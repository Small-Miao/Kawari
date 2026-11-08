using Kawari.Encounters;
// 元素预分配与实际踩塔人数检查。
using S=Script.Definitions.Statuses.UMAD;
namespace Script.Definitions.Actions.UMAD;
public partial class Celestriad
{
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {
        if(e.Action==47938)
        {
            var list=Targets.Shuffle(c);
            for(var i=0;i<3;i++)for(var j=0;j<2;j++)if(Targets.At(list,i*2+j) is {} id)c.D.Gain(id,S.Elements[i],0,20,c.Boss);
        }
        else if(e.Action is >=47939 and <=47941 && !Targets.Players(c,p.Pos,id=>c.D.Position(id).DistanceSquared(p.Pos)<=9).Any())
        {
            c.D.Raid(new(){["source"]=p.Get<ActorRef?>("source"),["effect_source"]=p.Get<ActorRef?>("effect_source"),["action"]=e.Action+3,["damage"]=100000,["status"]=S.DamageDown,["status_duration"]=180});return true;
        }
        return false;
    }
}
