using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.TEA;
public partial class TemporalPrison : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [18582] = new Params { ["kind"] = "visual" },
        [18583] = new Params { ["kind"] = "raid", ["damage"] = 9999999, ["unmitigated"] = true },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
