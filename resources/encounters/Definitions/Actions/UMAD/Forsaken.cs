using Kawari.Encounters;
// 橙圈诱导和地板破坏共用同一坐标，MapEffect 索引在施法时写入实例状态。
using S=Script.Definitions.Statuses.UMAD;
namespace Script.Definitions.Actions.UMAD;
public partial class Forsaken
{
    public static readonly Dictionary<int,Position> Puddles=new(){[29]=new(93.25,0,106.75),[30]=new(93.25,0,93.25),[31]=new(106.75,0,93.25),[32]=new(106.75,0,106.75)};
    private readonly List<Position> destroyed=[];private ActorRef? stack;private double floorCheck;
    public override Params? Prepare(EncounterContext c,MechanicEvent e)
    {
        if(e.Action!=47928||Targets.At(Targets.Shuffle(c),0) is not {} id)return null;
        var target=c.D.Position(id);var pair=Puddles.OrderBy(v=>v.Value.DistanceSquared(target)).ThenBy(v=>v.Key).First();
        c.State["forsaken-puddle"]=pair.Key;return new(){["pos"]=pair.Value,["cast_pos"]=pair.Value,["rotation"]=e.P.Rotation};
    }
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {
        if(e.Action is 47925 or 47926){stack=Targets.At(Targets.Shuffle(c),0);if(stack is {} id)c.D.Icon(id,161);}
        else if(e.Action==47927)destroyed.Add(p.Pos);
        else if(e.Action==47929)return !Targets.Select(c,p,stack);
        return false;
    }
    public override void Tick(EncounterContext c)
    {
        if(c.Phase!="battle"||c.Time<floorCheck)return;floorCheck=c.Time+0.25;
        var caught=Targets.Players(c,filter:id=>destroyed.Any(p=>c.D.Position(id).DistanceSquared(p)<64));
        if(caught.Length>0)c.D.Raid(new(){["source"]=c.Boss,["targets"]=caught,["action"]=0,["damage"]=9999999,["unmitigated"]=true,["death_status"]=S.MissingExistence});
    }
}
