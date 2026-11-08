using Kawari.Encounters;
// 星灵之剑 [40234]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Scene10PolarizingStrikes
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(1.241), () => { raid.DirectorEvent( 2147483687, new object?[] { 41, 2, 9326, 0 }); }, order: 775);
        raid.Schedule(TimeSpan.FromSeconds(6.336), () => { raid.DirectorEvent( 2147483687, new object?[] { 42, 2, 9347, 0 }); }, order: 921);
    }
}
