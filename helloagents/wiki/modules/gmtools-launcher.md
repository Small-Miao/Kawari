# Kawari 启动器与 GMTools

打开 `target/kawari-gmtools-win-x64/XIVLauncher.FakeLaunch.Gui.exe`，选择与 Kawari 服务器匹配的国服客户端并登录。随包版在没有保存设置时默认勾选卫月。启动后可通过游戏的 ESC 菜单或 `/gmtools` 打开 GM 面板。

2026-11-10 已把上述目录的 `dalamud-cn` 更新为 Soil `26-11-10-01`，对应国服 `2026.11.03.0000.0000`，沿用 API 15 的 GMTools 和第 6 版 UI 资源。76 项分发文件哈希及启动器的本地版本解析已验证。旧卫月目录备份于 `target/dalamud-20261103-update/dalamud-cn-before-20261103`。应在启动新游戏进程时勾选卫月，已有进程需退出后重开。

登录服务支持远程 HTTP 和 HTTPS，当前部署填写 `http://login.celemiao.com`；Lobby 地址填写 `frp-arm.com`，端口 `21059`。2026-11-08 移除 GUI 对远程 HTTP 的限制，保留地址格式检查和禁止自动跳转。旧版出现“登录服务请输入 HTTPS 地址”时，需要替换启动器 EXE。

2026-11-08 针对朋友电脑启动即出现 `sdologinentry64+11DB` 的反馈，恢复原 FakeLauncher 的启动前 ArgFix：挂起创建游戏、安装 `GameArgumentInterop.Fixer`、恢复执行，再按需附加卫月。保留单 Lobby、中文参数及 HTTP 登录；独立传递子进程 Unicode 环境，修复失败仅终止本次游戏。11 项流程回归与本机无卫月游戏主窗口启动检查通过，朋友电脑和启用卫月的实际表现仍需复测。替换包为 `target/Kawari-Launcher-SDO-Fix.zip`，只需覆盖 EXE，保留原有 `dalamud-cn` 和 `plugins`。

启动器从同级的 `plugins/FFXIVGMTools` 加载插件。首次注入时，它在 Kawari 独立卫月配置中启用开发插件登记和 GMTools 的开机加载，迁移旧的 GMTools 路径并保留插件标识。之后在卫月中手动禁用的选择会被保留。

在 GM 面板的 **Debug 指令 → 进入副本（!cf）** 中可按中文副本名或 CF ID 筛选下拉菜单。选中后自动填写 ID，点击执行才发送指令。

GMTools 0.2.2 起，副本下拉复用固定原生行，筛选和开合期间保持节点归属不变。若旧版在关闭面板时崩溃，请重新启动游戏以加载新版。

重新发布时，将 GMTools 的完整构建产物目录作为 `KawariGmToolsPath` 传给 GUI 项目，再把匹配的国服卫月目录放到发布目录的 `dalamud-cn`。分发时保留这两个目录与可执行文件同级。
