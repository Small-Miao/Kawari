using Kawari.Encounters;
// 未来观测β [19219]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Scene12FateProjectionBeta
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(5.816), () => { raid.MapEffect(1, 64, 128); }, order: 473);
        raid.Schedule(TimeSpan.FromSeconds(5.816), () => { raid.MapEffect(5, 64, 128); }, order: 474);
        raid.Schedule(TimeSpan.FromSeconds(5.816), () => { raid.MapEffect(4, 64, 128); }, order: 475);
        raid.Schedule(TimeSpan.FromSeconds(5.816), () => { raid.SetWeather(132, 1.0); }, order: 476);
    }
}
