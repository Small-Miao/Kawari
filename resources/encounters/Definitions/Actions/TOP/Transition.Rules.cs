using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.TOP;
public partial class Transition : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [31555] = new Params { ["kind"] = "visual" },
        [31623] = new Params { ["kind"] = "visual" },
        [31648] = new Params { ["kind"] = "raid", ["damage"] = 9999999, ["unmitigated"] = true },
        [31649] = new Params { ["kind"] = "raid", ["damage"] = 400000, ["requires_lb"] = true },
        [31650] = new Params { ["kind"] = "visual" },
        [31654] = new Params { ["kind"] = "visual" },
        [31657] = new Params { ["kind"] = "visual" },
        [31660] = new Params { ["kind"] = "visual" },
        [31664] = new Params { ["kind"] = "visual" },
        [31665] = new Params { ["kind"] = "visual" },
        [31670] = new Params { ["kind"] = "raid", ["status"] = 3532, ["damage"] = 400000, ["requires_lb"] = true, ["status_duration"] = 6 },
        [31747] = new Params { ["kind"] = "visual" },
        [32223] = new Params { ["kind"] = "flash_gale", ["damage"] = 80000, ["radius"] = 5 },
        [32337] = new Params { ["kind"] = "visual" },
        [32626] = new Params { ["kind"] = "raid", ["damage"] = 60000 },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
