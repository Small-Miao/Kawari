using Kawari.Encounters;
// 二选一的灾祟 [49743]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Sequence08Catastrophe
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(49743, TimeSpan.FromSeconds(4.0), new Params { ["spell"] = 49743, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Boss }); }, order: 235);
        raid.Schedule(TimeSpan.FromSeconds(4.273), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(49743, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Boss }); }, order: 236);
        raid.Schedule(TimeSpan.FromSeconds(4.9), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(47941, new Params { ["pos"] = new Position(103.4202, 0.0, 90.6031), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper13 }); }, order: 241);
        raid.Schedule(TimeSpan.FromSeconds(4.9), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(47941, new Params { ["pos"] = new Position(108.6603, 0.0, 95.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper14 }); }, order: 242);
        raid.Schedule(TimeSpan.FromSeconds(4.9), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(47939, new Params { ["pos"] = new Position(91.3397, 0.0, 95.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper16 }); }, order: 243);
        raid.Schedule(TimeSpan.FromSeconds(4.9), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(47940, new Params { ["pos"] = new Position(93.5721, 0.0, 107.6604), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper15 }); }, order: 244);
        raid.Schedule(TimeSpan.FromSeconds(5.022), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.14159); }, order: 245);
        raid.Schedule(TimeSpan.FromSeconds(5.085), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(47947, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Helper12 }); }, order: 246);
    }
}
