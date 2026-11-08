using Kawari.Encounters;
// 连续究极 [47936]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Sequence03UltimaRepeater
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(47936, TimeSpan.FromSeconds(3.7), new Params { ["spell"] = 47936, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.06949, ["target"] = ActorDefinitions.Boss }); }, order: 44);
        raid.Schedule(TimeSpan.FromSeconds(3.995), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(47936, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.06949, ["target"] = ActorDefinitions.Boss }); }, order: 45);
        raid.Schedule(TimeSpan.FromSeconds(3.995), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetOwner(ActorDefinitions.Boss); }, order: 46);
        raid.Schedule(TimeSpan.FromSeconds(3.995), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.06949); }, order: 47);
        raid.Schedule(TimeSpan.FromSeconds(3.995), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetOwner(ActorDefinitions.Boss); }, order: 48);
        raid.Schedule(TimeSpan.FromSeconds(3.995), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.06949); }, order: 49);
        raid.Schedule(TimeSpan.FromSeconds(3.995), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(ActorDefinitions.Boss); }, order: 50);
        raid.Schedule(TimeSpan.FromSeconds(3.995), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.06949); }, order: 51);
        raid.Schedule(TimeSpan.FromSeconds(3.995), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetOwner(ActorDefinitions.Boss); }, order: 52);
        raid.Schedule(TimeSpan.FromSeconds(3.995), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.06949); }, order: 53);
        raid.Schedule(TimeSpan.FromSeconds(5.151), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(47937, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.06949, ["target"] = ActorDefinitions.Helper16 }); }, order: 54);
        raid.Schedule(TimeSpan.FromSeconds(5.865), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(47937, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.06949, ["target"] = ActorDefinitions.Helper15 }); }, order: 55);
        raid.Schedule(TimeSpan.FromSeconds(6.529), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(47937, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.06949, ["target"] = ActorDefinitions.Helper14 }); }, order: 56);
        raid.Schedule(TimeSpan.FromSeconds(7.221), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(47937, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.06949, ["target"] = ActorDefinitions.Helper13 }); }, order: 57);
        raid.Schedule(TimeSpan.FromSeconds(8.143), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.11446); }, order: 58);
        raid.Schedule(TimeSpan.FromSeconds(9.203), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(50770, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.11446, ["target"] = ActorDefinitions.Boss }); }, order: 59);
        raid.Schedule(TimeSpan.FromSeconds(9.932), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.11446); }, order: 60);
        raid.Schedule(TimeSpan.FromSeconds(9.932), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.11446); }, order: 61);
        raid.Schedule(TimeSpan.FromSeconds(9.932), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.11446); }, order: 62);
        raid.Schedule(TimeSpan.FromSeconds(9.996), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(50772, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.11446 }); }, order: 63);
        raid.Schedule(TimeSpan.FromSeconds(9.996), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(50771, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.11446 }); }, order: 64);
        raid.Schedule(TimeSpan.FromSeconds(9.996), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(50773, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.11446 }); }, order: 65);
        raid.Schedule(TimeSpan.FromSeconds(12.353), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(50770, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.11446, ["target"] = ActorDefinitions.Boss }); }, order: 66);
        raid.Schedule(TimeSpan.FromSeconds(13.122), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.11446); }, order: 67);
        raid.Schedule(TimeSpan.FromSeconds(13.122), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.11446); }, order: 68);
        raid.Schedule(TimeSpan.FromSeconds(13.122), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.11446); }, order: 69);
        raid.Schedule(TimeSpan.FromSeconds(13.176), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(50772, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.11446 }); }, order: 70);
        raid.Schedule(TimeSpan.FromSeconds(13.176), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(50771, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.11446 }); }, order: 71);
        raid.Schedule(TimeSpan.FromSeconds(13.176), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(50773, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.11446 }); }, order: 72);
        raid.Schedule(TimeSpan.FromSeconds(15.49), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(50770, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.11446, ["target"] = ActorDefinitions.Boss }); }, order: 73);
        raid.Schedule(TimeSpan.FromSeconds(16.251), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.11446); }, order: 74);
        raid.Schedule(TimeSpan.FromSeconds(16.251), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.11446); }, order: 75);
        raid.Schedule(TimeSpan.FromSeconds(16.251), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.11446); }, order: 76);
        raid.Schedule(TimeSpan.FromSeconds(16.314), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(50772, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.11446 }); }, order: 77);
        raid.Schedule(TimeSpan.FromSeconds(16.314), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(50771, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.11446 }); }, order: 78);
        raid.Schedule(TimeSpan.FromSeconds(16.314), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(50773, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.11446 }); }, order: 79);
    }
}
