using Kawari.Encounters;
// 混沌涡旋 [47934]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Sequence11StrayWhirlwind
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(47933, new Params { ["pos"] = new Position(110.0, 0.0, 95.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper13 }); }, order: 436);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(47933, new Params { ["pos"] = new Position(95.0, 0.0, 110.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper14 }); }, order: 437);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(47934, TimeSpan.FromSeconds(4.7), new Params { ["spell"] = 47934, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Boss }); }, order: 438);
        raid.Schedule(TimeSpan.FromSeconds(0.326), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(47932, new Params { ["pos"] = new Position(115.0, 0.0, 80.0), ["rotation"] = -0.78546, ["target"] = ActorDefinitions.Helper12 }); }, order: 439);
        raid.Schedule(TimeSpan.FromSeconds(0.326), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.ExecuteAction(47932, new Params { ["pos"] = new Position(130.0, 0.0, 95.0), ["rotation"] = -0.78546, ["target"] = ActorDefinitions.Helper11 }); }, order: 440);
        raid.Schedule(TimeSpan.FromSeconds(0.457), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetPosition(new Position(100.0, 0.0, 115.0), -5e-05); }, order: 441);
        raid.Schedule(TimeSpan.FromSeconds(0.457), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetPosition(new Position(115.0, 0.0, 100.0), -5e-05); }, order: 442);
        raid.Schedule(TimeSpan.FromSeconds(0.543), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.ExecuteAction(47933, new Params { ["pos"] = new Position(100.0, 0.0, 115.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper09 }); }, order: 443);
        raid.Schedule(TimeSpan.FromSeconds(0.543), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.ExecuteAction(47933, new Params { ["pos"] = new Position(115.0, 0.0, 100.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper10 }); }, order: 444);
        raid.Schedule(TimeSpan.FromSeconds(0.857), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.SetPosition(new Position(125.0, 0.0, 100.0), -5e-05); }, order: 445);
        raid.Schedule(TimeSpan.FromSeconds(0.857), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetPosition(new Position(110.0, 0.0, 85.0), -5e-05); }, order: 446);
        raid.Schedule(TimeSpan.FromSeconds(0.943), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.ExecuteAction(47933, new Params { ["pos"] = new Position(110.0, 0.0, 85.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper08 }); }, order: 447);
        raid.Schedule(TimeSpan.FromSeconds(0.943), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.ExecuteAction(47933, new Params { ["pos"] = new Position(125.0, 0.0, 100.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper07 }); }, order: 448);
        raid.Schedule(TimeSpan.FromSeconds(0.992), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper05)?.SetPosition(new Position(120.0, 0.0, 105.0), -5e-05); }, order: 449);
        raid.Schedule(TimeSpan.FromSeconds(0.992), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper06)?.SetPosition(new Position(105.0, 0.0, 120.0), -5e-05); }, order: 450);
        raid.Schedule(TimeSpan.FromSeconds(1.113), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper05)?.ExecuteAction(47933, new Params { ["pos"] = new Position(120.0, 0.0, 105.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper05 }); }, order: 451);
        raid.Schedule(TimeSpan.FromSeconds(1.113), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper06)?.ExecuteAction(47933, new Params { ["pos"] = new Position(105.0, 0.0, 120.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper06 }); }, order: 452);
        raid.Schedule(TimeSpan.FromSeconds(1.361), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(105.0, 0.0, 90.0), -5e-05); }, order: 453);
        raid.Schedule(TimeSpan.FromSeconds(1.361), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(120.0, 0.0, 105.0), -5e-05); }, order: 454);
        raid.Schedule(TimeSpan.FromSeconds(1.49), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(47933, new Params { ["pos"] = new Position(120.0, 0.0, 105.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper16 }); }, order: 455);
        raid.Schedule(TimeSpan.FromSeconds(1.49), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(47933, new Params { ["pos"] = new Position(105.0, 0.0, 90.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper15 }); }, order: 456);
        raid.Schedule(TimeSpan.FromSeconds(1.939), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetPosition(new Position(115.0, 0.0, 110.0), -5e-05); }, order: 457);
        raid.Schedule(TimeSpan.FromSeconds(1.939), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 95.0), -5e-05); }, order: 458);
        raid.Schedule(TimeSpan.FromSeconds(2.002), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(47933, new Params { ["pos"] = new Position(115.0, 0.0, 110.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper13 }); }, order: 459);
        raid.Schedule(TimeSpan.FromSeconds(2.002), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(47933, new Params { ["pos"] = new Position(100.0, 0.0, 95.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper14 }); }, order: 460);
        raid.Schedule(TimeSpan.FromSeconds(2.432), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.SetPosition(new Position(95.0, 0.0, 100.0), -5e-05); }, order: 461);
        raid.Schedule(TimeSpan.FromSeconds(2.432), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetPosition(new Position(110.0, 0.0, 115.0), -5e-05); }, order: 462);
        raid.Schedule(TimeSpan.FromSeconds(2.52), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(47933, new Params { ["pos"] = new Position(110.0, 0.0, 115.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper12 }); }, order: 463);
        raid.Schedule(TimeSpan.FromSeconds(2.52), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.ExecuteAction(47933, new Params { ["pos"] = new Position(95.0, 0.0, 100.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper11 }); }, order: 464);
        raid.Schedule(TimeSpan.FromSeconds(2.964), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetPosition(new Position(105.0, 0.0, 120.0), -5e-05); }, order: 465);
        raid.Schedule(TimeSpan.FromSeconds(2.964), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetPosition(new Position(90.0, 0.0, 105.0), -5e-05); }, order: 466);
        raid.Schedule(TimeSpan.FromSeconds(3.053), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.ExecuteAction(47933, new Params { ["pos"] = new Position(105.0, 0.0, 120.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper09 }); }, order: 467);
        raid.Schedule(TimeSpan.FromSeconds(3.053), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.ExecuteAction(47933, new Params { ["pos"] = new Position(90.0, 0.0, 105.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper10 }); }, order: 468);
        raid.Schedule(TimeSpan.FromSeconds(3.447), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(85.0, 0.0, 110.0), -5e-05); }, order: 469);
        raid.Schedule(TimeSpan.FromSeconds(3.447), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(100.0, 0.0, 125.0), -5e-05); }, order: 470);
        raid.Schedule(TimeSpan.FromSeconds(3.578), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(47933, new Params { ["pos"] = new Position(100.0, 0.0, 125.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper16 }); }, order: 471);
        raid.Schedule(TimeSpan.FromSeconds(3.578), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(47933, new Params { ["pos"] = new Position(85.0, 0.0, 110.0), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper15 }); }, order: 472);
        raid.Schedule(TimeSpan.FromSeconds(4.968), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(47934, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.14159, ["target"] = ActorDefinitions.Boss }); }, order: 473);
        raid.Schedule(TimeSpan.FromSeconds(5.869), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.ExecuteAction(47935, new Params { ["pos"] = new Position(105.0, 0.0, 120.0), ["rotation"] = -5e-05 }); }, order: 474);
        raid.Schedule(TimeSpan.FromSeconds(5.869), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.ExecuteAction(47935, new Params { ["pos"] = new Position(90.0, 0.0, 105.0), ["rotation"] = -5e-05 }); }, order: 475);
        raid.Schedule(TimeSpan.FromSeconds(5.869), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(47935, new Params { ["pos"] = new Position(110.0, 0.0, 115.0), ["rotation"] = -5e-05 }); }, order: 476);
        raid.Schedule(TimeSpan.FromSeconds(5.869), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(47935, new Params { ["pos"] = new Position(115.0, 0.0, 110.0), ["rotation"] = -5e-05 }); }, order: 477);
        raid.Schedule(TimeSpan.FromSeconds(5.869), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper11)?.ExecuteAction(47935, new Params { ["pos"] = new Position(95.0, 0.0, 100.0), ["rotation"] = -5e-05 }); }, order: 478);
        raid.Schedule(TimeSpan.FromSeconds(5.869), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(47935, new Params { ["pos"] = new Position(100.0, 0.0, 95.0), ["rotation"] = -5e-05 }); }, order: 479);
        raid.Schedule(TimeSpan.FromSeconds(5.869), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(47935, new Params { ["pos"] = new Position(100.0, 0.0, 125.0), ["rotation"] = -5e-05 }); }, order: 480);
        raid.Schedule(TimeSpan.FromSeconds(5.869), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(47935, new Params { ["pos"] = new Position(85.0, 0.0, 110.0), ["rotation"] = -5e-05 }); }, order: 481);
        raid.Schedule(TimeSpan.FromSeconds(8.274), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.10593); }, order: 482);
        raid.Schedule(TimeSpan.FromSeconds(8.578), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.12443); }, order: 483);
    }
}
