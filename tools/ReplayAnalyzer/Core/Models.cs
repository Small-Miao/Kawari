// 保留录像证据和人工调整；原始包、推测关联和资源配置分开存储。
using System.Text.Json.Serialization;
namespace ReplayAnalyzer.Core;

[Flags]
public enum EventRole { None=0, Cast=1, Visual=2, Result=4, Omen=8, State=16, Map=32, Object=64, Resource=128, Movement=256, Unknown=512 }
public sealed record Point3(double X,double Y,double Z) {
    public override string ToString()=>$"({X:F2}, {Y:F2}, {Z:F2})";
}
public sealed class ActorInfo {
    public string Key {get;set;}="";
    public uint Id {get;set;}
    public uint Base {get;set;}
    public uint NameId {get;set;}
    public string Kind {get;set;}="unknown";
    public string Name {get;set;}="";
    public uint Layout {get;set;}
    public uint BindLayout {get;set;}
    public uint Owner {get;set;}
    public uint FirstMs {get;set;}
    public Point3? Position {get;set;}
    public double Rotation {get;set;}
    public string Label=>string.IsNullOrEmpty(Name)?$"{(Kind=="player"?"玩家":Kind=="object"?"物件":"演员")} {Key}":$"{Name} [{Base}] · {Key}";
}
public sealed record EffectInfo(string Target,byte Type,string Meaning,uint Value,ushort Parameter,byte[] Raw);
public sealed record Association(long EventId,string Confidence,string Reason);
public sealed class ReplayEvent {
    public long Id {get;set;}
    public uint Ms {get;set;}
    public long Offset {get;set;}
    public ushort Opcode {get;set;}
    public ushort PayloadSize {get;set;}
    public string Kind {get;set;}="";
    public EventRole Roles {get;set;}
    public string Actor {get;set;}="";
    public string Target {get;set;}="";
    public uint Action {get;set;}
    public uint AnimationAction {get;set;}
    public uint Sequence {get;set;}
    public uint Value {get;set;}
    public uint Param {get;set;}
    public uint[] Parameters {get;set;}=[];
    public double Duration {get;set;}
    public Point3? Position {get;set;}
    public double Rotation {get;set;}
    public string Summary {get;set;}="";
    public string Evidence {get;set;}="原始包";
    public string ResourceKey {get;set;}="";
    public string ResourceValue {get;set;}="";
    public List<EffectInfo> Effects {get;set;}=[];
    public List<Association> Related {get;set;}=[];
    public string PhaseId {get;set;}="";
    [JsonIgnore] public string TimeText=>TimeTextOf(Ms/1000d);
    public static string TimeTextOf(double seconds) {
        var sign=seconds<0?"−":"";seconds=Math.Abs(seconds);
        return $"{sign}{(int)(seconds/60):D2}:{seconds%60:00.000}";
    }
}
public sealed record Chapter(int Type,uint Offset,uint Ms);
public sealed class PhaseInfo {
    public string Id {get;set;}=Guid.NewGuid().ToString("N");
    public string Name {get;set;}="阶段候选";
    public uint StartMs {get;set;}
    public uint EndMs {get;set;}
    public uint AnchorMs {get;set;}
    public string Evidence {get;set;}="人工";
    public int Attempt {get;set;}
    public string Label=>$"{Name} · {ReplayEvent.TimeTextOf(StartMs/1000d)}–{ReplayEvent.TimeTextOf(EndMs/1000d)}";
}
public sealed class Recording {
    public string Path {get;set;}="";
    public string Sha256 {get;set;}="";
    public int Build {get;set;}
    public ushort Content {get;set;}
    public uint DurationMs {get;set;}
    public long PacketCount {get;set;}
    public List<Chapter> Chapters {get;set;}=[];
    public Dictionary<string,ActorInfo> Actors {get;set;}=[];
    public List<ReplayEvent> Events {get;set;}=[];
    public Dictionary<ushort,int> UnknownOpcodes {get;set;}=[];
    public List<string> Warnings {get;set;}=[];
    public List<PhaseInfo> Phases {get;set;}=[];
    public Dictionary<long,EventAnnotation> Annotations {get;set;}=[];
    [JsonIgnore] public string FileName=>System.IO.Path.GetFileName(Path);
    [JsonIgnore] public string ContentName=>Names.Content(Content);
    public EventRole Roles(ReplayEvent e)=>Annotations.TryGetValue(e.Id,out var a)&&a.Roles is {} roles?roles:e.Roles;
    public string ActorLabel(string key)=>Actors.TryGetValue(key,out var actor)?actor.Label:key;
    public bool IsPlayer(ReplayEvent e)=>Actors.TryGetValue(e.Actor,out var actor)&&actor.Kind=="player";
    public bool IsPlayerControlled(ReplayEvent e) {
        if(!Actors.TryGetValue(e.Actor,out var actor))return false;
        // 玩家召唤物常使用 NPC ID；沿 Owner 链识别，不能仅凭技能 ID 过滤 Boss 复用动作。
        var visited=new HashSet<uint>();
        for(var depth=0;depth<8&&visited.Add(actor.Id);depth++) {
            if(actor.Kind=="player"||(actor.Owner>=0x10000000&&actor.Owner<0x40000000))return true;
            if(actor.Owner==0||actor.Owner==0xE0000000)return false;
            var owner=Actors.Values.FirstOrDefault(a=>a.Id==actor.Owner&&a.FirstMs<=e.Ms);
            if(owner is null)return false;actor=owner;
        }
        return false;
    }
    public bool IsPlayerSkill(ReplayEvent e)=>e.Action!=0&&IsPlayerControlled(e);
}
public sealed class EventAnnotation {
    public EventRole? Roles {get;set;}
    public uint? RelatedAction {get;set;}
    public string Note {get;set;}="";
    public string Mechanic {get;set;}="";
}
public static class Names {
    public static string Content(ushort id)=>id switch {694=>"亚历山大绝境战",788=>"幻想龙诗绝境战",908=>"欧米茄绝境验证战",1006=>"光暗未来绝境战",1094=>"妖星乱舞绝境战",_=>$"副本 {id}"};
    public static string Role(EventRole roles)=>string.Join(" / ",new[]{(EventRole.Cast,"读条"),(EventRole.Result,"判定"),(EventRole.Omen,"预兆配置"),(EventRole.Map,"MapEffect"),(EventRole.Object,"物件"),(EventRole.Visual,"演出"),(EventRole.State,"状态/控制"),(EventRole.Resource,"资源解码"),(EventRole.Movement,"移动"),(EventRole.Unknown,"未知")}.Where(x=>roles.HasFlag(x.Item1)).Select(x=>x.Item2));
}
