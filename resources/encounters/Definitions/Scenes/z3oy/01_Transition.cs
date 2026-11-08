using Kawari.Encounters;
// 木桩后转场：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Scene01Transition
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(6.22), () => { raid.DirectorEvent( 2147483649, new object?[] { 1, 0, 0, 0 }); }, order: 6);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.MapEffect(0, 2048, 4096); }, order: 8);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.MapEffect(20, 1, 1); }, order: 9);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.MapEffect(21, 1, 1); }, order: 10);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.MapEffect(22, 1, 1); }, order: 11);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.MapEffect(23, 1, 1); }, order: 12);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.MapEffect(24, 1, 1); }, order: 13);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.MapEffect(25, 1, 1); }, order: 14);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.MapEffect(26, 1, 1); }, order: 15);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.MapEffect(27, 1, 1); }, order: 16);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.MapEffect(28, 1, 1); }, order: 17);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.MapEffect(29, 1, 1); }, order: 18);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.MapEffect(30, 1, 1); }, order: 19);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.MapEffect(31, 1, 1); }, order: 20);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.MapEffect(32, 1, 1); }, order: 21);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.MapEffect(33, 1, 1); }, order: 22);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.DirectorEvent( 2147483688, new object?[] { 0, 4, 6, 0 }); }, order: 23);
        raid.Schedule(TimeSpan.FromSeconds(8.137), () => { raid.SetWeather(175, 0.0); }, order: 24);
        raid.Schedule(TimeSpan.FromSeconds(10.279), () => { raid.DirectorEvent( 2147483687, new object?[] { 34, 2, 7131, raid.Context.D.Find(ActorDefinitions.KefkaP4) }); }, order: 28);
        raid.Schedule(TimeSpan.FromSeconds(16.854), () => { raid.DirectorEvent( 2147483649, new object?[] { 20294, 0, 0, 0 }); }, order: 29);
        raid.Schedule(TimeSpan.FromSeconds(23.015), () => { raid.DirectorEvent( 2147483687, new object?[] { 35, 2, 7131, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 30);
        raid.Schedule(TimeSpan.FromSeconds(30.113), () => { raid.DirectorEvent( 2147483687, new object?[] { 36, 2, 7131, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 31);
        raid.Schedule(TimeSpan.FromSeconds(37.166), () => { raid.DirectorEvent( 2147483661, new object?[] { 2, 0, 0, 0 }); }, order: 39);
    }
}
