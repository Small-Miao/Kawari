using Kawari.Encounters;
// 死亡轮回 [40310]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Scene04AkhMorn
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.077), () => { raid.AnimateEObj("blade_01", 4, 8); }, order: 216);
        raid.Schedule(TimeSpan.FromSeconds(0.077), () => { raid.AnimateEObj("blade_02", 4, 8); }, order: 217);
        raid.Schedule(TimeSpan.FromSeconds(2.393), () => { raid.RemoveEObj("blade_01"); }, order: 252);
        raid.Schedule(TimeSpan.FromSeconds(2.393), () => { raid.RemoveEObj("blade_02"); }, order: 253);
        raid.Schedule(TimeSpan.FromSeconds(12.212), () => { raid.DirectorEvent( 2147483687, new object?[] { 35, 2, 13561, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 302);
    }
}
