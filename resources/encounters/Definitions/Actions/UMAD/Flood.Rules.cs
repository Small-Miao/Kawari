using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.UMAD;
public partial class Flood : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [47951] = new Params { ["kind"] = "circle", ["split"] = true, ["damage"] = 880000, ["min_players"] = 8, ["radius"] = 6 },
        [49471] = new Params { ["kind"] = "visual" },
        [49539] = new Params { ["kind"] = "visual" },
        [49769] = new Params { ["kind"] = "rect", ["width"] = 10, ["length"] = 40, ["damage"] = 9999999, ["unmitigated"] = true },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
