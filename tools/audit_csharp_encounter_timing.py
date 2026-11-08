"""一次性迁移审计：核对五本每个显式调用的累计时间和同帧顺序。"""
from pathlib import Path
from decimal import Decimal
import re

root=Path(__file__).resolve().parents[1]
legacy=root/'resources/scripts/content/ultimate/Definitions'
current=root/'resources/encounters/Definitions'
total=0
for content in ['r1fz','n4gw','z3oz','d2az','z3oy']:
    old=(legacy/'Timelines'/f'{content}.lua').read_text(encoding='utf-8')
    new=(current/'Timelines'/f'{content}.cs').read_text(encoding='utf-8')
    durations=[Decimal(n) for n in re.findall(r'duration=([\d.]+)',old)]
    waits=[Decimal(n) for n in re.findall(r'Duration = TimeSpan.FromSeconds\(([\d.]+)\)',new)]
    assert waits==[Decimal(0)]+durations,content+' 节点等待时间改变'
    callbacks=re.findall(r'RaidManager.Instance.RunGroup\((.*?)\);',new)
    old_nodes=re.findall(r'events=Merge\((.*?)\)\},',old)
    assert len(callbacks)==len(old_nodes)==len(durations)
    absolute=Decimal(0);count=0
    for node,callback,duration in zip(old_nodes,callbacks,durations):
        references=re.findall(r'ROOT\.\."(.*?)"',node)
        expected=[];actual=[]
        for ref in references:
            previous=(legacy/ref).read_text(encoding='utf-8')
            migrated=current/Path(ref).with_suffix('.cs')
            source=migrated.read_text(encoding='utf-8')
            class_name=re.search(r'public static class (\w+)',source)[1]
            assert class_name+'.Execute' in callback,(content,ref,'时间轴漏挂')
            expected.extend((absolute+Decimal(t),int(o)) for t,o in re.findall(r'At\(([\d.]+), (-?\d+),',previous))
            actual.extend((absolute+Decimal(t),int(o)) for t,o in re.findall(r'raid.Schedule\(TimeSpan.FromSeconds\(([\d.]+)\).*?order: (-?\d+)\);',source))
        assert sorted(expected)==sorted(actual),(content,absolute,'事件时序改变')
        count+=len(expected);absolute+=duration
    total+=count
    print(f'PASS {content}: {len(durations)} 节点，{count} 调用，{absolute} 秒')
assert total==7055,total
print(f'PASS {total} 调用的累计时点、同帧顺序、节点挂载与总时长一致')
