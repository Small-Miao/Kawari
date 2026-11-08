# Kawari 启动器与 GMTools

打开 `target/kawari-gmtools-win-x64/XIVLauncher.FakeLaunch.Gui.exe`，选择与 Kawari 服务器匹配的国服客户端并登录。随包版在没有保存设置时默认勾选卫月。启动后可通过游戏的 ESC 菜单或 `/gmtools` 打开 GM 面板。

启动器从同级的 `plugins/FFXIVGMTools` 加载插件。首次注入时，它在 Kawari 独立卫月配置中启用开发插件登记和 GMTools 的开机加载，迁移旧的 GMTools 路径并保留插件标识。之后在卫月中手动禁用的选择会被保留。

在 GM 面板的 **Debug 指令 → 进入副本（!cf）** 中可按中文副本名或 CF ID 筛选下拉菜单。选中后自动填写 ID，点击执行才发送指令。

GMTools 0.2.2 起，副本下拉复用固定原生行，筛选和开合期间保持节点归属不变。若旧版在关闭面板时崩溃，请重新启动游戏以加载新版。

重新发布时，将 GMTools 的完整构建产物目录作为 `KawariGmToolsPath` 传给 GUI 项目，再把匹配的国服卫月目录放到发布目录的 `dalamud-cn`。分发时保留这两个目录与可执行文件同级。
