using Kawari.Encounters;
// Duration 与原工程一致：先等待，再执行 OnTimeLineEvent。
using MechanicSim_Server.Manager;
using TimeLineDef = MechanicSim_Server.Struct.TimeLineDef;
using TimeLinePhase = MechanicSim_Server.Struct.TimeLinePhase;
using TimeLineNode = MechanicSim_Server.Struct.TimeLineNode;
namespace Script.Definitions.z3oz;

public sealed class Timeline : MechanicSim_Server.Definition.ITimeLineDefinition
{
    public string DefinitionId => "z3oz";

    public TimeLineDef Build()
    {
        var timeline = new TimeLineDef
        {
            TimeLineName = "欧米茄绝境验证战",
            TimeLineDescription = "木桩触发后进入最终阶段",
            TimeLineAuthor = "Kawari",
        };

        // 原生模型、判定和重置接口在中间层统一装配。
        timeline.NativeEncounter = UltimateEncounter.Configure(new Kawari.Encounters.TimeLineDef
        {
            TimeLineName = "欧米茄绝境验证战",
            Actors = ActorDefinitions.Build(),
            InitialScene = _ => InitialScene.Reset(),
            InitialObjects = _ => InitialScene.SpawnObjects(),
            ArenaRadius = 20,
            EnrageCast = 31648,
            EnrageDelay = 30.3,
            Actions = [new Script.Definitions.Actions.TOP.Transition(), new Script.Definitions.Actions.TOP.CosmoArrow(), new Script.Definitions.Actions.TOP.WaveCannon(), new Script.Definitions.Actions.TOP.CosmoMeteor()],
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
                        Duration = TimeSpan.FromSeconds(67.329),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence02Engage.Execute, Scene02Engage.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "宇宙记忆 [31649]",
                        Duration = TimeSpan.FromSeconds(7.189),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence03CosmoMemory.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "宇宙天箭 [31650]",
                        Duration = TimeSpan.FromSeconds(14.334),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence04CosmoArrow.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "宇宙龙炎 [31654]",
                        Duration = TimeSpan.FromSeconds(15.081),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence05CosmoDive.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "波动炮：限制解除 [31660]",
                        Duration = TimeSpan.FromSeconds(19.028),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence06UnlimitedWaveCannon.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "波动炮 [31657]",
                        Duration = TimeSpan.FromSeconds(23.186),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence07WaveCannon.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "宇宙天箭 [31650]",
                        Duration = TimeSpan.FromSeconds(19.531),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence08CosmoArrow.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "波动炮 [31657]",
                        Duration = TimeSpan.FromSeconds(14.075),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence09WaveCannon.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "波动炮：限制解除 [31660]",
                        Duration = TimeSpan.FromSeconds(19.788),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence10UnlimitedWaveCannon.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "宇宙龙炎 [31654]",
                        Duration = TimeSpan.FromSeconds(18.078),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence11CosmoDive.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "宇宙流星 [31664]",
                        Duration = TimeSpan.FromSeconds(22.326),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence12CosmoMeteor.Execute, Scene12CosmoMeteor.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "魔数 [31670]",
                        Duration = TimeSpan.FromSeconds(35.306),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence13MagicNumber.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "魔数 [31670]",
                        Duration = TimeSpan.FromSeconds(16.193),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence14MagicNumber.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "代码：＊能＊ [31648]",
                        Duration = TimeSpan.FromSeconds(14.174),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence15Enrage.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "等待最后机制结算",
                        Duration = TimeSpan.FromSeconds(31.3),
                    },
                },
            },
        };
        return timeline;
    }
}
