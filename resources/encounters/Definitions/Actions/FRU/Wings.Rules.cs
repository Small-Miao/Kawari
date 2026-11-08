using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.FRU;
public partial class Wings : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [39879] = new Params { ["kind"] = "distance_target", ["punish_status"] = 2941, ["status_duration"] = 4, ["farthest"] = true, ["damage"] = 260000, ["status"] = 2941, ["radius"] = 4 },
        [39880] = new Params { ["kind"] = "distance_target", ["punish_status"] = 2941, ["status_duration"] = 4, ["damage"] = 260000, ["status"] = 2941, ["radius"] = 4 },
        [40314] = new Params { ["kind"] = "wing", ["status_duration"] = 7, ["punish_status"] = 2941, ["damage"] = 280000, ["offset"] = 1.0471975511965976, ["angle"] = 240, ["status"] = 2941, ["radius"] = 100 },
        [40315] = new Params { ["kind"] = "wing", ["status_duration"] = 7, ["punish_status"] = 2941, ["damage"] = 280000, ["offset"] = -1.0471975511965976, ["angle"] = 240, ["status"] = 2941, ["radius"] = 100 },
        [40320] = new Params { ["kind"] = "circle", ["max_players"] = 2, ["tanks"] = 0, ["damage"] = 90000, ["min_players"] = 2, ["radius"] = 3 },
        [40321] = new Params { ["kind"] = "raid", ["damage"] = 9999999, ["unmitigated"] = true },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
