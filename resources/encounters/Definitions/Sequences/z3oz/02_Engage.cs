using Kawari.Encounters;
// 最终本体出现：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oz;
public static class Sequence02Engage
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper28)?.SetOwner(null); }, order: 26);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper30)?.SetOwner(null); }, order: 27);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper29)?.SetOwner(null); }, order: 28);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper27)?.SetOwner(null); }, order: 29);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper31)?.SetOwner(null); }, order: 30);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper32)?.SetOwner(null); }, order: 31);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetEncounterTargetable(true); }, order: 34);
        raid.Schedule(TimeSpan.FromSeconds(0.044), () => { raid.GetObjectByGameObjectId(ActorDefinitions.BossP5)?.Destory(); }, order: 35);
        raid.Schedule(TimeSpan.FromSeconds(0.044), () => { raid.GetObjectByGameObjectId(ActorDefinitions.IntermissionOmegaF)?.Destory(); }, order: 36);
        raid.Schedule(TimeSpan.FromSeconds(0.044), () => { raid.GetObjectByGameObjectId(ActorDefinitions.IntermissionAlpha)?.Destory(); }, order: 37);
        raid.Schedule(TimeSpan.FromSeconds(1.752), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 0.06726); }, order: 38);
        raid.Schedule(TimeSpan.FromSeconds(2.097), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 0.01443); }, order: 39);
        raid.Schedule(TimeSpan.FromSeconds(2.413), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.12807); }, order: 40);
    }
}
