use std::io::Cursor;

use binrw::{BinRead, BinWrite};
use diesel::{
    backend::Backend,
    deserialize::{self, FromSqlRow},
    expression::AsExpression,
    serialize,
    sql_types::Text,
    sqlite::Sqlite,
};
use kawari::ipc::zone::PlateDesign;
use kawari::ipc::zone::PortraitBanner;
use serde::{Deserialize, Serialize};

/// The size in bytes of the serialized adventurer plate design block
/// (`PlateDesign`, i.e. the `version`..`timestamp` span of the plate packet).
const PLATE_DESIGN_SIZE: usize = 192;

/// The size in bytes of the serialized gearset portrait banner block ([`PortraitBanner`]).
const PLATE_BANNER_SIZE: usize = 52;

/// Persistent adventurer plate (CharaCard) data.
///
/// The client submits the entire editable "design block" as a frozen snapshot (see
/// [`PlateDesign`]), so we persist the whole block verbatim rather than a subset of style
/// fields. The block includes a snapshot of the character's customize (face) data, gear dye
/// stains, and equipped item ids taken at save time — this is intentional and matches retail.
///
/// The design block is stored as its raw wire bytes because [`PlateDesign`] contains
/// `CustomizeData`, which is a `binrw` type without `serde` support.
#[derive(Debug, Clone, Serialize, Deserialize, AsExpression, FromSqlRow)]
#[diesel(sql_type = Text)]
pub struct PlateStorage {
    /// Whether the character has ever saved a plate. `false` means the player should be told the
    /// plate is "not set" (LogMessage 5856) rather than shown the default design.
    pub has_plate: bool,
    /// The raw wire bytes of the [`PlateDesign`] block (192 bytes).
    pub design: Vec<u8>,
    /// Whether the character has a valid gearset portrait banner set.
    #[serde(default)]
    pub has_banner: bool,
    /// The raw wire bytes of the [`PortraitBanner`] block (52 bytes).
    #[serde(default)]
    pub banner: Vec<u8>,
}

impl Default for PlateStorage {
    fn default() -> Self {
        Self {
            has_plate: false,
            design: Self::design_to_bytes(&PlateDesign::default()),
            has_banner: false,
            banner: Self::banner_to_bytes(&PortraitBanner::default()),
        }
    }
}

impl PlateStorage {
    /// Serializes a [`PlateDesign`] to its 192-byte wire form.
    fn design_to_bytes(design: &PlateDesign) -> Vec<u8> {
        let mut buffer = Vec::with_capacity(PLATE_DESIGN_SIZE);
        let mut cursor = Cursor::new(&mut buffer);
        design
            .write_le(&mut cursor)
            .expect("failed to serialize PlateDesign");
        buffer
    }

    /// Decodes the stored design block into a [`PlateDesign`]. Returns the default design if the
    /// stored bytes are missing or malformed.
    pub fn design(&self) -> PlateDesign {
        let mut cursor = Cursor::new(&self.design);
        PlateDesign::read_le(&mut cursor).unwrap_or_default()
    }

    /// Stores a submitted design block and marks the plate as set.
    ///
    /// The `unk14` byte is a transient client-side dirty marker (observed as `0xF6` in the
    /// submit packet but reset to `0` in the persisted plate), so it is not stored.
    pub fn set_design(&mut self, mut design: PlateDesign) {
        design.unk14 = 0;
        self.design = Self::design_to_bytes(&design);
        self.has_plate = true;
    }

    /// Marks the plate's portrait as invalidated by a Fantasia (character re-customization).
    /// Sets `flags & 1` (`WasResetDueToFantasia`) on the stored design without otherwise
    /// clearing the plate. No-op if the character has no plate.
    pub fn mark_reset_by_fantasia(&mut self) {
        if !self.has_plate {
            return;
        }
        let mut design = self.design();
        design.flags |= 1;
        self.design = Self::design_to_bytes(&design);
    }

    /// Serializes a [`PortraitBanner`] to its 52-byte wire form.
    fn banner_to_bytes(banner: &PortraitBanner) -> Vec<u8> {
        let mut buffer = Vec::with_capacity(PLATE_BANNER_SIZE);
        let mut cursor = Cursor::new(&mut buffer);
        banner
            .write_le(&mut cursor)
            .expect("failed to serialize PortraitBanner");
        buffer
    }

    /// Decodes the stored banner block into a [`PortraitBanner`]. Returns the default banner if
    /// the stored bytes are missing or malformed.
    pub fn banner(&self) -> PortraitBanner {
        let mut cursor = Cursor::new(&self.banner);
        PortraitBanner::read_le(&mut cursor).unwrap_or_default()
    }

    /// Stores a submitted banner block and marks the banner as set.
    pub fn set_banner(&mut self, banner: PortraitBanner) {
        self.banner = Self::banner_to_bytes(&banner);
        self.has_banner = true;
    }

    /// Marks the banner as unset without discarding the stored bytes. Called when equipping a
    /// gearset that has no valid linked portrait.
    pub fn clear_banner(&mut self) {
        self.has_banner = false;
    }
}

impl serialize::ToSql<Text, Sqlite> for PlateStorage {
    fn to_sql<'b>(&'b self, out: &mut serialize::Output<'b, '_, Sqlite>) -> serialize::Result {
        out.set_value(serde_json::to_string(&self).unwrap());
        Ok(serialize::IsNull::No)
    }
}

impl deserialize::FromSql<Text, Sqlite> for PlateStorage {
    fn from_sql(mut bytes: <Sqlite as Backend>::RawValue<'_>) -> deserialize::Result<Self> {
        Ok(serde_json::from_str(bytes.read_text())
            .ok()
            .unwrap_or_default())
    }
}
