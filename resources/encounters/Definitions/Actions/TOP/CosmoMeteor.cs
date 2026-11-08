using Kawari.Encounters;
// 天体破坏表现绑定真实死亡；地面爆炸不再由录像的击杀时间触发。
namespace Script.Definitions.Actions.TOP;
public partial class CosmoMeteor
{
    private readonly Dictionary<string,string> adds=[];
    private ActorRef[] flares=[];private ActorRef? stack;
    public override void Start(EncounterContext c)=>c.State["top-meteor"]=this;
    public override Params? Prepare(EncounterContext c,MechanicEvent e)
    {if(e.Action==31664)c.State["spreads"]=Targets.Shuffle(c);return null;}
    public override bool BeforeEvent(EncounterContext c,MechanicEvent e)=>e.Kind!="despawn"||!adds.ContainsKey(e.Actor);
    public override void Event(EncounterContext c,MechanicEvent e,ActorRef? actor)
    {if(e.Kind=="spawn"&&e.Data is Params p&&p.Get<string>("role") is "CosmoMeteor" or "CosmoComet")adds[e.Actor]=p.Get<string>("role")!;}
    public override void ActorDeath(EncounterContext c,uint baseId,Position position,ActorRef actor)
    {foreach(var (key,p) in c.Definition.Actors!.DeathEffects)if(c.D.Find(key) is {} id&&c.D.Resolve(id)==actor.Id)c.Scene.MapEffect((byte)p.Number("index"),(ushort)p.Number("state"),(ushort)p.Number("timeline"));}
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {
        if(e.Action==31668)return !Targets.Select(c,p,Targets.Next(c,e.Action,e.Time,flares),"circle");
        return e.Action==31667&&!Targets.Select(c,p,stack,"circle");
    }
    public void Mark(EncounterContext c)
    {
        var players=Targets.Shuffle(c);flares=players.Take(3).ToArray();stack=Targets.At(players,3);
        foreach(var id in flares)c.D.Icon(id,346);
        foreach(var (role,delay) in new[]{("CosmoComet",0.3),("CosmoMeteor",8.3)})
            c.Schedule(delay,x=>{foreach(var (key,value) in adds)if(value==role&&x.D.Find(key) is {} id&&x.D.Alive(id)){x.D.Raid(new(){["source"]=id,["action"]=31669,["damage"]=9999999,["unmitigated"]=true});break;}});
    }
}
