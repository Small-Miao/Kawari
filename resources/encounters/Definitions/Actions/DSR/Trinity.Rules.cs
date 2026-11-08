using Kawari.Encounters;
// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。
namespace Script.Definitions.Actions.DSR;
public partial class Trinity : ActionDefinition
{
    private readonly Dictionary<uint, Params> rules = new()
    {
        [28063] = new Params { ["kind"] = "trinity", ["statuses"] = new object?[] { new Params { ["limit"] = 2, ["id"] = 3136, ["duration"] = 37, ["stacks"] = true } }, ["damage"] = 85000, ["rank"] = 1 },
        [28064] = new Params { ["kind"] = "trinity", ["statuses"] = new object?[] { new Params { ["limit"] = 2, ["id"] = 3135, ["duration"] = 37, ["stacks"] = true } }, ["damage"] = 85000, ["rank"] = 2 },
        [28065] = new Params { ["kind"] = "trinity", ["nearest"] = true, ["damage"] = 50000, ["physical"] = true, ["statuses"] = new object?[] { new Params { ["limit"] = 2, ["id"] = 3136, ["duration"] = 37, ["stacks"] = true }, new Params { ["limit"] = 2, ["id"] = 3135, ["duration"] = 37, ["stacks"] = true }, new Params { ["id"] = 2940, ["duration"] = 60, ["limit"] = 1 } } },
    };
    public override IReadOnlyDictionary<uint, Params> Rules => rules;
}
