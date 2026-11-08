"""避免原 MechanicSim 的 TimeLineDef/Node/Phase 与后端实现类型产生名称冲突。"""
from pathlib import Path
root=Path(__file__).resolve().parents[1]/'resources/encounters/Definitions'
for path in root.rglob('*.cs'):
    text=path.read_text(encoding='utf-8')
    if path.name=='Global.cs':
        text=text.replace('global using Kawari.Encounters;\n','')
    elif 'using Kawari.Encounters;' not in text:
        text='using Kawari.Encounters;\n'+text
    path.write_text(text,encoding='utf-8')
