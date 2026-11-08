using Kawari.Encounters;
// 制导 [18571]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Sequence06OpticalSight
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(18571, TimeSpan.FromSeconds(2.7), new Params { ["spell"] = 18571, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.14092, ["target"] = ActorDefinitions.Boss }); }, order: 120);
        raid.Schedule(TimeSpan.FromSeconds(3.003), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(18571, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.14092, ["target"] = ActorDefinitions.Boss }); }, order: 121);
        raid.Schedule(TimeSpan.FromSeconds(4.887), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(19083, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.14092 }); }, order: 122);
        raid.Schedule(TimeSpan.FromSeconds(4.976), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetOwner(null); }, order: 123);
        raid.Schedule(TimeSpan.FromSeconds(4.976), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetOwner(ActorDefinitions.Boss); }, order: 124);
        raid.Schedule(TimeSpan.FromSeconds(4.976), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.SetOwner(null); }, order: 125);
        raid.Schedule(TimeSpan.FromSeconds(4.976), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.SetOwner(ActorDefinitions.Boss); }, order: 126);
        raid.Schedule(TimeSpan.FromSeconds(5.07), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.ExecuteAction(18573, new Params { ["pos"] = new Position(99.9717, 0.0, 93.2008), ["rotation"] = -3.09557 }); }, order: 127);
        raid.Schedule(TimeSpan.FromSeconds(5.07), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(18573, new Params { ["pos"] = new Position(100.0, 28.7, 44.9), ["rotation"] = -5e-05 }); }, order: 128);
    }
}
