using Kawari.Encounters;
using MechanicSim_Server.Manager;
// 投影外观复制当前玩家，预演击杀只影响投影。
namespace Script.Definitions.Actions.TEA;
public partial class FateProjection
{
    // 使用原 MechanicSim 的位置更新及 BrocastMove，让预演人物通过 ActorMove 连续移动。
    public static void Move(string key, Position position, double rotation)
    {
        var projection = RaidManager.Instance.GetObjectByGameObjectId(key);
        if (projection is null) return;
        projection.Position = new System.Numerics.Vector3((float)position.x, (float)position.y, (float)position.z);
        projection.Rotation = (float)rotation;
        projection.BrocastMove();
    }

    public override Params? Prepare(EncounterContext c,MechanicEvent e)
    {
        if(e.Action is 18555 or 19219)
        {foreach(var id in Targets.Players(c))c.D.Untether(id,98);c.State["calibration"]=new CalibrationState{Phase=e.Action==18555?"alpha":"beta",Players=Targets.Shuffle(c)};}
        return null;
    }
    public override Params Spawn(EncounterContext c,string key,Params spec)
    {
        if(spec.Number("base")!=11350)return spec;
        var state=CalibrationState.Find(c)??throw new InvalidOperationException("未来观测尚未开始");
        if(state.Spawned.Add(key)){if(Targets.At(state.Players,state.Count++) is {} id)state.Owners[key]=id;}
        var p=spec.Copy();p["appearance_from"]=state.Owner(key)??Targets.At(state.Players,0);p["visible"]=true;p["targetable"]=false;p["boss"]=false;return p;
    }
    public override void Event(EncounterContext c,MechanicEvent e,ActorRef? actor)
    {
        var s=CalibrationState.Find(c);if(s?.Owner(e.Actor) is not {} player)return;
        if(e.Kind=="spawn"&&e.Data is Params p&&p.Number("base")==11350&&actor is {} id)c.D.Tether(player,id,98);
        else if(e.Kind=="despawn")c.D.Untether(player,98);
    }
}
