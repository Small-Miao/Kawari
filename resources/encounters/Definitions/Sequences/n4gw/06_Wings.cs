using Kawari.Encounters;
// 光与暗的孤翼 [40313]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Sequence06Wings
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(40313, TimeSpan.FromSeconds(6.6), new Params { ["spell"] = 40313, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 1.51718, ["target"] = ActorDefinitions.Boss }); }, order: 316);
        raid.Schedule(TimeSpan.FromSeconds(6.861), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(40313, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 1.51718, ["target"] = ActorDefinitions.Boss }); }, order: 323);
        raid.Schedule(TimeSpan.FromSeconds(7.144), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 1.05295); }, order: 325);
        raid.Schedule(TimeSpan.FromSeconds(7.144), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(40314, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 1.05295, ["target"] = ActorDefinitions.Boss }); }, order: 326);
        raid.Schedule(TimeSpan.FromSeconds(7.204), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(null); }, order: 327);
        raid.Schedule(TimeSpan.FromSeconds(7.204), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(ActorDefinitions.Boss); }, order: 328);
        raid.Schedule(TimeSpan.FromSeconds(7.204), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(93.9378, 0.0, 96.5), 1.0472); }, order: 329);
        raid.Schedule(TimeSpan.FromSeconds(7.285), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(40320, new Params { ["pos"] = new Position(93.9378, 0.0, 96.5), ["rotation"] = 1.0472, ["target"] = ActorDefinitions.Helper14 }); }, order: 331);
        raid.Schedule(TimeSpan.FromSeconds(7.884), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetOwner(null); }, order: 332);
        raid.Schedule(TimeSpan.FromSeconds(7.884), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetOwner(ActorDefinitions.Boss); }, order: 333);
        raid.Schedule(TimeSpan.FromSeconds(7.948), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(39879, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 1.51718 }); }, order: 334);
        raid.Schedule(TimeSpan.FromSeconds(8.582), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.Untether(0, 0); }, order: 335);
        raid.Schedule(TimeSpan.FromSeconds(10.732), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(null); }, order: 338);
        raid.Schedule(TimeSpan.FromSeconds(10.732), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(ActorDefinitions.Boss); }, order: 339);
        raid.Schedule(TimeSpan.FromSeconds(10.732), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(106.0622, 0.0, 96.5), -1.0472); }, order: 340);
        raid.Schedule(TimeSpan.FromSeconds(10.732), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 0.50004); }, order: 342);
        raid.Schedule(TimeSpan.FromSeconds(10.803), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(40320, new Params { ["pos"] = new Position(106.0622, 0.0, 96.5), ["rotation"] = -1.0472, ["target"] = ActorDefinitions.Helper14 }); }, order: 343);
        raid.Schedule(TimeSpan.FromSeconds(10.935), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(40315, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -0.7404, ["target"] = ActorDefinitions.Boss }); }, order: 344);
        raid.Schedule(TimeSpan.FromSeconds(11.146), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -0.7404); }, order: 345);
        raid.Schedule(TimeSpan.FromSeconds(11.71), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetModelState(0); }, order: 346);
        raid.Schedule(TimeSpan.FromSeconds(11.71), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetOwner(null); }, order: 347);
        raid.Schedule(TimeSpan.FromSeconds(11.71), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetOwner(ActorDefinitions.Boss); }, order: 348);
        raid.Schedule(TimeSpan.FromSeconds(11.71), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(39880, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 1.51718 }); }, order: 349);
        raid.Schedule(TimeSpan.FromSeconds(12.201), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.Untether(0, 0); }, order: 350);
        raid.Schedule(TimeSpan.FromSeconds(14.205), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(null); }, order: 351);
        raid.Schedule(TimeSpan.FromSeconds(14.205), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(ActorDefinitions.Boss); }, order: 352);
        raid.Schedule(TimeSpan.FromSeconds(14.205), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 107.0), -3.14159); }, order: 353);
        raid.Schedule(TimeSpan.FromSeconds(14.278), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(40320, new Params { ["pos"] = new Position(100.0, 0.0, 107.0), ["rotation"] = -3.14159, ["target"] = ActorDefinitions.Helper14 }); }, order: 355);
        raid.Schedule(TimeSpan.FromSeconds(15.352), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -0.95823); }, order: 356);
        raid.Schedule(TimeSpan.FromSeconds(15.703), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -1.27902); }, order: 357);
        raid.Schedule(TimeSpan.FromSeconds(15.981), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -1.43511); }, order: 358);
        raid.Schedule(TimeSpan.FromSeconds(16.504), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(40114, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -1.44853, ["target"] = ActorDefinitions.Boss }); }, order: 359);
        raid.Schedule(TimeSpan.FromSeconds(17.133), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(null); }, order: 360);
        raid.Schedule(TimeSpan.FromSeconds(17.133), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(ActorDefinitions.Boss); }, order: 361);
        raid.Schedule(TimeSpan.FromSeconds(17.133), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), -1.45649); }, order: 362);
        raid.Schedule(TimeSpan.FromSeconds(17.133), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetOwner(null); }, order: 363);
        raid.Schedule(TimeSpan.FromSeconds(17.133), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetOwner(ActorDefinitions.Boss); }, order: 364);
        raid.Schedule(TimeSpan.FromSeconds(17.133), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetPosition(new Position(100.0, 0.0, 100.0), -1.45649); }, order: 365);
        raid.Schedule(TimeSpan.FromSeconds(17.206), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -1.52916); }, order: 366);
        raid.Schedule(TimeSpan.FromSeconds(17.26), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(40115, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -1.45649 }); }, order: 367);
        raid.Schedule(TimeSpan.FromSeconds(17.26), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(40115, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -1.45649 }); }, order: 368);
        raid.Schedule(TimeSpan.FromSeconds(19.663), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(40114, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -1.53664, ["target"] = ActorDefinitions.Boss }); }, order: 369);
        raid.Schedule(TimeSpan.FromSeconds(20.304), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(null); }, order: 370);
        raid.Schedule(TimeSpan.FromSeconds(20.304), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetOwner(ActorDefinitions.Boss); }, order: 371);
        raid.Schedule(TimeSpan.FromSeconds(20.304), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), -1.53664); }, order: 372);
        raid.Schedule(TimeSpan.FromSeconds(20.304), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetOwner(null); }, order: 373);
        raid.Schedule(TimeSpan.FromSeconds(20.304), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetOwner(ActorDefinitions.Boss); }, order: 374);
        raid.Schedule(TimeSpan.FromSeconds(20.304), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetPosition(new Position(100.0, 0.0, 100.0), -1.53664); }, order: 375);
        raid.Schedule(TimeSpan.FromSeconds(20.383), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(40115, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -1.53664 }); }, order: 376);
        raid.Schedule(TimeSpan.FromSeconds(20.383), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(40115, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -1.53664 }); }, order: 377);
    }
}
