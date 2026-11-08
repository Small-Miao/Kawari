using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.TOP;
public partial class CosmoMeteor : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [31666] = new Params { ["kind"] = "puddle", ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 10 },
        [31667] = new Params { ["kind"] = "meteor_stack", ["split"] = true, ["damage"] = 450000, ["min_players"] = 5, ["radius"] = 6 },
        [31668] = new Params { ["kind"] = "flare", ["damage"] = 350000, ["falloff"] = 30, ["radius"] = 100 },
        [31669] = new Params { ["kind"] = "raid", ["damage"] = 9999999, ["unmitigated"] = true },
        [32699] = new Params { ["kind"] = "spread", ["punish_status"] = 2941, ["status_duration"] = 1.2, ["damage"] = 110000, ["status"] = 2941, ["radius"] = 5 },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
