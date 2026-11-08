# 副本 Director

负责入本初始化、战斗时间轴、演员、状态与场景控制。2026-11-07 增补取消、重置、状态与控制接口；兼容现有 content 脚本。

2026-11-08 按最新要求统一为 [C# 副本控制器](csharp_encounters.md)，八个现有入口及保留的凯夫卡 P2 均已迁移。C# 决定时间轴、选人、地图、轨迹与仇恨朝向，世界服负责原生同步与结算；`slide_actor` 连续移动，`move_actor` 瞬移。以下 Lua 形式描述的是保留的后端原生接口与旧脚本兼容语法，C# 中间层复用其验证和任务构建，不执行 Lua 副本定义。

## 取消与重置

| Lua 调用 | 行为 |
|---|---|
| `d:interrupt_cast({target=actor})` | 取消该演员及其当前预兆 Helper 的已排入 AOE、施法完成事件，解锁 NPC 并发送 CancelCast |
| `d:cancel_pending(actor)` | 按演员取消已排入的延迟技能 |
| `d:cancel_pending()` | 取消全副本当前已排入的延迟技能与读条 |
| `d:reset_encounter()` | 重置整轮战斗；丢弃当前任务队列剩余旧任务，再执行清理与 onReset |
| `d:stop_encounter(reason)` | 同样清理整轮，执行 onStop 并保持停止；不重新生成木桩 |
| `d:set_reset_on_deaggro(false)` | 关闭脱战自动重置，适用于多阶段转场；不关闭全灭/无人重置 |

延迟技能携带全局唯一轮次代号及来源/表现演员代号，结算时在世界锁内再次验证。演员移除、重置与通关后旧任务不会生效。旧施法完成也不能解除新施法的锁；普通 AOE 不解除读条锁。

重置恢复本轮开战时仍存活的已注册 Boss。基线是在开战前首次完成 Director 任务批次后保存的演员快照，包括 HP、位置、朝向、AI、仇恨、模型和可选中/可见状态；重置通过移除再重发演员同步到客户端。此前已死亡的地城 Boss 不在本轮恢复集合内。
清理副本记录的 Buff、Helper、预兆池、分身、连线及时间轴，重新打开屏障。机关和 MapEffect 的具体初始值仍由 `onReset` 显式设置。
`cancel_pending` 只取消当时已经排入的技能，不删除 Lua 未来时间轴回调。需要终止整轮时使用 `reset_encounter` 或 `stop_encounter`；转场应由脚本阶段变量约束后续回调。

## Buff

| Lua 调用 | 行为 |
|---|---|
| `d:gain_effect(actor,id,param,duration[,source])` | 来源可选，旧调用默认无具体来源；立即广播状态获得和完整状态列表 |
| `d:remove_effect(actor,id[,source])` | 显式移除并广播；可限制来源以避免删除其他来源的同 ID 状态 |
| `d:has_effect(actor,id)` | 查询本 tick 快照是否存在状态 |
| `d:get_effect(actor,id)` | 返回 `{id,param,duration,source}`，不存在返回 nil |

持续时间为 0 表示永久；限时刷新为永久时会取消旧到期任务。状态 ID 必须非零，Lua 持续时间必须是 0～604800 秒的有限值。
状态查询是 tick 快照，不保证同一个 Lua 回调内刚排入的 gain/remove 立即反映；任务执行后下一 tick 可见。

可选回调：

```lua
function onStatusGain(d, actor, id, param, duration, source)
    -- 包括通过 gain_effect_instance 路径发生的刷新；按状态 ID 过滤机制。
end

function onStatusLose(d, actor, id, param, duration, source)
    -- 显式移除和正常到期的 remove_effect 路径。
end
```

回调仅在战斗运行时收集，延后到 tick 执行以避免重入；重置清理不触发新的机制回调。直接修改 StatusEffects 内部数据的旁路（例如护盾耗尽）不保证触发这些回调。此接口负责状态与同步，不自动实现窒息、传染等具体机制。

## MapEffect 与演员控制

| Lua 调用 | 参数 |
|---|---|
| `d:map_effect(index,timeline[,state])` | index 为 u8，timeline/state 为 u16；state 默认 1 |
| `d:set_model_state(actor,state)` | u8 模型状态，更新服务器 Spawn 数据并广播类别 63 |
| `d:set_animation_state(actor,index,state)` | index=0/1、state=u8；广播类别 62，并缓存以便重入视野重发 |
| `d:set_target_icon(actor,id)` | Lockon 行号；类别 34，效果为瞬时通知 |
| `d:tether(actor,target,id[,slot])` | id 为 Channeling 行号，slot 默认 0；参数顺序为 slot/id/target/0 |
| `d:tether_cancel(actor,id[,slot])` | 按连线槽位和 Channeling ID 取消 |
| `d:set_target(actor,target)` | 更新当前目标和 ActorControlTarget；不会替代 NPC 仇恨逻辑 |

已有 `set_ai_enabled`、`set_targetable`、`set_visible`、`move_actor`、`play_timeline` 保留。动画及连线在演员重新进入视野后重发；模型状态写入生成数据。重置恢复 Boss 初始动画缓存。

```lua
-- 录像中的 MapEffect 状态/时间轴组合，参数顺序仍兼容旧脚本。
d:map_effect(1, 32, 16)
d:map_effect(2, 128, 64)
d:set_model_state(hand, 20)
d:gain_effect(player, 700, 0, 10, boss)
```

## 最终阶段脚本接口

| Lua 调用 | 行为 |
|---|---|
| `d:spawn_actor(key,spec)` | 按 BNpcBase 生成具名演员并返回对象 ID；指定位置、HP、等级、模型状态、目标可选中与 Boss 身份 |
| `d:arm_hit_trigger(actor)` | 设定一次性开场门控；支持玩家有效伤害、木桩仇恨和已完成入场玩家 3 米靠近 |
| `d:enmity_order(actor)` / `d:job(actor)` | 实时仇恨顺位快照和职业，用于选人与判定 |
| `d:begin_cast(actor,action,seconds[,target])` / `d:end_cast(actor,action)` | 读条与动作分离，按录像独立时间播放，避免重复结算 |
| `d:director_event(id,args)` | 发送限定范围的四参数演出事件；不用于回放通关/奖励 |
| `d:set_limit_break(value)` | 为当前实例启用极限技槽，范围 0～30000；触发专用三级 LB 执行路径 |
| `d:setup_map_effects(states,flag)` | 恢复 64/128 项地图状态基线，并清空旧增量缓存 |
| `d:set_weather(id[,fade])` | 更新实例天气并发送渐变；入场完成时补发当前天气 |

`spawn_actor` 的可选 `layout`、`model` 保留录像场景布局和模型 ID；缺省使用原生成路径。`begin_cast` 增加可选第五参数 `omen_delay`。场景增量缓存按最后更新时间排序；完整地图基线、天气、BGM 均在入场完成时恢复。Director 演出与 BGM 使用玩家自身消息，避免零来源控制包。`move_actor` 采用 ActorSetPos 精确定位，以满足瞬时地火 Helper 的位置/朝向需求。

第二轮客户端分析修订：`begin_cast(source,action,seconds,target,omen_delay,position,spell_id)` 的第六参数是独立预兆坐标，第七参数是可选技能表 ID，省略时保持原行为。`set_director_flag(u8)` 即使变量数组未变化也触发同步。`spawn_actor` 可选 `model_attribute_flags` 和 `animation_state` 直接保留模型属性及初始动画。

415 实际添加渲染隐藏位 13，旧 `force_state_refresh` 已移除，明确使用 `hide_actor(id)`；一般显隐仍使用 414 的 `set_visible`，两者不是互逆接口。`set_actor_owner(id,owner)` 对应 417，无 owner 时解除关联。`actor_presentation(id,operation,parameter,duration)` 对应 607，淡入时 duration 单位为百分之一秒，仅用于已经核对的演员演出事件。

`play_actor_timelines({{actor,timeline},...})` 发送 opcode 333，限制 1～10 名演员，填充剩余 ID 为无对象标记。客户端等待整组演员加载后同步启动 ActionTimeline，用于三绝转场。原录像演员 ID 必须先映射为本实例生成 ID，禁止直接转发原 ID。

MapEffect 最新状态按 index 缓存，在玩家 CommenceDuty 时补发。AOE 规则支持 targets、split、min/max_players、tanks、front_tanks/front_damage、状态惩罚和首人状态；`effect_source` 可独立指定表现演员，伤害来源保持 Boss。副本施加状态记录到清理集合，重置时移除。

实现和验收边界见 [三绝最终阶段](ultimate_final_phases.md)。

## 验证与范围

基础能力阶段通过世界服务器 162 项库测试和 2 项核心控制协议测试；三绝最终阶段更新后世界库共 169 项通过。测试包含旧 Lua 调用兼容、范围校验、精确 MapEffect 字节布局、控制包布局、状态网络同步、生命周期、三本时间轴与实例极限技回归。
2026-11-07 世界服已单独编译并更新，其他服务未重启。客户端视觉与八人机制仍待实机验收，不能由离线测试替代。
