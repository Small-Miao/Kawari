# Windows 服务器启动脚本

在项目根目录双击 `启动服务器.cmd`。入口按 UTF-8 读取 `Start-Servers.ps1`，兼容 Windows PowerShell 5.1，中文脚本不依赖 BOM 或系统代码页。

## 关闭服务器

先在游戏中退出角色，再双击同目录的 `关闭服务器.cmd`。脚本默认等待世界服活动 TCP 连接退出（最多 60 秒），确认连接静默后结束本项目的 8 个服务；若旧的 `kawari-run` 集合启动器还在运行，也会一并处理。结束之前再次验证可执行路径和进程启动时间，不按进程名或旧 PID 清单直接终止其他目录的实例。与启动脚本共用互斥锁。

当前世界服在角色注销时执行 `commit_player_data`，没有整体优雅停机接口。因此本脚本是等待注销后的进程终止，不能代替服务器内部的保存确认。仍有活动连接时会等待并报错保留世界服；连接数可能包含内部请求，并不等于玩家人数。等待期间尚未通过初始检查时，不停止任何服务。检查通过后先停登录/大厅，再次检查世界服，处理期间新到达的连接。

关闭记录在 `target/runtime/stop-<时间>/processes.json`。重复执行会提示已经关闭；已有服务保持关闭，不删除数据库、配置或日志。

PowerShell 7 可使用：

```powershell
.\Stop-Servers.ps1 -CheckOnly
.\Stop-Servers.ps1 -WorldOnly
# 仅在明确接受断线及未保存进度丢失时使用：
.\Stop-Servers.ps1 -Force
```

Windows PowerShell 5.1 使用显式 UTF-8 加载：

```powershell
$stopServers = [scriptblock]::Create((Get-Content -LiteralPath '.\Stop-Servers.ps1' -Raw -Encoding UTF8))
& $stopServers -Root (Get-Location).Path -CheckOnly
& $stopServers -Root (Get-Location).Path -WorldOnly
```

`-WaitForLogoutSeconds` 可设置 10～300 秒，默认 60 秒。`-Force` 跳过连接等待，不代表强制保存。关闭脚本与启动脚本同样只针对本目录 `target/debug` 下的服务程序。

## 启动行为

默认启动 `target/debug` 下的 login、lobby、world、frontier、patch、web、launcher、admin 共 8 个现有可执行程序，工作目录固定为项目根目录，因此使用现有 `config.yaml`、资源和数据库。脚本不调用 Cargo，不重新编译，也不停止或重启已运行服务。

相同路径的已有进程会被复用；其他进程占用所需端口时，在启动前报错。启动过程使用项目级互斥锁，避免同时双击重复启动。每项服务等待自己的配置端口就绪，世界服另检查 `/healthcheck`。所有服务器进程隐藏窗口运行，入口窗口关闭后继续运行。

每次启动日志在 `target/runtime/<时间>/`，包含新启动服务的 `*.stdout.log`、`*.stderr.log` 及全部服务的 `processes.json`。已有进程的旧日志不会迁移。失败时保留已运行进程，输出错误和日志路径，便于处理后重新运行。

## 可选用法

在项目根目录打开 PowerShell 7：

```powershell
.\Start-Servers.ps1 -CheckOnly
.\Start-Servers.ps1 -WorldOnly
```

Windows PowerShell 5.1 使用显式 UTF-8 加载方式：

```powershell
$startServers = [scriptblock]::Create((Get-Content -LiteralPath '.\Start-Servers.ps1' -Raw -Encoding UTF8))
& $startServers -Root (Get-Location).Path -CheckOnly
& $startServers -Root (Get-Location).Path -WorldOnly
```

`-CheckOnly` 只检查文件、配置、进程和端口，不启动或停止服务。`-WorldOnly` 只处理世界服；已有世界服仍会跳过启动。`-StartupTimeoutSeconds` 默认 120 秒，可设为 5～300 秒。

端口默认值来自 `core/src/config.rs`，支持现有普通缩进 YAML 中的 `port`、`healthcheck_port`、`listen_address` 覆盖；不支持服务段内联 YAML 或别名，会明确报错。数据库或可执行程序缺失时停止，不自动创建新数据库。

## 验证记录（2026-11-11）

- Windows PowerShell 5.1 只读检查通过，正确识别世界服 PID 42592 已运行，其余 7 项待启动。
- Windows PowerShell 5.1 执行 `-WorldOnly` 成功复用 PID 42592，两个监听端口和健康检查通过；生成日志清单 `target/runtime/20261111-174944-3116/processes.json`，未重启世界服。未为验证而启动其余 7 项服务。
- PowerShell 语法与差异空白检查通过。
- 此脚本使用已部署的普通可执行文件，不代表上一轮尚未部署的复活修复已上线。
- 关闭脚本通过 6 项隔离进程检查：只读模式、活动连接阻止退出、仅世界服强制退出、其他目录同名进程保护、重复执行及无连接世界服关闭。模拟服务不读取游戏数据；记录在 `target/stop-script-check-202611111817/result.log`。
- 对真实目录仅执行 `Stop-Servers.ps1 -CheckOnly`，识别 8 个服务且世界服 PID 42592 保持运行，未关闭实际服务器。
