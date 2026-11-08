using Kawari.Encounters;
// 制导 [18570]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Sequence07OpticalSight
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(18570, TimeSpan.FromSeconds(2.7), new Params { ["spell"] = 18570, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.14092, ["target"] = ActorDefinitions.Boss }); }, order: 129);
        raid.Schedule(TimeSpan.FromSeconds(3.011), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(18570, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.14092, ["target"] = ActorDefinitions.Boss }); }, order: 130);
        raid.Schedule(TimeSpan.FromSeconds(4.828), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(19083, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.14092 }); }, order: 131);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetOwner(null); }, order: 132);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetOwner(ActorDefinitions.Boss); }, order: 133);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.SetOwner(null); }, order: 134);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.SetOwner(ActorDefinitions.Boss); }, order: 135);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(null); }, order: 136);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(ActorDefinitions.Boss); }, order: 137);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(null); }, order: 138);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(ActorDefinitions.Boss); }, order: 139);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(null); }, order: 140);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(ActorDefinitions.Boss); }, order: 141);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.SetOwner(null); }, order: 142);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.SetOwner(ActorDefinitions.Boss); }, order: 143);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper06)?.SetOwner(null); }, order: 144);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper06)?.SetOwner(ActorDefinitions.Boss); }, order: 145);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper05)?.SetOwner(null); }, order: 146);
        raid.Schedule(TimeSpan.FromSeconds(5.012), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper05)?.SetOwner(ActorDefinitions.Boss); }, order: 147);
        raid.Schedule(TimeSpan.FromSeconds(5.078), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.ExecuteAction(18572, new Params { ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["rotation"] = -1.14624 }); }, order: 148);
        raid.Schedule(TimeSpan.FromSeconds(5.078), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.ExecuteAction(18572, new Params { ["pos"] = new Position(110.247, 0.0, 115.6343), ["rotation"] = -1.04729 }); }, order: 149);
        raid.Schedule(TimeSpan.FromSeconds(5.078), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.ExecuteAction(18572, new Params { ["pos"] = new Position(111.0866, 0.0, 104.5922), ["rotation"] = -5e-05 }); }, order: 150);
        raid.Schedule(TimeSpan.FromSeconds(5.078), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.ExecuteAction(18572, new Params { ["pos"] = new Position(99.9717, 0.0, 93.2008), ["rotation"] = -3.09557 }); }, order: 151);
        raid.Schedule(TimeSpan.FromSeconds(5.078), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(18572, new Params { ["pos"] = new Position(100.0, 28.7, 44.9), ["rotation"] = -5e-05 }); }, order: 152);
        raid.Schedule(TimeSpan.FromSeconds(5.078), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper05)?.ExecuteAction(18572, new Params { ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["rotation"] = -1.14624 }); }, order: 153);
        raid.Schedule(TimeSpan.FromSeconds(5.078), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper06)?.ExecuteAction(18572, new Params { ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["rotation"] = -1.14624 }); }, order: 154);
        raid.Schedule(TimeSpan.FromSeconds(5.078), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.ExecuteAction(18572, new Params { ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["rotation"] = -1.14624 }); }, order: 155);
        raid.Schedule(TimeSpan.FromSeconds(6.145), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.06739); }, order: 156);
        raid.Schedule(TimeSpan.FromSeconds(7.61), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.10085); }, order: 157);
        raid.Schedule(TimeSpan.FromSeconds(7.86), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(19083, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.11849 }); }, order: 158);
        raid.Schedule(TimeSpan.FromSeconds(7.928), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.11849); }, order: 159);
        raid.Schedule(TimeSpan.FromSeconds(10.195), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(18581, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.11849, ["dest"] = new Position(99.9924, -0.0153, 99.9924) }); }, order: 160);
        raid.Schedule(TimeSpan.FromSeconds(10.928), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.11849); }, order: 161);
        raid.Schedule(TimeSpan.FromSeconds(12.813), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 1.43453); }, order: 162);
    }
}
