using Kawari.Encounters;
// 连续究极 [47936]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Sequence09UltimaRepeater
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(47936, TimeSpan.FromSeconds(3.7), new Params { ["spell"] = 47936, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Boss }); }, order: 247);
        raid.Schedule(TimeSpan.FromSeconds(3.995), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(47936, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Boss }); }, order: 257);
        raid.Schedule(TimeSpan.FromSeconds(3.995), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.14159); }, order: 258);
        raid.Schedule(TimeSpan.FromSeconds(3.995), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.14159); }, order: 259);
        raid.Schedule(TimeSpan.FromSeconds(3.995), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.14159); }, order: 260);
        raid.Schedule(TimeSpan.FromSeconds(3.995), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.14159); }, order: 261);
        raid.Schedule(TimeSpan.FromSeconds(5.113), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(47937, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Helper16 }); }, order: 262);
        raid.Schedule(TimeSpan.FromSeconds(5.843), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(47937, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Helper15 }); }, order: 263);
        raid.Schedule(TimeSpan.FromSeconds(6.522), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(47937, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Helper14 }); }, order: 264);
        raid.Schedule(TimeSpan.FromSeconds(7.212), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(47937, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Helper13 }); }, order: 265);
        raid.Schedule(TimeSpan.FromSeconds(8.274), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.10305); }, order: 266);
        raid.Schedule(TimeSpan.FromSeconds(9.228), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(50770, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.10305, ["target"] = ActorDefinitions.Boss }); }, order: 267);
        raid.Schedule(TimeSpan.FromSeconds(9.981), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.10305); }, order: 268);
        raid.Schedule(TimeSpan.FromSeconds(9.981), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.10305); }, order: 269);
        raid.Schedule(TimeSpan.FromSeconds(9.981), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.10305); }, order: 270);
        raid.Schedule(TimeSpan.FromSeconds(10.033), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(50772, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.10305 }); }, order: 271);
        raid.Schedule(TimeSpan.FromSeconds(10.033), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(50771, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.10305 }); }, order: 272);
        raid.Schedule(TimeSpan.FromSeconds(10.033), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(50773, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.10305 }); }, order: 273);
        raid.Schedule(TimeSpan.FromSeconds(12.385), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(50770, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.10305, ["target"] = ActorDefinitions.Boss }); }, order: 274);
        raid.Schedule(TimeSpan.FromSeconds(13.119), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.10305); }, order: 275);
        raid.Schedule(TimeSpan.FromSeconds(13.119), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.10305); }, order: 276);
        raid.Schedule(TimeSpan.FromSeconds(13.119), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.10305); }, order: 277);
        raid.Schedule(TimeSpan.FromSeconds(13.158), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(50772, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.10305 }); }, order: 278);
        raid.Schedule(TimeSpan.FromSeconds(13.158), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(50771, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.10305 }); }, order: 279);
        raid.Schedule(TimeSpan.FromSeconds(13.171), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(50773, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.10305 }); }, order: 280);
        raid.Schedule(TimeSpan.FromSeconds(14.547), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(70.0, 0.0, 95.0), 0.78536); }, order: 282);
        raid.Schedule(TimeSpan.FromSeconds(14.547), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(85.0, 0.0, 80.0), 0.78536); }, order: 283);
        raid.Schedule(TimeSpan.FromSeconds(14.574), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.TryCast(47932, TimeSpan.FromSeconds(3.7), new Params { ["spell"] = 47932, ["omen_delay"] = 0, ["cast_pos"] = new Position(69.9931, -0.0153, 94.9874), ["pos"] = new Position(70.0, 0.0, 95.0), ["rotation"] = 0.78536, ["target"] = ActorDefinitions.Helper16 }); }, order: 284);
        raid.Schedule(TimeSpan.FromSeconds(14.574), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.TryCast(47932, TimeSpan.FromSeconds(3.7), new Params { ["spell"] = 47932, ["omen_delay"] = 0, ["cast_pos"] = new Position(84.9775, -0.0153, 79.9725), ["pos"] = new Position(85.0, 0.0, 80.0), ["rotation"] = 0.78536, ["target"] = ActorDefinitions.Helper15 }); }, order: 285);
    }
}
