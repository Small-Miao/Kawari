# API

当前副本编辑接口见 [C# 副本控制](modules/csharp_encounters.md)：保留 MechanicSim 的 TimeLineDef / Phase / Node、无参回调、RaidManager、GameObject、Action 和 Status 写法。原生后端及旧脚本兼容接口见 [Director 文档](modules/director.md)，没有新增公开 HTTP 控制接口。

`RaidManager.Instance` 的 `Schedule(TimeSpan, Action)`、`RunGroup` 和 `MapEffect/SpawnEObj/AnimateEObj/RemoveEObj` 控制机制与地图。MapEffect 包装参数顺序为 index/state/timeline，底层 Director 为 index/timeline/state。地图和技能回调使用同一实例时钟。原生 Lua 文档只保留作历史基线。
