using Kawari.Encounters;
// 三组魔击分别选择仇恨、治疗和输出职业。
namespace Script.Definitions.Actions.UMAD;
public partial class UltimaRepeaterFellForces
{
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {
        ActorRef? target;
        if(e.Action==50771)target=Targets.At(Targets.Hate(c),0);
        else if(e.Action is 50772 or 50773)
        {var list=Targets.Players(c,filter:id=>e.Action==50772?Targets.Healer(c.D,id):!Targets.Tank(c.D,id)&&!Targets.Healer(c.D,id));target=Targets.At(list,c.Random.Next(Math.Max(1,list.Length)));}
        else return false;
        return !Targets.Select(c,p,target);
    }
}
