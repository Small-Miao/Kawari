using Kawari.Encounters;
// 死亡轮回 [40310]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Scene13AkhMorn
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.07), () => { raid.AnimateEObj("blade_07", 4, 8); }, order: 1128);
        raid.Schedule(TimeSpan.FromSeconds(0.07), () => { raid.AnimateEObj("blade_08", 4, 8); }, order: 1129);
        raid.Schedule(TimeSpan.FromSeconds(2.423), () => { raid.DirectorEvent( 2147483687, new object?[] { 37, 2, 13561, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 1156);
        raid.Schedule(TimeSpan.FromSeconds(2.559), () => { raid.RemoveEObj("blade_07"); }, order: 1161);
        raid.Schedule(TimeSpan.FromSeconds(2.559), () => { raid.RemoveEObj("blade_08"); }, order: 1162);
    }
}
