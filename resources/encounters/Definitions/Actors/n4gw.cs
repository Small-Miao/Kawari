using Kawari.Encounters;
// 本副本演员名称与原生生成模板。
namespace Script.Definitions.n4gw;
public static class ActorDefinitions
{
    public const string VisionOfGaia = "a15";
    public const string Helper09 = "a9";
    public const string Helper01 = "a1";
    public const string Helper04 = "a4";
    public const string OracleOfDarknessP4 = "a17";
    public const string Helper12 = "a12";
    public const string Helper02 = "a2";
    public const string Helper08 = "a8";
    public const string Boss = "a19";
    public const string Helper03 = "a3";
    public const string VisionOfRyne = "a16";
    public const string UsurperOfFrostP4 = "a18";
    public const string Helper05 = "a5";
    public const string Helper14 = "a14";
    public const string Helper11 = "a11";
    public const string Helper13 = "a13";
    public const string Helper07 = "a7";
    public const string Helper10 = "a10";
    public const string Helper06 = "a6";
    public static ActorCatalog Build() => new()
    {
        Boss = "a19", BossBase = 17839, DirectorFlag = 1,
        Initial = ["a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "a10", "a11", "a12", "a13", "a14", "a15", "a16", "a17", "a18"],
        Templates = new()
        {
            ["a18"] = new Params { ["layout"] = 10836993, ["targetable"] = false, ["hp"] = 11943869, ["base"] = 17833, ["boss"] = false, ["rotation"] = -0.78546, ["role"] = "UsurperOfFrostP4", ["name"] = 12809, ["model"] = 4375, ["level"] = 100, ["model_state"] = 4, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(96.4523, 0.0153, 99.9924), ["model_attribute_flags"] = 252 },
            ["a15"] = new Params { ["layout"] = 10858276, ["targetable"] = false, ["hp"] = 188300, ["base"] = 17845, ["boss"] = false, ["rotation"] = 1.22169, ["role"] = "VisionOfGaia", ["name"] = 9830, ["model"] = 4436, ["level"] = 100, ["model_state"] = 31, ["animation_state"] = 0, ["flags"] = 393739, ["pos"] = new Position(99.2876, 0.0, 84.0), ["model_attribute_flags"] = 0 },
            ["a8"] = new Params { ["owner"] = "a17", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -3.14159, ["role"] = "Helper", ["name"] = 9707, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.04, 100.0), ["model_attribute_flags"] = 0 },
            ["a9"] = new Params { ["owner"] = "a17", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -3.14159, ["role"] = "Helper", ["name"] = 9707, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.04, 100.0), ["model_attribute_flags"] = 0 },
            ["a6"] = new Params { ["owner"] = "a18", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 1.1123, ["role"] = "Helper", ["name"] = 9707, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(92.4591, 0.0, 92.9938), ["model_attribute_flags"] = 0 },
            ["a7"] = new Params { ["owner"] = "a17", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -3.14159, ["role"] = "Helper", ["name"] = 9707, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.04, 100.0), ["model_attribute_flags"] = 0 },
            ["a12"] = new Params { ["owner"] = "a17", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -0.08193, ["role"] = "Helper", ["name"] = 9707, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.8887, 0.0, 103.2928), ["model_attribute_flags"] = 0 },
            ["a17"] = new Params { ["layout"] = 10836994, ["targetable"] = false, ["hp"] = 11943869, ["base"] = 17835, ["boss"] = false, ["rotation"] = 0.78536, ["role"] = "OracleOfDarknessP4", ["name"] = 9832, ["model"] = 3057, ["level"] = 100, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(103.5325, 0.0153, 99.9924), ["model_attribute_flags"] = 0 },
            ["a13"] = new Params { ["owner"] = "a17", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -0.04684, ["role"] = "Helper", ["name"] = 9707, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.8047, 0.0, 103.7985), ["model_attribute_flags"] = 0 },
            ["a16"] = new Params { ["layout"] = 10858275, ["targetable"] = false, ["hp"] = 188300, ["base"] = 17844, ["boss"] = false, ["rotation"] = -0.83781, ["role"] = "VisionOfRyne", ["name"] = 9829, ["model"] = 2720, ["level"] = 100, ["model_state"] = 5, ["animation_state"] = 0, ["flags"] = 393738, ["pos"] = new Position(100.7124, 0.0, 84.0), ["model_attribute_flags"] = 0 },
            ["a10"] = new Params { ["owner"] = "a18", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -3.14159, ["role"] = "Helper", ["name"] = 9707, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 90.0), ["model_attribute_flags"] = 0 },
            ["a19"] = new Params { ["layout"] = 10836998, ["targetable"] = false, ["hp"] = 48541857, ["base"] = 17839, ["boss"] = true, ["rotation"] = -5e-05, ["role"] = "BossP5", ["name"] = 13561, ["model"] = 4293, ["level"] = 100, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a11"] = new Params { ["owner"] = "a17", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 3.10717, ["role"] = "Helper", ["name"] = 9707, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.9993, 0.0, 104.8233), ["model_attribute_flags"] = 0 },
            ["a14"] = new Params { ["owner"] = "a18", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -3.14159, ["role"] = "Helper", ["name"] = 9707, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a1"] = new Params { ["owner"] = "a18", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 1.10281, ["role"] = "Helper", ["name"] = 9707, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(92.7744, 0.0, 93.0652), ["model_attribute_flags"] = 0 },
            ["a5"] = new Params { ["owner"] = "a18", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 1.07213, ["role"] = "Helper", ["name"] = 9707, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(93.0754, 0.0, 92.9467), ["model_attribute_flags"] = 0 },
            ["a4"] = new Params { ["owner"] = "a18", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -1.08957, ["role"] = "Helper", ["name"] = 9707, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(107.1324, 0.0, 92.9505), ["model_attribute_flags"] = 0 },
            ["a3"] = new Params { ["owner"] = "a18", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -2.65052, ["role"] = "Helper", ["name"] = 9707, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(106.1246, 0.0, 93.9212), ["model_attribute_flags"] = 0 },
            ["a2"] = new Params { ["owner"] = "a18", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 1.08794, ["role"] = "Helper", ["name"] = 9707, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(92.9311, 0.0, 93.0115), ["model_attribute_flags"] = 0 },
        },
        DeathEffects = new()
        {
        },
    };
}
