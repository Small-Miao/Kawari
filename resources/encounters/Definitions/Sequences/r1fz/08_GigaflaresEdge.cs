using Kawari.Encounters;
// 十亿核爆剑 [28057]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.r1fz;
public static class Sequence08GigaflaresEdge
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(28057, TimeSpan.FromSeconds(7.7), new Params { ["spell"] = 28057, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 0.01625, ["target"] = ActorDefinitions.Boss }); }, order: 702);
        raid.Schedule(TimeSpan.FromSeconds(0.062), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.TryCast(28115, TimeSpan.FromSeconds(16.7), new Params { ["spell"] = 28115, ["omen_delay"] = 54, ["cast_pos"] = new Position(112.2301, -0.0153, 106.7979), ["pos"] = new Position(112.2368, 0.0, 106.8015), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper08 }); }, order: 703);
        raid.Schedule(TimeSpan.FromSeconds(0.062), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.TryCast(28114, TimeSpan.FromSeconds(12.7), new Params { ["spell"] = 28114, ["omen_delay"] = 36, ["cast_pos"] = new Position(87.9683, -0.0153, 107.1946), ["pos"] = new Position(87.9913, 0.0, 107.1966), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper09 }); }, order: 704);
        raid.Schedule(TimeSpan.FromSeconds(0.062), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.TryCast(28058, TimeSpan.FromSeconds(8.7), new Params { ["spell"] = 28058, ["omen_delay"] = 18, ["cast_pos"] = new Position(99.7482, -0.0153, 85.9846), ["pos"] = new Position(99.7719, 0.0, 86.0019), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper10 }); }, order: 705);
        raid.Schedule(TimeSpan.FromSeconds(0.936), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ApplyStatuses(new StatusSpec[] { new StatusSpec(2056, 299, 0) }); }, order: 706);
        raid.Schedule(TimeSpan.FromSeconds(2.231), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ApplyStatuses(new StatusSpec[] { new StatusSpec(2056, 299, 0) }); }, order: 707);
        raid.Schedule(TimeSpan.FromSeconds(5.285), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ApplyStatuses(new StatusSpec[] { new StatusSpec(2056, 299, 0) }); }, order: 708);
        raid.Schedule(TimeSpan.FromSeconds(8.048), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(28057, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 0.01625, ["target"] = ActorDefinitions.Boss }); }, order: 709);
        raid.Schedule(TimeSpan.FromSeconds(8.048), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ApplyStatuses(new StatusSpec[] { new StatusSpec(2056, 299, 0) }); }, order: 710);
        raid.Schedule(TimeSpan.FromSeconds(8.305), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ApplyStatuses(new StatusSpec[] { new StatusSpec(2056, 299, 0) }); }, order: 711);
        raid.Schedule(TimeSpan.FromSeconds(8.985), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.ExecuteAction(28058, new Params { ["pos"] = new Position(99.7719, 0.0, 86.0019), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper10 }); }, order: 712);
        raid.Schedule(TimeSpan.FromSeconds(9.128), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.SetOwner(null); }, order: 713);
        raid.Schedule(TimeSpan.FromSeconds(9.128), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.SetOwner(ActorDefinitions.Boss); }, order: 714);
        raid.Schedule(TimeSpan.FromSeconds(9.128), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.SetPosition(new Position(100.0, 0.0, 100.0), 0.01625); }, order: 715);
        raid.Schedule(TimeSpan.FromSeconds(9.211), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper07)?.ExecuteAction(28050, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 0.01625, ["target"] = ActorDefinitions.Helper07 }); }, order: 716);
        raid.Schedule(TimeSpan.FromSeconds(12.16), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 1.13464); }, order: 717);
        raid.Schedule(TimeSpan.FromSeconds(12.461), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 2.02273); }, order: 718);
        raid.Schedule(TimeSpan.FromSeconds(12.95), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.ExecuteAction(28114, new Params { ["pos"] = new Position(87.9913, 0.0, 107.1966), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper09 }); }, order: 719);
        raid.Schedule(TimeSpan.FromSeconds(13.887), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 2.22109); }, order: 720);
        raid.Schedule(TimeSpan.FromSeconds(14.197), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 2.48609); }, order: 721);
        raid.Schedule(TimeSpan.FromSeconds(14.508), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 2.75943); }, order: 722);
        raid.Schedule(TimeSpan.FromSeconds(14.825), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 3.0136); }, order: 723);
        raid.Schedule(TimeSpan.FromSeconds(15.346), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.05042); }, order: 724);
        raid.Schedule(TimeSpan.FromSeconds(15.672), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -2.89443); }, order: 725);
        raid.Schedule(TimeSpan.FromSeconds(16.997), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.ExecuteAction(28115, new Params { ["pos"] = new Position(112.2368, 0.0, 106.8015), ["rotation"] = -5e-05, ["target"] = ActorDefinitions.Helper08 }); }, order: 726);
        raid.Schedule(TimeSpan.FromSeconds(17.13), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -2.74352); }, order: 727);
        raid.Schedule(TimeSpan.FromSeconds(17.621), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -2.38753); }, order: 728);
        raid.Schedule(TimeSpan.FromSeconds(18.155), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -2.57344); }, order: 729);
        raid.Schedule(TimeSpan.FromSeconds(18.474), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -2.795); }, order: 730);
        raid.Schedule(TimeSpan.FromSeconds(18.807), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -2.9416); }, order: 731);
        raid.Schedule(TimeSpan.FromSeconds(19.321), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.06652); }, order: 732);
        raid.Schedule(TimeSpan.FromSeconds(19.679), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.09691); }, order: 733);
        raid.Schedule(TimeSpan.FromSeconds(19.986), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.11829); }, order: 734);
        raid.Schedule(TimeSpan.FromSeconds(20.564), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.14006); }, order: 735);
        raid.Schedule(TimeSpan.FromSeconds(26.223), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(28062, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.13076, ["target"] = ActorDefinitions.Boss }); }, order: 736);
        raid.Schedule(TimeSpan.FromSeconds(27.212), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(null); }, order: 737);
        raid.Schedule(TimeSpan.FromSeconds(27.212), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(ActorDefinitions.Boss); }, order: 738);
        raid.Schedule(TimeSpan.FromSeconds(27.212), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(null); }, order: 739);
        raid.Schedule(TimeSpan.FromSeconds(27.212), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(ActorDefinitions.Boss); }, order: 740);
        raid.Schedule(TimeSpan.FromSeconds(27.212), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(null); }, order: 741);
        raid.Schedule(TimeSpan.FromSeconds(27.212), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(ActorDefinitions.Boss); }, order: 742);
        raid.Schedule(TimeSpan.FromSeconds(27.244), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.ExecuteAction(28065, new Params { ["pos"] = new Position(112.2368, 0.0, 106.8015), ["rotation"] = -5e-05 }); }, order: 743);
        raid.Schedule(TimeSpan.FromSeconds(27.244), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.ExecuteAction(28064, new Params { ["pos"] = new Position(87.9913, 0.0, 107.1966), ["rotation"] = -5e-05 }); }, order: 744);
        raid.Schedule(TimeSpan.FromSeconds(27.244), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.ExecuteAction(28063, new Params { ["pos"] = new Position(99.7719, 0.0, 86.0019), ["rotation"] = -5e-05 }); }, order: 745);
        raid.Schedule(TimeSpan.FromSeconds(30.257), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(28062, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.13076, ["target"] = ActorDefinitions.Boss }); }, order: 746);
        raid.Schedule(TimeSpan.FromSeconds(31.255), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(null); }, order: 747);
        raid.Schedule(TimeSpan.FromSeconds(31.255), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(ActorDefinitions.Boss); }, order: 748);
        raid.Schedule(TimeSpan.FromSeconds(31.255), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(null); }, order: 749);
        raid.Schedule(TimeSpan.FromSeconds(31.255), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(ActorDefinitions.Boss); }, order: 750);
        raid.Schedule(TimeSpan.FromSeconds(31.255), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(null); }, order: 751);
        raid.Schedule(TimeSpan.FromSeconds(31.255), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(ActorDefinitions.Boss); }, order: 752);
        raid.Schedule(TimeSpan.FromSeconds(31.255), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.ExecuteAction(28065, new Params { ["pos"] = new Position(112.2368, 0.0, 106.8015), ["rotation"] = -5e-05 }); }, order: 753);
        raid.Schedule(TimeSpan.FromSeconds(31.255), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.ExecuteAction(28064, new Params { ["pos"] = new Position(87.9913, 0.0, 107.1966), ["rotation"] = -5e-05 }); }, order: 754);
        raid.Schedule(TimeSpan.FromSeconds(31.255), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.ExecuteAction(28063, new Params { ["pos"] = new Position(99.7719, 0.0, 86.0019), ["rotation"] = -5e-05 }); }, order: 755);
        raid.Schedule(TimeSpan.FromSeconds(33.146), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(null); }, order: 756);
        raid.Schedule(TimeSpan.FromSeconds(33.146), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetOwner(ActorDefinitions.Boss); }, order: 757);
        raid.Schedule(TimeSpan.FromSeconds(33.146), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper10)?.SetPosition(new Position(99.914, 0.0, 107.9995), -0.01079); }, order: 758);
        raid.Schedule(TimeSpan.FromSeconds(33.146), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(null); }, order: 759);
        raid.Schedule(TimeSpan.FromSeconds(33.146), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetOwner(ActorDefinitions.Boss); }, order: 760);
        raid.Schedule(TimeSpan.FromSeconds(33.146), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper09)?.SetPosition(new Position(106.9708, 0.0, 96.0747), -0.01079); }, order: 761);
        raid.Schedule(TimeSpan.FromSeconds(33.146), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(null); }, order: 762);
        raid.Schedule(TimeSpan.FromSeconds(33.146), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetOwner(ActorDefinitions.Boss); }, order: 763);
        raid.Schedule(TimeSpan.FromSeconds(33.146), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper08)?.SetPosition(new Position(93.1152, 0.0, 95.9257), 0.77462); }, order: 764);
    }
}
