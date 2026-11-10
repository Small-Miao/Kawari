# 恢复国服启动前参数修复（轻量迭代）

- [√] 对照原 FakeLauncher，定位 Kawari 直接启动路径跳过 ArgFix。
- [√] 恢复无卫月启动前的 ArgFix，并让卫月路径共用挂起、修复、恢复流程。
- [√] 保留单 Lobby、HTTP 登录与卫月运行时环境，修复失败仅清理本次进程。
- [√] Release 构建、11 项流程回归和本机无卫月游戏主窗口检查通过，发布替换 EXE。
- [√] 同步知识库并归档，朋友电脑与启用卫月的实际表现仍需复验。

更新包：`target/Kawari-Launcher-SDO-Fix.zip`，仅包含 EXE。包内文件与构建产物哈希一致。本机旧启动器正在运行，随包 EXE 覆盖失败；关闭旧启动器后用此更新包替换。
源修改：`D:/Code/FFXIVQuickLauncher/src/XIVLauncher.FakeLaunch/Program.cs` 和 `src/XIVLauncher.FakeLaunch.Gui/KawariDalamud.cs`。
本机验证使用虚构会话，不登录角色；测试仅清理自身创建的进程。
