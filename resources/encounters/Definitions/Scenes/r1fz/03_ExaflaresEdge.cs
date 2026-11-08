using Kawari.Encounters;
// 百京核爆剑 [28059]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.r1fz;
public static class Scene03ExaflaresEdge
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(10.058), () => { raid.DirectorEvent( 2147483678, new object?[] { 581, 0, 0, 0 }); }, order: 158);
    }
}
