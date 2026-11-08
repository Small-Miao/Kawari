using Kawari.Encounters;
// 复乐园 [40319]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Sequence14ParadiseRegained
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(40319, TimeSpan.FromSeconds(3.7), new Params { ["spell"] = 40319, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 0.08691, ["target"] = ActorDefinitions.Boss }); }, order: 1231);
        raid.Schedule(TimeSpan.FromSeconds(3.961), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(40319, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 0.08691, ["target"] = ActorDefinitions.Boss }); }, order: 1232);
        raid.Schedule(TimeSpan.FromSeconds(7.076), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetModelState(4); }, order: 1236);
    }
}
