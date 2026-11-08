using Kawari.Encounters;
// 宇宙记忆 [31649]：演员 / 读条 / 技能 / 状态。
// At 为节点相对秒数，Order 保留同帧顺序。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oz;
public static class Sequence03CosmoMemory
{
    public static void Execute()
    {
        var raid = RaidManager.Instance;
        raid.Schedule(TimeSpan.FromSeconds(0.0), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.TryCast(31649, TimeSpan.FromSeconds(5.7), new Params { ["spell"] = 31649, ["omen_delay"] = 0, ["cast_pos"] = new Position(99.9924, -0.0153, 99.9924), ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.13028, ["target"] = ActorDefinitions.Boss }); }, order: 41);
        raid.Schedule(TimeSpan.FromSeconds(5.951), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(31649, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.13028, ["target"] = ActorDefinitions.Boss }); }, order: 42);
        raid.Schedule(TimeSpan.FromSeconds(10.098), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(31747, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = 3.13028, ["target"] = ActorDefinitions.Boss }); }, order: 43);
        raid.Schedule(TimeSpan.FromSeconds(10.891), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper32)?.SetOwner(ActorDefinitions.Boss); }, order: 44);
        raid.Schedule(TimeSpan.FromSeconds(10.891), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper31)?.SetOwner(ActorDefinitions.Boss); }, order: 45);
        raid.Schedule(TimeSpan.FromSeconds(10.891), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper31)?.ExecuteAction(32223, new Params { ["pos"] = new Position(119.1128, 0.0, 100.9695), ["rotation"] = -1.02524 }); }, order: 46);
        raid.Schedule(TimeSpan.FromSeconds(10.891), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper32)?.ExecuteAction(32223, new Params { ["pos"] = new Position(100.0, 0.0732, 100.0), ["rotation"] = -5e-05 }); }, order: 47);
        raid.Schedule(TimeSpan.FromSeconds(11.296), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.SetPosition(new Position(99.9924, -0.0153, 99.9924), -3.07649); }, order: 48);
        raid.Schedule(TimeSpan.FromSeconds(13.197), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Boss)?.ExecuteAction(31747, new Params { ["pos"] = new Position(99.9924, -0.0153, 99.9924), ["rotation"] = -3.07649, ["target"] = ActorDefinitions.Boss }); }, order: 49);
        raid.Schedule(TimeSpan.FromSeconds(13.989), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper32)?.SetOwner(null); }, order: 50);
        raid.Schedule(TimeSpan.FromSeconds(13.989), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper32)?.SetOwner(ActorDefinitions.Boss); }, order: 51);
        raid.Schedule(TimeSpan.FromSeconds(13.989), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper31)?.SetOwner(null); }, order: 52);
        raid.Schedule(TimeSpan.FromSeconds(13.989), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper31)?.SetOwner(ActorDefinitions.Boss); }, order: 53);
        raid.Schedule(TimeSpan.FromSeconds(13.989), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper31)?.ExecuteAction(32223, new Params { ["pos"] = new Position(119.1128, 0.0, 100.9695), ["rotation"] = -1.02524 }); }, order: 54);
        raid.Schedule(TimeSpan.FromSeconds(13.989), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper32)?.ExecuteAction(32223, new Params { ["pos"] = new Position(100.0, 0.0732, 100.0), ["rotation"] = -5e-05 }); }, order: 55);
        raid.Schedule(TimeSpan.FromSeconds(14.217), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper30)?.SetOwner(ActorDefinitions.Boss); }, order: 56);
        raid.Schedule(TimeSpan.FromSeconds(14.217), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper30)?.SetPosition(new Position(85.0, 0.0, 80.0), -5e-05); }, order: 57);
        raid.Schedule(TimeSpan.FromSeconds(14.217), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper29)?.SetOwner(ActorDefinitions.Boss); }, order: 58);
        raid.Schedule(TimeSpan.FromSeconds(14.217), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper29)?.SetPosition(new Position(85.0, 0.0, 80.0), -5e-05); }, order: 59);
        raid.Schedule(TimeSpan.FromSeconds(14.238), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper28)?.SetOwner(ActorDefinitions.Boss); }, order: 60);
        raid.Schedule(TimeSpan.FromSeconds(14.238), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper28)?.SetPosition(new Position(120.0, 0.0, 85.0), -1.57087); }, order: 61);
        raid.Schedule(TimeSpan.FromSeconds(14.238), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper27)?.SetOwner(ActorDefinitions.Boss); }, order: 62);
        raid.Schedule(TimeSpan.FromSeconds(14.238), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper27)?.SetPosition(new Position(120.0, 0.0, 85.0), -1.57087); }, order: 63);
        raid.Schedule(TimeSpan.FromSeconds(14.238), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper26)?.SetOwner(ActorDefinitions.Boss); }, order: 64);
        raid.Schedule(TimeSpan.FromSeconds(14.238), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper26)?.SetPosition(new Position(115.0, 0.0, 120.0), -3.14159); }, order: 65);
        raid.Schedule(TimeSpan.FromSeconds(14.238), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper25)?.SetOwner(ActorDefinitions.Boss); }, order: 66);
        raid.Schedule(TimeSpan.FromSeconds(14.238), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper25)?.SetPosition(new Position(115.0, 0.0, 120.0), -3.14159); }, order: 67);
        raid.Schedule(TimeSpan.FromSeconds(14.238), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper24)?.SetOwner(ActorDefinitions.Boss); }, order: 68);
        raid.Schedule(TimeSpan.FromSeconds(14.238), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper24)?.SetPosition(new Position(80.0, 0.0, 115.0), 1.57077); }, order: 69);
        raid.Schedule(TimeSpan.FromSeconds(14.238), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper23)?.SetOwner(ActorDefinitions.Boss); }, order: 70);
        raid.Schedule(TimeSpan.FromSeconds(14.238), () => { raid.GetObjectByGameObjectId(ActorDefinitions.Helper23)?.SetPosition(new Position(80.0, 0.0, 115.0), 1.57077); }, order: 71);
    }
}
