using Kawari.Encounters;
// 未来确定β [19220]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Scene13FateCalibrationBeta
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(36.099), () => { raid.MapEffect(1, 1, 2); }, order: 777);
        raid.Schedule(TimeSpan.FromSeconds(36.099), () => { raid.MapEffect(5, 1, 32); }, order: 778);
        raid.Schedule(TimeSpan.FromSeconds(36.099), () => { raid.MapEffect(4, 1, 32); }, order: 779);
        raid.Schedule(TimeSpan.FromSeconds(36.099), () => { raid.SetWeather(108, 1.0); }, order: 780);
    }
}
