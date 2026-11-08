using Kawari.Encounters;
// 本副本演员名称与原生生成模板。
namespace Script.Definitions.z3oz;
public static class ActorDefinitions
{
    public const string Helper21 = "a21";
    public const string Helper01 = "a1";
    public const string Helper10 = "a10";
    public const string Helper26 = "a26";
    public const string Helper08 = "a8";
    public const string Helper15 = "a15";
    public const string Helper23 = "a23";
    public const string Helper22 = "a22";
    public const string Helper14 = "a14";
    public const string CosmoComet01 = "a39";
    public const string Helper11 = "a11";
    public const string Helper18 = "a18";
    public const string Helper27 = "a27";
    public const string CosmoMeteor02 = "a38";
    public const string Helper31 = "a31";
    public const string Helper09 = "a9";
    public const string Helper16 = "a16";
    public const string Helper04 = "a4";
    public const string CosmoComet06 = "a44";
    public const string CosmoComet05 = "a43";
    public const string Helper20 = "a20";
    public const string Helper12 = "a12";
    public const string CosmoComet03 = "a41";
    public const string Helper06 = "a6";
    public const string Helper02 = "a2";
    public const string Helper28 = "a28";
    public const string CosmoMeteor01 = "a37";
    public const string IntermissionOmegaF = "a36";
    public const string IntermissionAlpha = "a35";
    public const string Boss = "a34";
    public const string Helper13 = "a13";
    public const string Helper03 = "a3";
    public const string Helper32 = "a32";
    public const string Helper30 = "a30";
    public const string BossP5 = "a33";
    public const string Helper05 = "a5";
    public const string Helper25 = "a25";
    public const string Helper19 = "a19";
    public const string CosmoComet04 = "a42";
    public const string Helper24 = "a24";
    public const string Helper17 = "a17";
    public const string Helper07 = "a7";
    public const string Helper29 = "a29";
    public const string CosmoComet02 = "a40";
    public static ActorCatalog Build() => new()
    {
        Boss = "a34", BossBase = 15725, DirectorFlag = 1,
        Initial = ["a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "a10", "a11", "a12", "a13", "a14", "a15", "a16", "a17", "a18", "a19", "a20", "a21", "a22", "a23", "a24", "a25", "a26", "a27", "a28", "a29", "a30", "a31", "a32", "a33"],
        Templates = new()
        {
            ["a27"] = new Params { ["owner"] = "a33", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -1.75648, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(82.406, 0.0, 92.9777), ["model_attribute_flags"] = 0 },
            ["a41"] = new Params { ["layout"] = 9561321, ["targetable"] = true, ["hp"] = 228360, ["base"] = 15727, ["boss"] = false, ["rotation"] = 2.61792, ["role"] = "CosmoComet", ["name"] = 12260, ["model"] = 819, ["level"] = 90, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262147, ["pos"] = new Position(93.5, 0.0, 111.2584), ["model_attribute_flags"] = 0 },
            ["a25"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 0.78833, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a8"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -2.59242, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.9445, 0.0318, 99.7476), ["model_attribute_flags"] = 0 },
            ["a6"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 90.0), ["model_attribute_flags"] = 0 },
            ["a12"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -2.83844, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.9445, 0.0318, 99.7476), ["model_attribute_flags"] = 0 },
            ["a28"] = new Params { ["owner"] = "a33", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 3.05559, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.224, 0.0, 90.6504), ["model_attribute_flags"] = 0 },
            ["a32"] = new Params { ["owner"] = "a33", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -2.84658, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(101.9972, 0.0, 111.3811), ["model_attribute_flags"] = 0 },
            ["a23"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 1.56406, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a29"] = new Params { ["owner"] = "a33", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -2.46097, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(91.9766, 0.0, 101.936), ["model_attribute_flags"] = 0 },
            ["a16"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -0.5008, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a43"] = new Params { ["layout"] = 9561321, ["targetable"] = true, ["hp"] = 228360, ["base"] = 15727, ["boss"] = false, ["rotation"] = -1.57087, ["role"] = "CosmoComet", ["name"] = 12260, ["model"] = 819, ["level"] = 90, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262147, ["pos"] = new Position(113.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a36"] = new Params { ["layout"] = 9632005, ["targetable"] = false, ["hp"] = 10380000, ["base"] = 15990, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "IntermissionOmegaF", ["name"] = 12258, ["model"] = 1233, ["level"] = 90, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 16 },
            ["a24"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 1.18219, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a4"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 90.0), ["model_attribute_flags"] = 0 },
            ["a44"] = new Params { ["layout"] = 9561321, ["targetable"] = true, ["hp"] = 228360, ["base"] = 15727, ["boss"] = false, ["rotation"] = -0.52362, ["role"] = "CosmoComet", ["name"] = 12260, ["model"] = 819, ["level"] = 90, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262147, ["pos"] = new Position(106.5, 0.0, 88.7417), ["model_attribute_flags"] = 0 },
            ["a2"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 90.0), ["model_attribute_flags"] = 0 },
            ["a18"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 1.17222, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a15"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 0.67367, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a9"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -2.64668, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.9445, 0.0318, 99.7476), ["model_attribute_flags"] = 0 },
            ["a35"] = new Params { ["layout"] = 9632004, ["targetable"] = false, ["hp"] = 69200, ["base"] = 15989, ["boss"] = false, ["rotation"] = -3.14159, ["role"] = "IntermissionAlpha", ["name"] = 7142, ["model"] = 2147, ["level"] = 90, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(100.0, 0.0, 101.4), ["model_attribute_flags"] = 0 },
            ["a7"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 0.54922, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.9445, 0.0318, 99.7476), ["model_attribute_flags"] = 0 },
            ["a22"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a17"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 1.71353, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a42"] = new Params { ["layout"] = 9561321, ["targetable"] = true, ["hp"] = 228360, ["base"] = 15727, ["boss"] = false, ["rotation"] = -2.61802, ["role"] = "CosmoComet", ["name"] = 12260, ["model"] = 819, ["level"] = 90, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262147, ["pos"] = new Position(106.5, 0.0, 111.2583), ["model_attribute_flags"] = 0 },
            ["a40"] = new Params { ["layout"] = 9561321, ["targetable"] = true, ["hp"] = 228360, ["base"] = 15727, ["boss"] = false, ["rotation"] = 1.57077, ["role"] = "CosmoComet", ["name"] = 12260, ["model"] = 819, ["level"] = 90, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262147, ["pos"] = new Position(87.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a31"] = new Params { ["owner"] = "a33", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -1.02524, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(119.1128, 0.0, 100.9695), ["model_attribute_flags"] = 0 },
            ["a38"] = new Params { ["layout"] = 9561320, ["targetable"] = true, ["hp"] = 482324, ["base"] = 15726, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "CosmoMeteor", ["name"] = 12259, ["model"] = 3417, ["level"] = 90, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262147, ["pos"] = new Position(100.0, 0.0, 90.0), ["model_attribute_flags"] = 0 },
            ["a37"] = new Params { ["layout"] = 9561320, ["targetable"] = true, ["hp"] = 482324, ["base"] = 15726, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "CosmoMeteor", ["name"] = 12259, ["model"] = 3417, ["level"] = 90, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262147, ["pos"] = new Position(100.0, 0.0, 110.0), ["model_attribute_flags"] = 0 },
            ["a13"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 2.64362, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.9445, 0.0318, 99.7476), ["model_attribute_flags"] = 0 },
            ["a10"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 0.55823, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.9445, 0.0318, 99.7476), ["model_attribute_flags"] = 0 },
            ["a39"] = new Params { ["layout"] = 9561321, ["targetable"] = true, ["hp"] = 228360, ["base"] = 15727, ["boss"] = false, ["rotation"] = 0.52353, ["role"] = "CosmoComet", ["name"] = 12260, ["model"] = 819, ["level"] = 90, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262147, ["pos"] = new Position(93.5, 0.0, 88.7417), ["model_attribute_flags"] = 0 },
            ["a33"] = new Params { ["layout"] = 9561222, ["targetable"] = false, ["hp"] = 13707136, ["base"] = 15720, ["boss"] = false, ["rotation"] = -3.13594, ["role"] = "BossP5", ["name"] = 12257, ["model"] = 3802, ["level"] = 90, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(98.9853, 0.0153, 98.0087), ["model_attribute_flags"] = 16 },
            ["a30"] = new Params { ["owner"] = "a33", ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -0.29841, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(92.9108, 0.0, 117.6499), ["model_attribute_flags"] = 0 },
            ["a20"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -0.37243, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a21"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 0.40387, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a19"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -1.921, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a26"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -0.78987, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a14"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 1.3864, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
            ["a1"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 90.0), ["model_attribute_flags"] = 0 },
            ["a5"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 90.0), ["model_attribute_flags"] = 0 },
            ["a11"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = 0.45641, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(99.9445, 0.0318, 99.7476), ["model_attribute_flags"] = 0 },
            ["a3"] = new Params { ["layout"] = 0, ["targetable"] = false, ["hp"] = 44, ["base"] = 9020, ["boss"] = false, ["rotation"] = -5e-05, ["role"] = "Helper", ["name"] = 7695, ["model"] = 480, ["level"] = 1, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 262152, ["pos"] = new Position(100.0, 0.0, 90.0), ["model_attribute_flags"] = 0 },
            ["a34"] = new Params { ["layout"] = 9561318, ["targetable"] = false, ["hp"] = 20530948, ["base"] = 15725, ["boss"] = true, ["rotation"] = -5e-05, ["role"] = "BossP6", ["name"] = 12256, ["model"] = 3524, ["level"] = 90, ["model_state"] = 0, ["animation_state"] = 0, ["flags"] = 393227, ["pos"] = new Position(100.0, 0.0, 100.0), ["model_attribute_flags"] = 0 },
        },
        DeathEffects = new()
        {
            ["a40"] = new Params { ["index"] = 16, ["timeline"] = 8, ["state"] = 4 },
            ["a41"] = new Params { ["index"] = 15, ["timeline"] = 8, ["state"] = 4 },
            ["a38"] = new Params { ["index"] = 18, ["timeline"] = 8, ["state"] = 4 },
            ["a39"] = new Params { ["index"] = 17, ["timeline"] = 8, ["state"] = 4 },
            ["a42"] = new Params { ["index"] = 14, ["timeline"] = 8, ["state"] = 4 },
            ["a43"] = new Params { ["index"] = 13, ["timeline"] = 8, ["state"] = 4 },
            ["a44"] = new Params { ["index"] = 12, ["timeline"] = 8, ["state"] = 4 },
            ["a37"] = new Params { ["index"] = 19, ["timeline"] = 8, ["state"] = 4 },
        },
    };
}
