using Kawari.Encounters;
// Duration 与原工程一致：先等待，再执行 OnTimeLineEvent。
using MechanicSim_Server.Manager;
using TimeLineDef = MechanicSim_Server.Struct.TimeLineDef;
using TimeLinePhase = MechanicSim_Server.Struct.TimeLinePhase;
using TimeLineNode = MechanicSim_Server.Struct.TimeLineNode;
namespace Script.Definitions.n4gw;

public sealed class Timeline : MechanicSim_Server.Definition.ITimeLineDefinition
{
    public string DefinitionId => "n4gw";

    public TimeLineDef Build()
    {
        var timeline = new TimeLineDef
        {
            TimeLineName = "光暗未来绝境战",
            TimeLineDescription = "木桩触发后进入最终阶段",
            TimeLineAuthor = "Kawari",
        };

        // 原生模型、判定和重置接口在中间层统一装配。
        timeline.NativeEncounter = UltimateEncounter.Configure(new Kawari.Encounters.TimeLineDef
        {
            TimeLineName = "光暗未来绝境战",
            Actors = ActorDefinitions.Build(),
            InitialScene = _ => InitialScene.Reset(),
            InitialObjects = _ => InitialScene.SpawnObjects(),
            ArenaRadius = 20,
            EnrageCast = 40327,
            EnrageDelay = 21.5,
            Actions = [new Script.Definitions.Actions.FRU.Transition(), new Script.Definitions.Actions.FRU.FulgentBlade(), new Script.Definitions.Actions.FRU.Wings(), new Script.Definitions.Actions.FRU.PolarizingStrikes()],
        });

        timeline.TimeLinePhaseList = new List<TimeLinePhase>
        {
            new TimeLinePhase
            {
                PhaseName = "转场",
                TimeLineNodes = new List<TimeLineNode>
                {
                    new TimeLineNode
                    {
                        NodeName = "木桩后转场",
                        Duration = TimeSpan.FromSeconds(0),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence01Transition.Execute, Scene01Transition.Execute);
                        },
                    },
                },
            },
            new TimeLinePhase
            {
                PhaseName = "最终阶段",
                TimeLineNodes = new List<TimeLineNode>
                {
                    new TimeLineNode
                    {
                        NodeName = "最终本体出现",
                        Duration = TimeSpan.FromSeconds(77.099),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence02Engage.Execute, Scene02Engage.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "光尘之剑 [40306]",
                        Duration = TimeSpan.FromSeconds(5.284),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence03FulgentBlade.Execute, Scene03FulgentBlade.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "死亡轮回 [40310]",
                        Duration = TimeSpan.FromSeconds(24.988),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence04AkhMorn.Execute, Scene04AkhMorn.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "复乐园 [40319]",
                        Duration = TimeSpan.FromSeconds(12.266),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence05ParadiseRegained.Execute, Scene05ParadiseRegained.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "光与暗的孤翼 [40313]",
                        Duration = TimeSpan.FromSeconds(7.126),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence06Wings.Execute, Scene06Wings.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "星灵之剑 [40316]",
                        Duration = TimeSpan.FromSeconds(21.823),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence07PolarizingStrikes.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "星灵之剑 [40234]",
                        Duration = TimeSpan.FromSeconds(8.657),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence08PolarizingStrikes.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "星灵之剑 [40234]",
                        Duration = TimeSpan.FromSeconds(4.612),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence09PolarizingStrikes.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "星灵之剑 [40234]",
                        Duration = TimeSpan.FromSeconds(4.643),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence10PolarizingStrikes.Execute, Scene10PolarizingStrikes.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "潘多拉魔盒 [40326]",
                        Duration = TimeSpan.FromSeconds(10.958),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence11PandorasBox.Execute, Scene11PandorasBox.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "光尘之剑 [40306]",
                        Duration = TimeSpan.FromSeconds(18.141),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence12FulgentBlade.Execute, Scene12FulgentBlade.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "死亡轮回 [40310]",
                        Duration = TimeSpan.FromSeconds(24.919),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence13AkhMorn.Execute, Scene13AkhMorn.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "复乐园 [40319]",
                        Duration = TimeSpan.FromSeconds(16.409),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence14ParadiseRegained.Execute, Scene14ParadiseRegained.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "光与暗的孤翼 [40313]",
                        Duration = TimeSpan.FromSeconds(7.134),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence15Wings.Execute, Scene15Wings.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "星灵之剑 [40316]",
                        Duration = TimeSpan.FromSeconds(16.646),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence16PolarizingStrikes.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "星灵之剑 [40234]",
                        Duration = TimeSpan.FromSeconds(8.628),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence17PolarizingStrikes.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "星灵之剑 [40234]",
                        Duration = TimeSpan.FromSeconds(4.625),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence18PolarizingStrikes.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "星灵之剑 [40234]",
                        Duration = TimeSpan.FromSeconds(4.581),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence19PolarizingStrikes.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "光尘之剑 [40306]",
                        Duration = TimeSpan.FromSeconds(7.731),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence20FulgentBlade.Execute, Scene20FulgentBlade.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "死亡轮回 [40310]",
                        Duration = TimeSpan.FromSeconds(24.852),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence21AkhMorn.Execute, Scene21AkhMorn.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "失乐园 [40327]",
                        Duration = TimeSpan.FromSeconds(16.417),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence22Enrage.Execute, Scene22Enrage.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "等待最后机制结算",
                        Duration = TimeSpan.FromSeconds(22.5),
                    },
                },
            },
        };
        return timeline;
    }
}
