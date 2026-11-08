using Kawari.Encounters;
// 凯夫卡 P2 一运的独立可选时间轴，默认妖星入口仍指向最终 P5。
using MechanicSim_Server.Manager;
using TimeLineDef = MechanicSim_Server.Struct.TimeLineDef;
using TimeLinePhase = MechanicSim_Server.Struct.TimeLinePhase;
using TimeLineNode = MechanicSim_Server.Struct.TimeLineNode;
namespace Script.Definitions.Timelines;

public sealed class KefkaP2 : MechanicSim_Server.Definition.ITimeLineDefinition
{
    public string DefinitionId => "kefka_p2";
    public TimeLineDef Build()
    {
        var a = new Script.Definitions.Actions.KefkaP2.Mechanics();
        var entries = new List<(double Time, string Name, Action<EncounterContext> Run)> { (3, "遗弃末世", a.Forsaken), (12, "咏唱危机点名", a.Markers) };
        double[] towers = [13.059, 23.089, 34.157, 44.191, 55.162, 65.236, 76.258, 86.266];
        for (var i = 0; i < towers.Length; i++) { var round = i; entries.Add((towers[i], $"第{i + 1}轮双塔", c => a.Towers(c, round))); }
        foreach (var times in new double[][] { [26.17, 32.916, 39.044], [47.074, 53.709, 59.981], [67.983, 74.657, 80.894], [88.927, 95.554, 101.897] })
        { entries.Add((times[0], "未来／过去终结", a.EndOfWorld)); entries.Add((times[1], "本体与分身跳跃", a.Jump)); entries.Add((times[2], "消灭之脚", a.Feet)); }
        var nodes = new List<TimeLineNode>(); double previous = 0;
        foreach (var e in entries.OrderBy(e => e.Time)) { var duration = e.Time - previous; previous = e.Time; nodes.Add(new() { NodeName = e.Name, Duration = TimeSpan.FromSeconds(duration), OnTimeLineEvent = () => e.Run(RaidManager.Instance.Context) }); }
        nodes.Add(new() { NodeName = "等待一运结算", Duration = TimeSpan.FromSeconds(10) });
        return new()
        {
            TimeLineName = "凯夫卡 P2 一运",
            TimeLinePhaseList = [new() { PhaseName = "P2 一运", TimeLineNodes = nodes }],
            NativeEncounter = new Kawari.Encounters.TimeLineDef
            {
                TimeLineName = "凯夫卡 P2 一运",
                Actors = new() { Boss = "boss", BossBase = 19506 },
                OnTimeLineInit = c => { c.D.Flag(1); c.D.ResetOnDeaggro(false); a.Initial(c); a.Setup(c); var dummy = c.D.Spawn("trigger", new() { ["base"] = 11744, ["name"] = 541, ["hp"] = 99999999, ["level"] = 1, ["pos"] = Position.Center, ["rotation"] = Math.PI, ["targetable"] = true, ["boss"] = true }); c.D.ArmTrigger(dummy); c.D.Ai(dummy, true); },
                OnBattleStart = c => { c.Phase = "battle"; c.D.Despawn("trigger"); c.D.Targetable(c.Boss!.Value, true); c.Motion.FaceEnmity(c.Boss.Value); },
                OnStop = a.Initial,
                OnEvent = (c, e) => { var kind = e.GetProperty("kind").GetString(); if (kind == "death" && c.Phase == "battle" && c.D.Resolve(c.Boss!.Value) == e.GetProperty("actor").GetUInt32()) c.Complete(); if (kind == "gimmick") { var player = e.GetProperty("actor").GetUInt32(); if (e.GetProperty("id").GetUInt32() == 2000139) c.D.Emit("abandon_duty", player); c.D.Emit("finish_gimmick", player); } }
            }
        };
    }
}
