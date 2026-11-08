// 原生副本脚本的值类型、快照和参数；不依赖客户端模拟器或 Lua。
using System.Text.Json;
using System.Text.Json.Serialization;

namespace Kawari.Encounters;

public sealed record Position(double x, double y, double z)
{
    public static readonly Position Center = new(100, 0, 100);
    public static readonly Position Zero = new(0, 0, 0);
    public double DistanceSquared(Position p) => (x-p.x)*(x-p.x)+(z-p.z)*(z-p.z);
    public double AngleTo(Position p) => Math.Atan2(p.x-x, p.z-z);
}

[JsonConverter(typeof(ActorRefConverter))]
public readonly record struct ActorRef(uint Id, string? Key = null)
{
    public static implicit operator ActorRef(uint id) => new(id);
    public static implicit operator ActorRef(string key) => new(0, key);
    public override string ToString() => Key ?? Id.ToString();
}
public sealed class ActorRefConverter : JsonConverter<ActorRef>
{
    public override ActorRef Read(ref Utf8JsonReader reader, Type type, JsonSerializerOptions options) => new(reader.GetUInt32());
    public override void Write(Utf8JsonWriter writer, ActorRef value, JsonSerializerOptions options)
    {
        if (value.Key is null) writer.WriteNumberValue(value.Id);
        else { writer.WriteStartObject(); writer.WriteString("actor", value.Key); writer.WriteEndObject(); }
    }
}

public sealed class Params : Dictionary<string, object?>
{
    public Params() : base(StringComparer.Ordinal) { }
    public Params(IEnumerable<KeyValuePair<string, object?>> values) : base(values, StringComparer.Ordinal) { }
    public Params Copy() => new(this);
    public T? Get<T>(string key) => TryGetValue(key, out var value) && value is T result ? result : default;
    public double Number(string key, double fallback=0) => TryGetValue(key, out var value) && value is not null ? Convert.ToDouble(value) : fallback;
    public bool Flag(string key) => Get<bool>(key);
    public string Kind { get => Get<string>("kind") ?? "visual"; set => this["kind"] = value; }
    public Position Pos { get => Get<Position>("pos") ?? Position.Center; set => this["pos"] = value; }
    public double Rotation { get => Number("rotation"); set => this["rotation"] = value; }
    public ActorRef? Target { get => Get<ActorRef?>("target"); set => this["target"] = value; }
}

public sealed record Operation(string method, object?[] args);
public sealed record StatusSpec(ushort id, ushort param, double duration);
public sealed record ActorSnapshot(uint id, bool player, uint hp, uint maxHp, byte job, double[] pos, double rotation, uint target, uint[] enmity, ulong actionCount=0)
{
    [JsonIgnore] public Position Position => new(pos[0], pos[1], pos[2]);
}
public sealed record StatusSnapshot(uint actor, ushort id, ushort param, double duration, uint source);
public sealed record InputFrame(int version, ulong seq, double time, bool battle,
    ActorSnapshot[] actors, Dictionary<string, uint> bindings, StatusSnapshot[] statuses, JsonElement[] events);
public sealed record OutputFrame(int version, ulong seq, IReadOnlyList<Operation> commands, object state);

public sealed class ActorCatalog
{
    public required string Boss { get; init; }
    public uint BossBase { get; init; }
    public byte DirectorFlag { get; init; }
    public string[] Initial { get; init; } = [];
    public Dictionary<string, Params> Templates { get; init; } = [];
    public Dictionary<string, Params> DeathEffects { get; init; } = [];
}
