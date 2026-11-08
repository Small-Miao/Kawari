// 资源表只提供配置证据，不能证明客户端实际显示。按类型定位字段避免旧 CSV 表头错位。
using Microsoft.VisualBasic.FileIO;
using System.Text.Json;
namespace ReplayAnalyzer.Core;

public sealed record ActionMeta(uint Id,string Name,uint CastTimeline,uint CastVfx,uint EndTimeline,uint HitTimeline,uint Omen);
public sealed class GameCatalog {
    public Dictionary<uint,ActionMeta> Actions {get;set;}=[];
    public Dictionary<uint,string> NpcNames {get;set;}=[];
    public Dictionary<uint,string> StatusNames {get;set;}=[];
    public Dictionary<uint,string> Timelines {get;set;}=[];
    public Dictionary<uint,string> Omens {get;set;}=[];
    public Dictionary<uint,uint[]> CastTimelines {get;set;}=[];
    public Dictionary<uint,uint> CastVfx {get;set;}=[];
    public Dictionary<uint,string> Vfx {get;set;}=[];
    public List<string> Warnings {get;set;}=[];
    public string Source {get;set;}="未载入资源表";
    public static GameCatalog Load(string? csvDirectory,string? fallback=null) {
        if(string.IsNullOrWhiteSpace(csvDirectory)||!Directory.Exists(csvDirectory))return fallback is not null&&File.Exists(fallback)?JsonSerializer.Deserialize<GameCatalog>(File.ReadAllText(fallback))??new():new();
        var c=new GameCatalog{Source=csvDirectory};
        void Table(string name,Action<string[],string[]> consume) {
            var path=Path.Combine(csvDirectory,name+".csv");if(!File.Exists(path)){c.Warnings.Add($"缺少 {name}.csv");return;}
            using var parser=new TextFieldParser(path,System.Text.Encoding.UTF8){TextFieldType=FieldType.Delimited,HasFieldsEnclosedInQuotes=true};parser.SetDelimiters(",");
            parser.ReadFields();parser.ReadFields();var types=parser.ReadFields()??[];
            while(!parser.EndOfData){var row=parser.ReadFields();if(row is not null&&row.Length>1&&uint.TryParse(row[0],out _))consume(row,types);}
        }
        static uint N(string[] row,int index)=>index>=0&&index<row.Length&&uint.TryParse(row[index],out var v)?v:0;
        Table("Action",(row,types)=>{var ends=Enumerable.Range(0,types.Length).Where(i=>types[i]=="ActionTimeline").ToArray();var id=N(row,0);c.Actions[id]=new(id,row[1],N(row,Array.IndexOf(types,"ActionCastTimeline")),N(row,Array.IndexOf(types,"ActionCastVFX")),N(row,ends.Length>0?ends[0]:-1),N(row,ends.Length>1?ends[1]:-1),N(row,Array.IndexOf(types,"Omen")));});
        Table("BNpcName",(row,_)=>c.NpcNames[N(row,0)]=row[1]);
        Table("Status",(row,_)=>c.StatusNames[N(row,0)]=row[1]);
        Table("ActionTimeline",(row,types)=>{var p=Array.IndexOf(types,"str");if(p>=0&&p<row.Length)c.Timelines[N(row,0)]=row[p];});
        Table("Omen",(row,_)=>c.Omens[N(row,0)]=row[1]);
        Table("ActionCastTimeline",(row,types)=>c.CastTimelines[N(row,0)]=[N(row,Array.IndexOf(types,"ActionTimeline")),N(row,Array.IndexOf(types,"VFX"))]);
        Table("ActionCastVFX",(row,types)=>c.CastVfx[N(row,0)]=N(row,Array.IndexOf(types,"VFX")));
        Table("VFX",(row,_)=>c.Vfx[N(row,0)]=row[1]);
        return c;
    }
    public Dictionary<string,string> ResourceStrings(Recording r)=>r.Events.Where(e=>e.Kind=="RSV").GroupBy(e=>e.ResourceKey).ToDictionary(g=>g.Key,g=>g.Last().ResourceValue);
    public string ActionName(uint id,IReadOnlyDictionary<string,string>? rsv=null) {
        if(!Actions.TryGetValue(id,out var m)) {
            var value=rsv?.FirstOrDefault(p=>p.Key.StartsWith($"_rsv_{id}_",StringComparison.Ordinal)).Value;
            return string.IsNullOrEmpty(value)?$"技能 {id}":value;
        }
        return m.Name.StartsWith("_rsv_")?(rsv?.GetValueOrDefault(m.Name)??m.Name):string.IsNullOrEmpty(m.Name)?$"无名技能 {id}":m.Name;
    }
    public IEnumerable<string> Resources(uint action) {
        if(!Actions.TryGetValue(action,out var m)){yield return "资源表中没有该技能；不会凭 ID 猜测预兆或动画。";yield break;}
        yield return "以下为资源表配置，不代表已确认客户端实际播放：";
        if(m.Omen>0)yield return $"Omen {m.Omen}：{Omens.GetValueOrDefault(m.Omen,"未知资源路径")}";
        if(m.EndTimeline>0)yield return $"结束 ActionTimeline {m.EndTimeline}：{Timelines.GetValueOrDefault(m.EndTimeline,"未知资源路径")}";
        if(m.HitTimeline>0)yield return $"命中 ActionTimeline {m.HitTimeline}：{Timelines.GetValueOrDefault(m.HitTimeline,"未知资源路径")}";
        if(CastTimelines.TryGetValue(m.CastTimeline,out var cast))yield return $"读条配置 {m.CastTimeline}：ActionTimeline {cast[0]} {Timelines.GetValueOrDefault(cast[0])} / VFX {cast[1]} {Vfx.GetValueOrDefault(cast[1])}";
        if(CastVfx.TryGetValue(m.CastVfx,out var vfx)&&vfx>0)yield return $"读条 VFX {vfx}：{Vfx.GetValueOrDefault(vfx)}";
        if(m.Omen==0)yield return "未配置普通 Omen；不能据此排除 MapEffect、EObj 或其他技能生成的预兆。";
    }
    public void Enrich(Recording r) {
        foreach(var a in r.Actors.Values)if(a.Kind=="npc")a.Name=NpcNames.GetValueOrDefault(a.NameId,$"NPC {a.Base}");
        foreach(var e in r.Events.Where(e=>e.Kind=="读条")) {
            e.Roles&=~EventRole.Omen;e.Evidence="原始包";
            if(Actions.TryGetValue(e.AnimationAction,out var m)&&m.Omen>0){e.Roles|=EventRole.Omen;e.Evidence="原始读条包 + Omen 资源配置；屏幕显示未确认";}
        }
    }
}
