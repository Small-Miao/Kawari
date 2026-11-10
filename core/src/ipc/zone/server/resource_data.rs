//! 副本资源字符串和资源参数；不涉及网络混淆种子。
use binrw::binrw;

#[binrw]
#[brw(little)]
#[derive(Clone, Debug, PartialEq)]
pub struct RsvData {
    #[br(temp)]
    #[br(assert(value_length <= 4096))]
    #[bw(calc = value.len() as u32)]
    value_length: u32,
    pub key: [u8; 48],
    #[br(count = value_length)]
    #[bw(assert(value.len() <= 4096))]
    pub value: Vec<u8>,
}

impl Default for RsvData {
    fn default() -> Self {
        Self {
            key: [0; 48],
            value: Vec::new(),
        }
    }
}

impl RsvData {
    pub fn new(key: &str, value: &str) -> Result<Self, String> {
        if !key.starts_with("_rsv_") || !key.is_ascii() || key.len() >= 48 || key.contains('\0') {
            return Err("RSV 键必须是小于 48 字节的 _rsv_ 标识".into());
        }
        if value.len() > 4096 || value.contains('\0') {
            return Err("RSV 内容超过 4096 字节或包含空字符".into());
        }
        let mut result = Self::default();
        result.key[..key.len()].copy_from_slice(key.as_bytes());
        result.value = value.as_bytes().to_vec();
        Ok(result)
    }
}

#[binrw]
#[brw(little)]
#[derive(Clone, Debug, PartialEq)]
pub struct RsfData {
    pub key: u64,
    pub value: [u8; 64],
}

impl Default for RsfData {
    fn default() -> Self {
        Self {
            key: 0,
            value: [0; 64],
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        ipc::zone::{ServerZoneIpcData, ServerZoneIpcSegment},
        packet::ReadWriteIpcSegment,
    };
    use binrw::{BinRead, BinWrite};
    use std::io::Cursor;

    #[test]
    fn rsv_uses_utf8_byte_length_and_variable_packet_size() {
        for value in ["", "未来终结", "日本語 / English / 中文"] {
            let data = RsvData::new("_rsv_47925_test", value).unwrap();
            let packet = ServerZoneIpcSegment::new(ServerZoneIpcData::RsvData(data.clone()));
            let mut bytes = Cursor::new(Vec::new());
            packet.write_le(&mut bytes).unwrap();
            assert_eq!(packet.get_opcode(), 594);
            assert_eq!(bytes.get_ref().len(), 16 + 52 + value.len());
            assert_eq!(packet.calc_size() as usize, bytes.get_ref().len());
            assert_eq!(
                &bytes.get_ref()[16..20],
                &(value.len() as u32).to_le_bytes()
            );
            bytes.set_position(16);
            assert_eq!(RsvData::read_le(&mut bytes).unwrap(), data);
        }
    }

    #[test]
    fn rsf_preserves_index_and_all_64_bytes() {
        let data = RsfData {
            key: 0xFFEEDDCCBBAA9988,
            value: std::array::from_fn(|i| i as u8),
        };
        let packet = ServerZoneIpcSegment::new(ServerZoneIpcData::RsfData(data.clone()));
        let mut bytes = Cursor::new(Vec::new());
        packet.write_le(&mut bytes).unwrap();
        assert_eq!(packet.get_opcode(), 903);
        assert_eq!(packet.calc_size(), 88);
        assert_eq!(bytes.get_ref().len(), 88);
        bytes.set_position(16);
        assert_eq!(RsfData::read_le(&mut bytes).unwrap(), data);
    }

    #[test]
    fn rsv_rejects_invalid_keys_and_oversized_values() {
        assert!(RsvData::new("plain", "x").is_err());
        assert!(RsvData::new(&format!("_rsv_{}", "x".repeat(43)), "x").is_err());
        assert!(RsvData::new("_rsv_test", &"x".repeat(4097)).is_err());
        assert!(RsvData::read_le(&mut Cursor::new(u32::MAX.to_le_bytes())).is_err());
    }
}
