"""真实 C# 宿主协议回归：模拟服务器快照，不连接游戏或改变在线副本。"""
import argparse, collections, json, math, queue, subprocess, threading, time
from pathlib import Path

root=Path(__file__).resolve().parents[2]
parser=argparse.ArgumentParser();parser.add_argument('--p2',action='store_true');parser.add_argument('--solo',action='store_true');parser.add_argument('--exe',type=Path);args=parser.parse_args()
profile=root/('resources/controllers/umad-p2/profile.json' if args.p2 else 'tools/MechanicSimController/Examples/native-demo.json')
exe=args.exe or root/'tools/MechanicSimController/bin/Debug/net10.0/MechanicSimController.exe'
test_name=('p2-solo' if args.solo else 'p2') if args.p2 else 'demo'
log_path=root/'target/ultimate-analysis'/f'{test_name}-controller.log'
with log_path.open('w',encoding='utf-8') as log:
 p=subprocess.Popen([str(exe),'--config',str(profile)],stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=log,text=True,encoding='utf-8',creationflags=getattr(subprocess,'CREATE_NO_WINDOW',0))
 lines=queue.Queue()
 def reader():
  for line in p.stdout:lines.put(line)
  lines.put(None)
 threading.Thread(target=reader,daemon=True).start()
 players=[{'id':100+i,'player':True,'hp':9999999,'maxHp':9999999,'job':job,'pos':[100,0,115],'rotation':0,'target':0,'enmity':[]} for i,job in enumerate([19,21,24,40,20,22,23,25] if args.p2 and not args.solo else [19])]
 actors={a['id']:a for a in players};bindings={};statuses={};counts=collections.Counter();seq=0;start=None;last=None;state=None;active_towers=[];batches=[];death_sent=False;main_finish=None;jumps=0;cleaves=0
 def resolve(value):
  if isinstance(value,dict) and set(value)=={'actor'}:return bindings[value['actor']]
  if isinstance(value,dict):return {k:resolve(v) for k,v in value.items()}
  if isinstance(value,list):return [resolve(v) for v in value]
  return value
 try:
  duration=140 if args.p2 else 8
  while True:
   now=0 if start is None else time.monotonic()-start
   seq+=1
   events=[]
   if args.p2 and now>125 and not death_sent:
    boss=bindings['ms-3000'];actors[boss]['hp']=0
    events=[{'kind':'death','actor':boss}];death_sent=True
   frame={'version':1,'seq':seq,'time':now,'battle':start is not None,'actors':list(actors.values()),'bindings':bindings,'statuses':list(statuses.values()),'events':events}
   p.stdin.write(json.dumps(frame)+'\n');p.stdin.flush()
   raw=lines.get(timeout=30 if seq==1 else 5)
   if raw is None:raise RuntimeError('宿主异常退出，请查看 '+str(log_path))
   response=json.loads(raw);assert response['seq']==seq and response['version']==1
   batches.append(response)
   state=response['state']
   for c in response['commands']:
    counts[c['method']]+=1;values=resolve(c['args']);method=c['method']
    if method in ['cast','begin_cast'] and args.p2:
     assert values[1] not in range(47830,47834), '跳跃不能伪造读条'
     if values[1] in (47826,47827):main_finish=None
    if method=='play_action_targeted' and args.p2:
     source,action,target=values
     if action in (47826,47827):
      assert source==target==bindings['ms-3000'];main_finish=action
     if action in range(47830,47834):
      assert target in [p['id'] for p in players], '跳跃必须以实时玩家为目标'
      if source==bindings['ms-3000']:
       assert action==(47830 if main_finish==47826 else 47831) and main_finish is not None
      else:assert action in (47832,47833) and source in [bindings[f'ms-{i}'] for i in (2001,2002,2003)]
      jumps+=1
    if method=='raidwide' and args.p2 and values[0]['action'] in (47836,47837):
     assert values[0]['source']==values[0]['target'] and values[0]['targets']==[]
     source=actors[values[0]['source']];angle=values[0]['rotation']-source['rotation']
     expected=math.pi if values[0]['action']==47837 else 0
     assert abs(math.remainder(angle-expected,2*math.pi))<.001
     cleaves+=1
    if method=='spawn_actor':
     alias,spec=values;entity=0x40000000+len(bindings)+1;bindings[alias]=entity
     actors[entity]={'id':entity,'player':False,'hp':spec['hp'],'maxHp':spec['hp'],'job':0,'pos':[spec['pos'][v] for v in ['x','y','z']],'rotation':spec.get('rotation',0),'target':100,'enmity':[100]}
    elif method=='despawn':actors.pop(values[0],None)
    elif method in ['move_actor','slide_actor']:
     entity,pos,rotation=values
     if entity in actors:actors[entity].update(pos=[pos[v] for v in ['x','y','z']],rotation=rotation)
    elif method=='gain_effect':
     target,ident,param,remaining,*source=values
     statuses[target,ident]={'actor':target,'id':ident,'param':param,'duration':remaining,'source':source[0] if source and source[0] else 0}
    elif method=='remove_effect':statuses.pop((values[0],values[1]),None)
    elif method=='map_effect' and 1<=values[0]<=8 and values[1:]==[2,1]:
     active_towers.append(values[0]);active_towers=active_towers[-2:]
     if len(active_towers)==2:
      for index,tower in enumerate(active_towers):
       angle=(tower-1)*math.pi/4
       for player in players[index*2:index*2+2]:player['pos']=[100+8*math.sin(angle),0,100-8*math.cos(angle)]
   if start is None and bindings:
    start=time.monotonic();print('C# 初始化成功，开始模拟开战',flush=True)
   if state.get('isCompleted') and (not args.p2 or death_sent):break
   if now>duration:raise AssertionError('时间轴未按期完成')
   current=(state.get('currentNodeIndex'),state.get('status'))
   if current!=last:
    print(f'{now:.1f}s 节点={current[0]} 状态={current[1]}',flush=True);last=current
   time.sleep(.125)
  assert counts['spawn_actor'] and (counts['cast'] or counts['begin_cast']) and counts['gain_effect']
  assert counts['raidwide'] if args.p2 else counts['aoe_circle']
  if args.p2:
   assert counts['map_effect']>=40 and counts['set_target_icon']>=1 and counts['slide_actor']>0
   assert counts['complete_duty']==1, '只有收到 Boss 实际死亡事件后才通关'
   assert jumps==(4 if args.solo else 16) and cleaves==16
   assert counts['interrupt_cast']==0, '不能因时间轴提前推进而中断本轮读条'
  (log_path.parent/f'{test_name}-commands.json').write_text(json.dumps(batches,ensure_ascii=False),encoding='utf-8')
  # 重复请求不得重放一整帧副作用。
  p.stdin.write(json.dumps(frame)+'\n');p.stdin.flush();assert lines.get(timeout=5) is None
  assert p.wait(timeout=5)!=0
  print(json.dumps({'passed':True,'counts':counts},ensure_ascii=False),flush=True)
 finally:
  p.kill() if p.poll() is None else None
  p.wait(timeout=5)
