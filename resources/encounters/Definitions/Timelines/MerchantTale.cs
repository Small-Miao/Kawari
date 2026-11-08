using Kawari.Encounters;
// 商客奇谭现有入口、NPC 路线建议和投票地图控制。
using MechanicSim_Server.Manager;
using TimeLineDef = MechanicSim_Server.Struct.TimeLineDef;
using TimeLinePhase = MechanicSim_Server.Struct.TimeLinePhase;
using TimeLineNode = MechanicSim_Server.Struct.TimeLineNode;
namespace Script.Definitions.Timelines;

public sealed class MerchantTale : MechanicSim_Server.Definition.ITimeLineDefinition
{
    public string DefinitionId => "m6d1";
    public TimeLineDef Build()
    {
        var route = 1;
        return new()
        {
            TimeLineName = "商客奇谭",
            NativeEncounter = new Kawari.Encounters.TimeLineDef
            {
                TimeLineName = "商客奇谭",
                OnTimeLineInit = c => { route = c.Random.Next(1, 4); c.D.Emit("spawn_bnpc", 12109841); },
                OnEvent = (c, e) =>
                {
                    var kind = e.GetProperty("kind").GetString();
                    if (kind == "gimmick_rect" && e.GetProperty("id").GetUInt32() == 12110117) c.D.Emit("variant_vote_route", route);
                    if (kind == "variant_vote") { var vote = e.GetProperty("vote").GetInt32(); if (vote is >= 1 and <= 3) c.D.Emit("map_effect", new[] { 11, 13, 12 }[vote - 1], 2); }
                }
            }
        };
    }
}
