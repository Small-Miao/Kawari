using Kawari.Encounters;
// 三位一体按当前仇恨和距离选人，状态由原生伤害结算同步。
namespace Script.Definitions.Actions.DSR;
public partial class Trinity
{
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {
        var rule=rules[e.Action];
        var target=rule.Flag("nearest")?Targets.At(Targets.Players(c,c.D.Position(c.Boss!.Value)),0):Targets.At(Targets.Hate(c),(int)rule.Number("rank")-1);
        p["radius"]=3;return !Targets.Select(c,p,target,"circle");
    }
}
