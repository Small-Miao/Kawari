# C# 控制器选择

本目录的 `<副本短名>.json` 会使**新建实例**选择独立 C# 控制器。例如 `r1fz.json` 对应龙诗。
`z3oy.json` 启用凯夫卡 P2 一运（`!cf 1094`）。没有配置覆盖的副本继续运行 Lua。

配置示例（请使用实际构建输出的绝对路径）：

```json
{
  "executable": "D:/Code/GitClone/GitHub/KawariYarukon/tools/MechanicSimController/bin/Debug/net10.0/MechanicSimController.exe",
  "args": ["--config", "D:/Code/GitClone/GitHub/KawariYarukon/tools/MechanicSimController/Examples/native-demo.json"]
}
```

仅在测试副本启用示例，示例坐标为 `(100,0,100)`。配置错误、控制器编译失败或超时会停止该实例控制器并取消本轮战斗，玩家仍可退出副本；日志和 `!controller status` 会说明原因。删除覆盖配置后，新实例重新使用 Lua。已有实例继续保留原控制器；修改选择配置后应重新创建实例。
