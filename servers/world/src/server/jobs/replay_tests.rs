//! 使用当前国服 SqPack 走实际执行、包生成和队伍结算路径，不连接在线世界服。
use crate::{
    ClientHandle, ClientId, FromServer, GameData,
    lua::KawariLua,
    server::{
        WorldServer,
        action::execute_action,
        actor::NetworkedActor,
        instance::Instance,
        network::NetworkState,
        party::{Party, PartyMember},
    },
    zone_connection::BaseParameters,
};
use kawari::{
    common::{ObjectId, ObjectTypeId},
    ipc::zone::{ActionRequest, ActionType, ServerZoneIpcData},
};
use parking_lot::Mutex;
use std::sync::Arc;

struct Fixture {
    owner: ObjectId,
    ally: ObjectId,
    stranger: ObjectId,
    world: Arc<Mutex<WorldServer>>,
    network: Arc<Mutex<NetworkState>>,
    game: Arc<Mutex<GameData>>,
    lua: Arc<Mutex<KawariLua>>,
    messages: tokio::sync::mpsc::Receiver<FromServer>,
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_all_raise_jobs_offer_before_accepting_and_restore_recorded_resources() {
    use crate::server::revival;
    use kawari::{common::CharacterMode, ipc::zone::{ClientTriggerCommand, TargetEffectKind}};
    use std::time::{Duration, Instant};
    for (job, action) in [(24,125),(27,173),(28,173),(33,3603),(35,7523),(40,24287)] {
        let mut f = Fixture::new(job);
        {
            let mut w = f.world.lock();
            let target = w.instances[0].find_actor_mut(f.ally).unwrap().get_common_spawn_mut();
            target.health_points = 0;
            target.resource_points = 0;
            target.mode = CharacterMode::Dead;
        }
        f.act_on(action, f.ally);
        {
            let w = f.world.lock();
            let i = &w.instances[0];
            let a = i.find_actor(f.ally).unwrap();
            assert_eq!(a.get_common_spawn().health_points, 0, "职业 {job} 不能未经确认直接复活");
            let s = a.status_effects().unwrap().get(148).expect("缺少复活待确认状态");
            assert_eq!(s.source_actor_id, f.owner);
            assert_eq!(s.param, 8);
            assert_eq!(i.find_actor(f.owner).unwrap().get_common_spawn().resource_points, 7600);
        }
        let packets = f.packets().await;
        assert!(packets.iter().any(|(_,p)|match p {
            ServerZoneIpcData::ActionEffect1(a) if a.action_id == action => a.effects.iter().any(|e| matches!(e.0, TargetEffectKind::GainEffect { effect_id:148, param:8, unk2:20, .. })),
            _ => false,
        }), "职业 {job} 缺少录像对应的复活效果包");
        let mut w = f.world.lock();
        let i = &mut w.instances[0];
        let now = Instant::now();
        let mut n = f.network.lock();
        revival::handle_trigger(&mut n, i, f.ally, &ClientTriggerCommand::Revive { action:5 }, now);
        revival::tick(&mut n, i, now + Duration::from_millis(1500));
        revival::handle_trigger(&mut n, i, f.ally, &ClientTriggerCommand::FinishZoning { location_change_type:5, position_change_type:2 }, now + Duration::from_secs(2));
        revival::tick(&mut n, i, now + Duration::from_secs(5));
        let a = i.find_actor(f.ally).unwrap();
        assert_eq!(a.get_common_spawn().health_points, 20000);
        assert_eq!(a.get_common_spawn().resource_points, 2000);
        assert!(a.status_effects().unwrap().get(418).is_some());
    }
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_melee_role_actions_grant_real_statuses_and_lifesteal(){
    let mut f=Fixture::new(39);let enemy=ObjectId(0x400000f8);
    {let mut w=f.world.lock();let i=&mut w.instances[0];let mut s=kawari::ipc::zone::SpawnNpc::default();s.common.health_points=100000;s.common.max_health_points=100000;s.common.owner_id=ObjectId(0xE0000000);s.common.position=kawari::common::Position(glam::Vec3::new(0.0,0.0,2.0));i.insert_npc(enemy,s);if let Some(NetworkedActor::Player{parameters,..})=i.find_actor_mut(f.owner){parameters.strength=1000;parameters.physical_damage=100;}}
    f.act(7542);f.act(7546);f.act_on(7549,enemy);f.act_on(7863,enemy);f.act_on(24373,enemy);
    {let w=f.world.lock();let a=w.instances[0].find_actor(f.owner).unwrap();assert!(a.get_common_spawn().health_points>1000);for id in[84,1250]{assert!(a.status_effects().unwrap().get(id).is_some());}let e=w.instances[0].find_actor(enemy).unwrap();assert!(e.is_action_locked());assert!(e.status_effects().unwrap().get(1195).unwrap().duration>14.0);}
    assert_eq!(f.game.lock().get_action_max_charges_at_level(7546,100),2);
    let _=f.packets().await;
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_scholar_esuna_removes_only_dispellable_negative_status(){
    let mut f=Fixture::new(28);{let mut w=f.world.lock();let s=w.instances[0].find_actor_mut(f.ally).unwrap().status_effects_mut().unwrap();s.add_with_source(3,0,30.0,f.owner);s.add_with_source(43,0,100.0,f.owner);}
    f.act_on(7568,f.ally);
    {let w=f.world.lock();let s=w.instances[0].find_actor(f.ally).unwrap().status_effects().unwrap();assert!(s.get(3).is_none());assert!(s.get(43).is_some());}
    let _=f.packets().await;
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_rpr_execution_enshroud_and_lemure_match_supplement(){
    let mut f=Fixture::new(39);let e=ObjectId(0x400000f1);{let mut w=f.world.lock();let i=&mut w.instances[0];let mut s=kawari::ipc::zone::SpawnNpc::default();s.common.health_points=1000000;s.common.max_health_points=1000000;s.common.owner_id=ObjectId(0xE0000000);s.common.position=kawari::common::Position(glam::Vec3::new(0.0,0.0,2.0));i.insert_npc(e,s);if let Some(NetworkedActor::Player{parameters,combat_state,..})=i.find_actor_mut(f.owner){parameters.strength=1000;parameters.physical_damage=100;combat_state.in_combat=true;combat_state.reaper.shroud=50;}}
    for id in[24380,24393,24382,24383,24394,24393,24382,24383,24389,24382,24383,24389,24398]{f.act_on(id,e);}
    {let w=f.world.lock();let NetworkedActor::Player{combat_state,..}=w.instances[0].find_actor(f.owner).unwrap()else{panic!()};assert_eq!(combat_state.reaper.shroud,20);assert_eq!(combat_state.reaper.lemure,0);assert_eq!(combat_state.reaper.void,0);}
    let p=f.packets().await;for id in[36970,36971,36969,24395,24396,24399,24398]{assert!(p.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==id)),"缺少钐镰派生 {id}");}
    {let mut g=f.game.lock();assert_eq!(g.get_action_max_charges_at_level(24380,100),2);}
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_rpr_crest_break_and_portal_are_real_runtime_objects(){
    use super::dispatch::JobActors;let mut f=Fixture::new(39);f.act(24404);
    {let mut w=f.world.lock();let i=&mut w.instances[0];i.find_actor_mut(f.owner).unwrap().apply_damage(10000);super::pictomancer::on_barrier_break(&mut f.network.lock(),i,f.owner);for id in[f.owner,f.ally]{assert!(i.find_actor(id).unwrap().status_effects().unwrap().get(2598).is_some());}assert!(i.find_actor(f.stranger).unwrap().status_effects().unwrap().get(2598).is_none());}
    f.act(24402);let gate={let w=f.world.lock();w.instances[0].actors.iter().find_map(|(id,a)|match a{NetworkedActor::Object{object,..}if object.base_id==1219=>Some(*id),_=>None}).expect("地狱之门未生成")};f.act(24403);assert!(f.world.lock().instances[0].find_actor(gate).is_none());
    {let mut w=f.world.lock();super::reaper::Reaper.on_job_deactivated(&mut f.network.lock(),&mut w.instances[0],f.owner);}
    let _=f.packets().await;
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_rdm_manafication_morphs_and_finisher_chain_match_recording(){
    let mut f=Fixture::new(35);let enemy=ObjectId(0x400000e1);
    {let mut w=f.world.lock();let i=&mut w.instances[0];let mut s=kawari::ipc::zone::SpawnNpc::default();s.common.health_points=1000000;s.common.max_health_points=1000000;s.common.owner_id=ObjectId(0xE0000000);s.common.position=kawari::common::Position(glam::Vec3::new(0.0,0.0,2.0));i.insert_npc(enemy,s);if let Some(NetworkedActor::Player{combat_state,..})=i.find_actor_mut(f.owner){combat_state.in_combat=true;}}
    f.act_on(37004,enemy);f.act(7521);for id in[7504,7512,7516,25856,37004,37004]{f.act_on(id,enemy);}
    {let w=f.world.lock();let NetworkedActor::Player{combat_state,..}=w.instances[0].find_actor(f.owner).unwrap()else{panic!()};assert_eq!(super::dispatch::job_for(35).unwrap().build_gauge_data(combat_state,100).unwrap().to_le_bytes()[..3],[21,10,0]);}
    let p=f.packets().await;for id in[45960,45961,45962,7526,16530,25858]{assert!(p.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==id)),"缺少赤魔派生 {id}");}
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_rdm_party_support_and_dualcast_request_are_effective(){
    let mut f=Fixture::new(35);f.act(7520);f.act(25857);
    {let w=f.world.lock();let i=&w.instances[0];assert!(i.find_actor(f.owner).unwrap().status_effects().unwrap().get(1239).is_some());assert!(i.find_actor(f.ally).unwrap().status_effects().unwrap().get(1297).is_some());assert!(i.find_actor(f.stranger).unwrap().status_effects().unwrap().get(2707).is_none());}
    f.act_on(7514,f.ally);{let w=f.world.lock();assert!(w.instances[0].find_actor(f.owner).unwrap().status_effects().unwrap().get(1249).is_some());}
    let _=f.packets().await;
    crate::server::action::handle_action_messages(f.world.clone(),f.game.clone(),f.network.clone(),f.lua.clone(),&crate::ToServer::ActionRequest(ClientId::default(),f.owner,ActionRequest{action_id:7514,action_type:ActionType::Action,target:ObjectTypeId{object_id:f.ally,..Default::default()},..Default::default()}));
    tokio::time::sleep(std::time::Duration::from_millis(200)).await;
    let p=f.packets().await;assert!(!p.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActorCast{..})));assert!(p.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==7514)));
    {let mut g=f.game.lock();assert_eq!(g.get_action_max_charges_at_level(7518,100),2);}
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_vpr_reawaken_and_followups_match_supplement_gauge(){
    use kawari::ipc::zone::ActorControlCategory;

    let mut f=Fixture::new(41);let enemy=ObjectId(0x400000d1);
    {let mut w=f.world.lock();let i=&mut w.instances[0];let mut spawn=kawari::ipc::zone::SpawnNpc::default();spawn.common.health_points=1000000;spawn.common.max_health_points=1000000;spawn.common.owner_id=ObjectId(0xE0000000);spawn.common.position=kawari::common::Position(glam::Vec3::new(0.0,0.0,2.0));i.insert_npc(enemy,spawn);if let Some(NetworkedActor::Player{parameters,combat_state,..})=i.find_actor_mut(f.owner){parameters.dexterity=1000;parameters.physical_damage=100;combat_state.in_combat=true;}}
    for id in [34620,34647,34621,35921,35922,34622,35922,35921]{f.act_on(id,enemy);}
    let mut p = f.packets().await;
    f.act_on(34626, enemy);
    let start = f.packets().await;
    let action = start.iter().position(|(_, p)| matches!(
        p, ServerZoneIpcData::ActionEffect8(a)
            if a.header.action_id == 34626 && a.header.target_count == 1
    )).unwrap();
    let ready_removed = start.iter().position(|(_, p)| matches!(
        p, ServerZoneIpcData::ActorControl(a)
            if matches!(a.category, ActorControlCategory::LoseEffect { effect_id: 3671, .. })
    )).unwrap();
    let reawaken_gained = start.iter().position(|(_, p)| matches!(
        p, ServerZoneIpcData::ActorControl(a)
            if matches!(a.category, ActorControlCategory::GainEffect { effect_id: 3670, .. })
    )).unwrap();
    let statuses = start.iter().position(|(source, p)| *source == f.owner && matches!(
        p, ServerZoneIpcData::StatusEffectList(list)
            if list.statuses.iter().any(|s| s.effect_id == 3670)
    )).unwrap();
    let gauge: Vec<_> = start.iter().enumerate().filter_map(|(index, (_, p))| match p {
        ServerZoneIpcData::ActorGauge { classjob_id: 41, data, .. } => {
            Some((index, data.to_le_bytes()))
        }
        _ => None,
    }).collect();
    assert_eq!(gauge.len(), 1);
    assert_eq!(gauge[0].1[..4], [2, 5, 10, 7]);
    assert!(action < ready_removed && ready_removed < reawaken_gained);
    assert!(reawaken_gained < statuses && statuses < gauge[0].0);
    p.extend(start);
    for id in [34606,35920,34607,35920,34621,35920,34622,35920,34626]{f.act_on(id,enemy);}
    p.extend(f.packets().await);
    assert!(p.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActorGauge{classjob_id:41,data,extra}if data.to_le_bytes()[..4]==[2,0,5,2]&&extra[0]==0x1e)));
    for extra in [0x1d,0x0d,0x11,0x15,0x19]{assert!(p.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActorGauge{classjob_id:41,extra:e,..}if e[0]==extra)),"缺少蝰蛇追加状态 {extra}");}
    assert!(p.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==34631)));
    {let w=f.world.lock();let NetworkedActor::Player{combat_state,..}=w.instances[0].find_actor(f.owner).unwrap()else{panic!()};assert_eq!(combat_state.viper.tribute,0);assert_eq!(combat_state.viper.offering,10);}
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_vpr_haste_changes_gcd_but_not_charge_recovery(){
    let f=Fixture::new(41);let mut w=f.world.lock();let a=w.instances[0].find_actor_mut(f.owner).unwrap();if let NetworkedActor::Player{remove_cooldowns,status_effects,..}=a{*remove_cooldowns=false;status_effects.add_with_source(3669,0,40.0,f.owner);}
    crate::server::action::start_action_cooldowns(a,&mut f.game.lock(),34620);
    if let NetworkedActor::Player{combat_state,parameters,..}=a{assert_eq!(combat_state.cooldowns[14].as_mut().unwrap().timer_values().1,8000);assert_eq!(combat_state.cooldowns[57].as_mut().unwrap().timer_values().1,parameters.apply_speed(300)*85/100);}
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_dnc_partner_standard_finish_and_waltz_keep_sources(){
    let mut f=Fixture::new(38);{let mut w=f.world.lock();if let Some(NetworkedActor::Player{parameters,..})=w.instances[0].find_actor_mut(f.owner){parameters.dexterity=1000;parameters.physical_damage=100;}}f.act_on(16006,f.stranger);
    {let w=f.world.lock();let NetworkedActor::Player{combat_state,..}=w.instances[0].find_actor(f.owner).unwrap()else{panic!()};assert!(combat_state.dancer.partner.is_none());}
    f.act_on(16006,f.ally);f.act(15997);
    let steps={let w=f.world.lock();let NetworkedActor::Player{combat_state,..}=w.instances[0].find_actor(f.owner).unwrap()else{panic!()};combat_state.dancer.steps};
    for step in &steps[..2]{f.act(15998+u32::from(*step));}f.act(15997);f.act(16011);f.act(16015);
    {let w=f.world.lock();let i=&w.instances[0];for id in [f.owner,f.ally]{let a=i.find_actor(id).unwrap();let s=a.status_effects().unwrap();assert_eq!(s.get(1821).unwrap().param,0);assert_eq!(s.magnitude(1821),Some(5));assert_eq!(s.get(1825).unwrap().source_actor_id,f.owner);assert!(a.get_common_spawn().health_points>1000);}assert!(i.find_actor(f.stranger).unwrap().status_effects().unwrap().get(1821).is_none());}
    let p=f.packets().await;assert!(p.iter().any(|(_,p)|match p{ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==16015=>a.header.target_count==2&&a.effects[0].iter().filter(|e|matches!(e.0,kawari::ipc::zone::TargetEffectKind::Heal{..})).count()==2,_=>false}));
    f.act(16006);{let w=f.world.lock();let i=&w.instances[0];assert!(i.find_actor(f.ally).unwrap().status_effects().unwrap().get(1824).is_none());}
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_dnc_dance_recasts_charges_and_flourish_follow_traits(){
    let mut f=Fixture::new(38);
    {let mut w=f.world.lock();let a=w.instances[0].find_actor_mut(f.owner).unwrap();if let NetworkedActor::Player{combat_state,remove_cooldowns,..}=a{combat_state.in_combat=true;*remove_cooldowns=false;}crate::server::action::start_action_cooldowns(a,&mut f.game.lock(),15997);if let NetworkedActor::Player{combat_state,..}=a{assert_eq!(combat_state.cooldowns[6].as_mut().unwrap().timer_values().1,3000);assert_eq!(combat_state.cooldowns[57].as_mut().unwrap().timer_values().1,150);}crate::server::action::start_action_cooldowns(a,&mut f.game.lock(),15999);if let NetworkedActor::Player{combat_state,remove_cooldowns,..}=a{assert_eq!(combat_state.cooldowns[57].as_mut().unwrap().timer_values().1,100);*remove_cooldowns=true;}}
    {let mut g=f.game.lock();for(level,charges)in[(67,1),(68,2),(78,3)]{assert_eq!(g.get_action_max_charges_at_level(16010,level),charges);}}
    f.act(16013);f.act(15997);let p=f.packets().await;assert!(p.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==36984)));
    {let w=f.world.lock();let s=w.instances[0].find_actor(f.owner).unwrap().status_effects().unwrap();assert!(s.get(3868).is_none());assert!(s.get(3867).is_some());}
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_sam_meikyo_tendo_and_kaeshi_send_recorded_effects(){
    let mut f=Fixture::new(34);let enemy=ObjectId(0x400000c1);
    {let mut w=f.world.lock();let i=&mut w.instances[0];let mut spawn=kawari::ipc::zone::SpawnNpc::default();spawn.common.health_points=1000000;spawn.common.max_health_points=1000000;spawn.common.owner_id=ObjectId(0xE0000000);spawn.common.position=kawari::common::Position(glam::Vec3::new(0.0,0.0,2.0));i.insert_npc(enemy,spawn);if let Some(NetworkedActor::Player{parameters,combat_state,..})=i.find_actor_mut(f.owner){parameters.strength=1000;parameters.physical_damage=100;combat_state.in_combat=true;}}
    f.act(7499);for id in [7481,7482,7480]{f.act_on(id,enemy);}f.act_on(7867,enemy);
    {let w=f.world.lock();let a=w.instances[0].find_actor(f.owner).unwrap();let NetworkedActor::Player{combat_state,..}=a else{panic!()};assert_eq!(combat_state.samurai.sen,0);assert_eq!(combat_state.samurai.meditation,1);assert!(a.status_effects().unwrap().get(4218).is_some());assert!(a.status_effects().unwrap().get(1233).is_none());}
    f.act_on(7477,enemy);f.act_on(16483,enemy);
    let packets=f.packets().await;for id in [36966,36968]{assert!(packets.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==id)),"缺少武士派生技能 {id}");}
    assert!(packets.iter().any(|(_,p)|match p{ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==7482=>a.effects.iter().flatten().any(|e|matches!(e.0,kawari::ipc::zone::TargetEffectKind::GainEffectSelf{effect_id:1299,unk1:243,param:0,..})),_=>false}));
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_sam_iaijutsu_cast_and_cooldown_apply_fuka_and_level_traits(){
    let mut f=Fixture::new(34);let enemy=ObjectId(0x400000c2);
    {let mut w=f.world.lock();let i=&mut w.instances[0];let mut spawn=kawari::ipc::zone::SpawnNpc::default();spawn.common.health_points=1000000;spawn.common.max_health_points=1000000;spawn.common.owner_id=ObjectId(0xE0000000);spawn.common.position=kawari::common::Position(glam::Vec3::new(0.0,0.0,2.0));i.insert_npc(enemy,spawn);let a=i.find_actor_mut(f.owner).unwrap();if let NetworkedActor::Player{combat_state,status_effects,..}=a{combat_state.samurai.sen=1;status_effects.add_with_source(1299,0,40.0,f.owner);}}
    let expected={let w=f.world.lock();let NetworkedActor::Player{parameters,..}=w.instances[0].find_actor(f.owner).unwrap()else{panic!()};(parameters.apply_speed(130)*87/100)as f32/100.0};
    let request=ActionRequest{action_id:7867,action_type:ActionType::Action,target:ObjectTypeId{object_id:enemy,..Default::default()},..Default::default()};
    crate::server::action::handle_action_messages(f.world.clone(),f.game.clone(),f.network.clone(),f.lua.clone(),&crate::ToServer::ActionRequest(ClientId::default(),f.owner,request));
    let p=f.packets().await;assert!(p.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActorCast{action_id:7489,cast_time,..}if *cast_time==expected)),"缺少受风花影响的居合读条 {expected}");
    {let mut g=f.game.lock();assert_eq!(g.get_action_max_charges_at_level(7499,75),1);assert_eq!(g.get_action_max_charges_at_level(7499,76),2);}
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_mch_heated_combo_resources_and_wildfire_use_native_path(){
    let mut f=Fixture::new(31);let enemy=ObjectId(0x400000a1);
    {let mut w=f.world.lock();let i=&mut w.instances[0];let mut spawn=kawari::ipc::zone::SpawnNpc::default();spawn.common.health_points=1000000;spawn.common.max_health_points=1000000;spawn.common.owner_id=ObjectId(0xE0000000);spawn.common.position=kawari::common::Position(glam::Vec3::new(0.0,0.0,5.0));i.insert_npc(enemy,spawn);if let Some(NetworkedActor::Player{parameters,combat_state,..})=i.find_actor_mut(f.owner){parameters.dexterity=1000;parameters.physical_damage=100;combat_state.in_combat=true;}}
    {let w=f.world.lock();f.network.lock().spawn_inserted_actor_in_range(&w.instances[0],enemy);}
    f.act_on(2878,enemy);for id in [2866,2868,2873]{f.act_on(id,enemy);}
    {let w=f.world.lock();let NetworkedActor::Player{combat_state,last_combo_action,..}=w.instances[0].find_actor(f.owner).unwrap()else{panic!()};assert_eq!(combat_state.machinist.heat,15);assert_eq!(combat_state.machinist.battery,10);assert_eq!(*last_combo_action,2873);}
    let packets=f.packets().await;assert!(packets.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==7413)));
    let before={let w=f.world.lock();w.instances[0].find_actor(enemy).unwrap().get_common_spawn().health_points};
    f.act_on(16766,enemy);
    {let w=f.world.lock();assert!(w.instances[0].find_actor(enemy).unwrap().get_common_spawn().health_points<before,"野火未结算：{:?}",if let NetworkedActor::Player{combat_state,..}=w.instances[0].find_actor(f.owner).unwrap(){Some(&combat_state.machinist)}else{None});}
    tokio::task::yield_now().await;let mut wildfire_tick=false;while let Ok(message)=f.messages.try_recv(){if matches!(message,FromServer::ActorControl(target,kawari::ipc::zone::ActorControlCategory::TickDamage{status_id:861,amount,..})if target==enemy&&amount>0){wildfire_tick=true;}}assert!(wildfire_tick);
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_mnk_forms_perfect_balance_and_blitz_consume_distinct_resources(){
    let mut f=Fixture::new(20);let enemy=ObjectId(0x400000b1);
    {let mut w=f.world.lock();let i=&mut w.instances[0];let mut spawn=kawari::ipc::zone::SpawnNpc::default();spawn.common.health_points=1000000;spawn.common.max_health_points=1000000;spawn.common.owner_id=ObjectId(0xE0000000);spawn.common.position=kawari::common::Position(glam::Vec3::new(0.0,0.0,2.0));i.insert_npc(enemy,spawn);if let Some(NetworkedActor::Player{parameters,combat_state,..})=i.find_actor_mut(f.owner){parameters.strength=1000;parameters.physical_damage=100;combat_state.in_combat=true;}}
    f.act(4262);for id in [74,61,66]{f.act_on(id,enemy);}
    {let w=f.world.lock();let NetworkedActor::Player{combat_state,..}=w.instances[0].find_actor(f.owner).unwrap()else{panic!()};assert_eq!(combat_state.monk.fury,[1,1,2]);}
    f.act(69);for _ in 0..3{f.act_on(53,enemy);}f.act(25764);
    {let w=f.world.lock();let a=w.instances[0].find_actor(f.owner).unwrap();let NetworkedActor::Player{combat_state,..}=a else{panic!()};assert_eq!(combat_state.monk.nadi,1);assert_eq!(combat_state.monk.beast,[0;3]);assert!(a.status_effects().unwrap().get(2513).is_some());}
    f.act(69);for id in [74,61,66]{f.act_on(id,enemy);}f.act(25764);
    {let w=f.world.lock();let NetworkedActor::Player{combat_state,..}=w.instances[0].find_actor(f.owner).unwrap()else{panic!()};assert_eq!(combat_state.monk.nadi,3);}
    f.act(69);for _ in 0..3{f.act_on(53,enemy);}f.act_on(25764,enemy);
    {let w=f.world.lock();let NetworkedActor::Player{combat_state,..}=w.instances[0].find_actor(f.owner).unwrap()else{panic!()};assert_eq!(combat_state.monk.nadi,0);assert!(combat_state.monk.chakra>0);}
    let packets=f.packets().await;for id in [36948,25768,25769]{assert!(packets.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==id)),"缺少必杀 {id}");}
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_mnk_party_support_riddle_heal_and_haste_use_runtime(){
    use super::dispatch::JobActors;
    let mut f=Fixture::new(20);{let mut w=f.world.lock();if let Some(NetworkedActor::Player{parameters,..})=w.instances[0].find_actor_mut(f.owner){parameters.strength=1000;parameters.physical_damage=100;}}f.act(65);f.act(7396);f.act(7394);
    {let mut w=f.world.lock();let i=&mut w.instances[0];assert!(i.find_actor(f.ally).unwrap().status_effects().unwrap().get(104).is_some());assert!(i.find_actor(f.ally).unwrap().status_effects().unwrap().get(1185).is_some());assert!(i.find_actor(f.stranger).unwrap().status_effects().unwrap().get(1185).is_none());i.find_actor_mut(f.owner).unwrap().apply_damage(1);super::monk::Monk.on_tick(&mut f.network.lock(),i,f.owner);assert!(i.find_actor(f.owner).unwrap().status_effects().unwrap().get(1180).is_some());}
    f.act(7394);
    {let mut w=f.world.lock();let i=&mut w.instances[0];assert!(i.find_actor(f.ally).unwrap().get_common_spawn().health_points>1000);let a=i.find_actor_mut(f.owner).unwrap();if let NetworkedActor::Player{parameters,remove_cooldowns,..}=a{*remove_cooldowns=false;parameters.skill_speed=420;}crate::server::action::start_action_cooldowns(a,&mut f.game.lock(),36945);if let NetworkedActor::Player{combat_state,parameters,..}=a{let(_,total)=combat_state.cooldowns[57].as_mut().unwrap().timer_values();assert_eq!(total,parameters.apply_speed(250)*80/100);}}
    let _=f.packets().await;
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_mch_level_charges_overheat_and_reassemble_follow_local_traits(){
    let mut f=Fixture::new(31);let enemy=ObjectId(0x400000a2);
    {let mut g=f.game.lock();for(id,lo,hi,l)in[(2874,2,3,74),(2876,1,2,84),(16498,1,2,94)]{assert_eq!(g.get_action_max_charges_at_level(id,l-1),lo);assert_eq!(g.get_action_max_charges_at_level(id,l),hi);}}
    {let mut w=f.world.lock();let i=&mut w.instances[0];let mut spawn=kawari::ipc::zone::SpawnNpc::default();spawn.common.health_points=1000000;spawn.common.max_health_points=1000000;spawn.common.owner_id=ObjectId(0xE0000000);spawn.common.position=kawari::common::Position(glam::Vec3::new(0.0,0.0,5.0));i.insert_npc(enemy,spawn);if let Some(NetworkedActor::Player{parameters,combat_state,..})=i.find_actor_mut(f.owner){parameters.dexterity=1000;parameters.physical_damage=100;combat_state.in_combat=true;combat_state.machinist.heat=30;}}
    f.act(7414);f.act(17209);f.act(2876);f.act_on(36982,enemy);
    {let w=f.world.lock();let a=w.instances[0].find_actor(f.owner).unwrap();assert!(a.status_effects().unwrap().get(851).is_some());let NetworkedActor::Player{combat_state,..}=a else{panic!()};assert_eq!(combat_state.machinist.heat,30);}
    for _ in 0..5{f.act_on(7410,enemy);}
    {let w=f.world.lock();let a=w.instances[0].find_actor(f.owner).unwrap();let NetworkedActor::Player{combat_state,..}=a else{panic!()};assert_eq!(combat_state.machinist.overheat_stacks,0);assert!(a.status_effects().unwrap().get(2688).is_none());}
    let _=f.packets().await;
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_sge_eukrasia_costs_kardia_and_single_target_do_not_duplicate(){
    let mut f=Fixture::new(40);let enemies=[ObjectId(0x40000091),ObjectId(0x40000092)];
    {let mut w=f.world.lock();let i=&mut w.instances[0];for id in enemies{let mut spawn=kawari::ipc::zone::SpawnNpc::default();spawn.common.health_points=1000000;spawn.common.max_health_points=1000000;spawn.common.owner_id=ObjectId(0xE0000000);spawn.common.position=kawari::common::Position(glam::Vec3::new(0.0,0.0,5.0));i.insert_npc(id,spawn);}}
    f.act(24290);f.act_on(24284,f.ally);
    {let w=f.world.lock();let i=&w.instances[0];let NetworkedActor::Player{spawn,combat_state,..}=i.find_actor(f.owner).unwrap()else{panic!()};assert!(!combat_state.sage.eukrasia);assert_eq!(spawn.common.resource_points,9200);assert!(i.find_actor(f.ally).unwrap().status_effects().unwrap().barrier_remaining(2607)>0);}
    f.act_on(24285,f.ally);f.act(24294);
    let before={let w=f.world.lock();w.instances[0].find_actor(f.ally).unwrap().get_common_spawn().health_points};
    f.act_on(24283,enemies[0]);
    {let w=f.world.lock();let i=&w.instances[0];assert!(i.find_actor(f.ally).unwrap().get_common_spawn().health_points>before);assert_eq!(i.find_actor(f.owner).unwrap().status_effects().unwrap().get(2610).unwrap().param,3);assert!(i.find_actor(enemies[0]).unwrap().get_common_spawn().health_points<1000000);assert_eq!(i.find_actor(enemies[1]).unwrap().get_common_spawn().health_points,1000000);}
    let p=f.packets().await;assert!(p.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActorGauge{classjob_id:40,data,..}if data.to_le_bytes()[4]==1)));
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_sge_pneuma_sends_its_recorded_heal_action_after_damage(){
    let mut f=Fixture::new(40);let enemy=ObjectId(0x40000093);
    {let mut w=f.world.lock();let mut spawn=kawari::ipc::zone::SpawnNpc::default();spawn.common.health_points=1000000;spawn.common.max_health_points=1000000;spawn.common.owner_id=ObjectId(0xE0000000);spawn.common.position=kawari::common::Position(glam::Vec3::new(0.0,0.0,5.0));w.instances[0].insert_npc(enemy,spawn);}
    f.act(24300);f.act_on(24318,enemy);
    let packets=f.packets().await;let actions:Vec<_>=packets.iter().filter_map(|(_,p)|match p{ServerZoneIpcData::ActionEffect1(a)=>Some(a.action_id),ServerZoneIpcData::ActionEffect8(a)=>Some(a.header.action_id),_=>None}).collect();
    let attack=actions.iter().position(|x|*x==24318).unwrap();let heal=actions.iter().position(|x|*x==27524).unwrap();assert!(attack<heal);
    {let w=f.world.lock();let i=&w.instances[0];assert!(i.find_actor(f.ally).unwrap().get_common_spawn().health_points>1000);assert_eq!(i.find_actor(f.stranger).unwrap().get_common_spawn().health_points,1000);assert!(i.find_actor(f.owner).unwrap().status_effects().unwrap().get(2611).is_none());}
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_sch_recitation_barrier_emergency_and_fairy_use_real_request_path(){
    use kawari::ipc::zone::TargetEffectKind;
    let mut f=Fixture::new(28);
    {let mut w=f.world.lock();if let Some(NetworkedActor::Player{combat_state,..})=w.instances[0].find_actor_mut(f.owner){combat_state.in_combat=true;}}
    f.act(17215);f.act(166);f.act(16542);f.act_on(185,f.ally);
    let packets=f.packets().await;
    let effects=packets.iter().find_map(|(_,p)|match p{ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==185=>Some(a.effects[0]),ServerZoneIpcData::ActionEffect1(a)if a.action_id==185=>Some(a.effects),_=>None}).expect("鼓舞结果包");
    let amount=effects.iter().find_map(|e|if let TargetEffectKind::Heal{amount,unk1}=e.0{assert_eq!(unk1[1]&0x20,0x20);Some(amount)}else{None}).unwrap();
    {
        let w=f.world.lock();let i=&w.instances[0];let a=i.find_actor(f.ally).unwrap();let s=a.status_effects().unwrap();
        assert_eq!(s.barrier_remaining(297),amount*180/100);assert_eq!(s.barrier_remaining(1918),amount*180/100);
        let NetworkedActor::Player{spawn,combat_state,..}=i.find_actor(f.owner).unwrap()else{panic!()};
        assert_eq!(spawn.common.resource_points,10000,"超流回满魔力，秘策鼓舞免费");assert!(combat_state.scholar.fairy.is_some());assert_eq!(combat_state.scholar.aetherflow,3);
    }
    f.act(3586);f.act(186);
    let p=f.packets().await;
    assert!(p.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==37013 && a.effects[0].iter().filter(|e|matches!(e.0,TargetEffectKind::Heal{..})).count()==2)));
    f.act(16537);f.act(3587);
    let p=f.packets().await;
    assert!(p.iter().any(|(source,p)|*source!=f.owner&&matches!(p,ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==803)));
    {let w=f.world.lock();let i=&w.instances[0];let NetworkedActor::Player{combat_state,..}=i.find_actor(f.owner).unwrap()else{panic!()};assert!(combat_state.scholar.fairy.is_none());
        let tick=i.find_actor(f.ally).unwrap().status_effects().unwrap().tick_effects(std::time::Instant::now()).find(|t|t.effect_id==315).unwrap();assert_eq!(tick.stat_source_actor_id,Some(f.owner));assert_ne!(tick.source_actor_id,f.owner);
    }
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_sch_fairy_flow_excogitation_and_deployment_validate_sources(){
    let mut f=Fixture::new(28);
    {let mut w=f.world.lock();let a=w.instances[0].find_actor_mut(f.owner).unwrap();if let NetworkedActor::Player{combat_state,..}=a{combat_state.in_combat=true;}w.instances[0].find_actor_mut(f.ally).unwrap().get_common_spawn_mut().health_points=100000;}
    f.act(17215);f.act(166);f.act_on(189,f.ally);
    f.act(16542);f.act_on(7434,f.ally);
    {let w=f.world.lock();let i=&w.instances[0];let NetworkedActor::Player{combat_state,..}=i.find_actor(f.owner).unwrap()else{panic!()};assert_eq!(combat_state.scholar.aetherflow,2);assert_eq!(combat_state.scholar.fairy_gauge,20);assert!(i.find_actor(f.ally).unwrap().status_effects().unwrap().get(1220).is_some());}
    f.act(16542);f.act_on(185,f.ally);f.act_on(3585,f.ally);
    {let w=f.world.lock();let i=&w.instances[0];let own=i.find_actor(f.owner).unwrap().status_effects().unwrap();let ally=i.find_actor(f.ally).unwrap().status_effects().unwrap();assert_eq!(own.barrier_remaining(297),ally.barrier_remaining(297));assert!(own.get(1918).is_none());assert!(i.find_actor(f.stranger).unwrap().status_effects().unwrap().get(297).is_none());}
    let _=f.packets().await;
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_drk_delirium_packets_aoe_and_dark_arts_use_real_request_path(){
    let mut f=Fixture::new(32);let enemy=ObjectId(0x40000011);
    {
        let mut w=f.world.lock();let i=&mut w.instances[0];
        let mut spawn=kawari::ipc::zone::SpawnNpc::default();spawn.common.health_points=1_000_000;spawn.common.max_health_points=1_000_000;spawn.common.owner_id=ObjectId(0xE0000000);i.insert_npc(enemy,spawn);
        if let NetworkedActor::Player{parameters,combat_state,spawn,..}=i.find_actor_mut(f.owner).unwrap(){parameters.strength=1000;parameters.physical_damage=100;combat_state.in_combat=true;combat_state.dark_knight.blood=20;spawn.common.resource_points=1000;}
    }
    f.act(7390);
    for(action,blood,step,mp) in [(7392,30,1,1800),(7392,40,2,2600),(7392,50,0,3400)] {
        f.act_on(action,enemy);
        {let w=f.world.lock();let NetworkedActor::Player{combat_state,spawn,..}=w.instances[0].find_actor(f.owner).unwrap()else{panic!()};assert_eq!(combat_state.dark_knight.blood,blood);assert_eq!(combat_state.dark_knight.combo_step,step);assert_eq!(spawn.common.resource_points,mp);}
        assert!(f.packets().await.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActorGauge{classjob_id:32,extra,..} if extra[0]==step as u8)));
    }
    f.act_on(7393,f.ally);
    {let mut w=f.world.lock();let i=&mut w.instances[0];assert_eq!(i.find_actor(f.owner).unwrap().get_common_spawn().resource_points,400);let ally=i.find_actor_mut(f.ally).unwrap();ally.apply_damage(25000);super::pictomancer::on_barrier_break(&mut f.network.lock(),i,f.ally);}
    f.act_on(16470,enemy);
    {let w=f.world.lock();let NetworkedActor::Player{combat_state,spawn,..}=w.instances[0].find_actor(f.owner).unwrap()else{panic!()};assert_eq!(spawn.common.resource_points,400);assert!(!combat_state.dark_knight.dark_arts);assert!(combat_state.dark_knight.has_darkside());}
    f.act(7390);f.act(7391);
    let packets=f.packets().await;
    assert!(packets.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==36931)));
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_drk_ground_followup_and_shadow_spawn_are_not_player_attacks(){
    use super::dispatch::JobActors;
    let mut f=Fixture::new(32);let enemy=ObjectId(0x40000021);
    {let mut w=f.world.lock();let mut spawn=kawari::ipc::zone::SpawnNpc::default();spawn.common.health_points=1_000_000;spawn.common.max_health_points=1_000_000;spawn.common.owner_id=ObjectId(0xE0000000);w.instances[0].insert_npc(enemy,spawn);}
    f.act(3639);f.act(3639); // 同一按钮变招：确认动作 + 固定位置的范围动作。
    let packets=f.packets().await;
    assert!(packets.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==25756)));
    f.act_on(16472,enemy);
    {let mut w=f.world.lock();let i=&mut w.instances[0];
        if let Some(NetworkedActor::Player{combat_state,..})=i.find_actor_mut(f.owner){combat_state.dark_knight.shadow_started=Some(std::time::Instant::now()-std::time::Duration::from_secs(7));}
        super::dark_knight::DarkKnight.on_tick(&mut f.network.lock(),i,f.owner);
        super::dark_knight::DarkKnight.on_tick(&mut f.network.lock(),i,f.owner);
    }
    let packets=f.packets().await;
    assert!(packets.iter().any(|(source,p)|*source!=f.owner&&matches!(p,ServerZoneIpcData::ActionEffect8(a)if a.header.action_id==17904&&a.header.animation_lock==2.2)));
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_warrior_beast_release_aoe_and_bloodwhetting_resolve_once() {
    let mut f=Fixture::new(21);
    let enemies=[ObjectId(0x40000001),ObjectId(0x40000002)];
    {
        let mut w=f.world.lock(); let i=&mut w.instances[0];
        for id in enemies {
            let mut spawn=kawari::ipc::zone::SpawnNpc::default();
            spawn.common.health_points=1_000_000;spawn.common.max_health_points=1_000_000;
            spawn.common.owner_id=ObjectId(0xE0000000);i.insert_npc(id,spawn);
        }
        if let NetworkedActor::Player{parameters,combat_state,..}=i.find_actor_mut(f.owner).unwrap(){
            parameters.strength=1000;parameters.physical_damage=100;combat_state.in_combat=true;
        }
    }
    f.act_on(31,enemies[0]);f.act_on(37,enemies[0]);f.act_on(45,enemies[0]);
    {
        let w=f.world.lock();let a=w.instances[0].find_actor(f.owner).unwrap();
        let NetworkedActor::Player{combat_state,..}=a else{unreachable!()};
        assert_eq!(combat_state.warrior.beast,20);
        let duration=a.status_effects().unwrap().get(2677).unwrap().duration;
        assert!(duration>29.0&&duration<=30.0,"风暴不应重复延长为 60 秒: {duration}");
    }
    f.act(52);f.act(7389);f.act_on(3549,enemies[0]); // 自动变为狂魂，保留解放三层。
    f.act(25751);
    let before={let w=f.world.lock();let i=&w.instances[0];
        (i.find_actor(f.owner).unwrap().get_common_spawn().health_points,
         enemies.map(|id|i.find_actor(id).unwrap().get_common_spawn().health_points))};
    f.act(3550);
    let packets=f.packets().await;
    let result=packets.iter().find_map(|(_,p)|match p{
        ServerZoneIpcData::ActionEffect8(a) if a.header.action_id==3550=>Some(a),_=>None}).expect("缺少地毁范围包");
    let mut received=std::collections::HashMap::new();
    for (t,effects) in result.target_ids.iter().zip(result.effects.iter()).take(result.header.target_count as usize) {
        for e in effects {
            match e.0 {kawari::ipc::zone::TargetEffectKind::Damage{amount,..}|kawari::ipc::zone::TargetEffectKind::Heal{amount,..}=>{received.insert(t.object_id,amount);},_=>{}}
        }
    }
    let w=f.world.lock();let i=&w.instances[0];
    for (n,id) in enemies.iter().enumerate(){assert_eq!(before.1[n]-i.find_actor(*id).unwrap().get_common_spawn().health_points,received[id]);}
    assert_eq!(i.find_actor(f.owner).unwrap().get_common_spawn().health_points-before.0,received[&f.owner]);
    let NetworkedActor::Player{combat_state,status_effects,..}=i.find_actor(f.owner).unwrap() else{unreachable!()};
    assert_eq!(combat_state.warrior.beast,20);
    assert_eq!(status_effects.get(1177).unwrap().param,2);
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_warrior_empty_aoe_has_no_hit_proc_and_shake_excludes_strangers() {
    let mut f=Fixture::new(21);
    f.act(7389);f.act(3550); // 没有敌人：消耗解放，但没有搏动。
    {
        let w=f.world.lock();let a=w.instances[0].find_actor(f.owner).unwrap();
        assert_eq!(a.status_effects().unwrap().get(1177).unwrap().param,2);
        assert!(a.status_effects().unwrap().get(3833).is_none());
    }
    f.act(40);f.act(36923);f.act(25751);f.act(7388);
    let packets=f.packets().await;
    assert!(packets.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActionEffect8(a) if a.header.action_id==7388)));
    let w=f.world.lock();let i=&w.instances[0];
    for id in [f.owner,f.ally] {
        let a=i.find_actor(id).unwrap();let s=a.status_effects().unwrap();
        assert_eq!(a.get_common_spawn().max_health_points,100000);
        assert!(s.get(1457).is_some());assert!(s.get(2108).is_some());
        // 15% 基础盾 + 三种被消耗的增益各 2%，按各受益者最大体力结算。
        let mut copy=s.clone();let amount=a.get_common_spawn().max_health_points*21/100;
        // 血烟可能还有额外护盾，因此独立检查摆脱时先去掉它。
        copy.remove(2680);assert_eq!(copy.absorb_damage(amount),0);assert_eq!(copy.absorb_damage(1),1);
    }
    assert!(i.find_actor(f.stranger).unwrap().status_effects().unwrap().get(1457).is_none());
    for id in [87,3832,2678] {assert!(i.find_actor(f.owner).unwrap().status_effects().unwrap().get(id).is_none());}
}
impl Fixture {
    fn new(class_job: u8) -> Self {
        let owner = ObjectId(0x10000001);
        let ally = ObjectId(0x10000002);
        let stranger = ObjectId(0x10000003);
        let mut instance = Instance::default();
        for id in [owner, ally, stranger] {
            instance.insert_empty_actor(id);
            if let NetworkedActor::Player {
                spawn,
                parameters,
                remove_cooldowns,
                ..
            } = instance.find_actor_mut(id).unwrap()
            {
                spawn.common.class_job = class_job;
                spawn.common.level = 100;
                spawn.common.health_points = 1000;
                spawn.common.max_health_points = 100000;
                spawn.common.resource_points = 10000;
                spawn.common.max_resource_points = 10000;
                *remove_cooldowns = true;
                *parameters = BaseParameters {
                    classjob_id: class_job,
                    level: 100,
                    mind: 1000,
                    intelligence: 1000,
                    magic_damage: 100,
                    ..Default::default()
                };
            }
        }
        let world = Arc::new(Mutex::new(WorldServer {
            instances: vec![instance],
            ..Default::default()
        }));
        let mut net = NetworkState::default();
        let (sender, messages) = tokio::sync::mpsc::channel(512);
        net.clients.insert(
            ClientId::default(),
            (
                ClientHandle {
                    id: ClientId::default(),
                    channel: sender,
                    actor_id: owner,
                    content_id: 0,
                    account_id: 0,
                },
                Default::default(),
            ),
        );
        net.parties.insert(
            1,
            Party {
                members: vec![
                    PartyMember {
                        actor_id: owner,
                        ..Default::default()
                    },
                    PartyMember {
                        actor_id: ally,
                        ..Default::default()
                    },
                ],
                ..Default::default()
            },
        );
        let game = Arc::new(Mutex::new(GameData::new()));
        let mut lua = KawariLua::new();
        lua.init(game.clone()).unwrap();
        Self {
            owner,
            ally,
            stranger,
            world,
            network: Arc::new(Mutex::new(net)),
            game,
            lua: Arc::new(Mutex::new(lua)),
            messages,
        }
    }
    fn act(&self, action: u32) {
        self.act_on(action, self.owner);
    }
    fn act_on(&self, action: u32, target: ObjectId) {
        let action = {
            let world = self.world.lock();
            let actor = world.instances[0].find_actor(self.owner).unwrap();
            if let NetworkedActor::Player {
                combat_state,
                spawn,
                ..
            } = actor
            {
                super::dispatch::job_for(spawn.common.class_job)
                    .map(|job| {
                        job.resolve_action(
                            &ActionRequest {
                                action_id: action,
                                ..Default::default()
                            },
                            combat_state,
                            spawn.common.level,
                            &mut self.game.lock(),
                        )
                    })
                    .unwrap_or(action)
            } else {
                action
            }
        };
        execute_action(
            self.network.clone(),
            self.world.clone(),
            self.game.clone(),
            self.lua.clone(),
            ClientId::default(),
            self.owner,
            ActionRequest {
                action_id: action,
                action_type: ActionType::Action,
                sequence: 9,
                target: ObjectTypeId {
                    object_id: target,
                    ..Default::default()
                },
                ..Default::default()
            },
            None,
        );
    }
    async fn packets(&mut self) -> Vec<(ObjectId, ServerZoneIpcData)> {
        tokio::task::yield_now().await;
        let mut packets = Vec::new();
        while let Ok(msg) = self.messages.try_recv() {
            if let FromServer::PacketSegment(packet, source) = msg {
                packets.push((source, packet.data));
            }
        }
        packets
    }
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_gnb_ammo_lion_continuations_and_party_defenses(){
    let mut f=Fixture::new(37);let enemy=ObjectId(0x40000031);
    {let mut w=f.world.lock();let i=&mut w.instances[0];let mut spawn=kawari::ipc::zone::SpawnNpc::default();spawn.common.health_points=2_000_000;spawn.common.max_health_points=2_000_000;spawn.common.owner_id=ObjectId(0xE0000000);i.insert_npc(enemy,spawn);if let Some(NetworkedActor::Player{parameters,combat_state,..})=i.find_actor_mut(f.owner){parameters.strength=1000;parameters.physical_damage=100;combat_state.in_combat=true;}}
    f.act_on(16137,enemy);f.act_on(16139,enemy);f.act_on(16145,enemy);
    {let w=f.world.lock();let a=w.instances[0].find_actor(f.owner).unwrap();assert!(a.status_effects().unwrap().get(1898).is_some());if let NetworkedActor::Player{combat_state,..}=a{assert_eq!(combat_state.gunbreaker.ammo,1);}}
    for skill in [16146,16155,16146,16155,16146,16155]{f.act_on(skill,enemy);}
    f.act_on(16164,enemy);
    for skill in [25760,36937,36937,36937,16162,16155]{f.act_on(skill,enemy);}
    let packets=f.packets().await;
    let ids:Vec<u32>=packets.iter().filter_map(|(_,p)|match p{ServerZoneIpcData::ActionEffect1(a)=>Some(a.action_id),ServerZoneIpcData::ActionEffect8(a)=>Some(a.header.action_id),_=>None}).collect();
    for id in [16146,16147,16150,16156,16157,16158,25760,36937,36938,36939,25759]{assert!(ids.contains(&id),"缺少动作 {id}");}
    f.act_on(25758,f.ally);f.act(16160);
    {let mut w=f.world.lock();let i=&mut w.instances[0];let ally=i.find_actor(f.ally).unwrap();for id in[1898,2683,2684,2685,1839]{assert!(ally.status_effects().unwrap().get(id).is_some(),"缺少状态 {id}");}assert!(i.find_actor(f.stranger).unwrap().status_effects().unwrap().get(1839).is_none());
        super::gunbreaker::tick_support(&mut f.network.lock(),i,f.ally);assert!(i.find_actor(f.ally).unwrap().status_effects().unwrap().get(2685).is_none());}
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_lightspeed_and_thin_air_send_signed_client_parameters() {
    for (job, action, status, param) in [(33, 3606, 841, -25i16), (24, 7430, 1217, -100)] {
        let mut f = Fixture::new(job);
        f.act(action);
        let world = f.world.lock();
        let actor = world.instances[0].find_actor(f.owner).unwrap();
        assert_eq!(
            actor.status_effects().unwrap().get(status).unwrap().param as i16,
            param
        );
        drop(world);
        assert!(
            f.packets().await.iter().any(
                |(_, p)| matches!(p,ServerZoneIpcData::ActionEffect1(a) if a.action_id==action)
            )
        );
    }
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_medica_heals_once_and_fans_out_regen_only_to_party() {
    let mut f = Fixture::new(24);
    f.act(37010);
    let packets = f.packets().await;
    let amount = packets
        .iter()
        .find_map(|(_, p)| {
            if let ServerZoneIpcData::ActionEffect8(a) = p {
                if a.header.action_id == 37010 {
                    if let kawari::ipc::zone::TargetEffectKind::Heal { amount, .. } =
                        a.effects[0][0].0
                    {
                        return Some(amount);
                    }
                }
                None
            } else {
                None
            }
        })
        .expect("没有范围治疗结果包");
    {
        let w = f.world.lock();
        let i = &w.instances[0];
        for id in [f.owner, f.ally] {
            let a = i.find_actor(id).unwrap();
            assert_eq!(a.get_common_spawn().health_points, 1000 + amount);
            assert!(a.status_effects().unwrap().get(3880).is_some());
        }
        assert_eq!(
            i.find_actor(f.stranger)
                .unwrap()
                .get_common_spawn()
                .health_points,
            1000
        );
    }
    assert!(packets.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActionEffect8(a) if a.header.action_id==37010 && a.header.target_count==2)));
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_bell_ack_precedes_pet_heal_and_animation_retirement() {
    let mut f = Fixture::new(24);
    f.act(25862);
    let _ = f.packets().await;
    f.act(28509);
    let packets = f.packets().await;
    let ack = packets
        .iter()
        .position(|(_, p)| matches!(p,ServerZoneIpcData::ActionEffect1(a) if a.action_id==28509))
        .expect("没有玩家引爆确认");
    let heal=packets.iter().position(|(_,p)|matches!(p,ServerZoneIpcData::ActionEffect1(a) if a.action_id==25864 && a.spell_id==25864 && a.animation_lock==1.1)).expect("没有铃演出");
    assert!(ack < heal);
    assert_ne!(packets[heal].0, f.owner);
    assert!(
        f.world.lock().instances[0]
            .find_actor(packets[heal].0)
            .is_some()
    );
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_bell_uses_recorded_model_and_stays_at_ground_position() {
    use crate::{
        common::{PetCommand, SpawnKind},
        server::actor::NpcState,
    };
    use kawari::common::Position;
    let mut f = Fixture::new(24);
    let ground = Position(glam::Vec3::new(12.0, 0.0, -8.0));
    execute_action(
        f.network.clone(),
        f.world.clone(),
        f.game.clone(),
        f.lua.clone(),
        ClientId::default(),
        f.owner,
        ActionRequest {
            action_id: 25862,
            action_type: ActionType::Action,
            target: ObjectTypeId {
                object_id: f.owner,
                ..Default::default()
            },
            ..Default::default()
        },
        Some(ground),
    );
    let bell = tokio::time::timeout(std::time::Duration::from_secs(3), async {
        loop {
            if let FromServer::ActorSpawn(id, SpawnKind::Npc(spawn)) =
                f.messages.recv().await.unwrap()
            {
                assert_eq!(spawn.common.model_chara, 3437);
                assert_eq!(spawn.common.display_flags.bits(), 0x40008);
                assert_eq!(spawn.common.position, ground);
                assert_eq!(
                    (
                        spawn.common.base_id,
                        spawn.common.name_id,
                        spawn.common.pet_id
                    ),
                    (13961, 10349, 33)
                );
                break id;
            }
        }
    })
    .await
    .expect("没有带独立客户端槽位的铃生成消息");
    {
        let mut w = f.world.lock();
        let i = &mut w.instances[0];
        i.find_actor_mut(f.owner)
            .unwrap()
            .get_common_spawn_mut()
            .position = Position(glam::Vec3::new(80.0, 0.0, 80.0));
        i.find_actor_mut(f.ally)
            .unwrap()
            .get_common_spawn_mut()
            .position = ground;
        i.find_actor_mut(f.stranger)
            .unwrap()
            .get_common_spawn_mut()
            .position = ground;
        for command in [
            PetCommand::Follow,
            PetCommand::Place(Position::default()),
            PetCommand::Stay,
            PetCommand::Recall,
        ] {
            assert!(!super::summoner::apply_pet_command(
                &mut f.network.lock(),
                i,
                f.owner,
                command
            ));
        }
        for _ in 0..4 {
            crate::server::npc_behavior::npc_behavior(
                f.network.clone(),
                f.lua.clone(),
                f.game.clone(),
                i,
                &mut Default::default(),
            );
        }
        match i.find_actor(bell).unwrap() {
            NetworkedActor::Npc {
                spawn,
                state,
                ai_paused,
                targetable,
                currently_invulnerable,
                navmesh_target,
                navmesh_path,
                ..
            } => {
                assert_eq!(spawn.common.position, ground);
                assert_eq!(*state, NpcState::Stay);
                assert!(*ai_paused && !*targetable && *currently_invulnerable);
                assert!(navmesh_target.is_none() && navmesh_path.is_empty());
            }
            _ => panic!("铃演员类型错误"),
        }
        super::white_mage::on_white_mage_took_damage(&mut f.network.lock(), i, f.owner);
        assert!(
            i.find_actor(f.ally)
                .unwrap()
                .get_common_spawn()
                .health_points
                > 1000
        );
        assert_eq!(
            i.find_actor(f.owner)
                .unwrap()
                .get_common_spawn()
                .health_points,
            1000
        );
        assert_eq!(
            i.find_actor(f.stranger)
                .unwrap()
                .get_common_spawn()
                .health_points,
            1000
        );
        assert_eq!(i.find_actor(bell).unwrap().position(), ground);
    }
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_pct_motif_dispatch_starry_object_and_party_buff() {
    let mut f = Fixture::new(42);
    f.act(34689);
    f.act(34691);
    if let NetworkedActor::Player { combat_state, .. } =
        f.world.lock().instances[0].find_actor_mut(f.owner).unwrap()
    {
        combat_state.in_combat = true;
    }
    f.act(35349);
    {
        let w = f.world.lock();
        let i = &w.instances[0];
        for id in [f.owner, f.ally] {
            assert!(
                i.find_actor(id)
                    .unwrap()
                    .status_effects()
                    .unwrap()
                    .get(3685)
                    .is_some()
            );
        }
        assert!(
            i.find_actor(f.stranger)
                .unwrap()
                .status_effects()
                .unwrap()
                .get(3685)
                .is_none()
        );
        if let NetworkedActor::Player { combat_state, .. } = i.find_actor(f.owner).unwrap() {
            assert_eq!(combat_state.pictomancer.canvas, 1);
            assert!(
                i.find_actor(combat_state.pictomancer.field_object.unwrap())
                    .is_some()
            );
        }
    }
    assert!(f.packets().await.iter().any(
        |(_, p)| matches!(p,ServerZoneIpcData::ActionEffect8(a) if a.header.action_id==34675)
    ));
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_thin_air_and_freecure_prevent_actual_mp_deduction() {
    let f = Fixture::new(24);
    f.act(7430);
    f.act(37010);
    {
        let w = f.world.lock();
        let a = w.instances[0].find_actor(f.owner).unwrap();
        assert_eq!(a.get_common_spawn().resource_points, 10000);
        assert!(a.status_effects().unwrap().get(1217).is_none());
    }
    f.world.lock().instances[0]
        .find_actor_mut(f.owner)
        .unwrap()
        .status_effects_mut()
        .unwrap()
        .add_with_source(155, 0, 15.0, f.owner);
    f.act(135);
    {
        let w = f.world.lock();
        let a = w.instances[0].find_actor(f.owner).unwrap();
        assert_eq!(a.get_common_spawn().resource_points, 10000);
        assert!(a.status_effects().unwrap().get(155).is_none());
    }
    f.act(135);
    assert!(
        f.world.lock().instances[0]
            .find_actor(f.owner)
            .unwrap()
            .get_common_spawn()
            .resource_points
            < 10000
    );
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_caress_regen_starts_only_when_shield_breaks_and_esuna_targets_ally() {
    let f = Fixture::new(24);
    f.act(16536);
    f.act(37011);
    {
        let mut w = f.world.lock();
        let a = w.instances[0].find_actor_mut(f.ally).unwrap();
        let s = a.status_effects_mut().unwrap();
        assert!(s.get(3903).is_some());
        assert!(s.get(3904).is_none());
        s.absorb_damage(100000);
        super::pictomancer::on_barrier_break(&mut f.network.lock(), &mut w.instances[0], f.ally);
        let s = w.instances[0]
            .find_actor(f.ally)
            .unwrap()
            .status_effects()
            .unwrap();
        assert!(s.get(3903).is_none());
        assert!(s.get(3904).is_some());
    }
    assert!(f.game.lock().status_sheet.row(18).unwrap().CanDispel);
    for id in [f.owner, f.ally] {
        f.world.lock().instances[0]
            .find_actor_mut(id)
            .unwrap()
            .status_effects_mut()
            .unwrap()
            .add_with_source(18, 0, 30.0, f.stranger);
    }
    f.act_on(7568, f.ally);
    let w = f.world.lock();
    let i = &w.instances[0];
    assert!(
        i.find_actor(f.ally)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(18)
            .is_none()
    );
    assert!(
        i.find_actor(f.owner)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(18)
            .is_some()
    );
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_swiftcast_trait_and_pct_charges_follow_level() {
    for (level, seconds) in [(93, 60), (94, 40)] {
        let f = Fixture::new(42);
        if let NetworkedActor::Player {
            spawn,
            remove_cooldowns,
            ..
        } = f.world.lock().instances[0].find_actor_mut(f.owner).unwrap()
        {
            spawn.common.level = level;
            *remove_cooldowns = false;
        }
        {
            let mut w = f.world.lock();
            let a = w.instances[0].find_actor_mut(f.owner).unwrap();
            let _ = crate::server::action::start_action_cooldowns(a, &mut f.game.lock(), 7561);
            if let NetworkedActor::Player { combat_state, .. } = a {
                assert!(
                    combat_state
                        .cooldowns
                        .iter()
                        .flatten()
                        .any(|c| c.action_id == 7561
                            && c.charge_duration == std::time::Duration::from_secs(seconds)),
                    "等级 {level} 的即刻咏唱冷却错误"
                );
            }
        }
        let g = &mut *f.game.lock();
        assert_eq!(g.get_action_max_charges_at_level(34670, 95), 2);
        assert_eq!(g.get_action_max_charges_at_level(34670, 96), 3);
        assert_eq!(g.get_action_max_charges_at_level(34674, 85), 1);
        assert_eq!(g.get_action_max_charges_at_level(34674, 86), 2);
        for id in [34664, 34668, 34669, 34674, 34678, 34683] {
            assert_eq!(g.get_action_mp_cost(id), 0, "动作 {id} 不应扣魔力");
        }
    }
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_lightspeed_request_path_preserves_long_cast_and_removes_short_cast() {
    let mut f = Fixture::new(33);
    f.act(3606);
    let _ = f.packets().await;
    for action in [3594, 3603] {
        // 复活读条必须有合法的死亡目标，不能以存活的施术者绕过校验。
        let target = if action == 3603 {
            let mut w = f.world.lock();
            let common = w.instances[0].find_actor_mut(f.ally).unwrap().get_common_spawn_mut();
            common.health_points = 0;
            common.mode = kawari::common::CharacterMode::Dead;
            f.ally
        } else { f.owner };
        let base = u32::from(f.game.lock().get_casttime(action).unwrap()) * 10;
        let expected = if let NetworkedActor::Player { parameters, .. } =
            f.world.lock().instances[0].find_actor(f.owner).unwrap()
        {
            parameters.apply_speed(base).saturating_sub(250) as f32 / 100.0
        } else {
            unreachable!()
        };
        let request = ActionRequest {
            action_id: action,
            action_type: ActionType::Action,
            target: ObjectTypeId {
                object_id: target,
                ..Default::default()
            },
            ..Default::default()
        };
        crate::server::action::handle_action_messages(
            f.world.clone(),
            f.game.clone(),
            f.network.clone(),
            f.lua.clone(),
            &crate::ToServer::ActionRequest(ClientId::default(), f.owner, request),
        );
        let packets = f.packets().await;
        let cast = packets.iter().find_map(|(_, p)| match p {
            ServerZoneIpcData::ActorCast {
                action_id,
                cast_time,
                ..
            } if *action_id == action => Some(*cast_time),
            _ => None,
        });
        if action == 3594 {
            assert_eq!(expected, 0.0);
            assert!(cast.is_none());
        } else {
            assert!(expected > 5.0);
            assert_eq!(cast, Some(expected));
        }
    }
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_temperance_snapshots_spell_regen_and_caress_expires_into_regen() {
    let f = Fixture::new(24);
    f.act(16536);
    f.act(137);
    {
        let w = f.world.lock();
        let a = w.instances[0].find_actor(f.owner).unwrap();
        assert_eq!(
            super::white_mage::outgoing_heal_multiplier(Some(a), 137),
            1.2
        );
        for id in [3569, 3570, 3571, 25864, 37011] {
            assert_eq!(
                super::white_mage::outgoing_heal_multiplier(Some(a), id),
                1.0
            );
        }
        let ticks: Vec<_> = a
            .status_effects()
            .unwrap()
            .tick_effects(std::time::Instant::now())
            .collect();
        assert!(
            ticks
                .iter()
                .any(|t| t.effect_id == 158 && t.healing_multiplier == 1.2)
        );
    }
    f.act(37011);
    {
        let mut w = f.world.lock();
        crate::server::effect::expire_effects(
            &f.network,
            &mut w.instances[0],
            std::time::Instant::now() + std::time::Duration::from_secs(11),
        );
        let s = w.instances[0]
            .find_actor(f.ally)
            .unwrap()
            .status_effects()
            .unwrap();
        assert!(s.get(3903).is_none());
        assert!(s.get(3904).is_some());
    }
}

#[tokio::test]
#[ignore = "需要当前国服客户端 SqPack"]
async fn cn_holy_and_assize_use_caster_center_without_hurting_party() {
    let mut f = Fixture::new(24);
    let enemies = [
        ObjectId(0x40000001),
        ObjectId(0x40000002),
        ObjectId(0x40000003),
    ];
    {
        let mut w = f.world.lock();
        for (id, x) in enemies.into_iter().zip([2.0, 6.0, 40.0]) {
            let mut spawn = kawari::ipc::zone::SpawnNpc::default();
            spawn.common.health_points = 100000;
            spawn.common.max_health_points = 100000;
            spawn.common.position = kawari::common::Position(glam::Vec3::new(x, 0.0, 0.0));
            w.instances[0].insert_npc(id, spawn);
        }
    }
    f.act_on(25860, f.ally);
    {
        let w = f.world.lock();
        let i = &w.instances[0];
        for id in [f.owner, f.ally, f.stranger] {
            let a = i.find_actor(id).unwrap();
            assert_eq!(a.get_common_spawn().health_points, 1000);
            assert!(a.status_effects().unwrap().get(2).is_none());
        }
        for id in &enemies[..2] {
            let a = i.find_actor(*id).unwrap();
            assert!(a.get_common_spawn().health_points < 100000);
            assert!(a.status_effects().unwrap().get(2).is_some());
        }
        assert_eq!(
            i.find_actor(enemies[2])
                .unwrap()
                .get_common_spawn()
                .health_points,
            100000
        );
    }
    let _ = f.packets().await;
    f.act_on(3571, enemies[2]);
    let w = f.world.lock();
    let i = &w.instances[0];
    for id in [f.owner, f.ally] {
        assert!(i.find_actor(id).unwrap().get_common_spawn().health_points > 1000);
    }
    assert_eq!(
        i.find_actor(f.stranger)
            .unwrap()
            .get_common_spawn()
            .health_points,
        1000
    );
    assert_eq!(
        i.find_actor(enemies[2])
            .unwrap()
            .get_common_spawn()
            .health_points,
        100000
    );
    drop(w);
    let _ = f.packets().await;
    {
        let mut w = f.world.lock();
        for n in 0..35 {
            let mut spawn = kawari::ipc::zone::SpawnNpc::default();
            spawn.common.health_points = 100000;
            spawn.common.max_health_points = 100000;
            w.instances[0].insert_npc(ObjectId(0x40001000 + n), spawn);
        }
    }
    f.act(3571);
    assert!(f.packets().await.iter().any(|(_,p)|matches!(p,ServerZoneIpcData::ActionEffect32(a) if a.header.action_id==3571 && a.header.target_count==32)),"大量敌人时仍须给队伍治疗保留结果槽位");
}
