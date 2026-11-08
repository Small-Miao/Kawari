using Kawari.Encounters;
// 光尘之剑 [40306]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Scene12FulgentBlade
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.281), () => { raid.SpawnEObj("blade_07", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -0.78546, ["state"] = 0, ["args1"] = 4, ["args2"] = 4521987, ["pos"] = new Position(110.6569, 0.0, 89.3431) }); }, order: 944);
        raid.Schedule(TimeSpan.FromSeconds(0.281), () => { raid.SpawnEObj("blade_08", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = 3.14159, ["state"] = 0, ["args1"] = 4, ["args2"] = 4456451, ["pos"] = new Position(100.0, 0.0, 83.0) }); }, order: 945);
        raid.Schedule(TimeSpan.FromSeconds(0.281), () => { raid.SpawnEObj("blade_09", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -2.35628, ["state"] = 0, ["args1"] = 4, ["args2"] = 4390915, ["pos"] = new Position(89.3431, 0.0, 89.3431) }); }, order: 946);
        raid.Schedule(TimeSpan.FromSeconds(0.281), () => { raid.SpawnEObj("blade_10", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = 1.57077, ["state"] = 0, ["args1"] = 4, ["args2"] = 4325379, ["pos"] = new Position(90.0, 0.0, 100.0) }); }, order: 947);
        raid.Schedule(TimeSpan.FromSeconds(0.281), () => { raid.SpawnEObj("blade_11", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -0.78546, ["state"] = 0, ["args1"] = 4, ["args2"] = 4259843, ["pos"] = new Position(96.4142, 0.0, 103.5858) }); }, order: 948);
        raid.Schedule(TimeSpan.FromSeconds(0.281), () => { raid.SpawnEObj("blade_12", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -3.14159, ["state"] = 0, ["args1"] = 4, ["args2"] = 4194307, ["pos"] = new Position(100.0, 0.0, 103.0) }); }, order: 949);
        raid.Schedule(TimeSpan.FromSeconds(0.863), () => { raid.MapEffect(47, 1, 32); }, order: 950);
        raid.Schedule(TimeSpan.FromSeconds(7.941), () => { raid.AnimateEObj("blade_12", 1, 2); }, order: 952);
        raid.Schedule(TimeSpan.FromSeconds(7.941), () => { raid.AnimateEObj("blade_11", 1, 2); }, order: 953);
        raid.Schedule(TimeSpan.FromSeconds(7.941), () => { raid.AnimateEObj("blade_10", 1, 2); }, order: 954);
        raid.Schedule(TimeSpan.FromSeconds(7.941), () => { raid.AnimateEObj("blade_09", 1, 2); }, order: 955);
        raid.Schedule(TimeSpan.FromSeconds(7.941), () => { raid.AnimateEObj("blade_08", 1, 2); }, order: 956);
        raid.Schedule(TimeSpan.FromSeconds(7.941), () => { raid.AnimateEObj("blade_07", 1, 2); }, order: 957);
        raid.Schedule(TimeSpan.FromSeconds(9.908), () => { raid.AnimateEObj("blade_12", 32, 16); }, order: 968);
        raid.Schedule(TimeSpan.FromSeconds(9.908), () => { raid.AnimateEObj("blade_11", 32, 16); }, order: 975);
        raid.Schedule(TimeSpan.FromSeconds(13.96), () => { raid.AnimateEObj("blade_10", 32, 16); }, order: 1001);
        raid.Schedule(TimeSpan.FromSeconds(13.96), () => { raid.AnimateEObj("blade_09", 32, 16); }, order: 1008);
        raid.Schedule(TimeSpan.FromSeconds(15.312), () => { raid.DirectorEvent( 2147483687, new object?[] { 43, 2, 9347, 0 }); }, order: 1020);
        raid.Schedule(TimeSpan.FromSeconds(16.98), () => { raid.AnimateEObj("blade_12", 4, 8); }, order: 1032);
        raid.Schedule(TimeSpan.FromSeconds(16.98), () => { raid.AnimateEObj("blade_11", 4, 8); }, order: 1033);
        raid.Schedule(TimeSpan.FromSeconds(17.925), () => { raid.AnimateEObj("blade_08", 32, 16); }, order: 1038);
        raid.Schedule(TimeSpan.FromSeconds(17.925), () => { raid.AnimateEObj("blade_07", 32, 16); }, order: 1045);
        raid.Schedule(TimeSpan.FromSeconds(19.1), () => { raid.RemoveEObj("blade_11"); }, order: 1065);
        raid.Schedule(TimeSpan.FromSeconds(19.1), () => { raid.RemoveEObj("blade_12"); }, order: 1066);
        raid.Schedule(TimeSpan.FromSeconds(20.347), () => { raid.DirectorEvent( 2147483687, new object?[] { 44, 2, 9326, 0 }); }, order: 1076);
        raid.Schedule(TimeSpan.FromSeconds(20.996), () => { raid.AnimateEObj("blade_09", 4, 8); }, order: 1079);
        raid.Schedule(TimeSpan.FromSeconds(20.996), () => { raid.AnimateEObj("blade_10", 4, 8); }, order: 1080);
        raid.Schedule(TimeSpan.FromSeconds(23.484), () => { raid.RemoveEObj("blade_09"); }, order: 1122);
        raid.Schedule(TimeSpan.FromSeconds(23.484), () => { raid.RemoveEObj("blade_10"); }, order: 1123);
    }
}
