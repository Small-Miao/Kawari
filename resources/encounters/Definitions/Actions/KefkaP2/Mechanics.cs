using Kawari.Encounters;
// 双塔消耗咏唱危机，并以当前距离选择跳跃与脚部方向。
namespace Script.Definitions.Actions.KefkaP2;
public sealed class Mechanics
{
    private readonly Dictionary<string,int> pool=new(){["stack"]=8,["circle"]=12,["cone"]=12};
    private readonly Dictionary<ActorRef,string> markers=[];
    private readonly Dictionary<ActorRef,int> stacks=[];
    private readonly Dictionary<ActorRef,double> vulnerable=[];
    private int effectIndex,beginTower,direction;private bool future;
    private static ActorRef Boss(EncounterContext c)=>c.D.Find("boss")!.Value;
    private static ActorRef[] Inside(EncounterContext c,Position p,double r)=>Targets.Players(c,p,id=>c.D.Position(id).DistanceSquared(p)<=r*r);
    public void Initial(EncounterContext c){c.D.SetBgm(533);c.Scene.MapEffect(0,64,128);c.Scene.MapEffect(17,1,2);c.Scene.MapEffect(18,1,4);for(byte i=1;i<=8;i++)c.Scene.MapEffect(i,4,8);}
    public void Setup(EncounterContext c)
    {
        beginTower=c.Random.Next(8);direction=c.Random.Next(2)==0?1:-1;
        var boss=c.D.Spawn("boss",new(){["base"]=19506,["layout"]=12326696,["name"]=7131,["model"]=4967,["hp"]=44109275,["level"]=100,["pos"]=Position.Center,["rotation"]=0,["boss"]=true,["targetable"]=false});c.D.Ai(boss,false);
        for(var i=1;i<=3;i++){var actor=c.D.Spawn($"clone{i}",new(){["base"]=19513,["layout"]=12326703,["name"]=7131,["model"]=2137,["hp"]=188300,["level"]=100,["pos"]=Position.Center,["rotation"]=0,["targetable"]=false,["visible"]=false});c.D.Ai(actor,false);}
    }
    private void Effect(EncounterContext c,uint action,Position pos,double rotation=0,ActorRef? target=null)
    {
        var key=$"p2-effect-{++effectIndex}";var id=c.D.Spawn(key,new(){["base"]=9020,["name"]=7131,["hp"]=1,["level"]=100,["model"]=480,["pos"]=pos,["rotation"]=rotation,["targetable"]=false});
        c.D.Circle(new(){["source"]=Boss(c),["effect_source"]=id,["action"]=action,["pos"]=pos,["rotation"]=rotation,["target"]=target??id,["radius"]=0,["targets"]=Array.Empty<ActorRef>(),["damage"]=0,["delay"]=0});c.Schedule(8,x=>x.D.Despawn(key));
    }
    private void Hurt(EncounterContext c,IEnumerable<ActorRef> players)
    {foreach(var id in players){if(vulnerable.GetValueOrDefault(id)>c.Time||c.D.Status(id,2941) is not null)Targets.Fail(c,[id]);else{vulnerable[id]=c.Time+3;c.D.Gain(id,2941,0,3,Boss(c));c.D.Raid(new(){["source"]=Boss(c),["targets"]=new[]{id},["action"]=0,["damage"]=100000,["delay"]=0});}}}
    private void Assign(EncounterContext c,ActorRef id,string? kind)
    {if(kind is null||pool.GetValueOrDefault(kind)<=0)kind=new[]{"stack","circle","cone"}.FirstOrDefault(k=>pool[k]>0);if(kind is null||pool[kind]<=0)return;pool[kind]--;markers[id]=kind;c.D.Icon(id,kind=="stack"?715u:kind=="circle"?716u:717u);}
    public void Forsaken(EncounterContext c)
    {
        c.Scene.MapEffect(17,4,8);var boss=Boss(c);c.Motion.LockFacing(boss,c.Time+7);c.D.BeginCast(boss,47804,6.7,boss,0,Position.Center);
        c.Schedule(7,x=>{x.D.EndCast(boss,47804);x.D.Emit("play_action_targeted",boss,47804,boss);x.Scene.MapEffect(17,1,2);foreach(var id in x.D.Players()){stacks[id]=4;x.D.Gain(id,5083,4,0,boss);}});
    }
    public void Markers(EncounterContext c)
    {
        var all=Targets.Shuffle(c);var support=all.Where(id=>Targets.Tank(c.D,id)||Targets.Healer(c.D,id)).ToArray();var dps=all.Except(support).ToArray();var used=new HashSet<ActorRef>();
        foreach(var group in new[]{support,dps}){var id=group.Concat(all).Where(id=>!used.Contains(id)).Cast<ActorRef?>().FirstOrDefault();if(id is {} actor){used.Add(actor);Assign(c,actor,"stack");}}
        var circle=c.Random.Next(2)==0?support:dps;var order=circle.Concat(all).Where(id=>!used.Contains(id)).Distinct().ToArray();for(var i=0;i<order.Length;i++)Assign(c,order[i],i<3?"circle":"cone");
    }
    private void Consume(EncounterContext c,ActorRef id)
    {
        markers.Remove(id,out var kind);stacks[id]=Math.Max(0,stacks.GetValueOrDefault(id)-1);if(stacks[id]>0)c.D.Gain(id,5083,(ushort)stacks[id],0,Boss(c));else c.D.Remove(id,5083);
        var p=c.D.Position(id);
        if(kind=="stack"){Effect(c,47808,p,0,id);var hit=Inside(c,p,5);if(hit.Length!=3)Targets.Fail(c,c.D.Players());Hurt(c,hit);}
        else if(kind=="circle"){Effect(c,47809,p,0,id);Hurt(c,Inside(c,p,5));}
        else if(kind=="cone"&&Targets.At(Targets.Players(c,p,v=>v!=id),0) is {} nearest)
        {var r=p.AngleTo(c.D.Position(nearest));Effect(c,47810,p,r);Hurt(c,Targets.Players(c,filter:v=>{if(v==id)return false;var q=c.D.Position(v);var diff=p.AngleTo(q)-r;return p.DistanceSquared(q)<=10000&&Math.Abs(Math.Atan2(Math.Sin(diff),Math.Cos(diff)))<=Math.PI/4;}));}
    }
    public void Towers(EncounterContext c,int round)
    {
        var positions=new List<Position>();
        foreach(var offset in new[]{0,2})
        {
            var i=((beginTower+direction*round+offset)%8+8)%8;var r=i*Math.PI/4;var p=new Position(100+8*Math.Sin(r),0,100+8*Math.Cos(r));positions.Add(p);
            var map=(byte)(((int)Math.Floor(Math.Atan2(p.x-100,100-p.z)/(Math.PI/4)+0.5)+8)%8+1);c.Scene.MapEffect(map,1,2);c.Schedule(3,x=>x.Scene.MapEffect(map,4,8));
        }
        c.Schedule(10,x=>{
            var soaked=new HashSet<ActorRef>();foreach(var p in positions){var hit=Inside(x,p,4);x.Random.Shuffle(hit);hit=hit.Take(2).ToArray();Effect(x,hit.Length==2?47806u:47807u,p);if(hit.Length!=2)Targets.Fail(x,x.D.Players());foreach(var id in hit)soaked.Add(id);}
            x.Schedule(0.67,y=>{foreach(var id in soaked)if(y.D.Alive(id))Consume(y,id);if(round<=5){var list=soaked.ToArray();y.Random.Shuffle(list);string[] requested=round%2==0?["circle","circle","cone","cone"]:["stack","stack","circle","cone"];for(var i=0;i<list.Length;i++)if(y.D.Alive(list[i]))Assign(y,list[i],requested.ElementAtOrDefault(i));}});
        });
    }
    public void EndOfWorld(EncounterContext c)
    {future=c.Random.Next(2)==0;var action=future?47826u:47827u;var boss=Boss(c);c.Motion.LockFacing(boss,c.Time+6.7);c.D.BeginCast(boss,action,6.1,boss,0,c.D.Position(boss));c.Schedule(6.4,x=>{x.D.EndCast(boss,action);x.D.Emit("play_action_targeted",boss,action,boss);});}
    public void Jump(EncounterContext c)
    {
        var list=Targets.Players(c,c.D.Position(Boss(c)));string[] names=["boss","clone1","clone2","clone3"];
        for(var i=0;i<names.Length;i++)if(Targets.At(list,i) is {} target)
        {
            var key=names[i];var source=c.D.Find(key)!.Value;var p=c.D.Position(source);var to=c.D.Position(target);var r=p.AngleTo(to);var action=key=="boss"?(future?47830u:47831u):(future?47832u:47833u);
            c.Motion.LockFacing(source,c.Time+1);c.D.Visible(source,true);c.D.Move(source,p,r,true);c.D.Emit("play_action_targeted",source,action,target);
            c.Schedule(0.5,x=>{var length=Math.Sqrt(p.DistanceSquared(to));var destination=length>5?new Position(to.x-(to.x-p.x)/length*5,to.y,to.z-(to.z-p.z)/length*5):p;x.D.Move(source,destination,r,true);Hurt(x,Inside(x,to,5));});
        }
    }
    public void Feet(EncounterContext c)
    {
        var rear=!future;var action=rear?47837u:47836u;
        foreach(var key in new[]{"boss","clone1","clone2","clone3"})
        {
            var source=c.D.Find(key)!.Value;var p=c.D.Position(source);if(Targets.At(Targets.Players(c,p),0) is not {} nearest)continue;
            var r=p.AngleTo(c.D.Position(nearest));c.Motion.LockFacing(source,c.Time+5.1);c.D.Move(source,p,r,true);c.D.BeginCast(source,action,4.7,source,0,p);
            c.Schedule(5,x=>{x.D.EndCast(source,action);x.D.Cone(new(){["source"]=source,["action"]=action,["target"]=source,["pos"]=p,["rotation"]=r+(rear?Math.PI:0),["radius"]=100,["angle"]=180,["damage"]=9999999,["unmitigated"]=true,["delay"]=0});if(key!="boss")x.Schedule(3,y=>y.D.PlayTimeline(source,7737));});
        }
    }
}
