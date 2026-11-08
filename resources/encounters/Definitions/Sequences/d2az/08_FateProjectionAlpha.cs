using Kawari.Encounters;
// 未来观测α [18555]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Sequence08FateProjectionAlpha
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(18555, TimeSpan.FromSeconds(4.7), new Params { ["spell"] = 18555, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Boss }); }, order: 163);
        raid.Schedule(TimeSpan.FromSeconds(0.132), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -5e-05); }, order: 164);
        raid.Schedule(TimeSpan.FromSeconds(5.065), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(18555, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Boss }); }, order: 165);
        raid.Schedule(TimeSpan.FromSeconds(6.18), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander05)?.SetPosition(new Position(78.2888, 0.0, 91.0069), 1.17807); }, order: 166);
        raid.Schedule(TimeSpan.FromSeconds(6.18), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander04)?.SetPosition(new Position(91.0069, 0.0, 78.2888), 0.39266); }, order: 167);
        raid.Schedule(TimeSpan.FromSeconds(6.18), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander03)?.SetPosition(new Position(108.9931, 0.0, 78.2888), -0.39275); }, order: 168);
        raid.Schedule(TimeSpan.FromSeconds(6.18), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander02)?.SetPosition(new Position(121.7112, 0.0, 91.0069), -1.17816); }, order: 169);
        raid.Schedule(TimeSpan.FromSeconds(6.198), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetModelState(4); }, order: 174);
        raid.Schedule(TimeSpan.FromSeconds(6.248), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander02)?.PlayTimeline(7747); }, order: 175);
        raid.Schedule(TimeSpan.FromSeconds(6.248), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander03)?.PlayTimeline(7747); }, order: 176);
        raid.Schedule(TimeSpan.FromSeconds(6.248), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander04)?.PlayTimeline(7747); }, order: 177);
        raid.Schedule(TimeSpan.FromSeconds(6.248), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexander05)?.PlayTimeline(7747); }, order: 178);
        raid.Schedule(TimeSpan.FromSeconds(6.447), () => { raid.SpawnActor(ActorDefinitions.FateProjection02); }, order: 179);
        raid.Schedule(TimeSpan.FromSeconds(6.447), () => { raid.SpawnActor(ActorDefinitions.FateProjection01); }, order: 180);
        raid.Schedule(TimeSpan.FromSeconds(6.447), () => { raid.SpawnActor(ActorDefinitions.FateProjection04); }, order: 181);
        raid.Schedule(TimeSpan.FromSeconds(6.447), () => { raid.SpawnActor(ActorDefinitions.FateProjection03); }, order: 182);
        raid.Schedule(TimeSpan.FromSeconds(6.447), () => { raid.SpawnActor(ActorDefinitions.FateProjection07); }, order: 183);
        raid.Schedule(TimeSpan.FromSeconds(6.447), () => { raid.SpawnActor(ActorDefinitions.FateProjection05); }, order: 184);
        raid.Schedule(TimeSpan.FromSeconds(6.447), () => { raid.SpawnActor(ActorDefinitions.FateProjection06); }, order: 185);
        raid.Schedule(TimeSpan.FromSeconds(6.447), () => { raid.SpawnActor(ActorDefinitions.FateProjection08); }, order: 186);
    }
}
