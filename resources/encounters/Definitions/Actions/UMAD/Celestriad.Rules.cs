using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.UMAD;
public partial class Celestriad : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [47938] = new Params { ["kind"] = "visual" },
        [47939] = new Params { ["kind"] = "circle", ["punish_status"] = 2902, ["split"] = true, ["status_duration"] = 20, ["damage"] = 240000, ["status"] = 2902, ["radius"] = 3 },
        [47940] = new Params { ["kind"] = "circle", ["punish_status"] = 2903, ["split"] = true, ["status_duration"] = 20, ["damage"] = 240000, ["status"] = 2903, ["radius"] = 3 },
        [47941] = new Params { ["kind"] = "circle", ["punish_status"] = 2998, ["split"] = true, ["status_duration"] = 20, ["damage"] = 240000, ["status"] = 2998, ["radius"] = 3 },
        [47942] = new Params { ["kind"] = "raid", ["damage"] = 100000, ["status"] = 2911, ["status_duration"] = 180 },
        [47943] = new Params { ["kind"] = "raid", ["damage"] = 100000, ["status"] = 2911, ["status_duration"] = 180 },
        [47944] = new Params { ["kind"] = "raid", ["damage"] = 100000, ["status"] = 2911, ["status_duration"] = 180 },
        [47946] = new Params { ["kind"] = "circle", ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 10 },
        [47947] = new Params { ["kind"] = "donut", ["outer"] = 40, ["inner"] = 10, ["unmitigated"] = true, ["damage"] = 9999999 },
        [49743] = new Params { ["kind"] = "visual" },
        [49746] = new Params { ["kind"] = "visual" },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
