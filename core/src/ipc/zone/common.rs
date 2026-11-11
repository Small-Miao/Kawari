use std::io::Read;

use binrw::binrw;
use bitflags::bitflags;
use strum::FromRepr;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct StrategyBoardShare {
    pub index: u8,
    pub realtime: bool,
    pub refresh: bool,
}

#[binrw]
#[brw(little)]
#[derive(Clone, Debug, Default, Eq, PartialEq)]
pub struct StrategyBoard {
    /// Checksum, packed board, names and folder position after the packet's content ID.
    #[br(count = 1176)]
    #[bw(pad_size_to = 1176)]
    data: Vec<u8>,
}

impl StrategyBoard {
    pub fn validate_share(&self) -> Option<StrategyBoardShare> {
        let packed = self.data.get(8..1048)?;
        let checksum = u32::from_le_bytes(self.data[..4].try_into().ok()?);
        let size = usize::from(u16::from_le_bytes(packed[..2].try_into().ok()?));
        let index = (*self.data.get(1168)?).max(1);
        let total = *self.data.get(1169)?;
        if !(1..=10).contains(&total)
            || index > total
            || !(3..=0x820).contains(&size)
            || crc32fast::hash(packed) != checksum
        {
            return None;
        }

        let mut unpacked = Vec::with_capacity(size);
        flate2::read::ZlibDecoder::new(&packed[3..])
            .take((size + 1) as u64)
            .read_to_end(&mut unpacked)
            .ok()?;
        if unpacked.len() != size || unpacked[1] > 75 || unpacked[2] > 8 {
            return None;
        }
        let text_start = 3 + usize::from(unpacked[1]) * 17;
        let text_end = text_start + usize::from(unpacked[2]);
        let text_size: usize = unpacked
            .get(text_start..text_end)?
            .iter()
            .map(|len| usize::from(*len))
            .sum();
        if unpacked[2] != 0 && text_end + text_size >= size {
            return None;
        }

        Some(StrategyBoardShare {
            index,
            realtime: packed[2] & 1 != 0,
            refresh: packed[2] & 2 != 0,
        })
    }
}

#[binrw]
#[brw(little)]
#[derive(Clone, Debug, Default, Eq, PartialEq)]
pub struct StrategyBoardUpdate {
    /// Client operation and payload; preserve the original bytes when relaying.
    #[br(count = 64)]
    #[bw(pad_size_to = 64)]
    data: Vec<u8>,
}

impl StrategyBoardUpdate {
    pub fn has_valid_checksum(&self) -> bool {
        self.data.len() == 64
            && self.data[..4] == crc32fast::hash(&self.data[8..]).to_le_bytes()
    }
}

/// Represents housing appeal tags that players can set for their owned housing.
#[binrw]
#[brw(repr = u8)]
#[derive(Clone, Debug, Default)]
pub enum HousingAppealTag {
    #[default]
    None = 0,
    Emporium = 1,
    Boutique = 2,
    DesignerHome = 3,
    MessageBook = 4,
    Tavern = 5,
    Eatery = 6,
    ImmersiveExperience = 7,
    Cafe = 8,
    Aquarium = 9,
    Sanctum = 10,
    Venue = 11,
    Florist = 12,
    Unknown = 13, // blank in the sheet...
    Library = 14,
    PhotoStudio = 15,
    HauntedHouse = 16,
    Atelier = 17,
    Bathhouse = 18,
    Garden = 19,
    FarEastern = 20,
    VisitorsWelcome = 21,
    Bakery = 22,
    UnderRenovation = 23,
    ConcertHall = 24,
}

/// Represents the size of a housing plot.
#[binrw]
#[repr(u8)]
#[brw(repr = u8)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, FromRepr)]
pub enum PlotSize {
    /// Small housing plot.
    #[default]
    Small = 0,
    /// Medium housing plot.
    Medium = 1,
    /// Large housing plot.
    Large = 2,
}

/// Represents the purchase system used for a plot.
/// FCFS hasn't been used since the addition of Empyreum in 6.0.
#[binrw]
#[brw(repr = u8)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum PurchaseType {
    #[default]
    Unavailable = 0,

    /// First come, First served
    FCFS = 1,

    Lottery = 2,
}

/// Represents the allowed type of tenant for a specific plot or entire ward.
#[binrw]
#[brw(repr = u8)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum TenantType {
    #[default]
    Any = 0,

    FreeCompany = 1,

    Personal = 2,
}

/// Represents the availability of a specific plot during the *current* lottery cycle/
#[binrw]
#[brw(repr = u8)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum AvailabilityType {
    /// Plot does not participate in current lottery cycle.
    #[default]
    Unavailable = 3,

    /// Plot is available for bidding.
    Available = 1,

    /// Plot participated in lottery cycle, no more bidding allowed.
    InResultsPeriod = 2,
}

#[binrw]
#[derive(Clone, Copy, Debug, PartialEq, Eq, Default)]
pub struct HousingFlags(u8);

bitflags! {
    impl HousingFlags: u8 {
        const PLOT_OWNED = 1 << 0;
        const VISITORS_ALLOWED = 1 << 1;
        const HAS_SEARCH_COMMENT = 1 << 2;
        const HOUSE_BUILT = 1 << 3;
        const OWNED_BY_FC = 1 << 4;
    }
}
