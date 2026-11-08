using Kawari.Encounters;
// 终审判决 [18557]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Sequence03FinalWord
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(18557, TimeSpan.FromSeconds(3.7), new Params { ["spell"] = 18557, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.11743, ["target"] = ActorDefinitions.Boss }); }, order: 63);
        raid.Schedule(TimeSpan.FromSeconds(3.987), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(18557, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.11743, ["target"] = ActorDefinitions.Boss }); }, order: 64);
        raid.Schedule(TimeSpan.FromSeconds(4.964), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(19083, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.11743 }); }, order: 65);
    }
}
