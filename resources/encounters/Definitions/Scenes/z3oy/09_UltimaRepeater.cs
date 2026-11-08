using Kawari.Encounters;
// 连续究极 [47936]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Scene09UltimaRepeater
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.041), () => { raid.RemoveEObj("tower_01"); }, order: 248);
        raid.Schedule(TimeSpan.FromSeconds(0.041), () => { raid.RemoveEObj("tower_02"); }, order: 249);
        raid.Schedule(TimeSpan.FromSeconds(0.041), () => { raid.RemoveEObj("tower_03"); }, order: 250);
        raid.Schedule(TimeSpan.FromSeconds(0.041), () => { raid.RemoveEObj("tower_04"); }, order: 251);
        raid.Schedule(TimeSpan.FromSeconds(0.041), () => { raid.RemoveEObj("tower_05"); }, order: 252);
        raid.Schedule(TimeSpan.FromSeconds(0.041), () => { raid.RemoveEObj("tower_06"); }, order: 253);
        raid.Schedule(TimeSpan.FromSeconds(0.041), () => { raid.RemoveEObj("tower_08"); }, order: 254);
        raid.Schedule(TimeSpan.FromSeconds(0.041), () => { raid.RemoveEObj("tower_09"); }, order: 255);
        raid.Schedule(TimeSpan.FromSeconds(0.041), () => { raid.RemoveEObj("tower_07"); }, order: 256);
        raid.Schedule(TimeSpan.FromSeconds(14.547), () => { raid.DirectorEvent( 2147483687, new object?[] { 37, 2, 7131, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 281);
    }
}
