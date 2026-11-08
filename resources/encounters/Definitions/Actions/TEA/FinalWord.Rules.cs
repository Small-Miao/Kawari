using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.TEA;
public partial class FinalWord : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [18557] = new Params { ["kind"] = "visual" },
        [18558] = new Params { ["kind"] = "visual" },
        [18559] = new Params { ["kind"] = "visual" },
        [18560] = new Params { ["kind"] = "ignore" },
        [18561] = new Params { ["kind"] = "ignore" },
        [18562] = new Params { ["kind"] = "ignore" },
        [18563] = new Params { ["kind"] = "ignore" },
        [18859] = new Params { ["kind"] = "visual" },
        [18860] = new Params { ["kind"] = "visual" },
        [19039] = new Params { ["kind"] = "ignore" },
        [19040] = new Params { ["kind"] = "ignore" },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
