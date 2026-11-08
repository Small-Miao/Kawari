using Kawari.Encounters;
// 光与暗的孤翼 [40313]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Sequence15Wings
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(40313, TimeSpan.FromSeconds(6.6), new Params { ["spell"] = 40313, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 0.08691, ["target"] = ActorDefinitions.Boss }); }, order: 1237);
        raid.Schedule(TimeSpan.FromSeconds(6.831), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(40313, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 0.08691, ["target"] = ActorDefinitions.Boss }); }, order: 1245);
        raid.Schedule(TimeSpan.FromSeconds(7.11), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -1.03157); }, order: 1246);
        raid.Schedule(TimeSpan.FromSeconds(7.178), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(null); }, order: 1247);
        raid.Schedule(TimeSpan.FromSeconds(7.178), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(ActorDefinitions.Boss); }, order: 1248);
        raid.Schedule(TimeSpan.FromSeconds(7.178), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(106.0622, 0.0, 96.5), -1.0472); }, order: 1249);
        raid.Schedule(TimeSpan.FromSeconds(7.255), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(40314, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -1.04538, ["target"] = ActorDefinitions.Boss }); }, order: 1251);
        raid.Schedule(TimeSpan.FromSeconds(7.255), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(40320, new Params { ["pos"] = new Position(106.0622, 0.0, 96.5), ["rotation"] = -1.0472, ["target"] = ActorDefinitions.Helper14 }); }, order: 1252);
        raid.Schedule(TimeSpan.FromSeconds(8.014), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetOwner(null); }, order: 1253);
        raid.Schedule(TimeSpan.FromSeconds(8.014), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetOwner(ActorDefinitions.Boss); }, order: 1254);
        raid.Schedule(TimeSpan.FromSeconds(8.014), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(39879, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 0.08691 }); }, order: 1255);
        raid.Schedule(TimeSpan.FromSeconds(8.607), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.Untether(0, 0); }, order: 1256);
        raid.Schedule(TimeSpan.FromSeconds(10.707), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(null); }, order: 1259);
        raid.Schedule(TimeSpan.FromSeconds(10.707), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(ActorDefinitions.Boss); }, order: 1260);
        raid.Schedule(TimeSpan.FromSeconds(10.707), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(93.9378, 0.0, 96.5), 1.0472); }, order: 1261);
        raid.Schedule(TimeSpan.FromSeconds(10.787), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(40320, new Params { ["pos"] = new Position(93.9378, 0.0, 96.5), ["rotation"] = 1.0472, ["target"] = ActorDefinitions.Helper14 }); }, order: 1263);
        raid.Schedule(TimeSpan.FromSeconds(10.997), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 2.92683); }, order: 1264);
        raid.Schedule(TimeSpan.FromSeconds(11.052), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(40315, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 2.92683, ["target"] = ActorDefinitions.Boss }); }, order: 1265);
        raid.Schedule(TimeSpan.FromSeconds(11.832), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetModelState(0); }, order: 1266);
        raid.Schedule(TimeSpan.FromSeconds(11.832), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetOwner(null); }, order: 1267);
        raid.Schedule(TimeSpan.FromSeconds(11.832), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetOwner(ActorDefinitions.Boss); }, order: 1268);
        raid.Schedule(TimeSpan.FromSeconds(11.906), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(39880, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 0.08691 }); }, order: 1269);
        raid.Schedule(TimeSpan.FromSeconds(12.301), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.Untether(0, 0); }, order: 1270);
        raid.Schedule(TimeSpan.FromSeconds(14.146), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(null); }, order: 1271);
        raid.Schedule(TimeSpan.FromSeconds(14.146), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(ActorDefinitions.Boss); }, order: 1272);
        raid.Schedule(TimeSpan.FromSeconds(14.146), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 107.0), -3.14159); }, order: 1273);
        raid.Schedule(TimeSpan.FromSeconds(14.236), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(40320, new Params { ["pos"] = new Position(100.0, 0.0, 107.0), ["rotation"] = -3.14159, ["target"] = ActorDefinitions.Helper14 }); }, order: 1275);
        raid.Schedule(TimeSpan.FromSeconds(14.689), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.11149); }, order: 1276);
    }
}
