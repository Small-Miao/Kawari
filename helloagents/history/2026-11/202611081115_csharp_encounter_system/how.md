# 设计

## 架构选择

1. 嵌入 CLR：同步调用简单，但错误脚本会阻塞世界服，运行时与进程生命周期复杂。
2. 原 MechanicSim 原样链接：可以复用旧接口，但单例与客户端模拟协议不能直接代表真实服务器状态，继续扩大兼容层不利于维护。
3. 独立 C# 宿主与原生中间层（采用）：每实例独立进程，读取快照和生命周期事件，输出原生操作；按用户后续明确要求，Definitions 使用原 MechanicSim 命名空间与 Timeline / Phase / Node / TimeSpan / 无参回调 / RaidManager.Instance 写法，并提供原生场景和机制后端，无 Lua 副本逻辑依赖。

## 实现

- `controllers/EncounterHost` 提供独立 API、时间轴运行时、运动控制和 C# 源码编译加载。采用本机现有 .NET 10 和已使用的 Roslyn 4.14.0。
- `resources/encounters/Definitions` 是脚本编辑入口；源文件编译成程序集，注册 ITimeLineDefinition。
- 世界服接入有界 JSON 通道、请求序号和生命周期检查。复用已有原生任务接口的参数验证，禁止执行控制器提供的 Lua 代码。
- 候选控制器完成编译和初始化验证后才替换旧控制器；错误与超时可诊断且不会阻塞其他副本。
- 先完整备份现有 Lua，与新定义进行迁移审计；所有入口默认使用 C#，不静默回退旧 Lua。

## 风险与验证

- 同帧生成后引用、查询延迟、状态同步和 Boss 仇恨均需专项覆盖。
- 完成构建和离线测试后才部署；使用可回滚二进制备份，重启限定世界服。
- 本地脚本为可信代码，程序集加载隔离不宣称为安全沙箱。
- 可收集加载上下文参考微软文档：https://learn.microsoft.com/en-us/dotnet/standard/assembly/unloadability 。
