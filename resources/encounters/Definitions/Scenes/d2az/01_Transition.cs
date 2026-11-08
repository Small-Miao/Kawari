using Kawari.Encounters;
// 木桩后转场：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Scene01Transition
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(15.69), () => { raid.MapEffect(2, 4, 8); }, order: 12);
        raid.Schedule(TimeSpan.FromSeconds(15.69), () => { raid.MapEffect(5, 1, 2); }, order: 13);
        raid.Schedule(TimeSpan.FromSeconds(15.69), () => { raid.AnimateEObj("prison_08", 1, 2); }, order: 14);
        raid.Schedule(TimeSpan.FromSeconds(15.69), () => { raid.AnimateEObj("prison_07", 1, 2); }, order: 15);
        raid.Schedule(TimeSpan.FromSeconds(15.69), () => { raid.AnimateEObj("prison_06", 1, 2); }, order: 16);
        raid.Schedule(TimeSpan.FromSeconds(15.69), () => { raid.AnimateEObj("prison_05", 1, 2); }, order: 17);
        raid.Schedule(TimeSpan.FromSeconds(15.69), () => { raid.AnimateEObj("prison_04", 1, 2); }, order: 18);
        raid.Schedule(TimeSpan.FromSeconds(15.69), () => { raid.AnimateEObj("prison_03", 1, 2); }, order: 19);
        raid.Schedule(TimeSpan.FromSeconds(15.69), () => { raid.AnimateEObj("prison_02", 1, 2); }, order: 20);
        raid.Schedule(TimeSpan.FromSeconds(15.69), () => { raid.AnimateEObj("prison_01", 1, 2); }, order: 21);
        raid.Schedule(TimeSpan.FromSeconds(15.69), () => { raid.SetWeather(108, 1.0); }, order: 22);
        raid.Schedule(TimeSpan.FromSeconds(18.583), () => { raid.DirectorEvent( 2147483649, new object?[] { 713, 0, 0, 0 }); }, order: 23);
        raid.Schedule(TimeSpan.FromSeconds(21.615), () => { raid.DirectorEvent( 2147483649, new object?[] { 726, 0, 0, 0 }); }, order: 24);
        raid.Schedule(TimeSpan.FromSeconds(23.616), () => { raid.MapEffect(3, 1, 2); }, order: 25);
        raid.Schedule(TimeSpan.FromSeconds(32.2), () => { raid.DirectorEvent( 2147483656, new object?[] { 0, 0, 0, 0 }); }, order: 28);
        raid.Schedule(TimeSpan.FromSeconds(68.381), () => { raid.MapEffect(4, 1, 2); }, order: 35);
        raid.Schedule(TimeSpan.FromSeconds(72.33), () => { raid.DirectorEvent( 2147483657, new object?[] { 0, 0, 0, 0 }); }, order: 50);
    }
}
