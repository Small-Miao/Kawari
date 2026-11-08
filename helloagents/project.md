# 项目技术约定

Rust 2024 Cargo workspace；当前游戏兼容版本 7.51.2。世界服务器使用 Tokio、mlua、parking_lot；协议在 core。副本控制在 `controllers/EncounterHost`（.NET 10 / Roslyn 4.14.0），可编辑 C# 定义在 `resources/encounters/Definitions`；其他事件脚本仍在 resources/scripts。
遵循现有 Rust 风格，新增说明使用中文；验证采用 cargo fmt、针对模块的 cargo test 和 cargo clippy。禁止将本地配置、数据库或凭据写入文档。

离线录像分析工具在 `tools/ReplayAnalyzer`，使用 .NET 10 WinForms、独立解析核心和控制台回归；发布至 `target/ReplayAnalyzer-1.1.0`，不依赖服务器进程。其协议覆盖与演出关联证据边界见 `wiki/modules/replay_analyzer.md`。
