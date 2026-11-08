using Kawari.Encounters;
// 最终本体出现：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.r1fz;
public static class Sequence02Engage
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetEncounterTargetable(true); }, order: 95);
        raid.Schedule(TimeSpan.FromSeconds(0.147), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.PlayTimeline(7747); }, order: 97);
        raid.Schedule(TimeSpan.FromSeconds(1.268), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 1.10578); }, order: 98);
        raid.Schedule(TimeSpan.FromSeconds(1.568), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.12922); }, order: 99);
        raid.Schedule(TimeSpan.FromSeconds(2.317), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.12405); }, order: 100);
        raid.Schedule(TimeSpan.FromSeconds(4.199), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(null); }, order: 102);
        raid.Schedule(TimeSpan.FromSeconds(4.199), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(ActorDefinitions.Boss); }, order: 103);
        raid.Schedule(TimeSpan.FromSeconds(4.199), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetPosition(new Position(100.1167, 0.0, 107.9991), -0.77089); }, order: 104);
        raid.Schedule(TimeSpan.FromSeconds(4.199), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(ActorDefinitions.Boss); }, order: 105);
        raid.Schedule(TimeSpan.FromSeconds(4.199), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetPosition(new Position(106.8691, 0.0, 95.8994), -1.5563); }, order: 106);
        raid.Schedule(TimeSpan.FromSeconds(4.199), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(ActorDefinitions.Boss); }, order: 107);
        raid.Schedule(TimeSpan.FromSeconds(4.199), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetPosition(new Position(93.0142, 0.0, 96.1015), 1.58535); }, order: 108);
    }
}
