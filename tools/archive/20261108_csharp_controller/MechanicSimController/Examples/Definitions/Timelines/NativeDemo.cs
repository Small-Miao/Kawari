// 示例只在显式选择的测试副本运行；采用与 MechanicSim 相同的定义接口。
using System;
using System.Collections.Generic;
using System.Numerics;
using Kawari.MechanicSim;
using MechanicSim_Server.Definition;
using MechanicSim_Server.Struct;

public sealed class NativeDemo : ITimeLineDefinition
{
    public string DefinitionId => "kawari-native-demo";
    public TimeLineDef Build() => new()
    {
        TimeLineName = "Kawari 原生控制器示例",
        TimeLineDescription = "木桩开战，圆形判定和状态同步；不替换现有绝本",
        TimeLineAuthor = "Kawari",
        OnTimeLineInit = () =>
        {
            Native.Spawn("dummy", 11744, 541, 99999999, new Vector3(100, 0, 100), boss: true);
            Native.Call("arm_hit_trigger", Native.Actor("dummy"));
        },
        TimeLinePhaseList = new List<TimeLinePhase>
        {
            new()
            {
                PhaseName = "原生接口验证",
                TimeLineNodes = new List<TimeLineNode>
                {
                    new() { NodeName = "木桩开战后读条", Duration = TimeSpan.Zero,
                        OnTimeLineEvent = () => Native.Cast(Native.Actor("dummy"), 7, 2) },
                    new() { NodeName = "圆形范围真实伤害", Duration = TimeSpan.FromSeconds(2),
                        OnTimeLineEvent = () => Native.Circle(Native.Actor("dummy"), 7, 100, new Vector3(100,0,100), 5) },
                    new() { NodeName = "状态施加", Duration = TimeSpan.FromSeconds(1),
                        OnTimeLineEvent = () => {
                            foreach (var player in Native.State.Actors)
                                if (player.Player && player.Hp > 0) Native.Buff(player.Id, 2911, 3);
                        } },
                    new() { NodeName = "等待状态结束", Duration = TimeSpan.FromSeconds(4), OnTimeLineEvent = () => { } }
                }
            }
        }
    };
}
