using Kawari.Encounters;
// 潘多拉魔盒 [40326]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class Sequence11PandorasBox
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(40326, TimeSpan.FromSeconds(11.7), new Params { ["spell"] = 40326, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -1.75562, ["target"] = ActorDefinitions.Boss }); }, order: 936);
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -1.75562); }, order: 937);
        raid.Schedule(TimeSpan.FromSeconds(11.942), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(40326, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -1.75562, ["target"] = ActorDefinitions.Boss }); }, order: 940);
        raid.Schedule(TimeSpan.FromSeconds(18.071), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -1.34575); }, order: 942);
    }
}
