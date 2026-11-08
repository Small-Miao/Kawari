using Kawari.Encounters;
// 诛罚 [18577]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Sequence15OrdainedPunishment
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(18577, TimeSpan.FromSeconds(4.7), new Params { ["spell"] = 18577, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9008, -0.0153, 92.4849), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.12884 }); }, order: 843);
        raid.Schedule(TimeSpan.FromSeconds(0.036), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(18579, new Params { ["pos"] = new Position(105.9155, 1.7502, 84.1014), ["rotation"] = -1.04931 }); }, order: 844);
        raid.Schedule(TimeSpan.FromSeconds(1.123), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(18579, new Params { ["pos"] = new Position(105.9155, 1.7502, 84.1014), ["rotation"] = -1.04931 }); }, order: 845);
        raid.Schedule(TimeSpan.FromSeconds(5.001), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(18577, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.12884 }); }, order: 846);
        raid.Schedule(TimeSpan.FromSeconds(8.067), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(19083, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.12884 }); }, order: 847);
        raid.Schedule(TimeSpan.FromSeconds(8.29), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.09461); }, order: 848);
        raid.Schedule(TimeSpan.FromSeconds(9.733), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.14111); }, order: 849);
        raid.Schedule(TimeSpan.FromSeconds(10.016), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.11216); }, order: 850);
        raid.Schedule(TimeSpan.FromSeconds(11.083), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(19083, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.11216 }); }, order: 851);
    }
}
