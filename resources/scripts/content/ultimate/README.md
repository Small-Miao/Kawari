# 原生 Lua 副本定义

五本最终阶段完全通过显式 Lua 函数执行。时间轴、战斗序列、演员模板、机制判定、状态和场景分别编辑；世界服不加载录像事件表，不使用 `recording_from/recording_to`。

## 从哪里修改

| 编辑内容 | 文件 |
|---|---|
| 阶段顺序、节点时长 | `Definitions/Timelines/<副本>.lua` |
| Boss / Helper 的生成、移动、读条、技能、状态、同步演出 | `Definitions/Sequences/<副本>/<序号_机制>.lua` |
| 地图初始化、入场 BGM / 天气 | `Definitions/Scenes/<副本>/Initial.lua` |
| 机制中的 MapEffect、EObj、音乐、天气、过场 | `Definitions/Scenes/<副本>/<序号_机制>.lua` |
| 动态场景函数，如绝亚时间牢狱 | `Definitions/Scenes/<副本>.lua` |
| 演员名称、模型、初始坐标及生成模板 | `Definitions/Actors/<副本>.lua` |
| 实时选人、仇恨、命中几何、Buff 和失败判定 | `Definitions/Actions/<缩写>/<机制>.lua` |
| 原生状态 ID、持续时间和层数 | `Definitions/Statuses/<缩写>.lua` |

同一个机制的场景和战斗序列使用相同序号与名称。例如光暗未来第一轮光尘之剑：
- `Sequences/n4gw/03_FulgentBlade.lua`：读条、演员运动和技能结算。
- `Scenes/n4gw/03_FulgentBlade.lua`：直接调用 SpawnEObj、AnimateEObj、RemoveEObj。
- `Actions/FRU/FulgentBlade.lua`：攻击形状与伤害规则。
- `Timelines/n4gw.lua`：该节点在整场战斗中的顺序与时长。

各轮分开成文件，修改第一轮不会意外改变后续轮次。没有场景变化的节点只有战斗序列。

| 副本 | 阶段 | 指令 | 定义名 / 缩写 |
|---|---|---|---|
| 亚历山大 | P4 | `!cf 694` | d2az / TEA |
| 妖星乱舞 | P5 | `!cf 1094` | z3oy / UMAD |
| 幻想龙诗 | P7 | `!cf 788` | r1fz / DSR |
| 光暗未来 | P5 | `!cf 1006` | n4gw / FRU |
| 欧米茄 | P6 | `!cf 908` | z3oz / TOP |

入场为前阶段场景，触发木桩后播放转场。绝亚约 73 秒、妖星约 37 秒开放最终本体。默认妖星入口是 P5；旧 P2 一运代码保留在 `kefka_p2.lua`。

## 显式地图与物件调用

场景文件里直接写调用，不再通过 `kind="map"` 或 `kind="object_spawn"` 分发：

```lua
local At = dofile(CONTENT_DIR .. "/ultimate/commands.lua").At

return {
    At(2.0, 1, function(d, s)
        s.scene:MapEffect(d, 46, 4, 8)
    end),
    At(3.0, 2, function(d, s)
        s.scene:AnimateEObj(d, "blade_01", 4, 8)
    end),
}
```

这是写法示例，参数应取对应副本现有定义。MapEffect 包装接口顺序为 **index / state / timeline**；底层 `d:map_effect` 则为 index / timeline / state，使用包装接口可避免混淆。

`SpawnEObj(d, key, spec)` 指定物件名、base、layout、坐标、方向、状态等；同名重建先删除旧物件。`AnimateEObj` 操作已存在物件，`RemoveEObj` 删除物件。入场静态物件在 `Initial.SpawnObjects`，全灭/重置沿用同一初始定义。

过场控制直接使用 `d:director_event(...)`；音乐既可能是 `d:set_bgm(...)`，也可能由 Director 事件移交。当前已验证的参数和同帧顺序保留在实际脚本中。

## 时间与执行顺序

`At(秒数, Order, 函数)` 的秒数从**当前节点开始**计算。`Order` 只决定同一时刻的先后顺序。时间轴将场景和战斗序列合并后按时间排序，因此生成演员、生成物件、播放动画与技能命中的顺序不会因拆成两个文件而改变。

`duration` 决定节点持续时间。修改前一个节点时长，会同时平移后续机制的场景和战斗调用。事件不能超过自身节点时长。初始化和回调会在加载时校验；无效定义不会替换正在运行的实例。

`OnEnter / OnUpdate / OnExit`、`WaitUntil / Timeout / OnTimeout` 可用于条件控制；条件必须有超时，超时后会停止并取消本轮。绝亚时间牢狱和天体死亡等动态结算使用当前玩家状态。

## 演员与技能控制

`Actors/<副本>.lua` 的 `names` 提供 `Boss`、`Helper01` 等可读名称；`templates` 定义模型和初始属性。序列通过 `control.lua` 显式调用：

- `C.Spawn / C.Despawn`：生成或移除注册演员。
- `C.Move`：位置控制，保留施法几何锁及当前 Boss 仇恨方向规则。
- `C.Cast`：原生读条与地面预兆。
- `C.Action`：结束读条并进入所属 Actions 模块的实时命中判定。
- `C.Status / C.Tether / C.Untether`：状态和连线，同步通知相关机制。
- `C.Targetable / C.Visible / C.Model / C.Animation`：战斗本体与模型控制。
- `C.SynchronizedTimelines`：整组演员同步演出。

持续运动由 `s.actor_motion:MoveTo / Follow / FaceEnmity / LockFacing / Stop / Teleport` 控制，参考原 C# Motion，但运行完全在原生 Lua。只有实际击杀最终 Boss 才通关。

## 生效与验证

- `!timeline status`：查看阶段、节点和状态。
- `!timeline reset`：清理本轮，恢复木桩；继续使用已加载定义。
- `!timeline stop`：清理并停止。
- `!timeline reload`：检查候选 Lua 定义，成功后替换并重建当前实例；失败保留旧实例。

命令需要现有 GM 权限；`!controller` 是同义入口。修改文件后使用 reload 或重新创建实例。Lua 修改不需要重启世界服。单人观察可以先 `!godmode on`，人数判定仍按机制执行。

本轮拆分包含 85 个节点和 7,055 个调用。正常回归 185 项；额外迁移审计对比旧版时点、同帧顺序与参数，一并执行共 186 项通过：

```text
cargo test --offline -p kawari-world --lib
cargo test --offline -p kawari-world --lib explicit_migration_matches_legacy_call_times_order_and_parameters -- --ignored
```

迁移审计仅用于本轮保真，有意编辑机制后允许与旧录像不同，不要求更新脚本仍完全匹配旧素材。运行依赖隔离测试始终启用，禁止五本重新加载旧事件表。

原始素材、旧场景表、旧时间轴与校验信息统一位于仓库 `tools/ultimate-evidence`，仅供离线分析和迁移对照。提取器也只输出到该目录，不覆盖手工脚本。完整迁移前备份位于 `target/ultimate-analysis/before-explicit-lua`。

本轮只改变脚本结构，既有客户端演出、八人平衡及随机分支的验收边界没有因测试通过而消失。
