using Kawari.Encounters;
// 遗弃末世每轮重新选择当前玩家分散顺序。
namespace Script.Definitions.Actions.UMAD;
public partial class StrayApocalypse
{
    public override Params? Prepare(EncounterContext c,MechanicEvent e){if(e.Action==47934)c.State["spreads"]=Targets.Shuffle(c);return null;}
}
