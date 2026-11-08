using Kawari.Encounters;
// 木桩后转场：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Sequence01Transition
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.057), () => { raid.GetObjectByGameObjectId(ActorDefinitions.UsurperOfFrostP4)?.SetEncounterTargetable(false); }, order: 1);
        raid.Schedule(TimeSpan.FromSeconds(0.057), () => { raid.GetObjectByGameObjectId(ActorDefinitions.OracleOfDarknessP4)?.SetEncounterTargetable(false); }, order: 2);
        raid.Schedule(TimeSpan.FromSeconds(0.127), () => { raid.GetObjectByGameObjectId(ActorDefinitions.OracleOfDarknessP4)?.PlayTimeline(4576); }, order: 3);
        raid.Schedule(TimeSpan.FromSeconds(0.127), () => { raid.GetObjectByGameObjectId(ActorDefinitions.UsurperOfFrostP4)?.PlayTimeline(4581); }, order: 4);
        raid.Schedule(TimeSpan.FromSeconds(3.34), () => { raid.GetObjectByGameObjectId(ActorDefinitions.UsurperOfFrostP4)?.SetPosition(new Position(94.5, 0.0, 100.0), -5e-05); }, order: 5);
        raid.Schedule(TimeSpan.FromSeconds(3.34), () => { raid.GetObjectByGameObjectId(ActorDefinitions.OracleOfDarknessP4)?.SetPosition(new Position(105.5, 0.0, 100.0), -5e-05); }, order: 6);
        raid.Schedule(TimeSpan.FromSeconds(3.58), () => { raid.GetObjectByGameObjectId(ActorDefinitions.OracleOfDarknessP4)?.PlayTimeline(4564); }, order: 8);
        raid.Schedule(TimeSpan.FromSeconds(3.58), () => { raid.GetObjectByGameObjectId(ActorDefinitions.UsurperOfFrostP4)?.PlayTimeline(7747); }, order: 9);
        raid.Schedule(TimeSpan.FromSeconds(3.65), () => { raid.SpawnActor(ActorDefinitions.Boss); }, order: 10);
        raid.Schedule(TimeSpan.FromSeconds(8.783), () => { raid.GetObjectByGameObjectId(ActorDefinitions.UsurperOfFrostP4)?.ExecuteAction(40231, new Params { ["pos"] = new Position(94.5, 0.0, 100.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.UsurperOfFrostP4 }); }, order: 12);
        raid.Schedule(TimeSpan.FromSeconds(9.641), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(null); }, order: 13);
        raid.Schedule(TimeSpan.FromSeconds(9.641), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(ActorDefinitions.UsurperOfFrostP4); }, order: 14);
        raid.Schedule(TimeSpan.FromSeconds(9.641), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 115.0), -3.14159); }, order: 15);
        raid.Schedule(TimeSpan.FromSeconds(9.71), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(40232, new Params { ["pos"] = new Position(100.0, 0.0, 115.0), ["rotation"] = -3.14159, ["target"] = ActorDefinitions.Helper14 }); }, order: 16);
        raid.Schedule(TimeSpan.FromSeconds(10.833), () => { raid.SynchronizedTimelines(new (string, ushort)[] { (ActorDefinitions.UsurperOfFrostP4, (ushort)4578), (ActorDefinitions.OracleOfDarknessP4, (ushort)4573), (ActorDefinitions.Boss, (ushort)4561) }); }, order: 18);
        raid.Schedule(TimeSpan.FromSeconds(12.849), () => { raid.GetObjectByGameObjectId(ActorDefinitions.VisionOfGaia)?.Destory(); }, order: 20);
        raid.Schedule(TimeSpan.FromSeconds(12.849), () => { raid.GetObjectByGameObjectId(ActorDefinitions.VisionOfRyne)?.Destory(); }, order: 21);
        raid.Schedule(TimeSpan.FromSeconds(76.966), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetOwner(null); }, order: 29);
        raid.Schedule(TimeSpan.FromSeconds(76.966), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(null); }, order: 30);
        raid.Schedule(TimeSpan.FromSeconds(76.966), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.SetOwner(null); }, order: 31);
        raid.Schedule(TimeSpan.FromSeconds(76.966), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(null); }, order: 32);
        raid.Schedule(TimeSpan.FromSeconds(76.966), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.SetOwner(null); }, order: 33);
        raid.Schedule(TimeSpan.FromSeconds(76.966), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetOwner(null); }, order: 34);
        raid.Schedule(TimeSpan.FromSeconds(76.966), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper02)?.SetOwner(null); }, order: 35);
        raid.Schedule(TimeSpan.FromSeconds(76.966), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper05)?.SetOwner(null); }, order: 36);
        raid.Schedule(TimeSpan.FromSeconds(76.966), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(null); }, order: 37);
        raid.Schedule(TimeSpan.FromSeconds(76.966), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper04)?.SetOwner(null); }, order: 38);
        raid.Schedule(TimeSpan.FromSeconds(76.966), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper03)?.SetOwner(null); }, order: 39);
        raid.Schedule(TimeSpan.FromSeconds(76.966), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(null); }, order: 40);
        raid.Schedule(TimeSpan.FromSeconds(76.966), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper01)?.SetOwner(null); }, order: 41);
        raid.Schedule(TimeSpan.FromSeconds(76.966), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper06)?.SetOwner(null); }, order: 42);
    }
}
