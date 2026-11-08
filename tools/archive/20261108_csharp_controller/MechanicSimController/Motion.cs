// C# 控制 Boss 站位、追踪和朝向，服务器负责权威坐标与移动包。
using System.Numerics;

namespace Kawari.MechanicSim;

public static class Motion
{
    private sealed record Plan(Vector3? Destination, uint? Target, float Speed, float StopDistance, bool FaceOnly, bool Aggro = false);
    private static readonly Dictionary<string, Plan> Plans = [];

    public static void Teleport(string actor, Vector3 position, float rotation)
    {
        Plans.Remove(actor);
        Native.Call("set_ai_enabled", Native.Actor(actor), false);
        Native.Call("move_actor", Native.Actor(actor), Native.Position(position), rotation);
    }
    public static void MoveTo(string actor, Vector3 destination, float speed = 6) =>
        Set(actor, new(destination, null, speed, 0, false));
    public static void Follow(string actor, uint target, float speed = 6, float stopDistance = 3) =>
        Set(actor, new(null, target, speed, stopDistance, false));
    public static void FaceTarget(string actor, uint target) => Set(actor, new(null, target, 0, 0, true));
    public static void FaceAggro(string actor)
    {
        Set(actor, new(null, null, 0, 0, true, true));
    }
    public static void Stop(string actor, bool resumeAi = false)
    {
        Plans.Remove(actor);
        Native.Call("set_ai_enabled", Native.Actor(actor), resumeAi);
    }
    private static void Set(string actor, Plan plan)
    {
        if (!float.IsFinite(plan.Speed) || plan.Speed < 0 || !float.IsFinite(plan.StopDistance) || plan.StopDistance < 0)
            throw new ArgumentOutOfRangeException(nameof(plan));
        Plans[actor] = plan;
        Native.Call("set_ai_enabled", Native.Actor(actor), false);
    }
    private static ActorState? Find(string alias) => Native.State.Bindings.TryGetValue(alias, out var id)
        ? Native.State.Actors.FirstOrDefault(a => a.Id == id) : null;
    internal static void Tick(double delta)
    {
        foreach (var (alias, plan) in Plans.ToArray())
        {
            var actor = Find(alias);
            if (actor is null) continue;
            if (actor.Hp == 0) { Plans.Remove(alias); continue; }
            var targetId = plan.Aggro ? actor.Enmity.FirstOrDefault() : plan.Target;
            var target = targetId is uint id ? Native.State.Actors.FirstOrDefault(a => a.Id == id && a.Hp > 0) : null;
            if (plan.Aggro && target is null) continue;
            if (plan.Target is not null && target is null) { Plans.Remove(alias); continue; }
            var destination = plan.Destination ?? new Vector3(target!.Pos[0], target.Pos[1], target.Pos[2]);
            var current = new Vector3(actor.Pos[0], actor.Pos[1], actor.Pos[2]);
            var offset = destination - current;
            offset.Y = 0;
            var distance = offset.Length();
            if (distance < .001f) { if (plan.Destination is not null) Plans.Remove(alias); continue; }
            var rotation = MathF.Atan2(offset.X, offset.Z);
            var step = plan.FaceOnly ? 0 : MathF.Min(MathF.Max(0, distance - plan.StopDistance), plan.Speed * (float)Math.Min(delta, .5));
            var position = current + offset / distance * step;
            Native.Call("slide_actor", Native.Actor(alias), Native.Position(position), rotation);
            if (plan.Destination is not null && distance - step < .001f) Plans.Remove(alias);
        }
    }
}
