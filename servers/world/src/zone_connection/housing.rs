use kawari::{
    common::{
        ContainerType, HandlerId, HouseId, LandData, ObjectId, ObjectTypeId, Position,
        internal_housing_row,
    },
    ipc::zone::{
        ActorControlCategory, AvailabilityType, Condition, EventStart, EventType, Furniture,
        FurnitureList, House,
        HouseList, HouseStatus, HousingFlags, HousingOccupiedLandInfo, HousingVacantLandInfo,
        HousingWardInfo, HousingWardSummaryItem, ItemInfo, PlotSize, PurchaseType,
        ServerZoneIpcData, ServerZoneIpcSegment, TenantType,
    },
};

use crate::{
    ToServer, ZoneConnection,
    database::Estate,
    housing::{
        ENTER_ESTATE_EVENT, EstateState, HousingAddress, PLOTS_PER_DIVISION, furniture_containers,
        furniture_index, furniture_slot, interior_furniture_slots, yard_furniture_slots,
    },
    inventory::{Inventory, Item, MAX_LARGE_STORAGE},
    lua::LuaZone,
};

impl ZoneConnection {
    pub fn housing_address(&self) -> Option<HousingAddress> {
        HousingAddress::unpack(self.player_data.volatile.housing_location)
    }

    pub fn resume_housing(&mut self) -> Option<HousingAddress> {
        let Some(address) = self.housing_address() else {
            let ward = HousingAddress::legacy_ward(self.player_data.volatile.zone_id as u16)?;
            self.player_data.volatile.zone_id = i32::from(ward.district);
            self.player_data.volatile.position = Position::default();
            return Some(ward);
        };
        if address.plot.is_none() {
            return (self.player_data.volatile.zone_id == i32::from(address.district))
                .then_some(address);
        }
        if let Some(estate) = self.read_estate(address)
            && estate.permit_id != 0
            && (estate.owner_id == self.player_data.character.content_id || estate.visitors_allowed)
            && self.plot_size(address).is_some_and(|size| {
                i32::from(address.interior(size)) == self.player_data.volatile.zone_id
            })
        {
            return Some(address);
        }
        self.player_data.volatile.zone_id = i32::from(address.district);
        self.player_data.volatile.position = Position::default();
        Some(address.outdoor())
    }

    fn read_estate(&self, address: HousingAddress) -> Option<Estate> {
        self.database
            .lock()
            .estate(address)
            .inspect_err(|error| tracing::error!(%error, ?address, "读取住宅失败"))
            .ok()
            .flatten()
    }

    fn owned_estate(&self) -> Option<Estate> {
        self.database
            .lock()
            .owned_estate(self.player_data.character.content_id)
            .inspect_err(|error| tracing::error!(%error, "读取个人住宅失败"))
            .ok()
            .flatten()
    }

    fn plot_size(&self, address: HousingAddress) -> Option<PlotSize> {
        self.gamedata.lock().get_land_set_size(
            internal_housing_row(address.district)?,
            usize::from(address.plot?),
        )
    }

    fn plot_price(&self, address: HousingAddress) -> Option<u32> {
        let plots = self
            .gamedata
            .lock()
            .get_land_sets(internal_housing_row(address.district)?)?;
        let price = plots.get(usize::from(address.plot?))?.InitialPrice;
        (price != 0).then_some(price)
    }

    fn plot_nearby(&self, zone: &LuaZone, plot: u8) -> bool {
        self.housing_position_nearby(zone.housing_plot_positions.get(&plot))
    }

    fn housing_position_nearby(&self, position: Option<&Position>) -> bool {
        self.spawned_in
            && self.zone_in_confirmed
            && position.is_some_and(|position| {
                position
                    .0
                    .distance_squared(self.player_data.volatile.position.0)
                    <= 18.0_f32.powi(2)
            })
    }

    pub async fn send_owned_estate(&mut self) {
        let private = self
            .owned_estate()
            .map(|estate| LandData {
                id: estate.address().id(),
                flags: if estate.permit_id != 0 { 19 } else { 1 },
                ..Default::default()
            })
            .unwrap_or_default();
        self.send_ipc_self(ServerZoneIpcSegment::new(ServerZoneIpcData::OwnedHousing {
            free_company: LandData::default(),
            personal: private,
            personal_chambers: LandData::default(),
            shared_estate_1: LandData::default(),
            shared_estate_2: LandData::default(),
            apartment: LandData::default(),
        }))
        .await;
    }

    pub async fn send_ward_info(&mut self, district: u32, ward: u32) {
        let Some(address) = u16::try_from(district)
            .ok()
            .zip(u8::try_from(ward).ok())
            .and_then(|(district, ward)| HousingAddress::ward(district, ward))
        else {
            return;
        };
        let Some(plots) = internal_housing_row(address.district)
            .and_then(|row| self.gamedata.lock().get_land_sets(row))
        else {
            return;
        };
        let mut summaries: Vec<_> = plots
            .iter()
            .map(|plot| HousingWardSummaryItem {
                plot_price: plot.InitialPrice,
                ..Default::default()
            })
            .collect();
        let estates = self.database.lock().ward_estates(address);
        let Ok(estates) =
            estates.inspect_err(|error| tracing::error!(%error, ?address, "读取住宅区失败"))
        else {
            return;
        };
        for (estate, name) in estates {
            if let Some(summary) = summaries.get_mut(estate.plot as usize) {
                summary.name = fit_name(&name, 31);
                summary.flags = HousingFlags::PLOT_OWNED;
                summary
                    .flags
                    .set(HousingFlags::HOUSE_BUILT, estate.permit_id != 0);
                summary
                    .flags
                    .set(HousingFlags::VISITORS_ALLOWED, estate.visitors_allowed);
            }
        }
        self.send_ipc_self(ServerZoneIpcSegment::new(
            ServerZoneIpcData::HousingWardInfo(HousingWardInfo {
                id: address.id(),
                house_summaries: summaries,
                purchase_type: PurchaseType::FCFS,
                tenant_type: TenantType::Personal,
                ..Default::default()
            }),
        ))
        .await;
    }

    pub async fn send_housing_placard(&mut self, district: u32, packed: u32) {
        let Some(address) = u16::try_from(district)
            .ok()
            .zip(u8::try_from(packed >> 8).ok())
            .and_then(|(district, ward)| HousingAddress::ward(district, ward))
            .and_then(|ward| ward.with_plot(packed as u8))
        else {
            return;
        };
        if let Some(price) = self.send_housing_placard_info(address).await {
            self.send_ipc_self(ServerZoneIpcSegment::new(
                ServerZoneIpcData::HousingLandPrice {
                    price,
                    seconds_until_reduction: 0,
                },
            ))
            .await;
        }
    }

    async fn send_housing_placard_info(&mut self, address: HousingAddress) -> Option<u32> {
        let size = self.plot_size(address)?;
        let estates = self.database.lock().ward_estates(address);
        let estates = estates
            .inspect_err(|error| tracing::error!(%error, ?address, "读取住宅告示牌失败"))
            .ok()?;
        let (data, price) = if let Some((estate, owner_name)) = estates
            .into_iter()
            .find(|(estate, _)| estate.address() == address)
        {
            let data = ServerZoneIpcData::HousingOccupiedLandInfo(HousingOccupiedLandInfo {
                id: address.id(),
                owner_id: estate.owner_id as u64,
                house_icon: if estate.permit_id == 0 {
                    2
                } else {
                    u8::from(estate.visitors_allowed)
                },
                house_size: size,
                unk2: 2,
                estate_name: if estate.estate_name.is_empty() {
                    format!("{}号地", estate.plot + 1)
                } else {
                    fit_name(&estate.estate_name, 20)
                },
                owner_name: fit_name(&owner_name, 30),
                ..Default::default()
            });
            (data, None)
        } else {
            let price = self.plot_price(address);
            let mut unknown = [0; 20];
            unknown[12..].fill(0xFF);
            let data = ServerZoneIpcData::HousingVacantLandInfo(HousingVacantLandInfo {
                purchase_type: if price.is_some() {
                    PurchaseType::FCFS
                } else {
                    PurchaseType::Unavailable
                },
                tenant_type: TenantType::Personal,
                availability_type: if price.is_some() {
                    AvailabilityType::Available
                } else {
                    AvailabilityType::Unavailable
                },
                unk4: unknown,
                ..Default::default()
            });
            (data, price)
        };
        self.send_ipc_self(ServerZoneIpcSegment::new(data)).await;
        price
    }

    pub async fn housing_signboard(&mut self, zone: &LuaZone, actor: ObjectId) -> Option<u32> {
        let address = zone.housing.filter(|address| address.plot.is_none())?;
        let &(plot, layout_id) = zone.housing_placards.get(&actor)?;
        if !self.plot_nearby(zone, plot) {
            return None;
        }
        self.send_housing_placard_info(address.with_plot(plot)?).await;
        Some(layout_id)
    }

    pub async fn buy_from_signboard(&mut self, zone: &LuaZone, actor: ObjectId) {
        if let Some(&(plot, _)) = zone.housing_placards.get(&actor) {
            self.buy_plot(zone, plot).await;
        }
    }

    pub async fn refresh_housing(&mut self, zone: &LuaZone) {
        let Some(address) = zone.housing else { return };
        if address.plot.is_some() {
            self.send_estate_interior(address).await;
        } else {
            self.send_housing_exterior(zone, address).await;
        }
    }

    async fn send_housing_exterior(&mut self, zone: &LuaZone, address: HousingAddress) {
        let estates = self.database.lock().ward_estates(address);
        let Ok(estates) =
            estates.inspect_err(|error| tracing::error!(%error, ?address, "读取住宅外观失败"))
        else {
            return;
        };
        let division = housing_division(zone, self.player_data.volatile.position);
        let first = usize::from(division * PLOTS_PER_DIVISION);
        let mut houses = [House::default(); PLOTS_PER_DIVISION as usize];
        // 每个分区连续分配 1460 个庭院槽位，末尾两个槽位留给公寓。
        let mut yard = vec![Furniture::default(); 1462];
        {
            let mut data = self.gamedata.lock();
            let Some(plots) =
                internal_housing_row(address.district).and_then(|row| data.get_land_sets(row))
            else {
                return;
            };
            for (index, house) in houses.iter_mut().enumerate() {
                if let Some(size) = plots
                    .get(first + index)
                    .and_then(|plot| PlotSize::from_repr(plot.PlotSize))
                {
                    house.plot_size = size;
                }
            }
            let mut offsets = [0; PLOTS_PER_DIVISION as usize];
            let mut next = 0;
            for (offset, house) in offsets.iter_mut().zip(&houses) {
                *offset = next;
                next += yard_furniture_slots(house.plot_size);
            }
            for (estate, _) in estates {
                let Some(index) = (estate.plot as usize).checked_sub(first) else {
                    continue;
                };
                let Some(house) = houses.get_mut(index) else {
                    continue;
                };
                house.status = HouseStatus::UnderConstruction;
                if estate.permit_id != 0
                    && let Some(preset) = data.get_housing_preset(
                        estate.permit_id as u32,
                        house.plot_size,
                        address.district,
                    )
                {
                    house.status = HouseStatus::HouseBuilt;
                    house.exterior = preset.exterior;
                    house
                        .flags
                        .set(kawari::common::HousingFlag::OPEN, estate.visitors_allowed);
                    if let Ok(state) = estate
                        .state()
                        .inspect_err(|error| tracing::error!(%error, "读取庭院家具失败"))
                    {
                        let start = offsets[index];
                        let slots = yard_furniture_slots(house.plot_size);
                        let furniture = state.furniture(&mut data, true);
                        if let Some(destination) = yard.get_mut(start..start + slots) {
                            for (target, item) in destination.iter_mut().zip(furniture) {
                                *target = item;
                            }
                        }
                    }
                }
            }
        }
        self.send_ipc_self(ServerZoneIpcSegment::new(ServerZoneIpcData::HouseList(
            HouseList {
                land_id: u16::from(address.ward),
                ward: u16::from(address.ward),
                territory_type_id: address.district,
                world_id: address.id().world_id,
                subdivision: ((u32::from(division) + 1) << 8) | 1,
                houses,
            },
        )))
        .await;
        self.send_furniture_lists(address, &yard, true).await;
    }

    pub async fn update_housing_warp(&mut self, zone: &LuaZone, position: Position, rotation: f32) {
        let Some(address) = zone.housing.filter(|address| address.plot.is_none()) else {
            return;
        };
        let before = housing_division(zone, self.player_data.volatile.position);
        self.player_data.volatile.position = position;
        self.player_data.volatile.rotation = f64::from(rotation);
        if before != housing_division(zone, position) {
            self.send_housing_exterior(zone, address).await;
        }
    }

    async fn send_estate_interior(&mut self, address: HousingAddress) {
        let Some(estate) = self.read_estate(address) else {
            return;
        };
        let Some(size) = self.plot_size(address) else {
            return;
        };
        let Ok(state) = estate
            .state()
            .inspect_err(|error| tracing::error!(%error, ?address, "读取住宅家具失败"))
        else {
            return;
        };
        let (details, mut furniture) = {
            let mut data = self.gamedata.lock();
            let mut details = data
                .get_housing_preset(estate.permit_id as u32, size, address.district)
                .map_or_else(Default::default, |preset| preset.interior);
            details.light_level = state.light;
            (details, state.furniture(&mut data, false))
        };
        self.send_ipc_self(ServerZoneIpcSegment::new(
            ServerZoneIpcData::HousingInteriorDetails(details),
        ))
        .await;
        furniture.resize(interior_furniture_slots(size), Furniture::default());
        self.send_furniture_lists(address, &furniture, false).await;
    }

    async fn send_furniture_lists(
        &mut self,
        address: HousingAddress,
        furniture: &[Furniture],
        yard: bool,
    ) {
        let count = furniture.len().div_ceil(Furniture::COUNT);
        for (index, page) in furniture.chunks(Furniture::COUNT).enumerate() {
            self.send_ipc_self(ServerZoneIpcSegment::new(ServerZoneIpcData::FurnitureList(
                FurnitureList {
                    id: address.id(),
                    count: count as u8,
                    index: index as u8,
                    slot_count: if yard { 0 } else { page.len() as u8 },
                    furniture: page.to_vec(),
                    ..Default::default()
                },
            )))
            .await;
        }
    }

    async fn travel_housing(
        &mut self,
        address: HousingAddress,
        territory: u16,
        pop_range: Option<u32>,
        return_plot: Option<u8>,
    ) {
        self.teleport_reason = crate::TeleportReason::NotSpecified;
        self.zone_in_confirmed = false;
        self.handle
            .send(ToServer::HousingTravel(
                self.id,
                self.player_data.character.actor_id,
                address,
                territory,
                pop_range,
                return_plot,
            ))
            .await;
    }

    pub async fn enter_housing_ward(&mut self, territory: u16, ward: u8, pop_range: u32) {
        if let Some(address) = HousingAddress::ward(territory, ward) {
            self.travel_housing(address, territory, Some(pop_range), None)
                .await;
        }
    }

    pub async fn leave_estate(&mut self) {
        if let Some(address) = self
            .housing_address()
            .filter(|address| address.plot.is_some())
        {
            self.travel_housing(address.outdoor(), address.district, None, address.plot)
                .await;
        }
    }

    pub async fn move_to_estate_door(&mut self) {
        if self.spawned_in
            && self.zone_in_confirmed
            && let Some(address) = self
                .housing_address()
                .filter(|address| address.plot.is_some())
        {
            self.travel_housing(
                address,
                self.player_data.volatile.zone_id as u16,
                None,
                None,
            )
            .await;
        }
    }

    pub async fn enter_estate_from_door(&mut self, zone: &LuaZone, target: ObjectTypeId) {
        let handler_id = HandlerId(ENTER_ESTATE_EVENT);
        // 完成房门的交互握手，由切区封包控制淡出和加载。
        self.send_ipc_self(ServerZoneIpcSegment::new(ServerZoneIpcData::EventStart(
            EventStart {
                target_id: target,
                handler_id,
                event_type: EventType::Talk,
                ..Default::default()
            },
        )))
        .await;
        self.send_ipc_self(ServerZoneIpcSegment::new(ServerZoneIpcData::EventFinish {
            handler_id,
            event_type: EventType::Talk,
            result: 1,
            arg: 0,
        }))
        .await;

        let Some(&plot) = zone.housing_entrances.get(&target.object_id) else {
            self.send_notice("当前房门无法使用，请重新进入住宅区后再试。")
                .await;
            return;
        };
        self.enter_estate(zone, plot).await;
    }

    async fn enter_estate(&mut self, zone: &LuaZone, plot: u8) {
        let Some(address) = zone
            .housing
            .filter(|address| address.plot.is_none())
            .and_then(|ward| ward.with_plot(plot))
            .filter(|_| {
                self.housing_position_nearby(zone.housing_entrance_positions.get(&plot))
                    || self.plot_nearby(zone, plot)
            })
        else {
            self.send_notice("请在住宅入口附近操作。").await;
            return;
        };
        let Some(estate) = self
            .read_estate(address)
            .filter(|estate| estate.permit_id != 0)
        else {
            self.send_notice("该地块尚未建房。").await;
            return;
        };
        if estate.owner_id != self.player_data.character.content_id && !estate.visitors_allowed {
            self.send_notice("房主未开放访客进入。").await;
            return;
        }
        let Some(size) = self.plot_size(address) else {
            tracing::warn!(?address, "无法读取房屋地块尺寸");
            self.send_notice("无法加载这间房屋。").await;
            return;
        };
        let territory = address.interior(size);
        tracing::info!(?address, territory, "开始进入住宅室内");
        self.travel_housing(address, territory, None, None).await;
    }

    pub async fn housing_command(&mut self, command: &str, zone: &LuaZone) -> bool {
        let mut args = command.split_whitespace();
        if args.next() != Some("!housing") {
            return false;
        }
        let action = args.next();
        let value = args.next();
        if args.next().is_none() {
            match (action, value) {
                (Some("buy" | "enter"), Some(plot)) => {
                    if let Ok(plot @ 1..=60) = plot.parse::<u8>() {
                        if action == Some("buy") {
                            self.buy_plot(zone, plot - 1).await;
                        } else {
                            self.enter_estate(zone, plot - 1).await;
                        }
                        return true;
                    }
                }
                (Some("build"), Some(permit)) => {
                    if let Ok(permit) = permit.parse::<u32>() {
                        self.build_estate(zone, None, permit, "").await;
                        return true;
                    }
                }
                (Some("open" | "close"), None) => {
                    self.set_estate_access(zone, None, action == Some("open"))
                        .await;
                    return true;
                }
                (Some("leave"), None)
                    if self
                        .housing_address()
                        .is_some_and(|address| address.plot.is_some()) =>
                {
                    self.leave_estate().await;
                    return true;
                }
                _ => {}
            }
        }
        self.send_notice("住宅命令：!housing buy 地块号 / build 许可证物品ID / enter 地块号 / open / close / leave").await;
        true
    }

    async fn buy_plot(&mut self, zone: &LuaZone, plot: u8) {
        let Some(address) = zone
            .housing
            .filter(|address| address.plot.is_none())
            .and_then(|ward| ward.with_plot(plot))
            .filter(|_| self.plot_nearby(zone, plot))
        else {
            self.send_notice("请在当前住宅区的目标地块告示牌附近购买。")
                .await;
            return;
        };
        let Some(price) = self.plot_price(address) else {
            self.send_notice("此地块不可购买。").await;
            return;
        };
        let mut inventory = self.player_data.inventory.clone();
        let Some(balance) = inventory.currency.gil.quantity.checked_sub(price) else {
            self.send_notice(&format!("金币不足。该地块需要 {price} 金币。"))
                .await;
            return;
        };
        inventory.currency.gil.quantity = balance;
        let result = self.database.lock().buy_estate(
            address,
            self.player_data.character.content_id,
            &inventory,
        );
        match result {
            Ok(true) => {
                self.player_data.inventory = inventory;
                let gil = self.player_data.inventory.currency.gil;
                self.send_housing_slot(ContainerType::Currency, 0, gil)
                    .await;
                self.send_owned_estate().await;
                self.refresh_ward(zone).await;
                self.send_notice(&format!(
                    "已支付 {price} 金币，取得{}区{}号地。",
                    address.ward + 1,
                    plot + 1
                ))
                .await;
            }
            Ok(false) => {
                self.send_notice("地块已被购买，或此角色已经持有个人地块。")
                    .await
            }
            Err(error) => {
                tracing::error!(%error, ?address, "购买住宅事务失败");
                self.send_notice("购买失败，未扣除金币。").await;
            }
        }
    }

    fn building_site(
        &self,
        zone: &LuaZone,
        requested_plot: Option<u8>,
    ) -> Result<Estate, &'static str> {
        let estate = self.owned_estate().ok_or("此角色尚未持有个人地块。")?;
        let address = estate.address();
        if zone.housing != Some(address.outdoor())
            || !address
                .plot
                .is_some_and(|plot| self.plot_nearby(zone, plot))
            || requested_plot.is_some_and(|plot| address.plot != Some(plot))
        {
            return Err("请在自己的地块告示牌附近建房。");
        }
        if estate.permit_id != 0 {
            return Err("此地块已经建房。");
        }
        Ok(estate)
    }

    pub async fn prepare_housing_build(&mut self, zone: &LuaZone, plot_index: u32) {
        let result = u8::try_from(plot_index)
            .ok()
            .is_some_and(|plot| self.building_site(zone, Some(plot)).is_ok());
        self.actor_control_self(ActorControlCategory::HousingBuildSelect {
            plot_index,
            result: u32::from(!result),
        })
        .await;
    }

    pub async fn build_estate(
        &mut self,
        zone: &LuaZone,
        plot: Option<u8>,
        permit_id: u32,
        name: &str,
    ) -> bool {
        let estate = match self.building_site(zone, plot) {
            Ok(estate) => estate,
            Err(message) => {
                self.send_notice(message).await;
                return false;
            }
        };
        let address = estate.address();
        let Some(size) = self.plot_size(address) else {
            return false;
        };
        if self
            .gamedata
            .lock()
            .get_housing_preset(permit_id, size, address.district)
            .is_none()
        {
            self.send_notice("许可证无效，或尺寸、地区与地块不匹配。")
                .await;
            return false;
        }
        let mut inventory = self.player_data.inventory.clone();
        let Some((page, index, slot)) = inventory.pages.iter_mut().find_map(|page| {
            let (index, slot) = page
                .slots
                .iter_mut()
                .enumerate()
                .find(|(_, slot)| slot.item_id == permit_id && slot.quantity != 0)?;
            Some((page.kind, index as u16, slot))
        }) else {
            self.send_notice("随身背包中没有指定的建筑许可证。").await;
            return false;
        };
        consume_one(slot);
        let slot_after = *slot;
        let name: String = name
            .trim()
            .chars()
            .filter(|character| !character.is_control())
            .collect();
        let result = self.database.lock().build_estate(
            estate.owner_id,
            permit_id,
            &fit_name(&name, 20),
            &inventory,
        );
        match result {
            Ok(true) => {
                self.player_data.inventory = inventory;
                self.send_housing_slot(page, index, slot_after).await;
                self.send_owned_estate().await;
                self.refresh_ward(zone).await;
                self.send_notice("房屋已建成，已开放访客访问。").await;
                return true;
            }
            Ok(false) => self.send_notice("地块已建房，或所有权已发生变化。").await,
            Err(error) => {
                tracing::error!(%error, ?address, "建房事务失败");
                self.send_notice("建房失败，未消耗许可证。").await;
            }
        }
        false
    }

    pub async fn set_estate_access(&mut self, zone: &LuaZone, id: Option<(u32, u32)>, open: bool) {
        let Some(estate) = self.owned_estate().filter(|estate| estate.permit_id != 0) else {
            return;
        };
        let address = estate.address();
        if let Some((territory_world, plot_ward)) = id {
            let expected = address.id();
            let high = u32::from(expected.territory_type_id) | (u32::from(expected.world_id) << 16);
            let low = u32::from(expected.unit.apartment_division_plot_index)
                | (u32::from(expected.ward_index) << 16);
            if territory_world != high || plot_ward & 0xFFFF00FF != low {
                return;
            }
        }
        let result = self
            .database
            .lock()
            .set_estate_access(estate.owner_id, open);
        match result {
            Ok(true) => {
                if zone.housing == Some(address.outdoor()) {
                    self.refresh_ward(zone).await;
                }
                self.send_notice(if open {
                    "访客访问已开放。"
                } else {
                    "访客访问已关闭。"
                })
                .await;
            }
            Ok(false) => {}
            Err(error) => tracing::error!(%error, ?address, "更新住宅访问权限失败"),
        }
    }

    async fn refresh_ward(&mut self, zone: &LuaZone) {
        self.refresh_housing(zone).await;
        self.handle
            .send(ToServer::RefreshHousing(
                self.player_data.character.actor_id,
            ))
            .await;
    }

    fn editable_estate(&self, zone: &LuaZone) -> Option<(HousingAddress, EstateState, usize)> {
        if !self.spawned_in || !self.zone_in_confirmed {
            return None;
        }
        let current = zone.housing?;
        let estate = if current.plot.is_some() {
            self.read_estate(current)?
        } else {
            let estate = self.owned_estate()?;
            let address = estate.address();
            if address.outdoor() != current
                || !address
                    .plot
                    .and_then(|plot| zone.housing_plot_positions.get(&plot))
                    .is_some_and(|entrance| {
                        entrance
                            .0
                            .distance_squared(self.player_data.volatile.position.0)
                            <= 45.0_f32.powi(2)
                    })
            {
                return None;
            }
            estate
        };
        if estate.owner_id != self.player_data.character.content_id || estate.permit_id == 0 {
            return None;
        }
        let address = estate.address();
        let size = self.plot_size(address)?;
        let limit = if current.plot.is_none() {
            yard_furniture_slots(size)
        } else {
            interior_furniture_slots(size)
        };
        let state = estate
            .state()
            .inspect_err(|error| tracing::error!(%error, ?address, "读取住宅状态失败"))
            .ok()?;
        Some((address, state, limit))
    }

    fn save_furniture(&mut self, state: &EstateState, inventory: Option<Inventory>) -> bool {
        let result = self.database.lock().save_estate_state(
            self.player_data.character.content_id,
            state,
            inventory.as_ref(),
        );
        if let Err(error) = result {
            tracing::error!(%error, "住宅家具事务失败");
            return false;
        }
        if let Some(inventory) = inventory {
            self.player_data.inventory = inventory;
        }
        true
    }

    pub async fn set_housing_light(&mut self, zone: &LuaZone, light: u32) {
        if light > 4 || zone.housing.is_none_or(|address| address.plot.is_none()) {
            return;
        }
        let Some((_, mut state, _)) = self.editable_estate(zone) else {
            return;
        };
        state.light = light as u8;
        if self.save_furniture(&state, None) {
            self.actor_control_self(ActorControlCategory::InteriorLightLevel {
                unk1: 0,
                level: light,
                unk2: 1,
            })
            .await;
            self.broadcast_actor_control(ActorControlCategory::InteriorLightLevelForObserver {
                level: light,
                unk1: 1,
            })
            .await;
        }
    }

    pub async fn housing_furniture_menu(&mut self, zone: &LuaZone, closed: bool) {
        if closed {
            self.conditions
                .remove_condition(Condition::UsingHousingFunctions);
        } else if self.editable_estate(zone).is_some() {
            self.conditions
                .set_condition(Condition::UsingHousingFunctions);
            self.actor_control_self(ActorControlCategory::FurnitureMenu {})
                .await;
        } else {
            return;
        }
        self.send_conditions().await;
    }

    pub async fn housing_inventory(&mut self, zone: &LuaZone, storeroom: bool) {
        let Some((_, state, limit)) = self.editable_estate(zone) else {
            return;
        };
        let yard = zone.housing.is_some_and(|address| address.plot.is_none());
        for page in state
            .inventory
            .pages(yard, storeroom)
            .iter()
            .take(limit.div_ceil(MAX_LARGE_STORAGE))
        {
            self.send_container(page, page.kind).await;
        }
    }

    pub async fn preview_housing_furniture(
        &mut self,
        zone: &LuaZone,
        house: HouseId,
        kind: ContainerType,
        slot: u16,
    ) {
        let Some((address, state, _)) = self.editable_estate(zone) else {
            return;
        };
        let yard = zone.housing.is_some_and(|address| address.plot.is_none());
        if !matches_address(house, address) || !furniture_containers(yard, true).contains(&kind) {
            return;
        }
        let Some(item) = state.inventory.get_item(kind, slot) else {
            return;
        };
        let catalog_id = self
            .gamedata
            .lock()
            .get_estate_furniture_catalog_id(item.item_id, yard);
        let Some(catalog_id) = catalog_id else { return };
        let position = self.player_data.volatile.position;
        let data = if yard {
            ServerZoneIpcData::ExteriorFurniturePlaced {
                plot_index: 0xFF,
                slot: 0xFF,
                unk1: [0; 2],
                catalog_id,
                unk2: 0,
                stain: item.stains[0],
                unk3: [0; 3],
                rotation: 0.0,
                position,
                unk4: 0,
            }
        } else {
            ServerZoneIpcData::InteriorFurniturePlaced {
                storage_id: kind,
                slot,
                catalog_id,
                unk1: 1,
                stain: item.stains[0],
                unk2: [0; 3],
                rotation: 0.0,
                position,
                unk3: [0; 4],
            }
        };
        self.send_ipc_self(ServerZoneIpcSegment::new(data)).await;
    }

    pub async fn place_housing_furniture(
        &mut self,
        zone: &LuaZone,
        plot: u8,
        kind: ContainerType,
        slot: u16,
        position: Position,
        rotation: f32,
        place: bool,
    ) {
        let Some((address, mut state, limit)) = self.editable_estate(zone) else {
            return;
        };
        let yard = zone.housing.is_some_and(|address| address.plot.is_none());
        if yard && address.plot != Some(plot) && plot != 0xFF {
            return;
        }
        if place
            && (!self.valid_furniture_transform(position, rotation)
                || (yard && !yard_position(zone, address, position)))
        {
            return;
        }
        let personal = matches!(
            kind,
            ContainerType::Inventory0
                | ContainerType::Inventory1
                | ContainerType::Inventory2
                | ContainerType::Inventory3
        );
        if !personal && (!place || !furniture_containers(yard, true).contains(&kind)) {
            return;
        }
        let mut inventory = personal.then(|| self.player_data.inventory.clone());
        let source = if let Some(inventory) = inventory.as_mut() {
            inventory
                .pages
                .iter_mut()
                .find(|page| page.kind == kind)
                .and_then(|page| page.slots.get_mut(usize::from(slot)))
        } else {
            state.inventory.get_item_mut(kind, slot)
        };
        let Some(source) = source.filter(|item| !item.is_empty_slot()) else {
            return;
        };
        let catalog_id = self
            .gamedata
            .lock()
            .get_estate_furniture_catalog_id(source.item_id, yard);
        let Some(catalog_id) = catalog_id else { return };
        let item = Item {
            quantity: 1,
            ..*source
        };
        consume_one(source);
        let source_after = *source;
        let Some((destination, destination_slot)) = state.inventory.add(item, yard, !place, limit)
        else {
            self.send_notice("住宅家具容器已满。").await;
            return;
        };
        let index = place
            .then(|| furniture_index(destination, destination_slot, yard))
            .flatten();
        if let Some(index) = index {
            state
                .furniture_transforms(yard)
                .insert(index, [position.0.x, position.0.y, position.0.z, rotation]);
        }
        if !self.save_furniture(&state, inventory) {
            return;
        }
        self.send_housing_slot(kind, slot, source_after).await;
        self.send_housing_slot(destination, destination_slot, item)
            .await;
        if let Some(index) = index {
            self.handle
                .send(ToServer::PlaceFurniture(
                    self.player_data.character.actor_id,
                    destination,
                    if yard { index } else { destination_slot },
                    catalog_id,
                    item.stains[0],
                    position,
                    !yard,
                    rotation,
                    address.plot.unwrap_or_default(),
                ))
                .await;
        }
        self.actor_control_self(ActorControlCategory::FurniturePlacedAck {
            unk1: 0,
            unk2: 0,
            unk3: 0,
            unk4: 0,
        })
        .await;
    }

    pub async fn remove_housing_furniture(
        &mut self,
        zone: &LuaZone,
        house: HouseId,
        kind: ContainerType,
        slot: u16,
        storeroom: bool,
    ) {
        let Some((address, mut state, limit)) = self.editable_estate(zone) else {
            return;
        };
        let yard = zone.housing.is_some_and(|address| address.plot.is_none());
        let from_placed = furniture_containers(yard, false).contains(&kind);
        let from_storeroom = furniture_containers(yard, true).contains(&kind);
        if !matches_address(house, address) || !(from_placed || (from_storeroom && !storeroom)) {
            return;
        }
        let Some(item) = state.inventory.get_item(kind, slot) else {
            return;
        };
        let mut inventory = (!storeroom).then(|| self.player_data.inventory.clone());
        let destination = if let Some(inventory) = inventory.as_mut() {
            inventory
                .add_in_next_free_slot(item)
                .map(|info| (info.container, info.slot))
        } else {
            state.inventory.add(item, yard, true, limit)
        };
        let Some((destination, destination_slot)) = destination else {
            self.send_notice("目标背包或住宅仓库已满。").await;
            return;
        };
        *state
            .inventory
            .get_item_mut(kind, slot)
            .expect("已校验家具槽位") = Item::default();
        let placed = furniture_index(kind, slot, yard)
            .filter(|index| state.furniture_transforms(yard).remove(index).is_some());
        if !self.save_furniture(&state, inventory) {
            return;
        }
        self.send_housing_slot(kind, slot, Item::default()).await;
        self.send_housing_slot(destination, destination_slot, item)
            .await;
        if let Some(index) = placed {
            let category = if yard {
                ActorControlCategory::YardFurnitureRemoved {
                    index,
                    plot_index: u16::from(address.plot.unwrap_or_default()),
                }
            } else {
                ActorControlCategory::FurnitureRemovedToInventoryAck {
                    unk1: u32::from(index),
                    unk2: 0,
                    unk3: 0,
                    unk4: 0,
                }
            };
            self.actor_control_self(category).await;
            self.handle
                .send(ToServer::RefreshHousing(
                    self.player_data.character.actor_id,
                ))
                .await;
        }
    }

    pub async fn store_housing_furniture(
        &mut self,
        zone: &LuaZone,
        house: HouseId,
        kind: ContainerType,
        slot: u16,
    ) {
        if matches!(
            kind,
            ContainerType::Inventory0
                | ContainerType::Inventory1
                | ContainerType::Inventory2
                | ContainerType::Inventory3
        ) {
            let Some((address, _, _)) = self.editable_estate(zone) else {
                return;
            };
            if matches_address(house, address) {
                self.place_housing_furniture(
                    zone,
                    address.plot.unwrap_or_default(),
                    kind,
                    slot,
                    Position::default(),
                    0.0,
                    false,
                )
                .await;
            }
        } else {
            self.remove_housing_furniture(zone, house, kind, slot, true)
                .await;
        }
    }

    pub async fn translate_housing_furniture(
        &mut self,
        zone: &LuaZone,
        house: HouseId,
        index: u16,
        position: Position,
        rotation: f32,
    ) {
        let Some((address, mut state, _)) = self.editable_estate(zone) else {
            return;
        };
        let yard = zone.housing.is_some_and(|address| address.plot.is_none());
        if !matches_address(house, address)
            || !self.valid_furniture_transform(position, rotation)
            || (yard && !yard_position(zone, address, position))
        {
            return;
        }
        let Some((storage_id, slot)) = furniture_slot(index, yard) else {
            return;
        };
        let Some(transform) = state.furniture_transforms(yard).get_mut(&index) else {
            return;
        };
        *transform = [position.0.x, position.0.y, position.0.z, rotation];
        if !self.save_furniture(&state, None) {
            return;
        }
        self.handle
            .send(ToServer::TranslateFurniture(
                self.player_data.character.actor_id,
                (false, address.plot.unwrap_or_default()),
                index,
                position,
                rotation,
                !yard,
            ))
            .await;
        self.actor_control_self(ActorControlCategory::FurnitureTranslatedAck {
            storage_id,
            slot: u32::from(slot),
            plot_number: u16::from(address.plot.unwrap_or_default()),
        })
        .await;
    }

    fn valid_furniture_transform(&self, position: Position, rotation: f32) -> bool {
        position.0.is_finite()
            && rotation.is_finite()
            && position
                .0
                .distance_squared(self.player_data.volatile.position.0)
                < 75.0_f32.powi(2)
    }

    async fn send_housing_slot(&mut self, container: ContainerType, slot: u16, item: Item) {
        let sequence = self.player_data.item_sequence;
        self.player_data.item_sequence = sequence.wrapping_add(1);
        self.send_ipc_self(ServerZoneIpcSegment::new(
            ServerZoneIpcData::UpdateInventorySlot(ItemInfo {
                sequence,
                container,
                slot,
                ..item.into()
            }),
        ))
        .await;
    }
}

fn fit_name(name: &str, bytes: usize) -> String {
    name[..name.floor_char_boundary(bytes.min(name.len()))].to_owned()
}

fn housing_division(zone: &LuaZone, position: Position) -> u8 {
    zone.housing_plot_positions
        .iter()
        .min_by(|(_, left), (_, right)| {
            left.0
                .distance_squared(position.0)
                .total_cmp(&right.0.distance_squared(position.0))
        })
        .map_or(0, |(&plot, _)| plot / PLOTS_PER_DIVISION)
}

fn yard_position(zone: &LuaZone, address: HousingAddress, position: Position) -> bool {
    address
        .plot
        .and_then(|plot| zone.housing_plot_bounds.get(&plot))
        .is_some_and(|bounds| bounds.contains(position))
}

fn matches_address(id: HouseId, address: HousingAddress) -> bool {
    let expected = address.id();
    let (received_high, received_low) = house_words(id);
    let (expected_high, expected_low) = house_words(expected);
    // 房屋封包直接写入 HouseId，部分 ClientTrigger 先写高 32 位。
    (received_high == expected_high && received_low & 0xFFFF00FF == expected_low)
        || (received_low == expected_high && received_high & 0xFFFF00FF == expected_low)
}

fn house_words(id: HouseId) -> (u32, u32) {
    let high = u32::from(id.territory_type_id) | (u32::from(id.world_id) << 16);
    let unit =
        id.unit.apartment_division_plot_index | if id.unit.apartment_flag { 0x80 } else { 0 };
    let low = u32::from(unit)
        | (u32::from(id.unk1) << 8)
        | (u32::from(id.ward_index) << 16)
        | (u32::from(id.room_number) << 22);
    (high, low)
}

fn consume_one(item: &mut Item) {
    item.quantity -= 1;
    if item.quantity == 0 {
        *item = Item::default();
    }
}
