using Kawari.Encounters;
// Duration 与原工程一致：先等待，再执行 OnTimeLineEvent。
using MechanicSim_Server.Manager;
using TimeLineDef = MechanicSim_Server.Struct.TimeLineDef;
using TimeLinePhase = MechanicSim_Server.Struct.TimeLinePhase;
using TimeLineNode = MechanicSim_Server.Struct.TimeLineNode;
namespace Script.Definitions.z3oy;

public sealed class Timeline : MechanicSim_Server.Definition.ITimeLineDefinition
{
    public string DefinitionId => "z3oy";

    public TimeLineDef Build()
    {
        var timeline = new TimeLineDef
        {
            TimeLineName = "妖星乱舞绝境战",
            TimeLineDescription = "木桩触发后进入最终阶段",
            TimeLineAuthor = "Kawari",
        };

        // 原生模型、判定和重置接口在中间层统一装配。
        timeline.NativeEncounter = UltimateEncounter.Configure(new Kawari.Encounters.TimeLineDef
        {
            TimeLineName = "妖星乱舞绝境战",
            Actors = ActorDefinitions.Build(),
            InitialScene = _ => InitialScene.Reset(),
            InitialObjects = _ => InitialScene.SpawnObjects(),
            ArenaRadius = 28.2843,
            EnrageCast = 47930,
            EnrageDelay = 26,
            ArenaSquare = 20,
            ArenaRotation = Math.PI / 4,
            Actions = [new Script.Definitions.Actions.UMAD.UltimaRepeaterFellForces(), new Script.Definitions.Actions.UMAD.Flood(), new Script.Definitions.Actions.UMAD.MaddeningOrchestra(), new Script.Definitions.Actions.UMAD.Celestriad(), new Script.Definitions.Actions.UMAD.StrayApocalypse(), new Script.Definitions.Actions.UMAD.Forsaken()],
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
                        Duration = TimeSpan.FromSeconds(37.225),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence02Engage.Execute, Scene02Engage.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "连续究极 [47936]",
                        Duration = TimeSpan.FromSeconds(3.083),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence03UltimaRepeater.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "洪水 [49471]",
                        Duration = TimeSpan.FromSeconds(16.626),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence04Flood.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "癫狂交响曲 [47952]",
                        Duration = TimeSpan.FromSeconds(13.133),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence05MaddeningOrchestra.Execute, Scene05MaddeningOrchestra.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "三星 [47938]",
                        Duration = TimeSpan.FromSeconds(21.704),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence06Celestriad.Execute, Scene06Celestriad.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "二选一的灾祟 [49743]",
                        Duration = TimeSpan.FromSeconds(9.183),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence07Catastrophe.Execute, Scene07Catastrophe.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "二选一的灾祟 [49743]",
                        Duration = TimeSpan.FromSeconds(12.116),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence08Catastrophe.Execute, Scene08Catastrophe.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "连续究极 [47936]",
                        Duration = TimeSpan.FromSeconds(9.16),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence09UltimaRepeater.Execute, Scene09UltimaRepeater.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "混沌末世 [47931]",
                        Duration = TimeSpan.FromSeconds(14.639),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence10StrayApocalypse.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "混沌涡旋 [47934]",
                        Duration = TimeSpan.FromSeconds(16.116),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence11StrayWhirlwind.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "癫狂交响曲 [47952]",
                        Duration = TimeSpan.FromSeconds(9.169),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence12MaddeningOrchestra.Execute, Scene12MaddeningOrchestra.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "遗弃末世 [47925]",
                        Duration = TimeSpan.FromSeconds(24.762),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence13Forsaken.Execute, Scene13Forsaken.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "遗弃末点 [47930]",
                        Duration = TimeSpan.FromSeconds(44.566),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence14Enrage.Execute, Scene14Enrage.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "等待最后机制结算",
                        Duration = TimeSpan.FromSeconds(27.0),
                    },
                },
            },
        };
        return timeline;
    }
}
