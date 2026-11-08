using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.FRU;
public partial class FulgentBlade : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [40118] = new Params { ["kind"] = "rect", ["width"] = 80, ["length"] = 5, ["damage"] = 9999999, ["unmitigated"] = true },
        [40307] = new Params { ["kind"] = "rect", ["width"] = 80, ["length"] = 5, ["damage"] = 9999999, ["unmitigated"] = true },
        [40308] = new Params { ["kind"] = "rect", ["width"] = 80, ["length"] = 5, ["damage"] = 9999999, ["unmitigated"] = true },
        [40309] = new Params { ["kind"] = "rect", ["width"] = 80, ["length"] = 5, ["damage"] = 9999999, ["unmitigated"] = true },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
