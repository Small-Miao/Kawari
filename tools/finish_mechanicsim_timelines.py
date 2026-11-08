"""一次性迁移工具：普通副本与凯夫卡 P2 采用原 MechanicSim 的入口接口。"""
from pathlib import Path

root = Path(__file__).resolve().parents[1] / 'resources/encounters/Definitions/Timelines'
header = '''using MechanicSim_Server.Manager;
using TimeLineDef = MechanicSim_Server.Struct.TimeLineDef;
using TimeLinePhase = MechanicSim_Server.Struct.TimeLinePhase;
using TimeLineNode = MechanicSim_Server.Struct.TimeLineNode;
'''
for name in ['KefkaP2', 'IfritHard', 'Sastasha', 'MerchantTale']:
    path = root / f'{name}.cs'
    text = path.read_text(encoding='utf-8')
    if 'MechanicSim_Server.Definition.ITimeLineDefinition' in text:
        continue
    text = text.replace('namespace Script.Definitions.Timelines;', header + 'namespace Script.Definitions.Timelines;')
    text = text.replace(': ITimeLineDefinition', ': MechanicSim_Server.Definition.ITimeLineDefinition')
    if name == 'KefkaP2':
        text = text.replace('Duration=duration,Events=[new(duration,0,e.Run)]', 'Duration=TimeSpan.FromSeconds(duration),OnTimeLineEvent=()=>e.Run(RaidManager.Instance.Context)')
        text = text.replace('Duration=10}', 'Duration=TimeSpan.FromSeconds(10)}')
        text = text.replace('return new(){TimeLineName="凯夫卡 P2 一运",Actors=', 'return new(){TimeLineName="凯夫卡 P2 一运",TimeLinePhaseList=[new(){PhaseName="P2 一运",TimeLineNodes=nodes}],\n            NativeEncounter=new Kawari.Encounters.TimeLineDef{TimeLineName="凯夫卡 P2 一运",Actors=')
        text = text.replace('            TimeLinePhaseList=[new("P2 一运",nodes.ToArray())],\n', '')
        text = text.replace('player);}}};', 'player);}}}};')
    elif name == 'IfritHard':
        text = text.replace('return new(){TimeLineName="真火神歼灭战",OnTimeLineInit=actions.Setup,\n            TimeLinePhaseList=[new("循环",[new(){NodeName="地火／炎柱／旋风",Duration=48,OnEnter=c=>actions.Cycle(c,0)}])],', '''return new(){TimeLineName="真火神歼灭战",
            TimeLinePhaseList=[new(){PhaseName="循环",TimeLineNodes=[
                new(){NodeName="地火／炎柱／旋风",Duration=TimeSpan.Zero,OnTimeLineEvent=()=>actions.Cycle(RaidManager.Instance.Context,0)},
                new(){NodeName="首轮结束",Duration=TimeSpan.FromSeconds(48)}]}],
            NativeEncounter=new Kawari.Encounters.TimeLineDef{TimeLineName="真火神歼灭战",OnTimeLineInit=actions.Setup,''')
        text = text.replace('            }};', '            }}};')
    elif name == 'Sastasha':
        text = text.replace('return new(){TimeLineName="沙斯塔夏溶洞",OnTimeLineInit=dungeon.Setup,OnEvent=dungeon.Event,PreserveStateOnReset=true,\n            DebugShortcuts=[11432969,11432970,11432971,11432972],\n            TimeLinePhaseList=[new("探索",[', '''return new(){TimeLineName="沙斯塔夏溶洞",
            NativeEncounter=new Kawari.Encounters.TimeLineDef{TimeLineName="沙斯塔夏溶洞",OnTimeLineInit=dungeon.Setup,OnEvent=dungeon.Event,PreserveStateOnReset=true,DebugShortcuts=[11432969,11432970,11432971,11432972]},
            TimeLinePhaseList=[new(){PhaseName="探索",TimeLineNodes=[''')
        text = text.replace('WaitUntil=_=>', 'WaitUntil=()=>').replace('Timeout=604800', 'Timeout=TimeSpan.FromDays(7)').replace('])]}', ']}]}')
    else:
        text = text.replace('return new(){TimeLineName="商客奇谭",OnTimeLineInit=', 'return new(){TimeLineName="商客奇谭",NativeEncounter=new Kawari.Encounters.TimeLineDef{TimeLineName="商客奇谭",OnTimeLineInit=')
        text = text.replace('            }};', '            }}};')
    path.write_text(text, encoding='utf-8')
