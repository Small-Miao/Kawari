using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.TEA;
public partial class TransitionPunishment : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [18553] = new Params { ["kind"] = "visual" },
        [18554] = new Params { ["kind"] = "raid", ["damage"] = 400000, ["requires_lb"] = true },
        [18577] = new Params { ["kind"] = "circle", ["status_duration"] = 10, ["damage"] = 180000, ["status"] = 695, ["radius"] = 5 },
        [18578] = new Params { ["kind"] = "visual" },
        [18579] = new Params { ["kind"] = "circle", ["damage"] = 300000, ["split"] = true, ["radius"] = 4 },
        [19034] = new Params { ["kind"] = "visual" },
        [19073] = new Params { ["kind"] = "raid", ["damage"] = 9999999, ["unmitigated"] = true },
        [19083] = new Params { ["kind"] = "tank_auto", ["damage"] = 50000, ["physical"] = true },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
