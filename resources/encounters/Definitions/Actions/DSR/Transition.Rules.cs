using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.DSR;
public partial class Transition : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [25584] = new Params { ["kind"] = "visual" },
        [25587] = new Params { ["kind"] = "visual" },
        [25588] = new Params { ["kind"] = "visual" },
        [26810] = new Params { ["kind"] = "raid", ["damage"] = 75000 },
        [28051] = new Params { ["kind"] = "visual" },
        [28052] = new Params { ["kind"] = "visual" },
        [28053] = new Params { ["kind"] = "visual" },
        [28057] = new Params { ["kind"] = "visual" },
        [28059] = new Params { ["kind"] = "visual" },
        [28062] = new Params { ["kind"] = "visual" },
        [28206] = new Params { ["kind"] = "visual" },
        [28207] = new Params { ["kind"] = "visual" },
        [28209] = new Params { ["kind"] = "raid", ["damage"] = 9999999, ["unmitigated"] = true },
        [29050] = new Params { ["kind"] = "visual" },
        [29156] = new Params { ["kind"] = "raid", ["damage"] = 100000 },
        [29365] = new Params { ["kind"] = "visual" },
        [29752] = new Params { ["kind"] = "raid", ["damage"] = 150000 },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
