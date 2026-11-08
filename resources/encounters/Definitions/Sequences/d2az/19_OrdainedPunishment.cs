using Kawari.Encounters;
// 诛罚 [18577]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Sequence19OrdainedPunishment
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(18577, TimeSpan.FromSeconds(4.7), new Params { ["spell"] = 18577, ["omen_delay"] = 0, ["cast_pos"] = new Position(100.0534, -0.0153, 91.6609), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.13153 }); }, order: 1115);
        raid.Schedule(TimeSpan.FromSeconds(0.037), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(18579, new Params { ["pos"] = new Position(84.0, 0.0, 84.0), ["rotation"] = -5e-05 }); }, order: 1116);
        raid.Schedule(TimeSpan.FromSeconds(1.093), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(18579, new Params { ["pos"] = new Position(84.0, 0.0, 84.0), ["rotation"] = -5e-05 }); }, order: 1117);
        raid.Schedule(TimeSpan.FromSeconds(4.995), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(18577, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.13153 }); }, order: 1118);
    }
}
