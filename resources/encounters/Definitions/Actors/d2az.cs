using Kawari.Encounters;
// 本副本演员名称与原生生成模板。
namespace Script.Definitions.d2az;
public static class ActorDefinitions
{
    public const string PerfectAlexander05 = "a24";
    public const string AlexanderPrimeCutscene = "a3";
    public const string Helper01 = "a9";
    public const string Helper10 = "a18";
    public const string PerfectAlexander04 = "a23";
    public const string Helper08 = "a16";
    public const string FateProjection13 = "a37";
    public const string Boss = "a7";
    public const string CruiseChaserCutscene = "a4";
    public const string Helper11 = "a19";
    public const string BruteJustice = "a5";
    public const string PerfectAlexander02 = "a21";
    public const string Helper09 = "a17";
    public const string FateProjection07 = "a31";
    public const string Helper04 = "a12";
    public const string FateProjection06 = "a30";
    public const string Alexander = "a1";
    public const string Helper12 = "a20";
    public const string FateProjection03 = "a27";
    public const string FateProjection09 = "a33";
    public const string Helper02 = "a10";
    public const string FateProjection15 = "a39";
    public const string CruiseChaser = "a6";
    public const string FateProjection14 = "a38";
    public const string PerfectAlexanderCutscene = "a2";
    public const string FateProjection16 = "a40";
    public const string FateProjection11 = "a35";
    public const string Helper03 = "a11";
    public const string FateProjection02 = "a26";
    public const string FateProjection08 = "a32";
    public const string FateProjection12 = "a36";
    public const string Helper05 = "a13";
    public const string Helper07 = "a15";
    public const string Helper06 = "a14";
    public const string FateProjection10 = "a34";
    public const string FateProjection01 = "a25";
    public const string PerfectAlexander03 = "a22";
    public const string AlexanderPrime = "a8";
    public const string FateProjection05 = "a29";
    public const string FateProjection04 = "a28";
    public static ActorCatalog Build() => new()
    {
        Boss = "a7", BossBase = 11349, DirectorFlag = 1,
        Initial = ["a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "a10", "a11", "a12", "a13", "a14", "a15", "a16", "a17", "a18", "a19", "a20"],
        Templates = new()
        {
            ["a27"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = 2.88378, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 264715, ["pos"] = new Position(93.1199, 0.0, 109.3616), ["model_attribute_flags"] = 0 },
            ["a25"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = -3.05818, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 264715, ["pos"] = new Position(100.7629, 0.0, 109.1918), ["model_attribute_flags"] = 0 },
            ["a8"] = new Params { ["layout"] = 8136070, ["targetable"] = false, ["hp"] = 3180181, ["base"] = 11347, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "AlexanderPrime", ["name"] = 9220, ["model"] = 1583, ["level"] = 80, ["model_state"] = 21, ["animation_state"] = 0, ["flags"] = 393224, ["pos"] = new Position(100.0, 0.0, 88.0), ["model_attribute_flags"] = 0 },
            ["a6"] = new Params { ["layout"] = 8136066, ["targetable"] = false, ["hp"] = 2168926, ["base"] = 11342, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "CruiseChaser", ["name"] = 9218, ["model"] = 1606, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393224, ["pos"] = new Position(109.0, 0.0, 106.0), ["model_attribute_flags"] = 0 },
            ["a12"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 0.44002, ["role"] = "Helper", ["name"] = 9220, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(85.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a28"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = -2.98886, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262667, ["pos"] = new Position(100.109, 0.0, 109.4952), ["model_attribute_flags"] = 0 },
            ["a32"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = 0.08039, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262667, ["pos"] = new Position(100.1501, 0.0, 92.1542), ["model_attribute_flags"] = 0 },
            ["a23"] = new Params { ["layout"] = 8136072, ["targetable"] = false, ["hp"] = 7535109, ["base"] = 11349, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "PerfectAlexander", ["name"] = 9042, ["model"] = 2783, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(99.9822, 0.0, 96.2461), ["model_attribute_flags"] = 0 },
            ["a29"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = -2.01822, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 264715, ["pos"] = new Position(105.5241, 0.0, 102.6468), ["model_attribute_flags"] = 0 },
            ["a16"] = new Params { ["owner"] = "a6", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -1.14624, ["role"] = "Helper", ["name"] = 9220, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["model_attribute_flags"] = 0 },
            ["a36"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = 2.10662, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 264715, ["pos"] = new Position(100.3067, 0.0, 106.1411), ["model_attribute_flags"] = 0 },
            ["a24"] = new Params { ["layout"] = 8136072, ["targetable"] = false, ["hp"] = 7535109, ["base"] = 11349, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "PerfectAlexander", ["name"] = 9042, ["model"] = 2783, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(99.9822, 0.0, 96.2461), ["model_attribute_flags"] = 0 },
            ["a20"] = new Params { ["owner"] = "a5", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "Helper", ["name"] = 9220, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(91.0, 0.0, 106.0), ["model_attribute_flags"] = 0 },
            ["a2"] = new Params { ["layout"] = 8153901, ["targetable"] = false, ["hp"] = 3853782, ["base"] = 11423, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "PerfectAlexanderCutscene", ["name"] = 9042, ["model"] = 2784, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393224, ["pos"] = new Position(87.7861, 0.0, 102.6487), ["model_attribute_flags"] = 0 },
            ["a18"] = new Params { ["owner"] = "a8", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "Helper", ["name"] = 9220, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(111.0866, 0.0, 104.5922), ["model_attribute_flags"] = 0 },
            ["a15"] = new Params { ["owner"] = "a6", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -1.14624, ["role"] = "Helper", ["name"] = 9220, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["model_attribute_flags"] = 0 },
            ["a9"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "Helper", ["name"] = 9220, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(97.3954, 0.0, 108.3706), ["model_attribute_flags"] = 0 },
            ["a35"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = 2.68331, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 264715, ["pos"] = new Position(95.3171, 0.0, 109.4705), ["model_attribute_flags"] = 0 },
            ["a7"] = new Params { ["layout"] = 8136072, ["targetable"] = false, ["hp"] = 7535109, ["base"] = 11349, ["boss"] = true, ["rotation"] = -5e-05, ["role"] = "PerfectAlexander", ["name"] = 9042, ["model"] = 2783, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393224, ["pos"] = new Position(99.9822, 0.0, 96.2461), ["model_attribute_flags"] = 0 },
            ["a22"] = new Params { ["layout"] = 8136072, ["targetable"] = false, ["hp"] = 7535109, ["base"] = 11349, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "PerfectAlexander", ["name"] = 9042, ["model"] = 2783, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(99.9822, 0.0, 96.2461), ["model_attribute_flags"] = 0 },
            ["a17"] = new Params { ["owner"] = "a8", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -1.04729, ["role"] = "Helper", ["name"] = 9220, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(110.247, 0.0, 115.6343), ["model_attribute_flags"] = 0 },
            ["a40"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = 0.03312, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262667, ["pos"] = new Position(99.6474, 0.0, 89.5846), ["model_attribute_flags"] = 0 },
            ["a30"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = -1.5144, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262667, ["pos"] = new Position(107.7524, 0.0, 99.5531), ["model_attribute_flags"] = 0 },
            ["a38"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = -0.90118, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262667, ["pos"] = new Position(108.5132, 0.0, 93.2464), ["model_attribute_flags"] = 0 },
            ["a37"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = -3.13066, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262667, ["pos"] = new Position(100.2986, 0.0, 110.8001), ["model_attribute_flags"] = 0 },
            ["a13"] = new Params { ["owner"] = "a6", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -1.14624, ["role"] = "Helper", ["name"] = 9220, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["model_attribute_flags"] = 0 },
            ["a4"] = new Params { ["layout"] = 8153899, ["targetable"] = false, ["hp"] = 3853782, ["base"] = 11421, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "CruiseChaserCutscene", ["name"] = 9218, ["model"] = 1605, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393224, ["pos"] = new Position(87.2021, 0.0, 95.0504), ["model_attribute_flags"] = 0 },
            ["a39"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = -2.9136, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 264715, ["pos"] = new Position(100.8944, 0.0, 103.8776), ["model_attribute_flags"] = 0 },
            ["a33"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = 1.95849, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 264715, ["pos"] = new Position(92.7119, 0.0, 102.9664), ["model_attribute_flags"] = 0 },
            ["a31"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = 1.99291, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 264715, ["pos"] = new Position(91.2974, 0.0, 103.8976), ["model_attribute_flags"] = 0 },
            ["a11"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -2.01343, ["role"] = "Helper", ["name"] = 9220, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 115.0), ["model_attribute_flags"] = 0 },
            ["a21"] = new Params { ["layout"] = 8136072, ["targetable"] = false, ["hp"] = 7535109, ["base"] = 11349, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "PerfectAlexander", ["name"] = 9042, ["model"] = 2783, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(99.9822, 0.0, 96.2461), ["model_attribute_flags"] = 0 },
            ["a19"] = new Params { ["owner"] = "a5", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -3.09557, ["role"] = "Helper", ["name"] = 9220, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.9717, 0.0, 93.2008), ["model_attribute_flags"] = 0 },
            ["a26"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = 1.51852, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262667, ["pos"] = new Position(87.8266, 0.0, 99.3561), ["model_attribute_flags"] = 0 },
            ["a14"] = new Params { ["owner"] = "a6", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -1.14624, ["role"] = "Helper", ["name"] = 9220, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(95.4037, 0.0308, 108.4593), ["model_attribute_flags"] = 0 },
            ["a1"] = new Params { ["layout"] = 8147090, ["targetable"] = false, ["hp"] = 42687, ["base"] = 6358, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "Alexander", ["name"] = 9225, ["model"] = 480, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(109.8293, 0.0, 88.8354), ["model_attribute_flags"] = 0 },
            ["a5"] = new Params { ["layout"] = 8136064, ["targetable"] = false, ["hp"] = 2168926, ["base"] = 11340, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "BruteJustice", ["name"] = 9216, ["model"] = 1357, ["level"] = 80, ["model_state"] = 4, ["animation_state"] = 0, ["flags"] = 393224, ["pos"] = new Position(91.0, 0.0, 106.0), ["model_attribute_flags"] = 0 },
            ["a10"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 1.08037, ["role"] = "Helper", ["name"] = 9220, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 85.0), ["model_attribute_flags"] = 0 },
            ["a3"] = new Params { ["layout"] = 8153900, ["targetable"] = false, ["hp"] = 3853782, ["base"] = 11422, ["boss"] = false, ["rotation"] = -0.39275, ["role"] = "AlexanderPrimeCutscene", ["name"] = 9220, ["model"] = 2782, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393224, ["pos"] = new Position(108.2277, 0.0, 80.1366), ["model_attribute_flags"] = 16 },
            ["a34"] = new Params { ["layout"] = 8136073, ["targetable"] = false, ["hp"] = 38418, ["base"] = 11350, ["boss"] = false, ["rotation"] = 3.13277, ["role"] = "FateProjection", ["name"] = 108, ["model"] = 0, ["level"] = 80, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262667, ["pos"] = new Position(99.909, 0.0, 109.6217), ["model_attribute_flags"] = 0 },
        },
        DeathEffects = new()
        {
        },
    };
}
