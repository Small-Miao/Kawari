using Kawari.Encounters;
// 行动命令 [18558]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Sequence04OrdainedMotion
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(18558, TimeSpan.FromSeconds(3.7), new Params { ["spell"] = 18558, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.11743, ["target"] = ActorDefinitions.Boss }); }, order: 66);
        raid.Schedule(TimeSpan.FromSeconds(3.946), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(18558, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.11743, ["target"] = ActorDefinitions.Boss }); }, order: 67);
        raid.Schedule(TimeSpan.FromSeconds(3.946), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetOwner(null); }, order: 68);
        raid.Schedule(TimeSpan.FromSeconds(3.946), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetOwner(ActorDefinitions.Boss); }, order: 69);
        raid.Schedule(TimeSpan.FromSeconds(3.946), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.SetOwner(ActorDefinitions.Boss); }, order: 70);
        raid.Schedule(TimeSpan.FromSeconds(3.946), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(ActorDefinitions.Boss); }, order: 71);
        raid.Schedule(TimeSpan.FromSeconds(3.946), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(ActorDefinitions.Boss); }, order: 72);
        raid.Schedule(TimeSpan.FromSeconds(3.946), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(ActorDefinitions.Boss); }, order: 73);
        raid.Schedule(TimeSpan.FromSeconds(3.946), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.SetOwner(ActorDefinitions.Boss); }, order: 74);
        raid.Schedule(TimeSpan.FromSeconds(3.946), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper06)?.SetOwner(ActorDefinitions.Boss); }, order: 75);
        raid.Schedule(TimeSpan.FromSeconds(3.946), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper05)?.SetOwner(ActorDefinitions.Boss); }, order: 76);
        raid.Schedule(TimeSpan.FromSeconds(4.031), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.ExecuteAction(19039, new Params { ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["rotation"] = -1.14624 }); }, order: 77);
        raid.Schedule(TimeSpan.FromSeconds(4.031), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.ExecuteAction(19039, new Params { ["pos"] = new Position(110.247, 0.0, 115.6343), ["rotation"] = -1.04729 }); }, order: 78);
        raid.Schedule(TimeSpan.FromSeconds(4.031), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.ExecuteAction(19039, new Params { ["pos"] = new Position(111.0866, 0.0, 104.5922), ["rotation"] = -5e-05 }); }, order: 79);
        raid.Schedule(TimeSpan.FromSeconds(4.031), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.ExecuteAction(19039, new Params { ["pos"] = new Position(99.9717, 0.0, 93.2008), ["rotation"] = -3.09557 }); }, order: 80);
        raid.Schedule(TimeSpan.FromSeconds(4.031), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(19039, new Params { ["pos"] = new Position(100.0, 28.7, 44.9), ["rotation"] = -5e-05 }); }, order: 81);
        raid.Schedule(TimeSpan.FromSeconds(4.031), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper05)?.ExecuteAction(19039, new Params { ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["rotation"] = -1.14624 }); }, order: 82);
        raid.Schedule(TimeSpan.FromSeconds(4.031), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper06)?.ExecuteAction(19039, new Params { ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["rotation"] = -1.14624 }); }, order: 83);
        raid.Schedule(TimeSpan.FromSeconds(4.031), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.ExecuteAction(19039, new Params { ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["rotation"] = -1.14624 }); }, order: 84);
        raid.Schedule(TimeSpan.FromSeconds(11.031), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(19083, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.11743 }); }, order: 85);
    }
}
