// 机制级整理：同名动作聚合、人工合并与逐条来源，候选演出仍保留置信度。
namespace ReplayAnalyzer.Core;

public sealed record MechanicObservation(string Recording,string FileName,string PhaseId,long EventId,long Offset,double Seconds,uint Action,string Kind,EventRole Roles,string Summary,bool Primary,string Confidence,string Reason);
public sealed class MechanicGroup {
    public ushort Content {get;set;}
    public int Build {get;set;}
    public string Phase {get;set;}="";
    public string Name {get;set;}="";
    public List<uint> Actions {get;set;}=[];
    public List<MechanicObservation> Observations {get;set;}=[];
    public int SourceCount=>Observations.Select(o=>o.Recording).Distinct().Count();
    public int RunCount=>Observations.Select(o=>(o.Recording,o.PhaseId)).Distinct().Count();
    public int Casts=>Observations.Count(o=>o.Primary&&o.Kind=="读条");
    public int Results=>Observations.Count(o=>o.Primary&&o.Roles.HasFlag(EventRole.Result));
    public int Presentations=>Observations.Count(o=>(o.Roles&(EventRole.Map|EventRole.Object|EventRole.Visual|EventRole.Omen))!=0);
}

public static class MechanicAnalysis {
    public static List<MechanicGroup> Build(IEnumerable<Recording> recordings,GameCatalog catalog,CancellationToken cancellation=default) {
        var groups=new Dictionary<(ushort,int,string,string),MechanicGroup>();
        foreach(var r in recordings.DistinctBy(r=>r.Sha256)) {
            cancellation.ThrowIfCancellationRequested();
            var events=r.Events.ToDictionary(e=>e.Id);var phases=r.Phases.ToDictionary(p=>p.Id);var rsv=catalog.ResourceStrings(r);
            var seen=new Dictionary<MechanicGroup,Dictionary<long,MechanicObservation>>();
            foreach(var e in r.Events) {
                if(r.IsPlayerSkill(e)||!phases.TryGetValue(e.PhaseId,out var phase))continue;
                var annotation=r.Annotations.GetValueOrDefault(e.Id);var action=e.Action!=0?e.Action:annotation?.RelatedAction??0;
                if(action==0&&string.IsNullOrWhiteSpace(annotation?.Mechanic))continue;
                var manual=!string.IsNullOrWhiteSpace(annotation?.Mechanic);
                var name=manual?annotation!.Mechanic.Trim():catalog.ActionName(action,rsv);
                // 通用无名攻击不跨不同 NPC 自动合成一个机制。
                if(!manual&&(name is "攻击" or "自动攻击"||name.StartsWith("无名技能")||name.StartsWith("技能 ")||name.StartsWith("_rsv_")))name+=$" · ID {action}";
                var key=(r.Content,r.Build,phase.Name,name);
                if(!groups.TryGetValue(key,out var group)){group=new(){Content=r.Content,Build=r.Build,Phase=phase.Name,Name=name};groups[key]=group;}
                if(action>0&&!group.Actions.Contains(action))group.Actions.Add(action);
                if(!seen.TryGetValue(group,out var observations)){observations=[];seen[group]=observations;}
                MechanicObservation Observe(ReplayEvent item,bool primary,string confidence,string reason)=>new(r.Sha256,r.FileName,item.PhaseId,item.Id,item.Offset,((long)item.Ms-phase.AnchorMs)/1000d,item.Action,item.Kind,r.Roles(item),item.Summary,primary,confidence,reason);
                observations[e.Id]=Observe(e,true,manual?"人工":"自动分组",manual?"用户指定机制组":"相同副本 / 阶段名 / 中文技能名；不等于所有机制条件相同");
                foreach(var link in e.Related) {
                    if(!events.TryGetValue(link.EventId,out var other)||other.PhaseId!=e.PhaseId||r.IsPlayerSkill(other)||(other.Roles&(EventRole.Resource|EventRole.Movement))!=0)continue;
                    if(!observations.ContainsKey(other.Id))observations[other.Id]=Observe(other,false,link.Confidence,link.Reason);
                }
            }
            foreach(var (group,observations) in seen)group.Observations.AddRange(observations.Values);
        }
        foreach(var group in groups.Values){group.Actions.Sort();group.Observations=group.Observations.OrderBy(o=>o.FileName).ThenBy(o=>o.PhaseId).ThenBy(o=>o.Seconds).ThenBy(o=>o.Offset).ToList();}
        return groups.Values.OrderBy(g=>g.Content).ThenBy(g=>g.Phase).ThenBy(g=>g.Observations.Min(o=>o.Seconds)).ToList();
    }
    public static void NameGroups(IEnumerable<Recording> recordings,IEnumerable<MechanicGroup> groups,string name) {
        if(string.IsNullOrWhiteSpace(name))throw new InvalidDataException("机制名称不能为空");
        var bySha=recordings.ToDictionary(r=>r.Sha256);
        foreach(var observation in groups.SelectMany(g=>g.Observations.Where(o=>o.Primary)).DistinctBy(o=>(o.Recording,o.EventId))) {
            if(!bySha.TryGetValue(observation.Recording,out var r))continue;
            var annotation=r.Annotations.GetValueOrDefault(observation.EventId)??new();annotation.Mechanic=name.Trim();r.Annotations[observation.EventId]=annotation;
        }
    }
}
