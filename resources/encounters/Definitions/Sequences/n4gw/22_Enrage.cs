using Kawari.Encounters;
// 失乐园 [40327]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Sequence22Enrage
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(40327, TimeSpan.FromSeconds(11.7), new Params { ["spell"] = 40327, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -2.94754, ["target"] = ActorDefinitions.Boss }); }, order: 2100);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.TryCast(40328, TimeSpan.FromSeconds(21.2), new Params { ["spell"] = 40328, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -2.94754, ["target"] = ActorDefinitions.Helper14 }); }, order: 2101);
        raid.Schedule(TimeSpan.FromSeconds(11.996), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(40327, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -2.94754, ["target"] = ActorDefinitions.Boss }); }, order: 2104);
    }
}
