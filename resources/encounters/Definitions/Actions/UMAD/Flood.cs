using Kawari.Encounters;
// 无之泛滥分摊以当前存活玩家为中心。
namespace Script.Definitions.Actions.UMAD;
public partial class Flood
{
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {if(e.Action==47951&&Targets.At(Targets.Shuffle(c),0) is {} id){p.Pos=c.D.Position(id);p.Target=id;}return false;}
}
