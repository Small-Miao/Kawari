//! 原生 Lua 控制器的节点、场景、运动及最终阶段实际脚本回归。
use super::*;

fn script(d: &DirectorData, code: &str) {
    let root =
        std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../resources/scripts/content");
    d.lua
        .0
        .globals()
        .set("CONTENT_DIR", root.to_string_lossy().replace('\\', "/"))
        .unwrap();
    let evidence = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../tools/ultimate-evidence");
    d.lua.0.globals().set("EVIDENCE_DIR", evidence.to_string_lossy().replace('\\', "/")).unwrap();
    d.lua.0.load(code).exec().unwrap();
}

#[test]
#[ignore = "一次性 C# 迁移：导出旧 Lua 定义用于离线生成和审计"]
fn export_csharp_migration_definitions() {
    let d = tests::director();
    script(&d, r#"
        migration = {}
        local root=CONTENT_DIR..'/ultimate/Definitions/'
        for _,content in ipairs({'r1fz','n4gw','z3oz','d2az','z3oy'}) do
            local rules=dofile(root..'Timelines/'..content..'.lua')
            local modules={}
            for _,name in ipairs(rules.definitions) do
                modules[name]={}
                for id,rule in pairs(dofile(root..'Actions/'..name..'.lua').actions) do modules[name][tostring(id)]=rule end
            end
            migration[content]={modules=modules,actors=dofile(root..'Actors/'..content..'.lua')}
        end
    "#);
    let value: serde_json::Value = d.lua.0.from_value(d.lua.0.globals().get::<Value>("migration").unwrap()).unwrap();
    let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../target/ultimate-analysis");
    std::fs::write(root.join("csharp-migration.json"),serde_json::to_vec_pretty(&value).unwrap()).unwrap();
}

#[test]
fn native_nodes_wait_timeout_and_cancel_drop_future_events() {
    let d = tests::director();
    script(
        &d,
        r#"
        local T=dofile(CONTENT_DIR..'/ultimate/timeline.lua')
        local vars={};local canceled=0;local hits=0
        local d={set_var=function(_,k,v)vars[k]=v end,stop_encounter=function()canceled=canceled+1 end}
        local timeline=T.new({Phases={{Name='条件',Nodes={
          {Name='等待',Duration=0,WaitUntil=function(_,s)return s.ready end,Timeout=2,OnTimeout=function()hits=hits+1 end},
          {Name='未到达',Duration=1,Events={{At=0,Run=function()error('越过等待条件')end}}}
        }}}})
        timeline:start();timeline:update(d,0,function()end,{})
        assert(timeline.active and hits==0)
        timeline:update(d,2,function()end,{})
        assert(not timeline.active and hits==1 and canceled==1)
        timeline:update(d,10,function()end,{})
        local t=T.new({phases={{name='测试',nodes={{name='取消',duration=5,events={
          {at=1,run=function()hits=hits+1 end},{at=3,run=function()error('取消后仍执行')end}
        }}}}}})
        t:start();t:update(d,1,function()end,{});t:cancel();t:update(d,5,function()end,{})
        assert(hits==2)
        for _,hook in ipairs({'OnUpdate','WaitUntil','OnExit'}) do
          local node={Name='回调取消',Duration=1,Timeout=2}
          local c
          node[hook]=function() c:cancel();return true end
          c=T.new({Phases={{Name='取消',Nodes={node,
            {Name='禁止进入',Duration=1,OnEnter=function()error('取消后进入下一节点')end}
          }}}})
          c:start();c:update(d,1,function()end,{})
          assert(not c.active and c.index==1)
        end
    "#,
    );
}

#[test]
fn native_scene_replaces_named_objects_and_restores_map_baseline() {
    let d = tests::director();
    script(
        &d,
        r#"
        local Scene=dofile(CONTENT_DIR..'/ultimate/scene.lua')
        local objects={};local events={};local next_id=10
        local d={actor_id=function(_,key)return objects[key]end,
          spawn_event_object=function(_,key,s)next_id=next_id+1;objects[key]=next_id;return next_id end,
          despawn_registered=function(_,key)objects[key]=nil end,
          object_animation=function(_,id,a,b)events[#events+1]={id,a,b}end,
          map_effect=function(_,i,t,s)events[#events+1]={i,s,t}end}
        local s=Scene.new({initial={maps={{index=5,state=1,timeline=2}}}})
        s:SpawnEObj(d,'剑',{animation={4,8}});local before=objects['剑']
        s:SpawnEObj(d,'剑',{animation={16,32}});assert(objects['剑']~=before)
        s:AnimateEObj(d,'剑',64,128);s:ClearEObjs(d);assert(next(objects)==nil)
        s:Apply(d,'initial');assert(events[#events][2]==1 and events[#events][3]==2)
    "#,
    );
}

#[test]
fn native_actor_motion_tracks_enmity_and_respects_cast_lock() {
    let d = tests::director();
    script(
        &d,
        r#"
        local A=dofile(CONTENT_DIR..'/ultimate/actors.lua');local a=A.new()
        local pos={[1]={x=0,y=0,z=0},[2]={x=10,y=0,z=0},[3]={x=0,y=0,z=10}}
        local rotation=0;local hate={2};local moves=0;local dead={};local ai=false
        local d={actor_id=function()return 1 end,is_alive=function(_,id)return not dead[id]end,
          position=function(_,id)return pos[id]end,rotation=function()return rotation end,
          enmity_order=function()return hate end,set_ai_enabled=function(_,id,enabled)ai=enabled end,
          set_target=function()end,slide_actor=function(_,id,p,r)pos[id]=p;rotation=r;moves=moves+1 end,
          move_actor=function(_,id,p,r)pos[id]=p;rotation=r end}
        a:FaceEnmity(d,'boss');a:Update(d,.125,0);assert(math.abs(rotation-math.pi/2)<.001)
        a:LockFacing('boss',2);hate={3};a:Update(d,.125,1);assert(moves==1)
        a:Update(d,.125,2);assert(math.abs(rotation)<.001)
        a:MoveTo(d,'boss',{x=10,y=0,z=0},4);a:Update(d,.5,3);assert(math.abs(pos[1].x-2)<.001)
        a:Stop(d,'boss');a:Update(d,.5,4);assert(math.abs(pos[1].x-2)<.001)
        a:Follow(d,'boss',2,100,3);a:Update(d,.5,5);assert(math.abs(pos[1].x-7)<.001)
        pos[2].x=12;a:Update(d,.5,6);assert(math.abs(pos[1].x-9)<.001)
        dead[2]=true;a:Update(d,.5,7);assert(a.plans.boss==nil)
        a:MoveTo(d,'boss',{x=20,y=0,z=0},6)
        a:Teleport(d,'boss',{x=3,y=0,z=4},1);a:Update(d,.5,8)
        assert(pos[1].x==3 and pos[1].z==4 and rotation==1 and a.plans.boss==nil)
        a:FaceAggro(d,'boss');dead[1]=true;a:Update(d,.5,9);assert(a.plans.boss==nil)
        a:Stop(d,'boss',true);assert(ai)
    "#,
    );
}

#[test]
fn explicit_tracks_merge_by_time_then_order_and_shift_with_their_node() {
    let d=tests::director();
    script(&d,r#"
        local T=dofile(CONTENT_DIR..'/ultimate/timeline.lua')
        local C=dofile(CONTENT_DIR..'/ultimate/commands.lua');local seen={}
        local function mark(name)return function(d,s)seen[#seen+1]={name,s.event_time}end end
        local d={set_var=function()end};local state={}
        local definition={phases={{name='阶段',nodes={
            {name='等待',duration=3},
            {name='机制',duration=1,events=C.Merge(
                {C.At(.5,3,mark('命中')),C.At(.25,4,mark('读条'))},
                {C.At(.5,2,mark('物件动画')),C.At(0,1,mark('地图'))})}
        }}}}
        local t=T.new(definition);t:start();t:update(d,4,state)
        assert(#seen==4 and seen[1][1]=='地图' and seen[2][1]=='读条' and seen[3][1]=='物件动画' and seen[4][1]=='命中')
        assert(seen[1][2]==3 and seen[2][2]==3.25 and state.event_time==nil)
        definition.phases[1].nodes[1].duration=5;seen={}
        t=T.new(definition);t:start();t:update(d,6,state)
        assert(seen[1][2]==5 and seen[4][2]==5.5,'修改节点时长必须同时平移场景和战斗调用')
        assert(not pcall(T.new,{phases={{name='旧数据',nodes={{name='旧范围',duration=1,recording_from=0,recording_to=1}}}}}))
        seen={};local drift={name='漂移检查',nodes={}}
        for i=1,10 do drift.nodes[i]={name=tostring(i),duration=.1,events={C.At(.1,1,mark(tostring(i)))}} end
        t=T.new({phases={drift}});t:start();t:update(d,1,state);assert(#seen==10 and not t.active)
    "#);
}

#[test]
#[ignore = "一次性迁移审计；有意编辑机制后不要求与旧录像相同"]
fn explicit_migration_matches_legacy_call_times_order_and_parameters() {
    let d=tests::director();
    script(&d,"local counts=dofile(EVIDENCE_DIR..'/audit_explicit.lua');local total=0;for _,n in pairs(counts)do total=total+n end;assert(total==7055)");
}

fn apply_actor_tasks(d: &mut DirectorData) -> Vec<LuaDirectorTask> {
    let tasks = std::mem::take(&mut d.tasks);
    for task in &tasks {
        match task {
            LuaDirectorTask::SpawnScriptActor(a) => d.current_actors.push(ActorSnapshot {
                id: a.id,
                enmity: vec![ObjectId(100)],
                is_player: false,
                is_boss: a.boss,
                position: a.position,
                rotation: a.rotation,
                hp: a.hp,
                max_hp: a.hp,
                class_job: 0,
                target: ObjectId(100),
            }),
            LuaDirectorTask::DespawnActor { actor_id } => {
                d.current_actors.retain(|a| a.id != *actor_id)
            }
            LuaDirectorTask::MoveActor {
                actor_id,
                position,
                rotation,
            }
            | LuaDirectorTask::SlideActor {
                actor_id,
                position,
                rotation,
            } => {
                if let Some(a) = d.current_actors.iter_mut().find(|a| a.id == *actor_id) {
                    a.position = *position;
                    a.rotation = *rotation;
                }
            }
            _ => {}
        }
    }
    tasks
}

#[test]
fn native_kefka_solo_and_party_use_recorded_actor_actions_and_reset() {
    for count in [1, 8] {
        let mut d = tests::director();
        script(
            &d,
            "math.randomseed(1974);dofile(CONTENT_DIR..'/ultimate/kefka_p2.lua')",
        );
        for i in 0..count {
            d.current_actors.push(ActorSnapshot {
                id: ObjectId(100 + i),
                enmity: vec![],
                is_player: true,
                is_boss: false,
                position: Position(Vec3::new(98.0 + i as f32, 0.0, 105.0)),
                rotation: 0.0,
                hp: 9999999,
                max_hp: 9999999,
                class_job: if i < 2 { 19 } else { 24 },
                target: ObjectId::default(),
            });
        }
        d.setup();
        apply_actor_tasks(&mut d);
        assert!(d.helpers.contains_key("trigger"));
        d.start_battle();
        let start = d.battle_started_at.unwrap();
        d.pending_battle_start = false;
        d.run_lifecycle_callback("onBattleStart");
        let boss = d.helpers["boss"];
        let mut casts = 0;
        let mut jumps = 0;
        let mut maps = 0;
        let mut finish = None;
        let mut completed = false;
        for step in 0..1000 {
            d.encounter_advance(start + Duration::from_millis(step * 125));
            for task in apply_actor_tasks(&mut d) {
                match task {
                    LuaDirectorTask::CastBar {
                        source_id,
                        action_id,
                        ..
                    } => {
                        casts += 1;
                        assert!(!(47830..=47833).contains(&action_id));
                        if action_id == 47826 || action_id == 47827 {
                            assert_eq!(source_id, boss);
                            finish = None;
                        }
                    }
                    LuaDirectorTask::EmitEffect {
                        source: Some(source),
                        action_id,
                        target,
                        effect: TargetEffectKind::None,
                    } => {
                        if action_id == 47826 || action_id == 47827 {
                            assert_eq!((source, target), (boss, boss));
                            finish = Some(action_id);
                        }
                        if (47830..=47833).contains(&action_id) {
                            jumps += 1;
                            assert!((100..100 + count).contains(&target.0));
                            if source == boss {
                                assert_eq!(Some(action_id - 4), finish);
                            } else {
                                assert!([47832, 47833].contains(&action_id));
                            }
                        }
                    }
                    LuaDirectorTask::MapEffect { .. } => maps += 1,
                    LuaDirectorTask::CompleteDuty { .. } => completed = true,
                    _ => {}
                }
            }
        }
        assert_eq!(casts, 21);
        assert_eq!(jumps, if count == 1 { 4 } else { 16 });
        assert!(maps >= 34);
        assert!(!completed);
        d.on_actor_death(19506, Position(Vec3::new(100.0, 0.0, 100.0)), boss);
        assert!(
            d.tasks
                .iter()
                .any(|t| matches!(t, LuaDirectorTask::CompleteDuty { .. }))
        );
        d.timeline_command("stop");
        assert!(d.scheduler.is_empty());
        assert!(d.helpers.is_empty());
        assert!(d.battle_started_at.is_none());
        apply_actor_tasks(&mut d);
        d.timeline_command("reset");
        assert!(d.helpers.contains_key("trigger"));
        assert!(d.scheduler.is_empty());
    }
}

#[test]
fn native_reload_validates_before_replacing_active_instance() {
    let mut d = tests::director();
    script(&d, "dofile(CONTENT_DIR..'/z3oy.lua')");
    d.setup();
    apply_actor_tasks(&mut d);
    let old = d.helpers["trigger"];
    let bad = std::env::temp_dir().join(format!("kawari-invalid-{}.lua", fastrand::u64(..)));
    std::fs::write(&bad, b"error('invalid candidate')").unwrap();
    d.script_path = Some(bad.to_string_lossy().into());
    assert!(d.timeline_command("reload").contains("重载失败"));
    assert_eq!(d.helpers["trigger"], old);
    assert!(d.tasks.is_empty());
    std::fs::remove_file(bad).unwrap();
    d.script_path = Some(
        std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
            .join("../../resources/scripts/content/z3oy.lua")
            .to_string_lossy()
            .into(),
    );
    assert!(d.timeline_command("reload").contains("重新加载"));
    assert_ne!(d.helpers["trigger"], old);
    assert!(
        d.tasks
            .iter()
            .any(|t| matches!(t,LuaDirectorTask::DespawnActor{actor_id} if *actor_id==old))
    );
}

#[test]
fn tea_projection_uses_current_owners_and_beta_handles_missing_members() {
    let d = tests::director();
    script(&d, r#"
        local root=CONTENT_DIR..'/ultimate/'
        local U=dofile(root..'mechanic_utils.lua')
        local A=dofile(root..'Definitions/Actions/TEA/FateCalibrationAlpha.lua')
        local B=dofile(root..'Definitions/Actions/TEA/FateCalibrationBeta.lua')
        local positions={[1]={x=10,y=0,z=0},[2]={x=20,y=0,z=0},[3]={x=40,y=0,z=0},
            [101]={x=0,y=0,z=0},[102]={x=20,y=0,z=0},[900]={x=0,y=0,z=0}}
        local aliases={boss=900,a=101,b=102};local failed={};local canceled=0
        local d={actor_id=function(_,k)return aliases[k]end,position=function(_,id)return assert(positions[id])end,
            is_alive=function(_,id)assert(id,'不允许查询空演员');return positions[id]~=nil end,
            alive_players=function()return {1,2,3}end,rotation=function()return 0 end,
            move_actor=function(_,id,pos)positions[id]=pos end,projection_death=function()end,
            tether_cancel=function()canceled=canceled+1 end,
            raidwide=function(_,p)failed[#failed+1]=p end}
        local s={data={boss='boss'},projection={phase='alpha',owners={a=1,b=2}},
            calibration={assault={},colors={},near={},far={},beacons={},jumps={}}}
        A.resolve(d,s,{action=18596,pos={x=0,y=0,z=0}},{},U)
        assert(s.calibration.defamation==1)
        positions[1]={x=50,y=0,z=0};local hit={}
        A.resolve(d,s,{action=18528},hit,U);assert(hit.target==1 and hit.pos.x==50)
        s.projection.phase='beta'
        B.event(d,s,{kind='tether',actor='missing',target='b',id=28},nil,U)
        B.resolve(d,s,{action=18531},{},U);assert(#failed==0)
        local c=s.calibration;c.links_resolved=nil;c.near={1,2};c.far={2,3}
        B.resolve(d,s,{action=18531},{},U)
        assert(#failed==2 and canceled==2,'近线过长和远线过短均需判失败')
        local jump={};B.resolve(d,s,{action=18565,actor='a'},jump,U)
        assert(jump.target==1 and positions[101].x==50)
        positions[1]={x=80,y=0,z=0};local donut={}
        B.resolve(d,s,{action=18566,actor='a'},donut,U)
        assert(donut.pos.x==50,'环形圣礼必须跟随跳跃落点而非随后移动的玩家')
        assert(B.before_event(d,s,{kind='move',actor='a'})==false)
    "#);
}

#[test]
fn tea_prison_checks_occupancy_and_anchors_only_captured_players() {
    let d = tests::director();
    script(&d, r#"
        local root=CONTENT_DIR..'/ultimate/';local U=dofile(root..'mechanic_utils.lua')
        local M=dofile(root..'Definitions/Actions/TEA/TemporalPrison.lua')
        local r=-math.pi-math.pi/4
        local pos={[1]={x=100+12*math.sin(r),y=0,z=100+12*math.cos(r)},[2]={x=100,y=0,z=100}}
        local callbacks={};local effects={};local failures=0;local interrupted=0;local animations={}
        local s={data={boss='boss'},enrage_at=42,scene={Apply=function(_,d,name,p)animations[#animations+1]=name end}}
        local d={schedule=function(_,at,f)callbacks[#callbacks+1]={at=at,run=f}end,
            actor_id=function()return 900 end,alive_players=function()return {1,2}end,
            is_alive=function()return true end,position=function(_,id)return pos[id]end,rotation=function()return 0 end,
            move_actor=function(_,id,p)pos[id]=p end,
            gain_effect=function(_,id,status)effects[id]=status end,
            interrupt_cast=function()interrupted=interrupted+1 end,raidwide=function()failures=failures+1 end}
        M.start(d,s);M.prepare(d,s,{action=18583},U)
        assert(s.enrage_at==nil and #callbacks==15)
        table.sort(callbacks,function(a,b)return a.at<b.at end)
        for _,c in ipairs(callbacks) do if c.at<=9.867 then c.run(d) end end
        assert(effects[1]==2165 and effects[2]==nil and interrupted==1 and failures==0)
        local anchor=s.prisoned[1];pos[1]={x=100,y=0,z=100};M.tick(d,s,10,U)
        assert(pos[1].x==anchor.x)
        for _,c in ipairs(callbacks) do if math.abs(c.at-14.866)<.001 then c.run(d) end end
        assert(failures==1 and effects[2]==nil,'空塔失败，不能抓取不在塔内的玩家')
    "#);
}

#[test]
fn umad_towers_orchestra_and_forsaken_use_live_targets_and_matching_scene() {
    let d = tests::director();
    script(&d, r#"
        local root=CONTENT_DIR..'/ultimate/';local U=dofile(root..'mechanic_utils.lua')
        local T=dofile(root..'Definitions/Actions/UMAD/Celestriad.lua')
        local O=dofile(root..'Definitions/Actions/UMAD/MaddeningOrchestra.lua')
        local F=dofile(root..'Definitions/Actions/UMAD/Forsaken.lua')
        local Scene=dofile(root..'scene.lua')
        local pos={};for i=1,8 do pos[i]={x=100+i,y=0,z=100} end;pos[900]={x=100,y=0,z=100}
        local hate={1,2};local raids={};local icons={};local maps={};local effects={}
        local d={alive_players=function()return {1,2,3,4,5,6,7,8}end,
            position=function(_,id)return pos[id]end,is_alive=function()return true end,
            actor_id=function()return 900 end,enmity_order=function()return hate end,
            job=function(_,id)return id<=2 and 19 or 24 end,
            raidwide=function(_,p)raids[#raids+1]=p end,
            gain_effect=function(_,id,status)effects[status]=id end,remove_effect=function()end,
            set_target_icon=function(_,id,icon)icons[icon]=id end,
            map_effect=function(_,i,t,s)maps[#maps+1]={i,t,s}end}
        local s={data={boss='boss'},groups={},phase='battle',scene=Scene.new(dofile(root..'Definitions/Scenes/z3oy.lua'))}
        local p={pos={x=0,y=0,z=0},source=900}
        assert(T.resolve(d,s,{action=47939},p,U)==true and raids[#raids].action==47942)
        p.pos={x=104,y=0,z=100};assert(T.resolve(d,s,{action=47939},p,U)==nil)
        assert(T.actions[47939].punish_status==2902 and T.actions[47939].split)
        O.prepare(d,s,{action=47952},U);local holy={}
        O.resolve(d,s,{action=47956},holy,U);assert(holy.target>2,'圣光先到达也不能选中双坦')
        O.resolve(d,s,{action=47954},{},U);assert(effects[5350]==1 and effects[5351]==2)
        hate={2,1};local swap={};O.resolve(d,s,{action=47955},swap,U);assert(swap.target==2)
        F.start(d,s);F.resolve(d,s,{action=47925},{},U);local target=icons[161]
        pos[target]={x=106,y=0,z=94};local stack={};F.resolve(d,s,{action=47929},stack,U)
        assert(stack.target==target and stack.pos==pos[target])
        -- 所有人移到同一象限；原录像左下橙圈必须改成右上，并与读条落点一致。
        for i=1,8 do pos[i]={x=110,y=0,z=90}end
        local puddle=F.prepare(d,s,{action=47928,rotation=0},U)
        assert(s.forsaken_puddle_index==31 and puddle.pos.x==106.75 and puddle.pos.z==93.25)
        local scene=dofile(root..'Definitions/Scenes/z3oy/13_Forsaken.lua')
        for _,e in ipairs(scene) do if math.abs(e.At-12.027)<.0001 then e.Run(d,s) end end
        assert(maps[#maps][1]==31)
        F.resolve(d,s,{action=47927},{pos=pos[1]},U);F.tick(d,s,250,U)
        assert(raids[#raids].death_status==5144 and #raids[#raids].targets==8)
    "#);
}

#[test]
fn ultimate_finals_run_solo_and_party_through_enrage_and_reset() {
    for content in ["d2az", "z3oy", "r1fz", "n4gw", "z3oz"] {
        for count in [1, 8] {
            let mut d = tests::director();
            script(
                &d,
                &format!(
                    r#"
                math.randomseed(148)
                local data=dofile(EVIDENCE_DIR..'/{content}_data.lua')
                local rules=dofile(CONTENT_DIR..'/ultimate/{content}_rules.lua')
                for _,e in ipairs(data.events) do
                    if e.action then assert(rules.actions[e.action], '未分类动作 '..e.action) end
                end
                local original_dofile=dofile
                dofile=function(path)
                    assert(not path:match('_data%.lua$') and not path:find('/Records/',1,true), '运行时仍在加载录像素材 '..path)
                    return original_dofile(path)
                end
                dofile(CONTENT_DIR..'/{content}.lua')
                __test_errors={{}}
                for _,name in ipairs({{'onSetup','onBattleStart','onTick','onReset','onStop','onActorDeath'}}) do
                    local f=_G[name]
                    if f then _G[name]=function(...)
                        local ok,err=pcall(f,...)
                        if not ok then __test_errors[#__test_errors+1]=tostring(err);error(err) end
                    end end
                end
            "#
                ),
            );
            for i in 0..count {
                d.current_actors.push(ActorSnapshot {
                    id: ObjectId(100 + i),
                    enmity: vec![],
                    is_player: true,
                    is_boss: false,
                    position: Position(Vec3::new(90.0 + i as f32 * 2.0, 0.0, 104.0)),
                    rotation: 0.0,
                    hp: 9999999,
                    max_hp: 9999999,
                    class_job: [19, 21, 24, 28, 20, 22, 23, 25][i as usize],
                    target: ObjectId::default(),
                });
            }
            d.setup();
            let initial = apply_actor_tasks(&mut d);
            assert!(d.helpers.contains_key("trigger"));
            assert!(!initial.iter().any(|t| matches!(
                t,
                LuaDirectorTask::CastBar { .. } | LuaDirectorTask::ResolveAoe(_)
            )));
            let main: String = d
                .lua
                .0
                .load(format!(
                    "return dofile(CONTENT_DIR..'/ultimate/Definitions/Actors/{content}.lua').boss"
                ))
                .eval()
                .unwrap();
            d.start_battle();
            let start = d.battle_started_at.unwrap();
            d.pending_battle_start = false;
            d.run_lifecycle_callback("onBattleStart");
            let mut casts = 0;
            let mut hits = 0;
            let mut projections = 0;
            let mut jumps = 0;
            let mut prison_warnings = 0;
            let mut prison_closes = 0;
            let mut objects = 0;
            let mut completed = false;
            for step in 0..3600 {
                d.encounter_advance(start + Duration::from_millis(step * 125));
                for task in apply_actor_tasks(&mut d) {
                    match task {
                        LuaDirectorTask::SpawnScriptActor(a) if a.base == 11350 => {
                            projections += 1;
                            assert!(
                                a.appearance_from
                                    .is_some_and(|id| (100..100 + count).contains(&id.0))
                            );
                            assert!(!a.boss && !a.targetable);
                        }
                        LuaDirectorTask::SpawnScriptObject(_) => objects += 1,
                        LuaDirectorTask::CastBar { .. } => casts += 1,
                        LuaDirectorTask::ResolveAoe(a) => {
                            assert!(a.origin.0.is_finite() && a.rotation.is_finite());
                            if a.damage > 0 {
                                hits += 1;
                            }
                            if a.action_id == 18565 {
                                jumps += 1;
                            }
                        }
                        LuaDirectorTask::SendActorControl {
                            category: ActorControlCategory::EObjAnimation { param1, param2 },
                            ..
                        } => {
                            if (param1, param2) == (0x400, 0x840) {
                                prison_warnings += 1;
                            }
                            if (param1, param2) == (0x1000, 0x2000) {
                                prison_closes += 1;
                            }
                        }
                        LuaDirectorTask::CompleteDuty { .. } => completed = true,
                        _ => {}
                    }
                }
            }
            assert!(
                casts > 0 && hits > 0,
                "{content}: casts={casts}, hits={hits}"
            );
            assert!(!completed, "录像终点或狂暴不可以自动通关");
            assert!(d.scheduler.is_empty());
            if content == "d2az" {
                assert_eq!(projections, 16);
                assert_eq!(jumps, 3);
                assert_eq!((prison_warnings, prison_closes), (7, 8));
            } else if content == "z3oy" {
                assert!(objects >= 9, "元素塔场景物件缺失");
            }
            let errors: Vec<String> = d.lua.0.globals().get("__test_errors").unwrap();
            assert!(errors.is_empty(),"{content}/{count}: {errors:?}");
            let boss=d.helpers[&main];
            let base:u32=d.lua.0.load(format!("return dofile(CONTENT_DIR..'/ultimate/Definitions/Actors/{content}.lua').boss_base")).eval().unwrap();
            d.on_actor_death(
                base,
                Position::default(),
                boss,
            );
            assert!(
                d.tasks
                    .iter()
                    .any(|t| matches!(t, LuaDirectorTask::CompleteDuty { .. }))
            );
            d.timeline_command("stop");
            apply_actor_tasks(&mut d);
            assert!(d.helpers.is_empty() && d.scheduler.is_empty());
            d.timeline_command("reset");
            apply_actor_tasks(&mut d);
            assert!(d.helpers.contains_key("trigger") && d.battle_started_at.is_none());
        }
    }
}
