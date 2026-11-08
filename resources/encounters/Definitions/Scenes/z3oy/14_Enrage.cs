using Kawari.Encounters;
// 遗弃末点 [47930]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Scene14Enrage
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.736), () => { raid.MapEffect(33, 8, 16); }, order: 615);
        raid.Schedule(TimeSpan.FromSeconds(0.736), () => { raid.MapEffect(29, 4, 8); }, order: 616);
        raid.Schedule(TimeSpan.FromSeconds(0.736), () => { raid.MapEffect(30, 4, 8); }, order: 617);
        raid.Schedule(TimeSpan.FromSeconds(0.736), () => { raid.MapEffect(31, 4, 8); }, order: 618);
        raid.Schedule(TimeSpan.FromSeconds(0.736), () => { raid.MapEffect(32, 4, 8); }, order: 619);
        raid.Schedule(TimeSpan.FromSeconds(4.291), () => { raid.DirectorEvent( 2147483687, new object?[] { 44, 2, 7131, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 620);
        raid.Schedule(TimeSpan.FromSeconds(21.819), () => { raid.DirectorEvent( 2147483687, new object?[] { 45, 2, 7131, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 621);
    }
}
