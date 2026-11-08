using Kawari.Encounters;
// 时空干涉 [18582]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Sequence22TemporalInterference
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(18582, TimeSpan.FromSeconds(4.7), new Params { ["spell"] = 18582, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Boss }); }, order: 1373);
        raid.Schedule(TimeSpan.FromSeconds(0.117), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -5e-05); }, order: 1374);
        raid.Schedule(TimeSpan.FromSeconds(5.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(18582, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Boss }); }, order: 1375);
        raid.Schedule(TimeSpan.FromSeconds(6.202), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetModelState(4); }, order: 1376);
    }
}
