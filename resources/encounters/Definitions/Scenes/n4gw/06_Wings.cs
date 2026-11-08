using Kawari.Encounters;
// 光与暗的孤翼 [40313]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Scene06Wings
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(1.159), () => { raid.MapEffect(52, 1, 2); }, order: 317);
        raid.Schedule(TimeSpan.FromSeconds(1.159), () => { raid.MapEffect(49, 4, 1); }, order: 318);
        raid.Schedule(TimeSpan.FromSeconds(3.859), () => { raid.DirectorEvent( 2147483687, new object?[] { 40, 2, 9326, 0 }); }, order: 319);
        raid.Schedule(TimeSpan.FromSeconds(4.671), () => { raid.MapEffect(53, 1, 2); }, order: 320);
        raid.Schedule(TimeSpan.FromSeconds(4.671), () => { raid.MapEffect(50, 4, 1); }, order: 321);
        raid.Schedule(TimeSpan.FromSeconds(5.255), () => { raid.MapEffect(53, 16, 32); }, order: 322);
        raid.Schedule(TimeSpan.FromSeconds(7.071), () => { raid.MapEffect(53, 64, 128); }, order: 324);
        raid.Schedule(TimeSpan.FromSeconds(7.204), () => { raid.MapEffect(51, 4, 8); }, order: 330);
        raid.Schedule(TimeSpan.FromSeconds(9.36), () => { raid.MapEffect(52, 16, 32); }, order: 336);
        raid.Schedule(TimeSpan.FromSeconds(10.262), () => { raid.MapEffect(52, 64, 128); }, order: 337);
        raid.Schedule(TimeSpan.FromSeconds(10.732), () => { raid.MapEffect(52, 4, 8); }, order: 341);
        raid.Schedule(TimeSpan.FromSeconds(14.205), () => { raid.MapEffect(53, 4, 8); }, order: 354);
    }
}
