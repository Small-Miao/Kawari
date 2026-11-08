using Kawari.Encounters;
// 死亡轮回 [40310]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Scene21AkhMorn
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.212), () => { raid.AnimateEObj("blade_13", 4, 8); }, order: 1994);
        raid.Schedule(TimeSpan.FromSeconds(0.212), () => { raid.AnimateEObj("blade_14", 4, 8); }, order: 1995);
        raid.Schedule(TimeSpan.FromSeconds(2.732), () => { raid.RemoveEObj("blade_13"); }, order: 2026);
        raid.Schedule(TimeSpan.FromSeconds(2.732), () => { raid.RemoveEObj("blade_14"); }, order: 2027);
        raid.Schedule(TimeSpan.FromSeconds(4.871), () => { raid.DirectorEvent( 2147483687, new object?[] { 46, 2, 9347, 0 }); }, order: 2036);
        raid.Schedule(TimeSpan.FromSeconds(9.908), () => { raid.DirectorEvent( 2147483687, new object?[] { 47, 2, 13561, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 2060);
        raid.Schedule(TimeSpan.FromSeconds(16.343), () => { raid.DirectorEvent( 2147483687, new object?[] { 48, 2, 13561, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 2096);
    }
}
