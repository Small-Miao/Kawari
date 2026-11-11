"""只读 AR zip/dat，提取匿名职业动作、量谱与状态；仅接受核验过的国服构建。"""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import struct
import zipfile

JOBS={"学者":"SCH","战士":"WAR","暗黑骑士":"DRK","机工":"MCH","武僧":"MNK","武士":"SAM","画家":"PCT","绝枪":"GNB","舞者":"DNC","蝰蛇":"VPR","贤者":"SGE","贤者2":"SGE","赤魔":"RDM","镰刀":"RPR"}
JOB_IDS=dict(SCH=28,WAR=21,DRK=32,MCH=31,MNK=20,SAM=34,PCT=42,GNB=37,DNC=38,VPR=41,SGE=40,RDM=35,RPR=39)
EFFECTS={400:1,563:8,281:16,924:24,221:32}
def u16(b,p=0): return struct.unpack_from('<H',b,p)[0]
def u32(b,p=0): return struct.unpack_from('<I',b,p)[0]

def parse(raw,source):
    if len(raw)<876 or raw[:11]!=b'FFXIVREPLAY' or u16(raw,12)!=5: raise ValueError(f'{source}: 非 v5 录像')
    if u32(raw,72)+876!=len(raw): raise ValueError(f'{source}: 长度不一致')
    build=u32(raw,16)
    if build!=14251465: raise ValueError(f'{source}: 未验证构建 {build}，禁止套用当前 opcode')
    aliases={}
    def actor(n):
        if n in (0,0xe0000000): return None
        if n not in aliases: aliases[n]=('P' if 0x10000000<=n<0x40000000 else 'A')+str(len(aliases)+1)
        return aliases[n]
    records=[]; opcounts=Counter();offset=876
    while offset<len(raw):
        if offset+12>len(raw): raise ValueError('截断的记录头')
        op,size,ms,aid=struct.unpack_from('<HHII',raw,offset)
        if offset+12+size>len(raw): raise ValueError('截断的记录内容')
        b=raw[offset+12:offset+12+size];offset+=12+size;opcounts[op]+=1
        e={'ms':ms,'actor':actor(aid),'opcode':op}
        if op==803:
            if size<10: raise ValueError('量谱长度无效')
            e.update(kind='gauge',job=b[0],bytes=list(b[2:10]),tail=b[10:].hex())
        elif op in EFFECTS:
            cap=EFFECTS[op]
            if size<48+cap*72 or b[33]>cap: raise ValueError('技能效果长度或目标数无效')
            targets=[]
            for i in range(b[33]):
                effects=[]
                for slot in range(8):
                    p=42+64*i+8*slot
                    if b[p]: effects.append({'type':b[p],'params':list(b[p+1:p+6]),'value':u16(b,p+6),'raw':b[p:p+8].hex()})
                targets.append({'actor':actor(u32(b,48+cap*64+i*8)),'effects':effects})
            e.update(kind='action',action=u32(b,8),spell=u16(b,28),lock=round(struct.unpack_from('<f',b,16)[0],4),targets=targets)
        elif op==352:
            if size<12: raise ValueError('读条记录过短')
            e.update(kind='cast',action=u32(b,4),seconds=round(struct.unpack_from('<f',b,8)[0],4))
        elif op==349:
            if size<380: raise ValueError('状态列表过短')
            statuses=[]
            for p in range(20,380,12):
                if u16(b,p): statuses.append({'id':u16(b,p),'param':u16(b,p+2),'seconds':round(struct.unpack_from('<f',b,p+4)[0],3),'source':actor(u32(b,p+8))})
            e.update(kind='statuses',statuses=statuses)
        elif op==374:
            if size<656: raise ValueError('NPC 生成长度无效')
            e.update(kind='spawn',base=u32(b,64),name_id=u32(b,68),pet=u32(b,76),owner=actor(u32(b,84)),model=u16(b,112),flags=u32(b,100))
        elif op==219:
            if size<8: raise ValueError('物件记录过短')
            e.update(kind='object',object_kind=b[1],base=u32(b,4),flags=b[3])
        elif op in (735,169):
            if size<4 or (size-4)%4: raise ValueError('控制记录长度无效')
            category=u16(b)
            if category not in (17,20,21,23,24,25,26,35,54,100,101,142,273,417,1541,1542): continue
            args=list(struct.unpack_from('<'+'I'*((size-4)//4),b,4))
            args=[actor(v) if 0x10000000<=v<0x50000000 or v==0xe0000000 else v for v in args]
            e.update(kind='control',category=category,args=args)
        else: continue
        records.append(e)
    return {'source':source,'sha256':hashlib.sha256(raw).hexdigest(),'build':build,'duty':u16(raw,32),'duration_ms':u32(raw,24),'opcodes':dict(opcounts),'records':records}

def perspective(records,job):
    performers=Counter(e['actor'] for e in records if e['kind']=='action'
        and str(e['actor']).startswith('P') and e['action'] not in (3,5,6,7,8))
    performer=performers.most_common(1)[0][0] if performers else None
    own_gauges=sum(e['kind']=='gauge' and e['actor']==performer and e['job']==JOB_IDS[job] for e in records)
    return {'performer':performer,'matching_gauge_updates':own_gauges,'first_person_evidence':own_gauges>0,
        'note':'本人量谱已确认' if own_gauges else '缺少本人量谱；不能据旁观者量谱推断本职业资源'}

def infer_job(records):
    performers=Counter(e['actor'] for e in records if e['kind']=='action'
        and str(e['actor']).startswith('P') and e['action'] not in (3,5,6,7,8))
    if not performers: raise ValueError('录像没有可识别的技能执行者')
    performer=performers.most_common(1)[0][0]
    jobs={e['job'] for e in records if e['kind']=='gauge' and e['actor']==performer}
    if len(jobs)!=1: raise ValueError('无法由执行者本人量谱唯一确定职业，不能套用旁观者量谱')
    job_id=jobs.pop()
    job=next((job for job,n in JOB_IDS.items() if n==job_id),None)
    if job is None: raise ValueError(f'未登记职业 {job_id}')
    return job

def main():
    ap=argparse.ArgumentParser();ap.add_argument('inputs',type=Path,nargs='+');ap.add_argument('--out',type=Path,required=True);args=ap.parse_args()
    args.out.mkdir(parents=True,exist_ok=True);summary=[]
    inputs=[];total=0
    for path in args.inputs:
        if path.suffix.lower()=='.zip':
            with zipfile.ZipFile(path) as z:
                files=[i for i in z.infolist() if not i.is_dir() and i.filename.lower().endswith('.dat')]
                total+=sum(i.file_size for i in files)
                if total>250_000_000: raise ValueError('输入解压体积超过审计限额')
                for info in files:
                    stem=Path(info.filename).stem;job=JOBS.get(stem)
                    if not job: raise ValueError(f'未知录像职业 {stem}')
                    inputs.append((z.read(info),info.filename,job))
        elif path.suffix.lower()=='.dat':
            total+=path.stat().st_size
            if total>250_000_000: raise ValueError('输入体积超过审计限额')
            inputs.append((path.read_bytes(),path.name,None))
        else: raise ValueError(f'不支持的输入格式 {path.suffix}')
    for index,(raw,source,job) in enumerate(inputs):
        result=parse(raw,source);job=job or infer_job(result['records']);result['job']=job
        result['perspective']=perspective(result['records'],job)
        filename=f'{job}-{index+1:02}.json'
        (args.out/filename).write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
        gauges=Counter(e['job'] for e in result['records'] if e['kind']=='gauge')
        actions=sorted({e['action'] for e in result['records'] if e['kind']=='action' and str(e['actor']).startswith('P')})
        summary.append({'job':job,'source':source,'evidence':filename,'duration_ms':result['duration_ms'],'gauge_jobs':dict(gauges),'player_actions':actions,'skip_implemented':job=='PCT','perspective':result['perspective']})
    (args.out/'index.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf-8')
    for r in summary: print(f"{r['job']}: {r['duration_ms']/1000:.1f}s, {len(r['player_actions'])} actions, gauges={r['gauge_jobs']}, skip={r['skip_implemented']}")

if __name__=='__main__': main()
