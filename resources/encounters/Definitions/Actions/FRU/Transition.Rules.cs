using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.FRU;
public partial class Transition : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [40114] = new Params { ["kind"] = "visual" },
        [40115] = new Params { ["kind"] = "tank_auto", ["damage"] = 100000, ["physical"] = true },
        [40231] = new Params { ["kind"] = "visual" },
        [40232] = new Params { ["kind"] = "visual" },
        [40233] = new Params { ["kind"] = "visual" },
        [40234] = new Params { ["kind"] = "visual" },
        [40306] = new Params { ["kind"] = "raid", ["damage"] = 180000 },
        [40310] = new Params { ["kind"] = "visual" },
        [40313] = new Params { ["kind"] = "visual" },
        [40316] = new Params { ["kind"] = "visual" },
        [40319] = new Params { ["kind"] = "visual" },
        [40326] = new Params { ["kind"] = "raid", ["damage"] = 700000, ["requires_lb"] = true },
        [40327] = new Params { ["kind"] = "visual" },
        [40328] = new Params { ["kind"] = "raid", ["damage"] = 9999999, ["unmitigated"] = true },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
