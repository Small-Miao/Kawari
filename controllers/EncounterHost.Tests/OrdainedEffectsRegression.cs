using Kawari.Encounters;

// 使用同一帧内一名行动、一名静止的玩家，分别验证两种命令的目标和效果来源。
internal static class OrdainedEffectsRegression
{
    public static void Run(DefinitionLoader loader, Action<bool, string> check,
        Action<EncounterContext, Simulation> submit, Action beginTrace)
    {
        foreach (var (command, success, failure, passed) in new[]
        {
            (18558u, 19039u, 18560u, 1u),
            (18559u, 19040u, 18561u, 2u),
        })
        {
            beginTrace();
            var simulation = new Simulation(2);
            var context = new EncounterContext(loader.Definitions["d2az"].Build());
            context.Initialize(simulation.Frame(1, 0, false));
            var actors = context.Definition.Actors!;
            var boss = context.Actors.Spawn(actors.Boss);
            var firstHelper = context.Actors.Spawn("a16");
            var secondHelper = context.Actors.Spawn("a17");
            context.Actors.Spawn("a18");
            submit(context, simulation);
            var finalWord = context.Definition.Actions.Single(action => action.Rules.ContainsKey(command));
            context.Advance(simulation.Frame(2, 0, false));
            finalWord.Tick(context);
            simulation.Actors[1] = simulation.Actors[1] with { actionCount = 1 };
            context.Advance(simulation.Frame(3, 0.125, false));
            finalWord.Tick(context);

            context.Actors.Action(actors.Boss, command, new());
            var castResult = context.D.Commands.Single(operation => operation.method == "play_action_targeted");
            check(castResult.args.SequenceEqual(new object[] { boss, command, boss, true }), "Boss 命令结算应保留自身目标与录像效果");
            context.Actors.Action("a16", success, new());
            context.Actors.Action("a17", success, new());
            context.Actors.Action("a18", success, new());
            var successResult = context.D.Commands.Where(operation => operation.method == "play_action_targeted").Last();
            check(successResult.args.SequenceEqual(new object[] { passed == 1 ? firstHelper : secondHelper, success, (ActorRef)passed, true }),
                "正确应对的玩家应收到来自对应 Helper 的单体效果");
            var failResult = (Params)context.D.Commands.Single(operation => operation.method == "raidwide").args[0]!;
            var failed = (ActorRef)(passed == 1 ? 2u : 1u);
            check(failResult.Number("action") == failure && failResult.Target == failed &&
                failResult.Get<ActorRef>("effect_source") == (passed == 1 ? secondHelper : firstHelper) &&
                failResult.Get<ActorRef[]>("targets")!.SequenceEqual(new[] { failed }), "失败判定必须由对应 Helper 命中唯一的失败玩家");
            check(context.D.Commands.Count(operation => operation.method == "play_action_targeted") == 2,
                "多余 Helper 不得重复结算玩家");
            submit(context, simulation);
        }
    }
}
