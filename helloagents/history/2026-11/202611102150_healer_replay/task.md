# 任务清单：占星修复、白魔与画家实现及审计

- [√] 定位用户三份录像，按当前国服协议提取匿名证据。
- [√] 从当前客户端确认光速参数含义，核对地星爆发生命周期。
- [√] 实现光速与地星修复及回归。
- [√] 完整核对录像中的白魔技能、状态与量谱，补齐实现及回归。
- [√] 根据新增画家录像实现 PvE 技能、画布、量谱、状态与职业特性，逐项审计证据与限制。
- [√] 检查多人、取消、切职、换区与召唤物清理。
- [√] 完成构建、必要测试和本机部署，确认健康检查。
- [√] 更新知识库、变更记录并归档。
- [?] 用户实机确认光速、地星/铃特效、白魔与画家技能表现。

## 验证记录

- 常规回归 227 项通过；国服真实数据集成测试 13 项通过。覆盖实际 MP、读条请求、参数、范围治疗、神圣/法令目标和包容量、护盾到期/破裂、冷却等级、地面物件与量谱。
- 世界服构建通过，保留已有住宅与副本改动。PID 60968，健康 HTTP 200，游戏端口 21063。
- 部署前确认没有游戏客户端或已连接玩家。备份路径 `target/job-replay-audit/backup-before-deploy/kawari-world.exe`，复制前后 SHA-256 一致。
- 当前完整审计：`helloagents/wiki/modules/job_replay_audit_20261110.md`。未将录像未覆盖和客户端未实测内容标为已确认。
- 明确限制：旧复活的接受/拒绝交互未实现；同 ID HoT 多来源覆盖属于共用状态系统限制；位移和效果仍需实机验收。

## 主要变更入口

- `servers/world/src/server/jobs/pictomancer.rs` 及子模块：状态机、威力阶梯、原生效果、回归。
- `servers/world/src/server/jobs/white_mage.rs`、`astrologian/effects.rs`、`transient.rs`：治疗职业与演员退场。
- `servers/world/src/server/action.rs`、`action/area.rs`、`effect.rs`、`mod.rs`、`zone.rs`、`instance.rs`、`combat_state.rs`、`jobs/mod.rs`、`jobs/dispatch.rs`：实际执行、范围判定和生命周期。
- `servers/world/src/status_effects.rs`、`gamedata.rs`、`servers/world/Cargo.toml`：状态事件、持续治疗倍率、当前 Status 表和等级充能。
- `resources/scripts/actions/`：白魔等级威力、无中生有、角色技能及正确铃引爆入口；旧 28507 文件已由 28509 替换。
- `servers/world/src/server/jobs/replay_tests.rs`：国服 SqPack、队伍、协议与实际结算测试。
- `helloagents/wiki/modules/{astrologian,white_mage,pictomancer,job_replay_audit_20261110}.md`、`wiki/overview.md`、`CHANGELOG.md` 与本方案包。
