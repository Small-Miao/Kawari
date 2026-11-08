using Kawari.Encounters;
// 同帧圣光与核爆共享选人结果，后半根据当前距离重新排序。
using S=Script.Definitions.Statuses.UMAD;
namespace Script.Definitions.Actions.UMAD;
public partial class MaddeningOrchestra
{
    private ActorRef[]? tanks;private ActorRef[] nonTanks=[],nearest=[];private int holy,flare;
    public override Params? Prepare(EncounterContext c,MechanicEvent e)
    {if(e.Action==47952){tanks=null;holy=flare=0;nonTanks=[];nearest=[];}return null;}
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {
        var a=e.Action;
        if(a is 47954 or 47956 && tanks is null){tanks=Targets.Hate(c);nonTanks=Targets.Shuffle(c).Where(id=>!tanks.Take(2).Contains(id)).ToArray();}
        ActorRef? target=null;
        switch(a)
        {
            case 47954:
                target=Targets.At(tanks??[],flare++);
                if(flare==1){if(Targets.At(tanks??[],0) is {} x)c.D.Gain(x,S.SurpriseFlare,0,7,c.Boss);if(Targets.At(tanks??[],1) is {} y)c.D.Gain(y,S.SurpriseHoly,0,7,c.Boss);}break;
            case 47956:
                holy++;if(holy==4)nearest=Targets.Players(c,c.D.Position(c.Boss!.Value));target=holy<=3?Targets.At(nonTanks,holy-1):Targets.At(nearest,holy-4);break;
            case 47955:target=Targets.At(Targets.Hate(c),0);break;
            case 47957:target=Targets.At(tanks??[],0);if(target is {} f)c.D.Remove(f,S.SurpriseFlare);break;
            case 47958:target=Targets.At(tanks??[],1);if(target is {} h)c.D.Remove(h,S.SurpriseHoly);break;
            default:return false;
        }
        if(target is not {} id)return true;p.Target=id;p.Pos=c.D.Position(id);
        if(a==47957)
        {
            p["damage"]=500000;p["unmitigated"]=false;
            Targets.Fail(c,Targets.Players(c,p.Pos,v=>v!=id&&c.D.Position(v).DistanceSquared(p.Pos)<625));p["targets"]=new[]{id};
        }
        return false;
    }
}
