# C# 副本控制与 MechanicSim 写法

2026-11-08 按用户最新要求，将已有副本控制统一迁入 C#。脚本写法对照 `D:/Code/MechanicSim-Master`：使用原命名空间、`ITimeLineDefinition.Build()`、`TimeLineDef`、`TimeLinePhase`、`TimeLineNode`、`TimeSpan`、无参 `OnTimeLineEvent` 与 `RaidManager.Instance`。原 MechanicSim 工程未修改。

## 从哪里编辑

用 Visual Studio / Rider 打开 `resources/encounters/Script.csproj`，可以获得中间层接口补全及编译检查。运行时只扫描 `resources/encounters/Definitions/**/*.cs`，不会加载编辑工程的 bin/obj。

| 目录或文件 | 修改内容 |
|---|---|
| `Definitions/Timelines/*.cs` | 阶段、节点名称、等待时间、机制调用 |
| `Definitions/Sequences/<副本>/` | Boss / Helper 生成、移动、读条、技能、状态、表现的明确调用 |
| `Definitions/Actions/<副本>/` | 当前玩家选人、塔人数、分摊、实时位置和技能结算 |
| `Definitions/Statuses/` | 状态定义；现有部分状态 ID 也保存在 Actions 的规则文件 |
| `Definitions/Actors/<副本>.cs` | 具名演员、初始演员、模型/布局 ID、模板 |
| `Definitions/Scenes/<副本>/Initial.cs` | 入场及重置的前阶段 MapEffect、天气、音乐、静态物件 |
| `Definitions/Scenes/<副本>/<机制>.cs` | 机制过程中的 MapEffect、EObj、动画、音乐及演出 |
| `manifest.json` | 副本入口到 C# DefinitionId 的映射、宿主位置 |

`NativeEncounter` 是真实服务器生命周期的装配扩展：注册模型、木桩、初始场景、判定模块及通关条件。修改机制时间顺序主要编辑 `TimeLinePhaseList`；修改地图直接编辑 Scenes。已有 7,055 个调用保留为显式 C#，没有隐藏的录像时间范围分发。

## 与原工程相同的时间轴写法

下面可作为新文件的写法示例。实际本体通过 Actors 初始化后，可用具名演员查询；原 `GameObject` 构造和数字 ID 查询也可用。

```csharp
using System;
using System.Collections.Generic;
using MechanicSim_Server.Definition;
using MechanicSim_Server.Manager;
using MechanicSim_Server.Struct;

public sealed class MyTimeline : ITimeLineDefinition
{
    public string DefinitionId => "my-encounter";

    public TimeLineDef Build()
    {
        var timeline = new TimeLineDef
        {
            TimeLineName = "我的副本",
            TimeLineDescription = "机制练习",
            TimeLineAuthor = "作者",
        };
        timeline.OnTimeLineInit = () => timeline.TimeLineVars.Clear();
        timeline.OnTimeLineReset = () => timeline.TimeLineVars.Clear();
        timeline.TimeLinePhaseList = new List<TimeLinePhase>
        {
            new TimeLinePhase
            {
                PhaseName = "最终阶段",
                TimeLineNodes = new List<TimeLineNode>
                {
                    new TimeLineNode
                    {
                        NodeName = "场景变化",
                        Duration = TimeSpan.FromSeconds(3),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.MapEffect(17, 1, 2);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "技能",
                        Duration = TimeSpan.FromSeconds(6),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.GetObjectByGameObjectId(1001)?.TryCast(1004);
                        },
                    },
                },
            },
        };
        return timeline;
    }
}
```

`Duration` 的含义与原工程相同：**等待后执行该节点**。上例第一个节点在第 3 秒执行，第二个在第 9 秒执行。迁移的主时间轴第一个节点为 0 秒启动转场，后续等待值按累计时间核对。

机制文件中的 `raid.Schedule(TimeSpan.FromSeconds(...), () => ...)` 相对于调用节点的计划时间；`RunGroup(Sequence.Execute, Scene.Execute)` 将同节点的战斗和场景调用按时间和 `order` 合并。不要使用 `Task.Delay`、线程计时器或 `async void` 操作副本；这些回调无法随本轮取消，且不在实例上下文中。`RaidManager.Now` 提供实例时钟。

## 技能、状态与对象

原样的 `IActionDefinition` 可以注册动作：`ActionId` 是脚本内定义 ID，`GameActionId` 是真实游戏技能 ID。`GameObject.TryCast(定义ID)` 查找动作定义；`OnActionCastEnd` 中调用 `castInfo.Execute()` 才执行动作与原生表现。`CancelCurrentCast` / `castInfo.Cancel()` 会中断读条并使旧完成回调失效。支持对象的施法开始、结束、执行和取消事件。

迁移的录像序列直接调用 `TryCast(游戏技能ID, TimeSpan, Params)` 与 `ExecuteAction`，因为录像读条结束和实际技能结果是两个独立时点，不能自动重复播放伤害/特效。

`IStatusDefinition` 保留 `StatusId`、`GameIconId`、层数与回调；真实状态需要额外设置 `NativeStatusId`。例如咏唱危机脚本 ID 可为 1002，原生状态 ID 为 5083，图标 218951 不能作为原生状态 ID。支持 `Player.AddStatus/RemoveStatus/HasStatus/ReduceStatusStack`、`ActiveStatus.Stack/AddStack/RemoveStack/Remove`；`ReduceStatusStack` 会同步实际 Buff 层数并在减至零时移除。`Duration = TimeSpan.MaxValue` 映射为永久状态。状态获得/消失来自世界服快照，回调在实例线程中串行执行。

Actor 的 `MoveTo`、`Follow`、`FaceEnmity`、`StopMovement` 使用实时快照和仇恨。`RaidManager.Instance.Context.Motion.LockFacing` 在读条期间锁定朝向。坐标是实际游戏世界坐标，当前练习场中心通常为 `(100, 0, 100)`；没有隐式把原模拟器原点平移。持续移动由世界服同步，取消会清除运动计划。

场景接口：`MapEffect(index, state, timeline)`、`SetupMapEffects(states, flag)`、`SpawnEObj(key, Params)`、`AnimateEObj(key, state, timeline)`、`RemoveEObj(key)`、`PlayBgm(id)`、`SetWeather(id, fade)`、`DirectorEvent(id, args)`。MapEffect 的包装参数顺序是 index/state/timeline，中间层负责转换为原生 index/timeline/state。

该层提供机制编写接口兼容，不是原模拟器所有网络/客户端功能的替代品。任意 VFX 路径、自定义图标绘制、任意模型缩放、客户端消息包不能自动变成游戏原生操作。玩家当前只暴露内部 ID 名称和职业数字字符串；不要按显示名写机制。生成原生演员应优先用 Actors 模板以保留 BNpcBase、布局与模型信息。

## 已迁移的入口

| 入口 | DefinitionId | 当前实现范围 |
|---|---|---|
| `!cf 788` | r1fz | 龙诗 P7，含前阶段场景、木桩、转场 |
| `!cf 1006` | n4gw | 光暗未来 P5，含光尘之剑 EObj |
| `!cf 908` | z3oz | 欧米茄 P6 |
| `!cf 694` | d2az | 亚历山大 P4 |
| `!cf 1094` | z3oy | 妖星乱舞 P5 |
| w1fa_2 | w1fa_2 | 现有真火神机制循环 |
| s1d1_re | s1d1_re | 现有沙斯塔夏门、钥匙、Boss、过场与通关 |
| m6d1 | m6d1 | 现有商客奇谭 NPC、路线与投票 |
| 可选替换 z3oy 的 definition | kefka_p2 | 保留凯夫卡 P2 一运 |

迁移覆盖已有内容，未把普通副本的原有缺失阶段声称为完整复原。manifest 中八个入口由 C# 控制，宿主错误会停止并记录错误，不会悄悄回退 Lua。原 Lua 保留作为迁移基线和旧回归测试素材，不参与这些入口的运行。

## 构建、检查和加载

在仓库根目录执行：

```powershell
dotnet build "controllers/EncounterHost/EncounterHost.csproj" -c Release
dotnet build "resources/encounters/Script.csproj"
& "controllers/EncounterHost/bin/Release/net10.0/EncounterHost.exe" --check
```

只修改 Definitions 后，新建实例自动加载；已有实例使用 `!timeline reload`。`!controller` 是兼容别名。

| 命令 | 行为 |
|---|---|
| `!timeline status` | 时间轴、阶段、节点、运行/重载错误 |
| `!timeline reload` | 编译候选 C# 宿主；初始化及原生参数验证成功才替换并重置实例，失败保留原战斗 |
| `!timeline reset` | 取消旧轮次、清理实体/状态/连线/读条，重建初始场景和木桩；不重新编译文件 |
| `!timeline stop` | 清理本轮并恢复初始场景，保持停止 |

修改宿主接口需要构建 Release，之后 reload；修改 Rust 中间层需要构建并重启世界服。源码错误包含文件和行号，日志在 `target/encounters/controller-*.log`。本地源码受信任，进程隔离用于防止阻塞和实例串状态，不是恶意代码沙箱。

## 中间层与验证

副本资源预加载通过 `manifest.json` 的 `resource_data` 配置，每个入场客户端在 Director / NPC 初始化前独立收到 RSV / RSF。该步骤不依赖木桩或时间轴开战，避免后加入者漏收。编辑方式与当前客户端包号证据见 [副本资源初始化](encounter_resources.md)。

Rust 世界服仍负责网络、实体、实际伤害、状态及数据库；C# 控制时间轴、机制、选人、运动和场景。每实例独立子进程，通过有界标准输入输出 JSON 交换快照与原生操作，无公开控制端口。中间层复用已有 `LuaDirector` 原生参数验证/任务构建代码，不加载或执行 C# 返回的 Lua 脚本。

协议版本/序号校验，1 MiB 单帧上限、4,096 操作上限；首帧 30 秒，后续 2 秒超时。所有操作先在草稿中校验，整批成功才提交；重置丢弃旧响应，错误停止并恢复初始场景。实例回收时终止子进程。重载候选编译失败不影响旧宿主。

自动验证包括：9 个定义编译、7 个战斗定义各 450 秒单人和八人执行、真实死亡通关、重置取消、普通副本事件链、原 MechanicSim 动作文件原样编译、Buff 层数、Boss 仇恨/施法锁面向/运动，以及真实 Rust/C# 子进程重载。原生批次逐条经世界服校验；五本 7,055 调用累计时间与同帧顺序审计通过。

录像与历史提取结果留在离线目录；`tools/*migrate*` 和本次改写工具仅用于一次性迁移，正常编辑不要重新生成覆盖脚本。迁移前备份在 `target/ultimate-analysis/before-csharp-encounters/`。

依赖为现有 .NET 10、Microsoft.CodeAnalysis.CSharp 4.14.0；未引入原 MechanicSim 的 MessagePack 运行库。宿主依赖恢复审计通过。库测试与 Clippy 的旧工程/链接器告警记录在构建日志，不宣称整个仓库零告警。

客户端视觉尚需新版本实机验证。本次保持迁移前机制行为；欧米茄陨石阶段额外 LB 特效、部分过场镜头/预兆与八人数值平衡仍属于原有待验收问题，没有因架构迁移自动判定修复。

## 本次验证和部署结果

- 195 个定义文件、9 条时间轴编译通过；宿主 Release 和编辑工程零警告、零错误。
- 世界服库 188 项通过；C# 模拟 99 项断言通过；50,480 个原生批次全部校验通过。
- 另行执行真实子进程重载/重置/停止与全批次校验两个测试，均通过。
- 2026-11-08 12:14 +08:00 世界服 PID 60808，健康检查 200；登录/大厅未重启。部署记录在 `target/ultimate-analysis/csharp-deployment.json`。旧版本备份可回滚，客户端视觉尚未复测。

### 入场调度修正

用户随后反馈绝亚没有木桩。根因在世界服外层 `encounter_tick`：旧代码仅在战斗已开始后调用控制器，而 C# 首帧负责生成开战木桩，造成初始化无法开始。之前的子进程测试直接调用内部轮询，未覆盖这个外层启动条件。

已允许有存活玩家的 C# 实例在未开战时初始化和轮询；普通 Lua 保持原先入口，全灭/脱战重置仅针对已开战实例。空实例不创建宿主，手动 stop 不会自行启动。

回归测试已先验证旧代码失败。修复后 189 项世界服测试通过；从真实 `encounter_tick` 进入的五绝子进程测试确认入场生成可见/可选中木桩、触发器和 MapEffect，绝亚未开战重置能重新生成木桩。修复版世界服 PID 59192，健康检查 200，部署记录 `target/ultimate-analysis/csharp-entry-deployment.json`；用户已实机确认绝亚木桩出现。此确认不扩展到转场或后续机制效果。
