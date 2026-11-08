using Kawari.Encounters;
// 木桩后转场：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Scene01Transition
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(3.34), () => { raid.DirectorEvent( 2147483678, new object?[] { 791, 0, 0, 0 }); }, order: 7);
        raid.Schedule(TimeSpan.FromSeconds(5.674), () => { raid.DirectorEvent( 2147483687, new object?[] { 54, 2, 12809, raid.Context.D.Find(ActorDefinitions.UsurperOfFrostP4) }); }, order: 11);
        raid.Schedule(TimeSpan.FromSeconds(10.833), () => { raid.DirectorEvent( 2147483674, new object?[] { 1, 1, 0, 0 }); }, order: 17);
        raid.Schedule(TimeSpan.FromSeconds(12.783), () => { raid.MapEffect(46, 4, 8); }, order: 19);
        raid.Schedule(TimeSpan.FromSeconds(25.788), () => { raid.DirectorEvent( 2147483649, new object?[] { 1, 0, 0, 0 }); }, order: 22);
        raid.Schedule(TimeSpan.FromSeconds(32.826), () => { raid.MapEffect(40, 4, 8); }, order: 23);
        raid.Schedule(TimeSpan.FromSeconds(32.826), () => { raid.MapEffect(41, 4, 4); }, order: 24);
        raid.Schedule(TimeSpan.FromSeconds(32.826), () => { raid.MapEffect(47, 1, 2); }, order: 25);
        raid.Schedule(TimeSpan.FromSeconds(32.826), () => { raid.SetWeather(108, 0.0); }, order: 26);
        raid.Schedule(TimeSpan.FromSeconds(65.331), () => { raid.DirectorEvent( 2147483649, new object?[] { 20099, 0, 0, 0 }); }, order: 27);
        raid.Schedule(TimeSpan.FromSeconds(76.88), () => { raid.DirectorEvent( 2147483675, new object?[] { 1, 0, 0, 0 }); }, order: 28);
    }
}
