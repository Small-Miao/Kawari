using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.UMAD;
public partial class MaddeningOrchestra : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [47952] = new Params { ["kind"] = "visual" },
        [47953] = new Params { ["kind"] = "visual" },
        [47954] = new Params { ["kind"] = "circle", ["punish_status"] = 2941, ["status_duration"] = 2, ["damage"] = 500000, ["status"] = 2941, ["radius"] = 5 },
        [47955] = new Params { ["kind"] = "circle", ["status_duration"] = 2, ["punish_status"] = 2941, ["split"] = true, ["min_players"] = 2, ["damage"] = 900000, ["status"] = 2941, ["radius"] = 5 },
        [47956] = new Params { ["kind"] = "circle", ["punish_status"] = 2941, ["status_duration"] = 4, ["damage"] = 130000, ["status"] = 2941, ["radius"] = 5 },
        [47957] = new Params { ["kind"] = "circle", ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 25 },
        [47958] = new Params { ["kind"] = "circle", ["status_duration"] = 2, ["punish_status"] = 2941, ["split"] = true, ["min_players"] = 4, ["damage"] = 1280000, ["status"] = 2941, ["radius"] = 6 },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
