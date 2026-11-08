// FFXIVREPLAY v5 流式解析；未知协议保留统计，拒绝错误版本和截断记录。
using System.Buffers.Binary;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
namespace ReplayAnalyzer.Core;

public sealed class ProtocolProfile {
    public string Name {get;set;}="国服 2026.10 / build 14101351";
    public int[] Builds {get;set;}=[14101351];
    public Dictionary<string,ushort> Opcodes {get;set;}=new() {
        ["SpawnNpc"]=276,["SpawnObject"]=403,["DeleteObject"]=722,["DeleteActor"]=476,
        ["ActorMove"]=535,["ActorSetPos"]=992,["ActorCast"]=769,
        ["ActionEffect1"]=189,["ActionEffect8"]=319,["ActionEffect16"]=912,["ActionEffect24"]=158,["ActionEffect32"]=630,
        ["ActorControl"]=408,["ActorControlSelf"]=486,["ActorControlTarget"]=200,
        ["MapEffect"]=422,["MapEffects64"]=106,["MapEffects128"]=764,["Weather"]=596,["DirectorVars"]=225,
        ["ActorTimelines"]=333,["Status30"]=718,["Status60"]=923,["Rsv"]=61441,["Rsf"]=61442
    };
    public static ProtocolProfile Load(string file)=>File.Exists(file)?JsonSerializer.Deserialize<ProtocolProfile>(File.ReadAllText(file))??throw new InvalidDataException("协议配置为空"):new();
}

public sealed class ReplayReader(ProtocolProfile profile) {
    private static ushort U16(ReadOnlySpan<byte> b,int p=0)=>BinaryPrimitives.ReadUInt16LittleEndian(b[p..]);
    private static uint U32(ReadOnlySpan<byte> b,int p=0)=>BinaryPrimitives.ReadUInt32LittleEndian(b[p..]);
    private static ulong U64(ReadOnlySpan<byte> b,int p=0)=>BinaryPrimitives.ReadUInt64LittleEndian(b[p..]);
    private static float F32(ReadOnlySpan<byte> b,int p) {
        var value=BitConverter.Int32BitsToSingle((int)U32(b,p));
        if(!float.IsFinite(value))throw new InvalidDataException("录像包含非有限的坐标或持续时间");
        return value;
    }
    private static double Rotation(ReadOnlySpan<byte> b,int p)=>U16(b,p)/65535d*2*Math.PI-Math.PI;
    private static Point3 Position(ReadOnlySpan<byte> b,int p,bool packed=false)=>packed
        ?new(U16(b,p)*2000d/65535-1000,U16(b,p+2)*2000d/65535-1000,U16(b,p+4)*2000d/65535-1000)
        :new(F32(b,p),F32(b,p+4),F32(b,p+8));

    public Recording Read(string path,IProgress<(double Fraction,string Text)>? progress=null,CancellationToken cancel=default) {
        using var file=new FileStream(path,FileMode.Open,FileAccess.Read,FileShare.Read);
        if(file.Length<876||file.Length>2L*1024*1024*1024)throw new InvalidDataException("录像长度无效（支持 876 字节至 2 GiB）");
        var h=new byte[876];file.ReadExactly(h);
        if(!h.AsSpan(0,11).SequenceEqual("FFXIVREPLAY"u8)||U16(h,12)!=5)throw new InvalidDataException("仅支持 FFXIVREPLAY v5 .dat 录像");
        if(U32(h,72)+876L!=file.Length)throw new InvalidDataException("录像长度与头部不一致，文件可能已截断");
        var build=(int)U32(h,16);
        if(!profile.Builds.Contains(build))throw new InvalidDataException($"客户端 build {build} 没有对应协议配置，不能套用 {profile.Name} 的包号。请更新 Data/protocol.json。");
        var r=new Recording{Path=System.IO.Path.GetFullPath(path),Build=build,Content=U16(h,32),DurationMs=U32(h,24)};
        var chapterCount=U32(h,104);if(chapterCount>64)throw new InvalidDataException("录像章节超过 64 项");
        for(var i=0;i<chapterCount;i++) {var p=108+i*12;var offset=U32(h,p+4);if(offset>file.Length-876)throw new InvalidDataException("章节偏移超出录像");r.Chapters.Add(new((int)U32(h,p),offset,U32(h,p+8)));}
        var opnames=profile.Opcodes.ToDictionary(p=>p.Value,p=>p.Key);
        var current=new Dictionary<uint,ActorInfo>();var objectSlots=new Dictionary<byte,uint>();
        var statuses=new Dictionary<string,Dictionary<ushort,ushort>>();
        var actorNumber=0;var playerNumber=0;
        ActorInfo Actor(uint id,uint ms) {
            if(id==0||id==0xE0000000)return new(){Key="无目标"};
            if(current.TryGetValue(id,out var info))return info;
            var player=id>=0x10000000&&id<0x40000000;
            var a=new ActorInfo{Id=id,Key=player?$"P{++playerNumber}":$"A{++actorNumber}",Kind=player?"player":"unknown",FirstMs=ms};
            current[id]=a;r.Actors[a.Key]=a;return a;
        }
        var header=new byte[12];var payload=new byte[ushort.MaxValue];long lastProgress=0;uint lastMs=0;int regressions=0;
        while(file.Position<file.Length) {
            cancel.ThrowIfCancellationRequested();var offset=file.Position;
            if(file.Length-offset<12)throw new InvalidDataException($"0x{offset:X}：数据段头部被截断");
            file.ReadExactly(header);var op=U16(header);var size=U16(header,2);var ms=U32(header,4);var actorId=U32(header,8);
            if(file.Length-file.Position<size)throw new InvalidDataException($"0x{offset:X}：数据段负载被截断");
            file.ReadExactly(payload.AsSpan(0,size));var b=payload.AsSpan(0,size);r.PacketCount++;
            if(ms==uint.MaxValue||r.DurationMs==uint.MaxValue)throw new InvalidDataException("录像时间戳超出可分段范围");
            if(ms+1000L<lastMs)regressions++;lastMs=ms;r.DurationMs=Math.Max(r.DurationMs,ms);
            if(r.PacketCount-lastProgress>8192){lastProgress=r.PacketCount;progress?.Report(((double)file.Position/file.Length,$"读取 {System.IO.Path.GetFileName(path)} · {r.PacketCount:N0} 包"));}
            if(!opnames.TryGetValue(op,out var kind)){r.UnknownOpcodes[op]=r.UnknownOpcodes.GetValueOrDefault(op)+1;continue;}
            var ordinal=0;
            ReplayEvent Add(string name,EventRole roles,string summary,uint source=uint.MaxValue) {
                var a=Actor(source==uint.MaxValue?actorId:source,ms);
                var e=new ReplayEvent{Id=offset*128+ordinal++,Ms=ms,Offset=offset,Opcode=op,PayloadSize=size,Kind=name,Roles=roles,Actor=a.Key,Position=a.Position,Rotation=a.Rotation,Summary=summary};
                r.Events.Add(e);return e;
            }
            void Need(int n){if(size<n)throw new InvalidDataException($"0x{offset:X}：{kind} 需要至少 {n} 字节，实际 {size}");}
            switch(kind) {
                case "Rsv": {
                    Need(52);var length=U32(b);if(length>4096||length+52!=size)throw new InvalidDataException($"0x{offset:X}：RSV 长度无效");
                    var key=Encoding.UTF8.GetString(b[4..52]).TrimEnd('\0');var value=new UTF8Encoding(false,true).GetString(b[52..]);
                    var e=Add("RSV",EventRole.Resource,$"{key} → {value}",0);e.ResourceKey=key;e.ResourceValue=value;break;
                }
                case "Rsf": {Need(72);var e=Add("RSF",EventRole.Resource,"资源参数（64 字节）",0);e.ResourceKey=U64(b).ToString("X16");e.ResourceValue=Convert.ToHexString(b[8..72]);break;}
                case "SpawnNpc": {
                    Need(656);if(current.TryGetValue(actorId,out var old)&&old.Base!=0)current.Remove(actorId);
                    var a=Actor(actorId,ms);a.Kind="npc";a.Base=U32(b,64);a.NameId=U32(b,68);a.Layout=U32(b,72);a.Owner=U32(b,84);a.Position=Position(b,512);a.Rotation=Rotation(b,114);
                    var e=Add("生成 NPC",EventRole.Object,"NPC 实体创建");e.Value=a.Base;e.Parameters=[U32(b,92),U32(b,100),U16(b,112),b[147],b[148],b[149],a.Layout,a.Owner];break;
                }
                case "SpawnObject": {
                    Need(64);var id=U32(b,8);if(current.ContainsKey(id))current.Remove(id);var a=Actor(id,ms);a.Kind="object";a.Base=U32(b,4);a.Layout=U32(b,12);a.BindLayout=U32(b,24);a.Position=Position(b,52);a.Rotation=Rotation(b,34);objectSlots[b[0]]=id;
                    var e=Add("生成 EObj",EventRole.Object|EventRole.Visual,$"Base={a.Base} Layout={a.Layout} Bind={a.BindLayout}",id);e.Value=a.Base;e.Parameters=[b[1],b[2],b[3],a.Layout,a.BindLayout,b[38],U32(b,44),U32(b,48)];break;
                }
                case "DeleteObject": {Need(1);var id=objectSlots.GetValueOrDefault(b[0]);Add("删除 EObj",EventRole.Object,$"槽位 {b[0]}",id);objectSlots.Remove(b[0]);current.Remove(id);break;}
                case "DeleteActor": {Need(8);var id=U32(b,4);Add("删除演员",EventRole.Object,"实体移除",id);current.Remove(id);break;}
                case "ActorMove": case "ActorSetPos": {
                    var packed=kind=="ActorMove";Need(packed?12:20);var a=Actor(actorId,ms);a.Position=Position(b,packed?6:8,packed);a.Rotation=Rotation(b,0);
                    if(a.Kind!="player")Add(packed?"ActorMove":"ActorSetPos",EventRole.Movement,packed?"连续移动包":"直接定位包");break;
                }
                case "ActorCast": {
                    Need(32);var e=Add("读条",EventRole.Cast|EventRole.Visual,"技能读条");e.Action=U32(b,4);e.AnimationAction=U16(b);e.Duration=F32(b,8);e.Target=Actor(U32(b,12),ms).Key;e.Position=Position(b,24,true);e.Rotation=Rotation(b,16);e.Parameters=[b[2],b[3],U16(b,18)];e.Summary=$"技能 {e.Action} / 表现ID {e.AnimationAction} · {e.Duration:F3} 秒 · 预兆参数 {b[3]}";break;
                }
                case "ActionEffect1": case "ActionEffect8": case "ActionEffect16": case "ActionEffect24": case "ActionEffect32": {
                    var cap=int.Parse(kind[12..]);Need(48+cap*72);var e=Add("技能效果",EventRole.Visual,"动作效果包");e.Action=U32(b,8);e.AnimationAction=U16(b,28);e.Sequence=U32(b,12);e.Rotation=Rotation(b,26);e.Target=Actor(U32(b),ms).Key;e.Parameters=[b[30],b[31],b[32],b[33],U16(b,24)];
                    if(b[33]>cap)throw new InvalidDataException($"0x{offset:X}：目标数超过效果包容量");
                    for(var i=0;i<b[33];i++) {
                        var targetId=(uint)U64(b,48+cap*64+i*8);var target=Actor(targetId,ms).Key;
                        for(var slot=0;slot<8;slot++) {
                            var p=42+i*64+slot*8;var type=b[p];if(type==0)continue;var value=(uint)U16(b,p+6);
                            if(type is 3 or 4 or 5 or 6 && (b[p+5]&0x40)!=0)value+=(uint)b[p+4]<<16;
                            var meaning=EffectMeaning(type);e.Effects.Add(new(target,type,meaning,value,U16(b,p+3),b.Slice(p,8).ToArray()));
                            if(IsResult(type))e.Roles|=EventRole.Result;else if(type is not (59 or 73))e.Roles|=EventRole.Unknown;
                        }
                    }
                    if(cap>1&&size>=48+cap*72+6)e.Position=Position(b,48+cap*72,true);
                    var outcomes=e.Effects.Select(x=>x.Meaning).Distinct().ToArray();e.Summary=$"技能 {e.Action} / 表现ID {e.AnimationAction} · {b[33]} 目标 · "+(outcomes.Length==0?"无已观察结算（不等于纯演出）":string.Join("、",outcomes));break;
                }
                case "MapEffect": {Need(12);var e=Add("MapEffect",EventRole.Map|EventRole.Visual,$"索引 {b[8]} · 状态 0x{U16(b,4):X4} / 0x{U16(b,6):X4}",0);e.Value=b[8];e.Param=U32(b,4);e.Parameters=[U32(b),U16(b,4),U16(b,6)];break;}
                case "MapEffects64": case "MapEffects128": {var count=kind=="MapEffects64"?64:128;Need(6+count*2);var e=Add("地图初始化",EventRole.Map|EventRole.Visual,$"{count} 项 MapEffect 初始状态",0);e.Value=U16(b,4);e.Parameters=Enumerable.Range(0,count).Select(i=>(uint)U16(payload,6+i*2)).ToArray();break;}
                case "Weather": {Need(8);var e=Add("天气",EventRole.Visual,$"天气 {b[0]} · 淡入 {F32(b,4):F2} 秒",0);e.Value=b[0];e.Duration=F32(b,4);break;}
                case "DirectorVars": {Need(24);var e=Add("Director 初始化",EventRole.State|EventRole.Visual,$"Director 0x{U32(b):X8} · Flag={b[4]}",0);e.Value=U32(b);e.Parameters=b[4..24].ToArray().Select(x=>(uint)x).ToArray();break;}
                case "ActorTimelines": {Need(64);for(var i=0;i<10;i++){var id=U32(b,i*4);if(id==0xE0000000)break;var e=Add("同步动画",EventRole.Visual,$"ActionTimeline {U16(b,40+i*2)}",id);e.Value=U16(b,40+i*2);}break;}
                case "ActorControl": case "ActorControlSelf": case "ActorControlTarget": {
                    Need(20);var category=U16(b);var ps=new[]{U32(b,4),U32(b,8),U32(b,12),U32(b,16)};
                    var name=category switch{14=>"演员死亡",20=>"状态获得",21=>"状态移除",23=>"状态通知",34=>"目标标记",35=>"连线",47=>"取消连线",50=>"仇恨目标",54=>"可选中",62=>"动画状态",63=>"模型状态",109=>"Director 事件",161=>"BGM",407=>"动作动画",412=>"表情动画",413=>"EObj 动画",414=>"可见性",415=>"隐藏演员",417=>"演员归属",607=>"演员演出",_=>""};
                    if(name.Length==0){r.UnknownOpcodes[op]=r.UnknownOpcodes.GetValueOrDefault(op)+1;break;}
                    var role=category switch{20 or 21 or 23=>EventRole.State|EventRole.Result,14 or 50 or 54 or 417=>EventRole.State,_=>EventRole.State|EventRole.Visual};
                    var e=Add(name,role,$"AC {category} · {string.Join(", ",ps.Select(v=>$"0x{v:X}"))}");e.Value=ps[0];e.Param=category;e.Parameters=ps;
                    if(category==109){e.Value=ps[1];e.Parameters=size>=28?new[]{ps[2],ps[3],U32(b,20),U32(b,24)}:new[]{ps[2],ps[3]};e.Summary=$"Director 事件 0x{e.Value:X8} · {string.Join(", ",e.Parameters)}";}
                    if(category==35)e.Target=Actor(ps[2],ms).Key;
                    if(category==50&&size>=28)e.Target=Actor(U32(b,24),ms).Key;
                    if(category is 20 or 21){e.Summary=$"状态 {ps[0]} · 参数 {ps[1]}";e.Target=Actor(ps[2],ms).Key;}
                    if(category==607)e.Target=Actor(ps[0],ms).Key;
                    if(category==417)Actor(actorId,ms).Owner=ps[0];break;
                }
                case "Status30": case "Status60": {
                    Need(kind=="Status30"?380:740);var actor=Actor(actorId,ms);var seen=new Dictionary<ushort,ushort>();
                    var offsets=kind=="Status30"?Enumerable.Range(0,30).Select(i=>20+i*12):Enumerable.Range(0,30).Select(i=>i*12).Concat(Enumerable.Range(0,30).Select(i=>380+i*12));
                    statuses.TryGetValue(actor.Key,out var previous);
                    foreach(var p in offsets){var id=U16(b,p);if(id==0)continue;var param=U16(b,p+2);seen[id]=param;if(previous is null||previous.GetValueOrDefault(id,ushort.MaxValue)!=param){var e=Add("状态快照",EventRole.State,$"快照包含状态 {id} · 参数 {param}");e.Value=id;e.Parameters=[param];e.Duration=F32(b,p+4);e.Target=Actor(U32(b,p+8),ms).Key;e.Evidence="状态快照差异；非精确施加时刻";}}
                    if(previous is not null)foreach(var id in previous.Keys.Except(seen.Keys)){var e=Add("状态快照移除",EventRole.State,$"快照不再包含状态 {id}");e.Value=id;e.Evidence="状态快照差异；非精确移除时刻";}
                    statuses[actor.Key]=seen;break;
                }
            }
        }
        if(regressions>0)r.Warnings.Add($"检测到 {regressions} 次时间戳回退；显示按时间和文件顺序排序，保留原偏移。");
        if(r.Events.Count==0)throw new InvalidDataException("没有识别到有效事件，请检查协议配置");
        r.Events.Sort((a,b)=>{var c=a.Ms.CompareTo(b.Ms);return c!=0?c:a.Id.CompareTo(b.Id);});
        file.Position=0;r.Sha256=Convert.ToHexString(SHA256.HashData(file)).ToLowerInvariant();
        progress?.Report((1,$"完成 {r.FileName}：{r.Events.Count:N0} 条事件"));return r;
    }
    public static bool IsResult(byte t)=>t is >=1 and <=18 or 20 or 24 or 26 or 28 or >=31 and <=36 or 50 or 55 or 74 or 75 or 76;
    public static string EffectMeaning(byte type)=>type switch{1=>"未命中",2=>"完整抵抗",3=>"伤害",4=>"治疗",5=>"格挡伤害",6=>"招架伤害",7=>"无敌",8=>"无效果提示",9=>"缺少所需状态",10=>"MP 减少",11=>"MP 恢复",12=>"TP 减少",13=>"TP 恢复",14=>"目标施加状态",15=>"来源施加状态",16=>"状态恢复",17=>"目标移除状态",18=>"来源移除状态",20=>"状态无效果",24=>"仇恨位置",26=>"仇恨减少",27=>"连击通知",28=>"反击",31=>"击退",32 or 33=>"吸引",34 or 35 or 36=>"自定义吸引",50=>"治疗 LB 复活",55=>"状态完全抵抗",59=>"VFX",73=>"模型状态",74=>"设置 HP",75=>"部分无敌",76=>"打断",_=>$"未知效果 {type}"};
}
