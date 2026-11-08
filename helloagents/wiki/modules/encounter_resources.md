# 副本 RSV / RSF 资源初始化

妖星乱舞开场解码数据来自用户录像 `妖星乱舞绝境战 2026.11.03 17.11.19.dat`：386 条 RSV、220 条 RSF，全部时间戳为 0，共 45,074 字节原始负载。仅导出资源名称、资源索引和参数，不导出角色身份。

## 编辑位置

- `resources/encounters/manifest.json` 的 `resource_data` 按 ContentFinderCondition ID 选择文件；妖星为 1094。
- `resources/encounters/ResourceData/z3oy.json`：`rsv` 项为键和 UTF-8 文本，`rsf` 项为 16 个十六进制字符的索引及 128 个十六进制字符的数据字符串。
- `tools/extract_encounter_resources.py` 可从原始录像重新提取。存在非零时间戳资源更新时明确报错，不能把战斗中才生效的资源静默移到开局。

这部分是每个客户端连接都需要的资源预加载，放在 ZoneInit 后、Director 和 NPC 初始化前。开战、场景和实际机制仍由可编辑 C# Timeline 控制。每次新入场、重新进入或后加入都会完整补发；只重载 C# 时间轴不会重新发送连接资源，修改资源后需重新入场。

## 协议证据

录制插件 ARealmRecorded 使用自定义回放编号 0xF001 / 0xF002 保存两类数据，不能直接作为线上包号发送。当前 `ffxiv_dx11.exe` 的只读分发表验证结果：

| 类型 | 线上 opcode | 数据格式 | 接收函数 RVA |
|---|---|---|---|
| RSV | 274 | u32 UTF-8 字节长度、48 字节键、变长文本 | 0xB4A520 |
| RSF | 921 | u64 索引、64 字节参数 | 0xB4A540 |

分发表 RVA 为 0x18DB3C8，索引为 opcode - 101；分支 RVA 分别为 0x18D9C7C、0x18D9C8A。客户端及录像 SHA-256 见 `tools/ultimate-evidence/z3oy_resources_protocol.json`。升级客户端时必须重新核对，不使用第三方旧版包号。

核心协议新增显式变长尺寸声明，IPC 和外层 segment 长度都按实际字节计算。RSV 最多 4096 字节，RSF 固定 64 字节；单份资源最多 1024 项、256 KiB。完整验证成功后再开始发送，错误在世界服日志中报告。

## 验证与部署

- 606 条导出数据与录像顺序及原始负载逐字节一致。
- 3 项协议测试通过，包括中文长度、序列化尺寸、固定 RSF、超长数据拒绝。
- 世界服 192 项通过；资源读取覆盖每次入场重新下发、其他副本空集和坏批次拒绝。
- C# 50,480 原生批次校验及真实五绝入场子进程测试通过。
- 核心库全量 112 通过、1 项既有背包样本失败：旧操作值 218 与当前基数 284 不兼容。失败不经过本次变长协议处理，没有将其记为全部通过。
- 2026-11-08 13:23:30 +08:00 启动世界服 PID 60336，健康接口 200。备份 `target/ultimate-analysis/kawari-world.before-resource-data.exe`，日志 `resource-world.stdout.log` / `resource-world.stderr.log`；详细部署记录 `target/ultimate-analysis/resource-deployment.json`。
- 三次真实入场日志均确认 `content_finder_condition_id=1094 count=606`，随后正常初始化 Director 和 C# 控制器。用户已反馈“已在妖星，没问题”，并确认前两次关闭连接是主动退出重登。妖星资源初始化入场验收通过；该结果不延伸至尚未观察的完整战斗演出。

## 本次文件清单

- `core/src/ipc/zone/server/resource_data.rs`：资源协议及序列化测试。
- `core/src/ipc/zone/server/mod.rs`：注册 RSV / RSF 类型。
- `core/src/packet/ipc.rs`：使用已知变长负载尺寸。
- `core/macro/src/lib.rs`：显式变长尺寸声明。
- `resources/data/opcodes.yml`：当前客户端协议编号。
- `servers/world/src/zone_connection/resource_data.rs`：资源清单加载、批次校验和回归测试。
- `servers/world/src/zone_connection/mod.rs`：注册资源模块。
- `servers/world/src/zone_connection/zone.rs`：每连接入场补发。
- `servers/world/src/server/director/external.rs`：兼容新增资源清单字段。
- `resources/encounters/manifest.json`：妖星资源映射。
- `resources/encounters/ResourceData/z3oy.json`：606 条录像资源。
- `tools/extract_encounter_resources.py`：可重复提取工具。
- `tools/ultimate-evidence/z3oy_resources_protocol.json`：客户端及录像校验依据。
- `helloagents/wiki/modules/encounter_resources.md`、`csharp_encounters.md`、`tea_umad_final_phases.md`：实现和验证记录。
- `helloagents/CHANGELOG.md`、`helloagents/history/index.md`、`helloagents/history/2026-11/202611081340_umad_resource_init/`：变更与归档。
