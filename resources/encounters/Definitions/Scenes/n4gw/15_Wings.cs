using Kawari.Encounters;
// 光与暗的孤翼 [40313]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Scene15Wings
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(1.027), () => { raid.MapEffect(52, 64, 128); }, order: 1238);
        raid.Schedule(TimeSpan.FromSeconds(1.129), () => { raid.MapEffect(51, 1, 2); }, order: 1239);
        raid.Schedule(TimeSpan.FromSeconds(1.129), () => { raid.MapEffect(48, 4, 1); }, order: 1240);
        raid.Schedule(TimeSpan.FromSeconds(2.857), () => { raid.MapEffect(51, 16, 32); }, order: 1241);
        raid.Schedule(TimeSpan.FromSeconds(3.393), () => { raid.MapEffect(51, 64, 128); }, order: 1242);
        raid.Schedule(TimeSpan.FromSeconds(4.675), () => { raid.MapEffect(53, 1, 2); }, order: 1243);
        raid.Schedule(TimeSpan.FromSeconds(4.675), () => { raid.MapEffect(50, 4, 1); }, order: 1244);
        raid.Schedule(TimeSpan.FromSeconds(7.178), () => { raid.MapEffect(52, 4, 8); }, order: 1250);
        raid.Schedule(TimeSpan.FromSeconds(9.389), () => { raid.MapEffect(53, 16, 32); }, order: 1257);
        raid.Schedule(TimeSpan.FromSeconds(9.638), () => { raid.MapEffect(53, 64, 128); }, order: 1258);
        raid.Schedule(TimeSpan.FromSeconds(10.707), () => { raid.MapEffect(51, 4, 8); }, order: 1262);
        raid.Schedule(TimeSpan.FromSeconds(14.146), () => { raid.MapEffect(53, 4, 8); }, order: 1274);
    }
}
