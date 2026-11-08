# 数据模型

实例拥有演员、任务和可选 Director；Director 拥有 C# 控制器通道、Boss 注册、Helper、战斗变量及取消代号。C# 快照包括坐标、HP、职业、目标、仇恨、状态与动作计数；死亡、机关、投票与状态变化通过事件传递。
EncounterRuntime 保存初始 Boss/控制快照、当前施法/预兆代号、预兆来源关联、状态回调队列及副本管理的状态来源。PendingAoe 在任务执行时绑定当前轮次和来源/表现演员代号，结算时验证后才改变 HP。
状态以 effect_id、param、duration、source_actor_id 表达。此次不改变持久化数据库结构。

最终阶段使用 C# 函数节点：TimeSpan 等待后执行无参回调，机制内 Schedule 保留相对时间及 order。Actors 保存具名模板与初始演员，Scenes/Initial 保存显式初始化函数。原始录像和旧 Lua 留作离线证据/迁移审计，不参与已配置入口的运行。此迁移不修改持久化数据库结构。
