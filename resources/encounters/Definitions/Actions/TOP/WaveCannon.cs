using Kawari.Encounters;
// 波动炮实时选人，直线分摊由原生几何检查前排坦克数量。
namespace Script.Definitions.Actions.TOP;
public partial class WaveCannon
{
    private ActorRef[] proteans=[];private int index;private ActorRef? charge;
    public override Params? Prepare(EncounterContext c,MechanicEvent e)
    {if(e.Action==31657){proteans=Targets.Shuffle(c);index=0;charge=Targets.At(Targets.Players(c,filter:id=>!Targets.Tank(c.D,id)),0);}return null;}
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {
        if(e.Action is not(31659 or 31658))return false;
        var id=e.Action==31659?Targets.At(proteans,index++):charge;
        p.Pos=c.D.Position(c.Boss!.Value);p.Rotation=id is {} actor?p.Pos.AngleTo(c.D.Position(actor)):e.P.Rotation;p.Kind="rect";return false;
    }
}
