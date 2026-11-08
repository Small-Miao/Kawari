using Kawari.Encounters;
// α 根据投影分配回映当前玩家，十字圣礼沿演员实际原点结算。
namespace Script.Definitions.Actions.TEA;
public partial class FateCalibrationAlpha
{
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {
        if(CalibrationState.Find(c) is not {} s)return false;
        var owner=s.Owner(e.Target);
        switch(e.Action)
        {
            case 18596:
                s.Defamation=s.Owners.Where(v=>c.D.Find(v.Key) is not null).OrderBy(v=>c.D.Position(c.D.Find(v.Key)!.Value).DistanceSquared(e.P.Pos)).Select(v=>(ActorRef?)v.Value).FirstOrDefault();break;
            case 18598:s.Shared=owner;if(owner is not null&&c.D.Find(e.Target) is {} shared)c.D.Emit("projection_death",shared);break;
            case 18597:if(owner is {} id){s.Assault.Add(id);if(c.D.Find(e.Target) is {} a)c.D.Emit("projection_death",a);}break;
            case 18585:case 18586:if(c.D.Find(e.Target) is {} dead)c.D.Emit("projection_death",dead);break;
            case 18528:return !Targets.Select(c,p,s.Defamation);
            case 18530:
                if(!Targets.Select(c,p,s.Shared))return true;
                if(s.Phase=="alpha")Targets.Fail(c,s.Assault.Where(id=>c.D.Alive(id)&&c.D.Position(id).DistanceSquared(p.Pos)<=16));break;
            case 18529:return !Targets.Select(c,p,Targets.At(s.Assault,s.AssaultIndex++));
            case 18569:
                var source=c.D.Find(e.Actor)!.Value;var center=c.D.Position(source);var rotation=c.D.Rotation(source);
                c.D.Emit("play_action_targeted",source,e.Action,source);
                foreach(var r in new[]{rotation,rotation+Math.PI/2})c.D.Rect(new(){["source"]=c.Boss,["action"]=0,["pos"]=new Position(center.x-100*Math.Sin(r),center.y,center.z-100*Math.Cos(r)),["rotation"]=r,["length"]=200,["width"]=16,["damage"]=9999999,["unmitigated"]=true});
                return true;
        }
        return false;
    }
}
