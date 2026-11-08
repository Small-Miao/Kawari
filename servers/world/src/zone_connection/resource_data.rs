//! 每连接的副本资源预加载：后加入和重新入场走同一路径，不依赖战斗触发。
use kawari::ipc::zone::{RsfData, RsvData, ServerZoneIpcData, ServerZoneIpcSegment};
use serde::Deserialize;
use std::{
    collections::HashMap,
    path::{Component, Path},
};

#[derive(Deserialize)]
struct ResourceManifest {
    #[serde(default)]
    resource_data: HashMap<u16, String>,
}

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct ResourceFile {
    schema: u8,
    source_sha256: String,
    packets: Vec<ResourceEntry>,
}

#[derive(Deserialize)]
#[serde(tag = "kind", rename_all = "lowercase", deny_unknown_fields)]
enum ResourceEntry {
    Rsv { key: String, value: String },
    Rsf { key: String, value: String },
}

fn decode(bytes: &[u8]) -> Result<Vec<ServerZoneIpcSegment>, String> {
    let file: ResourceFile = serde_json::from_slice(bytes).map_err(|e| e.to_string())?;
    if file.schema != 1
        || file.source_sha256.len() != 64
        || !file.source_sha256.bytes().all(|b| b.is_ascii_hexdigit())
        || file.packets.len() > 1024
    {
        return Err("副本资源格式版本、来源摘要或数量无效".into());
    }
    file.packets
        .into_iter()
        .map(|entry| {
            let data = match entry {
                ResourceEntry::Rsv { key, value } => {
                    ServerZoneIpcData::RsvData(RsvData::new(&key, &value)?)
                }
                ResourceEntry::Rsf { key, value } => {
                    if key.len() != 16
                        || value.len() != 128
                        || !key
                            .bytes()
                            .chain(value.bytes())
                            .all(|b| b.is_ascii_hexdigit())
                    {
                        return Err("RSF 索引必须为 8 字节、资源参数必须为 64 字节".into());
                    }
                    let key = u64::from_str_radix(&key, 16).map_err(|e| e.to_string())?;
                    let mut data = [0; 64];
                    for (i, byte) in data.iter_mut().enumerate() {
                        *byte = u8::from_str_radix(&value[i * 2..i * 2 + 2], 16)
                            .map_err(|e| e.to_string())?;
                    }
                    ServerZoneIpcData::RsfData(RsfData { key, value: data })
                }
            };
            Ok(ServerZoneIpcSegment::new(data))
        })
        .collect()
}

pub(super) fn load(root: &Path, content: u16) -> Result<Vec<ServerZoneIpcSegment>, String> {
    if content == 0 {
        return Ok(vec![]);
    }
    let manifest: ResourceManifest = serde_json::from_slice(
        &std::fs::read(root.join("manifest.json")).map_err(|e| e.to_string())?,
    )
    .map_err(|e| e.to_string())?;
    let Some(file) = manifest.resource_data.get(&content) else {
        return Ok(vec![]);
    };
    if !Path::new(file)
        .components()
        .all(|part| matches!(part, Component::Normal(_)))
    {
        return Err("副本资源路径必须位于清单目录内".into());
    }
    let path = root.join(file);
    if std::fs::metadata(&path).map_err(|e| e.to_string())?.len() > 256 * 1024 {
        return Err("副本资源文件超过 256 KiB".into());
    }
    decode(&std::fs::read(path).map_err(|e| e.to_string())?)
}

#[cfg(test)]
mod tests {
    use super::*;
    use kawari::packet::ReadWriteIpcSegment;

    fn root() -> std::path::PathBuf {
        Path::new(env!("CARGO_MANIFEST_DIR")).join("../../resources/encounters")
    }

    #[test]
    fn umad_entry_and_reentry_receive_all_recorded_resources_in_order() {
        for _ in 0..2 {
            let packets = load(&root(), 1094).unwrap();
            assert_eq!(packets.len(), 606);
            assert_eq!(
                packets.iter().filter(|p| p.get_opcode() == 274).count(),
                386
            );
            assert_eq!(
                packets.iter().filter(|p| p.get_opcode() == 921).count(),
                220
            );
            assert!(
                matches!(&packets[0].data, ServerZoneIpcData::RsvData(d) if d.key.starts_with(b"_rsv_47842_"))
            );
            assert!(packets.iter().any(|p| matches!(&p.data, ServerZoneIpcData::RsvData(d) if d.key.starts_with(b"_rsv_47925_") && std::str::from_utf8(&d.value).is_ok())));
        }
    }

    #[test]
    fn unrelated_contents_receive_no_resource_packets() {
        for content in [0, 694, 788, 908, 1006] {
            assert!(load(&root(), content).unwrap().is_empty());
        }
    }

    #[test]
    fn malformed_resource_batch_is_rejected_before_sending() {
        let input = serde_json::json!({"schema":1,"source_sha256":"0".repeat(64),"packets":[
            {"kind":"rsv","key":"_rsv_valid","value":"有效"},
            {"kind":"rsf","key":"0123456789abcdef","value":"00"}
        ]});
        assert!(decode(&serde_json::to_vec(&input).unwrap()).is_err());
    }
}
