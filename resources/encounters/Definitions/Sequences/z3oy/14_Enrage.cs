using Kawari.Encounters;
// 遗弃末点 [47930]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Sequence14Enrage
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(47930, TimeSpan.FromSeconds(25.7), new Params { ["spell"] = 47930, ["omen_delay"] = 0, ["cast_pos"] = new Position(95.7809, 0.0458, 100.206), ["pos"] = new Position(95.7809, 0.0458, 100.206), ["rotation"] = -1.21565, ["target"] = ActorDefinitions.Boss }); }, order: 614);
    }
}
