"""一次性导入用户的 P2 一运定义并替换客户端表现接口；后续直接编辑导出的 C#。"""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[2]
source = Path('D:/Code/MechanicSim-Master/Script/Definitions')
dest = root / 'resources/controllers/umad-p2/Definitions'
if dest.exists():
    raise SystemExit('目标已存在，不覆盖已编辑的机制定义。')
files = [(source/'Timelines/KfkP2_1Timeline.cs','Timelines/KefkaP2.cs')]
files += [(p, 'Actions/'+p.name) for p in (source/'Actions/UKFKP2').glob('*.cs')]
files += [(source/'Statuses/UKFKP2/咏唱危机.cs','Statuses/咏唱危机.cs'), (source/'Statuses/魔法防御力降低.cs','Statuses/魔法防御力降低.cs')]
for path, target in files:
    text = path.read_text(encoding='utf-8-sig')
    text = 'using Kawari.MechanicSim;\n'+text
    # 原脚本若干分支引用未定义的 1000/1001；这里统一到明确的死亡/魔法易伤语义。
    if target.startswith('Actions/'):
        text = text.replace('HasStatus(1001)', 'HasStatus(9001)').replace('AddStatus(1001)', 'AddStatus(9001)').replace('AddStatus(1000)', 'AddStatus(9000)')
        text = re.sub(r'(\w+)\.AddStatus\(9000\);', r'Presentation.Kill(\1, (uint)castInfo.ActionInfo.GameActionId);', text)
        text = re.sub(r'(\w+)\.AddStatus\(9001\);', r'\1.AddStatus(9001); Presentation.Hit(\1, (uint)castInfo.ActionInfo.GameActionId, 100000);', text)
        text = text.replace('p.SendDamageText(900000, "光之波动", FlyTextIconEnum.Magic);', '// 录像中光之波动结算本身为 0 伤害，真实伤害由咏唱危机分支产生。')
        text = text.replace('var target = result.First();', 'var target = result.FirstOrDefault();\n                                        if (target == null) break;')
        text = re.sub(r'^.*\.SendDamageText\(.*\);\s*$', '', text, flags=re.M)
    # 点名图标使用本地 Lockon.csv 与录像核对的 ID。
    for suffix,icon in [('c07c',715),('c08c',716),('c09c',717)]:
        text = re.sub(r'(?:RaidManager\.Instance|raidManager)\.PlayActionVfx\(([^,]+)\.PlayerName\s*,\s*[^,]+,\s*"vfx/lockon/eff/m0462trg_'+suffix+r'\.avfx"\s*,\s*5000\);', rf'Presentation.Icon(\1, {icon});', text)
    replacements = {
        'raidManager.PlayStaticVfx("bg/ex2/05_zon_z3/common/vfx/eff/b1352pil01_u.avfx", Vector3.One, castInfo.Caster.Position, 0, 10000, 0);': 'Presentation.Tower(castInfo.Caster.Position);',
        'raidManager.PlayStaticVfx("bg/ex2/05_zon_z3/common/vfx/eff/b3793had01_y1.avfx", Vector3.One, castInfo.Caster.Position, 0, 9000,3000);':'',
        'raidManager.PlayActionVfx(player.PlayerName,player.PlayerName, "vfx/monster/gimmick6/eff/z3oy_b0_g06c0c.avfx",0);':'Presentation.EffectAt(47808, player.Position);',
        'raidManager.PlayActionVfx(player.PlayerName,player.PlayerName,"vfx/monster/gimmick6/eff/z3oy_b0_g07c0c.avfx",0);':'Presentation.EffectAt(47809, player.Position);',
        'raidManager.PlayStaticVfx("vfx/omen/eff/z6r3_b4_fan90_k2.avfx", new Vector3(50, 50, 50), player.Position, Rotation, 1500, 0);':'Presentation.EffectAt(47810, player.Position, Rotation);',
        'raidManager.PlayActionVfx(castInfo.Caster.GameObjectName, castInfo.Caster.GameObjectName, "vfx/monster/gimmick2/eff/z3oa_b0_g12c0c.avfx", 0);':'Presentation.EffectAt(47807, castInfo.Caster.Position);',
        'raidManager.PlayActionVfx(castInfo.Caster.GameObjectName, castInfo.Caster.GameObjectName, "vfx/monster/gimmick2/eff/z3oa_b0_g11c0c.avfx", 0);':'Presentation.EffectAt(47806, castInfo.Caster.Position);',
        'raidManager.PlayActionVfx(castInfo.TargetPlayer.PlayerName, castInfo.TargetPlayer.PlayerName, "vfx/monster/m0459/eff/m0459sp04t0c.avfx", 0);':'Presentation.EffectAt((uint)castInfo.ActionInfo.GameActionId, castInfo.TargetPlayer.Position);',
        'RaidManager.Instance.ShowGimmickHint("时间轴已经停止/重置", 40, TextGimmickHintStyle.Warning);':'',
        'new System.Numerics.Vector3(-5.567f, 0, 5.567f)':'new System.Numerics.Vector3(-5.657f, 0, 5.657f)',
    }
    for old,new in replacements.items(): text=text.replace(old,new)
    # 去除已停用的客户端特效示例，避免误认为仍在使用。
    text='\n'.join(l for l in text.splitlines() if not (l.lstrip().startswith('//') and ('PlayStaticVfx' in l or 'PlayActionVfx' in l)))
    if 'PlayStaticVfx(' in text or 'PlayActionVfx(' in text: raise RuntimeError(f'尚有未迁移表现：{target}')
    if target.startswith('Timelines/'):
        text=text.replace('RaidManager.Instance.PlayBgm(533);', '''RaidManager.Instance.PlayBgm(533);
            Native.ActorDied += id => {
                if (Native.State.Bindings.TryGetValue("ms-3000", out var boss) && id == boss)
                    Native.Complete();
            };
            Native.MapEffect(0, 64, 128);
            Native.MapEffect(17, 1, 2);
            Native.MapEffect(18, 1, 4);
            for (byte index = 1; index <= 8; index++) Native.MapEffect(index, 4, 8);''')
    output=dest/target;output.parent.mkdir(parents=True,exist_ok=True);output.write_text(text,encoding='utf-8')
print(f'导入 {len(files)} 个 C# 定义到 {dest}')
