using Kawari.Encounters;
// 光尘之剑 [40306]：地图 / EObj / 音乐 / 天气 / 过场。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Scene03FulgentBlade
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.138), () => { raid.SpawnEObj("blade_01", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -2.35628, ["state"] = 0, ["args1"] = 4, ["args2"] = 4521987, ["pos"] = new Position(89.3934, 0.0, 89.3934) }); }, order: 55);
        raid.Schedule(TimeSpan.FromSeconds(0.138), () => { raid.SpawnEObj("blade_02", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -5e-05, ["state"] = 0, ["args1"] = 4, ["args2"] = 4456451, ["pos"] = new Position(100.0, 0.0, 90.0) }); }, order: 56);
        raid.Schedule(TimeSpan.FromSeconds(0.138), () => { raid.SpawnEObj("blade_03", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -1.57087, ["state"] = 0, ["args1"] = 4, ["args2"] = 4390915, ["pos"] = new Position(103.0, 0.0, 100.0) }); }, order: 57);
        raid.Schedule(TimeSpan.FromSeconds(0.138), () => { raid.SpawnEObj("blade_04", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = 2.35618, ["state"] = 0, ["args1"] = 4, ["args2"] = 4325379, ["pos"] = new Position(103.5858, 0.0, 96.4142) }); }, order: 58);
        raid.Schedule(TimeSpan.FromSeconds(0.138), () => { raid.SpawnEObj("blade_05", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -5e-05, ["state"] = 0, ["args1"] = 4, ["args2"] = 4259843, ["pos"] = new Position(100.0, 0.0, 110.0) }); }, order: 59);
        raid.Schedule(TimeSpan.FromSeconds(0.138), () => { raid.SpawnEObj("blade_06", new Params { ["base"] = 2014199, ["flags"] = 5, ["hidden"] = false, ["layout"] = 0, ["bind_layout"] = 0, ["radius"] = 1.0, ["rotation"] = -2.35628, ["state"] = 0, ["args1"] = 4, ["args2"] = 4194307, ["pos"] = new Position(103.5858, 0.0, 103.5858) }); }, order: 60);
        raid.Schedule(TimeSpan.FromSeconds(8.049), () => { raid.AnimateEObj("blade_06", 1, 2); }, order: 62);
        raid.Schedule(TimeSpan.FromSeconds(8.049), () => { raid.AnimateEObj("blade_05", 1, 2); }, order: 63);
        raid.Schedule(TimeSpan.FromSeconds(8.049), () => { raid.AnimateEObj("blade_04", 1, 2); }, order: 64);
        raid.Schedule(TimeSpan.FromSeconds(8.049), () => { raid.AnimateEObj("blade_03", 1, 2); }, order: 65);
        raid.Schedule(TimeSpan.FromSeconds(8.049), () => { raid.AnimateEObj("blade_02", 1, 2); }, order: 66);
        raid.Schedule(TimeSpan.FromSeconds(8.049), () => { raid.AnimateEObj("blade_01", 1, 2); }, order: 67);
        raid.Schedule(TimeSpan.FromSeconds(10.013), () => { raid.AnimateEObj("blade_06", 32, 16); }, order: 78);
        raid.Schedule(TimeSpan.FromSeconds(10.013), () => { raid.AnimateEObj("blade_05", 32, 16); }, order: 83);
        raid.Schedule(TimeSpan.FromSeconds(14.015), () => { raid.AnimateEObj("blade_04", 32, 16); }, order: 108);
        raid.Schedule(TimeSpan.FromSeconds(14.015), () => { raid.AnimateEObj("blade_03", 32, 16); }, order: 115);
        raid.Schedule(TimeSpan.FromSeconds(17.078), () => { raid.AnimateEObj("blade_06", 4, 8); }, order: 131);
        raid.Schedule(TimeSpan.FromSeconds(17.078), () => { raid.AnimateEObj("blade_05", 4, 8); }, order: 132);
        raid.Schedule(TimeSpan.FromSeconds(18.03), () => { raid.AnimateEObj("blade_02", 32, 16); }, order: 137);
        raid.Schedule(TimeSpan.FromSeconds(18.03), () => { raid.AnimateEObj("blade_01", 32, 16); }, order: 144);
        raid.Schedule(TimeSpan.FromSeconds(19.352), () => { raid.RemoveEObj("blade_05"); }, order: 167);
        raid.Schedule(TimeSpan.FromSeconds(19.352), () => { raid.RemoveEObj("blade_06"); }, order: 168);
        raid.Schedule(TimeSpan.FromSeconds(21.108), () => { raid.AnimateEObj("blade_03", 4, 8); }, order: 174);
        raid.Schedule(TimeSpan.FromSeconds(21.108), () => { raid.AnimateEObj("blade_04", 4, 8); }, order: 175);
        raid.Schedule(TimeSpan.FromSeconds(23.337), () => { raid.RemoveEObj("blade_03"); }, order: 213);
        raid.Schedule(TimeSpan.FromSeconds(23.337), () => { raid.RemoveEObj("blade_04"); }, order: 214);
    }
}
