// 无第三方测试依赖：协议边界、证据语义、跨录像合并、工程和真实录像回归。
using System.Buffers.Binary;
using System.Text;
using System.Text.Json;
using ReplayAnalyzer.Core;

var root=Path.GetFullPath("target/replay-analyzer-tests");Directory.CreateDirectory(root);
var checks=0;void Check(bool value,string why){if(!value)throw new Exception(why);checks++;}
void Reject(Action action,string why){try{action();}catch(InvalidDataException){checks++;return;}throw new Exception("没有拒绝："+why);}
void U16(byte[] b,int at,ushort v)=>BinaryPrimitives.WriteUInt16LittleEndian(b.AsSpan(at),v);
void U32(byte[] b,int at,uint v)=>BinaryPrimitives.WriteUInt32LittleEndian(b.AsSpan(at),v);
byte[] Packet(ushort op,uint ms,uint actor,byte[] body){var b=new byte[12+body.Length];U16(b,0,op);U16(b,2,(ushort)body.Length);U32(b,4,ms);U32(b,8,actor);body.CopyTo(b,12);return b;}
string Fixture(string name,byte[][] packets,int build=14101351,uint timestamp=0){var b=new byte[876+packets.Sum(p=>p.Length)];"FFXIVREPLAY"u8.CopyTo(b);U16(b,12,5);U32(b,16,(uint)build);U32(b,20,timestamp);U32(b,24,5000);U16(b,32,694);U32(b,72,(uint)b.Length-876);var at=876;foreach(var p in packets){p.CopyTo(b,at);at+=p.Length;}var file=Path.Combine(root,name);File.WriteAllBytes(file,b);return file;}
var npc=new byte[656];U32(npc,64,11349);U32(npc,68,1);
var cast=new byte[32];U16(cast,0,18583);U32(cast,4,18583);U32(cast,8,(uint)BitConverter.SingleToInt32Bits(3));U32(cast,12,0x10000001);
var effect=new byte[124];U32(effect,8,18583);U16(effect,28,18583);effect[33]=1;effect[42]=3;effect[46]=1;effect[47]=0x40;U16(effect,48,4464);U32(effect,112,0x10000001);
var unknown=(byte[])effect.Clone();Array.Clear(unknown,42,64);unknown[42]=61;
var map=new byte[16];U16(map,4,4);U16(map,6,8);map[8]=5;
var profile=new ProtocolProfile();var reader=new ReplayReader(profile);
var path=Fixture("sample.dat",[Packet(276,0,0x40000001,npc),Packet(769,1000,0x40000001,cast),Packet(189,4000,0x40000001,effect),Packet(422,4000,0,map),Packet(189,4500,0x40000001,unknown)]);
var r=reader.Read(path);PhaseAnalysis.Initialize(r);Relationships.Build(r,new());
Check(r.Events.Count==5,"关键包数量");var hit=r.Events.Single(e=>e.Kind=="技能效果"&&e.Ms==4000);
Check(hit.Effects.Single().Value==70000,"24 位伤害量");Check(hit.Roles.HasFlag(EventRole.Result|EventRole.Visual),"判定和演出可以同时存在");
Check(r.Events.Single(e=>e.Ms==4500).Roles.HasFlag(EventRole.Unknown)&&!r.Events.Single(e=>e.Ms==4500).Roles.HasFlag(EventRole.Result),"未知效果不能当作已确认判定或纯演出");
Check(hit.Related.Any(l=>l.Confidence=="高"),"同演员同技能读条和效果关联");
Check(r.Events.Single(e=>e.Kind=="MapEffect").Related.All(l=>l.Confidence=="低"),"地图邻近关系只能是候选");
var bad=Fixture("wrong-build.dat",[],1);Reject(()=>reader.Read(bad),"未知 build");
var truncated=Path.Combine(root,"truncated.dat");File.WriteAllBytes(truncated,File.ReadAllBytes(path)[..^1]);Reject(()=>reader.Read(truncated),"截断录像");
var tooMany=(byte[])effect.Clone();tooMany[33]=2;Reject(()=>reader.Read(Fixture("targets.dat",[Packet(189,1000,0x40000001,tooMany)])),"目标数越界");
Reject(()=>reader.Read(Fixture("short.dat",[Packet(769,1,0x40000001,new byte[4])])),"已知包短负载");
Reject(()=>reader.Read(Fixture("rsv.dat",[Packet(61441,0,0,new byte[53])])),"RSV 长度不匹配");
var nanCast=(byte[])cast.Clone();U32(nanCast,8,(uint)BitConverter.SingleToInt32Bits(float.NaN));Reject(()=>reader.Read(Fixture("nan.dat",[Packet(769,1,0x40000001,nanCast)])),"非有限读条时间");
var r2=reader.Read(Fixture("sample2.dat",[Packet(276,0,0x40000001,npc),Packet(769,1000,0x40000001,cast),Packet(189,4100,0x40000001,effect),Packet(422,4100,0,map),Packet(189,4600,0x40000001,unknown)],timestamp:1));PhaseAnalysis.Initialize(r2);
var merged=Merger.Merge([r,r2],1.5);Check(merged.Sum(g=>g.Observations.Count)==r.Events.Count+r2.Events.Count,"合并保留所有观察");
Check(merged.Where(g=>g.Kind=="技能效果").Count()==2,"同录像的近邻重复技能不得合成一条");
Check(merged.Any(g=>g.SourceCount==2),"两录像可以对齐");Check(Merger.Merge([r,r],1.5).Sum(g=>g.Observations.Count)==r.Events.Count,"相同 SHA 不能重复计数");
PhaseAnalysis.Split(r,3000,"P2 测试");Check(r.Phases.Count==2&&hit.PhaseId==r.Phases[1].Id,"手工阶段拆分");
r.Annotations[hit.Id]=new(){Roles=EventRole.Result,RelatedAction=123,Note="人工复核"};
var project=Path.Combine(root,"project.json");WorkspaceFiles.SaveProject(project,[r],"",1.5);var loaded=WorkspaceFiles.ReadProject(project);var reread=reader.Read(path);WorkspaceFiles.Apply(reread,loaded.Recordings[0]);
Check(reread.Phases[1].Name=="P2 测试"&&reread.Annotations[hit.Id].RelatedAction==123,"工程恢复阶段及人工关联");
Check(SkillAnalysis.Summarize(r,r.Events,new()).Any(s=>s.Action==123&&s.Results==1),"人工技能关联参与汇总");
var mapEvent=r.Events.Single(e=>e.Kind=="MapEffect");r.Annotations[mapEvent.Id]=new(){RelatedAction=123};
Check(SkillAnalysis.Summarize(r,r.Events,new()).Single(s=>s.Action==123).MapLinks==1,"人工地图关联参与技能汇总");
var catalogFixture=new GameCatalog();catalogFixture.Actions[18583]=new(18583,"测试",0,0,0,0,1);catalogFixture.Enrich(r);Check(r.Events.Any(e=>e.Roles.HasFlag(EventRole.Omen)),"加载预兆配置");new GameCatalog().Enrich(r);Check(r.Events.All(e=>!e.Roles.HasFlag(EventRole.Omen)),"更换资源表清除过期预兆标记");
var gap=new ProjectRecording(path,r.Sha256,[new(){StartMs=0,EndMs=2000},new(){StartMs=3000,EndMs=5001,AnchorMs=3000}],[]);Reject(()=>WorkspaceFiles.Apply(reread,gap),"拒绝阶段空隙，避免漏掉事件");Check(reread.Events.All(e=>e.PhaseId.Length>0),"坏工程不会破坏原分段");
Reject(()=>WorkspaceFiles.Apply(r2,loaded.Recordings[0]),"不同录像不能应用工程标注");
var player=reread.Events.First(e=>e.Kind=="读条");var npcKey=player.Actor;
reread.Actors["pet"]=new(){Key="pet",Id=0x40000033,Kind="npc",Owner=0x10000001};
var petEvent=new ReplayEvent{Id=99999,Ms=4200,PhaseId=reread.Phases[1].Id,Kind="技能效果",Actor="pet",Action=18583,Roles=EventRole.Result};reread.Events.Add(petEvent);
Check(reread.IsPlayerSkill(petEvent),"玩家召唤物技能自动识别");Check(!reread.IsPlayerSkill(player),"Boss 使用相同技能仍然保留");
var groupCatalog=new GameCatalog();groupCatalog.Actions[18583]=new(18583,"时间牢狱",0,0,0,0,0);groupCatalog.Actions[18584]=new(18584,"时间牢狱",0,0,0,0,0);
var helperEvent=new ReplayEvent{Id=99998,Ms=4300,PhaseId=reread.Phases[1].Id,Kind="技能效果",Actor=npcKey,Action=18584,Roles=EventRole.Result};reread.Events.Add(helperEvent);
var groups=MechanicAnalysis.Build([reread],groupCatalog);var group=groups.Single(g=>g.Phase=="P2 测试"&&g.Name=="时间牢狱");
Check(group.Actions.SequenceEqual(new uint[]{18583,18584}),"同名机制的不同技能 ID 自动归组");Check(groups.All(g=>g.Observations.All(o=>o.EventId!=petEvent.Id)),"机制分组排除宠物技能");
Check(group.Observations.Count(o=>o.Primary&&o.Action==18583)==2,"同机制的重复调用全部保留");
var otherEvent=new ReplayEvent{Id=99997,Ms=4400,PhaseId=reread.Phases[1].Id,Kind="技能效果",Actor=npcKey,Action=20000,Roles=EventRole.Visual};reread.Events.Add(otherEvent);groups=MechanicAnalysis.Build([reread],groupCatalog);
MechanicAnalysis.NameGroups([reread],groups.Where(g=>g.Phase=="P2 测试"),"最终机制");
var named=MechanicAnalysis.Build([reread],groupCatalog).Single(g=>g.Phase=="P2 测试");Check(named.Name=="最终机制"&&named.Actions.Count==3,"不同名称可人工合并机制组");
WorkspaceFiles.SaveProject(project,[reread],"",1.5);Check(WorkspaceFiles.ReadProject(project).Recordings[0].Annotations[helperEvent.Id].Mechanic=="最终机制","人工机制组保存到工程");
WorkspaceFiles.ExportMechanics(Path.Combine(root,"single-mechanic.json"),[named]);WorkspaceFiles.ExportMechanicsCsv(Path.Combine(root,"mechanics.csv"),[named]);
Check(JsonDocument.Parse(File.ReadAllText(Path.Combine(root,"single-mechanic.json"))).RootElement.GetProperty("mechanics")[0].GetProperty("Actions").GetArrayLength()==3,"单独机制 JSON 可读取");
var before=File.ReadAllBytes(path);Reject(()=>WorkspaceFiles.ExportReport(path,[r],new(),1.5),"禁止 JSON 覆盖原始 dat");Check(before.SequenceEqual(File.ReadAllBytes(path)),"录像原文件未变化");
WorkspaceFiles.ExportCsv(Path.Combine(root,"events.csv"),r,r.Events,new());WorkspaceFiles.ExportReport(Path.Combine(root,"report.json"),[r,r2],new(),1.5);Check(JsonDocument.Parse(File.ReadAllText(Path.Combine(root,"report.json"))).RootElement.GetProperty("schema").GetInt32()==1,"报告 JSON 可读取");
var csv=Argument("--csv");var catalog=GameCatalog.Load(csv);var bundle=Argument("--bundle-catalog");
if(bundle is not null){WorkspaceFiles.WriteJson(bundle,catalog);WorkspaceFiles.WriteJson(Path.Combine(Path.GetDirectoryName(bundle)!,"protocol.json"),profile);}
if(csv is not null){Check(catalog.Actions.Count>30000,"动作资源目录载入");Check(catalog.Actions[18583].Name=="时间牢狱","中文 Action 名称");Check(catalog.Timelines.Count>1000,"动画目录载入");}
var dir=Argument("--recordings");
if(dir is not null) {
    var presets=JsonSerializer.Deserialize<List<PhasePreset>>(File.ReadAllText(Path.Combine(AppContext.BaseDirectory,"Data/phase-presets.json")))!;
    var files=Directory.GetFiles(dir,"*.dat").Where(p=>new[]{"亚历山大绝境战","妖星乱舞绝境战","幻想龙诗绝境战","光暗未来绝境战","欧米茄绝境验证战"}.Any(prefix=>Path.GetFileName(p).StartsWith(prefix))).ToArray();
    var all=new List<Recording>();var timer=System.Diagnostics.Stopwatch.StartNew();
    foreach(var file in files) {
        var recording=reader.Read(file);PhaseAnalysis.Initialize(recording,presets);catalog.Enrich(recording);Relationships.Build(recording,catalog);all.Add(recording);
        Check(recording.Events.Count>100&&recording.Events.Any(e=>e.Kind=="MapEffect"),"真实录像必须识别地图事件");
        Check(recording.Events.All(e=>e.Offset>=876&&e.PhaseId.Length>0),"每条事件均可追溯和分段");
        Check(recording.Events.Any(e=>e.Roles.HasFlag(EventRole.Result)),"真实伤害/状态判定");
        if(recording.Content==1094){Check(recording.Events.Count(e=>e.Kind=="RSV")==386&&recording.Events.Count(e=>e.Kind=="RSF")==220,"妖星解码包数量");Check(catalog.ActionName(47925,catalog.ResourceStrings(recording))=="遗弃末世","RSV 解析技能名称");}
        Console.WriteLine($"PASS {recording.FileName}：{recording.PacketCount:N0} 包，{recording.Events.Count:N0} 事件，{recording.Phases.Count} 区间，{SkillAnalysis.Summarize(recording,recording.Events,catalog).Count} 技能");
    }
    var actual=Merger.Merge(all);Check(actual.All(m=>m.Observations.Select(o=>(o.Recording,o.PhaseId)).Distinct().Count()==m.Observations.Count),"所有合并项每尝试最多一条，重复事件不丢失");
    var mechanismGroups=MechanicAnalysis.Build(all,catalog);var recordsBySha=all.ToDictionary(r=>r.Sha256);var indices=all.ToDictionary(r=>r.Sha256,r=>r.Events.ToDictionary(e=>e.Id));
    Check(mechanismGroups.All(g=>g.Observations.All(o=>!recordsBySha[o.Recording].IsPlayerSkill(indices[o.Recording][o.EventId]))),"真实录像机制组不包含玩家及宠物技能");
    Check(mechanismGroups.Any(g=>g.Actions.Count>1),"真实录像有多个技能 ID 的同名机制组");
    Check(mechanismGroups.Any(g=>g.SourceCount>1),"同名阶段的机制可以跨录像整理");
    WorkspaceFiles.WriteJson(Path.Combine(root,"mechanic-summary.json"),mechanismGroups.Select(g=>new{g.Content,g.Phase,g.Name,g.Actions,g.SourceCount,g.RunCount,Events=g.Observations.Count}));
    Console.WriteLine($"机制分组 {mechanismGroups.Count:N0} 项；多个技能 ID 的组 {mechanismGroups.Count(g=>g.Actions.Count>1):N0} 项");
    Check(all.Count(r=>r.Phases.Any(p=>p.Evidence.StartsWith("人工核对预设")))==5,"五个最终阶段精确 SHA 预设");
    WorkspaceFiles.SaveProject(Path.Combine(root,"真实录像示例工程.json"),all,csv??"",1.5);
    WorkspaceFiles.WriteJson(Path.Combine(root,"real-summary.json"),all.Select(r=>new{r.FileName,r.PacketCount,Events=r.Events.Count,Phases=r.Phases.Count,Skills=SkillAnalysis.Summarize(r,r.Events,catalog).Count,Unknown=r.UnknownOpcodes}));
    Console.WriteLine($"真实录像 {all.Count} 份；合并 {actual.Count:N0} 项；耗时 {timer.Elapsed.TotalSeconds:F1} 秒");
}
Console.WriteLine($"PASS {checks} assertions");
string? Argument(string name){var i=Array.IndexOf(args,name);return i>=0&&i+1<args.Length?args[i+1]:null;}
