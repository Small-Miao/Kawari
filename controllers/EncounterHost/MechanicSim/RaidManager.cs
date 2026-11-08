// 每个上下文独立的 RaidManager；保留原工程 Instance 调用方式并绑定真实实体接口。
using Kawari.Encounters;
using MechanicSim_Server.Definition;
using MechanicSim_Server.Struct;
namespace MechanicSim_Server.Manager;
public sealed class RaidManager
{
    private static readonly AsyncLocal<RaidManager?> current=new();
    public static RaidManager Instance=>current.Value??throw new InvalidOperationException("RaidManager 只能在副本回调中访问");
    public EncounterContext Context { get; }
    internal DateTime ClockOrigin { get; }=DateTime.UtcNow;
    public DateTime Now=>ClockOrigin.AddSeconds(Context.Time);
    public DefinitionRegistry DefinitionRegistry=>Context.Definition.ScriptRegistry;
    public Dictionary<string,object> TimeLineVars=>Context.Definition.ScriptTimeline?.TimeLineVars??Context.State;
    public List<GameObject> GameObjects { get; }=[];
    public List<Player> Players=>Context.D.Frame.actors.Where(a=>a.player).Select(a=>PlayerFor(a.id)).ToList();
    private readonly Dictionary<uint,Player> players=[];
    private List<(double At,int Order,System.Action Run)>? group;
    private RaidManager(EncounterContext context)=>Context=context;
    private sealed class Scope(RaidManager? previous):IDisposable { public void Dispose()=>current.Value=previous; }
    public static IDisposable Enter(EncounterContext context)
    {var old=current.Value;current.Value=context.Get("mechanicsim.manager",()=>new RaidManager(context));return new Scope(old);}
    private Player PlayerFor(uint id){if(!players.TryGetValue(id,out var player))players[id]=player=new Player(this,id);return player;}
    public void Update()
    {
        foreach(var obj in GameObjects.ToArray())
        {
            obj.Refresh();
            if(obj.Move){if(obj.TargetPlayer is {} player)Context.Motion.Follow(obj.Reference,player.Reference,obj.MoveSpeed,obj.HitboxRadius);else if(obj.TargetGameObject is {} target)Context.Motion.Follow(obj.Reference,target.Reference,obj.MoveSpeed,obj.HitboxRadius);}
        }
        foreach(var player in players.Values)player.Update();
    }
    public GameObject? GetObjectByGameObjectId(ulong id)=>GameObjects.FirstOrDefault(o=>o.ServerGameObjectId==id);
    public GameObject? GetObjectByGameObjectId(string key)
    {var found=GameObjects.FirstOrDefault(o=>o.Key==key);if(found is not null)return Context.D.Find(key) is null?null:found;if(Context.D.Find(key) is null)return null;return GameObject.Wrap(this,key);}
    public void PlayBgm(int id)=>Context.D.SetBgm((uint)id);
    public void MapEffect(byte index,ushort state,ushort timeline)=>Context.Scene.MapEffect(index,state,timeline);
    public void SetWeather(byte id,double fade=0)=>Context.D.Weather(id,fade);
    public void SetupMapEffects(ushort[] states,ushort flag)=>Context.D.SetupMapEffects(states,flag);
    public void DirectorEvent(uint id,params object?[] args)=>Context.D.Emit("director_event",id,args);
    public void SpawnEObj(string key,Params spec)=>Context.Scene.SpawnEObj(key,spec);
    public void AnimateEObj(string key,uint state,uint timeline)=>Context.Scene.AnimateEObj(key,state,timeline);
    public void RemoveEObj(string key)=>Context.Scene.RemoveEObj(key);
    public void SpawnActor(string key)=>Context.Actors.Spawn(key);
    public void SynchronizedTimelines((string Actor,ushort Timeline)[] entries)=>Context.Actors.SynchronizedTimelines(entries);
    public void Schedule(TimeSpan delay,System.Action run,int order=0)
    {
        if(group is not null){group.Add((delay.TotalSeconds,order,run));return;}
        Context.Schedule(delay.TotalSeconds,_=>run());
    }
    public void RunGroup(params System.Action[] scripts)
    {
        if(group is not null)throw new InvalidOperationException("不能嵌套 RunGroup");
        var pending=new List<(double At,int Order,System.Action Run)>();group=pending;
        try{foreach(var script in scripts)script();}finally{group=null;}
        var start=Context.EventTime;
        foreach(var e in pending.OrderBy(e=>e.At).ThenBy(e=>e.Order))
        {
            Context.EventTime=start;
            if(start+e.At<=Context.Time+1e-8){Context.EventTime=start+e.At;e.Run();}
            else Context.Schedule(e.At,_=>e.Run());
        }
        Context.EventTime=start;
    }
    public void ClearAllPlayerStatus(){foreach(var p in Players)p.ClearStatus();}
    public void DestoryAllObject(){foreach(var o in GameObjects.ToArray())o.Destory();}
}
