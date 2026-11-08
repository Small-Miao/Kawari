use binrw::binrw;

use crate::{
    common::{
        EventState, HandlerId, ObjectId, Position, read_bool_from, read_quantized_rotation,
        write_bool_as, write_quantized_rotation,
    },
    ipc::zone::ObjectKind,
};

#[binrw]
#[brw(little)]
#[derive(Debug, Copy, Clone, Default, PartialEq)]
pub struct SpawnObject {
    /// The object's spawn index. Note that this is a completely separate index from actors.
    pub spawn_index: u8,
    /// What kind of object this is.
    pub kind: ObjectKind,
    #[br(temp)]
    #[bw(calc = u8::from(*not_targetable) | (*extra_flags & !1))]
    flags: u8,
    /// 是否不可选中；保留同一字节中的其他客户端标志。
    #[br(calc = flags & 1 != 0)]
    #[bw(ignore)]
    pub not_targetable: bool,
    #[br(calc = flags & !1)]
    #[bw(ignore)]
    pub extra_flags: u8,
    /// Whether this object is initially hidden or not.
    #[br(map = read_bool_from::<u8>)]
    #[bw(map = write_bool_as::<u8>)]
    pub is_hidden: bool,
    /// If this is an ENPC, represents an index into the EObj Excel sheet.
    /// If this is an AreaObject, represents an index into the VFX Excel sheet.
    pub base_id: u32,
    /// Unique ID of this object.
    pub entity_id: ObjectId,
    /// Instance ID of the EventObject in the LGB.
    pub layout_id: u32,
    /// The event handler that owns this object.
    pub handler_id: HandlerId,
    /// The owner actor for this object.
    pub owner_id: ObjectId,
    /// Bound ID of the EventObject in the LGB, usually a SharedGroup.
    pub bind_layout_id: u32,
    /// Radius of the hitbox(?) If `bind_layout_id` is set, this value is ignored.
    #[brw(pad_after = 2)] // padding for alignment, not read by the client
    pub radius: f32,
    /// The rotation to create the object, in radians.
    #[br(map = read_quantized_rotation)]
    #[bw(map = write_quantized_rotation)]
    pub rotation: f32,
    /// The FATE to associate with.
    pub fate_id: u16,
    /// Controls the visibility of the event object.
    #[brw(pad_after = 5)] // padding for alignment, and then an unused u32
    pub event_state: EventState,
    /// For EventObjs, this is the default SharedGroupTimelineState.
    pub args1: u32,
    /// Part of this is used for housing entrances. EventObj uses this too, but it varies based on SubKind.
    pub args2: u32,
    /// The position to place this object at.
    pub position: Position,
}

#[cfg(feature = "server")]
impl mlua::UserData for SpawnObject {}

#[cfg(feature = "server")]
impl mlua::FromLua for SpawnObject {
    fn from_lua(value: mlua::Value, _: &mlua::Lua) -> mlua::Result<Self> {
        match value {
            mlua::Value::UserData(ud) => Ok(*ud.borrow::<Self>()?),
            _ => unreachable!(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use binrw::{BinRead, BinWrite};
    use std::io::Cursor;

    #[test]
    fn fulgent_blade_object_preserves_flags_and_effect_parameters() {
        // 原录像 opcode 403：匿名化 entity_id，保留光尘之剑的方向、位置与效果参数。
        let mut bytes = [0_u8; 64];
        bytes[1] = 7;
        bytes[2] = 5;
        bytes[4..8].copy_from_slice(&0x1EBBF7_u32.to_le_bytes());
        bytes[8..12].copy_from_slice(&0x40000001_u32.to_le_bytes());
        bytes[16..20].copy_from_slice(&0x800375BF_u32.to_le_bytes());
        bytes[20..24].copy_from_slice(&0xE0000000_u32.to_le_bytes());
        bytes[28..32].copy_from_slice(&1_f32.to_le_bytes());
        bytes[34..36].copy_from_slice(&0x1FFF_u16.to_le_bytes());
        bytes[44..48].copy_from_slice(&4_u32.to_le_bytes());
        bytes[48..52].copy_from_slice(&0x00450003_u32.to_le_bytes());
        bytes[52..56].copy_from_slice(&89.3934_f32.to_le_bytes());
        bytes[60..64].copy_from_slice(&89.3934_f32.to_le_bytes());
        let object = SpawnObject::read_le(&mut Cursor::new(bytes)).unwrap();
        assert!(object.not_targetable);
        assert_eq!(object.extra_flags, 4);
        assert_eq!(object.args1, 4);
        assert_eq!(object.args2, 0x00450003);
        let mut written = Cursor::new(Vec::new());
        object.write_le(&mut written).unwrap();
        assert_eq!(written.into_inner(), bytes);
    }
}
