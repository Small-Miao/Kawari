// 玩家对象读取原生快照；状态定义需显式映射原生状态 ID。
using System.Numerics;
using Kawari.Encounters;
using MechanicSim_Server.Manager;
using MechanicSim_Server.Enum;
namespace MechanicSim_Server.Struct;
public sealed class Player
{
    private readonly RaidManager raid;
    public ActorRef Reference { get; }
    public int ClientId=>(int)Reference.Id;
    public ulong SessionHandle=>Reference.Id;
    public string PlayerName=>$"Player-{Reference.Id}";
    public string ClassJob=>raid.Context.D.Job(Reference).ToString();
    public RoleEnum Role=>Targets.Tank(raid.Context.D,Reference)?RoleEnum.TANK:Targets.Healer(raid.Context.D,Reference)?RoleEnum.HEALER:raid.Context.D.Job(Reference) is 2 or 4 or 20 or 22 or 29 or 30 or 34 or 39 or 41?RoleEnum.DPS_MELEE:RoleEnum.DPS_RANGE;
    public Vector3 Position { get {var p=raid.Context.D.Position(Reference);return new((float)p.x,(float)p.y,(float)p.z);} }
    public float Faceing=>(float)raid.Context.D.Rotation(Reference);
    public bool IsDead=>!raid.Context.D.Alive(Reference);
    public Dictionary<string,object> PlayerVar { get; }=[];
    public List<ActiveStatus> StatusList { get; }=[];
    internal Player(RaidManager raid,uint id){this.raid=raid;Reference=id;}
    internal void Update()
    {
        foreach(var active in StatusList.ToArray())
        {
            var status=raid.Context.D.Status(Reference,active.StatusInfo.NativeStatusId);
            if(status is not null){active.Seen=true;active.CurrentStack=status.param;active.StatusInfo.OnStatusTick?.Invoke(active,this);}
            else if(active.Seen||IsDead){StatusList.Remove(active);active.StatusInfo.OnStatusRemove?.Invoke(active,this,IsDead?StatusRemoveReason.Death:StatusRemoveReason.Expired);}
        }
    }
    public ActiveStatus? AddStatus(int statusId,DateTime? applyAt=null)=>raid.DefinitionRegistry.Statuses.TryGetValue(statusId,out var s)?AddStatus(s):null;
    public ActiveStatus? AddStatus(int statusId,TimeSpan duration,DateTime? applyAt=null)=>raid.DefinitionRegistry.Statuses.TryGetValue(statusId,out var s)?AddStatus(s,duration):null;
    public ActiveStatus AddStatus(Status status,DateTime? applyAt=null)=>AddStatus(status,status.Duration);
    public ActiveStatus AddStatus(Status status,TimeSpan duration,DateTime? applyAt=null)
    {
        if(status.NativeStatusId==0)throw new InvalidDataException($"状态 {status.StatusId} 需要设置 NativeStatusId，图标 ID 不能作为服务器状态 ID");
        var active=StatusList.FirstOrDefault(s=>s.StatusInfo.StatusId==status.StatusId);
        if(active is null){active=new(status,this);StatusList.Add(active);}else if(status.CanStack)active.CurrentStack+=Math.Max(1,status.StackStep);
        active.Duration=duration;
        active.AppliedAt=raid.Context.Time;
        raid.Context.D.Gain(Reference,status.NativeStatusId,(ushort)active.CurrentStack,duration==TimeSpan.MaxValue?0:duration.TotalSeconds);
        status.OnStatusAdd?.Invoke(active,this);return active;
    }
    public bool RemoveStatus(int statusId)
    {var active=StatusList.FirstOrDefault(s=>s.StatusInfo.StatusId==statusId);if(active is null)return false;RemoveActiveStatus(active,StatusRemoveReason.ServerRemove);return true;}
    public bool RemoveStatus(Status status)=>RemoveStatus(status.StatusId);
    internal void RemoveActiveStatus(ActiveStatus active,StatusRemoveReason reason)
    {if(!StatusList.Remove(active))return;raid.Context.D.Remove(Reference,active.StatusInfo.NativeStatusId);active.StatusInfo.OnStatusRemove?.Invoke(active,this,reason);}
    public bool ReduceStatusStack(int statusId,int amount=1)
    {
        var active=StatusList.FirstOrDefault(s=>s.StatusInfo.StatusId==statusId);if(active is null)return false;
        if(!active.StatusInfo.CanStack||active.RemoveStack(amount)<=0)return RemoveStatus(statusId);
        BroadcastUpdateStatusStack(active);return true;
    }
    public void BroadcastUpdateStatusStack(ActiveStatus active)
    {
        var permanent=active.Duration==TimeSpan.MaxValue||active.Duration<=TimeSpan.Zero;
        var remaining=permanent?0:Math.Max(0,active.Duration.TotalSeconds-(raid.Context.Time-active.AppliedAt));
        if(!permanent&&remaining<=0){RemoveActiveStatus(active,StatusRemoveReason.Expired);return;}
        raid.Context.D.Gain(Reference,active.StatusInfo.NativeStatusId,checked((ushort)active.Stack),remaining);
    }
    public bool HasStatus(int statusId)=>StatusList.Any(s=>s.StatusInfo.StatusId==statusId);
    public void ClearStatus(){foreach(var s in StatusList.ToArray())RemoveStatus(s.StatusInfo.StatusId);}
    public void KnockbackFrom(ulong gameObjectId,float distance)
    {var source=raid.GetObjectByGameObjectId(gameObjectId)??throw new InvalidOperationException("击退来源不存在");raid.Context.D.Emit("knockback",new Params{["source"]=source.Reference,["target"]=Reference,["distance"]=distance});}
}
