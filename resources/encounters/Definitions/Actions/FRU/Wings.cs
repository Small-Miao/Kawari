using Kawari.Encounters;
// 首次翅膀保留读条点名，后续使用实时仇恨以支持换坦。
namespace Script.Definitions.Actions.FRU;
public partial class Wings
{
    private ActorRef? target;private int hit;
    public override Params? Prepare(EncounterContext c,MechanicEvent e)
    {if(e.Action is 40313 or 40233){target=Targets.At(Targets.Hate(c),0);hit=0;}return null;}
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {
        var rule=rules[e.Action];if(rule.Kind!="wing")return false;
        var id=hit++==0?target:Targets.At(Targets.Hate(c),0);p.Pos=c.D.Position(c.Boss!.Value);
        p.Rotation=id is {} actor?p.Pos.AngleTo(c.D.Position(actor))+rule.Number("offset"):e.P.Rotation;p.Kind="cone";return false;
    }
}
