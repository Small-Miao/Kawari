using Kawari.Encounters;
// 复乐园 [40319]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Scene05ParadiseRegained
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(4.843), () => { raid.MapEffect(51, 1, 2); }, order: 311);
        raid.Schedule(TimeSpan.FromSeconds(4.843), () => { raid.MapEffect(48, 4, 1); }, order: 312);
        raid.Schedule(TimeSpan.FromSeconds(4.879), () => { raid.MapEffect(51, 64, 128); }, order: 313);
        raid.Schedule(TimeSpan.FromSeconds(5.929), () => { raid.DirectorEvent( 2147483687, new object?[] { 39, 2, 9347, 0 }); }, order: 314);
    }
}
