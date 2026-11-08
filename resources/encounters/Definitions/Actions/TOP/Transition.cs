using Kawari.Encounters;
// 转场极限技检查与潜能切换保留原服务器结算路径。
namespace Script.Definitions.Actions.TOP;
public partial class Transition
{
    public override void Engage(EncounterContext c){foreach(var id in Targets.Players(c))c.D.Gain(id,3444,3,0);}
    public override void BeforeResolve(EncounterContext c,MechanicEvent e,Params p)=>p["requires_dynamis"]=e.Action is not(31649 or 32626 or 31670);
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {
        if(e.Action==32223)
        {
            var far=Targets.Players(c,c.D.Position(c.Boss!.Value));
            var list=new[]{Targets.At(Targets.Hate(c),0),Targets.At(far,far.Length-1)}.OfType<ActorRef>().ToArray();
            return !Targets.Select(c,p,Targets.Next(c,e.Action,e.Time,list),"circle");
        }
        if(e.Action==31649)c.Schedule(0.2,x=>{foreach(var id in x.D.Players()){x.D.Remove(id,3444);x.D.Gain(id,3446,0,0);}x.D.LimitBreak(30000);});
        return false;
    }
}
