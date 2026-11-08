using Kawari.Encounters;
// 二选一的灾祟 [49743]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Scene08Catastrophe
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(4.77), () => { raid.AnimateEObj("tower_09", 1, 64); }, order: 237);
        raid.Schedule(TimeSpan.FromSeconds(4.77), () => { raid.AnimateEObj("tower_08", 1, 64); }, order: 238);
        raid.Schedule(TimeSpan.FromSeconds(4.77), () => { raid.AnimateEObj("tower_04", 1, 64); }, order: 239);
        raid.Schedule(TimeSpan.FromSeconds(4.77), () => { raid.AnimateEObj("tower_02", 1, 64); }, order: 240);
    }
}
