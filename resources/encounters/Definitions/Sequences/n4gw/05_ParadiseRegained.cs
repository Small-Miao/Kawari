using Kawari.Encounters;
// 复乐园 [40319]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Sequence05ParadiseRegained
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(40319, TimeSpan.FromSeconds(3.7), new Params { ["spell"] = 40319, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 1.51718, ["target"] = ActorDefinitions.Boss }); }, order: 303);
        raid.Schedule(TimeSpan.FromSeconds(0.141), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper03)?.SetPosition(new Position(110.6066, 0.0, 110.6066), 0.78536); }, order: 304);
        raid.Schedule(TimeSpan.FromSeconds(0.141), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper06)?.SetPosition(new Position(100.0, 0.0, 120.0), -5e-05); }, order: 305);
        raid.Schedule(TimeSpan.FromSeconds(0.216), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper03)?.ExecuteAction(40309, new Params { ["pos"] = new Position(110.6066, 0.0, 110.6066), ["rotation"] = 0.78536, ["target"] = ActorDefinitions.Helper03 }); }, order: 306);
        raid.Schedule(TimeSpan.FromSeconds(0.216), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper06)?.ExecuteAction(40308, new Params { ["pos"] = new Position(100.0, 0.0, 120.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper06 }); }, order: 307);
        raid.Schedule(TimeSpan.FromSeconds(2.17), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper03)?.SetPosition(new Position(114.1421, 0.0, 114.1422), 0.78536); }, order: 308);
        raid.Schedule(TimeSpan.FromSeconds(2.241), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper03)?.ExecuteAction(40309, new Params { ["pos"] = new Position(114.1421, 0.0, 114.1422), ["rotation"] = 0.78536, ["target"] = ActorDefinitions.Helper03 }); }, order: 309);
        raid.Schedule(TimeSpan.FromSeconds(4.013), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(40319, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 1.51718, ["target"] = ActorDefinitions.Boss }); }, order: 310);
        raid.Schedule(TimeSpan.FromSeconds(7.064), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetModelState(4); }, order: 315);
    }
}
