using Kawari.Encounters;
// 木桩后转场：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oz;
public static class Scene01Transition
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.054), () => { raid.MapEffect(0, 4, 8); }, order: 1);
        raid.Schedule(TimeSpan.FromSeconds(13.485), () => { raid.DirectorEvent( 2147483674, new object?[] { 1, 1, 0, 0 }); }, order: 17);
        raid.Schedule(TimeSpan.FromSeconds(14.17), () => { raid.DirectorEvent( 2147483649, new object?[] { 1, 0, 0, 0 }); }, order: 19);
        raid.Schedule(TimeSpan.FromSeconds(26.17), () => { raid.DirectorEvent( 2147483683, new object?[] { 35823, 50, 0, 0 }); }, order: 20);
        raid.Schedule(TimeSpan.FromSeconds(48.664), () => { raid.DirectorEvent( 2147483683, new object?[] { 35825, 60, 0, 0 }); }, order: 21);
        raid.Schedule(TimeSpan.FromSeconds(57.477), () => { raid.DirectorEvent( 2147483649, new object?[] { 951, 0, 0, 0 }); }, order: 22);
        raid.Schedule(TimeSpan.FromSeconds(58.194), () => { raid.DirectorEvent( 2147483683, new object?[] { 35827, 60, 0, 0 }); }, order: 23);
        raid.Schedule(TimeSpan.FromSeconds(59.037), () => { raid.SetWeather(175, 1.0); }, order: 24);
        raid.Schedule(TimeSpan.FromSeconds(67.265), () => { raid.DirectorEvent( 2147483675, new object?[] { 1, 0, 0, 0 }); }, order: 25);
    }
}
