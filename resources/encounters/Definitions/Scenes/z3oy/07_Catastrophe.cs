using Kawari.Encounters;
// 二选一的灾祟 [49743]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Scene07Catastrophe
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(4.87), () => { raid.AnimateEObj("tower_09", 1, 64); }, order: 198);
        raid.Schedule(TimeSpan.FromSeconds(4.87), () => { raid.AnimateEObj("tower_06", 1, 64); }, order: 199);
        raid.Schedule(TimeSpan.FromSeconds(4.87), () => { raid.AnimateEObj("tower_04", 1, 64); }, order: 200);
        raid.Schedule(TimeSpan.FromSeconds(4.87), () => { raid.AnimateEObj("tower_02", 1, 64); }, order: 201);
        raid.Schedule(TimeSpan.FromSeconds(4.87), () => { raid.AnimateEObj("tower_03", 16, 32); }, order: 203);
        raid.Schedule(TimeSpan.FromSeconds(4.87), () => { raid.AnimateEObj("tower_01", 16, 32); }, order: 205);
        raid.Schedule(TimeSpan.FromSeconds(4.87), () => { raid.AnimateEObj("tower_05", 16, 32); }, order: 208);
        raid.Schedule(TimeSpan.FromSeconds(4.87), () => { raid.AnimateEObj("tower_07", 16, 32); }, order: 211);
        raid.Schedule(TimeSpan.FromSeconds(10.861), () => { raid.AnimateEObj("tower_07", 1, 64); }, order: 219);
        raid.Schedule(TimeSpan.FromSeconds(10.861), () => { raid.AnimateEObj("tower_05", 1, 64); }, order: 220);
        raid.Schedule(TimeSpan.FromSeconds(10.861), () => { raid.AnimateEObj("tower_01", 1, 64); }, order: 221);
        raid.Schedule(TimeSpan.FromSeconds(10.861), () => { raid.AnimateEObj("tower_03", 1, 64); }, order: 222);
        raid.Schedule(TimeSpan.FromSeconds(10.861), () => { raid.AnimateEObj("tower_02", 16, 32); }, order: 224);
        raid.Schedule(TimeSpan.FromSeconds(10.861), () => { raid.AnimateEObj("tower_04", 16, 32); }, order: 226);
        raid.Schedule(TimeSpan.FromSeconds(10.861), () => { raid.AnimateEObj("tower_08", 16, 32); }, order: 228);
        raid.Schedule(TimeSpan.FromSeconds(10.861), () => { raid.AnimateEObj("tower_09", 16, 32); }, order: 230);
    }
}
