using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.TOP;
public partial class CosmoArrow : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [31651] = new Params { ["kind"] = "rect", ["width"] = 10, ["length"] = 40, ["damage"] = 9999999, ["unmitigated"] = true },
        [31652] = new Params { ["kind"] = "rect", ["width"] = 5, ["length"] = 100, ["damage"] = 9999999, ["unmitigated"] = true },
        [31655] = new Params { ["kind"] = "dive_tank", ["punish_status"] = 2941, ["status_duration"] = 2, ["damage"] = 270000, ["status"] = 2941, ["radius"] = 8 },
        [31656] = new Params { ["kind"] = "dive_stack", ["status_duration"] = 2, ["punish_status"] = 2941, ["split"] = true, ["min_players"] = 6, ["damage"] = 570000, ["status"] = 2941, ["radius"] = 6 },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
