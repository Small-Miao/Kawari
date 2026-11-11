use std::collections::BTreeMap;

use glam::{Quat, Vec3};
use kawari::{
    common::{HouseId, HouseUnit, Position, internal_housing_row},
    config::get_config,
    ipc::zone::{Furniture, HouseExterior, HousingInteriorDetails, PlotSize},
};
use serde::{Deserialize, Serialize};

use crate::{GameData, inventory::HousingInventory};

pub const WARDS: u8 = 30;
pub const PLOTS: u8 = 60;
pub const PLOTS_PER_DIVISION: u8 = 30;
pub const SIGNBOARD_EVENT: u32 = 0x000B0087;
pub const BUILD_ESTATE_EVENT: u32 = 0x000B0095;
pub const ENTER_ESTATE_EVENT: u32 = 0x0002004C;
const INTERIOR_TERRITORIES: [(u16, u16); 5] =
    [(339, 282), (340, 342), (418, 345), (641, 649), (979, 980)];

pub fn interior_furniture_slots(size: PlotSize) -> usize {
    match size {
        PlotSize::Small => 300,
        PlotSize::Medium => 450,
        PlotSize::Large => 600,
    }
}

pub fn yard_furniture_slots(size: PlotSize) -> usize {
    match size {
        PlotSize::Small => 40,
        PlotSize::Medium => 60,
        PlotSize::Large => 80,
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct HousingAddress {
    pub district: u16,
    pub ward: u8,
    pub plot: Option<u8>,
}

#[derive(Clone, Copy, Debug)]
pub struct PlotBounds {
    pub center: Vec3,
    pub half_extent: Vec3,
    pub rotation: f32,
}

impl PlotBounds {
    pub fn contains(self, position: Position) -> bool {
        let local = Quat::from_rotation_y(-self.rotation) * (position.0 - self.center);
        let extent = self.half_extent.abs() + Vec3::splat(0.5);
        local.abs().cmple(extent).all()
    }
}

impl HousingAddress {
    pub fn ward(district: u16, ward: u8) -> Option<Self> {
        internal_housing_row(district)?;
        (ward < WARDS).then_some(Self {
            district,
            ward,
            plot: None,
        })
    }

    pub fn with_plot(self, plot: u8) -> Option<Self> {
        (plot < PLOTS).then_some(Self {
            plot: Some(plot),
            ..self
        })
    }

    pub fn outdoor(self) -> Self {
        Self { plot: None, ..self }
    }

    pub fn pack(self) -> i32 {
        (i32::from(self.district) << 16)
            | (i32::from(self.ward) << 8)
            | self.plot.map_or(0, |plot| i32::from(plot) + 1)
    }

    pub fn unpack(value: i32) -> Option<Self> {
        let ward = Self::ward(u16::try_from(value >> 16).ok()?, (value >> 8) as u8)?;
        match value as u8 {
            0 => Some(ward),
            plot => ward.with_plot(plot - 1),
        }
    }

    pub fn id(self) -> HouseId {
        HouseId {
            unit: HouseUnit {
                apartment_division_plot_index: self.plot.unwrap_or(127),
                apartment_flag: false,
            },
            unk1: if self.plot.is_some() { 0 } else { 255 },
            ward_index: self.ward,
            room_number: 0,
            territory_type_id: self.district,
            world_id: get_config().world.world_id,
        }
    }

    pub fn interior(self, size: PlotSize) -> u16 {
        let (_, first) = INTERIOR_TERRITORIES
            .iter()
            .find(|(district, _)| *district == self.district)
            .expect("已校验住宅区");
        first + size as u16
    }

    pub fn legacy_ward(territory: u16) -> Option<Self> {
        let (district, _) = INTERIOR_TERRITORIES
            .iter()
            .find(|(_, first)| (*first..=*first + 2).contains(&territory))?;
        Self::ward(*district, 0)
    }
}

#[derive(Deserialize, Serialize, Default)]
#[serde(default)]
pub struct EstateState {
    pub inventory: HousingInventory,
    pub transforms: BTreeMap<u16, [f32; 4]>,
    pub yard_transforms: BTreeMap<u16, [f32; 4]>,
    pub light: u8,
}

impl EstateState {
    pub fn furniture(&self, gamedata: &mut GameData, yard: bool) -> Vec<Furniture> {
        let mut furniture = Vec::new();
        let transforms = if yard {
            &self.yard_transforms
        } else {
            &self.transforms
        };
        for (&index, &[x, y, z, rotation]) in transforms {
            let Some((container, slot)) = furniture_slot(index, yard) else {
                continue;
            };
            let Some(item) = self.inventory.get_item(container, slot) else {
                continue;
            };
            let Some(id) = gamedata.get_estate_furniture_catalog_id(item.item_id, yard) else {
                continue;
            };
            furniture.resize(
                furniture.len().max(usize::from(index) + 1),
                Furniture::default(),
            );
            furniture[usize::from(index)] = Furniture {
                id: id + 1,
                stain: item.stains[0],
                rotation,
                position: Position(glam::Vec3::new(x, y, z)),
                ..Default::default()
            };
        }
        furniture
    }

    pub fn furniture_transforms(&mut self, yard: bool) -> &mut BTreeMap<u16, [f32; 4]> {
        if yard {
            &mut self.yard_transforms
        } else {
            &mut self.transforms
        }
    }
}

pub const INTERIOR_PLACED: [kawari::common::ContainerType; 12] = {
    use kawari::common::ContainerType::*;
    [
        HousingInteriorPlacedItems1,
        HousingInteriorPlacedItems2,
        HousingInteriorPlacedItems3,
        HousingInteriorPlacedItems4,
        HousingInteriorPlacedItems5,
        HousingInteriorPlacedItems6,
        HousingInteriorPlacedItems7,
        HousingInteriorPlacedItems8,
        HousingInteriorPlacedItems9,
        HousingInteriorPlacedItems10,
        HousingInteriorPlacedItems11,
        HousingInteriorPlacedItems12,
    ]
};

pub const INTERIOR_STOREROOM: [kawari::common::ContainerType; 12] = {
    use kawari::common::ContainerType::*;
    [
        HousingInteriorStoreroom1,
        HousingInteriorStoreroom2,
        HousingInteriorStoreroom3,
        HousingInteriorStoreroom4,
        HousingInteriorStoreroom5,
        HousingInteriorStoreroom6,
        HousingInteriorStoreroom7,
        HousingInteriorStoreroom8,
        HousingInteriorStoreroom9,
        HousingInteriorStoreroom10,
        HousingInteriorStoreroom11,
        HousingInteriorStoreroom12,
    ]
};

pub const YARD_PLACED: [kawari::common::ContainerType; 2] = [
    kawari::common::ContainerType::HousingExteriorPlacedItems,
    kawari::common::ContainerType::HousingExteriorPlacedItems2,
];

pub const YARD_STOREROOM: [kawari::common::ContainerType; 2] = [
    kawari::common::ContainerType::HousingExteriorStoreroom,
    kawari::common::ContainerType::HousingExteriorStoreroom2,
];

pub fn furniture_containers(
    yard: bool,
    storeroom: bool,
) -> &'static [kawari::common::ContainerType] {
    match (yard, storeroom) {
        (true, false) => &YARD_PLACED,
        (true, true) => &YARD_STOREROOM,
        (false, false) => &INTERIOR_PLACED,
        (false, true) => &INTERIOR_STOREROOM,
    }
}

pub fn furniture_slot(index: u16, yard: bool) -> Option<(kawari::common::ContainerType, u16)> {
    let page = usize::from(index / 50);
    Some((*furniture_containers(yard, false).get(page)?, index % 50))
}

pub fn furniture_index(
    container: kawari::common::ContainerType,
    slot: u16,
    yard: bool,
) -> Option<u16> {
    let page = furniture_containers(yard, false)
        .iter()
        .position(|&kind| kind == container)?;
    (slot < 50).then_some(page as u16 * 50 + slot)
}

pub struct EstatePreset {
    pub exterior: HouseExterior,
    pub interior: HousingInteriorDetails,
}
