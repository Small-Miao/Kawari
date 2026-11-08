// 服务器快照驱动持续运动、仇恨朝向、施法锁定和瞬移；实例取消立即清空计划。
namespace Kawari.Encounters;
public sealed class ActorMotion(EncounterContext context)
{
    private sealed record Plan(Position? Destination,ActorRef? Target,double Speed,double Distance,bool Face,bool Enmity);
    private readonly Dictionary<ActorRef,Plan> plans=[];
    private readonly Dictionary<ActorRef,double> locks=[];
    private void Set(ActorRef actor,Plan plan)
    {
        if(!double.IsFinite(plan.Speed)||plan.Speed<0||!double.IsFinite(plan.Distance)||plan.Distance<0) throw new ArgumentException("无效运动参数");
        if(plan.Destination is {} p && !(double.IsFinite(p.x)&&double.IsFinite(p.y)&&double.IsFinite(p.z))) throw new ArgumentException("无效坐标");
        plans[actor]=plan; context.D.Ai(actor,false);
    }
    public void MoveTo(ActorRef actor,Position destination,double speed=6) => Set(actor,new(destination,null,speed,0,false,false));
    public void Follow(ActorRef actor,ActorRef target,double speed=6,double distance=3) => Set(actor,new(null,target,speed,distance,false,false));
    public void FaceTarget(ActorRef actor,ActorRef target) => Set(actor,new(null,target,0,0,true,false));
    public void FaceEnmity(ActorRef actor) => Set(actor,new(null,null,0,0,true,true));
    public void FaceAggro(ActorRef actor) => FaceEnmity(actor);
    public void LockFacing(ActorRef actor,double until) { if(!double.IsFinite(until)) throw new ArgumentException("无效锁定时间"); locks[actor]=until; }
    public void Stop(ActorRef actor,bool resumeAi=false) { plans.Remove(actor); locks.Remove(actor); context.D.Ai(actor,resumeAi); }
    public void Teleport(ActorRef actor,Position pos,double rotation) { Stop(actor); context.D.Move(actor,pos,rotation); }
    public void Clear() { plans.Clear(); locks.Clear(); }
    public void Update(double dt,double now)
    {
        var d=context.D;
        foreach(var (actor,plan) in plans.ToArray())
        {
            if(!d.Alive(actor)) { plans.Remove(actor); locks.Remove(actor); continue; }
            if(now<locks.GetValueOrDefault(actor)) continue;
            ActorRef? target=plan.Enmity?d.Enmity(actor).Cast<ActorRef?>().FirstOrDefault():plan.Target;
            if(target is {} t&&!d.Alive(t)) { if(!plan.Enmity) plans.Remove(actor); target=null; }
            var to=plan.Destination ?? (target is {} a?d.Position(a):null);
            if(to is null) continue;
            var from=d.Position(actor);var length=Math.Sqrt(from.DistanceSquared(to));
            if(length>0.001)
            {
                var facing=from.AngleTo(to);var step=plan.Face?0:Math.Min(Math.Max(0,length-plan.Distance),plan.Speed*Math.Min(dt,0.5));
                var delta=facing-d.Rotation(actor);
                if(step>0||Math.Abs(Math.Atan2(Math.Sin(delta),Math.Cos(delta)))>0.001)
                    d.Move(actor,new(from.x+(to.x-from.x)/length*step,from.y,from.z+(to.z-from.z)/length*step),facing,true);
                if(plan.Destination is not null&&length-step<0.001) plans.Remove(actor);
            }
            else if(plan.Destination is not null) plans.Remove(actor);
            if(target is {} id) d.Target(actor,id);
        }
    }
}
