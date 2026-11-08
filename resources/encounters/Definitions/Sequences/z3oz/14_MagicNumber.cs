using Kawari.Encounters;
// 魔数 [31670]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oz;
public static class Sequence14MagicNumber
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(31670, TimeSpan.FromSeconds(4.7), new Params { ["spell"] = 31670, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Boss }); }, order: 1895);
        raid.Schedule(TimeSpan.FromSeconds(4.978), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(31670, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Boss }); }, order: 1896);
    }
}
