# 启动器允许远程 HTTP（轻量迭代）

- [√] 移除远程 HTTP 限制，保留协议及地址字段检查。
- [√] 更新启动器源仓库及服务器知识库说明。
- [√] 验证 HTTP/HTTPS 和无效地址，13 项检查及 Release 发布通过。
- [√] 备份并更新随包启动器，提供 `target/Kawari-Launcher-HTTP-Update.zip`（仅包含替换 EXE）。

验证范围：登录地址校验、编译和发布文件哈希；未使用实际账号进行游戏登录。
启动器源文件：`D:/Code/FFXIVQuickLauncher/src/XIVLauncher.FakeLaunch.Gui/KawariLogin.cs`。
旧包中的 `.7z` 保持原样；本次更新使用上述 ZIP 替换其中 EXE。
