using Kawari.Encounters;
// 入场及重置恢复前阶段场景，再创建静态物件。
using MechanicSim_Server.Manager;
namespace Script.Definitions.d2az;
public static class InitialScene
{
    public static void Reset()
    {
        RaidManager.Instance.SetupMapEffects(new ushort[] { 0, 1, 4, 1, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }, 5);
        RaidManager.Instance.MapEffect(7, 4, 2);
        RaidManager.Instance.MapEffect(2, 1, 32);
        RaidManager.Instance.MapEffect(1, 1, 2);
        RaidManager.Instance.MapEffect(3, 4, 8);
        RaidManager.Instance.SetWeather(71, 0);
        RaidManager.Instance.PlayBgm(725);
    }
    public static void SpawnObjects()
    {
        RaidManager.Instance.SpawnEObj("prison_01", new Params { ["base"] = 2007457, ["flags"] = 5, ["hidden"] = false, ["layout"] = 8160974, ["bind_layout"] = 8150085, ["radius"] = 1.0, ["rotation"] = -5e-05, ["state"] = 0, ["args1"] = 4, ["args2"] = 0, ["pos"] = new Position(100.0, 0.0, 100.0) });
        RaidManager.Instance.SpawnEObj("prison_02", new Params { ["base"] = 2007457, ["flags"] = 5, ["hidden"] = false, ["layout"] = 8160973, ["bind_layout"] = 8150084, ["radius"] = 1.0, ["rotation"] = -5e-05, ["state"] = 0, ["args1"] = 4, ["args2"] = 0, ["pos"] = new Position(100.0, 0.0, 100.0) });
        RaidManager.Instance.SpawnEObj("prison_03", new Params { ["base"] = 2007457, ["flags"] = 5, ["hidden"] = false, ["layout"] = 8160972, ["bind_layout"] = 8150083, ["radius"] = 1.0, ["rotation"] = -5e-05, ["state"] = 0, ["args1"] = 4, ["args2"] = 0, ["pos"] = new Position(100.0, 0.0, 100.0) });
        RaidManager.Instance.SpawnEObj("prison_04", new Params { ["base"] = 2007457, ["flags"] = 5, ["hidden"] = false, ["layout"] = 8160971, ["bind_layout"] = 8150082, ["radius"] = 1.0, ["rotation"] = -5e-05, ["state"] = 0, ["args1"] = 4, ["args2"] = 0, ["pos"] = new Position(100.0, 0.0, 100.0) });
        RaidManager.Instance.SpawnEObj("prison_05", new Params { ["base"] = 2007457, ["flags"] = 5, ["hidden"] = false, ["layout"] = 8160970, ["bind_layout"] = 8150081, ["radius"] = 1.0, ["rotation"] = -5e-05, ["state"] = 0, ["args1"] = 4, ["args2"] = 0, ["pos"] = new Position(100.0, 0.0, 100.0) });
        RaidManager.Instance.SpawnEObj("prison_06", new Params { ["base"] = 2007457, ["flags"] = 5, ["hidden"] = false, ["layout"] = 8160969, ["bind_layout"] = 8150080, ["radius"] = 1.0, ["rotation"] = -5e-05, ["state"] = 0, ["args1"] = 4, ["args2"] = 0, ["pos"] = new Position(100.0, 0.0, 100.0) });
        RaidManager.Instance.SpawnEObj("prison_07", new Params { ["base"] = 2007457, ["flags"] = 5, ["hidden"] = false, ["layout"] = 8160968, ["bind_layout"] = 8150079, ["radius"] = 1.0, ["rotation"] = -5e-05, ["state"] = 0, ["args1"] = 4, ["args2"] = 0, ["pos"] = new Position(100.0, 0.0, 100.0) });
        RaidManager.Instance.SpawnEObj("prison_08", new Params { ["base"] = 2007457, ["flags"] = 5, ["hidden"] = false, ["layout"] = 8160966, ["bind_layout"] = 8150078, ["radius"] = 1.0, ["rotation"] = -5e-05, ["state"] = 0, ["args1"] = 4, ["args2"] = 0, ["pos"] = new Position(100.0, 0.0, 100.0) });
    }
}
