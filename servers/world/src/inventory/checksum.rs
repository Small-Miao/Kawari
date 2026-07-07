use kawari::common::EquipDisplayFlag;
use physis::equipment::EquipSlot;
use strum::IntoEnumIterator;

use super::{EquippedStorage, Storage};

/// Standard CRC-32/ISO-HDLC (zlib crc32): reflected poly 0xEDB88320,
/// init 0xFFFFFFFF, refin/refout true, final XOR 0xFFFFFFFF.
fn crc32(data: &[u8]) -> u32 {
    let mut crc: u32 = 0xFFFF_FFFF;
    for &byte in data {
        crc ^= byte as u32;
        for _ in 0..8 {
            let mask = (crc & 1).wrapping_neg();
            crc = (crc >> 1) ^ (0xEDB8_8320 & mask);
        }
    }
    !crc
}

/// Computes the gearset portrait fingerprint checksum, byte-exact with the client's
/// `GenerateChecksum`. `item_ids`/`stains` are indexed by equip-slot repr (0=MainHand ..
/// 5=Waist .. 13=SoulCrystal). Slot 5 (waist) is always excluded; slot 2 (head) is
/// excluded when `flag & 1` is set.
pub fn gearset_checksum(
    item_ids: &[u32; 14],
    stains: &[[u8; 2]; 14],
    glasses: &[u16; 2],
    flag: u32,
) -> u32 {
    let mut buf = [0u8; 92];
    let mut off = 0usize;
    for i in 0..14 {
        if i == 5 || (i == 2 && (flag & 1) != 0) {
            off += 6; // skipped slot leaves 6 zero bytes
            continue;
        }
        let id = item_ids[i] % 500_000;
        buf[off..off + 4].copy_from_slice(&id.to_le_bytes());
        buf[off + 4] = stains[i][0];
        buf[off + 5] = stains[i][1];
        off += 6;
    }
    buf[84..86].copy_from_slice(&glasses[0].to_le_bytes());
    buf[86..88].copy_from_slice(&glasses[1].to_le_bytes());
    let stored_flag = if (flag & 1) != 0 { flag & 0xFFFF_FFF3 } else { flag };
    buf[88..92].copy_from_slice(&stored_flag.to_le_bytes());
    crc32(&buf)
}

/// Maps the character's live equipment display flags into the 4-bit gear-visibility flag that
/// feeds [`gearset_checksum`].
///
/// The client bakes this flag into a captured banner's checksum from the linked gearset's stored
/// visibility byte, which equals the live display toggles at the moment the gearset (and thus the
/// portrait) was saved. Because Kawari does not persist gearsets, we reproduce the same value from
/// the live `EquipDisplayFlag` register instead — correct whenever the portrait was captured with
/// the currently-worn visibility settings (i.e. the player has not changed a toggle since).
///
/// The mapping is bit-for-bit "hidden/closed", verified against the client (remap at 0x140bc0a90
/// and the inverse unpack at 0x1409d3d30):
/// - bit0 = HIDE_HEAD, bit1 = HIDE_WEAPON, bit2 = CLOSE_VISOR, bit3 = HIDE_VIERA_EARS.
///
/// All other `EquipDisplayFlag` bits (legacy mark, armoury-chest storage, etc.) are not part of
/// the checksum and are ignored.
pub fn display_flags_to_checksum_flag(flags: EquipDisplayFlag) -> u32 {
    let mut result = 0u32;
    if flags.contains(EquipDisplayFlag::HIDE_HEAD) {
        result |= 0x1;
    }
    if flags.contains(EquipDisplayFlag::HIDE_WEAPON) {
        result |= 0x2;
    }
    if flags.contains(EquipDisplayFlag::CLOSE_VISOR) {
        result |= 0x4;
    }
    if flags.contains(EquipDisplayFlag::HIDE_VIERA_EARS) {
        result |= 0x8;
    }
    result
}

/// Computes the gearset portrait checksum from the player's live equipped gear.
///
/// Mirrors the client's data-gathering: per slot it uses the *apparent* item id
/// (`Item::apparent_id()` = glamour id if present, else base id) and the item's own
/// two stains. `glasses` and `gear_visibility_flag` are supplied by the caller because
/// the server does not currently track live facewear or a standalone visibility flag.
///
/// Known divergence from retail: the client zeroes a slot's stains and uses the *base*
/// item id when the gearset's per-slot 0x02 "show actual item" override bit is set.
/// Kawari does not track that per-slot bit, so this always uses the apparent id + stains,
/// which matches gearsets without the override.
pub fn gearset_checksum_from_equipped(
    equipped: &EquippedStorage,
    glasses: [u16; 2],
    gear_visibility_flag: u32,
) -> u32 {
    let mut item_ids = [0u32; 14];
    let mut stains = [[0u8; 2]; 14];
    for slot in EquipSlot::iter() {
        let idx = slot as usize;
        let item = equipped.get_slot(slot as u16);
        item_ids[idx] = item.apparent_id();
        stains[idx] = item.stains;
    }
    gearset_checksum(&item_ids, &stains, &glasses, gear_visibility_flag)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::inventory::Item;

    #[test]
    fn crc32_standard_vector() {
        // Standard CRC-32/ISO-HDLC check value for the ASCII string "123456789".
        assert_eq!(crc32(b"123456789"), 0xCBF4_3926);
    }

    #[test]
    fn display_flags_map_to_checksum_flag() {
        // Only the four visibility bits feed the checksum, in "hidden/closed" polarity.
        assert_eq!(display_flags_to_checksum_flag(EquipDisplayFlag::empty()), 0x0);
        assert_eq!(display_flags_to_checksum_flag(EquipDisplayFlag::HIDE_HEAD), 0x1);
        assert_eq!(display_flags_to_checksum_flag(EquipDisplayFlag::HIDE_WEAPON), 0x2);
        assert_eq!(display_flags_to_checksum_flag(EquipDisplayFlag::CLOSE_VISOR), 0x4);
        assert_eq!(
            display_flags_to_checksum_flag(EquipDisplayFlag::HIDE_VIERA_EARS),
            0x8
        );
        // All four set together.
        assert_eq!(
            display_flags_to_checksum_flag(
                EquipDisplayFlag::HIDE_HEAD
                    | EquipDisplayFlag::HIDE_WEAPON
                    | EquipDisplayFlag::CLOSE_VISOR
                    | EquipDisplayFlag::HIDE_VIERA_EARS
            ),
            0xF
        );
        // Non-visibility bits must NOT leak into the checksum flag.
        assert_eq!(
            display_flags_to_checksum_flag(
                EquipDisplayFlag::HIDE_LEGACY_MARK
                    | EquipDisplayFlag::STORE_NEW_ITEMS_IN_ARMOURY_CHEST
                    | EquipDisplayFlag::STORE_CRAFTED_ITEMS_IN_INVENTORY
                    | EquipDisplayFlag::UNK2
            ),
            0x0
        );
    }

    // Golden data reconstructed from a real 634 PartyMemberPortraits capture (MCH, slot 0).
    // The wire packet carries only 12 item ids (no waist, no soul crystal); the soul-crystal
    // id (8574) was recovered by brute force as the unique value that reproduces the captured
    // checksum, jointly confirming the 14-slot layout, ordering, %500000, stains, and CRC.
    // gear_visibility_flag = 2, glasses = [0,0], expected checksum = 0xCB14B46B.
    const GOLDEN_ITEM_IDS: [u32; 14] =
        [40999, 0, 32596, 37179, 10043, 0, 33565, 30683, 9293, 9292, 9294, 9295, 9295, 8574];
    const GOLDEN_STAINS: [[u8; 2]; 14] = [
        [0, 0], [0, 0], [1, 0], [1, 0], [1, 0], [0, 0], [1, 0], [1, 0],
        [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0],
    ];
    const GOLDEN_CHECKSUM: u32 = 0xCB14_B46B;

    #[test]
    fn gearset_checksum_matches_capture() {
        let got = gearset_checksum(&GOLDEN_ITEM_IDS, &GOLDEN_STAINS, &[0, 0], 2);
        assert_eq!(got, GOLDEN_CHECKSUM, "got {got:#010X}");
    }

    #[test]
    fn adapter_matches_capture() {
        // Build EquippedStorage in equip-slot order matching the golden arrays.
        // apparent_id() returns item_id when quantity>0 and no glamour; 0 for empty slots.
        let mk = |id: u32, s: [u8; 2]| Item {
            quantity: if id == 0 { 0 } else { 1 },
            item_id: id,
            stains: s,
            ..Default::default()
        };
        let equipped = EquippedStorage {
            main_hand: mk(40999, [0, 0]),
            off_hand: mk(0, [0, 0]),
            head: mk(32596, [1, 0]),
            body: mk(37179, [1, 0]),
            hands: mk(10043, [1, 0]),
            belt: mk(0, [0, 0]), // waist: skipped by the checksum regardless
            legs: mk(33565, [1, 0]),
            feet: mk(30683, [1, 0]),
            ears: mk(9293, [0, 0]),
            neck: mk(9292, [0, 0]),
            wrists: mk(9294, [0, 0]),
            right_ring: mk(9295, [0, 0]),
            left_ring: mk(9295, [0, 0]),
            soul_crystal: mk(8574, [0, 0]),
            glasses: [0, 0],
        };
        let got = gearset_checksum_from_equipped(&equipped, [0, 0], 2);
        assert_eq!(got, GOLDEN_CHECKSUM, "got {got:#010X}");
    }
}
