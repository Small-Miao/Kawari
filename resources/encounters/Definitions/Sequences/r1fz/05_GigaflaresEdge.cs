using Kawari.Encounters;
// 十亿核爆剑 [28057]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.r1fz;
public static class Sequence05GigaflaresEdge
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(28057, TimeSpan.FromSeconds(7.7), new Params { ["spell"] = 28057, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -0.01184, ["target"] = ActorDefinitions.Boss }); }, order: 367);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.TryCast(28114, TimeSpan.FromSeconds(12.7), new Params { ["spell"] = 28114, ["omen_delay"] = 36, ["cast_pos"] = new Position(112.0165, -0.0153, 107.1336), ["pos"] = new Position(112.041, 0.0, 107.1425), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper08 }); }, order: 368);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.TryCast(28115, TimeSpan.FromSeconds(16.7), new Params { ["spell"] = 28115, ["omen_delay"] = 54, ["cast_pos"] = new Position(87.7852, -0.0153, 106.8284), ["pos"] = new Position(87.7939, 0.0, 106.8565), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper09 }); }, order: 369);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.TryCast(28058, TimeSpan.FromSeconds(8.7), new Params { ["spell"] = 28058, ["omen_delay"] = 18, ["cast_pos"] = new Position(100.145, -0.0153, 85.9846), ["pos"] = new Position(100.1651, 0.0, 86.001), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper10 }); }, order: 370);
        raid.Schedule(TimeSpan.FromSeconds(0.927), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ApplyStatuses(new StatusSpec[] { new StatusSpec(2056, 299, 0) }); }, order: 371);
        raid.Schedule(TimeSpan.FromSeconds(1.236), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ApplyStatuses(new StatusSpec[] { new StatusSpec(2056, 299, 0) }); }, order: 372);
        raid.Schedule(TimeSpan.FromSeconds(2.97), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ApplyStatuses(new StatusSpec[] { new StatusSpec(2056, 299, 0) }); }, order: 373);
        raid.Schedule(TimeSpan.FromSeconds(4.306), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ApplyStatuses(new StatusSpec[] { new StatusSpec(2056, 299, 0) }); }, order: 374);
        raid.Schedule(TimeSpan.FromSeconds(7.3), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ApplyStatuses(new StatusSpec[] { new StatusSpec(2056, 299, 0) }); }, order: 375);
        raid.Schedule(TimeSpan.FromSeconds(7.951), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(28057, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -0.01184, ["target"] = ActorDefinitions.Boss }); }, order: 376);
        raid.Schedule(TimeSpan.FromSeconds(8.98), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.ExecuteAction(28058, new Params { ["pos"] = new Position(100.1651, 0.0, 86.001), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper10 }); }, order: 377);
        raid.Schedule(TimeSpan.FromSeconds(9.115), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.SetOwner(null); }, order: 378);
        raid.Schedule(TimeSpan.FromSeconds(9.115), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.SetOwner(ActorDefinitions.Boss); }, order: 379);
        raid.Schedule(TimeSpan.FromSeconds(9.115), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.SetPosition(new Position(100.0, 0.0, 100.0), -0.01184); }, order: 380);
        raid.Schedule(TimeSpan.FromSeconds(9.115), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.ExecuteAction(28050, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -0.01184, ["target"] = ActorDefinitions.Helper07 }); }, order: 381);
        raid.Schedule(TimeSpan.FromSeconds(12.142), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -1.6957); }, order: 382);
        raid.Schedule(TimeSpan.FromSeconds(12.509), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -2.1536); }, order: 383);
        raid.Schedule(TimeSpan.FromSeconds(12.8), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -2.17785); }, order: 384);
        raid.Schedule(TimeSpan.FromSeconds(13.017), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.ExecuteAction(28114, new Params { ["pos"] = new Position(112.041, 0.0, 107.1425), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper08 }); }, order: 385);
        raid.Schedule(TimeSpan.FromSeconds(13.305), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -2.1954); }, order: 386);
        raid.Schedule(TimeSpan.FromSeconds(13.608), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -2.36031); }, order: 387);
        raid.Schedule(TimeSpan.FromSeconds(13.931), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -2.61994); }, order: 388);
        raid.Schedule(TimeSpan.FromSeconds(14.243), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.02252); }, order: 389);
        raid.Schedule(TimeSpan.FromSeconds(14.555), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 2.90593); }, order: 390);
        raid.Schedule(TimeSpan.FromSeconds(14.867), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 2.46222); }, order: 391);
        raid.Schedule(TimeSpan.FromSeconds(15.186), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 2.22148); }, order: 392);
        raid.Schedule(TimeSpan.FromSeconds(15.498), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 2.07441); }, order: 393);
        raid.Schedule(TimeSpan.FromSeconds(15.803), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 2.00777); }, order: 394);
        raid.Schedule(TimeSpan.FromSeconds(16.365), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 1.94564); }, order: 395);
        raid.Schedule(TimeSpan.FromSeconds(16.662), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 1.85782); }, order: 396);
        raid.Schedule(TimeSpan.FromSeconds(17.016), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.ExecuteAction(28115, new Params { ["pos"] = new Position(87.7939, 0.0, 106.8565), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper09 }); }, order: 397);
        raid.Schedule(TimeSpan.FromSeconds(17.232), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 1.7794); }, order: 398);
        raid.Schedule(TimeSpan.FromSeconds(17.521), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 1.67336); }, order: 399);
        raid.Schedule(TimeSpan.FromSeconds(17.812), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 1.50702); }, order: 400);
        raid.Schedule(TimeSpan.FromSeconds(18.137), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 1.30884); }, order: 401);
        raid.Schedule(TimeSpan.FromSeconds(18.442), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 1.08919); }, order: 402);
        raid.Schedule(TimeSpan.FromSeconds(18.75), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 0.85727); }, order: 403);
        raid.Schedule(TimeSpan.FromSeconds(19.111), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 0.61825); }, order: 404);
        raid.Schedule(TimeSpan.FromSeconds(19.412), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 0.36696); }, order: 405);
        raid.Schedule(TimeSpan.FromSeconds(19.723), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 0.15086); }, order: 406);
        raid.Schedule(TimeSpan.FromSeconds(20.06), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -0.04377); }, order: 407);
        raid.Schedule(TimeSpan.FromSeconds(23.275), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -0.01807); }, order: 408);
        raid.Schedule(TimeSpan.FromSeconds(26.184), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(28062, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -0.01807, ["target"] = ActorDefinitions.Boss }); }, order: 409);
        raid.Schedule(TimeSpan.FromSeconds(27.161), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(null); }, order: 410);
        raid.Schedule(TimeSpan.FromSeconds(27.161), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(ActorDefinitions.Boss); }, order: 411);
        raid.Schedule(TimeSpan.FromSeconds(27.161), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(null); }, order: 412);
        raid.Schedule(TimeSpan.FromSeconds(27.161), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(ActorDefinitions.Boss); }, order: 413);
        raid.Schedule(TimeSpan.FromSeconds(27.161), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(null); }, order: 414);
        raid.Schedule(TimeSpan.FromSeconds(27.161), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(ActorDefinitions.Boss); }, order: 415);
        raid.Schedule(TimeSpan.FromSeconds(27.195), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.ExecuteAction(28065, new Params { ["pos"] = new Position(112.041, 0.0, 107.1425), ["rotation"] = -5e-05 }); }, order: 416);
        raid.Schedule(TimeSpan.FromSeconds(27.195), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.ExecuteAction(28064, new Params { ["pos"] = new Position(87.7939, 0.0, 106.8565), ["rotation"] = -5e-05 }); }, order: 417);
        raid.Schedule(TimeSpan.FromSeconds(27.195), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.ExecuteAction(28063, new Params { ["pos"] = new Position(100.1651, 0.0, 86.001), ["rotation"] = -5e-05 }); }, order: 418);
        raid.Schedule(TimeSpan.FromSeconds(30.178), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(28062, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -0.01807, ["target"] = ActorDefinitions.Boss }); }, order: 419);
        raid.Schedule(TimeSpan.FromSeconds(31.179), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(null); }, order: 420);
        raid.Schedule(TimeSpan.FromSeconds(31.179), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(ActorDefinitions.Boss); }, order: 421);
        raid.Schedule(TimeSpan.FromSeconds(31.179), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(null); }, order: 422);
        raid.Schedule(TimeSpan.FromSeconds(31.179), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(ActorDefinitions.Boss); }, order: 423);
        raid.Schedule(TimeSpan.FromSeconds(31.179), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(null); }, order: 424);
        raid.Schedule(TimeSpan.FromSeconds(31.179), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(ActorDefinitions.Boss); }, order: 425);
        raid.Schedule(TimeSpan.FromSeconds(31.265), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.ExecuteAction(28065, new Params { ["pos"] = new Position(112.041, 0.0, 107.1425), ["rotation"] = -5e-05 }); }, order: 426);
        raid.Schedule(TimeSpan.FromSeconds(31.265), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.ExecuteAction(28064, new Params { ["pos"] = new Position(87.7939, 0.0, 106.8565), ["rotation"] = -5e-05 }); }, order: 427);
        raid.Schedule(TimeSpan.FromSeconds(31.265), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.ExecuteAction(28063, new Params { ["pos"] = new Position(100.1651, 0.0, 86.001), ["rotation"] = -5e-05 }); }, order: 428);
        raid.Schedule(TimeSpan.FromSeconds(33.115), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(null); }, order: 429);
        raid.Schedule(TimeSpan.FromSeconds(33.115), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(ActorDefinitions.Boss); }, order: 430);
        raid.Schedule(TimeSpan.FromSeconds(33.115), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetPosition(new Position(100.3663, 0.0, 92.0084), 3.09576); }, order: 431);
        raid.Schedule(TimeSpan.FromSeconds(33.115), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(null); }, order: 432);
        raid.Schedule(TimeSpan.FromSeconds(33.115), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(ActorDefinitions.Boss); }, order: 433);
        raid.Schedule(TimeSpan.FromSeconds(33.115), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetPosition(new Position(92.8959, 0.0, 103.6785), 2.31035); }, order: 434);
        raid.Schedule(TimeSpan.FromSeconds(33.115), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(null); }, order: 435);
        raid.Schedule(TimeSpan.FromSeconds(33.115), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(ActorDefinitions.Boss); }, order: 436);
        raid.Schedule(TimeSpan.FromSeconds(33.115), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetPosition(new Position(106.7378, 0.0, 104.3131), -1.6167); }, order: 437);
        raid.Schedule(TimeSpan.FromSeconds(33.182), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -0.04588); }, order: 438);
    }
}
