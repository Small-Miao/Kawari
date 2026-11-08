"""从国服 FFXIVREPLAY v5 提取最终阶段；输出不含玩家身份的 Lua 数据。

只读原始录像。演员 ID 仅用于解析期间关联，输出使用本地序号。
用法：python tools/extract_ultimate_finals.py --recordings <目录> --bossmod <BossMod/Modules>
"""
import argparse
import collections
import csv
import hashlib
import json
import math
from pathlib import Path
import re
import struct

ROOT = Path(__file__).resolve().parents[1]
PROFILES = {
    'r1fz': ('幻想龙诗绝境战 2026.11.04 23.21.11.dat', 'Endwalker/Ultimate/DSW2/DSW2Enums.cs', 5664700, 5950000, 12616, 'phase 7', [26810, 25584, 29050]),
    'n4gw': ('光暗未来绝境战 2026.11.05 00.18.13.dat', 'Dawntrail/Ultimate/FRU/FRUEnums.cs', 1153400, 1513679, 17839, '// P5\n', [40231, 40232]),
    'z3oz': ('欧米茄绝境验证战 2026.11.07 21.48.13.dat', 'Endwalker/Ultimate/TOP/TOPEnums.cs', 4238900, 4588969, 15725, '// p6', [31555, 31623, 32626]),
    'd2az': ('亚历山大绝境战 2026.11.04 21.26.24.dat', 'Shadowbringers/Ultimate/TEA/TEAEnums.cs', 611300, 1006985, 11349, 'public enum AID : uint\n{', []),
    'z3oy': ('妖星乱舞绝境战 2026.11.03 17.11.19.dat', None, 988200, 1251186, 19511, None, []),
}

def u16(b, p=0): return struct.unpack_from('<H', b, p)[0]
def u32(b, p=0): return struct.unpack_from('<I', b, p)[0]
def f32(b, p=0): return struct.unpack_from('<f', b, p)[0]
def rot(b, p=0): return round(u16(b, p) / 65535 * 2 * math.pi - math.pi, 5)
def pos(b, p, packed=False):
    v = struct.unpack_from('<HHH' if packed else '<fff', b, p)
    return dict(zip(('x','y','z'), (round(x*2000/65535-1000 if packed else x, 4) for x in v)))

def lua(v):
    if v is None: return 'nil'
    if isinstance(v, bool): return 'true' if v else 'false'
    if isinstance(v, (int,float)): return str(v)
    if isinstance(v, str): return json.dumps(v, ensure_ascii=False)
    if isinstance(v, list): return '{'+','.join(map(lua,v))+'}'
    return '{'+','.join('['+lua(k)+']='+lua(val) for k,val in v.items())+'}'

def extract(key, profile, recordings, bossmod, csv_dir=None):
    filename, enums, start, end, boss_base, marker, extra = profile
    if enums:
        enum_text=(bossmod/enums).read_text(encoding='utf-8-sig').replace('\r\n','\n')
        oid_body=re.search(r'public enum OID[^\{]*\{(.*?)\n\}',enum_text,re.S)[1]
        roles={int(v,0):n for n,v in re.findall(r'^\s*(\w+)\s*=\s*(0x[\da-fA-F]+|\d+)',oid_body,re.M)}
        aid_body=enum_text.split(marker,1)[1].split('\n}',1)[0]
        actions={int(v):{'label':n,'description':desc.strip()} for n,v,desc in re.findall(r'^\s*(\w+)\s*=\s*(\d+),?\s*//([^\n]*)',aid_body,re.M)}
    else:
        assert csv_dir, '妖星乱舞需要 --csv-dir 指向当前国服数据'
        roles={19511:'UltimaKefka',18475:'KefkaP4',9020:'Helper'}
        with (csv_dir/'Action.csv').open(encoding='utf-8-sig',newline='') as f:
            rows=csv.reader(f);next(rows);next(rows);next(rows)
            # 当前 CSV 的旧字段表头比类型列滞后一列；此处仅按可靠的 ID/名称读取。
            actions={int(row[0]):{'label':row[1],'description':'国服录像动作'} for row in rows if 47925<=int(row[0])<=47958 or int(row[0]) in [49471,49539,49738,49743,49746,49769,50173,50770,50771,50772,50773]}
    for aid in extra: actions.setdefault(aid,{'label':'Transition','description':'转场演出'})
    raw=(recordings/filename).read_bytes()
    assert raw.startswith(b'FFXIVREPLAY') and u16(raw,12)==5 and u32(raw,72)+876==len(raw)
    packets=[]; off=876
    while off<len(raw):
        op,n,ms,actor=struct.unpack_from('<HHII',raw,off)
        assert off+12+n<=len(raw)
        packets.append((off,op,n,ms,actor)); off+=12+n
    assert off==len(raw)
    phase_actor=None
    # 完美亚历山大开局即创建；其后同 BNpcBase 的四个分身不是本体。
    for off,op,n,ms,actor in packets:
        if op==276 and u32(raw,off+12+64)==boss_base and (key=='d2az' or ms>=start):
            phase_actor=actor;break
    if key=='z3oy':
        for off,op,n,ms,actor in packets:
            if op!=61441: continue
            b=raw[off+12:off+12+n]
            name=b[4:52].split(b'\0',1)[0].decode('utf-8')
            value=b[52:52+u32(b)].decode('utf-8')
            match=re.match(r'_rsv_(\d+)_',name)
            if match and int(match[1]) in actions: actions[int(match[1])]['label']=value
    for off,op,n,ms,actor in packets:
        if not start<=ms<=end: continue
        b=memoryview(raw)[off+12:off+12+n]
        if op==408 and actor==phase_actor and u16(b)==14:
            end=ms-1
            break
    # 首轮扫描选出本窗口真正参与演出的演员，避免拉入旧阶段背景演员。
    needed=set(); latest={}; spawn_defs={}; prior={}; maps={}; bgm=0; weather=None; map_setup=None; director_flag=None
    initial_objects={}
    def object_definition(b):
        return {'base':u32(b,4),'flags':b[2],'hidden':bool(b[3]),
            'layout':u32(b,12),'bind_layout':u32(b,24),'radius':f32(b,28),'rotation':rot(b,34),
            'state':b[38],'args1':u32(b,44),'args2':u32(b,48),'pos':pos(b,52)}
    for off,op,n,ms,actor in packets:
        b=memoryview(raw)[off+12:off+12+n]
        if op==276 and n==656:
            base=u32(b,64)
            latest[actor]={'base':base,'name':u32(b,68),'hp':u32(b,92),'level':b[134], 'pos':pos(b,512), 'rotation':rot(b,114), 'flags':u32(b,100), 'model_state':b[147], 'animation_state':b[149], 'role':roles.get(base,''),'spawn_ms':ms}
            latest[actor]['layout']=u32(b,72)
            latest[actor]['model']=u16(b,112)
            latest[actor]['model_attribute_flags']=b[148]
            latest[actor]['owner']=u32(b,84)
            spawn_defs[(actor,ms)]=dict(latest[actor])
        elif op in (535,992) and actor in latest:
            latest[actor]['pos']=pos(b,6,True) if op==535 else pos(b,8)
            latest[actor]['rotation']=rot(b)
        elif op==408 and actor in latest and u16(b)==63: latest[actor]['model_state']=u32(b,4)
        elif op==408 and actor in latest and u16(b)==417: latest[actor]['owner']=u32(b,4)
        if ms<start:
            if key=='d2az' and op==403 and b[1]==7 and u32(b,4)==0x1EA1A1:
                initial_objects[u32(b,8)]=object_definition(b)
            if op==408 and u16(b)==413 and actor in initial_objects:
                initial_objects[actor]['animation']=[u32(b,4),u32(b,8)]
            if op==225 and n==24: director_flag=b[4]
            if op in (106,764):
                map_setup={'flag':u16(b,4),'states':[u16(b,6+i*2) for i in range(64 if op==106 else 128)]}
                maps.clear()
            if op==596: weather=b[0]
            # 全灭会重建场景；不能把此前尝试遗留的索引混入当前阶段快照。
            if op==486 and u16(b)==109 and u32(b,8)==0x40000005: maps.clear()
            if op==422: maps[b[8]]=[u16(b,4),u16(b,6),ms]
            if op in (408,486) and u16(b)==161: bgm=u32(b,4)
            if op==486 and u16(b)==109 and u32(b,8)==0x80000001: bgm=u32(b,12)
            if actor in latest: prior[actor]=dict(latest[actor])
        if not start<=ms<=end: continue
        if op==333 and n==64:
            needed.update(u32(b,i*4) for i in range(10) if u32(b,i*4) in latest)
        if (op==769 and u32(b,4) in actions) or (op in (189,319,912,158,630) and u32(b,8) in actions):
            needed.add(actor)
            target=u32(b,12) if op==769 else u32(b)
            if target in latest and latest[target]['role']: needed.add(target)
        if op==276 and (u32(b,64)==boss_base or roles.get(u32(b,64),'') in ['RightEye','LeftEye','Estinien','Alphinaud','IntermissionAlpha','IntermissionOmegaF','CosmoMeteor','CosmoComet','FateProjection']): needed.add(actor)
    # 前一阶段的视觉主角也参与转场。
    before_roles={'r1fz':{'NidhoggP6','HraesvelgrP6'},'n4gw':{'UsurperOfFrostP4','OracleOfDarknessP4','VisionOfGaia','VisionOfRyne'},'z3oz':{'BossP5'},'d2az':{'AlexanderPrime','BruteJustice','CruiseChaser'},'z3oy':{'KefkaP4'}}[key]
    for role in before_roles:
        candidates=[(v['spawn_ms'],a) for a,v in prior.items() if v['role']==role]
        if candidates: needed.add(max(candidates)[1])
    # 只保留实际 NPC；玩家目标在运行时按规则选择。
    needed.add(phase_actor)
    needed &= set(latest)
    aliases={a:'a'+str(i+1) for i,a in enumerate(sorted(needed))}
    def definition(d, actor):
        out={k:v for k,v in d.items() if k!='spawn_ms'}
        out['owner']=aliases.get(d.get('owner'))
        out['boss']=actor==phase_actor
        out['targetable']=d['role'] in ['CosmoMeteor','CosmoComet']
        # 初始隐显状态保留原始 Spawn display flags；避免主动显形破坏转场。
        return out
    initial={aliases[a]:definition(prior[a],a) for a in needed if a in prior}
    events=[]; transforms={a:(v['pos'],v['rotation']) for a,v in prior.items()}
    object_slots={}; object_count=0
    object_ids={a:'s'+str(i+1) for i,a in enumerate(sorted(initial_objects))}
    death_effects={}; pending_deaths=[]
    counts=collections.Counter(); controls=collections.Counter(); main=aliases[phase_actor]
    for off,op,n,ms,actor in packets:
        if not start<=ms<=end: continue
        b=memoryview(raw)[off+12:off+12+n]
        e={'t':round((ms-start)/1000,3),'kind':'','actor':aliases.get(actor)}
        if key=='z3oz' and op==408 and u16(b)==14 and actor in aliases and latest[actor]['role'] in ('CosmoMeteor','CosmoComet'):
            pending_deaths.append((ms,actor))
        if key=='z3oz' and op==422 and 12<=b[8]<=19 and u16(b,4)==4 and u16(b,6)==8:
            candidates=[(t,a) for t,a in pending_deaths if 0<=ms-t<=100]
            assert len(candidates)==1, ('陨石破坏效果必须对应唯一死亡演员',ms,candidates)
            t,a=candidates[0];pending_deaths.remove((t,a))
            death_effects[aliases[a]]={'index':b[8],'state':4,'timeline':8}
            continue
        if op==403 and n==64:
            # 光尘之剑等动态 EObj 与 MapEffect 不同；保留模型参数，不复制原始 ID/槽位。
            object_slots.pop(b[0],None)
            if b[1]!=7 or u32(b,16)>>16!=0x8003 or u32(b,20)!=0xE0000000: continue
            object_count+=1; alias='o'+str(object_count); object_slots[b[0]]=alias
            object_ids[u32(b,8)]=alias
            e.update(kind='object_spawn',actor=alias,data=object_definition(b))
        elif op==408 and u16(b)==413 and actor in object_ids:
            # 时间牢狱在实战按入塔者结算，录像只保留预备外观。
            if key=='d2az' and ms>=986104: continue
            e.update(kind='object_animation',actor=object_ids[actor],params=[u32(b,4),u32(b,8)])
        elif op==722 and n==8:
            alias=object_slots.pop(b[0],None)
            if alias is None: continue
            e.update(kind='object_despawn',actor=alias)
        elif op==333 and n==64:
            entries=[]
            for i in range(10):
                target=u32(b,i*4)
                if target==0xE0000000: break
                if target not in aliases: raise ValueError(('同步动画演员未映射',key,ms,i))
                entries.append([aliases[target],u16(b,40+i*2)])
            assert u32(b,60)==0
            e.update(kind='timelines',entries=entries); e.pop('actor')
        elif op==486 and u16(b)==109:
            event_id=u32(b,8)
            if event_id==0x80000004 or not 0x80000000<=event_id<=0x80000030: continue # 不复制通关/奖励或副本时限
            args=[u32(b,i) for i in (12,16,20,24)]
            if event_id==0x80000027:
                args[3]=aliases.get(args[3],0)
            if any(isinstance(v,int) and 0x10000000<=v<0x80000000 for v in args):
                raise ValueError(('未经映射的 Director 演出参数',key,event_id,args))
            e.update(kind='director',id=event_id,args=args);e.pop('actor')
        elif op==476 and n==8 and u32(b,4) in aliases:
            e.update(kind='despawn',actor=aliases[u32(b,4)])
        elif op==422:
            e.update(kind='map',index=b[8],state=u16(b,4),timeline=u16(b,6)); e.pop('actor')
        elif op==596:
            e.update(kind='weather',id=b[0],fade=round(f32(b,4),4));e.pop('actor')
        elif op in (408,486) and u16(b)==607 and u32(b,4) in aliases:
            e.update(kind='presentation',actor=aliases[u32(b,4)],operation=u32(b,8),parameter=u32(b,12),duration=u32(b,16))
        elif actor not in needed:
            if op in (408,486) and u16(b)==161:
                e.update(kind='bgm',id=u32(b,4));e.pop('actor')
            else: continue
        elif op==276 and n==656:
            d=spawn_defs[(actor,ms)]; e.update(kind='spawn',data=definition(d,actor)); transforms[actor]=(d['pos'],d['rotation'])
        elif op in (535,992):
            p=pos(b,6,True) if op==535 else pos(b,8); r=rot(b)
            transforms[actor]=(p,r); e.update(kind='move',pos=p,rotation=r)
        elif op==769 and u32(b,4) in actions:
            e.update(kind='cast',action=u32(b,4),spell=u16(b),seconds=round(f32(b,8),4),omen_delay=b[3],target=aliases.get(u32(b,12)),cast_pos=pos(b,24,True),pos=transforms.get(actor,({'x':100,'y':0,'z':100},0))[0],rotation=rot(b,16))
        elif op in (189,319,912,158,630) and u32(b,8) in actions:
            aid=u32(b,8); cap={189:1,319:8,912:16,158:24,630:32}[op]
            e.update(kind='action',action=aid,target=aliases.get(u32(b)),pos=transforms.get(actor,({'x':100,'y':0,'z':100},0))[0],rotation=rot(b,26))
            if cap>1:
                dest=pos(b,42+cap*64+6+cap*8,True)
                if abs(dest['x'])>1 or abs(dest['z'])>1: e['dest']=dest
            counts[aid]+=1
        elif op in (408,486,200):
            cat=u16(b); p=[u32(b,at) for at in (4,8,12,16)]
            controls[cat]+=1
            if cat in (54,62,63,407,414,415): e.update(kind='control',category=cat,params=p)
            elif cat==417 and (p[0]==0xE0000000 or p[0] in aliases): e.update(kind='owner',target=aliases.get(p[0]))
            elif cat==35 and p[2] in aliases: e.update(kind='tether',slot=p[0],id=p[1],target=aliases[p[2]])
            elif cat==47: e.update(kind='untether',slot=p[0],id=p[1])
            elif cat==161: e.update(kind='bgm',id=p[0])
            elif cat==50 and n>=28 and u32(b,24) in aliases: e.update(kind='target',target=aliases[u32(b,24)])
            elif key=='d2az' and cat==20 and p[0]==2195: e.update(kind='status',data=[{'id':2195,'param':p[1],'duration':40}])
            else: continue
        elif op in (718,923):
            # 模型机制状态（如火剑/冰剑），不复制记录玩家的战斗 Buff。
            slots=range(20,380,12) if op==718 else list(range(0,360,12))+list(range(380,740,12))
            found=[{'id':u16(b,i),'param':u16(b,i+2),'duration':max(0,round(f32(b,i+4),3))} for i in slots if u16(b,i)==2056 or key=='d2az' and u16(b,i)==2195]
            if found: e.update(kind='status',data=found)
            else: continue
        else: continue
        events.append(e)
    assert main and director_flag is not None, key
    # 同 ID 在画面内反复 Spawn，生成器/控制器以具名演员更新处理。
    if key=='z3oz': assert len(death_effects)==8 and not pending_deaths
    out={'content':key,'boss':main,'boss_base':boss_base,'death_effects':death_effects,'initial_objects':{object_ids[a]:v for a,v in initial_objects.items()},'start_ms':start,'end_ms':end,'sha256':hashlib.sha256(raw).hexdigest(),'bgm':bgm,'weather':weather,'map_setup':map_setup,'director_flag':director_flag,
         'initial_maps': [{'index':i,'state':v[0],'timeline':v[1],'recording_ms':v[2]} for i,v in sorted(maps.items(),key=lambda item:item[1][2])], 'initial':initial,'events':events,'actions':actions}
    # 只输出离线证据；世界服运行手工维护的显式 Lua 定义。
    dest=ROOT/'tools/ultimate-evidence'; dest.mkdir(parents=True,exist_ok=True)
    (dest/(key+'_data.lua')).write_text('-- 由 tools/extract_ultimate_finals.py 生成；坐标来自录像，不含玩家身份。\nreturn {\n'+',\n'.join('['+lua(k)+']='+('{\n'+',\n'.join(map(lua,v))+'\n}' if k=='events' else lua(v)) for k,v in out.items())+'\n}\n',encoding='utf-8')
    return {'content':key,'sha256':out['sha256'],'start_ms':start,'end_ms':end,'initial_maps':out['initial_maps'],'actors':len(aliases),'objects':object_count,'events':len(events),'actions':dict(sorted(counts.items())),'control_categories':dict(sorted(controls.items()))}

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--recordings',type=Path,required=True)
    parser.add_argument('--bossmod',type=Path,required=True)
    parser.add_argument('--csv-dir',type=Path)
    parser.add_argument('--content',nargs='+',choices=PROFILES)
    args=parser.parse_args()
    summaries=[extract(k,v,args.recordings,args.bossmod,args.csv_dir) for k,v in PROFILES.items() if not args.content or k in args.content]
    summary_path=ROOT/'tools/ultimate-evidence/evidence.json'
    previous=json.loads(summary_path.read_text(encoding='utf-8')) if summary_path.exists() else []
    by_content={s['content']:s for s in previous}
    by_content.update({s['content']:s for s in summaries})
    summary_path.write_text(json.dumps(list(by_content.values()),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    for s in summaries: print(s['content'],s['actors'],'actors',s['events'],'events',len(s['actions']),'actions')
