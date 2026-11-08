using Kawari.Encounters;
// 木桩后转场：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Sequence01Transition
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.09), () => { raid.GetObjectByGameObjectId(ActorDefinitions.AlexanderPrime)?.ExecuteAction(18553, new Params { ["pos"] = new Position(100.0, 0.0, 88.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.AlexanderPrime }); }, order: 1);
        raid.Schedule(TimeSpan.FromSeconds(0.807), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetOwner(null); }, order: 2);
        raid.Schedule(TimeSpan.FromSeconds(0.807), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetOwner(ActorDefinitions.Alexander); }, order: 3);
        raid.Schedule(TimeSpan.FromSeconds(0.807), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetPosition(new Position(100.0, 28.7, 44.9), -5e-05); }, order: 4);
        raid.Schedule(TimeSpan.FromSeconds(0.857), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.TryCast(19034, TimeSpan.FromSeconds(4.7), new Params { ["spell"] = 19034, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(100.0, 28.7, 44.9), ["rotation"] = -3.14159 }); }, order: 5);
        raid.Schedule(TimeSpan.FromSeconds(2.109), () => { raid.GetObjectByGameObjectId(ActorDefinitions.BruteJustice)?.Untether(0, 0); }, order: 6);
        raid.Schedule(TimeSpan.FromSeconds(2.109), () => { raid.GetObjectByGameObjectId(ActorDefinitions.CruiseChaser)?.Untether(0, 0); }, order: 7);
        raid.Schedule(TimeSpan.FromSeconds(2.109), () => { raid.GetObjectByGameObjectId(ActorDefinitions.AlexanderPrime)?.SetEncounterTargetable(false); }, order: 8);
        raid.Schedule(TimeSpan.FromSeconds(2.141), () => { raid.GetObjectByGameObjectId(ActorDefinitions.AlexanderPrime)?.PlayTimeline(7737); }, order: 9);
        raid.Schedule(TimeSpan.FromSeconds(5.874), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(19034, new Params { ["pos"] = new Position(100.0, 28.7, 44.9), ["rotation"] = -5e-05, ["dest"] = new Position(99.9924, -0.0153, 99.9924) }); }, order: 10);
        raid.Schedule(TimeSpan.FromSeconds(15.556), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Alexander)?.ExecuteAction(18554, new Params { ["pos"] = new Position(109.8293, 0.0, 88.8354), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Alexander }); }, order: 11);
        raid.Schedule(TimeSpan.FromSeconds(27.666), () => { raid.GetObjectByGameObjectId(ActorDefinitions.AlexanderPrimeCutscene)?.SetPosition(new Position(100.0, 0.0, 100.0), -5e-05); }, order: 26);
        raid.Schedule(TimeSpan.FromSeconds(27.717), () => { raid.GetObjectByGameObjectId(ActorDefinitions.AlexanderPrimeCutscene)?.PlayTimeline(7747); }, order: 27);
        raid.Schedule(TimeSpan.FromSeconds(33.216), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(100.0, 0.0, 100.0), -5e-05); }, order: 29);
        raid.Schedule(TimeSpan.FromSeconds(33.216), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexanderCutscene)?.SetPosition(new Position(100.0, 0.0, 100.0), -5e-05); }, order: 30);
        raid.Schedule(TimeSpan.FromSeconds(33.216), () => { raid.GetObjectByGameObjectId(ActorDefinitions.AlexanderPrimeCutscene)?.SetPosition(new Position(100.0, 0.0, 100.0), -5e-05); }, order: 31);
        raid.Schedule(TimeSpan.FromSeconds(33.216), () => { raid.GetObjectByGameObjectId(ActorDefinitions.CruiseChaserCutscene)?.SetPosition(new Position(100.0, 0.0, 100.0), -5e-05); }, order: 32);
        raid.Schedule(TimeSpan.FromSeconds(33.216), () => { raid.GetObjectByGameObjectId(ActorDefinitions.BruteJustice)?.SetPosition(new Position(100.0, 0.0, 100.0), -5e-05); }, order: 33);
        raid.Schedule(TimeSpan.FromSeconds(33.216), () => { raid.SynchronizedTimelines(new (string, ushort)[] { (ActorDefinitions.Boss, (ushort)4561), (ActorDefinitions.PerfectAlexanderCutscene, (ushort)4562), (ActorDefinitions.AlexanderPrimeCutscene, (ushort)4561), (ActorDefinitions.CruiseChaserCutscene, (ushort)4561), (ActorDefinitions.BruteJustice, (ushort)4566) }); }, order: 34);
        raid.Schedule(TimeSpan.FromSeconds(71.382), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(null); }, order: 36);
        raid.Schedule(TimeSpan.FromSeconds(71.382), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.SetOwner(null); }, order: 37);
        raid.Schedule(TimeSpan.FromSeconds(71.382), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper06)?.SetOwner(null); }, order: 38);
        raid.Schedule(TimeSpan.FromSeconds(71.382), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper05)?.SetOwner(null); }, order: 39);
        raid.Schedule(TimeSpan.FromSeconds(71.382), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.SetOwner(null); }, order: 40);
        raid.Schedule(TimeSpan.FromSeconds(71.382), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper01)?.SetOwner(null); }, order: 41);
        raid.Schedule(TimeSpan.FromSeconds(71.382), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(null); }, order: 42);
        raid.Schedule(TimeSpan.FromSeconds(71.382), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(null); }, order: 43);
        raid.Schedule(TimeSpan.FromSeconds(71.6), () => { raid.GetObjectByGameObjectId(ActorDefinitions.PerfectAlexanderCutscene)?.Destory(); }, order: 44);
        raid.Schedule(TimeSpan.FromSeconds(71.6), () => { raid.GetObjectByGameObjectId(ActorDefinitions.CruiseChaserCutscene)?.Destory(); }, order: 45);
        raid.Schedule(TimeSpan.FromSeconds(71.6), () => { raid.GetObjectByGameObjectId(ActorDefinitions.BruteJustice)?.Destory(); }, order: 46);
        raid.Schedule(TimeSpan.FromSeconds(71.6), () => { raid.GetObjectByGameObjectId(ActorDefinitions.AlexanderPrimeCutscene)?.Destory(); }, order: 47);
        raid.Schedule(TimeSpan.FromSeconds(71.6), () => { raid.GetObjectByGameObjectId(ActorDefinitions.AlexanderPrime)?.Destory(); }, order: 48);
        raid.Schedule(TimeSpan.FromSeconds(71.6), () => { raid.GetObjectByGameObjectId(ActorDefinitions.CruiseChaser)?.Destory(); }, order: 49);
    }
}
