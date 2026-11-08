using Kawari.Encounters;
// 最终宣言与 β 共用强制移动，保留当前玩家位置和距离失败条件。
using S=Script.Definitions.Statuses.TEA;
namespace Script.Definitions.Actions.TEA;
public static class ForcedMarch
{
    private sealed record March(Position From,Position To,double Start,double Finish,double Rotation);
    public static void Begin(EncounterContext c,Dictionary<ActorRef,string> roles)
    {
        var positions=roles.Keys.Where(c.D.Alive).ToDictionary(id=>id,id=>c.D.Position(id));
        ActorRef? light=roles.Where(v=>v.Value=="light_beacon").Select(v=>(ActorRef?)v.Key).FirstOrDefault();
        ActorRef? dark=roles.Where(v=>v.Value=="dark_beacon").Select(v=>(ActorRef?)v.Key).FirstOrDefault();
        var marches=new Dictionary<ActorRef,March>();c.State["marches"]=marches;
        foreach(var (id,role) in roles)
        {
            if(!positions.TryGetValue(id,out var p))continue;
            ActorRef? target=role=="light_follow"?light:role=="dark_follow"?dark:(ActorRef?)null;
            var to=p;
            if(target is {} actor&&positions.TryGetValue(actor,out var b))
            {
                var length=Math.Sqrt(p.DistanceSquared(b));var sign=role=="light_follow"?1:-1;
                if((sign==1&&length<22)||(sign==-1&&length>5))Targets.Fail(c,[id],18563);
                if(length>0.001)to=new(p.x+(b.x-p.x)/length*20*sign,p.y,p.z+(b.z-p.z)/length*20*sign);
            }
            c.D.Remove(id,S.FinalWord[role]);c.D.Gain(id,S.Ordained[role],0,S.MarchDuration,target??id);
            marches[id]=new(p,to,c.Time,c.Time+S.MarchDuration,c.D.Rotation(id));
        }
    }
    public static void Tick(EncounterContext c)
    {
        if(c.Find<Dictionary<ActorRef,March>>("marches") is not {} marches)return;
        foreach(var (id,m) in marches.ToArray())
        {
            if(c.D.Alive(id)){var f=Math.Min(1,(c.Time-m.Start)/(m.Finish-m.Start));c.D.Move(id,new(m.From.x+(m.To.x-m.From.x)*f,m.From.y,m.From.z+(m.To.z-m.From.z)*f),m.Rotation);}
            if(c.Time>=m.Finish)marches.Remove(id);
        }
    }
}
