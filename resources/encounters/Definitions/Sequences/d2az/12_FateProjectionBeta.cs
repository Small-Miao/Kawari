using Kawari.Encounters;
// 未来观测β [19219]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Sequence12FateProjectionBeta
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(19219, TimeSpan.FromSeconds(4.7), new Params { ["spell"] = 19219, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Boss }); }, order: 466);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -5e-05); }, order: 467);
        raid.Schedule(TimeSpan.FromSeconds(4.701), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(19219, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Boss }); }, order: 468);
        raid.Schedule(TimeSpan.FromSeconds(5.816), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander05)?.SetPosition(new Position(121.7112, 0.0, 91.0069), -1.17816); }, order: 469);
        raid.Schedule(TimeSpan.FromSeconds(5.816), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander04)?.SetPosition(new Position(108.9931, 0.0, 78.2888), -0.39275); }, order: 470);
        raid.Schedule(TimeSpan.FromSeconds(5.816), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander03)?.SetPosition(new Position(78.2888, 0.0, 91.0069), 1.17807); }, order: 471);
        raid.Schedule(TimeSpan.FromSeconds(5.816), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander02)?.SetPosition(new Position(91.0069, 0.0, 78.2888), 0.39266); }, order: 472);
        raid.Schedule(TimeSpan.FromSeconds(5.849), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetModelState(4); }, order: 477);
        raid.Schedule(TimeSpan.FromSeconds(5.9), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander02)?.PlayTimeline(7747); }, order: 478);
        raid.Schedule(TimeSpan.FromSeconds(5.9), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander03)?.PlayTimeline(7747); }, order: 479);
        raid.Schedule(TimeSpan.FromSeconds(5.9), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander04)?.PlayTimeline(7747); }, order: 480);
        raid.Schedule(TimeSpan.FromSeconds(5.9), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander05)?.PlayTimeline(7747); }, order: 481);
        raid.Schedule(TimeSpan.FromSeconds(6.234), () => { raid.SpawnActor(ActorDefinitions.FateProjection09); }, order: 482);
        raid.Schedule(TimeSpan.FromSeconds(6.234), () => { raid.SpawnActor(ActorDefinitions.FateProjection10); }, order: 483);
        raid.Schedule(TimeSpan.FromSeconds(6.234), () => { raid.SpawnActor(ActorDefinitions.FateProjection11); }, order: 484);
        raid.Schedule(TimeSpan.FromSeconds(6.234), () => { raid.SpawnActor(ActorDefinitions.FateProjection12); }, order: 485);
        raid.Schedule(TimeSpan.FromSeconds(6.234), () => { raid.SpawnActor(ActorDefinitions.FateProjection13); }, order: 486);
        raid.Schedule(TimeSpan.FromSeconds(6.234), () => { raid.SpawnActor(ActorDefinitions.FateProjection14); }, order: 487);
        raid.Schedule(TimeSpan.FromSeconds(6.234), () => { raid.SpawnActor(ActorDefinitions.FateProjection15); }, order: 488);
        raid.Schedule(TimeSpan.FromSeconds(6.234), () => { raid.SpawnActor(ActorDefinitions.FateProjection16); }, order: 489);
    }
}
