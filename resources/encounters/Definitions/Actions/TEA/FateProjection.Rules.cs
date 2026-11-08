using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.TEA;
public partial class FateProjection : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [18555] = new Params { ["kind"] = "visual" },
        [18581] = new Params { ["kind"] = "visual" },
        [19219] = new Params { ["kind"] = "visual" },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
