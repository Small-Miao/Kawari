using Kawari.Encounters;
// 本副本演员名称与原生生成模板。
namespace Script.Definitions.r1fz;
public static class ActorDefinitions
{
    public const string Helper09 = "a9";
    public const string Estinien = "a15";
    public const string Helper01 = "a1";
    public const string Helper04 = "a4";
    public const string Helper02 = "a2";
    public const string LeftEye02 = "a19";
    public const string Helper08 = "a8";
    public const string Boss = "a18";
    public const string Helper03 = "a3";
    public const string LeftEye03 = "a20";
    public const string BossP5 = "a17";
    public const string Helper05 = "a5";
    public const string Alphinaud = "a16";
    public const string LeftEye01 = "a14";
    public const string RightEye = "a13";
    public const string HraesvelgrP6 = "a11";
    public const string NidhoggP6 = "a12";
    public const string Helper07 = "a7";
    public const string Helper10 = "a10";
    public const string Helper06 = "a6";
    public static ActorCatalog Build() => new()
    {
        Boss = "a18", BossBase = 12616, DirectorFlag = 1,
        Initial = ["a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "a10", "a11", "a12"],
        Templates = new()
        {
            ["a18"] = new Params { ["layout"] = 8954831, ["targetable"] = false, ["hp"] = 12178508, ["base"] = 12616, ["boss"] = true, ["rotation"] = -5e-05, ["role"] = "DragonKingThordan", ["name"] = 11319, ["model"] = 2969, ["level"] = 90, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(100.0, 0.0, 88.0), ["model_attribute_flags"] = 0 },
            ["a15"] = new Params { ["layout"] = 8904694, ["targetable"] = false, ["hp"] = 6920000, ["base"] = 13119, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "Estinien", ["name"] = 11312, ["model"] = 3291, ["level"] = 90, ["model_state"] = 5, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a8"] = new Params { ["owner"] = "a12", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 0.70444, ["role"] = "Helper", ["name"] = 3642, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(78.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a9"] = new Params { ["owner"] = "a12", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 1.9026, ["role"] = "Helper", ["name"] = 3642, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(78.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a6"] = new Params { ["owner"] = "a12", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -3.03901, ["role"] = "Helper", ["name"] = 3642, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(114.6972, -0.0, 82.0039), ["model_attribute_flags"] = 0 },
            ["a7"] = new Params { ["owner"] = "a12", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 2.12905, ["role"] = "Helper", ["name"] = 3642, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(78.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a12"] = new Params { ["layout"] = 8981065, ["targetable"] = false, ["hp"] = 4535368, ["base"] = 12612, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "NidhoggP6", ["name"] = 3458, ["model"] = 3444, ["level"] = 90, ["model_state"] = 27, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 16 },
            ["a17"] = new Params { ["layout"] = 8904724, ["targetable"] = false, ["hp"] = 5821796, ["base"] = 12611, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "BossP5", ["name"] = 3632, ["model"] = 3269, ["level"] = 90, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(100.0, 0.0, 88.0), ["model_attribute_flags"] = 16 },
            ["a13"] = new Params { ["layout"] = 8904700, ["targetable"] = false, ["hp"] = 4860608, ["base"] = 12610, ["boss"] = false, ["rotation"] = 0.78536, ["role"] = "RightEye", ["name"] = 11318, ["model"] = 3141, ["level"] = 90, ["model_state"] = 28, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(97.9781, -0.0153, 99.9923), ["model_attribute_flags"] = 0 },
            ["a16"] = new Params { ["layout"] = 8904696, ["targetable"] = false, ["hp"] = 69200, ["base"] = 13769, ["boss"] = false, ["rotation"] = -3.14159, ["role"] = "Alphinaud", ["name"] = 4130, ["model"] = 3499, ["level"] = 90, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393736, ["pos"] = new Position(100.0, 0.0, 110.0), ["model_attribute_flags"] = 0 },
            ["a20"] = new Params { ["layout"] = 9278010, ["targetable"] = false, ["hp"] = 3979000, ["base"] = 12609, ["boss"] = false, ["rotation"] = -3.14159, ["role"] = "LeftEye", ["name"] = 108, ["model"] = 3140, ["level"] = 90, ["model_state"] = 5, ["animation_state"] = 0, ["flags"] = 262155, ["pos"] = new Position(105.0, 0.0, 120.5), ["model_attribute_flags"] = 0 },
            ["a10"] = new Params { ["owner"] = "a12", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -0.49965, ["role"] = "Helper", ["name"] = 3642, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.7941, -0.0, 83.0291), ["model_attribute_flags"] = 0 },
            ["a19"] = new Params { ["layout"] = 9278010, ["targetable"] = false, ["hp"] = 3979000, ["base"] = 12609, ["boss"] = false, ["rotation"] = -3.14159, ["role"] = "LeftEye", ["name"] = 108, ["model"] = 3140, ["level"] = 90, ["model_state"] = 5, ["animation_state"] = 0, ["flags"] = 262155, ["pos"] = new Position(104.0, 0.0, 122.0), ["model_attribute_flags"] = 0 },
            ["a11"] = new Params { ["layout"] = 8904725, ["targetable"] = false, ["hp"] = 4535368, ["base"] = 12613, ["boss"] = false, ["rotation"] = -3.14159, ["role"] = "HraesvelgrP6", ["name"] = 4954, ["model"] = 3386, ["level"] = 90, ["model_state"] = 27, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(100.0, 0.0, 125.0), ["model_attribute_flags"] = 0 },
            ["a14"] = new Params { ["layout"] = 8904699, ["targetable"] = false, ["hp"] = 3979000, ["base"] = 12609, ["boss"] = false, ["rotation"] = -0.78546, ["role"] = "LeftEye", ["name"] = 11317, ["model"] = 3140, ["level"] = 90, ["model_state"] = 28, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(102.0, -0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a1"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "Helper", ["name"] = 3642, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(108.4853, -0.0, 91.5147), ["model_attribute_flags"] = 0 },
            ["a5"] = new Params { ["owner"] = "a12", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -1.26714, ["role"] = "Helper", ["name"] = 3642, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(110.374, -0.0, 89.8522), ["model_attribute_flags"] = 0 },
            ["a4"] = new Params { ["owner"] = "a12", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -0.42679, ["role"] = "Helper", ["name"] = 3642, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(83.1617, -0.0, 88.6463), ["model_attribute_flags"] = 0 },
            ["a3"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 0.01002, ["role"] = "Helper", ["name"] = 3642, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a2"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -2.36836, ["role"] = "Helper", ["name"] = 3642, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
        },
        DeathEffects = new()
        {
        },
    };
}
