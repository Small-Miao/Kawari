using System.Text.Json;
using Kawari.Encounters;
using MechanicSim_Server.Manager;

// 欧米茄音乐必须在过场释放后交接，旧转场任务不能污染重置后的场景。
internal static class TopMusicRegression
{
    private sealed record Cue(double Time,uint Event,uint Value);

    public static void Run(DefinitionLoader loader,Action<bool,string> check,Action<EncounterContext,Simulation> submit,Action beginTrace)
    {
        foreach(var step in new[]{0.125,5.0})
        {
            var simulation=new Simulation(1);
            var context=new EncounterContext(loader.Definitions["z3oz"].Build());
            var cues=new List<Cue>();
            ulong sequence=0;
            void Capture()
            {
                foreach(var operation in context.D.Commands)
                {
                    var args=JsonSerializer.SerializeToElement(operation.args);
                    if(operation.method=="set_bgm")cues.Add(new(context.Time,0x80000001,args[0].GetUInt32()));
                    else if(operation.method=="director_event")
                    {
                        var id=args[0].GetUInt32();
                        if(id is 0x80000001 or 0x80000005 or 0x8000001A or 0x8000001B)
                            cues.Add(new(context.Time,id,args[1][0].GetUInt32()));
                    }
                }
                submit(context,simulation);
            }
            void Advance(double time,bool battle=true)
            {
                context.Advance(simulation.Frame(++sequence,time,battle));Capture();
            }
            void Initialize()
            {
                beginTrace();
                context.Initialize(simulation.Frame(++sequence,0,false));Capture();
                check(cues.Count>=2&&cues[^2] is {Event:0x80000001,Value:964},"欧米茄入场应先保存非零恢复曲目 964");
                check(cues.LastOrDefault() is {Event:0x80000005,Value:0},"欧米茄入场应解除临时音乐覆盖");
                check(simulation.Bindings.ContainsKey("trigger"),"欧米茄入场应生成木桩");
            }
            void Transition()
            {
                for(var i=0;i<=Math.Ceiling(70/step);i++)Advance(i*step);
                var begin=cues.FindIndex(c=>c.Event==0x8000001A);
                var end=cues.FindIndex(c=>c.Event==0x8000001B);
                check(begin>=0&&end>begin,"欧米茄应依次开始与结束过场");
                check(cues.Skip(begin+1).Take(end-begin-1).Any(c=>c.Event==0x80000001&&c.Value==951),"保留欧米茄录像中的过场内切曲");
                check(cues.Skip(end+1).Any(c=>c.Event==0x80000001&&c.Value==951),$"欧米茄过场结束后必须交接最终阶段曲目 951（步长 {step}）");
                var clear=cues.FindIndex(end+1,c=>c.Event==0x80000005&&c.Value==0);
                check(clear>end&&cues.Skip(clear+1).Any(c=>c.Event==0x80000001&&c.Value==951),"结束过场后应先解除临时覆盖，再设置最终曲目");
                check(cues.LastOrDefault() is {Event:0x80000001,Value:951},"最终阶段音乐不得被过场结束操作覆盖");
            }

            Initialize();Transition();
            context.D.Commands.Clear();
            using(RaidManager.Enter(context))context.Stop("音乐回归：停止最终阶段");
            Capture();
            check(cues[^2] is {Event:0x80000001,Value:964},"停止最终阶段应保存前阶段曲目");
            check(cues.LastOrDefault() is {Event:0x80000005,Value:0},"停止最终阶段应解除临时音乐覆盖并恢复曲目");
            var count=cues.Count;Advance(100,false);
            check(cues.Count==count,"停止后不得继续发送旧音乐任务");

            // 中途取消后重新创建，与世界服 reset/reload 的候选替换路径一致。
            foreach(var stopAt in new[]{14.5,60.0,67.3})
            {
                context.BeforeReplace();simulation.ClearEncounter();
                context=new EncounterContext(loader.Definitions["z3oz"].Build());cues.Clear();Initialize();
                Advance(0);Advance(stopAt);
                context.D.Commands.Clear();
                using(RaidManager.Enter(context))context.Stop("音乐回归：取消转场");
                Capture();
                check(cues[^2] is {Event:0x80000001,Value:964},"取消转场应保存恢复曲目 964");
                check(cues.LastOrDefault() is {Event:0x80000005,Value:0},"取消转场应解除临时音乐覆盖并恢复曲目");
                count=cues.Count;Advance(100,false);
                check(cues.Count==count,"取消转场后不得延迟切入曲目 951");
            }
            context.BeforeReplace();simulation.ClearEncounter();
            context=new EncounterContext(loader.Definitions["z3oz"].Build());cues.Clear();Initialize();Transition();
        }
        Console.WriteLine("PASS z3oz: 过场音乐交接、低帧率、停止与重新触发");
    }
}
