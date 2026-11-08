using Kawari.Encounters;
// 沙斯塔夏事件驱动的阶段入口，门钥匙与 Boss 行为位于 Actions。
using MechanicSim_Server.Manager;
using TimeLineDef = MechanicSim_Server.Struct.TimeLineDef;
using TimeLinePhase = MechanicSim_Server.Struct.TimeLinePhase;
using TimeLineNode = MechanicSim_Server.Struct.TimeLineNode;
namespace Script.Definitions.Timelines;

public sealed class Sastasha : MechanicSim_Server.Definition.ITimeLineDefinition
{
    public string DefinitionId => "s1d1_re";
    public TimeLineDef Build()
    {
        var dungeon = new Script.Definitions.Actions.Sastasha.Dungeon();
        return new()
        {
            TimeLineName = "沙斯塔夏溶洞",
            NativeEncounter = new Kawari.Encounters.TimeLineDef { TimeLineName = "沙斯塔夏溶洞", OnTimeLineInit = dungeon.Setup, OnEvent = dungeon.Event, PreserveStateOnReset = true, DebugShortcuts = [11432969, 11432970, 11432971, 11432972] },
            TimeLinePhaseList = [new(){PhaseName="探索",TimeLineNodes=[
                new(){NodeName="打开隐藏门",WaitUntil=()=>dungeon.Sequence>=2,Timeout=TimeSpan.FromDays(7)},
                new(){NodeName="取得舰长室钥匙",WaitUntil=()=>dungeon.Sequence>=3,Timeout=TimeSpan.FromDays(7)},
                new(){NodeName="取得波涛门钥匙",WaitUntil=()=>dungeon.Sequence>=4,Timeout=TimeSpan.FromDays(7)},
                new(){NodeName="抵达最终房间",WaitUntil=()=>dungeon.Sequence>=5,Timeout=TimeSpan.FromDays(7)},
            ]}]
        };
    }
}
