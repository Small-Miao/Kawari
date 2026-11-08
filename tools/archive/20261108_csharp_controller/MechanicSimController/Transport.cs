// 替换 MechanicSim 的客户端广播出口，仅接受可映射的原生操作。
using System.Numerics;
using System.Text.Json;
using MechanicSim_Server.Struct;
using Kawari.MechanicSim;

namespace Kawari.MechanicSim
{
    public sealed record ModelMapping(uint Base, uint Name, uint Hp, bool Boss = false, ushort? Model = null, byte Level = 100);
    public sealed class ControllerOptions
    {
        public string Definitions { get; set; } = "";
        public string Timeline { get; set; } = "";
        public Dictionary<uint, ModelMapping> Models { get; set; } = [];
        public Dictionary<ulong, ModelMapping> Actors { get; set; } = [];
        public float[] Origin { get; set; } = [0, 0, 0];
        public bool DummyTrigger { get; set; }
        // 0 表示仅 C# 使用的内部状态；不将自定义图标 ID 当作游戏 Status ID。
        public Dictionary<int, ushort> Statuses { get; set; } = [];
    }

    internal static class Transport
    {
        internal static ControllerOptions Options = new();
        private static readonly Dictionary<string, ActorRef> Objects = [];
        private static readonly Dictionary<(uint, int), (ushort Id, int Stack, int Duration)> Statuses = [];
        internal static uint PlayerId(string name) => Native.State.Actors.Single(a => a.Player && $"Actor-{a.Id}" == name).Id;
        private static ushort StatusId(int id) => Options.Statuses.TryGetValue(id, out var gameId)
            ? gameId : throw new InvalidOperationException($"自定义状态 {id} 缺少 Status 映射；内部状态须显式映射为 0。");
        private static ActorRef Ref(JsonElement p) => Native.Actor($"ms-{p.GetProperty("GameObjectId").GetUInt64()}");
        internal static Vector3 Origin => new(Options.Origin[0], Options.Origin[1], Options.Origin[2]);
        private static Location Pos(JsonElement p)
        {
            var v = p.GetProperty("Position");
            return Native.Position(new Vector3(v.GetProperty("X").GetSingle(), v.GetProperty("Y").GetSingle(), v.GetProperty("Z").GetSingle()) + Origin);
        }
        internal static void Send<T>(T payload, Player? player = null)
        {
            if (payload is null) throw new ArgumentNullException(nameof(payload));
            var p = JsonSerializer.SerializeToElement(payload, new JsonSerializerOptions { IncludeFields = true });
            var type = payload.GetType().Name;
            switch (type)
            {
                case "PlayBGM": Native.Bgm(p.GetProperty("BGMId").GetUInt32()); break;
                case "BattleNpcSpawn":
                    var model = p.GetProperty("ModuleId").GetUInt32();
                    if (!Options.Actors.TryGetValue(p.GetProperty("GameObjectId").GetUInt64(), out var spec) && !Options.Models.TryGetValue(model, out spec))
                        throw new InvalidOperationException($"模型 {model} 缺少 BNpcBase、名称、HP 映射。");
                    var actor = Ref(p);
                    Native.Call("spawn_actor", actor.Actor, new {
                        @base = spec.Base, name = spec.Name, hp = spec.Hp, boss = spec.Boss, level = spec.Level,
                        model = spec.Model ?? model, pos = Pos(p), rotation = p.GetProperty("Rotation").GetSingle(),
                        targetable = p.GetProperty("IsTargetable").GetBoolean(), visible = p.GetProperty("Visible").GetBoolean()
                    });
                    Native.Call("set_ai_enabled", actor, false);
                    Objects[actor.Actor] = actor;
                    break;
                case "BattleNpcDeSpawn":
                    actor = Ref(p);
                    Native.Call("despawn", actor);
                    Objects.Remove(actor.Actor);
                    break;
                case "BattleNpcMove": case "BattleNpcSetPos":
                    Native.Call(type == "BattleNpcMove" ? "slide_actor" : "move_actor", Ref(p), Pos(p), p.GetProperty("Rotation").GetSingle()); break;
                case "BattleNpcTargetableSet": Native.Call("set_targetable", Ref(p), p.GetProperty("IsTargetable").GetBoolean()); break;
                case "ObjectPlayTimeline": Native.Call("play_timeline", Ref(p), p.GetProperty("TimelineId").GetUInt32()); break;
                case "BNpcCast":
                    if (p.GetProperty("DisplayVfxAndTimeLine").GetBoolean())
                        Native.Cast(Ref(p), p.GetProperty("ActionId").GetUInt32(), p.GetProperty("Duration").GetSingle());
                    break;
                case "AddStatus":
                    var owner = PlayerId(p.GetProperty("TargetPlayerName").GetString()!);
                    var localId = p.GetProperty("StatusId").GetInt32();
                    var status = StatusId(localId);
                    var stack = p.GetProperty("Stack").GetInt32();
                    var duration = p.GetProperty("Duration").GetInt32();
                    Statuses[(owner, localId)] = (status, stack, duration);
                    if (status != 0) Native.Buff(owner, status, duration, checked((ushort)stack));
                    break;
                case "RemoveStatus":
                    owner = PlayerId(p.GetProperty("TargetPlayerName").GetString()!);
                    localId = p.GetProperty("StatusId").GetInt32();
                    status = StatusId(localId);
                    Statuses.Remove((owner, localId));
                    if (status != 0) Native.Call("remove_effect", owner, status);
                    break;
                case "UpdateStatusStack":
                    owner = PlayerId(p.GetProperty("TargetPlayerName").GetString()!);
                    localId = p.GetProperty("StatusId").GetInt32();
                    var previous = Statuses[(owner, localId)];
                    var remaining = Native.State.Statuses.FirstOrDefault(s => s.Actor == owner && s.Id == previous.Id)?.Duration;
                    if (previous.Id != 0 && remaining is not null)
                        Native.Buff(owner, previous.Id, remaining.Value, checked((ushort)p.GetProperty("Stack").GetInt32()));
                    break;
                case "ClearAllStatus":
                    // 只清理本控制器拥有的状态，不触碰玩家食物、职业等状态。
                    foreach (var pair in Statuses)
                        if (pair.Value.Id != 0) Native.Call("remove_effect", pair.Key.Item1, pair.Value.Id);
                    Statuses.Clear();
                    break;
                case "DespawnAllObject":
                    foreach (var obj in Objects.Values) Native.Call("despawn", obj);
                    Objects.Clear(); break;
                case "SendFlyText":
                    // 保留诊断，绝不将旧模拟器的飘字当作真实伤害。
                    Console.Error.WriteLine("SendDamageText 是表现接口；真实伤害请使用 Native.Damage/Circle。");
                    break;
                default:
                    throw new NotSupportedException($"{type} 尚未映射到原生副本接口，请改用 Native.Call 或补充映射。");
            }
        }
    }
}

namespace MechanicSim_Server.Manager
{
    public sealed class TCPServerManager
    {
        public static TCPServerManager serverInstance = new();
        public Task BroadcastPacketAsync<T>(T payload, CancellationToken cancellationToken = default)
        { Transport.Send(payload); return Task.CompletedTask; }
        public Task SendPacketToPlayerAsync<T>(Player player, T payload, CancellationToken cancellationToken = default)
        { Transport.Send(payload, player); return Task.CompletedTask; }
        public Task SendPacketToClientAsync<T>(int id, T payload, CancellationToken cancellationToken = default) =>
            SendPacketToPlayerAsync(RaidManager.Instance.Players.Single(p => p.ClientId == id), payload, cancellationToken);
    }
}
