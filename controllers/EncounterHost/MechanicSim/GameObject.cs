// 原 GameObject 的原生后端，包括同名构造、TryCast、运动、显隐和销毁。
using System.Numerics;
using Kawari.Encounters;
using MechanicSim_Server.Manager;
namespace MechanicSim_Server.Struct;
public sealed class GameObject
{
    private readonly RaidManager raid;
    public string Key { get; }
    public ActorRef Reference=>raid.Context.D.Find(Key)??throw new InvalidOperationException($"演员已移除 {Key}");
    public string GameObjectName="";public string[] Tag=[];public ulong ServerGameObjectId;
    public bool IsTargetable,Visible;public Vector3 Scale=Vector3.One;public float Rotation,MoveSpeed,HitboxRadius;public int ModuleId;
    public bool Move;public GameObject? TargetGameObject;public Player? TargetPlayer;
    public Vector3 Position;
    public ActionCast? CurrentCast { get; private set; }
    public ActionCast? LastCast { get; private set; }
    public event System.Action<ActionCast,RaidManager>? OnActionCastStart,OnActionCastEnd,OnActionExecute;
    public event System.Action<ActionCast,RaidManager,ActionCancelReason>? OnActionCancel;
    internal void NotifyCastEnd(ActionCast cast)=>OnActionCastEnd?.Invoke(cast,raid);
    internal void NotifyExecute(ActionCast cast)=>OnActionExecute?.Invoke(cast,raid);
    internal void NotifyCancel(ActionCast cast,ActionCancelReason reason)=>OnActionCancel?.Invoke(cast,raid,reason);
    private GameObject(RaidManager manager,string key){raid=manager;Key=key;raid.GameObjects.Add(this);Refresh();}
    public GameObject(string GameObjectName,ulong ServerGameObjectId,bool IsTargetable,bool Visible,Vector3 Position,float Rotation,float MoveSpeed,Vector3 Scale,float HitboxRadius,int moduleId)
    {
        raid=RaidManager.Instance;Key=$"ms:{ServerGameObjectId}";this.GameObjectName=GameObjectName;this.ServerGameObjectId=ServerGameObjectId;this.IsTargetable=IsTargetable;this.Visible=Visible;this.Position=Position;this.Rotation=Rotation;this.MoveSpeed=MoveSpeed;this.Scale=Scale;this.HitboxRadius=HitboxRadius;ModuleId=moduleId;
        raid.Context.D.Spawn(Key,new(){["base"]=9020,["name"]=0,["model"]=moduleId,["hp"]=10000000,["level"]=100,["pos"]=ToPosition(Position),["rotation"]=Rotation,["targetable"]=IsTargetable,["visible"]=Visible});raid.GameObjects.Add(this);
    }
    internal static GameObject Wrap(RaidManager manager,string key)=>new(manager,key);
    internal static Kawari.Encounters.Position ToPosition(Vector3 p)=>new(p.X,p.Y,p.Z);
    internal void Refresh(){if(raid.Context.D.Find(Key) is {} actor){var p=raid.Context.D.Position(actor);Position=new((float)p.x,(float)p.y,(float)p.z);Rotation=(float)raid.Context.D.Rotation(actor);}}
    public void Destory(){CurrentCast?.Cancel();raid.Context.Actors.Despawn(Key);raid.GameObjects.Remove(this);}
    public void Targetable(bool enabled){IsTargetable=enabled;raid.Context.D.Targetable(Reference,enabled);}
    public void SetVisible(bool value,double fade=0){Visible=value;raid.Context.D.Visible(Reference,value,fade);}
    public void BrocastMove()=>raid.Context.D.Move(Reference,ToPosition(Position),Rotation,true);
    public void MoveTo(Vector3 destination,float speed=6)=>raid.Context.Motion.MoveTo(Reference,ToPosition(destination),speed);
    public void FaceEnmity()=>raid.Context.Motion.FaceEnmity(Reference);
    public void Follow(Player player,float speed=6,float distance=3)=>raid.Context.Motion.Follow(Reference,player.Reference,speed,distance);
    public void StopMovement()=>raid.Context.Motion.Stop(Reference);
    public void SetPosition(Kawari.Encounters.Position p,double rotation)=>raid.Context.Actors.Move(Key,p,rotation);
    public void SetOwner(string? key)=>raid.Context.Actors.Owner(Key,key);
    public void SetTarget(string? key)=>raid.Context.Actors.Target(Key,key);
    public void SetAnimationState(int index,int state)=>raid.Context.Actors.Animation(Key,index,state);
    public void SetModelState(int state)=>raid.Context.Actors.Model(Key,state);
    public void PlayTimeline(uint id)=>raid.Context.Actors.Timeline(Key,id);
    public void Hide()=>raid.Context.Actors.Hide(Key);
    public void SetPresentation(uint operation,uint parameter,uint duration)=>raid.Context.Actors.Presentation(Key,operation,parameter,duration);
    public void Tether(string? target,uint id,int slot)=>raid.Context.Actors.Tether(Key,target,id,slot);
    public void Untether(uint id,int slot)=>raid.Context.Actors.Untether(Key,id,slot);
    public void ApplyStatuses(StatusSpec[] statuses)=>raid.Context.Actors.Status(Key,statuses);
    public void SetEncounterTargetable(bool value)=>raid.Context.Actors.Targetable(Key,value);
    public void TryCast(uint action,TimeSpan duration,Params options)=>raid.Context.Actors.Cast(Key,action,duration.TotalSeconds,options);
    public void ExecuteAction(uint action,Params options)=>raid.Context.Actors.Action(Key,action,options);
    public bool TryCast(int actionId,GameObject? targetGameObject=null,Player? targetPlayer=null,DateTime? castStartAt=null,bool replaceExisting=true)
    {
        if(!raid.DefinitionRegistry.Actions.TryGetValue(actionId,out var action))return false;
        if(action.ActionCastTime<TimeSpan.Zero||action.ActionCastTime>TimeSpan.FromDays(7)||action.GameActionId<0)throw new InvalidDataException("技能读条或原生 ID 无效");
        if(CurrentCast is {State:ActionCastState.Casting or ActionCastState.ReadyToExecute} old){if(!replaceExisting)return false;old.Cancel(ActionCancelReason.Replaced);}
        var cast=new ActionCast(action,this,targetGameObject,targetPlayer,castStartAt);CurrentCast=LastCast=cast;
        var target=targetPlayer?.Reference??targetGameObject?.Reference??Reference;
        if(action.IsDisplayActionOnGame)raid.Context.D.BeginCast(Reference,(uint)action.GameActionId,Math.Max(0,(cast.CastEndAt-raid.Now).TotalSeconds),target);
        action.OnActionCastBegin?.Invoke(cast,raid);
        OnActionCastStart?.Invoke(cast,raid);
        raid.Context.Schedule(Math.Max(0,(cast.CastEndAt-raid.ClockOrigin).TotalSeconds-raid.Context.EventTime),_=>cast.Finish());return true;
    }
    public bool TryStartCast(int actionId,GameObject? targetGameObject=null,Player? targetPlayer=null,DateTime? castStartAt=null,bool replaceExisting=true)
        =>TryCast(actionId,targetGameObject,targetPlayer,castStartAt,replaceExisting);
    public bool CancelCurrentCast(ActionCancelReason reason=ActionCancelReason.Interrupted)
    {if(CurrentCast is not {} cast||!cast.Cancel(reason))return false;LastCast=cast;CurrentCast=null;return true;}
}
