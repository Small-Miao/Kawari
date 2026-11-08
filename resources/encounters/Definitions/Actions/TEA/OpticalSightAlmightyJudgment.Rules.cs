using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.TEA;
public partial class OpticalSightAlmightyJudgment : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [18570] = new Params { ["kind"] = "visual" },
        [18571] = new Params { ["kind"] = "visual" },
        [18572] = new Params { ["kind"] = "circle", ["damage"] = 100000, ["radius"] = 6 },
        [18573] = new Params { ["kind"] = "circle", ["max_players"] = 4, ["split"] = true, ["damage"] = 240000, ["min_players"] = 4, ["radius"] = 6 },
        [18574] = new Params { ["kind"] = "visual" },
        [18575] = new Params { ["kind"] = "visual" },
        [18576] = new Params { ["kind"] = "circle", ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 6 },
        [18580] = new Params { ["kind"] = "circle", ["split"] = true, ["damage"] = 560000, ["min_players"] = 8, ["radius"] = 6 },
        [18861] = new Params { ["kind"] = "visual" },
        [18862] = new Params { ["kind"] = "visual" },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
