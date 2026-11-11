# 普通复活确认流程（2026-11-11）

状态：服务端代码已接入；前一轮 300 项常规、40 项国服数据回归通过，尚未部署到在线世界服。新增当前 build 14251465 的本人复活录像后，8 项复活专项和 14 项解析回归通过。当前版本的迁移、起身及资源/状态下行协议已核对；本地服务器的原生确认窗口、上行通知及动画仍未完成实机验收，不把官方录像或服务端测试当作本服客户端验收。用户先前表示暂时无法启动 IDA，本轮无需依赖 IDA。

## 证据与边界

`tools/analyze_raise_replays.py` 按 v5/build 14101351、14251465 分别选择已验证 opcode，其他构建直接拒绝。三份旧版龙诗、光暗未来、欧米茄录像共提取 22 条职业复活效果；其中 2 条是对录像本人的先后复活请求，属于同一次死亡后的请求覆盖及一次完整复活过程。新补的帕戈尔赞录像增加 1 条道具复活及一次完整本人接受过程，合计 4 个文件、23 条请求、3 条本人请求。匿名证据保存在 `arr_jobs_100_audit/revival_evidence.json`，含原文件 SHA-256，不保存原始角色 ID 或角色名。

- 请求技能包：状态 148，参数 8，持续 60 秒；效果字节 `0e00140800009400`。后一位施术者可覆盖尚未接受的请求，目标仍为 0 HP。
- 本人接受后的 PrepareZoning：动画 181，warp 5，参数 2，fade 3、unk1 2；旁观者收到 ActorControl 212，参数 2/181。
- 约 1.5 秒后 ActorSetPos：warp 5、参数 2。随后 ActorControl 200，参数 1/1；再约 3 秒恢复普通模式及生命值。
- 本人状态包明确显示 HP `16236 / 81181`、MP `2000 / 10000`，即最大值的 20%；状态 43 持续 100 秒、418 持续 5 秒。两种状态来源均为无角色来源，不能归到施术者或受术者。
- 客户端上行 200/action 5（接受）、205（拒绝）、201/location 5（迁移完成）使用仓库已有协议定义；AR 只有下行记录，当前客户端上行及确认窗口仍需实机检查。迁移目标使用施法完成时施术者位置，这是当前实现选择，移动施术者边界待核验。

## 当前版本本人录像补充

文件：`黄金平原帕戈尔赞草原 2026.11.11 17.46.52.dat`，build 14251465，时长 42.926 秒，62,376 字节；SHA-256 `4fbe978dcd4200ed4fc8634cce524ae0e685e1b21098bac4b622bb4f9b9584c2`。

这次使用的是道具动作：`ActionType=2`、道具 ID `4570`，演出 `spell_id=43336`，本地国服 Action 表名称为“不死鸟之尾”。4570 不能当作 Action 表的职业技能编号，也不是需要减去偏移的混淆技能 ID。解析器保留动作类型、道具 ID 和演出 ID，并通过 GainEffect 148 识别复活请求；未将这两个编号加入服务端职业复活白名单。本轮不声称实现了道具使用及消耗。

| 录像时刻 | 下行证据 | 结论 |
|---|---|---|
| 25.158 秒 | ActorCast 352，道具 4570，演出 43336，8 秒读条 | 道具施放过程 |
| 32.660 秒 | ActionEffect1 400：`0e00140800009400`；StatusEffectList 349：HP 0、状态 148/参数 8/60 秒 | 发出请求时仍死亡 |
| 34.945 秒 | PrepareZoning 688：`00000000aa03b5000000050203020000` | 本人进入迁移，区域 938、动画 181、warp 5、参数 2 |
| 36.388 秒 | ActorSetPos 934：`ff7f050200000000d98e4fc4ada9364052088a4300000000` | 1.443 秒后移动；warp 5、参数 2 |
| 36.779 秒 | ActorControlSelf 169，类别 200，参数 1/1 | 执行起身演出 |
| 39.762 秒 | 模式恢复普通，HP 6724/33621、MP 2000/10000；状态 43/100 秒、418/5 秒 | 起身后约 2.983 秒恢复 20% 资源；状态来源为系统 |
| 41.808 秒 | PrepareZoning，warp 13 | 离开副本，解析在此终止复活追踪，避免把离场清理当成复活移除状态 |

施术者最后一次 ActorMove（25.234 秒）的位置与复活落点逐轴相差小于 0.031，符合量化精度；本段未包含请求发出后施术者再次移动，因此不能据此解决“接受时追随施术者还是使用施法完成位置”的边界。服务端保留 1.5 秒迁移和 3 秒起身等待，不为单个包的网络时序波动改成固定 1.443/2.983 秒。

复活后的通用下行参数与已有服务端实现相符，本轮无需改变状态机行为。旧版职业复活的消耗、职业与距离校验继续使用各自技能数据，不由不死鸟之尾样本推导。

## 服务端行为

白魔/幻术师 125，召唤/秘术师/学者 173，占星 3603，赤魔 7523，贤者 24287 共用 `server/revival.rs`。发出请求时保留死亡状态并扣除正常技能消耗；本人接受有效请求后，迁移至保存的位置，等待迁移完成通知和复活动画，再恢复 20% HP/MP。普通复活与治疗 LB 的直接复活路径分别处理。返回出生点（action 8）不属于本次新增流程。

请求校验包含职业、死亡玩家、距离、禁止复活状态；接受校验以连接所属演员为准，不能指定其他玩家。重复接受、迟到拒绝均不重复执行。60 秒未确认取消；迁移后 10 秒未收到完成通知则取消并恢复显示，不通过超时强制复活。换区清除请求，接受后不允许另一请求覆盖。重复衰弱时添加状态 44；衰弱/濒死的主属性数值减益未在本次校准，当前只完成状态同步。

复活完成添加 5 秒保护，实际伤害结算返回 0；有效动作或自动攻击解除保护。恢复时关闭旧自动攻击，避免死亡前保留的自动攻击立即取消保护。该保护不代表 GM 无敌，也不覆盖所有副本强制死亡规则。

## 验证与部署

- 新增 7 项复活单元回归，覆盖请求字节、完整接受链、资源恢复、拒绝/超时、重复确认、替换来源、换区、非法目标及保护。
- 新增 1 项国服 SqPack 请求链，循环验证白魔、召唤、学者、占星、赤魔和贤者六个职业的实际效果包及 2400 MP 消耗。
- 旧光速测试使用存活的自身作为复活目标，新目标校验会正确拒绝。改用死亡队友，保留原本长读条与短读条的完整断言。
- 最终 `cargo test -p kawari-world --offline --no-run` 构建库与主程序测试产物成功；300 项常规回归、40 项国服数据回归及 6 项解析测试通过，无失败。新工具额外验证拒绝用旧 opcode 解析新构建，证据计数、资源比例及系统状态来源一致。测试日志位于 `target/arr-job-audit/revival-*.log`。保留项目既有链接/可见性警告，未声称零警告。
- 只读核对在线进程仍是 PID 42592，健康 HTTP 200，二进制仍为此前部署的 `27408D08A76DD54CECAA1ECA50850825937F9150A6BBEB112CFDE7B49EF84E70`；本轮未重启、未替换在线二进制，尚未发布含此修复的普通 world 可执行文件。验证窗口需要双开/另一名玩家实际施放复活，不能仅靠单人的函数测试确认。
- 当前录像补充：新增第 8 项 Rust 复活回归，逐字节比较上述 PrepareZoning / ActorSetPos，并核对非整除 HP 的向下取整、系统来源与状态时长。首次断言未考虑状态读取会实时扣除经过时间，调整为剩余时间范围后 8 项全部通过；日志 `target/arr-job-audit/revival-current-wire.log`。仅构建测试产物，未发布或重启 world。
- 解析器新增 8 项回归，与已有职业解析 6 项合计 14 项通过；覆盖双构建、30/60 状态槽、道具/技能命名空间、第一人称歧义、截断包、未知构建和离场终止。4 份真实录像重新提取为 23 条证据，当前录像包含完整 20% 资源及系统状态来源。日志 `target/arr-job-audit/revival-current-parser.log`。

## 文件落点

- `servers/world/src/server/revival.rs`
- `servers/world/src/server/revival/tests.rs`
- `servers/world/src/server/combat_state.rs`
- `servers/world/src/server/mod.rs`
- `servers/world/src/server/action.rs`
- `servers/world/src/server/actor.rs`
- `servers/world/src/server/zone.rs`
- `servers/world/src/main.rs`
- `servers/world/src/server/jobs/white_mage.rs`
- `servers/world/src/server/jobs/scholar/effects.rs`
- `servers/world/src/server/jobs/sage/effects.rs`
- `servers/world/src/server/jobs/red_mage/effects.rs`
- `servers/world/src/server/jobs/paladin.rs`
- `servers/world/src/server/jobs/replay_tests.rs`
- `resources/scripts/actions/001/Raise_00125.lua`
- `tools/analyze_raise_replays.py`
- `tools/test_analyze_raise_replays.py`
- `tools/build_job_audit_report.py`
- `helloagents/wiki/modules/arr_jobs_100_audit/` 的索引、12 个职业表与匿名复活证据。
- `helloagents/wiki/modules/arr_job_audit_20261111.md`
- `helloagents/wiki/modules/white_mage.md`
- `helloagents/wiki/modules/job_replay_audit_20261110.md`
- `helloagents/plan/202611111255_arr_jobs/task.md`
- `helloagents/CHANGELOG.md`

整体职业审计仍有其他未验收项，原方案保持未完成，不归档。
