// C# 机制通过此接口提交原生副本操作；实体 ID 由世界服分配。
using System.Numerics;
using System.Text.Json;

namespace Kawari.MechanicSim;

public sealed record ActorRef(string Actor);
public sealed record Location(float X, float Y, float Z);
public sealed record Command(string Method, object?[] Args);
public sealed record ActorState(uint Id, bool Player, uint Hp, uint MaxHp, byte Job,
    float[] Pos, float Rotation, uint Target, uint[] Enmity);
public sealed record StatusState(uint Actor, ushort Id, ushort Param, float Duration, uint Source);
public sealed record Frame(int Version, ulong Seq, double Time, bool Battle,
    ActorState[] Actors, Dictionary<string, uint> Bindings, StatusState[] Statuses, JsonElement[] Events);

public static class Native
{
    private static readonly List<Command> Pending = [];
    private static int _thread;
    public static Frame State { get; private set; } = null!;
    public static event System.Action<uint>? ActorDied;
    public static event System.Action<StatusState>? StatusGained;
    public static event System.Action<StatusState>? StatusLost;

    internal static void Update(Frame frame)
    {
        _thread = Environment.CurrentManagedThreadId;
        State = frame;
        // 使用世界服实际死亡与 Buff 变更事件，避免通过采样 HP 或本地倒计时猜测。
        foreach (var item in frame.Events)
        {
            var kind = item.GetProperty("kind").GetString();
            var actor = item.GetProperty("actor").GetUInt32();
            if (kind == "death") ActorDied?.Invoke(actor);
            else
            {
                var status = new StatusState(actor, item.GetProperty("id").GetUInt16(),
                    item.GetProperty("param").GetUInt16(), item.GetProperty("duration").GetSingle(),
                    item.GetProperty("source").GetUInt32());
                if (kind == "status_gain") StatusGained?.Invoke(status);
                else if (kind == "status_lose") StatusLost?.Invoke(status);
            }
        }
    }

    public static ActorRef Actor(string alias) => new(alias);
    public static Location Position(Vector3 value) => new(value.X, value.Y, value.Z);
    public static void Call(string method, params object?[] args)
    {
        if (_thread != Environment.CurrentManagedThreadId)
            throw new InvalidOperationException("原生操作只能在控制器回调线程提交，延时请使用时间轴节点。");
        if (Pending.Count >= 512) throw new InvalidOperationException("单帧原生指令超过 512 条。");
        Pending.Add(new(method, args));
    }
    internal static Command[] Drain() { var result = Pending.ToArray(); Pending.Clear(); return result; }
    public static void Spawn(string alias, uint baseId, uint nameId, uint hp, Vector3 position,
        bool boss = false, ushort? model = null, bool targetable = true, byte level = 100) =>
        Call("spawn_actor", alias, new { @base = baseId, name = nameId, hp, pos = Position(position), boss, model, targetable, level });
    public static void MapEffect(byte index, ushort state, ushort timeline) => Call("map_effect", index, timeline, state);
    public static void Bgm(uint id) => Call("set_bgm", id);
    public static void Cast(object actor, uint action, float seconds, object? target = null) => Call("cast", actor, action, seconds, target);
    public static void BeginCast(object actor, uint action, float seconds, Vector3 position) =>
        Call("begin_cast", actor, action, seconds, actor, 0, Position(position));
    public static void EndCast(object actor, uint action) => Call("end_cast", actor, action);
    public static void TargetedAction(object actor, uint action, object target) =>
        Call("play_action_targeted", actor, action, target);
    public static void Buff(uint player, ushort status, float seconds, ushort stacks = 0, object? source = null) =>
        Call("gain_effect", player, status, stacks, seconds, source);
    public static void Damage(object source, uint action, uint amount, params uint[] targets) =>
        Call("raidwide", new { source, action, damage = amount, delay = 0, targets });
    public static void Circle(object source, uint action, uint amount, Vector3 position, float radius, float delay = 0) =>
        Call("aoe_circle", new { source, action, damage = amount, pos = Position(position), radius, delay });
    public static void Reset() => Call("reset_encounter");
    public static void Complete() => Call("complete_duty");
}
