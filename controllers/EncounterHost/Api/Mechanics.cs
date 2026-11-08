// 通用选人和命中分发；副本专属规则由 Definitions/Actions 的 C# 模块提供。
namespace Kawari.Encounters;
public sealed record MechanicEvent(string Kind,string Actor,double Time, uint Action=0,double Seconds=0,Params? Options=null,object? Data=null)
{
    public Params P => Options??new();
    public string? Target => Options?.Get<string>("target");
}
public abstract class ActionDefinition
{
    public abstract IReadOnlyDictionary<uint,Params> Rules { get; }
    public virtual void Start(EncounterContext c) { }
    public virtual void Engage(EncounterContext c) { }
    public virtual void Tick(EncounterContext c) { }
    public virtual void Event(EncounterContext c,MechanicEvent e,ActorRef? actor) { }
    public virtual bool BeforeEvent(EncounterContext c,MechanicEvent e) => true;
    public virtual Params Spawn(EncounterContext c,string key,Params spec) => spec;
    public virtual Params? Prepare(EncounterContext c,MechanicEvent e) => null;
    public virtual void BeforeResolve(EncounterContext c,MechanicEvent e,Params p) { }
    public virtual bool Resolve(EncounterContext c,MechanicEvent e,Params p) => false;
    public virtual void ActorDeath(EncounterContext c,uint baseId,Position position,ActorRef actor) { }
}
public static class Targets
{
    public static bool Tank(NativeDirector d,ActorRef actor) => d.Job(actor) is 1 or 3 or 19 or 21 or 32 or 37;
    public static bool Healer(NativeDirector d,ActorRef actor) => d.Job(actor) is 6 or 24 or 28 or 33 or 40;
    public static ActorRef[] Players(EncounterContext c,Position? origin=null,Func<ActorRef,bool>? filter=null)
    {
        var all=c.D.Players().Where(p=>filter?.Invoke(p)??true);
        return (origin is null?all.OrderBy(p=>p.Id):all.OrderBy(p=>c.D.Position(p).DistanceSquared(origin)).ThenBy(p=>p.Id)).ToArray();
    }
    public static ActorRef[] Hate(EncounterContext c)
    {
        var hate=c.Boss is {} boss?c.D.Enmity(boss):[];
        return hate.Concat(Players(c).OrderByDescending(p=>Tank(c.D,p)).ThenBy(p=>p.Id)).Distinct().ToArray();
    }
    public static ActorRef? At(IEnumerable<ActorRef> list,int index) => list.Skip(index).Cast<ActorRef?>().FirstOrDefault();
    public static ActorRef[] Shuffle(EncounterContext c) { var p=Players(c); c.Random.Shuffle(p); return p; }
    private sealed record Group(double Time,ActorRef[] Players) { public int Cursor; }
    public static ActorRef? Next(EncounterContext c,uint action,double time,ActorRef[]? list=null)
    {
        var key=$"target-group:{action}";
        var group=c.Find<Group>(key);
        if(group is null||time-group.Time>0.25) c.State[key]=group=new(time,list??Players(c));
        return group.Players.Length==0?(ActorRef?)null:group.Players[group.Cursor++%group.Players.Length];
    }
    public static ActorRef? Side(EncounterContext c,double side)
    {
        var pos=c.Boss is {} b?c.D.Position(b):Position.Center;var rot=c.Boss is {} a?c.D.Rotation(a):0;
        return At(Players(c,pos,id=>{var p=c.D.Position(id);return side*((p.x-pos.x)*Math.Cos(rot)-(p.z-pos.z)*Math.Sin(rot))>0;}),0);
    }
    public static bool Select(EncounterContext c,Params p,ActorRef? id,string? kind=null)
    { if(id is not {} actor||!c.D.Alive(actor)) return false; p.Target=actor;p.Pos=c.D.Position(actor);if(kind is not null)p.Kind=kind;return true; }
    public static void Fail(EncounterContext c,IEnumerable<ActorRef> targets,uint action=0)
    { var all=targets.ToArray(); if(all.Length>0)c.D.Raid(new(){["source"]=c.Boss,["targets"]=all,["action"]=action,["damage"]=9999999,["unmitigated"]=true}); }
}
public sealed class MechanicEngine(EncounterContext c)
{
    private readonly Dictionary<uint,Params> rules=c.Definition.Actions.SelectMany(a=>a.Rules).ToDictionary(p=>p.Key,p=>p.Value);
    public Params Rule(uint id) => rules.TryGetValue(id,out var p)?p:throw new InvalidDataException($"未分类技能 {id}");
    public void Start() { c.D.LimitBreak(30000);foreach(var m in c.Definition.Actions)m.Start(c); }
    public void Engage() { foreach(var m in c.Definition.Actions)m.Engage(c); }
    public bool BeforeEvent(MechanicEvent e) => c.Definition.Actions.All(m=>m.BeforeEvent(c,e));
    public void Event(MechanicEvent e,ActorRef? actor) { foreach(var m in c.Definition.Actions)m.Event(c,e,actor); }
    public Params Spawn(string key,Params spec) { foreach(var m in c.Definition.Actions)spec=m.Spawn(c,key,spec);return spec; }
    public void ActorDeath(uint baseId,Position pos,ActorRef actor) { foreach(var m in c.Definition.Actions)m.ActorDeath(c,baseId,pos,actor); }
    public Params Prepare(MechanicEvent e)
    {
        if(e.Actor==c.Definition.Actors?.Boss&&c.Boss is {} boss)c.Motion.LockFacing(boss,e.Time+e.Seconds+0.5);
        var rule=Rule(e.Action);
        if(e.Action==c.Definition.EnrageCast)c.EnrageAt=e.Time+c.Definition.EnrageDelay;
        Params? geometry=null;
        foreach(var m in c.Definition.Actions)geometry=m.Prepare(c,e)??geometry;
        if(geometry is not null){c.Geometry[e.Actor]=geometry;return geometry;}
        var p=new Params{["pos"]=e.P.Pos,["rotation"]=e.P.Rotation};
        if(e.Actor==c.Definition.Actors?.Boss&&c.Phase=="battle"&&c.Boss is {} b)
        {p.Pos=c.D.Position(b);p.Rotation=Targets.At(Targets.Hate(c),0) is {} id?p.Pos.AngleTo(c.D.Position(id)):c.D.Rotation(b);}
        if(rule.Kind=="puddle"&&Targets.Next(c,e.Action,e.Time) is {} target)
        {p.Pos=c.D.Position(target);p["cast_pos"]=p.Pos;c.Geometry[e.Actor]=p;}
        return p;
    }
    public void Resolve(MechanicEvent e,ActorRef source,ActorRef? target)
    {
        var rule=Rule(e.Action);var p=rule.Copy();p["source"]=source;p["action"]=e.Action;p["delay"]=0;
        var bp=c.Boss is {} boss?c.D.Position(boss):Position.Center;
        if(c.Boss is {} b){p["source"]=b;p["effect_source"]=source;}
        var g=c.Geometry.GetValueOrDefault(e.Actor);p.Pos=g?.Pos??e.P.Pos;p.Rotation=g?.Rotation??e.P.Rotation;
        if(source==c.Boss&&c.Phase=="battle")p.Rotation=c.D.Rotation(source);
        p.Target=target;
        foreach(var m in c.Definition.Actions)m.BeforeResolve(c,e,p);
        foreach(var m in c.Definition.Actions)if(m.Rules.ContainsKey(e.Action)&&m.Resolve(c,e,p))return;
        var kind=p.Kind;p.Remove("kind");
        if(kind=="ignore")return;
        if(kind=="visual"){p["radius"]=0;p["targets"]=Array.Empty<ActorRef>();p["damage"]=0;p.Pos=e.P.Get<Position>("dest")??p.Pos;c.D.Circle(p);return;}
        ActorRef? selected=null;
        switch(kind)
        {
            case "tank_auto":selected=Targets.Next(c,e.Action,e.Time,Targets.Hate(c));p["radius"]=0;p["physical"]=true;kind="single";break;
            case "distance_target":var all=Targets.Players(c,bp);selected=Targets.At(all,rule.Flag("farthest")?all.Length-1:0);kind="circle";break;
            case "puddle":kind="circle";break;
            case "spread":selected=Targets.Next(c,e.Action,e.Time,c.Find<ActorRef[]>("spreads"));kind="circle";break;
        }
        if(selected is {} id)
        {if(!Targets.Select(c,p,id))return;if(kind=="single"){p["targets"]=new[]{id};kind="raid";}}
        else if(kind=="single"){if(p.Target is not {} t)return;p["targets"]=new[]{t};kind="raid";}
        if(source!=c.Boss)c.D.Move(source,p.Pos,p.Rotation);
        switch(kind){case "circle":c.D.Circle(p);break;case "donut":c.D.Donut(p);break;case "rect":c.D.Rect(p);break;case "cone":c.D.Cone(p);break;case "raid":c.D.Raid(p);break;default:throw new InvalidDataException($"未知判定类型 {kind}");}
    }
    public void Tick()
    {
        foreach(var m in c.Definition.Actions)m.Tick(c);
        if(c.EnrageAt is {} t&&c.Time>=t&&c.Boss is not null){c.EnrageAt=null;Targets.Fail(c,Targets.Players(c));}
        if(c.Phase!="battle"||c.Boss is not {} boss)return;
        if(!c.State.ContainsKey("facing")){c.Motion.FaceEnmity(boss);c.State["facing"]=true;}
        Targets.Fail(c,Targets.Players(c,filter:id=>{
            var p=c.D.Position(id);var def=c.Definition;
            if(def.ArenaSquare is not {} square)return p.DistanceSquared(Position.Center)>def.ArenaRadius*def.ArenaRadius;
            var a=def.ArenaRotation;var x=p.x-100;var z=p.z-100;
            return Math.Abs(x*Math.Cos(a)-z*Math.Sin(a))>square||Math.Abs(x*Math.Sin(a)+z*Math.Cos(a))>square;
        }));
    }
}
