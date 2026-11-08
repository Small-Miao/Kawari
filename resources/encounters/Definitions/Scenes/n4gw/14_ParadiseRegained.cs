using Kawari.Encounters;
// 复乐园 [40319]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Scene14ParadiseRegained
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(4.799), () => { raid.MapEffect(52, 1, 2); }, order: 1233);
        raid.Schedule(TimeSpan.FromSeconds(4.799), () => { raid.MapEffect(49, 4, 1); }, order: 1234);
        raid.Schedule(TimeSpan.FromSeconds(6.134), () => { raid.MapEffect(52, 16, 32); }, order: 1235);
    }
}
