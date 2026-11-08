using Kawari.Encounters;
// 遗弃末世 [47925]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Scene13Forsaken
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(12.027), () => { raid.MapEffect((byte)raid.Context.Get("forsaken-puddle", () => 29), 16, 32); }, order: 534);
        raid.Schedule(TimeSpan.FromSeconds(15.632), () => { raid.MapEffect(20, 16, 32); }, order: 546);
        raid.Schedule(TimeSpan.FromSeconds(15.632), () => { raid.MapEffect(25, 16, 32); }, order: 547);
        raid.Schedule(TimeSpan.FromSeconds(18.073), () => { raid.DirectorEvent( 2147483687, new object?[] { 41, 2, 7131, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 548);
        raid.Schedule(TimeSpan.FromSeconds(20.189), () => { raid.MapEffect((byte)raid.Context.Get("forsaken-puddle", () => 30), 16, 32); }, order: 556);
        raid.Schedule(TimeSpan.FromSeconds(23.827), () => { raid.MapEffect(27, 16, 32); }, order: 564);
        raid.Schedule(TimeSpan.FromSeconds(23.87), () => { raid.MapEffect(28, 16, 32); }, order: 565);
        raid.Schedule(TimeSpan.FromSeconds(26.176), () => { raid.DirectorEvent( 2147483687, new object?[] { 42, 2, 7131, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 568);
        raid.Schedule(TimeSpan.FromSeconds(28.31), () => { raid.MapEffect((byte)raid.Context.Get("forsaken-puddle", () => 31), 16, 32); }, order: 576);
        raid.Schedule(TimeSpan.FromSeconds(31.959), () => { raid.MapEffect(26, 16, 32); }, order: 586);
        raid.Schedule(TimeSpan.FromSeconds(31.959), () => { raid.MapEffect(22, 16, 32); }, order: 587);
        raid.Schedule(TimeSpan.FromSeconds(34.34), () => { raid.DirectorEvent( 2147483687, new object?[] { 43, 2, 7131, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 588);
        raid.Schedule(TimeSpan.FromSeconds(36.423), () => { raid.MapEffect((byte)raid.Context.Get("forsaken-puddle", () => 32), 16, 32); }, order: 596);
        raid.Schedule(TimeSpan.FromSeconds(40.063), () => { raid.MapEffect(21, 16, 32); }, order: 605);
        raid.Schedule(TimeSpan.FromSeconds(40.063), () => { raid.MapEffect(24, 16, 32); }, order: 606);
    }
}
