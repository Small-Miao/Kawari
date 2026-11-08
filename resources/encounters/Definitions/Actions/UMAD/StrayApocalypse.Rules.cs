using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.UMAD;
public partial class StrayApocalypse : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [47931] = new Params { ["kind"] = "visual" },
        [47932] = new Params { ["kind"] = "circle", ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 6 },
        [47933] = new Params { ["kind"] = "circle", ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 6 },
        [47934] = new Params { ["kind"] = "visual" },
        [47935] = new Params { ["kind"] = "spread", ["punish_status"] = 2941, ["status_duration"] = 2, ["damage"] = 150000, ["status"] = 2941, ["radius"] = 5 },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
