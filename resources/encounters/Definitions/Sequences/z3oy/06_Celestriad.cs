using Kawari.Encounters;
// 三星 [47938]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Sequence06Celestriad
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(47938, TimeSpan.FromSeconds(4.7), new Params { ["spell"] = 47938, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Boss }); }, order: 177);
        raid.Schedule(TimeSpan.FromSeconds(4.997), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(47938, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Boss }); }, order: 178);
        raid.Schedule(TimeSpan.FromSeconds(8.043), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(91.3397, 0.0, 95.0), -5e-05); }, order: 188);
        raid.Schedule(TimeSpan.FromSeconds(8.043), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(93.5721, 0.0, 107.6604), -5e-05); }, order: 190);
        raid.Schedule(TimeSpan.FromSeconds(8.043), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(106.4279, 0.0, 107.6604), -5e-05); }, order: 192);
        raid.Schedule(TimeSpan.FromSeconds(8.043), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetPosition(new Position(103.4202, 0.0, 90.6031), -5e-05); }, order: 194);
    }
}
