using Kawari.Encounters;
// 癫狂交响曲 [47952]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Scene05MaddeningOrchestra
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(21.617), () => { raid.DirectorEvent( 2147483687, new object?[] { 39, 2, 7131, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 176);
    }
}
