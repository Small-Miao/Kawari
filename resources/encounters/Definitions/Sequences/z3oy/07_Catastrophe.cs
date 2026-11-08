using Kawari.Encounters;
// 二选一的灾祟 [49743]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Sequence07Catastrophe
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(49743, TimeSpan.FromSeconds(4.0), new Params { ["spell"] = 49743, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Boss }); }, order: 196);
        raid.Schedule(TimeSpan.FromSeconds(4.302), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(49743, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Boss }); }, order: 197);
        raid.Schedule(TimeSpan.FromSeconds(4.87), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetPosition(new Position(90.1519, 0.0, 101.7365), -5e-05); }, order: 202);
        raid.Schedule(TimeSpan.FromSeconds(4.87), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.SetPosition(new Position(96.5798, 0.0, 90.6031), -5e-05); }, order: 204);
        raid.Schedule(TimeSpan.FromSeconds(4.87), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(ActorDefinitions.Boss); }, order: 206);
        raid.Schedule(TimeSpan.FromSeconds(4.87), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetPosition(new Position(100.0, 0.0, 110.0), -5e-05); }, order: 207);
        raid.Schedule(TimeSpan.FromSeconds(4.87), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(ActorDefinitions.Boss); }, order: 209);
        raid.Schedule(TimeSpan.FromSeconds(4.87), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetPosition(new Position(109.8481, 0.0, 101.7365), -5e-05); }, order: 210);
        raid.Schedule(TimeSpan.FromSeconds(4.947), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(47941, new Params { ["pos"] = new Position(103.4202, 0.0, 90.6031), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper13 }); }, order: 212);
        raid.Schedule(TimeSpan.FromSeconds(4.947), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(47940, new Params { ["pos"] = new Position(106.4279, 0.0, 107.6604), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper14 }); }, order: 213);
        raid.Schedule(TimeSpan.FromSeconds(4.947), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(47939, new Params { ["pos"] = new Position(91.3397, 0.0, 95.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper16 }); }, order: 214);
        raid.Schedule(TimeSpan.FromSeconds(4.947), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(47940, new Params { ["pos"] = new Position(93.5721, 0.0, 107.6604), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper15 }); }, order: 215);
        raid.Schedule(TimeSpan.FromSeconds(5.065), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(ActorDefinitions.Boss); }, order: 216);
        raid.Schedule(TimeSpan.FromSeconds(5.065), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.14159); }, order: 217);
        raid.Schedule(TimeSpan.FromSeconds(5.129), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.ExecuteAction(47947, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Helper08 }); }, order: 218);
        raid.Schedule(TimeSpan.FromSeconds(10.861), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(91.3397, 0.0, 95.0), -5e-05); }, order: 223);
        raid.Schedule(TimeSpan.FromSeconds(10.861), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(93.5721, 0.0, 107.6604), -5e-05); }, order: 225);
        raid.Schedule(TimeSpan.FromSeconds(10.861), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(108.6603, 0.0, 95.0), -5e-05); }, order: 227);
        raid.Schedule(TimeSpan.FromSeconds(10.861), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetPosition(new Position(103.4202, 0.0, 90.6031), -5e-05); }, order: 229);
        raid.Schedule(TimeSpan.FromSeconds(10.989), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.ExecuteAction(47941, new Params { ["pos"] = new Position(109.8481, 0.0, 101.7365), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper09 }); }, order: 231);
        raid.Schedule(TimeSpan.FromSeconds(10.989), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.ExecuteAction(47940, new Params { ["pos"] = new Position(100.0, 0.0, 110.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper10 }); }, order: 232);
        raid.Schedule(TimeSpan.FromSeconds(10.989), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(47939, new Params { ["pos"] = new Position(90.1519, 0.0, 101.7365), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper12 }); }, order: 233);
        raid.Schedule(TimeSpan.FromSeconds(10.989), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.ExecuteAction(47939, new Params { ["pos"] = new Position(96.5798, 0.0, 90.6031), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper11 }); }, order: 234);
    }
}
