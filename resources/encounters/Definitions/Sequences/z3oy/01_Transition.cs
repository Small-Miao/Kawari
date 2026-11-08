using Kawari.Encounters;
// 木桩后转场：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Sequence01Transition
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.045), () => { raid.SpawnActor(ActorDefinitions.Boss); }, order: 1);
        raid.Schedule(TimeSpan.FromSeconds(1.018), () => { raid.GetObjectByGameObjectId(ActorDefinitions.KefkaP4)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.10746); }, order: 2);
        raid.Schedule(TimeSpan.FromSeconds(1.259), () => { raid.GetObjectByGameObjectId(ActorDefinitions.KefkaP4)?.TryCast(49738, TimeSpan.FromSeconds(4.7), new Params { ["spell"] = 49738, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.KefkaP4 }); }, order: 3);
        raid.Schedule(TimeSpan.FromSeconds(1.384), () => { raid.GetObjectByGameObjectId(ActorDefinitions.KefkaP4)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.14159); }, order: 4);
        raid.Schedule(TimeSpan.FromSeconds(6.22), () => { raid.GetObjectByGameObjectId(ActorDefinitions.KefkaP4)?.ExecuteAction(49738, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.KefkaP4 }); }, order: 5);
        raid.Schedule(TimeSpan.FromSeconds(6.22), () => { raid.GetObjectByGameObjectId(ActorDefinitions.KefkaP4)?.SetEncounterTargetable(false); }, order: 7);
        raid.Schedule(TimeSpan.FromSeconds(9.473), () => { raid.GetObjectByGameObjectId(ActorDefinitions.KefkaP4)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -0.91738); }, order: 25);
        raid.Schedule(TimeSpan.FromSeconds(9.559), () => { raid.SynchronizedTimelines(new (string, ushort)[] { (ActorDefinitions.Boss, (ushort)4561), (ActorDefinitions.KefkaP4, (ushort)4579) }); }, order: 26);
        raid.Schedule(TimeSpan.FromSeconds(9.777), () => { raid.GetObjectByGameObjectId(ActorDefinitions.KefkaP4)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -5e-05); }, order: 27);
        raid.Schedule(TimeSpan.FromSeconds(37.049), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper03)?.SetOwner(null); }, order: 32);
        raid.Schedule(TimeSpan.FromSeconds(37.049), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper04)?.SetOwner(null); }, order: 33);
        raid.Schedule(TimeSpan.FromSeconds(37.049), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper05)?.SetOwner(null); }, order: 34);
        raid.Schedule(TimeSpan.FromSeconds(37.049), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper06)?.SetOwner(null); }, order: 35);
        raid.Schedule(TimeSpan.FromSeconds(37.049), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.SetOwner(null); }, order: 36);
        raid.Schedule(TimeSpan.FromSeconds(37.049), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(null); }, order: 37);
        raid.Schedule(TimeSpan.FromSeconds(37.11), () => { raid.GetObjectByGameObjectId(ActorDefinitions.KefkaP4)?.Destory(); }, order: 38);
    }
}
