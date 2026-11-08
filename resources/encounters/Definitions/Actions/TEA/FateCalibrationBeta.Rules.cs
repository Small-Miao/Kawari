using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.TEA;
public partial class FateCalibrationBeta : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [18531] = new Params { ["kind"] = "visual" },
        [18565] = new Params { ["kind"] = "circle", ["damage"] = 9999999, ["unmitigated"] = true, ["radius"] = 10 },
        [18566] = new Params { ["kind"] = "donut", ["outer"] = 60, ["inner"] = 8, ["unmitigated"] = true, ["damage"] = 9999999 },
        [18587] = new Params { ["kind"] = "visual" },
        [18588] = new Params { ["kind"] = "visual" },
        [18589] = new Params { ["kind"] = "visual" },
        [18590] = new Params { ["kind"] = "visual" },
        [18592] = new Params { ["kind"] = "visual" },
        [18593] = new Params { ["kind"] = "visual" },
        [18594] = new Params { ["kind"] = "visual" },
        [18595] = new Params { ["kind"] = "visual" },
        [19220] = new Params { ["kind"] = "visual" },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
