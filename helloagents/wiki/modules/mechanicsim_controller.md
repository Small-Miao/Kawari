# 第一版 MechanicSim C# 控制器（历史方案）

以下只记录先前的局部 C# 适配方案，旧源代码归档在 `tools/archive/20261108_csharp_controller/`。用户最新要求已落实为独立中间层与全部现有副本 C# 定义，当前入口和接口见 [C# 副本控制](csharp_encounters.md)，不要按本文旧路径启动。

当前编辑和控制方式见 [原生 Lua 副本控制器](native_lua_controller.md)。`!cf 1094` 现在运行 Lua 凯夫卡 P2 一运；`!controller` 仅作为原生 `!timeline` 命令别名保留。旧方案的运动行为已迁入 `actors.lua`。

## 架构和边界

Kawari 为每个实例启动一个 C# 子进程。宿主只读链接 `D:/Code/MechanicSim-Master` 中的定义接口、RaidManager、技能/状态结构及几何判定；网络出口替换为原生操作适配器。原工程的 33 个技能、28 个状态、3 条时间轴已通过编译验证。

世界服向宿主发送玩家/NPC 坐标、HP、职业、仇恨、状态和实际死亡/状态变更事件。C# 返回有序指令，复用 LuaDirector 验证及任务执行；Lua 不负责所选 C# 副本的时间轴。通信为进程标准输入输出，无公开控制端口。

每实例独占进程，避免原工程静态 `RaidManager.Instance` 串实例。世界服只做非阻塞轮询；首帧编译允许 30 秒，后续响应限 2 秒。单帧最多 1 MiB、512 条操作；版本、序号、方法允许列表和演员别名校验。一个批次失败时整批不提交。重置/无人离场/超时/完成会结束对应进程，旧轮次响应不能进入新轮次。

脚本是本地受信任 C# 代码，独立进程用于故障和实例隔离，不是代码权限沙箱。

## 编辑和启用

- 宿主工程：`tools/MechanicSimController/MechanicSimController.csproj`，.NET 10。
- 首个实用适配：`resources/controllers/umad-p2/Definitions/`，包含原凯夫卡 P2 一运的 8 个技能、2 个状态和 1 条时间轴。
- 时间轴：`Timelines/KefkaP2.cs`；技能、Buff 分别放在 `Actions/` 和 `Statuses/`。这些导入文件可以直接编辑；导入工具不会覆盖已有目录。
- IDE 编辑入口：`resources/controllers/umad-p2/Script.csproj`，通过项目引用提供原定义和原生 API 的补全与编译检查。
- 适配配置：`resources/controllers/umad-p2/profile.json`，设置模型/BNpcBase、原生 Status ID、场地原点和木桩。
- 副本选择：`resources/controllers/<副本短名>.json`。`z3oy` 对应 `!cf 1094`。未配置的副本继续 Lua。

在仓库根目录执行：

```powershell
dotnet build "tools/MechanicSimController/MechanicSimController.csproj"
dotnet "tools/MechanicSimController/bin/Debug/net10.0/MechanicSimController.dll" --check "resources/controllers/umad-p2/profile.json"
```

纯机制源码变更只需先执行 `--check`，再在副本内使用 `!controller reload`。新进程会重新编译定义。宿主接口或 Rust 代码修改需要重新构建相应程序。不会在战斗中自动替换文件；旧实例继续使用已编译的定义。

## 控制命令

| 命令 | 行为 |
|---|---|
| `!controller status` | 当前时间轴、阶段、节点或错误 |
| `!controller stop` | 取消战斗并清理本轮实体和拥有的状态 |
| `!controller reset` | 重建进程及初始化木桩 |
| `!controller reload` | 同 reset，重新编译当前 C# 定义 |

这些入口沿用现有 GM 命令权限检查。错误详情记录在 `target/mechanicsim/controller-*.log`。

## Boss 位置与机制接口

`Motion.MoveTo` 按速度水平移动，`Follow` 跟随玩家，`FaceTarget` 只改朝向，`FaceAggro` 持续面向最高仇恨；`Teleport` 瞬移，`Stop` 停止并可归还默认 AI。脚本移动会暂停默认 AI。连续移动由 `slide_actor` 更新服务器坐标并发送 ActorMove；瞬移使用 ActorSetPos。Motion 接口使用世界坐标，原 GameObject 定义仍使用 profile 原点偏移坐标。

`Native.Spawn/Cast/Damage/Circle/Buff/MapEffect/Bgm` 提交原生操作，`Native.Call` 可调用允许列表中的 EObj、动画、连线、头标和导演事件等接口。`Native.ActorDied/StatusGained/StatusLost` 接收世界服实际事件。`Scheduling.After` 使用服务器战斗时间，随进程结束取消。

旧定义中的 `SendDamageText` 仅为表现接口，不能自动当作真实伤害。任意 VFX 路径、客户端自定义图标、任意模型缩放没有通用原生等价物；未适配的客户端消息会报错，不静默伪装成功。

旧 GameObject 读条和 ActiveStatus 仍保留原工程的实时计时实现，不能用于加速仿真或暂停后精确续跑；原生延时、死亡与状态事件由服务器驱动。旧状态定义的本地 OnStatusRemove 并不自动等同服务器驱散事件，需要通过 Native.StatusLost 编写此类联动。

## 凯夫卡 P2 一运适配

沿用用户机制的八轮塔、随机方向、三种点名池、过去/未来跳跃、分身与消灭之脚。坐标从模拟器原点转换到 `(100,0,100)`。NPC 记录核对为本体 BNpcBase 19506 / 模型 4967、分身 19513 / 2137。

原生状态咏唱危机 5083；魔法易伤 2941。头标 715/716/717 对应分摊/大圈/扇形。塔通过 MapEffect 1～8 呈现（北=1，顺时针），按录像 3 秒后发送下一状态、约 10 秒后机制结算。旧脚本未定义的 1000/1001 引用已改为真实失败伤害/魔法易伤。原脚本最后一个西南塔坐标的 5.567 拼写改为 5.657。

入场先显示木桩，触发后本体可选中；原生伤害仍经过世界服无敌模式。只在本体实际死亡时通关，时间轴自然结束不会伪造击杀。当前适配范围是用户现有 **P2 一运**，并非完整 P2/P5 或整场绝妖星。非致死伤害使用明确的练习数值 100000，未宣称录像数值完整校准；正常组队平衡及游戏内模型、塔、图标需要实机验收。

## 验证

- 原始定义及原生 P2 定义编译通过。
- 176 项世界库回归通过；另行显式执行的 2 项专项测试通过。
- 真实 C# 进程联调已覆盖实体、施法、AoE、Buff、重置、超时回收；完整 P2 单人和八人输出逐批通过真实 LuaDirector 接口校验。
- 单人、八人模拟快照分别完整运行一运；八人出现 43 条 MapEffect、37 次读条和分身移动，重复请求被拒绝；仅注入本体真实死亡事件后输出通关。此结果只验证宿主执行及输出，不代替客户端视觉和八人战斗验收。
- 编辑工程构建成功；保留 66 条原定义/引用源码的可空性、未使用变量等警告，没有编译错误。构建日志 `target/ultimate-analysis/mechanicsim-editor-build.log`。

## 部署记录

2026-11-08：世界服 PID 44748，健康检查 `127.0.0.1:21064/healthcheck` 返回 200；`z3oy.json` 已启用 P2 控制器。原二进制备份 `target/ultimate-analysis/kawari-world.before-mechanicsim-deploy.exe`；运行日志 `target/ultimate-analysis/mechanicsim-world.stdout.log` / `stderr.log`。实际实例宿主已完成 8 个技能、2 个状态、1 条时间轴编译；客户端反馈待收集。

## 依赖说明

宿主使用 Microsoft.CodeAnalysis.CSharp 4.14.0 编译定义；为复用原消息类，仅引用 MessagePack.Annotations 3.1.7，不载入 MessagePack 序列化/反序列化运行库。原工程的 MessagePack 3.1.4 有构建审计告警，因此未将它引入新通信路径；参见 [官方漏洞公告](https://github.com/advisories/GHSA-vh6j-jc39-fggf)。本适配未修改原工程依赖。
