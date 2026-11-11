"""汇总国服动作/特性、匿名录像与源码落点；不会把静态定位冒充实机验收。"""
import argparse
from collections import Counter, defaultdict
import hashlib
import json
from pathlib import Path
import re

JOBS={
    'WAR':('战士','warrior.rs'), 'DRK':('暗黑骑士','dark_knight'),
    'GNB':('绝枪战士','gunbreaker.rs'), 'SCH':('学者','scholar'),
    'SGE':('贤者','sage'), 'MCH':('机工士','machinist'),
    'MNK':('武僧','monk'), 'SAM':('武士','samurai'),
    'DNC':('舞者','dancer'), 'VPR':('蝰蛇剑士','viper'),
    'RDM':('赤魔法师','red_mage'), 'RPR':('钐镰客','reaper'),
}
ISSUES={
    'WAR':'动作、资源及队伍结算已有回归；全技能视觉尚未实机验收。',
    'DRK':'掠影的独立属性与精确动作时点仍需实机标定。',
    'GNB':'伪装的招架减伤已结算，招架结果协议标志尚未完成对照。',
    'SCH':'炽天使、慰藉、以太契约缺对应录像；契约连线与独立宠物属性待核验。复活确认服务端已补齐，尚未部署/实机验收。',
    'SGE':'复活确认服务端已补齐，尚未部署/实机验收；幸福当前按状态治疗包下发，独立 Action 37036 未见于两份录像。非副本初始蛇刺待核验。',
    'MCH':'人偶独立属性和喷射器精确应用延迟待实机标定；低等级车式炮塔不在本次范围。',
    'MNK':'范围战技多目标暴击的斗气次数当前按每次技能最多一次，仍需专项证据。',
    'SAM':'完全被护盾吸收时的天眼触发当前按受到攻击处理，此边界待实机对照。',
    'DNC':'队友伶俐使用集中 20% 近似概率，各职业真实概率尚未标定。',
    'VPR':'本人量谱与完整派生链已有回归，实际移动和演出仍待客户端验收。',
    'RDM':'复活确认服务端已补齐，尚未部署/实机验收；实际位移和全技能演出待验收。',
    'RPR':'地狱之门固定对象/回退坐标已回归，实际位移和化身演出待验收。',
}

def read(path):
    return json.loads(path.read_text(encoding='utf-8'))

def cell(text):
    return str(text).replace('|','／').replace('\r','').replace('\n','<br>')

def mentions(text, value):
    if re.search(rf'(?<![\w]){value}(?![\w])',text): return True
    return any(int(a)<=value<=int(b) for a,b in re.findall(r'\b(\d+)\s*\.\.=\s*(\d+)\b',text))

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--root',type=Path,default=Path('.'))
    ap.add_argument('--data',type=Path,default=Path('target/arr-job-audit'))
    ap.add_argument('--out',type=Path,default=Path('helloagents/wiki/modules/arr_jobs_100_audit'))
    args=ap.parse_args();root=args.root.resolve();data=args.data;out=args.out
    out.mkdir(parents=True,exist_ok=True)
    meta=read(data/'job-metadata.json');actions={a['id']:a for a in meta['actions']}
    evidence=defaultdict(list);seen=set()
    for folder in ['evidence','supplement-cli']:
        for p in (data/folder).glob('*.json'):
            d=read(p)
            if not isinstance(d,dict) or 'records' not in d or d['sha256'] in seen:continue
            seen.add(d['sha256']);evidence[d['job']].append(d)
    lua=list((root/'resources/scripts/actions').rglob('*.lua'))
    lua_ids=defaultdict(list)
    for p in lua:
        match=re.search(r'_(\d+)\.lua$',p.name)
        if match:lua_ids[int(match[1])].append(p)
    totals=[];manifest={'build':14251465,'level':100,'files':{},'jobs':{}}
    common=[root/p for p in ['servers/world/src/server/action.rs','servers/world/src/gamedata.rs',
        'servers/world/src/zone_connection/stats.rs','servers/world/src/server/jobs/role.rs',
        'servers/world/src/server/revival.rs']]
    for job,(name,module) in JOBS.items():
        source=root/'servers/world/src/server/jobs'/module
        sources=[source] if source.is_file() else [p for p in source.glob('*.rs') if p.name!='tests.rs']
        source_text={p:p.read_text(encoding='utf-8') for p in sources}
        report=read(data/f'actionaudit-{job}.json')
        rows={a['id']:a for a in report['implemented']+report['missing'] if a['effective_at_level']}
        excluded=[]
        for aid in list(rows):
            if job not in actions.get(aid,{}).get('eligible_jobs',[]) and not(job=='DRK' and aid==36933):
                excluded.append(rows.pop(aid))
        counts=Counter();wire=defaultdict(set)
        for replay in evidence[job]:
            for e in replay['records']:
                if e['kind']!='action':continue
                counts[e['action']]+=1
                for t in e['targets']:
                    for effect in t['effects']:
                        if effect['type'] in (14,15,16,17):wire[e['action']].add(effect['value'])
        lines=[f'# {name}（{job}）100 级逐项审计','',
            '基准：国服 build 14251465。仅列当前最高等级仍有效的动作；低级替代动作列入导出目录而不重复验收。',
            '源码落点是静态定位，回放次数包含本人及演员动作；它们不表示该条全部效果已由测试或实机覆盖。测试范围及已知缺口见主审计记录。','',
            f'**待核验：** {ISSUES[job]}','', '## 技能与效果','',
            '| ID | 技能 | 类别 | 回放次数 | 录像状态 ID | 实现落点 / 边界 |',
            '|---|---|---|---:|---|---|']
        unresolved=[];manifest_rows=[]
        for aid,a in sorted(rows.items()):
            hits=[p for p,t in source_text.items() if mentions(t,aid)]
            if hits: location='原生：'+'、'.join(p.relative_to(root).as_posix() for p in hits[:2])
            elif aid in lua_ids:location='共用脚本：'+lua_ids[aid][0].relative_to(root).as_posix();hits=lua_ids[aid][:1]
            elif job=='SGE' and aid==37036:location='状态 3899 治疗路径；未使用独立动作，演出待核验'
            else:location='尚未定位，需复核';unresolved.append(aid)
            for p in hits+sources+common:
                if p.exists():manifest['files'][p.relative_to(root).as_posix()]=hashlib.sha256(p.read_bytes()).hexdigest()
            lines.append(f"| {aid} | {cell(a['name_loc'])} | {cell(a['kind'])} | {counts[aid]} | {','.join(map(str,sorted(wire[aid])))} | {cell(location)} |")
            manifest_rows.append({'id':aid,'observed':counts[aid],'location':location})
        traits=[t for t in meta['traits'] if job in t.get('eligible_jobs',[]) and 0<t['level']<=100]
        lines+=['','## 职业和职能特性','',
            '以下逐条保留本地 Trait 说明，便于继续逐效果复核；落点列表示实现责任，单独测试未覆盖的边界不标为完整验收。','',
            '| ID | 特性 / 学习等级 | 当前效果 | 实现责任 |', '|---|---|---|---|']
        for t in sorted(traits,key=lambda t:(t['level'],t['id'])):
            if t['job']==0:where='共用职能脚本、action.rs、paladin.rs / white_mage.rs'
            elif '积蓄' in t['description']:where=f'{module} + gamedata.rs 充能查询'
            elif '基本值' in t['description'] or '基本伤害' in t['description'] or '防护精通' in t['name']:where='zone_connection/stats.rs 属性/伤害与 action.rs 减伤'
            else:where=f'{module} 职业资源、变招、威力和效果'
            lines.append(f"| {t['id']} | {cell(t['name'])} / {t['level']} | {cell(t['description'])} | {where} |")
        lines+=['','## 输入录像','']+[f"- {r['source']}：本人量谱 {'已确认' if r['perspective']['first_person_evidence'] else '不适用（旁观）'}，SHA-256 `{r['sha256']}`。" for r in evidence[job]]
        if excluded:lines+=['','## 排除的旧工具误报','', 'ClassJobCategory 不属于该职业，未计入待实现动作：'+ '、'.join(f"{a['id']} {a['name_loc']}" for a in excluded)+'。']
        (out/f'{job}.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
        manifest['jobs'][job]={'actions':manifest_rows,'traits':[t['id'] for t in traits],'unlocated':unresolved}
        totals.append((job,name,len(rows),len(traits),unresolved))
    index=['# 100 级职业审计索引','','范围为本批 12 个职业；跳过既有职业。龙骑士、忍者缺录像，未纳入。',
        '静态接入、已通过的回归、实机验收分别记录，不能据脚本存在或 ID 出现认定完整实现。','',
        '| 职业 | 有效动作数 | 特性数 | 未定位动作 |','|---|---:|---:|---|']
    for j,n,a,t,u in totals:index.append(f"| [{n}（{j}）]({j}.md) | {a} | {t} | {','.join(map(str,u)) or '无'} |")
    index+=['','## 共用待核验边界','','- 普通复活确认、接受、拒绝和超时的服务端流程已实现并测试；尚未部署，当前客户端窗口/动画待实机验证，见 ../revival_protocol_20261111.md。',
        '- 控制状态已阻止行动/移动并支持受伤解除睡眠，但敌人控制抗性递减和免疫表仍待完整接入。',
        '- 亲疏自行的防击退已接入，受击施加减速及敌人动作速度结算尚未完整接入。',
        '- 浴血按直接物理伤害 25% 回血；当前录像没有浴血样本，比例与浮字协议仍待本人录像验证。',
        '- 所有职业的完整实机视觉验收、多人长时间实战尚未完成；各职业的具体缺口见对应页面。']
    (out/'index.md').write_text('\n'.join(index)+'\n',encoding='utf-8')
    (data/'implementation-manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
    for j,n,a,t,u in totals:print(f'{j}: {a} 个动作 / {t} 个特性，未定位 {u}')

if __name__=='__main__':main()
