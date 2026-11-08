using Kawari.Encounters;
// 最终本体出现：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Scene02Engage
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(2.995), () => { raid.DirectorEvent( 2147483687, new object?[] { 38, 2, 7131, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 43);
    }
}
