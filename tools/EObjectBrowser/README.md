# EObject 离线浏览器 1.0.3

独立 Windows 桌面程序，读取本机安装的国服游戏资源，使用自己的 OpenGL 渲染器预览 EObj。运行时不需要 FFXIV、卫月、启动器或服务器，也不请求在线资源服务。游戏资源仅只读，不包含在工具发布包里。

## 使用

1. 运行 `EObjectBrowser.exe`，默认游戏目录是 `D:\Games\FFXIVCN`。可选择其他游戏根目录、`game` 或 `sqpack`，点击“读取目录”。
2. 左侧搜索 ID、中文名称或 SGB 路径，点击物件。也可以在顶部输入完整 ID 或 `bg/`、`bgcommon/` 开头的游戏内部 `.sgb` 路径。
3. “三维预览”提供播放、暂停、速度、时间拖动、截图；左键拖动转向，右键平移，滚轮前后移动，WASD / QE 飞行，Shift 加速，“重置视角”重新定位。
4. 时间线下拉框切换 SGB 内部时间线。“时间线 / 指令”页展示 SubId、名称、自动播放、循环、时长、Actor 到实例绑定、指令时刻及解析字段。
5. 右侧“手动特效预览”独立播放 AVFX。它用于查看特效本身，不代表执行了所有时间线指令。默认每 5 秒循环预览，可取消循环或点击“从头播放”。
6. “物件层级”展示节点、模型、特效、子 SGB、位置；展开子物件并打开，顶部“返回”回到上一资源。
7. “导出物件分析 JSON”导出实际 SGB 中读取的信息，便于和录像分析结果对应。截图为窗口截图。

内置“示例：以太之光”和“光尘之剑”入口。光尘之剑对应 **2014199**，主要由 AVFX 组成，需要勾选右侧具体特效查看。

## 当前边界

- 目录内置国服 CSV 快照：15,513 个 EObj，11,407 个有关联 SGB；模型、纹理、着色器、SGB 和 AVFX 从所选游戏安装中读取。CSV 更新后需重新生成目录并构建。资源版本不匹配会显示读取错误。
- 没有 ExportedSG 路径的 ID 不一定有独立模型，可能由地图布局绑定或仅用于逻辑。例如 2007457。工具会提示需要具体布局资源，不会把其他模型当成它的外观。
- 时间单位为 SGB / TMB 的 30 tick/s。当前播放 C013 / C018 变换轨道及引擎支持的自转/重复运动；C019、C056、C057、C058、C059、C133 等保留解析内容，尚未执行。手动 AVFX 不自动推测这些指令的触发关系。
- 场景时间线 SubId、客户端动画槽、服务器 ActorControl 动画索引是不同的标识，不能直接等同。该工具展示资源自身时间线，不推测某个副本何时调用。
- 独立渲染器并非游戏引擎的完整替代；材质、光照和部分 AVFX 运算可能与客户端不同。已完成解析/预览的范围应以界面支持标记和验证记录为准。

## 构建

需要 Windows x64、Rust（当前验证 1.99.0-nightly）、MSVC C++ 构建工具、Git。首次构建需要网络下载锁定依赖；发布程序运行不需要网络。

```powershell
powershell -File .\tools\EObjectBrowser\build.ps1 -Test
# CSV 已更新时重新生成内嵌目录
powershell -File .\tools\EObjectBrowser\build.ps1 -RefreshCatalog
```

源码在本目录；`Engine` 是固定版本的 XIViewer 构建缓存，不纳入父仓库。`engine.patch`、`ironworks.patch` 记录引擎修改；`eframe.patch`、`egui_glow.patch` 和 `glow_compositor.rs` 实现整窗合成。GUI 原始归档按 SHA-256 校验，构建脚本拒绝覆盖版本不符或有补丁冲突的目录。发布位置：`target/EObjectBrowser-1.0.3`。

1.0.3 修复整窗闪烁：先在独立缓冲中绘制完整界面与三维场景，再一次性复制到窗口后缓冲并交换。用户已确认新窗口正常。缩放窗口时重建相应尺寸的缓冲，退出时释放；不再保留 1.0.2 无效的 `glFinish` 等待。窗口标题含版本号，旧版发布目录保留。

开发诊断：环境变量 `EOBJ_RENDER_PROBE` 指定连续帧输出目录，10 秒后记录 64 帧亮度与静态 UI 像素哈希；`EOBJ_UI_ONLY=1` 可在测试实例中关闭三维绘制做对照。普通运行不开启这些诊断。

隐藏渲染自检（不打开游戏）：

```powershell
EObjectBrowser.exe --smoke D:\Temp\EObjRender --open 2014199
# 同时验证缩小、放大、还原窗口时的缓冲重建
EObjectBrowser.exe --smoke D:\Temp\EObjResize --resize-smoke
```

输出窗口 PNG、资源分析 JSON、渲染计数 JSON；90 秒超时写 `failure.txt`。自动测试对纯特效物件显式启用第一项 AVFX，正常界面由用户选择。

本工具基于 [XIViewer](https://github.com/WorkingRobot/XIViewer) 与其 Ironworks 资源解析器扩展，遵循上游许可证；来源、固定版本与依赖审计见 `THIRD-PARTY.md`。
