using Kawari.Encounters;
// 木桩后转场：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.r1fz;
public static class Scene01Transition
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(10.178), () => { raid.DirectorEvent( 2147483670, new object?[] { 1, 70, 0, 0 }); }, order: 11);
        raid.Schedule(TimeSpan.FromSeconds(17.311), () => { raid.DirectorEvent( 2147483678, new object?[] { 580, 0, 0, 0 }); }, order: 15);
        raid.Schedule(TimeSpan.FromSeconds(37.375), () => { raid.SetWeather(170, 3.0); }, order: 47);
        raid.Schedule(TimeSpan.FromSeconds(52.098), () => { raid.DirectorEvent( 2147483649, new object?[] { 1, 0, 0, 0 }); }, order: 77);
        raid.Schedule(TimeSpan.FromSeconds(54.145), () => { raid.DirectorEvent( 2147483679, new object?[] { 765, 0, 0, 0 }); }, order: 82);
        raid.Schedule(TimeSpan.FromSeconds(54.145), () => { raid.SetWeather(47, 0.0); }, order: 83);
    }
}
