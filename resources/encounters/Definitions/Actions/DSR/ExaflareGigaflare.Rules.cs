using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.DSR;
public partial class ExaflareGigaflare : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [28049] = new Params { ["kind"] = "circle", ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 8 },
        [28050] = new Params { ["kind"] = "donut", ["outer"] = 50, ["inner"] = 8, ["unmitigated"] = true, ["damage"] = 9999999 },
        [28058] = new Params { ["kind"] = "circle", ["damage"] = 300000, ["falloff"] = 25, ["radius"] = 50 },
        [28060] = new Params { ["kind"] = "circle", ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 6 },
        [28061] = new Params { ["kind"] = "circle", ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 6 },
        [28114] = new Params { ["kind"] = "circle", ["damage"] = 300000, ["falloff"] = 25, ["radius"] = 50 },
        [28115] = new Params { ["kind"] = "circle", ["damage"] = 300000, ["falloff"] = 25, ["radius"] = 50 },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
