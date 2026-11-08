using Kawari.Encounters;
// 天箭伴随的近距离双坦与第三近分摊。
namespace Script.Definitions.Actions.TOP;
public partial class CosmoArrow
{
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {
        var rule=rules[e.Action];var list=Targets.Players(c,c.D.Position(c.Boss!.Value));
        if(rule.Kind=="dive_tank")return !Targets.Select(c,p,Targets.Next(c,e.Action,e.Time,list),"circle");
        return rule.Kind=="dive_stack"&&!Targets.Select(c,p,Targets.At(list,2),"circle");
    }
}
