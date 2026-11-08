using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.UMAD;
public partial class UltimaRepeaterFellForces : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [47936] = new Params { ["kind"] = "visual" },
        [47937] = new Params { ["kind"] = "raid", ["damage"] = 135000 },
        [49738] = new Params { ["kind"] = "raid", ["damage"] = 140000 },
        [50173] = new Params { ["kind"] = "visual" },
        [50770] = new Params { ["kind"] = "visual" },
        [50771] = new Params { ["kind"] = "circle", ["punish_status"] = 2941, ["split"] = true, ["status_duration"] = 1.5, ["damage"] = 880000, ["status"] = 2941, ["radius"] = 3 },
        [50772] = new Params { ["kind"] = "circle", ["status_duration"] = 1.5, ["punish_status"] = 2941, ["split"] = true, ["min_players"] = 2, ["damage"] = 220000, ["status"] = 2941, ["radius"] = 5 },
        [50773] = new Params { ["kind"] = "circle", ["status_duration"] = 1.5, ["punish_status"] = 2941, ["split"] = true, ["min_players"] = 4, ["damage"] = 440000, ["status"] = 2941, ["radius"] = 5 },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
