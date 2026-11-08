// 显式演员操作进入实时机制钩子，保持施法几何和仇恨朝向的一致性。
namespace Kawari.Encounters;
public sealed class ActorControl(EncounterContext c)
{
    private MechanicEvent Event(string kind,string key,uint action=0,double seconds=0,Params? p=null,object? data=null)=>new(kind,key,c.EventTime,action,seconds,p,data);
    public ActorRef Spawn(string key,bool notify=true)
    {
        var spec=c.Mechanics.Spawn(key,c.Definition.Actors!.Templates[key]);
        var actor=c.D.Find(key);
        if(actor is {} old){c.D.Move(old,spec.Pos,spec.Rotation);c.D.Model(old,(int)spec.Number("model_state"));}
        else {actor=c.D.Spawn(key,spec);if(spec.Number("animation_state")!=0)c.D.Animation(actor.Value,0,(int)spec.Number("animation_state"));}
        if(notify&&spec.Get<string>("owner") is {} owner)c.D.Owner(actor.Value,c.D.Find(owner));
        if(notify)c.Mechanics.Event(Event("spawn",key,data:spec),actor);
        return actor.Value;
    }
    public void Despawn(string key)
    {var e=Event("despawn",key);if(!c.Mechanics.BeforeEvent(e))return;if(key!=c.Definition.Actors?.Boss)c.D.Despawn(key);c.Mechanics.Event(e,c.D.Find(key));}
    public void Move(string key,Position pos,double rotation)
    {if(!c.Mechanics.BeforeEvent(Event("move",key,p:new(){["pos"]=pos,["rotation"]=rotation})))return;if(c.D.Find(key) is {} actor&&!c.Geometry.ContainsKey(key)&&!(key==c.Definition.Actors?.Boss&&c.Phase=="battle"))c.D.Move(actor,pos,rotation);}
    public void Cast(string key,uint action,double seconds,Params options)
    {
        if(c.D.Find(key) is not {} actor)return;
        var e=Event("cast",key,action,seconds,options);var p=c.Mechanics.Prepare(e);
        c.D.Move(actor,p.Get<Position>("pos")??options.Pos,p.ContainsKey("rotation")?p.Rotation:options.Rotation);
        c.D.BeginCast(actor,action,seconds,p.Target??c.D.Find(e.Target)??actor,options.Number("omen_delay"),p.Get<Position>("cast_pos")??options.Get<Position>("cast_pos"),options.ContainsKey("spell")?(ushort)options.Number("spell"):null);
    }
    public void Action(string key,uint action,Params options)
    {if(c.D.Find(key) is not {} actor)return;var e=Event("action",key,action,p:options);c.D.EndCast(actor,action);c.Mechanics.Resolve(e,actor,c.D.Find(e.Target));c.Geometry.Remove(key);}
    public void Target(string key,string? to){if(c.D.Find(key) is {} actor&&c.D.Find(to) is {} target)c.D.Target(actor,target);}
    public void Owner(string key,string? to){if(c.D.Find(key) is {} actor)c.D.Owner(actor,c.D.Find(to));}
    public void Tether(string key,string? to,uint id,int slot)
    {var actor=c.D.Find(key);if(actor is {} a&&c.D.Find(to) is {} t)c.D.Tether(a,t,id,slot);c.Mechanics.Event(Event("tether",key,p:new(){["target"]=to,["id"]=id,["slot"]=slot}),actor);}
    public void Untether(string key,uint id,int slot){if(c.D.Find(key) is {} actor)c.D.Untether(actor,id,slot);}
    public void Status(string key,StatusSpec[] statuses)
    {var actor=c.D.Find(key);if(actor is {} a)foreach(var s in statuses)c.D.Gain(a,s.id,s.param,s.duration,a);c.Mechanics.Event(Event("status",key,data:statuses),actor);}
    public void Targetable(string key,bool enabled)
    {if(key!=c.Definition.Actors?.Boss||c.D.Find(key) is not {} actor)return;c.D.Targetable(actor,enabled);if(enabled&&c.Phase=="transition"){c.Phase="battle";c.Mechanics.Engage();}}
    public void Animation(string key,int a,int b){if(c.D.Find(key) is {} id)c.D.Animation(id,a,b);}
    public void Model(string key,int state){if(c.D.Find(key) is {} id)c.D.Model(id,state);}
    public void Timeline(string key,uint value){if(c.D.Find(key) is {} id)c.D.PlayTimeline(id,value);}
    public void Visible(string key,bool value,double fade=0){if(c.D.Find(key) is {} id)c.D.Visible(id,value,fade);}
    public void Hide(string key){if(c.D.Find(key) is {} id)c.D.Emit("hide_actor",id);}
    public void Presentation(string key,uint operation,uint parameter,uint duration){if(c.D.Find(key) is {} id)c.D.Emit("actor_presentation",id,operation,parameter,duration);}
    public void SynchronizedTimelines((string Actor,ushort Timeline)[] entries)
        => c.D.Emit("play_actor_timelines",(object)entries.Select(e=>new object[]{c.D.Find(e.Actor)??throw new InvalidOperationException($"同步演员不存在 {e.Actor}"),e.Timeline}).ToArray());
}
