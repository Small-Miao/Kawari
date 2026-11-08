using Kawari.Encounters;
// 牢狱依次检查占塔，末轮由服务器时钟负责狂暴。
using S=Script.Definitions.Statuses.TEA;
using Scene=Script.Definitions.d2az.SceneHooks;
namespace Script.Definitions.Actions.TEA;
public partial class TemporalPrison
{
    private readonly Dictionary<ActorRef,Position> prisoned=[];
    public override bool Resolve(EncounterContext c,MechanicEvent e,Params p){if(e.Action==18582)Scene.PrisonPrepare(c);return false;}
    public override Params? Prepare(EncounterContext c,MechanicEvent e)
    {
        if(e.Action!=18583)return null;c.EnrageAt=null;
        for(var i=0;i<7;i++)
        {
            var index=i;var r=-Math.PI-(i+1)*Math.PI/4;var pos=new Position(100+12*Math.Sin(r),0,100+12*Math.Cos(r));
            c.Schedule(1.866+i*5,x=>Scene.PrisonWarning(x,index));
            c.Schedule(9.866+i*5,x=>{
                Scene.PrisonClose(x,index);var occupants=Targets.Players(x,pos,id=>!prisoned.ContainsKey(id)&&x.D.Position(id).DistanceSquared(pos)<=16);
                if(occupants.Length!=1){Targets.Fail(x,Targets.Players(x));return;}
                var id=occupants[0];prisoned[id]=x.D.Position(id);x.D.Gain(id,S.Prison,0,0,x.Boss);x.D.Emit("interrupt_cast",new Params{["target"]=id});
            });
        }
        c.Schedule(42,x=>{Scene.PrisonClose(x,7);foreach(var id in Targets.Players(x)){prisoned[id]=x.D.Position(id);x.D.Gain(id,S.Prison,0,0,x.Boss);}Targets.Fail(x,Targets.Players(x),18583);});
        return null;
    }
    public override void Tick(EncounterContext c){foreach(var (id,pos) in prisoned)if(c.D.Alive(id)&&c.D.Position(id).DistanceSquared(pos)>0.001)c.D.Move(id,pos,c.D.Rotation(id));}
}
