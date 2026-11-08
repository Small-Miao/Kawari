// 命令批次只调用允许的服务器原生接口；查询读取本帧快照及本帧预测状态。
namespace Kawari.Encounters;

public sealed class NativeDirector
{
    private readonly Dictionary<string, Params> pendingActors = [];
    private readonly Dictionary<ActorRef, (Position Pos, double Rotation)> poses = [];
    private readonly HashSet<string> removed = [];
    public InputFrame Frame { get; private set; } = new(1,0,0,false,[],[],[],[]);
    public List<Operation> Commands { get; } = [];
    public void Read(InputFrame frame) { Frame=frame; Commands.Clear(); poses.Clear(); foreach(var key in frame.bindings.Keys) pendingActors.Remove(key); }
    public void Emit(string method, params object?[] args) => Commands.Add(new(method,args));
    public ActorRef? Find(string? key) => key is not null && !removed.Contains(key) && (pendingActors.ContainsKey(key)||Frame.bindings.ContainsKey(key)) ? new ActorRef(0,key) : (ActorRef?)null;
    public uint Resolve(ActorRef actor) => actor.Key is null ? actor.Id : Frame.bindings.GetValueOrDefault(actor.Key);
    public ActorSnapshot? Snapshot(ActorRef actor) => Frame.actors.FirstOrDefault(a=>a.id==Resolve(actor));
    public Position Position(ActorRef actor) => poses.TryGetValue(actor,out var pose) ? pose.Pos : Snapshot(actor)?.Position ?? (actor.Key is not null ? pendingActors.GetValueOrDefault(actor.Key)?.Pos : null) ?? Kawari.Encounters.Position.Center;
    public double Rotation(ActorRef actor) => poses.TryGetValue(actor,out var pose) ? pose.Rotation : Snapshot(actor)?.rotation ?? (actor.Key is not null ? pendingActors.GetValueOrDefault(actor.Key)?.Rotation : null) ?? 0;
    public bool Alive(ActorRef actor) => Snapshot(actor)?.hp > 0 || (actor.Key is not null && pendingActors.ContainsKey(actor.Key) && !removed.Contains(actor.Key));
    public byte Job(ActorRef actor) => Snapshot(actor)?.job ?? 0;
    public uint Hp(ActorRef actor) => Snapshot(actor)?.hp ?? 0;
    public uint MaxHp(ActorRef actor) => Snapshot(actor)?.maxHp ?? 0;
    public ActorRef[] Players() => Frame.actors.Where(a=>a.player&&a.hp>0).OrderBy(a=>a.id).Select(a=>(ActorRef)a.id).ToArray();
    public ActorRef[] Enmity(ActorRef actor) => (Snapshot(actor)?.enmity ?? []).Where(id=>Alive(id)).Select(id=>(ActorRef)id).ToArray();
    public StatusSnapshot? Status(ActorRef actor, ushort id) => Frame.statuses.FirstOrDefault(s=>s.actor==Resolve(actor)&&s.id==id);
    public ActorRef Spawn(string key, Params spec)
    {
        var wire=spec.Copy(); wire.Remove("owner");
        Emit("spawn_actor",key,wire); pendingActors[key]=spec.Copy(); removed.Remove(key);
        var actor=new ActorRef(0,key); poses[actor]=(spec.Pos,spec.Rotation); return actor;
    }
    public void Despawn(string key) { if(Find(key) is {} actor) Emit("despawn_registered",key); removed.Add(key); pendingActors.Remove(key); }
    public ActorRef SpawnEObj(string key, Params spec) { Emit("spawn_event_object",key,spec); pendingActors[key]=spec.Copy(); removed.Remove(key); return key; }
    public void Move(ActorRef actor, Position pos, double rotation, bool slide=false)
    { Emit(slide?"slide_actor":"move_actor",actor,pos,rotation); poses[actor]=(pos,rotation); }
    public void BeginCast(ActorRef actor,uint action,double seconds,ActorRef? target=null,double omenDelay=0,Position? castPos=null,ushort? spell=null)
        => Emit("begin_cast",actor,action,seconds,target,omenDelay,castPos,spell);
    public void EndCast(ActorRef actor,uint action) => Emit("end_cast",actor,action);
    public void Gain(ActorRef actor,ushort status,ushort param,double duration,ActorRef? source=null) => Emit("gain_effect",actor,status,param,duration,source);
    public void Remove(ActorRef actor,ushort status) => Emit("remove_effect",actor,status);
    public void Target(ActorRef actor,ActorRef target) => Emit("set_target",actor,target);
    public void Targetable(ActorRef actor,bool value) => Emit("set_targetable",actor,value);
    public void Visible(ActorRef actor,bool value,double fade=0) => Emit("set_visible",actor,value,fade);
    public void Owner(ActorRef actor,ActorRef? owner) => Emit("set_actor_owner",actor,owner);
    public void Model(ActorRef actor,int state) => Emit("set_model_state",actor,state);
    public void Animation(ActorRef actor,int a,int b) => Emit("set_animation_state",actor,a,b);
    public void PlayTimeline(ActorRef actor,uint id) => Emit("play_timeline",actor,id);
    public void PlayAction(ActorRef actor,uint action) => Emit("play_action",actor,action);
    public void Ai(ActorRef actor,bool enabled) => Emit("set_ai_enabled",actor,enabled);
    public void Tether(ActorRef from,ActorRef to,uint id,int slot=0) => Emit("tether",from,to,id,slot);
    public void Untether(ActorRef from,uint id,int slot=0) => Emit("tether_cancel",from,id,slot);
    public void Icon(ActorRef actor,uint id) => Emit("set_target_icon",actor,id);
    public void Circle(Params p) => Emit("aoe_circle",p);
    public void Donut(Params p) => Emit("aoe_donut",p);
    public void Rect(Params p) => Emit("aoe_rect",p);
    public void Cone(Params p) => Emit("aoe_cone",p);
    public void Raid(Params p) => Emit("raidwide",p);
    public void DirectorEvent(uint id, params uint[] args) => Emit("director_event",id,args);
    public void SetBgm(uint id) => Emit("set_bgm",id);
    public void Weather(byte id,double fade=0) => Emit("set_weather",id,fade);
    public void MapEffect(byte index,ushort state,ushort timeline) => Emit("map_effect",index,timeline,state);
    public void SetupMapEffects(ushort[] values,ushort flag) => Emit("setup_map_effects",values,flag);
    public void ObjectAnimation(ActorRef actor,uint state,uint timeline) => Emit("object_animation",actor,state,timeline);
    public void LimitBreak(uint amount) => Emit("set_limit_break",amount);
    public void Flag(byte flag) => Emit("set_director_flag",flag);
    public void ResetOnDeaggro(bool value) => Emit("set_reset_on_deaggro",value);
    public void ArmTrigger(ActorRef actor) => Emit("arm_hit_trigger",actor);
    public void CancelPending(ActorRef? actor=null) => Emit("cancel_pending",actor);
    public void Complete() => Emit("complete_duty");
    public void Stop(string reason) => Emit("stop_encounter",reason);
    public void ClearLocal() { pendingActors.Clear(); poses.Clear(); removed.Clear(); }
}
