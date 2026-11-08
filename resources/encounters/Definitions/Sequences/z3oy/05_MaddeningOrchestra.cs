using Kawari.Encounters;
// 癫狂交响曲 [47952]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class Sequence05MaddeningOrchestra
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(47952, TimeSpan.FromSeconds(4.7), new Params { ["spell"] = 47952, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 2.25427, ["target"] = ActorDefinitions.Boss }); }, order: 141);
        raid.Schedule(TimeSpan.FromSeconds(4.971), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(47952, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 2.25427, ["target"] = ActorDefinitions.Boss }); }, order: 142);
        raid.Schedule(TimeSpan.FromSeconds(5.806), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(100.0, 0.0, 100.0), 2.25427); }, order: 143);
        raid.Schedule(TimeSpan.FromSeconds(5.806), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(100.0, 0.0, 100.0), 2.25427); }, order: 144);
        raid.Schedule(TimeSpan.FromSeconds(5.806), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), 2.25427); }, order: 145);
        raid.Schedule(TimeSpan.FromSeconds(5.806), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.SetPosition(new Position(100.0, 0.0, 100.0), 2.25427); }, order: 146);
        raid.Schedule(TimeSpan.FromSeconds(5.806), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.SetPosition(new Position(100.0, 0.0, 100.0), 2.25427); }, order: 147);
        raid.Schedule(TimeSpan.FromSeconds(5.878), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper12)?.ExecuteAction(47956, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 2.25427 }); }, order: 148);
        raid.Schedule(TimeSpan.FromSeconds(5.878), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(47956, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 2.25427 }); }, order: 149);
        raid.Schedule(TimeSpan.FromSeconds(5.878), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(47956, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 2.25427 }); }, order: 150);
        raid.Schedule(TimeSpan.FromSeconds(5.878), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(47954, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 2.25427 }); }, order: 151);
        raid.Schedule(TimeSpan.FromSeconds(5.878), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(47954, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 2.25427 }); }, order: 152);
        raid.Schedule(TimeSpan.FromSeconds(8.122), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(47953, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 2.25427, ["target"] = ActorDefinitions.Boss }); }, order: 153);
        raid.Schedule(TimeSpan.FromSeconds(9.019), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper13)?.ExecuteAction(47956, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 2.25427 }); }, order: 154);
        raid.Schedule(TimeSpan.FromSeconds(9.019), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(47956, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 2.25427 }); }, order: 155);
        raid.Schedule(TimeSpan.FromSeconds(9.019), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(47955, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 2.25427 }); }, order: 156);
        raid.Schedule(TimeSpan.FromSeconds(9.019), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(47956, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 2.25427 }); }, order: 157);
        raid.Schedule(TimeSpan.FromSeconds(11.222), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), 2.81974); }, order: 158);
        raid.Schedule(TimeSpan.FromSeconds(11.522), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.13977); }, order: 159);
        raid.Schedule(TimeSpan.FromSeconds(12.546), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(47958, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 2.25427 }); }, order: 160);
        raid.Schedule(TimeSpan.FromSeconds(12.546), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(47957, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = 2.25427 }); }, order: 161);
        raid.Schedule(TimeSpan.FromSeconds(16.339), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(50770, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.13977, ["target"] = ActorDefinitions.Boss }); }, order: 162);
        raid.Schedule(TimeSpan.FromSeconds(17.128), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.13977); }, order: 163);
        raid.Schedule(TimeSpan.FromSeconds(17.128), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.13977); }, order: 164);
        raid.Schedule(TimeSpan.FromSeconds(17.128), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.13977); }, order: 165);
        raid.Schedule(TimeSpan.FromSeconds(17.19), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(50772, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.13977 }); }, order: 166);
        raid.Schedule(TimeSpan.FromSeconds(17.19), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(50771, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.13977 }); }, order: 167);
        raid.Schedule(TimeSpan.FromSeconds(17.19), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(50773, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.13977 }); }, order: 168);
        raid.Schedule(TimeSpan.FromSeconds(19.477), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(50770, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.13977, ["target"] = ActorDefinitions.Boss }); }, order: 169);
        raid.Schedule(TimeSpan.FromSeconds(20.268), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.13977); }, order: 170);
        raid.Schedule(TimeSpan.FromSeconds(20.268), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.13977); }, order: 171);
        raid.Schedule(TimeSpan.FromSeconds(20.268), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.SetPosition(new Position(100.0, 0.0, 100.0), -3.13977); }, order: 172);
        raid.Schedule(TimeSpan.FromSeconds(20.268), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper14)?.ExecuteAction(50772, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.13977 }); }, order: 173);
        raid.Schedule(TimeSpan.FromSeconds(20.268), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper16)?.ExecuteAction(50771, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.13977 }); }, order: 174);
        raid.Schedule(TimeSpan.FromSeconds(20.268), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper15)?.ExecuteAction(50773, new Params { ["pos"] = new Position(100.0, 0.0, 100.0), ["rotation"] = -3.13977 }); }, order: 175);
    }
}
