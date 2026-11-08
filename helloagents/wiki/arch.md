# 架构

客户端 IPC → core 解码 → world 实例状态 → C# 副本宿主 / 原生 Director 任务 → 实例状态变更和网络广播。
精确定时 AOE 在 Tokio 任务醒来后取得世界锁，验证所属战斗与演员生命周期，再进行判定。

最终阶段脚本：C# `ITimeLineDefinition.Build()` 装配 `TimeLinePhaseList` → 先等待 `Duration` 再执行 `OnTimeLineEvent` → RaidManager 合并 Sequences / Scenes → 有界 JSON 原生操作 → 世界服验证和结算。Actors 提供模板，Statuses / Actions 提供状态及实时判定。详见 [C# 副本控制](modules/csharp_encounters.md)。

每个实例拥有独立 C# 子进程和时钟；候选重载编译及初始化成功才替换旧实例。世界服非阻塞轮询，校验整批参数后才提交。Rust 保留既有原生任务验证结构 `LuaDirector`，但八个已迁移的副本入口不读取 Lua 脚本。C# 实例失败不会退回旧逻辑。

原始录像提取物与旧事件表仅存在 `tools/ultimate-evidence`，运行时无依赖。此决策使机制编辑者能直接找到地图、物件、演员和技能调用，同时允许通过一次性迁移审计核对旧行为；后续有意修改机制不受旧录像约束。
