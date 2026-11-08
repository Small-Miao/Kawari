// MechanicSim Duration 表示等待后执行节点，保持原工程的累计时间语义。
using Kawari.Encounters;
using MechanicSim_Server.Definition;
namespace Kawari.Encounters;
internal sealed class TimelineAdapter(MechanicSim_Server.Definition.ITimeLineDefinition definition,Func<DefinitionRegistry> registry):ITimeLineDefinition
{
    public string DefinitionId=>definition.DefinitionId;
    public TimeLineDef Build()
    {
        var script=definition.Build();var runtime=script.NativeEncounter??new TimeLineDef{TimeLineName=script.TimeLineName};
        runtime.ScriptTimeline=script;runtime.ScriptRegistry=registry();
        if(script.TimeLinePhaseList.Count>0)runtime.TimeLinePhaseList=script.TimeLinePhaseList.Select(p=>new TimeLinePhase(p.PhaseName,p.TimeLineNodes.Select(n=>new TimeLineNode{
            NodeName=n.NodeName,Duration=n.Duration.TotalSeconds,Events=n.OnTimeLineEvent is {} run?[new TimelineEvent(n.Duration.TotalSeconds,0,_=>run())]:[],
            WaitUntil=n.WaitUntil is {} condition?_=>condition():null,Timeout=n.Timeout?.TotalSeconds
        }).ToArray())).ToArray();
        var init=runtime.OnTimeLineInit;runtime.OnTimeLineInit=c=>{init?.Invoke(c);script.OnTimeLineInit?.Invoke();};
        var stop=runtime.OnStop;runtime.OnStop=c=>{stop?.Invoke(c);script.OnTimeLineReset?.Invoke();};
        var reset=runtime.OnReset;runtime.OnReset=c=>{reset?.Invoke(c);script.OnTimeLineReset?.Invoke();};
        return runtime;
    }
}
