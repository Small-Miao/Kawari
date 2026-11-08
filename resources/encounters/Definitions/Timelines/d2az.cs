using Kawari.Encounters;
// Duration 与原工程一致：先等待，再执行 OnTimeLineEvent。
using MechanicSim_Server.Manager;
using TimeLineDef = MechanicSim_Server.Struct.TimeLineDef;
using TimeLinePhase = MechanicSim_Server.Struct.TimeLinePhase;
using TimeLineNode = MechanicSim_Server.Struct.TimeLineNode;
namespace Script.Definitions.d2az;

public sealed class Timeline : MechanicSim_Server.Definition.ITimeLineDefinition
{
    public string DefinitionId => "d2az";

    public TimeLineDef Build()
    {
        var timeline = new TimeLineDef
        {
            TimeLineName = "亚历山大绝境战",
            TimeLineDescription = "木桩触发后进入最终阶段",
            TimeLineAuthor = "Kawari",
        };

        // 原生模型、判定和重置接口在中间层统一装配。
        timeline.NativeEncounter = UltimateEncounter.Configure(new Kawari.Encounters.TimeLineDef
        {
            TimeLineName = "亚历山大绝境战",
            Actors = ActorDefinitions.Build(),
            InitialScene = SceneHooks.Initial,
            InitialObjects = _ => InitialScene.SpawnObjects(),
            ArenaRadius = 20,
            EnrageCast = 18583,
            EnrageDelay = 42,
            Actions = [new Script.Definitions.Actions.TEA.TransitionPunishment(), new Script.Definitions.Actions.TEA.FinalWord(), new Script.Definitions.Actions.TEA.FateProjection(), new Script.Definitions.Actions.TEA.FateCalibrationAlpha(), new Script.Definitions.Actions.TEA.FateCalibrationBeta(), new Script.Definitions.Actions.TEA.OpticalSightAlmightyJudgment(), new Script.Definitions.Actions.TEA.TemporalPrison()],
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
                        Duration = TimeSpan.FromSeconds(73.364),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence02Engage.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "终审判决 [18557]",
                        Duration = TimeSpan.FromSeconds(10.185),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence03FinalWord.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "行动命令 [18558]",
                        Duration = TimeSpan.FromSeconds(7.157),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence04OrdainedMotion.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "静止命令 [18559]",
                        Duration = TimeSpan.FromSeconds(11.114),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence05OrdainedStillness.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "制导 [18571]",
                        Duration = TimeSpan.FromSeconds(11.165),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence06OpticalSight.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "制导 [18570]",
                        Duration = TimeSpan.FromSeconds(6.141),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence07OpticalSight.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "未来观测α [18555]",
                        Duration = TimeSpan.FromSeconds(12.985),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence08FateProjectionAlpha.Execute, Scene08FateProjectionAlpha.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "未来确定α [18556]",
                        Duration = TimeSpan.FromSeconds(8.181),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence09FateCalibrationAlpha.Execute, Scene09FateCalibrationAlpha.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "加重诛罚 [18578]",
                        Duration = TimeSpan.FromSeconds(44.484),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence10CapitalPunishment.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "诛罚 [18577]",
                        Duration = TimeSpan.FromSeconds(7.17),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence11OrdainedPunishment.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "未来观测β [19219]",
                        Duration = TimeSpan.FromSeconds(15.392),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence12FateProjectionBeta.Execute, Scene12FateProjectionBeta.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "未来确定β [19220]",
                        Duration = TimeSpan.FromSeconds(7.85),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence13FateCalibrationBeta.Execute, Scene13FateCalibrationBeta.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "加重诛罚 [18578]",
                        Duration = TimeSpan.FromSeconds(69.551),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence14CapitalPunishment.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "诛罚 [18577]",
                        Duration = TimeSpan.FromSeconds(7.147),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence15OrdainedPunishment.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "神圣大审判 [18574]",
                        Duration = TimeSpan.FromSeconds(12.183),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence16AlmightyJudgment.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "株连 [18580]",
                        Duration = TimeSpan.FromSeconds(14.134),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence17IrresistibleGrace.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "加重诛罚 [18578]",
                        Duration = TimeSpan.FromSeconds(12.183),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence18CapitalPunishment.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "诛罚 [18577]",
                        Duration = TimeSpan.FromSeconds(7.177),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence19OrdainedPunishment.Execute, Scene19OrdainedPunishment.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "神圣大审判 [18574]",
                        Duration = TimeSpan.FromSeconds(8.14),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence20AlmightyJudgment.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "株连 [18580]",
                        Duration = TimeSpan.FromSeconds(14.186),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence21IrresistibleGrace.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "时空干涉 [18582]",
                        Duration = TimeSpan.FromSeconds(14.915),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence22TemporalInterference.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "时间牢狱 [18583]",
                        Duration = TimeSpan.FromSeconds(8.25),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence23TemporalPrison.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "等待最后机制结算",
                        Duration = TimeSpan.FromSeconds(43.0),
                    },
                },
            },
        };
        return timeline;
    }
}
