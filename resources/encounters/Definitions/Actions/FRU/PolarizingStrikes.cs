using Kawari.Encounters;
// 光暗分摊锁定本轮方向，余晖沿用对应方向；首位减益读取服务器状态。
namespace Script.Definitions.Actions.FRU;
public partial class PolarizingStrikes
{
    private readonly Dictionary<int,Params> afterglow=[];
    public override Params? Prepare(EncounterContext c,MechanicEvent e)
    {
        if(!rules.TryGetValue(e.Action,out var rule)||rule.Kind!="polarizing")return null;
        if(Targets.Side(c,rule.Number("side")) is not {} id)return null;
        var p=c.D.Position(c.Boss!.Value);
        return new(){["pos"]=p,["rotation"]=p.AngleTo(c.D.Position(id)),["target"]=id,["cast_pos"]=c.D.Position(id)};
    }
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p)
    {
        var rule=rules[e.Action];var side=(int)rule.Number("side");
        if(rule.Kind=="side_stack")return !Targets.Select(c,p,Targets.Side(c,side),"circle");
        if(rule.Kind=="polarizing")
        {
            var geometry=c.Geometry.GetValueOrDefault(e.Actor);var target=geometry?.Target??Targets.Side(c,side);
            p.Pos=c.D.Position(c.Boss!.Value);p.Rotation=geometry?.Rotation??(target is {} id?p.Pos.AngleTo(c.D.Position(id)):e.P.Rotation);
            if(target is {} actor&&(c.D.Status(actor,4164) is not null||c.D.Status(actor,3323) is not null)){p["damage"]=9999999;p["unmitigated"]=true;}
            afterglow[side]=new(){["pos"]=p.Pos,["rotation"]=p.Rotation};p.Kind="rect";
        }
        else if(rule.Kind=="afterglow")
        {if(afterglow.TryGetValue(side,out var g)){p.Pos=g.Pos;p.Rotation=g.Rotation;}p.Kind="rect";}
        return false;
    }
}
