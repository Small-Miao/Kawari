using Kawari.Encounters;
// 行动/静止判定同时检查位移和服务器技能计数。
using S=Script.Definitions.Statuses.TEA;
namespace Script.Definitions.Actions.TEA;
public partial class FinalWord
{
    private sealed class Motion(Position pos,ulong count){public Position Pos=pos;public ulong Count=count;public double Last=-100;}
    private readonly Dictionary<ActorRef,Motion> motion=[];
    private readonly Queue<(ActorRef Player, bool Passed)> ordainedResults = new();
    private uint ordainedSuccess;
    public override void Tick(EncounterContext c)
    {
        foreach(var id in Targets.Players(c))
        {
            var p=c.D.Position(id);var count=c.D.Snapshot(id)?.actionCount??0;
            if(!motion.TryGetValue(id,out var m))motion[id]=m=new(p,count);
            if(p.DistanceSquared(m.Pos)>0.0001||count!=m.Count)m.Last=c.Time;m.Pos=p;m.Count=count;
        }
        ForcedMarch.Tick(c);
    }
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {
        if(e.Action==18557)
        {
            var players=Targets.Shuffle(c);string[] names=["light_beacon","dark_beacon","light_follow","dark_follow","light_follow","dark_follow","light_follow","dark_follow"];
            var roles=new Dictionary<ActorRef,string>();
            for(var i=0;i<Math.Min(players.Length,names.Length);i++){roles[players[i]]=names[i];c.D.Gain(players[i],S.FinalWord[names[i]],0,10,c.Boss);}
            c.Schedule(9.95,x=>ForcedMarch.Begin(x,roles));
        }
        else if(e.Action is 18558 or 18559 or 18859 or 18860)
        {
            var required=e.Action is 18558 or 18859;
            ordainedSuccess = required ? 19039u : 19040u;
            ordainedResults.Clear();
            foreach (var player in Targets.Players(c))
            {
                var moved = motion.TryGetValue(player, out var m) && c.Time - m.Last < 0.75;
                ordainedResults.Enqueue((player, moved == required));
            }
            if (c.D.Find(e.Actor) is { } caster)
                c.D.Emit("play_action_targeted", caster, e.Action, caster, true);
            return true;
        }
        else if (e.Action is 19039 or 19040)
        {
            // 录像中八个 Helper 各结算一人；练习模式只处理当前存活的玩家。
            if (e.Action == ordainedSuccess && ordainedResults.TryDequeue(out var result) &&
                c.D.Alive(result.Player) && c.D.Find(e.Actor) is { } helper)
            {
                if (result.Passed)
                    c.D.Emit("play_action_targeted", helper, e.Action, result.Player, true);
                else
                    c.D.Raid(new()
                    {
                        ["source"] = c.Boss, ["effect_source"] = helper, ["targets"] = new[] { result.Player },
                        ["target"] = result.Player, ["pos"] = c.D.Position(result.Player),
                        ["action"] = e.Action == 19039 ? 18560u : 18561u, ["damage"] = 9999999, ["unmitigated"] = true,
                    });
            }
            return true;
        }
        return false;
    }
}
