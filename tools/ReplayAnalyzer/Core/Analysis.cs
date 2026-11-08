// 阶段和关联分析不把时间邻近当成因果；合并始终保留每条观察的来源。
using System.Text.Json;
namespace ReplayAnalyzer.Core;

public sealed record PhasePreset(string Sha256,string Name,uint StartMs,uint EndMs);
public static class PhaseAnalysis {
    public static void Initialize(Recording r,IEnumerable<PhasePreset>? presets=null) {
        var starts=new SortedDictionary<uint,(string Name,string Evidence)>{[0]=("入场 / 阶段候选","录像起点")};
        foreach(var c in r.Chapters.Where(c=>c.Ms<r.DurationMs)) {
            if(c.Type is 2 or 5)starts[c.Ms]=("战斗区间候选","原始 Start/Restart 章节；非精确开怪时刻");
            if(c.Type==4)starts[c.Ms]=("过场区间候选","原始 Event Cutscene 章节");
        }
        var preset=presets?.FirstOrDefault(p=>p.Sha256==r.Sha256);
        if(preset is not null) {
            foreach(var t in starts.Keys.Where(t=>t>=preset.StartMs&&t<=preset.EndMs).ToArray())starts.Remove(t);
            starts[preset.StartMs]=(preset.Name,"人工核对预设：精确匹配录像 SHA-256");
            if(preset.EndMs+1<r.DurationMs)starts[preset.EndMs+1]=("战后记录","预设最终阶段结束");
        }
        var points=starts.ToArray();var attempt=0;
        r.Phases=points.Select((p,i)=>{if(p.Value.Name=="战斗区间候选")attempt++;return new PhaseInfo{Name=p.Value.Name,StartMs=p.Key,EndMs=i+1<points.Length?points[i+1].Key:r.DurationMs+1,AnchorMs=p.Key,Evidence=p.Value.Evidence,Attempt=attempt};}).ToList();
        Assign(r);
    }
    public static void Assign(Recording r) {
        r.Phases=r.Phases.OrderBy(p=>p.StartMs).ToList();
        if(r.Phases.Count==0||r.Phases[0].StartMs!=0||r.Phases[^1].EndMs!=(long)r.DurationMs+1)throw new InvalidDataException("阶段必须覆盖录像的完整时间范围");
        for(var i=0;i<r.Phases.Count;i++) {
            var p=r.Phases[i];if(string.IsNullOrWhiteSpace(p.Id)||string.IsNullOrWhiteSpace(p.Name)||p.StartMs>r.DurationMs||p.EndMs<=p.StartMs||p.AnchorMs<p.StartMs||p.AnchorMs>=p.EndMs)throw new InvalidDataException("阶段名称、范围或锚点无效");
            if(i>0&&r.Phases[i-1].EndMs!=p.StartMs)throw new InvalidDataException("阶段范围存在空隙或重叠");
        }
        var index=0;foreach(var e in r.Events){while(index<r.Phases.Count&&r.Phases[index].EndMs<=e.Ms)index++;e.PhaseId=index<r.Phases.Count&&r.Phases[index].StartMs<=e.Ms?r.Phases[index].Id:"";}
    }
    public static void Split(Recording r,uint at,string name) {
        var phase=r.Phases.FirstOrDefault(p=>p.StartMs<=at&&at<p.EndMs)??throw new InvalidDataException("该时间不在已有阶段范围内");
        if(string.IsNullOrWhiteSpace(name))throw new InvalidDataException("阶段名称不能为空");
        if(at==phase.StartMs){phase.Name=name;phase.Evidence="人工命名";}
        else {var end=phase.EndMs;phase.EndMs=at;if(phase.AnchorMs>=at)phase.AnchorMs=phase.StartMs;r.Phases.Add(new(){Name=name,StartMs=at,EndMs=end,AnchorMs=at,Evidence="人工拆分",Attempt=phase.Attempt});}
        Assign(r);
    }
    public static Dictionary<uint,string> MapBaseline(Recording r,uint before) {
        var states=new Dictionary<uint,string>();
        foreach(var e in r.Events.TakeWhile(e=>e.Ms<before)) {
            if(e.Kind=="地图初始化"){states.Clear();for(uint i=0;i<e.Parameters.Length;i++)if(e.Parameters[i]!=0)states[i]=$"初始状态 0x{e.Parameters[i]:X4}（{e.TimeText}）";}
            if(e.Kind=="MapEffect")states[e.Value]=$"0x{e.Parameters[1]:X4} / 0x{e.Parameters[2]:X4}（{e.TimeText}）";
        }
        return states;
    }
}

public static class Relationships {
    public static void Build(Recording r,GameCatalog catalog) {
        foreach(var e in r.Events)e.Related.Clear();
        foreach(var group in r.Events.GroupBy(e=>e.PhaseId)) {
            var events=group.ToArray();var lastCast=new Dictionary<(string,uint),ReplayEvent>();
            foreach(var e in events) {
                if(e.Kind=="读条"){lastCast[(e.Actor,e.Action)]=e;continue;}
                if(e.Kind=="技能效果"&&lastCast.TryGetValue((e.Actor,e.Action),out var cast)&&e.Ms>=cast.Ms&&e.Ms-cast.Ms<=Math.Max(2000,cast.Duration*1000+2500))Link(e,cast,"高","同演员、同技能，发生于读条结束附近；未使用距离猜测");
            }
            var actions=events.Where(e=>e.Action!=0&&!r.IsPlayerSkill(e)).ToArray();var begin=0;
            foreach(var e in events.Where(e=>e.Action==0&&(e.Roles&(EventRole.Visual|EventRole.State|EventRole.Map|EventRole.Object))!=0)) {
                while(begin<actions.Length&&actions[begin].Ms+2500L<e.Ms)begin++;
                var candidates=new List<(ReplayEvent E,string Confidence,string Why,int Score,long Delta)>();
                for(var i=begin;i<actions.Length&&actions[i].Ms<=e.Ms+1000L;i++) {
                    var a=actions[i];var delta=Math.Abs((long)e.Ms-a.Ms);var sameActor=e.Actor==a.Actor;
                    if(e.Kind=="状态获得"&&a.Effects.Any(f=>f.Value==e.Value&&((f.Type==14&&f.Target==e.Actor)||(f.Type==15&&a.Actor==e.Actor)))&&delta<=1200)candidates.Add((a,"高","相同状态ID和受影响演员，邻近动作效果包含施加状态",100,delta));
                    else if(e.Kind is "动作动画" or "同步动画"&&sameActor&&catalog.Actions.TryGetValue(a.AnimationAction==0?a.Action:a.AnimationAction,out var meta)&&(meta.EndTimeline==e.Value||meta.HitTimeline==e.Value))candidates.Add((a,"高","同演员的 ActionTimeline 与该技能资源表引用一致",90,delta));
                    else if(sameActor&&delta<=1200)candidates.Add((a,"中","同演员的邻近演出/控制包；尚无直接因果证明",50,delta));
                    else if(e.Kind is "MapEffect" or "EObj 动画" or "Director 事件" or "生成 EObj"&&delta<=800)candidates.Add((a,"低","时间邻近候选；全场效果可能与其他技能并发",10,delta));
                }
                foreach(var candidate in candidates.OrderByDescending(c=>c.Score).ThenBy(c=>c.Delta).Take(3))Link(e,candidate.E,candidate.Confidence,candidate.Why);
            }
        }
    }
    private static void Link(ReplayEvent a,ReplayEvent b,string confidence,string why) {
        if(a.Id==b.Id||a.Related.Any(r=>r.EventId==b.Id))return;
        a.Related.Add(new(b.Id,confidence,why));b.Related.Add(new(a.Id,confidence,why));
    }
}

public sealed record Observation(string Recording,string FileName,string PhaseId,string Phase,long EventId,long Offset,double Seconds,string Summary,string Actor,Point3? Position);
public sealed class MergedEvent {
    public ushort Content {get;set;}
    public int Build {get;set;}
    public string Phase {get;set;}="";
    public string Kind {get;set;}="";
    public string Signature {get;set;}="";
    public List<Observation> Observations {get;set;}=[];
    public double Seconds=>Observations.Count==0?0:Observations.Average(o=>o.Seconds);
    public double Spread=>Observations.Count==0?0:Observations.Max(o=>o.Seconds)-Observations.Min(o=>o.Seconds);
    public int SourceCount=>Observations.Select(o=>o.Recording).Distinct().Count();
    public int RunCount=>Observations.Select(o=>(o.Recording,o.PhaseId)).Distinct().Count();
}
public static class Merger {
    public static string Signature(Recording r,ReplayEvent e) {
        var actor=r.Actors.GetValueOrDefault(e.Actor);var target=r.Actors.GetValueOrDefault(e.Target);
        // 演员运行时 ID 和伤害随机值不参与跨录像签名；物件布局及控制参数保留。
        var parameters=e.Kind is "MapEffect" or "EObj 动画" or "Director 事件" or "动画状态" or "模型状态"?string.Join(",",e.Parameters):"";
        return $"{e.Kind}|A={e.Action}|动画={e.AnimationAction}|人工技能={r.Annotations.GetValueOrDefault(e.Id)?.RelatedAction}|分类={(int)r.Roles(e)}|V={e.Value}|P={e.Param}|NPC={actor?.Base??0}|目标={(target?.Kind=="player"?"玩家":target?.Base.ToString())}|Layout={actor?.Layout??0}|{parameters}";
    }
    public static List<MergedEvent> Merge(IEnumerable<Recording> recordings,double toleranceSeconds=1.5,CancellationToken cancellation=default) {
        if(!double.IsFinite(toleranceSeconds)||toleranceSeconds<0||toleranceSeconds>30)throw new ArgumentOutOfRangeException(nameof(toleranceSeconds));
        var result=new List<MergedEvent>();
        var input=recordings.DistinctBy(r=>r.Sha256).SelectMany(r=>r.Phases.SelectMany(p=>r.Events.Where(e=>e.PhaseId==p.Id&&!r.IsPlayerSkill(e)&&(e.Roles&(EventRole.Movement|EventRole.Resource))==0).Select(e=>(R:r,P:p,E:e))));
        foreach(var group in input.GroupBy(x=>(x.R.Content,x.R.Build,x.P.Name,Signature(x.R,x.E)))) {
            cancellation.ThrowIfCancellationRequested();
            var clusters=new List<MergedEvent>();
            foreach(var x in group.OrderBy(x=>((long)x.E.Ms-x.P.AnchorMs)/1000d)) {
                cancellation.ThrowIfCancellationRequested();
                var t=((long)x.E.Ms-x.P.AnchorMs)/1000d;
                var cluster=clusters.Where(c=>Math.Abs(c.Seconds-t)<=toleranceSeconds&&!c.Observations.Any(o=>o.Recording==x.R.Sha256&&o.PhaseId==x.P.Id)).OrderBy(c=>Math.Abs(c.Seconds-t)).FirstOrDefault();
                if(cluster is null){cluster=new(){Content=x.R.Content,Build=x.R.Build,Phase=x.P.Name,Kind=x.E.Kind,Signature=group.Key.Item4};clusters.Add(cluster);result.Add(cluster);}
                cluster.Observations.Add(new(x.R.Sha256,x.R.FileName,x.P.Id,x.P.Name,x.E.Id,x.E.Offset,t,x.E.Summary,x.R.ActorLabel(x.E.Actor),x.E.Position));
            }
        }
        return result.OrderBy(e=>e.Content).ThenBy(e=>e.Build).ThenBy(e=>e.Phase).ThenBy(e=>e.Seconds).ToList();
    }
}

public sealed record SkillSummary(uint Action,string Name,int Casts,int Effects,int Results,int VisualLinks,int MapLinks,int OmenConfigurations,string Classification,List<ReplayEvent> Events);
public static class SkillAnalysis {
    public static List<SkillSummary> Summarize(Recording r,IEnumerable<ReplayEvent> scope,GameCatalog catalog) {
        var byId=r.Events.ToDictionary(e=>e.Id);var rsv=catalog.ResourceStrings(r);
        return scope.SelectMany(e=>new[]{!r.IsPlayerSkill(e)?e.Action:0,r.Annotations.GetValueOrDefault(e.Id)?.RelatedAction??0}.Where(id=>id>0).Distinct().Select(id=>(Action:id,Event:e))).GroupBy(x=>x.Action).Select(g=>{
            var events=g.Select(x=>x.Event).ToList();var linked=events.SelectMany(e=>e.Related).Where(l=>byId.ContainsKey(l.EventId)).Select(l=>byId[l.EventId]).Concat(events.Where(e=>e.Action!=g.Key)).DistinctBy(e=>e.Id).ToArray();
            var result=events.Count(e=>r.Roles(e).HasFlag(EventRole.Result));var unknown=events.Any(e=>r.Roles(e).HasFlag(EventRole.Unknown));
            var manual=events.Any(e=>r.Annotations.ContainsKey(e.Id));
            return new SkillSummary(g.Key,catalog.ActionName(g.Key,rsv),events.Count(e=>e.Kind=="读条"),events.Count(e=>e.Kind=="技能效果"),result,linked.Count(e=>r.Roles(e).HasFlag(EventRole.Visual)),linked.Count(e=>r.Roles(e).HasFlag(EventRole.Map)),events.Count(e=>r.Roles(e).HasFlag(EventRole.Omen)),(result>0?"含结算事件":unknown?"存在未知效果，待核对":"未观察到结算，不等于纯演出")+(manual?"（含人工整理）":""),events);
        }).OrderBy(s=>s.Events[0].Ms).ToList();
    }
}
