using Kawari.Encounters;
// 真火神已有机制循环；节点中的延时回调由同一 C# 实例时钟驱动。
using MechanicSim_Server.Manager;
using TimeLineDef = MechanicSim_Server.Struct.TimeLineDef;
using TimeLinePhase = MechanicSim_Server.Struct.TimeLinePhase;
using TimeLineNode = MechanicSim_Server.Struct.TimeLineNode;
namespace Script.Definitions.Timelines;

public sealed class IfritHard : MechanicSim_Server.Definition.ITimeLineDefinition
{
    public string DefinitionId => "w1fa_2";
    public TimeLineDef Build()
    {
        var actions = new Script.Definitions.Actions.IfritHard.Mechanics();
        return new()
        {
            TimeLineName = "真火神歼灭战",
            TimeLinePhaseList = [new(){PhaseName="循环",TimeLineNodes=[
                new(){NodeName="地火／炎柱／旋风",Duration=TimeSpan.Zero,OnTimeLineEvent=()=>actions.Cycle(RaidManager.Instance.Context,0)},
                new(){NodeName="首轮结束",Duration=TimeSpan.FromSeconds(48)}]}],
            NativeEncounter = new Kawari.Encounters.TimeLineDef
            {
                TimeLineName = "真火神歼灭战",
                OnTimeLineInit = actions.Setup,
                OnEvent = (c, e) =>
                {
                    var kind = e.GetProperty("kind").GetString();
                    if (kind == "death" && e.GetProperty("base").GetUInt32() == 209) c.Complete();
                    if (kind == "gimmick") { var id = e.GetProperty("actor").GetUInt32(); if (e.GetProperty("id").GetUInt32() == 2000139) c.D.Emit("abandon_duty", id); c.D.Emit("finish_gimmick", id); }
                }
            }
        };
    }
}
