using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.TOP;
public partial class WaveCannon : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [31658] = new Params { ["kind"] = "wildcharge", ["width"] = 8, ["front_damage"] = 370000, ["length"] = 100, ["damage"] = 95000, ["front_tanks"] = 2, ["min_players"] = 8 },
        [31659] = new Params { ["kind"] = "protean", ["width"] = 8, ["punish_status"] = 2941, ["length"] = 100, ["damage"] = 95000, ["status"] = 2941, ["status_duration"] = 2 },
        [31661] = new Params { ["kind"] = "circle", ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 8 },
        [31662] = new Params { ["kind"] = "circle", ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 8 },
        [31663] = new Params { ["kind"] = "puddle", ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 6 },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
