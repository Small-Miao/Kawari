use diesel::{OptionalExtension, SqliteConnection, prelude::*};

use crate::{
    housing::{EstateState, HousingAddress},
    inventory::Inventory,
};

use super::{
    WorldDatabase, models,
    schema::{character, housing_estate as estate},
};

#[derive(Queryable, Selectable, Debug)]
#[diesel(table_name = estate)]
pub struct Estate {
    pub district: i32,
    pub ward: i32,
    pub plot: i32,
    pub owner_id: i64,
    pub permit_id: i32,
    pub estate_name: String,
    pub visitors_allowed: bool,
    state: String,
}

impl Estate {
    pub fn address(&self) -> HousingAddress {
        HousingAddress::ward(self.district as u16, self.ward as u8)
            .and_then(|ward| ward.with_plot(self.plot as u8))
            .expect("住宅记录地址无效")
    }

    pub fn state(&self) -> serde_json::Result<EstateState> {
        serde_json::from_str(&self.state)
    }
}

fn save_inventory(
    conn: &mut SqliteConnection,
    owner_id: i64,
    inventory: &Inventory,
) -> QueryResult<()> {
    models::Inventory {
        content_id: owner_id,
        contents: inventory.clone(),
    }
    .save_changes::<models::Inventory>(conn)?;
    Ok(())
}

impl WorldDatabase {
    pub fn built_housing_plots(&mut self, address: HousingAddress) -> QueryResult<Vec<i32>> {
        estate::table
            .filter(estate::district.eq(i32::from(address.district)))
            .filter(estate::ward.eq(i32::from(address.ward)))
            .filter(estate::permit_id.ne(0))
            .select(estate::plot)
            .load(&mut self.connection)
    }

    pub fn ward_estates(&mut self, address: HousingAddress) -> QueryResult<Vec<(Estate, String)>> {
        estate::table
            .inner_join(character::table.on(character::content_id.eq(estate::owner_id)))
            .filter(estate::district.eq(i32::from(address.district)))
            .filter(estate::ward.eq(i32::from(address.ward)))
            .select((Estate::as_select(), character::name))
            .load(&mut self.connection)
    }

    pub fn estate(&mut self, address: HousingAddress) -> QueryResult<Option<Estate>> {
        estate::table
            .find((
                i32::from(address.district),
                i32::from(address.ward),
                i32::from(address.plot.expect("需要地块地址")),
            ))
            .select(Estate::as_select())
            .first(&mut self.connection)
            .optional()
    }

    pub fn owned_estate(&mut self, owner_id: i64) -> QueryResult<Option<Estate>> {
        estate::table
            .filter(estate::owner_id.eq(owner_id))
            .select(Estate::as_select())
            .first(&mut self.connection)
            .optional()
    }

    pub fn buy_estate(
        &mut self,
        address: HousingAddress,
        owner_id: i64,
        inventory: &Inventory,
    ) -> QueryResult<bool> {
        self.connection.immediate_transaction(|conn| {
            let inserted = diesel::insert_into(estate::table)
                .values((
                    estate::district.eq(i32::from(address.district)),
                    estate::ward.eq(i32::from(address.ward)),
                    estate::plot.eq(i32::from(address.plot.expect("需要地块地址"))),
                    estate::owner_id.eq(owner_id),
                ))
                .on_conflict_do_nothing()
                .execute(conn)?;
            if inserted == 0 {
                return Ok(false);
            }
            save_inventory(conn, owner_id, inventory)?;
            Ok(true)
        })
    }

    pub fn build_estate(
        &mut self,
        owner_id: i64,
        permit_id: u32,
        name: &str,
        inventory: &Inventory,
    ) -> QueryResult<bool> {
        self.connection.immediate_transaction(|conn| {
            let updated = diesel::update(
                estate::table
                    .filter(estate::owner_id.eq(owner_id))
                    .filter(estate::permit_id.eq(0)),
            )
            .set((
                estate::permit_id.eq(permit_id as i32),
                estate::estate_name.eq(name),
                estate::visitors_allowed.eq(true),
            ))
            .execute(conn)?;
            if updated == 0 {
                return Ok(false);
            }
            save_inventory(conn, owner_id, inventory)?;
            Ok(true)
        })
    }

    pub fn set_estate_access(&mut self, owner_id: i64, open: bool) -> QueryResult<bool> {
        Ok(diesel::update(
            estate::table
                .filter(estate::owner_id.eq(owner_id))
                .filter(estate::permit_id.ne(0)),
        )
        .set(estate::visitors_allowed.eq(open))
        .execute(&mut self.connection)?
            == 1)
    }

    pub fn save_estate_state(
        &mut self,
        owner_id: i64,
        state: &EstateState,
        inventory: Option<&Inventory>,
    ) -> QueryResult<()> {
        let state = serde_json::to_string(state)
            .map_err(|err| diesel::result::Error::SerializationError(Box::new(err)))?;
        self.connection.immediate_transaction(|conn| {
            let updated = diesel::update(
                estate::table
                    .filter(estate::owner_id.eq(owner_id))
                    .filter(estate::permit_id.ne(0)),
            )
            .set(estate::state.eq(&state))
            .execute(conn)?;
            if updated != 1 {
                return Err(diesel::result::Error::NotFound);
            }
            if let Some(inventory) = inventory {
                save_inventory(conn, owner_id, inventory)?;
            }
            Ok(())
        })
    }
}
