// 可重复的全副本和生命周期回归，不依赖游戏客户端。
using System.Text.Json;
using Kawari.Encounters;
using MechanicSim_Server.Manager;

var root=Path.GetFullPath(args.FirstOrDefault()??"resources/encounters/Definitions");
using var loader=new DefinitionLoader(root);
var output=Path.GetFullPath("target/ultimate-analysis/csharp-commands.jsonl");
using var trace=new StreamWriter(output,false,new System.Text.UTF8Encoding(false));
var checks=0;ulong sequence=0;
void Check(bool condition,string message){if(!condition)throw new Exception(message);checks++;}
void Submit(EncounterContext context,Simulation simulation)
{
    simulation.Apply(context.D.Commands);
    trace.WriteLine(JsonSerializer.Serialize(new OutputFrame(1,++sequence,context.D.Commands,context.Report())));
}
foreach(var content in new[]{"r1fz","n4gw","z3oz","d2az","z3oy","kefka_p2","w1fa_2"})
foreach(var count in new[]{1,8})
{
    trace.WriteLine();
    var simulation=new Simulation(count);var context=new EncounterContext(loader.Definitions[content].Build());
    var projectionMoves=new Dictionary<string,(int Slide,int Teleport)>();
    if(content=="d2az")foreach(var pair in context.Definition.Actors!.Templates.Where(v=>v.Value.Number("base")==11350))projectionMoves[pair.Key]=(0,0);
    context.Initialize(simulation.Frame(1,0,false));Submit(context,simulation);
    if(content!="w1fa_2")Check(simulation.Bindings.ContainsKey("trigger"),$"{content} 木桩不存在");
    for(var i=0;i<=3600;i++)
    {
        try{
            context.Advance(simulation.Frame((ulong)i+2,i*0.125,true));
            foreach(var operation in context.D.Commands)
                if(operation.method is "slide_actor" or "move_actor"&&operation.args[0] is ActorRef {Key:{} key}&&projectionMoves.TryGetValue(key,out var moves))
                    projectionMoves[key]=(moves.Slide+(operation.method=="slide_actor"?1:0),moves.Teleport+(operation.method=="move_actor"?1:0));
            Submit(context,simulation);
        }
        catch(Exception e){throw new Exception($"{content}/{count} 人，第 {i*0.125} 秒",e);}
    }
    Check(simulation.Counts.GetValueOrDefault("begin_cast")+simulation.Counts.GetValueOrDefault("cast")>0,$"{content} 无读条");
    Check(simulation.Counts.GetValueOrDefault("aoe_circle")+simulation.Counts.GetValueOrDefault("aoe_rect")+simulation.Counts.GetValueOrDefault("raidwide")>0,$"{content} 无结算");
    foreach(var (key,moves) in projectionMoves)Check(moves.Slide>0&&moves.Teleport==0,$"{count} 人投影 {key} 应通过 ActorMove 移动，实际 Move={moves.Slide}, SetPos={moves.Teleport}");
    if(content is "r1fz" or "n4gw" or "z3oz" or "d2az" or "z3oy")
    {
        Check(context.Phase=="battle",$"{content} 未开放最终本体");
        var catalog=context.Definition.Actors!;var id=simulation.Bindings[catalog.Boss];
        var death=JsonSerializer.SerializeToElement(new{kind="death",actor=id,@base=catalog.BossBase,pos=new[]{100,0,100}});
        context.Advance(simulation.Frame(5000,451,true,death));Submit(context,simulation);
        Check(context.Phase=="complete"&&simulation.Counts.GetValueOrDefault("complete_duty")==1,$"{content} 真实击杀未通关");
    }
    context.BeforeReplace();simulation.ClearEncounter();context=new EncounterContext(loader.Definitions[content].Build());trace.WriteLine();
    context.Initialize(simulation.Frame(6000,0,false));Submit(context,simulation);
    Check(!context.Timeline.Running,$"{content} 重置后自行开战");
    Console.WriteLine($"PASS {content}: {count} 人全程、死亡和重置");
}
// 单人可模拟珊瑚/钥匙/门与首领事件，覆盖原普通副本所有关键阶段。
{
    trace.WriteLine();
    var simulation=new Simulation(1);var c=new EncounterContext(loader.Definitions["s1d1_re"].Build());c.Initialize(simulation.Frame(1,0,false));Submit(c,simulation);
    void Event(object value){c.Advance(simulation.Frame(2,0,false,JsonSerializer.SerializeToElement(value)));Submit(c,simulation);}
    Event(new{kind="gimmick",actor=1,id=2000213,@params=new[]{0}});
    Event(new{kind="event_action",actor=1,target=2000216});
    Event(new{kind="death",actor=1001,@base=3988325,pos=new[]{100,0,100}});
    Event(new{kind="event_action",actor=1,target=2000255});
    Event(new{kind="death",actor=1002,@base=4035056,pos=new[]{100,0,100}});
    Event(new{kind="gimmick_rect",id=4069552});
    Event(new{kind="death",actor=1003,@base=3978771,pos=new[]{100,0,100}});
    Check(simulation.Counts.GetValueOrDefault("complete_duty")==1,"沙斯塔夏通关");
    Check(simulation.Counts.GetValueOrDefault("spawn_boss")==3,"沙斯塔夏阶段 Boss");
    Check(simulation.Counts.GetValueOrDefault("play_cutscene")==2,"沙斯塔夏过场");
}
{
    trace.WriteLine();
    var simulation=new Simulation(1);var c=new EncounterContext(loader.Definitions["m6d1"].Build());c.Initialize(simulation.Frame(1,0,false));Submit(c,simulation);
    c.Advance(simulation.Frame(2,0,false,JsonSerializer.SerializeToElement(new{kind="gimmick_rect",id=12110117})));Submit(c,simulation);
    for(var i=1;i<=3;i++){c.Advance(simulation.Frame((ulong)i+2,0,false,JsonSerializer.SerializeToElement(new{kind="variant_vote",vote=i})));Submit(c,simulation);}
    Check(simulation.Counts.GetValueOrDefault("variant_vote_route")==1&&simulation.Counts.GetValueOrDefault("map_effect")==3,"商客奇谭投票");
}
// 同帧顺序、条件超时、取消与原 MechanicSim 的等待后执行语义。
{
    var seen=new List<int>();var definition=new TimeLineDef{TimeLineName="scheduler",TimeLinePhaseList=[new("P",[new(){NodeName="N",Duration=1,Events=[new(0,2,_=>seen.Add(2)),new(0,1,_=>seen.Add(1))]},new(){NodeName="W",Duration=1,WaitUntil=_=>false,Timeout=1}])]};
    var c=new EncounterContext(definition);var sim=new Simulation(1);c.Initialize(sim.Frame(1,0,false));
    c.Advance(sim.Frame(2,0,true));Check(seen.SequenceEqual(new[]{1,2}),"同帧顺序");
    c.Advance(sim.Frame(3,3,true));Check(c.Phase=="stopped","条件超时必须停止");
    var ran=false;c.Schedule(1,_=>ran=true);c.Cancel();c.Advance(sim.Frame(4,5,false));Check(!ran,"取消后回调不得执行");
}
// 仇恨改变、施法锁面向、移动和取消使用当前服务器快照。
{
    trace.WriteLine();var sim=new Simulation(2);
    var c=new EncounterContext(new TimeLineDef{TimeLineName="motion",OnTimeLineInit=x=>x.D.Spawn("boss",new(){["base"]=9020,["name"]=1,["pos"]=Position.Center,["hp"]=10000}),OnBattleStart=x=>x.Motion.FaceEnmity("boss")});
    c.Initialize(sim.Frame(1,0,false));Submit(c,sim);c.Advance(sim.Frame(2,0,true));Submit(c,sim);
    var boss=sim.Bindings["boss"];Check(Math.Abs(sim.Actors[boss].rotation-Math.PI/2)<0.001,"本体面向最高仇恨");
    sim.Actors[2]=sim.Actors[2] with{pos=[100,0,110]};sim.Actors[boss]=sim.Actors[boss] with{enmity=[2,1]};
    c.Motion.LockFacing("boss",2);c.Advance(sim.Frame(3,1,true));Submit(c,sim);
    Check(Math.Abs(sim.Actors[boss].rotation-Math.PI/2)<0.001,"读条锁面向期间不得转向");
    c.Advance(sim.Frame(4,2,true));Submit(c,sim);Check(Math.Abs(sim.Actors[boss].rotation)<0.001,"锁定结束跟随新仇恨");
    c.Motion.MoveTo("boss",new Position(100,0,110),6);c.Advance(sim.Frame(5,2.5,true));Submit(c,sim);
    Check(Math.Abs(sim.Actors[boss].pos[2]-103)<0.001,"按服务器时间和速度移动");
    c.Cancel();var before=sim.Actors[boss].pos;c.Advance(sim.Frame(6,3,true));Submit(c,sim);Check(sim.Actors[boss].pos.SequenceEqual(before),"取消后停止持续运动");
}
// 编译未改动的原工程 Action，驱动原样时间轴写法走到真实原生协议。
{
    var fixture=Path.GetFullPath("target/ultimate-analysis/mechanicsim-fixtures");Directory.CreateDirectory(fixture);
    foreach(var file in Directory.GetFiles("controllers/EncounterHost.Tests/Fixtures","*.cs.txt"))File.Copy(file,Path.Combine(fixture,Path.GetFileNameWithoutExtension(file)),true);
    File.Copy(Path.Combine(root,"Global.cs"),Path.Combine(fixture,"Global.cs"),true);
    using var original=new DefinitionLoader(fixture);
    var sim=new Simulation(1);var c=new EncounterContext(original.Definitions["original-style"].Build());
    trace.WriteLine();c.Initialize(sim.Frame(1,0,false));Submit(c,sim);
    Check(sim.Bindings.ContainsKey("ms:1001"),"原 GameObject 构造自动生成模型");
    c.Advance(sim.Frame(2,0,true));Submit(c,sim);Check(!sim.Counts.ContainsKey("begin_cast"),"Duration 前禁止执行");
    c.Advance(sim.Frame(3,2,true));Submit(c,sim);Check(sim.Counts.GetValueOrDefault("begin_cast")==1,"原 TryCast 注册动作");
    c.Advance(sim.Frame(4,8.3,true));Submit(c,sim);Check(!sim.Counts.ContainsKey("play_action_targeted"),"读条完成前禁止结算");
    c.Advance(sim.Frame(5,8.4,true));Submit(c,sim);Check(sim.Counts.GetValueOrDefault("play_action_targeted")==1,"原 OnActionCastEnd Execute 语义");
    c.Advance(sim.Frame(6,11,true));Submit(c,sim);Check(!sim.Counts.ContainsKey("set_bgm"),"第二节点累计等待");
    c.Advance(sim.Frame(7,12,true));Submit(c,sim);Check(sim.Counts.GetValueOrDefault("set_bgm")==1,"第二节点在第十二秒执行");
    using(RaidManager.Enter(c))
    {
        var raid=RaidManager.Instance;var p=raid.Players[0];
        Check(p.StatusList.Single().Stack==4,"原状态层数同步");p.ReduceStatusStack(1002);Check(p.StatusList.Single().Stack==3,"原 ReduceStatusStack 同步原生层数");p.RemoveStatus(1002);Check(p.PlayerVar.ContainsKey("removed"),"原状态移除回调");
        var actor=raid.GetObjectByGameObjectId(1001)!;actor.TryCast(1004);actor.CurrentCast!.Cancel();
    }
    Submit(c,sim);var effects=sim.Counts.GetValueOrDefault("play_action_targeted");
    c.Advance(sim.Frame(8,20,true));Submit(c,sim);Check(sim.Counts.GetValueOrDefault("play_action_targeted")==effects,"取消读条不得执行旧动作");
    c.BeforeReplace();Check((bool)c.Definition.ScriptTimeline!.TimeLineVars["reset"],"原 OnTimeLineReset 已调用");
    Check(c.D.Find("ms:1001") is null,"重置销毁演员");
}
trace.Flush();
Console.WriteLine($"PASS {checks} assertions; {sequence} native batches; {loader.Definitions.Count} timelines");
