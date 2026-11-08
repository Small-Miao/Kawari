using Kawari.Encounters;
// 潘多拉魔盒 [40326]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Scene11PandorasBox
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.849), () => { raid.DirectorEvent( 2147483687, new object?[] { 34, 2, 13561, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 938);
        raid.Schedule(TimeSpan.FromSeconds(7.884), () => { raid.DirectorEvent( 2147483687, new object?[] { 38, 2, 13561, raid.Context.D.Find(ActorDefinitions.Boss) }); }, order: 939);
        raid.Schedule(TimeSpan.FromSeconds(13.91), () => { raid.MapEffect(47, 8, 16); }, order: 941);
    }
}
