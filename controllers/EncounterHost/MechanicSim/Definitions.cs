// 保持 MechanicSim 的命名空间、接口和时间轴书写形式。
namespace MechanicSim_Server.Definition
{
    public interface ITimeLineDefinition { string DefinitionId { get; } Struct.TimeLineDef Build(); }
    public interface IActionDefinition { static abstract int DefinitionId { get; } Struct.Action Build(); }
    public interface IStatusDefinition { static abstract int DefinitionId { get; } Struct.Status Build(); }
    public sealed class DefinitionRegistry
    {
        public Dictionary<int,Struct.Action> Actions { get; }=[];
        public Dictionary<int,Struct.Status> Statuses { get; }=[];
    }
}
namespace MechanicSim_Server.Struct
{
    public sealed class TimeLineDef
    {
        public string TimeLineName="",TimeLineDescription="",TimeLineAuthor="";
        public Dictionary<string,object> TimeLineVars=[];
        public Dictionary<string,object> TimeLineDefinition=[];
        public System.Action? OnTimeLineInit,OnTimeLineReset;
        public List<TimeLinePhase> TimeLinePhaseList=[];
        // 真实服务器的生命周期与技能模块由适配器接入，脚本节点仍使用原接口。
        public Kawari.Encounters.TimeLineDef? NativeEncounter;
    }
    public sealed class TimeLineNode
    {
        public string NodeName="";
        public TimeSpan Duration;
        public System.Action? OnTimeLineEvent;
        // 普通副本的门、钥匙等条件；时间轴仍然先等待 Duration。
        public System.Func<bool>? WaitUntil;
        public TimeSpan? Timeout;
    }
    public sealed class TimeLinePhase
    {
        public string PhaseName="";
        public List<TimeLineNode> TimeLineNodes=[];
    }
    public sealed class Action
    {
        public Guid Id=Guid.NewGuid();
        public string ActionName="";
        public int ActionId,GameActionId;
        public bool IsDisplayActionOnGame;
        public TimeSpan ActionCastTime;
        public System.Action<ActionCast,Manager.RaidManager>? OnActionCastBegin,OnActionCastExecute,OnActionCastEnd;
        public System.Action<ActionCast,Manager.RaidManager,ActionCancelReason>? OnActionCastCancel;
    }
    public enum ActionCastState { Casting,ReadyToExecute,Executed,Cancelled }
    public enum ActionCancelReason { Unknown,Interrupted,Replaced }
    public sealed class ActionCast
    {
        public Action ActionInfo { get; }
        public GameObject Caster { get; }
        public GameObject? TargetGameObject { get; }
        public Player? TargetPlayer { get; }
        public Manager.RaidManager RaidManager { get; }
        public DateTime CastStartAt { get; }
        public DateTime CastEndAt=>CastStartAt+ActionInfo.ActionCastTime;
        public ActionCastState State { get; private set; }=ActionCastState.Casting;
        internal ActionCast(Action action,GameObject caster,GameObject? target,Player? player,DateTime? castStartAt)
        {ActionInfo=action;Caster=caster;TargetGameObject=target;TargetPlayer=player;RaidManager=Manager.RaidManager.Instance;CastStartAt=castStartAt??RaidManager.ClockOrigin.AddSeconds(RaidManager.Context.EventTime);}
        internal void Finish()
        {
            if(State!=ActionCastState.Casting)return;State=ActionCastState.ReadyToExecute;
            ActionInfo.OnActionCastEnd?.Invoke(this,RaidManager);
            Caster.NotifyCastEnd(this);
        }
        public bool Execute()
        {
            if(State!=ActionCastState.ReadyToExecute)return false;State=ActionCastState.Executed;
            var d=RaidManager.Context.D;d.EndCast(Caster.Reference,(uint)ActionInfo.GameActionId);
            if(ActionInfo.IsDisplayActionOnGame)d.Emit("play_action_targeted",Caster.Reference,(uint)ActionInfo.GameActionId,TargetPlayer?.Reference??TargetGameObject?.Reference??Caster.Reference);
            ActionInfo.OnActionCastExecute?.Invoke(this,RaidManager);Caster.NotifyExecute(this);return true;
        }
        public bool Cancel(ActionCancelReason reason=ActionCancelReason.Unknown)
        {if(State is ActionCastState.Executed or ActionCastState.Cancelled)return false;State=ActionCastState.Cancelled;RaidManager.Context.D.CancelPending(Caster.Reference);RaidManager.Context.D.Emit("interrupt_cast",new Kawari.Encounters.Params{["target"]=Caster.Reference});ActionInfo.OnActionCastCancel?.Invoke(this,RaidManager,reason);Caster.NotifyCancel(this,reason);return true;}
    }
    public sealed class Status
    {
        public int StatusId;public string StatusName="",StatusDescription="";public uint GameIconId;
        public bool CanStack;public int CurrentStack,StackStep;public TimeSpan Duration;
        public ushort NativeStatusId;
        public System.Action<ActiveStatus,Player>? OnStatusAdd,OnStatusTick;
        public System.Action<ActiveStatus,Player,Enum.StatusRemoveReason>? OnStatusRemove;
    }
    public sealed class ActiveStatus(Status status,Player owner)
    {
        public Status StatusInfo { get; }=status;
        public Player Owner { get; }=owner;
        public int CurrentStack=status.CurrentStack;
        public int Stack=>CurrentStack;
        public TimeSpan Duration=status.Duration;
        internal double AppliedAt=Manager.RaidManager.Instance.Context.Time;
        public void AddStack(int amount){if(StatusInfo.CanStack)CurrentStack=Math.Max(1,CurrentStack+amount);}
        public int RemoveStack(int amount=1){if(StatusInfo.CanStack)CurrentStack=Math.Max(0,CurrentStack-Math.Max(1,amount));return CurrentStack;}
        public void Remove(Enum.StatusRemoveReason reason)=>Owner.RemoveActiveStatus(this,reason);
        public void Expired()=>Remove(Enum.StatusRemoveReason.Expired);
        internal bool Seen;
    }
}
namespace MechanicSim_Server.Enum
{
    public enum RoleEnum { TANK,HEALER,DPS_MELEE,DPS_RANGE }
    public enum StatusRemoveReason { ServerRemove=0,Removed=0,Unknown=0,Expired=1,Death=2 }
}
