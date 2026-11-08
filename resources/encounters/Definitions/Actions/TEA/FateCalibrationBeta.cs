using Kawari.Encounters;
// β 光暗、远近线和最远跳跃，跳后演员坐标由实时诱导控制。
using S=Script.Definitions.Statuses.TEA;
namespace Script.Definitions.Actions.TEA;
public partial class FateCalibrationBeta
{
    public override void Event(EncounterContext c,MechanicEvent e,ActorRef? actor)
    {
        var s=CalibrationState.Find(c);if(s?.Phase!="beta")return;
        if(e.Kind=="status"&&e.Data is StatusSpec[] statuses&&s.Owner(e.Actor) is {} owner)
        {foreach(var status in statuses)if(status.id==S.ProjectionColor)s.Colors[owner]=status.param;}
        else if(e.Kind=="tether"&&e.P.Number("id") is 28 or 29&&s.Owner(e.Actor) is {} a&&s.Owner(e.Target) is {} b)
        {if(e.P.Number("id")==28)s.Near=[a,b];else s.Far=[a,b];}
    }
    public override bool BeforeEvent(EncounterContext c,MechanicEvent e)=>e.Kind!="move"||CalibrationState.Find(c)?.Jumps.ContainsKey(e.Actor)!=true;
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {
        if(CalibrationState.Find(c) is not {} s)return false;
        var id=s.Owner(e.Target);
        if(e.Action is 18587 or 18588 or 18594 or 18595)
        {
            if(id is {} player){if(e.Action is 18594 or 18595&&s.Colors.TryGetValue(player,out var color))s.Beacons[color]=player;if(c.D.Find(e.Target) is {} a)c.D.Emit("projection_death",a);}
        }
        else if(e.Action==19220)
        {
            var roles=s.Colors.ToDictionary(v=>v.Key,v=>v.Value==132?(s.Beacons.GetValueOrDefault((ushort)132)==v.Key?"light_beacon":"light_follow"):(s.Beacons.GetValueOrDefault((ushort)133)==v.Key?"dark_beacon":"dark_follow"));
            c.Schedule(5.1,x=>{
                ForcedMarch.Begin(x,roles);
                foreach(var (pair,tether,status) in new[]{(s.Near,28u,S.Near),(s.Far,29u,S.Far)})if(pair.Length==2){x.D.Tether(pair[0],pair[1],tether,1);foreach(var player in pair)x.D.Gain(player,status,0,7.2,x.Boss);}
            });
        }
        else if(e.Action==18531)
        {
            if(s.LinksResolved)return true;s.LinksResolved=true;
            foreach(var (pair,tether,near) in new[]{(s.Near,28u,true),(s.Far,29u,false)})if(pair.Length==2)
            {var alive=c.D.Alive(pair[0])&&c.D.Alive(pair[1]);var distance=alive?c.D.Position(pair[0]).DistanceSquared(c.D.Position(pair[1])):0;
                if(!alive||(near&&distance>25)||(!near&&distance<900))Targets.Fail(c,pair,18562);c.D.Untether(pair[0],tether,1);}
            return true;
        }
        else if(e.Action==18565)
        {var source=c.D.Find(e.Actor)!.Value;var players=Targets.Players(c,c.D.Position(source));if(!Targets.Select(c,p,Targets.At(players,players.Length-1)))return true;s.Jumps[e.Actor]=p.Pos;p.Rotation=c.D.Position(source).AngleTo(p.Pos);c.D.Move(source,p.Pos,p.Rotation);}
        else if(e.Action==18566)p.Pos=s.Jumps.GetValueOrDefault(e.Actor)??c.D.Position(c.D.Find(e.Actor)!.Value);
        return false;
    }
}
