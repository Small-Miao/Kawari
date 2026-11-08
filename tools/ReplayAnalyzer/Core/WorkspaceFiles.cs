// 工程保存人工整理；导出始终保留来源、偏移、原始分类及推测关联。
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
namespace ReplayAnalyzer.Core;

public sealed class ReplayProject {
    public int Schema {get;set;}=1;
    public string CsvDirectory {get;set;}="";
    public double MergeTolerance {get;set;}=1.5;
    public List<ProjectRecording> Recordings {get;set;}=[];
}
public sealed record ProjectRecording(string Path,string Sha256,List<PhaseInfo> Phases,Dictionary<long,EventAnnotation> Annotations);
public static class WorkspaceFiles {
    public static readonly JsonSerializerOptions JsonOptions=new(){WriteIndented=true,Encoder=System.Text.Encodings.Web.JavaScriptEncoder.UnsafeRelaxedJsonEscaping,Converters={new JsonStringEnumConverter()}};
    public static void SaveProject(string file,IEnumerable<Recording> recordings,string csv,double tolerance) {
        CheckExtension(file,".json");
        var project=new ReplayProject{CsvDirectory=csv,MergeTolerance=tolerance,Recordings=recordings.Select(r=>new ProjectRecording(r.Path,r.Sha256,r.Phases,r.Annotations)).ToList()};
        WriteJson(file,project);
    }
    public static ReplayProject ReadProject(string file) {
        if(new FileInfo(file).Length>16*1024*1024)throw new InvalidDataException("工程超过 16 MiB");
        var p=JsonSerializer.Deserialize<ReplayProject>(File.ReadAllText(file),JsonOptions)??throw new InvalidDataException("工程为空");
        if(p.Schema!=1||p.Recordings.Count>100||!double.IsFinite(p.MergeTolerance)||p.MergeTolerance<0||p.MergeTolerance>30)throw new InvalidDataException("不支持的工程版本、文件数或合并阈值");return p;
    }
    public static void Apply(Recording r,ProjectRecording project) {
        if(!r.Sha256.Equals(project.Sha256,StringComparison.OrdinalIgnoreCase))throw new InvalidDataException($"{r.FileName} 的内容与工程 SHA-256 不一致，拒绝错配人工标注");
        if(project.Phases.Select(p=>p.Id).Distinct().Count()!=project.Phases.Count)throw new InvalidDataException("阶段标识重复");
        var old=r.Phases;r.Phases=project.Phases;
        try{PhaseAnalysis.Assign(r);}catch{r.Phases=old;PhaseAnalysis.Assign(r);throw;}
        var valid=r.Events.Select(e=>e.Id).ToHashSet();r.Annotations=project.Annotations.Where(p=>valid.Contains(p.Key)).ToDictionary();
    }
    public static void ExportCsv(string file,Recording r,IEnumerable<ReplayEvent> events,GameCatalog catalog) {
        CheckExtension(file,".csv");using var writer=new StreamWriter(file,false,new UTF8Encoding(true));
        WriteCsv(writer,["录像","副本ID","Build","阶段","绝对秒","阶段相对秒","文件偏移","Opcode","类型","技能ID","名称","原始分类","人工分类","演员","目标","参数","坐标","效果","证据","人工关联技能","机制组","备注"]);
        var phases=r.Phases.ToDictionary(p=>p.Id);var rsv=catalog.ResourceStrings(r);
        foreach(var e in events) {
            var phase=phases.GetValueOrDefault(e.PhaseId);var note=r.Annotations.GetValueOrDefault(e.Id);
            WriteCsv(writer,[r.FileName,r.Content.ToString(),r.Build.ToString(),phase?.Name??"未分段",Number(e.Ms/1000d),Number(((long)e.Ms-(phase?.AnchorMs??0))/1000d),$"0x{e.Offset:X}",e.Opcode.ToString(),e.Kind,e.Action.ToString(),e.Action==0?"":catalog.ActionName(e.Action,rsv),Names.Role(e.Roles),note?.Roles is {} role?Names.Role(role):"",r.ActorLabel(e.Actor),r.ActorLabel(e.Target),string.Join(" ",e.Parameters.Select(p=>$"0x{p:X}")),e.Position?.ToString()??"",string.Join("; ",e.Effects.Select(f=>$"{f.Target} {f.Meaning}={f.Value} param={f.Parameter}")),e.Evidence,note?.RelatedAction?.ToString()??"",note?.Mechanic??"",note?.Note??""]);
        }
    }
    public static void ExportMergedCsv(string file,IEnumerable<MergedEvent> groups) {
        CheckExtension(file,".csv");using var w=new StreamWriter(file,false,new UTF8Encoding(true));
        WriteCsv(w,["副本ID","Build","阶段","类型","相对秒均值","误差范围秒","录像数","尝试数","事件签名","原始来源"]);
        foreach(var g in groups)WriteCsv(w,[g.Content.ToString(),g.Build.ToString(),g.Phase,g.Kind,Number(g.Seconds),Number(g.Spread),g.SourceCount.ToString(),g.RunCount.ToString(),g.Signature,string.Join(" | ",g.Observations.Select(o=>$"{o.FileName} [{o.PhaseId}] +{Number(o.Seconds)}s @0x{o.Offset:X}"))]);
    }
    public static void ExportMechanicsCsv(string file,IEnumerable<MechanicGroup> groups) {
        CheckExtension(file,".csv");using var w=new StreamWriter(file,false,new UTF8Encoding(true));
        WriteCsv(w,["副本ID","Build","阶段","机制组","组内技能ID","录像","录像SHA","阶段标识","相对秒","事件ID","偏移","事件","技能ID","分类","主要事件","置信度","分组或关联依据","内容"]);
        foreach(var group in groups)foreach(var o in group.Observations)WriteCsv(w,[group.Content.ToString(),group.Build.ToString(),group.Phase,group.Name,string.Join(" / ",group.Actions),o.FileName,o.Recording,o.PhaseId,Number(o.Seconds),o.EventId.ToString(),$"0x{o.Offset:X}",o.Kind,o.Action.ToString(),Names.Role(o.Roles),o.Primary?"是":"关联候选",o.Confidence,o.Reason,o.Summary]);
    }
    public static void ExportMechanics(string file,IEnumerable<MechanicGroup> groups){CheckExtension(file,".json");WriteJson(file,new{schema=1,notes="同名技能自动归组；关联演出仍按各自证据区分，所有重复调用均保留。",mechanics=groups});}
    public static void ExportReport(string file,IEnumerable<Recording> recordings,GameCatalog catalog,double tolerance) {
        CheckExtension(file,".json");var rs=recordings.ToArray();
        var report=new {schema=1,notes=new[]{"关联置信度是分析证据，不是已证实的客户端因果。","资源配置不保证屏幕显示；无伤害不能证明纯演出。","未知包保留计数，未保存聊天和录制者 CID。"},catalog=catalog.Source,recordings=rs.Select(r=>new{r.FileName,r.Sha256,r.Content,r.Build,r.DurationMs,r.PacketCount,r.Warnings,r.UnknownOpcodes,phases=r.Phases.Select(p=>new{phase=p,initialMapEffects=PhaseAnalysis.MapBaseline(r,p.StartMs)}),r.Actors,r.Events,r.Annotations,skills=SkillAnalysis.Summarize(r,r.Events,catalog).Select(s=>new{s.Action,s.Name,s.Casts,s.Effects,s.Results,s.VisualLinks,s.MapLinks,s.OmenConfigurations,s.Classification,eventIds=s.Events.Select(e=>e.Id),resources=catalog.Resources(s.Action)})}),merged=Merger.Merge(rs,tolerance),mechanics=MechanicAnalysis.Build(rs,catalog)};
        WriteJson(file,report);
    }
    public static void ExportResources(string file,Recording r) {
        CheckExtension(file,".json");WriteJson(file,new{schema=1,source_sha256=r.Sha256,packets=r.Events.Where(e=>e.Kind is "RSV" or "RSF").Select(e=>new{kind=e.Kind.ToLowerInvariant(),key=e.ResourceKey,value=e.ResourceValue,recording_ms=e.Ms})});
    }
    public static void WriteJson<T>(string file,T value) {
        var temporary=file+"."+Guid.NewGuid().ToString("N")+".tmp";
        try{using(var stream=File.Create(temporary))JsonSerializer.Serialize(stream,value,JsonOptions);File.Move(temporary,file,true);}finally{if(File.Exists(temporary))File.Delete(temporary);}
    }
    private static void CheckExtension(string file,string extension){if(!Path.GetExtension(file).Equals(extension,StringComparison.OrdinalIgnoreCase))throw new InvalidDataException($"输出文件必须使用 {extension} 扩展名，避免覆盖录像");}
    private static string Number(double v)=>v.ToString("0.000",System.Globalization.CultureInfo.InvariantCulture);
    private static void WriteCsv(TextWriter w,IEnumerable<string> fields)=>w.WriteLine(string.Join(",",fields.Select(v=>{
        var leading=v.TrimStart();
        var formula=leading.Length>0&&("=+@".Contains(leading[0])||(leading[0]=='-'&&!double.TryParse(leading,System.Globalization.NumberStyles.Float,System.Globalization.CultureInfo.InvariantCulture,out _)));
        return "\""+(formula?"'":"")+v.Replace("\"","\"\"")+"\"";
    })));
}
