using Kawari.Encounters;
// 最终本体出现：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.r1fz;
public static class Scene02Engage
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.073), () => { raid.DirectorEvent( 2147483670, new object?[] { 1, 80, 0, 0 }); }, order: 96);
        raid.Schedule(TimeSpan.FromSeconds(3.146), () => { raid.DirectorEvent( 2147483649, new object?[] { 907, 0, 0, 0 }); }, order: 101);
    }
}
