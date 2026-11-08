using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.FRU;
public partial class PolarizingStrikes : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [40119] = new Params { ["kind"] = "afterglow", ["width"] = 6, ["side"] = 1, ["length"] = 100, ["damage"] = 9999999, ["unmitigated"] = true },
        [40120] = new Params { ["kind"] = "afterglow", ["width"] = 6, ["side"] = -1, ["length"] = 100, ["damage"] = 9999999, ["unmitigated"] = true },
        [40311] = new Params { ["kind"] = "side_stack", ["side"] = 1, ["split"] = true, ["damage"] = 480000, ["min_players"] = 4, ["radius"] = 4 },
        [40312] = new Params { ["kind"] = "side_stack", ["side"] = -1, ["split"] = true, ["damage"] = 480000, ["min_players"] = 4, ["radius"] = 4 },
        [40317] = new Params { ["kind"] = "polarizing", ["side"] = 1, ["first_status_duration"] = 16, ["first_status"] = 4164, ["status"] = 2941, ["status_duration"] = 1, ["min_players"] = 4, ["width"] = 6, ["punish_status"] = 4164, ["split"] = true, ["length"] = 100, ["damage"] = 450000 },
        [40318] = new Params { ["kind"] = "polarizing", ["side"] = -1, ["first_status_duration"] = 16, ["first_status"] = 3323, ["status"] = 2941, ["status_duration"] = 1, ["min_players"] = 4, ["width"] = 6, ["punish_status"] = 3323, ["split"] = true, ["length"] = 100, ["damage"] = 450000 },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
