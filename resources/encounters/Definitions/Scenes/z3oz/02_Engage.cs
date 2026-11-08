using Kawari.Encounters;
// 最终本体出现：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oz;
public static class Scene02Engage
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.DirectorEvent( 2147483678, new object?[] { 686, 0, 0, 0 }); }, order: 32);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.MapEffect(0, 1, 2); }, order: 33);
    }
}
