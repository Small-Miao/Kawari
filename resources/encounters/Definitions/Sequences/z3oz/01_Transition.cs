using Kawari.Encounters;
// 木桩后转场：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oz;
public static class Sequence01Transition
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.193), () => { raid.GetObjectByGameObjectId(ActorDefinitions.BossP5)?.ExecuteAction(31555, new Params { ["pos"] = new Position(98.9853, 0.0153, 98.0087), ["rotation"] = 0.46226, ["dest"] = new Position(99.9924, -0.0153, 99.9924) }); }, order: 2);
        raid.Schedule(TimeSpan.FromSeconds(0.258), () => { raid.GetObjectByGameObjectId(ActorDefinitions.BossP5)?.SetPosition(new Position(98.9853, 0.0153, 98.0087), 0.46226); }, order: 3);
        raid.Schedule(TimeSpan.FromSeconds(0.516), () => { raid.SpawnActor(ActorDefinitions.Boss); }, order: 4);
        raid.Schedule(TimeSpan.FromSeconds(0.516), () => { raid.SpawnActor(ActorDefinitions.IntermissionAlpha); }, order: 5);
        raid.Schedule(TimeSpan.FromSeconds(0.516), () => { raid.SpawnActor(ActorDefinitions.IntermissionOmegaF); }, order: 6);
        raid.Schedule(TimeSpan.FromSeconds(0.97), () => { raid.GetObjectByGameObjectId(ActorDefinitions.BossP5)?.SetPosition(new Position(99.9924, 0.0458, 99.9924), 0.46226); }, order: 7);
        raid.Schedule(TimeSpan.FromSeconds(1.4), () => { raid.GetObjectByGameObjectId(ActorDefinitions.BossP5)?.TryCast(31623, TimeSpan.FromSeconds(9.7), new Params { ["spell"] = 31623, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, 0.0458, 99.9924), ["pos"] = new Position(99.9924, 0.0458, 99.9924), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.BossP5 }); }, order: 8);
        raid.Schedule(TimeSpan.FromSeconds(1.465), () => { raid.GetObjectByGameObjectId(ActorDefinitions.BossP5)?.SetPosition(new Position(99.9924, 0.0458, 99.9924), -5e-05); }, order: 9);
        raid.Schedule(TimeSpan.FromSeconds(11.367), () => { raid.GetObjectByGameObjectId(ActorDefinitions.BossP5)?.ExecuteAction(31623, new Params { ["pos"] = new Position(99.9924, 0.0458, 99.9924), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.BossP5 }); }, order: 10);
        raid.Schedule(TimeSpan.FromSeconds(11.367), () => { raid.GetObjectByGameObjectId(ActorDefinitions.BossP5)?.SetEncounterTargetable(false); }, order: 11);
        raid.Schedule(TimeSpan.FromSeconds(11.367), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper32)?.SetOwner(null); }, order: 12);
        raid.Schedule(TimeSpan.FromSeconds(11.367), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper32)?.SetOwner(ActorDefinitions.BossP5); }, order: 13);
        raid.Schedule(TimeSpan.FromSeconds(11.367), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper32)?.SetPosition(new Position(100.0, 0.0732, 100.0), -5e-05); }, order: 14);
        raid.Schedule(TimeSpan.FromSeconds(11.452), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper32)?.TryCast(32626, TimeSpan.FromSeconds(0.9), new Params { ["spell"] = 32626, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, 0.0458, 99.9924), ["pos"] = new Position(100.0, 0.0732, 100.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper32 }); }, order: 15);
        raid.Schedule(TimeSpan.FromSeconds(12.676), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper32)?.ExecuteAction(32626, new Params { ["pos"] = new Position(100.0, 0.0732, 100.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper32 }); }, order: 16);
        raid.Schedule(TimeSpan.FromSeconds(14.17), () => { raid.SynchronizedTimelines(new (string, ushort)[] { (ActorDefinitions.IntermissionOmegaF, (ushort)4574), (ActorDefinitions.IntermissionAlpha, (ushort)4573), (ActorDefinitions.Boss, (ushort)4561) }); }, order: 18);
    }
}
