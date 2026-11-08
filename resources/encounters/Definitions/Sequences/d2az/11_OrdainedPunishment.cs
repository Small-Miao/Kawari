using Kawari.Encounters;
// 诛罚 [18577]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Sequence11OrdainedPunishment
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(18577, TimeSpan.FromSeconds(4.7), new Params { ["spell"] = 18577, ["omen_delay"] = 0, ["cast_pos"] = new Position(100.1144, -0.0153, 89.5552), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.12999 }); }, order: 456);
        raid.Schedule(TimeSpan.FromSeconds(0.037), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(18579, new Params { ["pos"] = new Position(105.9155, 1.7502, 84.1014), ["rotation"] = -1.04931 }); }, order: 457);
        raid.Schedule(TimeSpan.FromSeconds(1.127), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(18579, new Params { ["pos"] = new Position(105.9155, 1.7502, 84.1014), ["rotation"] = -1.04931 }); }, order: 458);
        raid.Schedule(TimeSpan.FromSeconds(5.009), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(18577, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.12999 }); }, order: 459);
        raid.Schedule(TimeSpan.FromSeconds(8.126), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(19083, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.12999 }); }, order: 460);
        raid.Schedule(TimeSpan.FromSeconds(8.126), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.08292); }, order: 461);
        raid.Schedule(TimeSpan.FromSeconds(11.092), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(19083, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.06547 }); }, order: 462);
        raid.Schedule(TimeSpan.FromSeconds(12.398), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(18581, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.06547, ["dest"] = new Position(99.9924, -0.0153, 99.9924) }); }, order: 463);
        raid.Schedule(TimeSpan.FromSeconds(12.998), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.06547); }, order: 464);
        raid.Schedule(TimeSpan.FromSeconds(14.892), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -1.38161); }, order: 465);
    }
}
