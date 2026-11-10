# 任务清单

- [√] 修复骑士魔法耗蓝。请求与实际扣费应用 64 级特性。
- [√] 修复状态到期与切职清理。保留稳定槽位，实际职业变化后清理本人与同实例目标，避免已移除的占星延迟状态触发治疗。
- [√] 执行回归并更新知识库。214 项常规回归通过，另用国服数据验证骑士悔罪连段与厄运流转、黑魔纹、占星地星共 3 项。
- [√] 更新本机世界服。PID 47148 监听 21063 和 21064，健康检查 HTTP 200。截图对应的客户端状态图标仍需游戏内复验。

## 主要改动

- `servers/world/src/status_effects.rs`、`servers/world/src/server/effect.rs` 和 `servers/world/src/server/instance.rs` 统一到期和移除流程。
- `servers/world/src/server/mod.rs`、`servers/world/src/common.rs` 和 `servers/world/src/zone_connection/item.rs` 在最终职业变化时清理。
- `servers/world/src/server/action.rs`、`servers/world/src/server/jobs/paladin.rs` 校准骑士魔法耗蓝并验证技能结算。
- `servers/world/src/server/jobs/astrologian/effects.rs`、`servers/world/src/server/jobs/summoner.rs` 清理职业运行数据。
- `servers/world/src/server/director.rs`、`servers/world/src/server/director/tests.rs` 和 `servers/world/src/server/limit_break.rs` 接入统一状态接口并验证副本状态保留。

## 占星后续回归

- 手动触发及天宫图升级验证实际状态与施术来源，防止已清除的状态短暂触发。大宇宙到期自动结算仅触发一次。
- 使用副本伤害结算验证四项占星减伤各将 100 点伤害降至 90。两项叠加降至 81，状态过期后恢复 100。强制伤害依然为 100。
- 217 项常规回归及国服地星端到端回归通过。更新后的世界服 PID 40876，健康检查 HTTP 200。
