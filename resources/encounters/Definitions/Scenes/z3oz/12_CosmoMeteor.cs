using Kawari.Encounters;
// 宇宙流星 [31664]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oz;
public static class Scene12CosmoMeteor
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(7.993), () => { raid.MapEffect(12, 4, 2); }, order: 1785);
        raid.Schedule(TimeSpan.FromSeconds(7.993), () => { raid.MapEffect(13, 4, 2); }, order: 1786);
        raid.Schedule(TimeSpan.FromSeconds(7.993), () => { raid.MapEffect(14, 4, 2); }, order: 1787);
        raid.Schedule(TimeSpan.FromSeconds(7.993), () => { raid.MapEffect(15, 4, 2); }, order: 1788);
        raid.Schedule(TimeSpan.FromSeconds(7.993), () => { raid.MapEffect(16, 4, 2); }, order: 1789);
        raid.Schedule(TimeSpan.FromSeconds(7.993), () => { raid.MapEffect(17, 4, 2); }, order: 1790);
        raid.Schedule(TimeSpan.FromSeconds(7.993), () => { raid.MapEffect(18, 4, 2); }, order: 1791);
        raid.Schedule(TimeSpan.FromSeconds(7.993), () => { raid.MapEffect(19, 4, 2); }, order: 1792);
        raid.Schedule(TimeSpan.FromSeconds(8.416), () => { raid.MapEffect(21, 1, 2); }, order: 1801);
    }
}
