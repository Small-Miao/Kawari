using Kawari.Encounters;
// 本副本演员名称与原生生成模板。
namespace Script.Definitions.z3oy;
public static class ActorDefinitions
{
    public const string Helper09 = "a9";
    public const string Helper01 = "a1";
    public const string Helper04 = "a4";
    public const string Helper12 = "a12";
    public const string Helper02 = "a2";
    public const string KefkaP4 = "a17";
    public const string Helper08 = "a8";
    public const string Helper15 = "a15";
    public const string Helper03 = "a3";
    public const string Helper05 = "a5";
    public const string Boss = "a18";
    public const string Helper16 = "a16";
    public const string Helper14 = "a14";
    public const string Helper11 = "a11";
    public const string Helper13 = "a13";
    public const string Helper07 = "a7";
    public const string Helper10 = "a10";
    public const string Helper06 = "a6";
    public static ActorCatalog Build() => new()
    {
        Boss = "a18", BossBase = 19511, DirectorFlag = 1,
        Initial = ["a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "a10", "a11", "a12", "a13", "a14", "a15", "a16", "a17"],
        Templates = new()
        {
            ["a18"] = new Params { ["layout"] = 12326701, ["targetable"] = false, ["hp"] = 56943803, ["base"] = 19511, ["boss"] = true, ["rotation"] = -5e-05, ["role"] = "UltimaKefka", ["name"] = 7131, ["model"] = 4965, ["level"] = 100, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a15"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 2.48216, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.9731, 0.0, 100.0171), ["model_attribute_flags"] = 0 },
            ["a8"] = new Params { ["owner"] = "a17", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 0.78536, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a9"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 2.29808, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.8414, 0.0, 100.1266), ["model_attribute_flags"] = 0 },
            ["a6"] = new Params { ["owner"] = "a17", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 0.78536, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(82.3223, 0.0, 89.3934), ["model_attribute_flags"] = 0 },
            ["a7"] = new Params { ["owner"] = "a17", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -2.35628, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a12"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -2.89711, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0656, 0.0, 100.2862), ["model_attribute_flags"] = 0 },
            ["a17"] = new Params { ["layout"] = 12743243, ["targetable"] = false, ["hp"] = 42678195, ["base"] = 18475, ["boss"] = false, ["rotation"] = 3.10746, ["role"] = "KefkaP4", ["name"] = 7131, ["model"] = 4966, ["level"] = 100, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["model_attribute_flags"] = 0 },
            ["a13"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -3.13268, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.2621, 0.0, 100.1627), ["model_attribute_flags"] = 0 },
            ["a16"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 0.67731, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.8723, 0.0, 99.8431), ["model_attribute_flags"] = 0 },
            ["a10"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -0.20599, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.9989, 0.0, 99.9607), ["model_attribute_flags"] = 0 },
            ["a11"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 1.87709, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.7313, 0.0, 100.0749), ["model_attribute_flags"] = 0 },
            ["a14"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 2.98004, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.877, 0.0, 100.6999), ["model_attribute_flags"] = 0 },
            ["a1"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 90.0), ["model_attribute_flags"] = 0 },
            ["a5"] = new Params { ["owner"] = "a17", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 0.78536, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(75.2513, 0.0, 96.4645), ["model_attribute_flags"] = 0 },
            ["a4"] = new Params { ["owner"] = "a17", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 0.78536, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(96.4645, 0.0, 75.2513), ["model_attribute_flags"] = 0 },
            ["a3"] = new Params { ["owner"] = "a17", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 0.78536, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(89.3934, 0.0, 82.3223), ["model_attribute_flags"] = 0 },
            ["a2"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "Helper", ["name"] = 7131, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 90.0), ["model_attribute_flags"] = 0 },
        },
        DeathEffects = new()
        {
        },
    };
}
