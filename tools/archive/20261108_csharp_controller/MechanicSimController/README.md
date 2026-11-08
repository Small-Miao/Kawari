# MechanicSim 原生控制器

宿主为每个副本单独运行一个进程，只读引用 `D:/Code/MechanicSim-Master` 的运行时。原工程不需要启动 TCP 服务或卫月模拟客户端。

## 编辑凯夫卡 P2 一运

用 IDE 打开 `resources/controllers/umad-p2/Script.csproj`，可以获得类型检查和补全。机制位于同目录的 `Definitions/Timelines`、`Definitions/Actions`、`Definitions/Statuses`；模型、状态 ID 和场地原点映射位于 `profile.json`。

在仓库根目录执行：

```powershell
dotnet build "resources/controllers/umad-p2/Script.csproj"
dotnet "tools/MechanicSimController/bin/Debug/net10.0/MechanicSimController.dll" --check "resources/controllers/umad-p2/profile.json"
```

脚本编译检查通过后，在游戏中执行 `!controller reload`。它会取消当前战斗、清理实体和状态，并重新创建木桩。`!controller status` 查看节点，`!controller stop` 停止，`!controller reset` 重置。所有命令沿用服务器 GM 权限。

副本入口为 `!cf 1094`，通过 `resources/controllers/z3oy.json` 选用此控制器。单人观察可先开 `!godmode on`；机制人数判定仍按原脚本执行，单人不会自动模拟另外七人。

Boss 移动可用 `Motion.MoveTo/Follow/FaceTarget/FaceAggro/Teleport/Stop`，参数使用世界坐标；原 GameObject 坐标继续按 profile 原点转换。MoveTo/Follow 用于水平地面移动。脚本操作真实实体、伤害、状态和 MapEffect。仅飘字、任意客户端 VFX 路径等旧接口需要显式适配。

当前是用户原有的 **P2 一运**，不包含完整 P2/P5。非致死伤害为练习数值，客户端表现和组队平衡需要实测。

更多说明见 `helloagents/wiki/modules/mechanicsim_controller.md`。

## 验证

```powershell
python "tools/MechanicSimController/smoke_test.py" --p2
python "tools/MechanicSimController/smoke_test.py" --p2 --solo
cargo test -p kawari-world --lib native_csharp_roundtrip_and_reset -- --ignored
cargo test -p kawari-world --lib native_p2_recorded_commands -- --ignored
```

完整烟雾测试约 125 秒，使用模拟快照，不连接游戏。最后一项读取前两项产生的批次，验证真实服务器原生接口的参数兼容性。
