using Kawari.Encounters;
// 三星 [47938]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Scene06Celestriad
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(5.249), () => { raid.SpawnEObj("tower_01", new Params { ["base"] = 2015294, ["flags"] = 5, ["hidden"] = false, ["layout"] = 12327438, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = 0.34903, ["state"] = 0, ["args1"] = 2, ["args2"] = 4390915, ["pos"] = new Position(96.5798, 0.0, 90.6031) }); }, order: 179);
        raid.Schedule(TimeSpan.FromSeconds(5.249), () => { raid.SpawnEObj("tower_02", new Params { ["base"] = 2015294, ["flags"] = 5, ["hidden"] = false, ["layout"] = 12327437, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = 1.0472, ["state"] = 0, ["args1"] = 2, ["args2"] = 4325379, ["pos"] = new Position(91.3397, 0.0, 95.0) }); }, order: 180);
        raid.Schedule(TimeSpan.FromSeconds(5.249), () => { raid.SpawnEObj("tower_03", new Params { ["base"] = 2015294, ["flags"] = 5, ["hidden"] = false, ["layout"] = 12327436, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = 1.74527, ["state"] = 0, ["args1"] = 2, ["args2"] = 4259843, ["pos"] = new Position(90.1519, 0.0, 101.7365) }); }, order: 181);
        raid.Schedule(TimeSpan.FromSeconds(5.249), () => { raid.SpawnEObj("tower_04", new Params { ["base"] = 2015295, ["flags"] = 5, ["hidden"] = false, ["layout"] = 12327435, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = 2.44343, ["state"] = 0, ["args1"] = 2, ["args2"] = 4587523, ["pos"] = new Position(93.5721, 0.0, 107.6604) }); }, order: 182);
        raid.Schedule(TimeSpan.FromSeconds(5.249), () => { raid.SpawnEObj("tower_05", new Params { ["base"] = 2015295, ["flags"] = 5, ["hidden"] = false, ["layout"] = 12327434, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = 3.1415, ["state"] = 0, ["args1"] = 2, ["args2"] = 4521987, ["pos"] = new Position(100.0, 0.0, 110.0) }); }, order: 183);
        raid.Schedule(TimeSpan.FromSeconds(5.249), () => { raid.SpawnEObj("tower_06", new Params { ["base"] = 2015295, ["flags"] = 5, ["hidden"] = false, ["layout"] = 12327433, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -2.44352, ["state"] = 0, ["args1"] = 2, ["args2"] = 4456451, ["pos"] = new Position(106.4279, 0.0, 107.6604) }); }, order: 184);
        raid.Schedule(TimeSpan.FromSeconds(5.249), () => { raid.SpawnEObj("tower_07", new Params { ["base"] = 2015296, ["flags"] = 5, ["hidden"] = false, ["layout"] = 12327432, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -1.74536, ["state"] = 0, ["args1"] = 2, ["args2"] = 4784131, ["pos"] = new Position(109.8481, 0.0, 101.7365) }); }, order: 185);
        raid.Schedule(TimeSpan.FromSeconds(5.249), () => { raid.SpawnEObj("tower_08", new Params { ["base"] = 2015296, ["flags"] = 5, ["hidden"] = false, ["layout"] = 12327431, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -1.0472, ["state"] = 0, ["args1"] = 2, ["args2"] = 4718595, ["pos"] = new Position(108.6603, 0.0, 95.0) }); }, order: 186);
        raid.Schedule(TimeSpan.FromSeconds(5.249), () => { raid.SpawnEObj("tower_09", new Params { ["base"] = 2015296, ["flags"] = 5, ["hidden"] = false, ["layout"] = 12327430, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -0.34913, ["state"] = 0, ["args1"] = 2, ["args2"] = 4653059, ["pos"] = new Position(103.4202, 0.0, 90.6031) }); }, order: 187);
        raid.Schedule(TimeSpan.FromSeconds(8.043), () => { raid.AnimateEObj("tower_02", 16, 32); }, order: 189);
        raid.Schedule(TimeSpan.FromSeconds(8.043), () => { raid.AnimateEObj("tower_04", 16, 32); }, order: 191);
        raid.Schedule(TimeSpan.FromSeconds(8.043), () => { raid.AnimateEObj("tower_06", 16, 32); }, order: 193);
        raid.Schedule(TimeSpan.FromSeconds(8.043), () => { raid.AnimateEObj("tower_09", 16, 32); }, order: 195);
    }
}
