using Kawari.Encounters;
// 癫狂交响曲 [47952]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Sequence12MaddeningOrchestra
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(47952, TimeSpan.FromSeconds(4.7), new Params { ["spell"] = 47952, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.12443, ["target"] = ActorDefinitions.Boss }); }, order: 484);
        raid.Schedule(TimeSpan.FromSeconds(4.97), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(47952, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.12443, ["target"] = ActorDefinitions.Boss }); }, order: 485);
        raid.Schedule(TimeSpan.FromSeconds(5.86), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.12443); }, order: 486);
        raid.Schedule(TimeSpan.FromSeconds(5.86), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.12443); }, order: 487);
        raid.Schedule(TimeSpan.FromSeconds(5.86), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.12443); }, order: 488);
        raid.Schedule(TimeSpan.FromSeconds(5.86), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.12443); }, order: 489);
        raid.Schedule(TimeSpan.FromSeconds(5.86), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.12443); }, order: 490);
        raid.Schedule(TimeSpan.FromSeconds(5.92), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(47956, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.12443 }); }, order: 491);
        raid.Schedule(TimeSpan.FromSeconds(5.92), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(47956, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.12443 }); }, order: 492);
        raid.Schedule(TimeSpan.FromSeconds(5.92), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(47956, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.12443 }); }, order: 493);
        raid.Schedule(TimeSpan.FromSeconds(5.92), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(47954, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.12443 }); }, order: 494);
        raid.Schedule(TimeSpan.FromSeconds(5.92), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(47954, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.12443 }); }, order: 495);
        raid.Schedule(TimeSpan.FromSeconds(8.147), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(47953, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.12443, ["target"] = ActorDefinitions.Boss }); }, order: 496);
        raid.Schedule(TimeSpan.FromSeconds(9.044), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(47956, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.12443 }); }, order: 497);
        raid.Schedule(TimeSpan.FromSeconds(9.044), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(47956, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.12443 }); }, order: 498);
        raid.Schedule(TimeSpan.FromSeconds(9.044), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(47955, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.12443 }); }, order: 499);
        raid.Schedule(TimeSpan.FromSeconds(9.044), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(47956, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.12443 }); }, order: 500);
        raid.Schedule(TimeSpan.FromSeconds(11.365), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.13622); }, order: 501);
        raid.Schedule(TimeSpan.FromSeconds(12.531), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(47957, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.12443 }); }, order: 502);
        raid.Schedule(TimeSpan.FromSeconds(12.531), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(47958, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.12443 }); }, order: 503);
        raid.Schedule(TimeSpan.FromSeconds(16.388), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(50770, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.13622, ["target"] = ActorDefinitions.Boss }); }, order: 504);
        raid.Schedule(TimeSpan.FromSeconds(17.156), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.13622); }, order: 505);
        raid.Schedule(TimeSpan.FromSeconds(17.156), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.13622); }, order: 506);
        raid.Schedule(TimeSpan.FromSeconds(17.156), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.13622); }, order: 507);
        raid.Schedule(TimeSpan.FromSeconds(17.224), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(50772, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.13622 }); }, order: 508);
        raid.Schedule(TimeSpan.FromSeconds(17.224), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(50771, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.13622 }); }, order: 509);
        raid.Schedule(TimeSpan.FromSeconds(17.224), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(50773, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.13622 }); }, order: 510);
        raid.Schedule(TimeSpan.FromSeconds(19.546), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(50770, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.13622, ["target"] = ActorDefinitions.Boss }); }, order: 511);
        raid.Schedule(TimeSpan.FromSeconds(20.285), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.13622); }, order: 512);
        raid.Schedule(TimeSpan.FromSeconds(20.285), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.13622); }, order: 513);
        raid.Schedule(TimeSpan.FromSeconds(20.285), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.13622); }, order: 514);
        raid.Schedule(TimeSpan.FromSeconds(20.344), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(50772, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.13622 }); }, order: 515);
        raid.Schedule(TimeSpan.FromSeconds(20.344), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(50771, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.13622 }); }, order: 516);
        raid.Schedule(TimeSpan.FromSeconds(20.344), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(50773, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.13622 }); }, order: 517);
        raid.Schedule(TimeSpan.FromSeconds(22.654), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(50770, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.13622, ["target"] = ActorDefinitions.Boss }); }, order: 518);
        raid.Schedule(TimeSpan.FromSeconds(23.416), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.13622); }, order: 519);
        raid.Schedule(TimeSpan.FromSeconds(23.416), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.13622); }, order: 520);
        raid.Schedule(TimeSpan.FromSeconds(23.416), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), 3.13622); }, order: 521);
        raid.Schedule(TimeSpan.FromSeconds(23.483), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(50772, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.13622 }); }, order: 522);
        raid.Schedule(TimeSpan.FromSeconds(23.483), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(50771, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.13622 }); }, order: 523);
        raid.Schedule(TimeSpan.FromSeconds(23.483), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(50773, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 3.13622 }); }, order: 524);
    }
}
