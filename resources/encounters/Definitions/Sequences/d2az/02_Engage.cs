using Kawari.Encounters;
// 最终本体出现：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Sequence02Engage
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetEncounterTargetable(true); }, order: 51);
        raid.Schedule(TimeSpan.FromSeconds(0.15), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -1.68391); }, order: 52);
        raid.Schedule(TimeSpan.FromSeconds(0.217), () => { raid.SpawnActor(ActorDefinitions.PerfectAlexander02); }, order: 53);
        raid.Schedule(TimeSpan.FromSeconds(0.217), () => { raid.SpawnActor(ActorDefinitions.PerfectAlexander03); }, order: 54);
        raid.Schedule(TimeSpan.FromSeconds(0.217), () => { raid.SpawnActor(ActorDefinitions.PerfectAlexander05); }, order: 55);
        raid.Schedule(TimeSpan.FromSeconds(0.217), () => { raid.SpawnActor(ActorDefinitions.PerfectAlexander04); }, order: 56);
        raid.Schedule(TimeSpan.FromSeconds(0.433), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -2.14545); }, order: 57);
        raid.Schedule(TimeSpan.FromSeconds(0.799), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 0.09132); }, order: 58);
        raid.Schedule(TimeSpan.FromSeconds(1.067), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.07659); }, order: 59);
        raid.Schedule(TimeSpan.FromSeconds(1.367), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.12424); }, order: 60);
        raid.Schedule(TimeSpan.FromSeconds(5.067), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(19083, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.11743 }); }, order: 61);
        raid.Schedule(TimeSpan.FromSeconds(8.102), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(19083, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.11743 }); }, order: 62);
    }
}
