using Kawari.Encounters;
// Duration 与原工程一致：先等待，再执行 OnTimeLineEvent。
using MechanicSim_Server.Manager;
using TimeLineDef = MechanicSim_Server.Struct.TimeLineDef;
using TimeLinePhase = MechanicSim_Server.Struct.TimeLinePhase;
using TimeLineNode = MechanicSim_Server.Struct.TimeLineNode;
namespace Script.Definitions.r1fz;

public sealed class Timeline : MechanicSim_Server.Definition.ITimeLineDefinition
{
    public string DefinitionId => "r1fz";

    public TimeLineDef Build()
    {
        var timeline = new TimeLineDef
        {
            TimeLineName = "幻想龙诗绝境战",
            TimeLineDescription = "木桩触发后进入最终阶段",
            TimeLineAuthor = "Kawari",
        };

        // 原生模型、判定和重置接口在中间层统一装配。
        timeline.NativeEncounter = UltimateEncounter.Configure(new Kawari.Encounters.TimeLineDef
        {
            TimeLineName = "幻想龙诗绝境战",
            Actors = ActorDefinitions.Build(),
            InitialScene = _ => InitialScene.Reset(),
            InitialObjects = _ => InitialScene.SpawnObjects(),
            ArenaRadius = 21,
            EnrageCast = 28206,
            EnrageDelay = 18.1,
            Actions = [new Script.Definitions.Actions.DSR.Transition(), new Script.Definitions.Actions.DSR.Trinity(), new Script.Definitions.Actions.DSR.ExaflareGigaflare(), new Script.Definitions.Actions.DSR.AkhMorn()],
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
                        Duration = TimeSpan.FromSeconds(62.206),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence02Engage.Execute, Scene02Engage.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "百京核爆剑 [28059]",
                        Duration = TimeSpan.FromSeconds(4.286),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence03ExaflaresEdge.Execute, Scene03ExaflaresEdge.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "死亡轮回剑 [28051]",
                        Duration = TimeSpan.FromSeconds(21.216),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence04AkhMornsEdge.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "十亿核爆剑 [28057]",
                        Duration = TimeSpan.FromSeconds(24.509),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence05GigaflaresEdge.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "百京核爆剑 [28059]",
                        Duration = TimeSpan.FromSeconds(33.273),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence06ExaflaresEdge.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "死亡轮回剑 [28051]",
                        Duration = TimeSpan.FromSeconds(21.145),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence07AkhMornsEdge.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "十亿核爆剑 [28057]",
                        Duration = TimeSpan.FromSeconds(25.585),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence08GigaflaresEdge.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "百京核爆剑 [28059]",
                        Duration = TimeSpan.FromSeconds(33.281),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence09ExaflaresEdge.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "死亡轮回剑 [28051]",
                        Duration = TimeSpan.FromSeconds(21.186),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence10AkhMornsEdge.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "无尽顿悟剑 [28206]",
                        Duration = TimeSpan.FromSeconds(26.67),
                        OnTimeLineEvent = () =>
                        {
                            RaidManager.Instance.RunGroup(Sequence11Enrage.Execute);
                        },
                    },
                    new TimeLineNode
                    {
                        NodeName = "等待最后机制结算",
                        Duration = TimeSpan.FromSeconds(19.1),
                    },
                },
            },
        };
        return timeline;
    }
}
