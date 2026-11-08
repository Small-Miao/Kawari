using Kawari.Encounters;
// 转场、天诛及抨击共享实时仇恨。
using S=Script.Definitions.Statuses.TEA;
namespace Script.Definitions.Actions.TEA;
public partial class TransitionPunishment
{
    public override void Engage(EncounterContext c){foreach(var id in Targets.Players(c))c.D.Gain(id,S.EnigmaCodex,0,0,c.Boss);}
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {if(e.Action is 18579 or 18577)return !Targets.Select(c,p,Targets.At(Targets.Hate(c),0));if(e.Action==19083)p["punish_status"]=S.PhysicalVulnerability;return false;}
}
