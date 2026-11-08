"""一次性将已迁移的定义改写为 MechanicSim 的无参回调与 TimeSpan 风格。"""
from pathlib import Path
import re
ROOT=Path('resources/encounters/Definitions')
MAP={'Move':'SetPosition','Cast':'TryCast','Action':'ExecuteAction','Target':'SetTarget','Owner':'SetOwner','Status':'ApplyStatuses','Targetable':'SetEncounterTargetable','Animation':'SetAnimationState','Model':'SetModelState','Timeline':'PlayTimeline','Visible':'SetVisible','Presentation':'SetPresentation','Tether':'Tether','Untether':'Untether','Hide':'Hide','Despawn':'Destory'}
def convert(body):
    m=re.fullmatch(r'c\.Actors\.(\w+)\((.*)\);',body,re.S)
    if m:
        name,args=m.groups()
        if name=='SynchronizedTimelines':return 'raid.SynchronizedTimelines('+args+');'
        first,_,rest=args.partition(',')
        rest=rest.strip()
        if name=='Spawn':return 'raid.SpawnActor('+first+');'
        if name=='Cast':
            action,seconds,options=rest.split(',',2)
            rest=action+', TimeSpan.FromSeconds('+seconds.strip()+'),'+options
        return 'raid.GetObjectByGameObjectId('+first+')?.'+MAP[name]+'('+rest+');'
    return body.replace('c.Scene.','raid.').replace('c.D.Emit("director_event",','raid.DirectorEvent(').replace('c.D.SetBgm(','raid.PlayBgm(').replace('c.D.Weather(','raid.SetWeather(').replace('c.D.SetupMapEffects(','raid.SetupMapEffects(').replace('c.D.','raid.Context.D.').replace('c.Get(','raid.Context.Get(').replace('.Mark(c)','.Mark(raid.Context)')

for content in ['r1fz','n4gw','z3oz','d2az','z3oy']:
    for group in ['Sequences','Scenes']:
        for path in (ROOT/group/content).glob('*.cs'):
            if path.stem in ['Initial','SceneHooks']:continue
            source=path.read_text(encoding='utf-8')
            if 'TimelineEvent[] Build()' not in source:continue
            prefix=source[:source.index('    public static TimelineEvent[]')]
            prefix=prefix.replace('namespace ', 'using MechanicSim_Server.Manager;\nnamespace ',1)
            body='    public static void Execute()\n    {\n        var raid = RaidManager.Instance;\n'
            for at,order,run in re.findall(r'        new\(([^,]+), ([^,]+), c => \{ (.*?) \}\),',source):
                body+=f'        raid.Schedule(TimeSpan.FromSeconds({at}), () => {{ {convert(run)} }}, order: {order});\n'
            path.write_text(prefix+body+'    }\n}\n',encoding='utf-8')
    path=ROOT/'Timelines'/f'{content}.cs';source=path.read_text(encoding='utf-8')
    name=re.search(r'TimeLineName = ("[^"]+")',source)[1]
    config=source.split('    {\n',2)[-1] if False else source[source.index('        TimeLineName'):source.index('        TimeLinePhaseList')]
    prefix='// Duration 与原工程一致：先等待，再执行 OnTimeLineEvent。\nusing MechanicSim_Server.Manager;\nusing TimeLineDef = MechanicSim_Server.Struct.TimeLineDef;\nusing TimeLinePhase = MechanicSim_Server.Struct.TimeLinePhase;\nusing TimeLineNode = MechanicSim_Server.Struct.TimeLineNode;\nnamespace Script.Definitions.'+content+';\npublic sealed class Timeline : MechanicSim_Server.Definition.ITimeLineDefinition\n{\n'
    prefix+=f'    public string DefinitionId => "{content}";\n\n    public TimeLineDef Build()\n    {{\n        var timeline = new TimeLineDef\n        {{\n            TimeLineName = {name},\n            TimeLineDescription = "木桩触发后进入最终阶段",\n            TimeLineAuthor = "Kawari",\n        }};\n\n'
    prefix+='        // 原生模型、判定和重置接口在中间层统一装配。\n        timeline.NativeEncounter = UltimateEncounter.Configure(new Kawari.Encounters.TimeLineDef\n        {\n'+config+'        });\n\n'
    prefix+='        timeline.TimeLinePhaseList = new List<TimeLinePhase>\n        {\n'
    previous=0;opened=False
    for line in source.splitlines():
        if m:=re.search(r'^            new\(("[^"]+"),$',line):
            if opened:prefix+='                },\n            },\n'
            opened=True;prefix+='            new TimeLinePhase\n            {\n                PhaseName = '+m[1]+',\n                TimeLineNodes = new List<TimeLineNode>\n                {\n'
        elif m:=re.search(r'NodeName = ("[^"]+"), Duration = ([\d.]+), Events = \[ (.*?) \]',line):
            callbacks=re.findall(r'(\w+)\.Build\(\)',m[3])
            prefix+='                    new TimeLineNode\n                    {\n                        NodeName = '+m[1]+',\n                        Duration = TimeSpan.FromSeconds('+str(previous)+'),\n                        OnTimeLineEvent = () =>\n                        {\n                            RaidManager.Instance.RunGroup('+', '.join(c+'.Execute' for c in callbacks)+');\n                        },\n                    },\n'
            previous=float(m[2])
    prefix+='                    new TimeLineNode\n                    {\n                        NodeName = "等待最后机制结算",\n                        Duration = TimeSpan.FromSeconds('+str(previous)+'),\n                    },\n                },\n            },\n        };\n        return timeline;\n    }\n}\n'
    path.write_text(prefix,encoding='utf-8')
print('MechanicSim timeline and callback style applied')
