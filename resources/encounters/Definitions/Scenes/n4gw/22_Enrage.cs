using Kawari.Encounters;
// 失乐园 [40327]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Scene22Enrage
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(5.416), () => { raid.DirectorEvent( 2147483687, new object?[] { 49, 2, 9326, 0 }); }, order: 2102);
        raid.Schedule(TimeSpan.FromSeconds(10.425), () => { raid.DirectorEvent( 2147483687, new object?[] { 50, 2, 9347, 0 }); }, order: 2103);
        raid.Schedule(TimeSpan.FromSeconds(17.488), () => { raid.DirectorEvent( 2147483687, new object?[] { 51, 2, 13699, 0 }); }, order: 2105);
    }
}
