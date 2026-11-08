using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.TEA;
public partial class FateCalibrationAlpha : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [18528] = new Params { ["kind"] = "circle", ["damage"] = 140000, ["radius"] = 30 },
        [18529] = new Params { ["kind"] = "single", ["damage"] = 10000 },
        [18530] = new Params { ["kind"] = "circle", ["split"] = true, ["damage"] = 240000, ["min_players"] = 3, ["radius"] = 4 },
        [18556] = new Params { ["kind"] = "visual" },
        [18569] = new Params { ["kind"] = "visual" },
        [18584] = new Params { ["kind"] = "visual" },
        [18585] = new Params { ["kind"] = "visual" },
        [18586] = new Params { ["kind"] = "visual" },
        [18591] = new Params { ["kind"] = "visual" },
        [18596] = new Params { ["kind"] = "visual" },
        [18597] = new Params { ["kind"] = "visual" },
        [18598] = new Params { ["kind"] = "visual" },
        [18858] = new Params { ["kind"] = "visual" },
        [19213] = new Params { ["kind"] = "visual" },
        [19214] = new Params { ["kind"] = "visual" },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
