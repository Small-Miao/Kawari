using Kawari.Encounters;
// 无尽顿悟剑 [28206]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.r1fz;
public static class Sequence11Enrage
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(28206, TimeSpan.FromSeconds(9.7), new Params { ["spell"] = 28206, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -1.59004, ["target"] = ActorDefinitions.Boss }); }, order: 1049);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.TryCast(29456, TimeSpan.FromSeconds(10.4), new Params { ["spell"] = 29456, ["omen_delay"] = 20, ["cast_pos"] = new Position(95.8419, -0.0153, 106.8284), ["pos"] = new Position(95.8676, 0.0, 106.8501), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper08 }); }, order: 1050);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.TryCast(29455, TimeSpan.FromSeconds(10.4), new Params { ["spell"] = 29455, ["omen_delay"] = 10, ["cast_pos"] = new Position(96.1166, -0.0153, 92.9732), ["pos"] = new Position(96.1338, 0.0, 92.9962), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper09 }); }, order: 1051);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.TryCast(29457, TimeSpan.FromSeconds(10.4), new Params { ["spell"] = 29457, ["omen_delay"] = 30, ["cast_pos"] = new Position(107.9881, -0.0153, 100.145), ["pos"] = new Position(107.9985, 0.0, 100.1537), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper10 }); }, order: 1052);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -1.59004); }, order: 1053);
    }
}
