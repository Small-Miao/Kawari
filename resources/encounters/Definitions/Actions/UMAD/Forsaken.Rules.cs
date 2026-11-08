using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.UMAD;
public partial class Forsaken : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [47925] = new Params { ["kind"] = "raid", ["damage"] = 380000 },
        [47926] = new Params { ["kind"] = "raid", ["damage"] = 320000 },
        [47927] = new Params { ["kind"] = "circle", ["death_status"] = 5144, ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 8 },
        [47928] = new Params { ["kind"] = "puddle", ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 8 },
        [47929] = new Params { ["kind"] = "circle", ["split"] = true, ["damage"] = 2400000, ["min_players"] = 8, ["radius"] = 6 },
        [47930] = new Params { ["kind"] = "raid", ["damage"] = 9999999, ["unmitigated"] = true },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
