using Kawari.Encounters;
// 光学分散/分摊和神圣之恩使用本轮实际点名。
namespace Script.Definitions.Actions.TEA;
public partial class OpticalSightAlmightyJudgment
{
    private ActorRef[]? targets;private int index;private ActorRef? grace;
    public override Params? Prepare(EncounterContext c,MechanicEvent e)
    {if(e.Action==18580){grace=Targets.At(Targets.Shuffle(c),0);if(grace is {} id)c.D.Icon(id,62);}return null;}
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {
        if(e.Action is 18570 or 18571 or 18861 or 18862)
        {
            var stack=e.Action is 18571 or 18862;var list=Targets.Shuffle(c);
            targets=e.Action==18862?new ushort[]{132,133}.Where(color=>CalibrationState.Find(c)?.Beacons.ContainsKey(color)==true).Select(color=>CalibrationState.Find(c)!.Beacons[color]).ToArray():stack?list.Take(2).ToArray():list;
            index=0;foreach(var id in targets)c.D.Icon(id,stack?62u:139u);
        }
        else if(e.Action is 18572 or 18573){targets??=Targets.Players(c);return !Targets.Select(c,p,Targets.At(targets,index++));}
        else if(e.Action==18580)return !Targets.Select(c,p,grace);
        return false;
    }
}
