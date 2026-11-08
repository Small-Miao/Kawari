"""一次性迁移收尾：地图初始化与主时间轴保持无参回调写法。"""
from pathlib import Path
root=Path(__file__).resolve().parents[1]/'resources/encounters/Definitions'
for content in ['r1fz','n4gw','z3oz','d2az','z3oy']:
    path=root/'Scenes'/content/'Initial.cs'
    text=path.read_text(encoding='utf-8')
    text=text.replace('namespace Script.', 'using MechanicSim_Server.Manager;\nnamespace Script.')
    text=text.replace('Reset(EncounterContext c)', 'Reset()').replace('SpawnObjects(EncounterContext c)', 'SpawnObjects()')
    text=text.replace('c.D.SetupMapEffects', 'RaidManager.Instance.SetupMapEffects').replace('c.Scene.', 'RaidManager.Instance.')
    text=text.replace('c.D.Weather', 'RaidManager.Instance.SetWeather').replace('c.D.SetBgm', 'RaidManager.Instance.PlayBgm')
    path.write_text(text,encoding='utf-8')
    path=root/'Timelines'/f'{content}.cs';text=path.read_text(encoding='utf-8')
    text=text.replace('InitialScene = InitialScene.Reset', 'InitialScene = _ => InitialScene.Reset()').replace('InitialObjects = InitialScene.SpawnObjects','InitialObjects = _ => InitialScene.SpawnObjects()')
    inside=False;lines=[]
    for line in text.splitlines():
        if line.strip()=='TimeLineName = "'+{'r1fz':'幻想龙诗绝境战','n4gw':'光暗未来绝境战','z3oz':'欧米茄绝境验证战','d2az':'亚历山大绝境战','z3oy':'妖星乱舞绝境战'}[content]+'",' and line.startswith('        TimeLineName'):
            inside=True
        if inside and line=='        });':inside=False
        lines.append('    '+line if inside else line)
    path.write_text('\n'.join(lines)+'\n',encoding='utf-8')
path=root/'Scenes/d2az/SceneHooks.cs'
text=path.read_text(encoding='utf-8').replace('InitialScene.Reset(c)','InitialScene.Reset()')
path.write_text(text,encoding='utf-8')
