// 参考 MechanicSim 的定义、阶段和节点结构，所有回调在实例时钟上串行执行。
using System.Text.Json;
namespace Kawari.Encounters;

public interface ITimeLineDefinition { string DefinitionId { get; } TimeLineDef Build(); }
public sealed record TimelineEvent(double At, int Order, Action<EncounterContext> Run);
public sealed class TimeLineNode
{
    public required string NodeName { get; init; }
    public double Duration { get; init; }
    public TimelineEvent[] Events { get; init; } = [];
    public Action<EncounterContext>? OnEnter { get; init; }
    public Action<EncounterContext>? OnUpdate { get; init; }
    public Action<EncounterContext>? OnExit { get; init; }
    public Func<EncounterContext,bool>? WaitUntil { get; init; }
    public double? Timeout { get; init; }
    public Action<EncounterContext>? OnTimeout { get; init; }
}
public sealed record TimeLinePhase(string PhaseName, TimeLineNode[] TimeLineNodes);
public sealed class TimeLineDef
{
    public required string TimeLineName { get; init; }
    public TimeLinePhase[] TimeLinePhaseList { get; set; } = [];
    public Action<EncounterContext>? OnTimeLineInit { get; set; }
    public Action<EncounterContext>? OnBattleStart { get; set; }
    public Action<EncounterContext>? OnTick { get; set; }
    public Action<EncounterContext>? OnStop { get; set; }
    public bool PreserveStateOnReset { get; init; }
    public Action<EncounterContext>? OnReset { get; set; }
    public Action<EncounterContext,JsonElement>? OnEvent { get; set; }
    public ActorCatalog? Actors { get; init; }
    public ActionDefinition[] Actions { get; init; } = [];
    public double ArenaRadius { get; init; } = 21;
    public double? ArenaSquare { get; init; }
    public double ArenaRotation { get; init; }
    public uint EnrageCast { get; init; }
    public double EnrageDelay { get; init; }
    public Action<EncounterContext>? InitialScene { get; init; }
    public Action<EncounterContext>? InitialObjects { get; init; }
    public uint[] DebugShortcuts { get; init; } = [];
    public MechanicSim_Server.Struct.TimeLineDef? ScriptTimeline { get; set; }
    public MechanicSim_Server.Definition.DefinitionRegistry ScriptRegistry { get; set; }=new();
}

public sealed class TimelineRunner
{
    private readonly (string Phase, TimeLineNode Node, TimelineEvent[] Events)[] nodes;
    private int index, cursor;
    private double start;
    private bool entered;
    public bool Running { get; private set; }
    public string Phase => index<nodes.Length?nodes[index].Phase:"";
    public string Node => index<nodes.Length?nodes[index].Node.NodeName:"已结束";
    public TimelineRunner(TimeLineDef definition)
    {
        nodes=definition.TimeLinePhaseList.SelectMany(p=>p.TimeLineNodes.Select(n=>(p.PhaseName,n,n.Events.OrderBy(e=>e.At).ThenBy(e=>e.Order).ToArray()))).ToArray();
        foreach(var (_,n,events) in nodes)
        {
            if(!double.IsFinite(n.Duration)||n.Duration<0) throw new InvalidDataException($"节点 {n.NodeName} 时长无效");
            if(n.WaitUntil is not null && (n.Timeout is null||!double.IsFinite(n.Timeout.Value)||n.Timeout<=0)) throw new InvalidDataException($"条件节点 {n.NodeName} 必须指定有限超时");
            if(events.Any(e=>!double.IsFinite(e.At)||e.At<0||e.At>n.Duration+1e-8)) throw new InvalidDataException($"节点 {n.NodeName} 存在越界事件");
        }
    }
    public void Start() { Running=true; index=cursor=0; start=0; entered=false; }
    public void Cancel() => Running=false;
    public void Update(EncounterContext context)
    {
        while(Running && index<nodes.Length)
        {
            var (_,n,events)=nodes[index];
            if(!entered) { entered=true; context.EventTime=start; n.OnEnter?.Invoke(context); }
            while(Running&&cursor<events.Length&&start+events[cursor].At<=context.Time+1e-8)
            { var e=events[cursor++]; context.EventTime=start+e.At; e.Run(context); }
            context.EventTime=context.Time;
            if(!Running) break;
            n.OnUpdate?.Invoke(context);
            if(context.Time+1e-8<start+n.Duration) break;
            if(n.WaitUntil is not null&&!n.WaitUntil(context))
            {
                if(context.Time-start<n.Duration+n.Timeout) break;
                n.OnTimeout?.Invoke(context); context.Stop($"节点超时：{n.NodeName}"); break;
            }
            n.OnExit?.Invoke(context); start=n.WaitUntil is null?start+n.Duration:context.Time;
            index++; cursor=0; entered=false;
        }
        if(index>=nodes.Length) Running=false;
        context.EventTime=context.Time;
    }
}

public sealed class EncounterContext
{
    private readonly PriorityQueue<(long Epoch,Action<EncounterContext> Run),(double At,long Order)> schedule=new();
    private long epoch, order;
    private bool started;
    public NativeDirector D { get; } = new();
    public TimeLineDef Definition { get; }
    public TimelineRunner Timeline { get; }
    public ActorMotion Motion { get; }
    public SceneController Scene { get; }
    public ActorControl Actors { get; }
    public MechanicEngine Mechanics { get; }
    public Random Random { get; }
    public Dictionary<string,object> State { get; }=[];
    public Dictionary<string,Params> Geometry { get; }=[];
    public string Phase { get; set; }="waiting";
    public string Status { get; private set; }="等待开战";
    public double Time { get; private set; }
    public double Delta { get; private set; }
    public double EventTime { get; set; }
    public ActorRef? Boss => D.Find(Definition.Actors?.Boss);
    public double? EnrageAt { get; set; }
    public EncounterContext(TimeLineDef definition,int seed=1974)
    { Definition=definition; Timeline=new(definition); Motion=new(this); Scene=new(this); Actors=new(this); Mechanics=new(this); Random=new(seed); }
    public T Get<T>(string key,Func<T> create) where T:notnull
    { if(!State.TryGetValue(key,out var value)) State[key]=value=create(); return (T)value; }
    public T? Find<T>(string key) where T:class => State.GetValueOrDefault(key) as T;
    public void Initialize(InputFrame frame) { using var scope=MechanicSim_Server.Manager.RaidManager.Enter(this); D.Read(frame); Definition.OnTimeLineInit?.Invoke(this); }
    public void Reset(InputFrame frame)
    { using var scope=MechanicSim_Server.Manager.RaidManager.Enter(this); Cancel(); started=false; Time=Delta=EventTime=0; Phase="waiting"; Status="等待开战"; D.ClearLocal(); D.Read(frame); Definition.OnReset?.Invoke(this); }
    public void BeforeReplace()
    { using var scope=MechanicSim_Server.Manager.RaidManager.Enter(this); Cancel(); Definition.OnReset?.Invoke(this); Cancel(); }
    public void Advance(InputFrame frame)
    {
        using var scope=MechanicSim_Server.Manager.RaidManager.Enter(this);
        if(!double.IsFinite(frame.time)||frame.time<0||frame.time+1e-8<Time) throw new InvalidDataException("实例时钟倒退或无效");
        Delta=frame.time-Time; Time=frame.time; EventTime=Time; D.Read(frame);
        MechanicSim_Server.Manager.RaidManager.Instance.Update();
        foreach(var e in frame.events) Definition.OnEvent?.Invoke(this,e);
        if(Phase is "complete" or "stopped") return;
        if(frame.battle&&!started) { started=true; Status="运行中"; Definition.OnBattleStart?.Invoke(this); Timeline.Start(); }
        if(Phase is "complete" or "stopped") return;
        var count=0;
        while(schedule.TryPeek(out var pending,out var due)&&due.At<=Time+1e-8)
        {
            if(++count>10000) throw new InvalidOperationException("本帧延时回调超过上限");
            schedule.Dequeue(); if(pending.Epoch==epoch) { EventTime=due.At; pending.Run(this); }
        }
        EventTime=Time;
        Definition.OnTick?.Invoke(this);
        if(started) { Timeline.Update(this); Motion.Update(Delta,Time); }
    }
    public void Schedule(double seconds,Action<EncounterContext> callback)
    { if(!double.IsFinite(seconds)||seconds<0||seconds>604800) throw new ArgumentOutOfRangeException(nameof(seconds)); schedule.Enqueue((epoch,callback),(EventTime+seconds,++order)); }
    public void Cancel() { epoch++; schedule.Clear(); Timeline.Cancel(); Motion.Clear(); }
    public void Complete() { Phase="complete"; Status="已通关"; Cancel(); D.CancelPending(); D.Complete(); }
    public void Stop(string reason) { Phase="stopped"; Status=reason; Cancel(); Definition.OnStop?.Invoke(this); D.Stop(reason); }
    public object Report() => new { name=Definition.TimeLineName,phase=Timeline.Phase,node=Timeline.Node,status=Status,time=Time,debugShortcuts=Definition.DebugShortcuts };
}
