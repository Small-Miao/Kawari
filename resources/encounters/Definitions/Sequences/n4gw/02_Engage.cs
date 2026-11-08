using Kawari.Encounters;
// 最终本体出现：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Sequence02Engage
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetEncounterTargetable(true); }, order: 43);
        raid.Schedule(TimeSpan.FromSeconds(0.197), () => { raid.GetObjectByGameObjectId(ActorDefinitions.OracleOfDarknessP4)?.Destory(); }, order: 44);
        raid.Schedule(TimeSpan.FromSeconds(0.197), () => { raid.GetObjectByGameObjectId(ActorDefinitions.UsurperOfFrostP4)?.Destory(); }, order: 45);
        raid.Schedule(TimeSpan.FromSeconds(3.16), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(40114, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -0.01347, ["target"] = ActorDefinitions.Boss }); }, order: 47);
        raid.Schedule(TimeSpan.FromSeconds(3.803), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(ActorDefinitions.Boss); }, order: 48);
        raid.Schedule(TimeSpan.FromSeconds(3.803), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), -0.01347); }, order: 49);
        raid.Schedule(TimeSpan.FromSeconds(3.803), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetOwner(ActorDefinitions.Boss); }, order: 50);
        raid.Schedule(TimeSpan.FromSeconds(3.803), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetPosition(new Position(100.0, 0.0, 100.0), -0.01347); }, order: 51);
        raid.Schedule(TimeSpan.FromSeconds(3.858), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(40115, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -0.01347 }); }, order: 52);
        raid.Schedule(TimeSpan.FromSeconds(3.858), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(40115, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -0.01347 }); }, order: 53);
    }
}
