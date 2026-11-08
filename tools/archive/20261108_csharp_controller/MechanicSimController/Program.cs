// 每个副本独占进程；编译和脚本异常只终止此控制器。标准输出专用于协议。
using System.Numerics;
using System.Text;
using System.Text.Json;
using MechanicSim_Server.Definition;
using MechanicSim_Server.Enum;
using MechanicSim_Server.Manager;
using MechanicSim_Server.Struct;
using Kawari.MechanicSim;

Console.InputEncoding = Console.OutputEncoding = new UTF8Encoding(false);
var wire = Console.Out;
Console.SetOut(Console.Error);
var json = new JsonSerializerOptions(JsonSerializerDefaults.Web) { IncludeFields = true };
try
{
    if (args.Length != 2 || (args[0] != "--config" && args[0] != "--check"))
        throw new ArgumentException("用法：MechanicSimController --config profile.json 或 --check profile.json");
    var configFile = Path.GetFullPath(args[1]);
    var options = JsonSerializer.Deserialize<ControllerOptions>(File.ReadAllText(configFile), json)!;
    if (options.Origin.Length != 3 || options.Origin.Any(v => !float.IsFinite(v)))
        throw new ArgumentException("场地原点必须包含三个有限坐标。");
    var definitions = Path.GetFullPath(options.Definitions, Path.GetDirectoryName(configFile)!);
    Transport.Options = options;
    var compiled = new DefinitionCompilerService(definitions).CompileAndLoad();
    foreach (var diagnostic in compiled.Diagnostics) Console.Error.WriteLine(diagnostic);
    if (!compiled.Success || compiled.Diagnostics.Any(d => d.Contains("Duplicate ") || d.Contains("does not match")))
        throw new InvalidOperationException("机制定义编译失败，未启动副本。");
    if (!compiled.Registry.Timelines.TryGetValue(options.Timeline, out var timeline))
        throw new InvalidOperationException($"找不到时间轴 {options.Timeline}");
    foreach (var phase in timeline.TimeLinePhaseList)
        foreach (var node in phase.TimeLineNodes)
            if (node.Duration < TimeSpan.Zero) throw new InvalidOperationException($"节点时长不能为负：{node.NodeName}");
    if (args[0] == "--check")
    {
        Console.Error.WriteLine($"编译通过：{compiled.Registry.Actions.Count} 个技能，{compiled.Registry.Statuses.Count} 个状态，{compiled.Registry.Timelines.Count} 个时间轴。");
        return 0;
    }
    var raid = new RaidManager(compiled.Registry);
    Exception? callbackError = null;
    raid.TimelineExecutionError += (_, error) => callbackError = error;
    if (!raid.TrySelectTimeline(options.Timeline, out var message)) throw new InvalidOperationException(message);
    var initialized = false;
    var started = false;
    var lastTime = 0d;
    ulong lastSeq = 0;
    var watched = new HashSet<GameObject>();
    string? line;
    while ((line = Console.ReadLine()) is not null)
    {
        var frame = JsonSerializer.Deserialize<Frame>(line, json)!;
        if (frame.Version != 1 || frame.Seq <= lastSeq || !double.IsFinite(frame.Time) || frame.Time < lastTime)
            throw new InvalidOperationException("协议版本、序号或服务器时钟不正确。");
        lastSeq = frame.Seq;
        Native.Update(frame);
        var players = frame.Actors.Where(a => a.Player).ToArray();
        raid.Players.RemoveAll(p => !players.Any(a => a.Id == unchecked((uint)p.ClientId)));
        foreach (var actor in players)
        {
            var player = raid.Players.FirstOrDefault(p => unchecked((uint)p.ClientId) == actor.Id);
            if (player is null) { player = new Player { ClientId = unchecked((int)actor.Id), PlayerName = $"Actor-{actor.Id}" }; raid.Players.Add(player); }
            player.Position = new Vector3(actor.Pos[0], actor.Pos[1], actor.Pos[2]) - Transport.Origin;
            player.Faceing = actor.Rotation;
            player.IsDead = actor.Hp == 0;
            player.ClassJob = actor.Job.ToString();
            player.Role = actor.Job is 1 or 3 or 19 or 21 or 32 or 37 ? RoleEnum.TANK :
                actor.Job is 6 or 24 or 28 or 33 or 40 ? RoleEnum.HEALER : RoleEnum.DPS_MELEE;
        }
        if (!initialized && players.Length > 0)
        {
            timeline.OnTimeLineInit?.Invoke();
            timeline.OnTimeLineInit = null; // 初始化一次，开战不重复生成实体。
            initialized = true;
            Native.Call("set_reset_on_deaggro", false);
            if (options.DummyTrigger)
            {
                Native.Spawn("trigger", 11744, 541, 99999999, Transport.Origin, boss: true, level: 1);
                Native.Call("arm_hit_trigger", Native.Actor("trigger"));
                Native.Call("set_ai_enabled", Native.Actor("trigger"), true);
                foreach (var obj in raid.GameObjects.Where(o => o.IsTargetable)) Native.Call("set_targetable", Native.Actor($"ms-{obj.ServerGameObjectId}"), false);
            }
        }
        if (frame.Battle && !started && initialized)
        {
            if (!raid.TryStartSelectedTimeline(out message)) throw new InvalidOperationException(message);
            started = true;
            if (options.DummyTrigger)
            {
                Native.Call("despawn", Native.Actor("trigger"));
                foreach (var obj in raid.GameObjects.Where(o => o.IsTargetable)) Native.Call("set_targetable", Native.Actor($"ms-{obj.ServerGameObjectId}"), true);
            }
        }
        foreach (var obj in raid.GameObjects)
        {
            if (watched.Add(obj))
                obj.OnActionCancel += (_, _, _) => Native.Call("interrupt_cast", new { target = Native.Actor($"ms-{obj.ServerGameObjectId}") });
            if (frame.Bindings.TryGetValue($"ms-{obj.ServerGameObjectId}", out var id))
            {
                var actor = frame.Actors.FirstOrDefault(a => a.Id == id);
                if (actor is not null && actor.Hp == 0) obj.CancelCurrentCast();
            }
        }
        var delta = started ? frame.Time - lastTime : 0;
        raid.Tick(TimeSpan.FromSeconds(delta));
        // 原定义只在机制期间主动改朝向；其余时间由 C# 面向实时最高仇恨。
        foreach (var obj in raid.GameObjects.Where(o => o.CurrentCast is null && !o.Move))
        {
            if (!options.Actors.TryGetValue(obj.ServerGameObjectId, out var mapping) || !mapping.Boss) continue;
            if (!frame.Bindings.TryGetValue($"ms-{obj.ServerGameObjectId}", out var actorId)) continue;
            var stateActor = frame.Actors.FirstOrDefault(a => a.Id == actorId);
            var target = stateActor is null ? null : frame.Actors.FirstOrDefault(a => a.Id == stateActor.Enmity.FirstOrDefault() && a.Hp > 0);
            if (target is null) continue;
            var offset = new Vector3(target.Pos[0], target.Pos[1], target.Pos[2]) - Transport.Origin - obj.Position;
            if (offset.X * offset.X + offset.Z * offset.Z < .000001f) continue;
            var facing = MathF.Atan2(offset.X, offset.Z);
            if (MathF.Abs(obj.Rotation - facing) < .001f) continue;
            obj.Rotation = facing;
            Native.Call("slide_actor", Native.Actor($"ms-{obj.ServerGameObjectId}"), Native.Position(obj.Position + Transport.Origin), facing);
        }
        Motion.Tick(delta);
        Scheduling.Tick();
        if (callbackError is not null) throw callbackError;
        lastTime = frame.Time;
        var response = new { version = 1, seq = frame.Seq, commands = Native.Drain(), state = raid.BuildTimelineRuntimeState() };
        await wire.WriteLineAsync(JsonSerializer.Serialize(response, json));
        await wire.FlushAsync();
    }
    return 0;
}
catch (Exception error)
{
    Console.Error.WriteLine(error);
    return 1;
}
