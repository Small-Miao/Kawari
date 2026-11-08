"""一次性离线迁移显式 Lua 定义为可编辑 C#；世界服不依赖此工具。"""
from pathlib import Path
import json,re

SRC=Path('resources/scripts/content/ultimate/Definitions')
DST=Path('resources/encounters/Definitions')
DATA=json.loads(Path('target/ultimate-analysis/csharp-migration.json').read_text(encoding='utf-8'))

class Expr(str): pass
class Parser:
    def __init__(self,text):
        text=re.sub(r'--[^\n]*','',text)
        text=re.sub(r'\(s\.forsaken_puddle_index or (\d+)\)',r'PUDDLE_\1',text)
        text=re.sub(r'd:actor_id\(A\.(\w+)\) or 0',r'REF_\1',text)
        self.t=re.findall(r'"(?:\\.|[^"\\])*"|0x[0-9a-fA-F]+|-?\d+(?:\.\d+)?(?:e[+-]?\d+)?|[A-Za-z_][\w.]*|[{}=,()]',text)
        self.i=0
    def take(self):v=self.t[self.i];self.i+=1;return v
    def value(self):
        t=self.take()
        if t=='{':
            values=[];mapping={}
            while self.t[self.i]!='}':
                if self.i+1<len(self.t) and self.t[self.i+1]=='=':
                    k=self.take();self.take();mapping[k]=self.value()
                else:values.append(self.value())
                if self.t[self.i]==',':self.take()
            self.take();assert not(values and mapping);return mapping or values
        if t.startswith('"'):return json.loads(t)
        if t in ['true','false','nil']:return {'true':True,'false':False,'nil':None}[t]
        if re.fullmatch(r'-?\d+(?:\.\d+)?(?:e[+-]?\d+)?',t):return float(t) if '.' in t or 'e' in t else int(t)
        if t.startswith('0x'):return int(t,16)
        if t.startswith('A.'):return Expr('ActorDefinitions.'+t[2:])
        if t.startswith('PUDDLE_'):return Expr('(byte)c.Get("forsaken-puddle", () => '+t[7:]+')')
        if t.startswith('REF_'):return Expr('c.D.Find(ActorDefinitions.'+t[4:]+')')
        raise ValueError(t)
    def arguments(self):
        result=[]
        while self.i<len(self.t):
            result.append(self.value())
            if self.i<len(self.t):assert self.take()==','
        return result

def cs(v):
    if isinstance(v,Expr):return str(v)
    if isinstance(v,dict):
        if set(v)=={'x','y','z'}:return 'new Position('+', '.join(cs(v[k]) for k in ['x','y','z'])+')'
        return 'new Params { '+', '.join('['+json.dumps(k)+'] = '+cs(x) for k,x in v.items())+' }'
    if isinstance(v,list):return 'new object?[] { '+', '.join(cs(x) for x in v)+' }'
    return json.dumps(v,ensure_ascii=False,allow_nan=False)

def write(path,text):
    p=DST/path;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text,encoding='utf-8')

def call(body):
    body=body.strip()
    if '.Mark(d,s)' in body:return 'c.Get("top-meteor", () => new Script.Definitions.Actions.TOP.CosmoMeteor()).Mark(c);'
    m=re.fullmatch(r'(C\.(\w+)|s.scene:(\w+)|scene:(\w+)|d:(\w+))\((.*)\)',body,re.S)
    if not m:raise ValueError(body)
    _,actor,scene,initial,native,args=m.groups()
    args=re.sub(r'^d\s*,\s*s\s*,|^d\s*,','',args)
    a=Parser(args).arguments()
    if actor:
        if actor=='Status':
            vals=', '.join('new StatusSpec('+str(s['id'])+', '+str(s.get('param',0))+', '+cs(s['duration'])+')' for s in a[1])
            return f'c.Actors.Status({cs(a[0])}, new StatusSpec[] {{ {vals} }});'
        if actor=='SynchronizedTimelines':
            vals=', '.join('('+cs(x[0])+', (ushort)'+cs(x[1])+')' for x in a[0])
            return f'c.Actors.SynchronizedTimelines(new (string, ushort)[] {{ {vals} }});'
        return 'c.Actors.'+actor+'('+', '.join(cs(x) for x in a)+');'
    if scene or initial:return 'c.Scene.'+(scene or initial)+'('+', '.join(cs(x) for x in a)+');'
    if native=='setup_map_effects':return 'c.D.SetupMapEffects(new ushort[] { '+', '.join(map(str,a[0]))+' }, '+str(a[1])+');'
    if native=='director_event':return 'c.D.Emit("director_event", '+cs(a[0])+', '+cs(a[1])+');'
    name={'set_weather':'Weather','set_bgm':'SetBgm'}[native]
    return 'c.D.'+name+'('+', '.join(cs(x) for x in a)+');'

def class_name(path,group):return ('Sequence' if group=='Sequences' else 'Scene')+path.stem.replace('_','')
count=0
for content,item in DATA.items():
    catalog=item['actors'];namespace='Script.Definitions.'+content
    text='// 本副本演员名称与原生生成模板。\nnamespace '+namespace+';\npublic static class ActorDefinitions\n{\n'
    for name,key in catalog['names'].items():text+=f'    public const string {name} = {cs(key)};\n'
    text+='    public static ActorCatalog Build() => new()\n    {\n'
    text+=f'        Boss = {cs(catalog["boss"])}, BossBase = {catalog["boss_base"]}, DirectorFlag = {catalog["director_flag"]},\n'
    text+='        Initial = ['+', '.join(cs(v) for v in catalog['initial'])+'],\n'
    for field,key in [('Templates','templates'),('DeathEffects','death_effects')]:
        text+='        '+field+' = new()\n        {\n'
        for name,spec in catalog.get(key,{}).items():text+=f'            [{cs(name)}] = {cs(spec)},\n'
        text+='        },\n'
    text+='    };\n}\n';write(Path('Actors')/(content+'.cs'),text)
    for group in ['Sequences','Scenes']:
        for path in (SRC/group/content).glob('*.lua'):
            source=path.read_text(encoding='utf-8')
            if path.stem=='Initial':
                text='// 入场及重置恢复前阶段场景，再创建静态物件。\nnamespace '+namespace+';\npublic static class InitialScene\n{\n'
                for name,body in re.findall(r'function M\.(\w+)\(d,scene\)\n(.*?)^end',source,re.S|re.M):
                    # 括号深度用于拆分跨行的物件模板。
                    calls=[];buf='';depth=0
                    for line in body.splitlines():
                        buf+=line+'\n';depth+=line.count('(')-line.count(')')
                        if depth==0 and buf.strip():calls.append(call(buf));buf=''
                    text+=f'    public static void {name}(EncounterContext c)\n    {{\n'+''.join('        '+v+'\n' for v in calls)+'    }\n'
                text+='}\n'
            else:
                rows=re.findall(r'At\(([-\d.e]+), ([-\d]+), function\(d,s\)\n(.*?)\n    end\)',source,re.S)
                assert len(rows)==source.count('    At('),str(path)
                text='// '+source.splitlines()[0].removeprefix('-- ')+'\n// At 为节点相对秒数，Order 保留同帧顺序。\nnamespace '+namespace+';\npublic static class '+class_name(path,group)+'\n{\n    public static TimelineEvent[] Build() =>\n    [\n'
                for at,order,body in rows:text+=f'        new({at}, {order}, c => {{ {call(body)} }}),\n'
                text+='    ];\n}\n';count+=len(rows)
            write(Path(group)/content/(path.stem+'.cs'),text)
    source=(SRC/'Timelines'/f'{content}.lua').read_text(encoding='utf-8')
    tail=source[source.index('return {'):]
    name=re.search(r'name="([^"]+)"',tail).group(1)
    mods=re.findall(r'"([A-Z]+/\w+)"',tail)
    text='// 可编辑阶段与节点；场景、演员和判定由独立 C# 定义装配。\nnamespace '+namespace+';\npublic sealed class Timeline : ITimeLineDefinition\n{\n'
    text+=f'    public string DefinitionId => "{content}";\n    public TimeLineDef Build() => UltimateEncounter.Configure(new()\n    {{\n        TimeLineName = {cs(name)},\n        Actors = ActorDefinitions.Build(),\n        InitialScene = {"SceneHooks.Initial" if content=="d2az" else "InitialScene.Reset"}, InitialObjects = InitialScene.SpawnObjects,\n'
    props={'arena_radius':'ArenaRadius','enrage_cast':'EnrageCast','enrage_delay':'EnrageDelay','arena_square':'ArenaSquare','arena_rotation':'ArenaRotation'}
    for key,prop in props.items():
        if match:=re.search(key+r'=([^,}\n]+)',tail):text+=f'        {prop} = '+match[1].replace('math.pi','Math.PI')+',\n'
    text+='        Actions = ['+', '.join('new Script.Definitions.Actions.'+m.replace('/','.')+'()' for m in mods)+'],\n        TimeLinePhaseList =\n        [\n'
    phase=False
    for line in source.splitlines():
        if match:=re.search(r'\{name="([^"]+)",nodes=\{',line):
            if phase:text+='            ]),\n'
            text+=f'            new({cs(match[1])},\n            [\n';phase=True
        elif match:=re.search(r'\{name="([^"]+)", duration=([\d.]+), events=Merge\((.*)\)\}',line):
            paths=re.findall(r'"(Sequences|Scenes)/'+content+r'/([^"/]+)\.lua"',match[3])
            builds=[class_name(Path(p+'.lua'),g)+'.Build()' for g,p in paths]
            text+=f'                new() {{ NodeName = {cs(match[1])}, Duration = {match[2]}, Events = [ '+', '.join('.. '+v for v in builds)+' ] },\n'
    text+='            ]),\n        ],\n    });\n}\n';write(Path('Timelines')/(content+'.cs'),text)
    for module,rules in item['modules'].items():
        ns,name=module.split('/')
        text='// 原生技能 ID、命中形状和可调伤害；行为钩子在同名机制文件。\nnamespace Script.Definitions.Actions.'+ns+';\npublic partial class '+name+' : ActionDefinition\n{\n    private readonly Dictionary<uint, Params> rules = new()\n    {\n'
        for action,spec in sorted(rules.items(),key=lambda x:int(x[0])):text+=f'        [{action}] = {cs(spec)},\n'
        text+='    };\n    public override IReadOnlyDictionary<uint, Params> Rules => rules;\n}\n'
        write(Path('Actions')/ns/(name+'.Rules.cs'),text)
write(Path('Global.cs'),'// 动态编译使用的公共引用。\nglobal using System;\nglobal using System.Collections.Generic;\nglobal using System.Linq;\nglobal using Kawari.Encounters;\n')
print('已迁移显式调用',count)
