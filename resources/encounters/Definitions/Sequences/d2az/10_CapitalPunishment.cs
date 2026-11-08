using Kawari.Encounters;
// 加重诛罚 [18578]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Sequence10CapitalPunishment
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(18578, TimeSpan.FromSeconds(2.7), new Params { ["spell"] = 18578, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.12999, ["target"] = ActorDefinitions.Boss }); }, order: 451);
        raid.Schedule(TimeSpan.FromSeconds(2.982), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(18578, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.12999, ["target"] = ActorDefinitions.Boss }); }, order: 452);
        raid.Schedule(TimeSpan.FromSeconds(6.07), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetOwner(null); }, order: 453);
        raid.Schedule(TimeSpan.FromSeconds(6.07), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetOwner(ActorDefinitions.Boss); }, order: 454);
        raid.Schedule(TimeSpan.FromSeconds(6.135), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(18579, new Params { ["pos"] = new Position(105.9155, 1.7502, 84.1014), ["rotation"] = -1.04931 }); }, order: 455);
    }
}
