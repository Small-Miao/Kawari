// 延时任务使用世界服战斗时间；控制器销毁时全部自然失效。
using System.Numerics;
using MechanicSim_Server.Struct;

namespace Kawari.MechanicSim;

public static class Scheduling
{
    private static readonly List<(double At, System.Action Callback)> Queue = [];
    public static void After(double seconds, System.Action callback)
    {
        if (!double.IsFinite(seconds) || seconds < 0 || seconds > 604800 || Queue.Count >= 4096)
            throw new ArgumentOutOfRangeException(nameof(seconds));
        Queue.Add((Native.State.Time + seconds, callback));
    }
    internal static void Tick()
    {
        for (var count = 0; count < 4096; count++)
        {
            var next = Queue.FindIndex(x => x.At <= Native.State.Time);
            if (next < 0) return;
            var entry = Queue[next]; Queue.RemoveAt(next); entry.Callback();
        }
        throw new InvalidOperationException("同一帧的延时任务过多。");
    }
}

public static class Presentation
{
    private static uint _sequence;
    public static Vector3 World(Vector3 local) => local + Transport.Origin;
    public static void Icon(Player player, uint id) => Native.Call("set_target_icon", unchecked((uint)player.ClientId), id);
    public static void EffectAt(uint action, Vector3 localPosition, float rotation = 0, uint? target = null)
    {
        var key = $"effect-{++_sequence}";
        Native.Spawn(key, 9020, 7131, 1, World(localPosition), model: 480, targetable: false);
        Native.Call("move_actor", Native.Actor(key), Native.Position(World(localPosition)), rotation);
        Native.Call("raidwide", new { source = Native.Actor(key), action, damage = 0, delay = 0,
            pos = Native.Position(World(localPosition)), rotation,
            target = (object?)target ?? Native.Actor(key), targets = Array.Empty<uint>() });
        Scheduling.After(8, () => Native.Call("despawn", Native.Actor(key)));
    }
    public static void Hit(Player player, uint action, uint amount) =>
        Native.Damage(Native.Actor("ms-3000"), action, amount, unchecked((uint)player.ClientId));
    public static void Kill(Player player, uint action) => Native.Call("raidwide", new {
        source = Native.Actor("ms-3000"), action, damage = 9999999, delay = 0, unmitigated = true,
        targets = new[] { unchecked((uint)player.ClientId) }
    });
    public static void Tower(Vector3 localPosition)
    {
        // 录像映射：北=1、东北=2，顺时针至西北=8。
        var index = (byte)((((int)MathF.Round(MathF.Atan2(localPosition.X, -localPosition.Z) / (MathF.PI / 4))) + 8) % 8 + 1);
        Native.MapEffect(index, 1, 2);
        Scheduling.After(3, () => Native.MapEffect(index, 4, 8));
    }

    public static ActorRef Actor(GameObject actor) => Native.Actor($"ms-{actor.ServerGameObjectId}");
    public static void Begin(GameObject actor, uint action, float seconds) =>
        Native.BeginCast(Actor(actor), action, seconds, World(actor.Position));
    public static void Finish(GameObject actor, uint action)
    {
        Native.EndCast(Actor(actor), action);
        Native.TargetedAction(Actor(actor), action, Actor(actor));
    }
    public static void Jump(ActionCast cast, uint mainAction, uint cloneAction)
    {
        var actor = cast.Caster;
        actor.Move = false;
        var destination = cast.TargetPlayer.Position;
        var offset = destination - actor.Position;
        if (offset.LengthSquared() > .000001f) actor.Rotation = MathF.Atan2(offset.X, offset.Z);
        Native.Call("slide_actor", Actor(actor), Native.Position(World(actor.Position)), actor.Rotation);
        Native.Call("set_visible", Actor(actor), true);
        Native.TargetedAction(Actor(actor), actor.ServerGameObjectId == 3000 ? mainAction : cloneAction,
            unchecked((uint)cast.TargetPlayer.ClientId));
        // 先由真实演员播放跳跃，随后同步落点；不从透明 Helper 播放本体动作。
        Scheduling.After(.5, () => {
            var length = offset.Length();
            actor.Position = length > actor.HitboxRadius ? destination - offset / length * actor.HitboxRadius : actor.Position;
            Native.Call("slide_actor", Actor(actor), Native.Position(World(actor.Position)), actor.Rotation);
        });
    }
    public static void Cleave(GameObject actor, uint action, bool rear)
    {
        Native.EndCast(Actor(actor), action);
        var rotation = actor.Rotation + (rear ? MathF.PI : 0);
        Native.Call("raidwide", new { source = Actor(actor), action, damage = 0, delay = 0,
            target = Actor(actor), targets = Array.Empty<uint>(), rotation, pos = Native.Position(World(actor.Position)) });
        if (actor.ServerGameObjectId != 3000)
            Scheduling.After(3, () => Native.Call("play_timeline", Actor(actor), 7737));
    }
}
