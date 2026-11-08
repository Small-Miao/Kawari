# 工作区模块

- core：IPC 编解码、通用类型、配置及数据模型；macro 提供代码生成。
- world：实例、角色、动作、状态、战斗、C# 中间层及原生任务调度。
- controllers/EncounterHost：C# 定义编译、实例时钟、机制、场景、运动和 MechanicSim 兼容接口。
- login/lobby：账号会话和角色入口。
- launcher/frontier/patch：启动与更新相关服务。
- admin/web：管理与网页服务。
- resources：内容脚本与服务器数据。
- tools/run、navimesh、constants-gen、actionaudit：开发启动、导航、常量生成与动作审计。

本轮仅检查和修改 Director 相关路径，其余模块没有进行完整行为验证。

## 仓库整理与推送

- 发布目标：`git@github.com:Small-Miao/Kawari.git`，远程名 `small-miao`，分支 `master`；原 `origin` 和 `upstream` 保留。
- `.vs`、`bin`、`obj`、Python 缓存和本地 `.env` 不进入版本控制；保留工具所需的内嵌目录快照及源码归档。
- EObjectBrowser 的 `.patch` 文件包含统一差异语法所需的空白，通过 `.gitattributes` 单独关闭空白诊断，保持补丁原样。
- 推送前保存本地提交并合并目标已有历史，使用普通推送；最后核对远程与本地提交 ID。
- 合并保留黑魔法师、白魔法师及地面目标技能；旧效果包调用适配当前 `TargetEffect` / `ActionEffect1`，宠物参数使用现有具名字段。
- 职业路由统一区分 ClassJob 与 ClassJobCategory：弓箭手/诗人 5/23、幻术师/白魔 6/24、咒术师/黑魔 7/25；职业分类 ID 不能作为角色职业 ID 的别名。
- 本轮验证：世界服 193 项库测试及 9 项入口测试通过、5 项原有忽略；C# 宿主 131 项断言/50,480 批次、录像分析器 36 项断言及 7,055 调用时序审计通过。未执行客户端联机验收。
