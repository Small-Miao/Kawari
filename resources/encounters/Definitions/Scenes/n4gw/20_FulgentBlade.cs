using Kawari.Encounters;
// 光尘之剑 [40306]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Scene20FulgentBlade
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.217), () => { raid.SpawnEObj("blade_13", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -0.78546, ["state"] = 0, ["args1"] = 4, ["args2"] = 4521987, ["pos"] = new Position(89.3934, 0.0, 110.6569) }); }, order: 1822);
        raid.Schedule(TimeSpan.FromSeconds(0.217), () => { raid.SpawnEObj("blade_14", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -3.14159, ["state"] = 0, ["args1"] = 4, ["args2"] = 4456451, ["pos"] = new Position(100.0, 0.0, 117.0) }); }, order: 1823);
        raid.Schedule(TimeSpan.FromSeconds(0.217), () => { raid.SpawnEObj("blade_15", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = 1.57077, ["state"] = 0, ["args1"] = 4, ["args2"] = 4325379, ["pos"] = new Position(110.0, 0.0, 100.0) }); }, order: 1824);
        raid.Schedule(TimeSpan.FromSeconds(0.217), () => { raid.SpawnEObj("blade_16", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = 2.35618, ["state"] = 0, ["args1"] = 4, ["args2"] = 4259843, ["pos"] = new Position(103.5858, 0.0, 96.4142) }); }, order: 1825);
        raid.Schedule(TimeSpan.FromSeconds(0.217), () => { raid.SpawnEObj("blade_17", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -5e-05, ["state"] = 0, ["args1"] = 4, ["args2"] = 4194307, ["pos"] = new Position(100.0, 0.0, 97.0) }); }, order: 1826);
        raid.Schedule(TimeSpan.FromSeconds(0.217), () => { raid.SpawnEObj("blade_18", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -2.35628, ["state"] = 0, ["args1"] = 4, ["args2"] = 4390915, ["pos"] = new Position(110.6569, 0.0, 110.6569) }); }, order: 1827);
        raid.Schedule(TimeSpan.FromSeconds(8.065), () => { raid.AnimateEObj("blade_17", 1, 2); }, order: 1829);
        raid.Schedule(TimeSpan.FromSeconds(8.065), () => { raid.AnimateEObj("blade_16", 1, 2); }, order: 1830);
        raid.Schedule(TimeSpan.FromSeconds(8.065), () => { raid.AnimateEObj("blade_15", 1, 2); }, order: 1831);
        raid.Schedule(TimeSpan.FromSeconds(8.065), () => { raid.AnimateEObj("blade_18", 1, 2); }, order: 1832);
        raid.Schedule(TimeSpan.FromSeconds(8.065), () => { raid.AnimateEObj("blade_14", 1, 2); }, order: 1833);
        raid.Schedule(TimeSpan.FromSeconds(8.065), () => { raid.AnimateEObj("blade_13", 1, 2); }, order: 1834);
        raid.Schedule(TimeSpan.FromSeconds(10.052), () => { raid.AnimateEObj("blade_17", 32, 16); }, order: 1845);
        raid.Schedule(TimeSpan.FromSeconds(10.052), () => { raid.AnimateEObj("blade_16", 32, 16); }, order: 1852);
        raid.Schedule(TimeSpan.FromSeconds(14.03), () => { raid.AnimateEObj("blade_15", 32, 16); }, order: 1877);
        raid.Schedule(TimeSpan.FromSeconds(14.03), () => { raid.AnimateEObj("blade_18", 32, 16); }, order: 1884);
        raid.Schedule(TimeSpan.FromSeconds(17.055), () => { raid.AnimateEObj("blade_17", 4, 8); }, order: 1904);
        raid.Schedule(TimeSpan.FromSeconds(17.055), () => { raid.AnimateEObj("blade_16", 4, 8); }, order: 1905);
        raid.Schedule(TimeSpan.FromSeconds(18.042), () => { raid.AnimateEObj("blade_14", 32, 16); }, order: 1910);
        raid.Schedule(TimeSpan.FromSeconds(18.042), () => { raid.AnimateEObj("blade_13", 32, 16); }, order: 1917);
        raid.Schedule(TimeSpan.FromSeconds(19.509), () => { raid.RemoveEObj("blade_16"); }, order: 1945);
        raid.Schedule(TimeSpan.FromSeconds(19.509), () => { raid.RemoveEObj("blade_17"); }, order: 1946);
        raid.Schedule(TimeSpan.FromSeconds(21.067), () => { raid.AnimateEObj("blade_18", 4, 8); }, order: 1947);
        raid.Schedule(TimeSpan.FromSeconds(21.067), () => { raid.AnimateEObj("blade_15", 4, 8); }, order: 1948);
        raid.Schedule(TimeSpan.FromSeconds(23.538), () => { raid.RemoveEObj("blade_15"); }, order: 1988);
        raid.Schedule(TimeSpan.FromSeconds(23.538), () => { raid.RemoveEObj("blade_18"); }, order: 1989);
        raid.Schedule(TimeSpan.FromSeconds(24.715), () => { raid.DirectorEvent( 2147483687, new object?[] { 45, 2, 9326, 0 }); }, order: 1992);
    }
}
