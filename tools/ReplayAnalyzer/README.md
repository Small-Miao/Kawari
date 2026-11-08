# FFXIV 录像分析工具

独立中文 Windows 桌面程序，版本 1.1.0。源码分为 Core、Desktop 和 Tests，无第三方 NuGet 依赖。

双击仓库中的 `target/ReplayAnalyzer-1.1.0/ReplayAnalyzer.exe`，选择“导入录像”多选 `.dat`，也可“打开工程”载入发布目录中的 `示例工程.json`。示例工程引用本机的八份录像，不复制录像文件。

详细使用方法、协议边界和维护说明见 [知识库](../../helloagents/wiki/modules/replay_analyzer.md)。运行需要 .NET 10 Windows Desktop Runtime，本机已安装。复制到其他机器时需保留整个发布目录及 `Data` 子目录。

## 构建和验证

在仓库根目录运行：

```powershell
dotnet publish "tools/ReplayAnalyzer/Desktop/ReplayAnalyzer.csproj" -c Release --no-self-contained -o "target/ReplayAnalyzer-1.1.0"
dotnet run --project "tools/ReplayAnalyzer/Tests/ReplayAnalyzer.Tests.csproj"
```

真实录像验证增加参数 `-- --recordings "录像目录" --csv "国服 CSV 目录"`。维护资源快照时才增加 `--bundle-catalog "tools/ReplayAnalyzer/Data/catalog.json"`，并同步核对协议版本。
