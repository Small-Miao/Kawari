using Kawari.Encounters;
// 诛罚 [18577]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class Scene19OrdainedPunishment
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(8.058), () => { raid.MapEffect(6, 1, 2); }, order: 1119);
    }
}
