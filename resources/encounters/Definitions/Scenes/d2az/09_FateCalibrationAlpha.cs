using Kawari.Encounters;
// 未来确定α [18556]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Scene09FateCalibrationAlpha
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(23.084), () => { raid.MapEffect(1, 1, 2); }, order: 360);
        raid.Schedule(TimeSpan.FromSeconds(23.084), () => { raid.MapEffect(5, 1, 32); }, order: 361);
        raid.Schedule(TimeSpan.FromSeconds(23.084), () => { raid.MapEffect(4, 1, 32); }, order: 362);
        raid.Schedule(TimeSpan.FromSeconds(23.084), () => { raid.SetWeather(108, 1.0); }, order: 363);
    }
}
