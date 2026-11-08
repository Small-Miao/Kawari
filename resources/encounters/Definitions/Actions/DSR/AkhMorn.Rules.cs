using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.DSR;
public partial class AkhMorn : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [28054] = new Params { ["kind"] = "circle", ["split"] = true, ["damage"] = 225000, ["min_players"] = 1, ["radius"] = 4 },
        [28055] = new Params { ["kind"] = "circle", ["split"] = true, ["min_players"] = 1, ["damage"] = 360000, ["physical"] = true, ["radius"] = 4 },
        [28056] = new Params { ["kind"] = "raid", ["damage"] = 9999999, ["unmitigated"] = true },
        [28208] = new Params { ["kind"] = "circle", ["min_players"] = 1, ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 4 },
        [29452] = new Params { ["kind"] = "circle", ["split"] = true, ["damage"] = 225000, ["min_players"] = 1, ["radius"] = 4 },
        [29453] = new Params { ["kind"] = "circle", ["split"] = true, ["damage"] = 225000, ["min_players"] = 1, ["radius"] = 4 },
        [29454] = new Params { ["kind"] = "circle", ["split"] = true, ["min_players"] = 1, ["damage"] = 360000, ["physical"] = true, ["radius"] = 4 },
        [29455] = new Params { ["kind"] = "circle", ["min_players"] = 1, ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 4 },
        [29456] = new Params { ["kind"] = "circle", ["min_players"] = 1, ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 4 },
        [29457] = new Params { ["kind"] = "circle", ["min_players"] = 1, ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 4 },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
