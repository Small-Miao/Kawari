using Kawari.Encounters;
// 静止命令 [18559]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Sequence05OrdainedStillness
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(18559, TimeSpan.FromSeconds(3.7), new Params { ["spell"] = 18559, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.11743, ["target"] = ActorDefinitions.Boss }); }, order: 86);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(18559, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.11743, ["target"] = ActorDefinitions.Boss }); }, order: 87);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetOwner(null); }, order: 88);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetOwner(ActorDefinitions.Boss); }, order: 89);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.SetOwner(null); }, order: 90);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.SetOwner(ActorDefinitions.Boss); }, order: 91);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(null); }, order: 92);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(ActorDefinitions.Boss); }, order: 93);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(null); }, order: 94);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(ActorDefinitions.Boss); }, order: 95);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(null); }, order: 96);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(ActorDefinitions.Boss); }, order: 97);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.SetOwner(null); }, order: 98);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.SetOwner(ActorDefinitions.Boss); }, order: 99);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper06)?.SetOwner(null); }, order: 100);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper06)?.SetOwner(ActorDefinitions.Boss); }, order: 101);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper05)?.SetOwner(null); }, order: 102);
        raid.Schedule(TimeSpan.FromSeconds(4.02), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper05)?.SetOwner(ActorDefinitions.Boss); }, order: 103);
        raid.Schedule(TimeSpan.FromSeconds(4.082), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.ExecuteAction(19040, new Params { ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["rotation"] = -1.14624 }); }, order: 104);
        raid.Schedule(TimeSpan.FromSeconds(4.082), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.ExecuteAction(19040, new Params { ["pos"] = new Position(110.247, 0.0, 115.6343), ["rotation"] = -1.04729 }); }, order: 105);
        raid.Schedule(TimeSpan.FromSeconds(4.082), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.ExecuteAction(19040, new Params { ["pos"] = new Position(111.0866, 0.0, 104.5922), ["rotation"] = -5e-05 }); }, order: 106);
        raid.Schedule(TimeSpan.FromSeconds(4.082), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.ExecuteAction(19040, new Params { ["pos"] = new Position(99.9717, 0.0, 93.2008), ["rotation"] = -3.09557 }); }, order: 107);
        raid.Schedule(TimeSpan.FromSeconds(4.082), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(19040, new Params { ["pos"] = new Position(100.0, 28.7, 44.9), ["rotation"] = -5e-05 }); }, order: 108);
        raid.Schedule(TimeSpan.FromSeconds(4.082), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper05)?.ExecuteAction(19040, new Params { ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["rotation"] = -1.14624 }); }, order: 109);
        raid.Schedule(TimeSpan.FromSeconds(4.082), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper06)?.ExecuteAction(19040, new Params { ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["rotation"] = -1.14624 }); }, order: 110);
        raid.Schedule(TimeSpan.FromSeconds(4.082), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.ExecuteAction(19040, new Params { ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["rotation"] = -1.14624 }); }, order: 111);
        raid.Schedule(TimeSpan.FromSeconds(6.966), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(19083, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.11743 }); }, order: 112);
        raid.Schedule(TimeSpan.FromSeconds(7.118), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.08177); }, order: 113);
        raid.Schedule(TimeSpan.FromSeconds(7.634), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.02213); }, order: 114);
        raid.Schedule(TimeSpan.FromSeconds(8.398), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.08963); }, order: 115);
        raid.Schedule(TimeSpan.FromSeconds(8.715), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.12414); }, order: 116);
        raid.Schedule(TimeSpan.FromSeconds(9.922), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.11388); }, order: 117);
        raid.Schedule(TimeSpan.FromSeconds(10.069), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(19083, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.11388 }); }, order: 118);
        raid.Schedule(TimeSpan.FromSeconds(10.883), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.14092); }, order: 119);
    }
}
