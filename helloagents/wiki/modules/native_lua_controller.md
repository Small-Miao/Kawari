# 原生 Lua 副本控制器（历史基线）

本文记录 2026-11-08 较早的 Lua 版本。用户随后明确要求整个副本系统迁入 C# 并保持 MechanicSim 写法，现已由 [C# 副本控制](csharp_encounters.md) 接替。下面的 Lua 文件仅作迁移基线和历史回归；已配置的八个入口不再读取它们。

运行入口在 `resources/scripts/content/*.lua`；共享控制模块和可编辑定义位于 `resources/scripts/content/ultimate/`。详见该目录 `README.md` 的时间轴、场景、EObj 和运动示例。

## 实现

- `timeline.lua` 支持阶段/具名节点、相对时长、进入/更新/退出、节点定时事件和条件超时。超时通过 StopEncounter 清理整轮，避免遗留回调。
- `Definitions/Actions` 承载各副本技能判定、选人、Buff、仇恨和死亡处理；`mechanics.lua` 仅分发并提交通用几何，不再包含某本专属技能分支。
- 五本已完全改为显式 Lua：`Timelines` 组织节点，`Sequences/<content>/<序号_机制>.lua` 直接调用演员、读条、技能和状态；同名 `Scenes/<content>/<序号_机制>.lua` 直接调用 MapEffect、EObj、音乐、天气和 Director 演出。
- `Actors/<content>.lua` 提供 Boss/Helper 可读名称、初始演员与模板。`control.lua` 保留实时选人/命中钩子，`scene.lua` 管理物件生命周期。`commands.lua` 合并相对时间调用，同帧按 Order 稳定执行。
- 五本入口不再加载 `_data.lua`、场景 Records 或录像时间范围。旧素材、场景表和时间轴移至 `tools/ultimate-evidence`，仅供离线分析。提取器只更新该目录，不覆盖运行脚本。
- `actors.lua` 参考 C# Motion，实现 MoveTo/Follow/FaceTarget/FaceEnmity/LockFacing/Stop/Teleport；FaceAggro 为 FaceEnmity 别名。水平速度、停止距离、演员死亡取消计划和最高仇恨方向由服务器控制。连续移动发 ActorMove，瞬移发 ActorSetPos。
- `!timeline status/reset/stop/reload` 支持运行状态和控制；`!controller` 为别名。reload 先在候选 Lua VM 检查依赖及初始化，失败保留旧实例，成功才替换并清理。
- C# 子进程桥接及实例覆盖配置已从运行/编译路径移除，旧工程归档至 `tools/archive/20261108_csharp_controller/`，原 MechanicSim 工程未修改。

## 当前入口

| 副本 | 最终阶段 | CF 指令 | 定义名 |
|---|---|---|---|
| 亚历山大 | P4 | `!cf 694` | d2az |
| 妖星乱舞 | P5 | `!cf 1094` | z3oy |
| 幻想龙诗 | P7 | `!cf 788` | r1fz |
| 光暗未来 | P5 | `!cf 1006` | n4gw |
| 欧米茄 | P6 | `!cf 908` | z3oz |

各本均为前阶段场景 → 木桩 → 转场 → 最终本体。凯夫卡 P2 一运保留在 `ultimate/kefka_p2.lua` 和 Definitions/KefkaP2 相关模块，默认入口已由 P2 改为 P5。

凯夫卡 P2 历史实现仍区分 47826/47827 读条、47830/47831 本体跳跃与 47832/47833 分身跳跃。新最终阶段的具体实现与证据限制见 [绝亚与绝妖星](tea_umad_final_phases.md)。

## 边界

五本均接入原生结构与实时玩家判定；不等同于全部随机变体、职业技能和原始装等公式均已复原。录像图案按当前样本，伤害为可调练习初值。光尘之剑 EObj/BGM 修复已保留；TOP 额外 LB 样特效仍在既有待办。新两本的客户端镜头、模型与完整特效尚待反馈。

## 验证与部署（2026-11-08）

- 本轮 `cargo test --offline -p kawari-world --lib -- --include-ignored`：186 通过、0 失败。普通回归 185 项，包含五本单人/八人全程且禁止加载录像素材、节点时长平移、同帧顺序和取消；额外一项迁移审计核对 7,055 个调用的时点、顺序与有效参数。有意编辑机制后可跳过一次性迁移审计，常规回归继续运行。
- `cargo build --offline -p kawari-world --bin kawari-world` 成功。既有 Oodle 返回类型、链接库及 binrw 未来兼容性警告仍存在。
- `cargo clippy --offline -p kawari-world --lib` 完成，无错误；现有 23 项世界库风格告警保留，未批量改动无关代码。
- 本轮世界服 PID 42908，健康检查返回 200；登录服 PID 54148、Lobby PID 45740 保持运行。健康检查不能代替演出验收。
- 日志前缀 `target/ultimate-analysis/tea-umad-`：tests / build / clippy / world.stdout / world.stderr。
- 旧二进制备份 `target/ultimate-analysis/kawari-world.before-tea-umad-finals.exe`。
- 已请求用户以 `!godmode on`、`!cf 694` 或 `!cf 1094` 复测木桩、最终本体、音乐与首轮机制，反馈待补充。
- 完整拆分仅修改 Lua、分析工具和测试，未重启世界服。PID 42908 持续健康，HTTP 200；新实例读取新定义，已有实例用 `!timeline reload` 安全替换。日志为 `target/ultimate-analysis/explicit-lua-tests.log`；迁移前完整 Lua 备份在 `target/ultimate-analysis/before-explicit-lua`。
