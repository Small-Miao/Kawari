use super::*;
use crate::server::{action::action_damage_modifiers, action::area::AreaResult};
use kawari::ipc::zone::{SpawnNpc, TargetEffectKind};
fn fixture() -> (Instance, NetworkState, ObjectId, ObjectId) {
    let mut i = Instance::default();
    let o = ObjectId(0x10000001);
    let e = ObjectId(0x40000001);
    i.insert_empty_actor(o);
    let a = i.find_actor_mut(o).unwrap();
    let c = a.get_common_spawn_mut();
    c.class_job = 34;
    c.level = 100;
    c.health_points = 10000;
    c.max_health_points = 10000;
    if let NetworkedActor::Player {
        parameters,
        combat_state,
        ..
    } = a
    {
        parameters.classjob_id = 34;
        parameters.level = 100;
        parameters.strength = 1000;
        parameters.physical_damage = 100;
        combat_state.in_combat = true;
    }
    let mut s = SpawnNpc::default();
    s.common.health_points = 1000000;
    s.common.max_health_points = 1000000;
    s.common.owner_id = ObjectId(0xE0000000);
    s.common.position = Position(glam::Vec3::new(0.0, 0.0, 2.0));
    i.insert_npc(e, s);
    (i, NetworkState::default(), o, e)
}
fn attack(
    i: &mut Instance,
    n: &mut NetworkState,
    o: ObjectId,
    e: ObjectId,
    id: u32,
    combo: bool,
) -> AreaResult {
    let a = i.find_actor(o).unwrap();
    let s = a.status_effects().cloned().unwrap();
    let mods = action_damage_modifiers(Some(a));
    effects::apply(
        n,
        i,
        JobAreaContext {
            caster: o,
            target: e,
            action: id,
            combo,
            ground: None,
            statuses: &s,
            effects: &[],
            modifiers: mods,
        },
    )
    .unwrap()
}
#[test]
fn samurai_sen_tendo_and_tsubame_have_independent_lifetimes() {
    let (mut i, mut n, o, e) = fixture();
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
        combat_state.samurai.tendo_until = until(30);
    }
    for id in [7480, 7481, 7482] {
        attack(&mut i, &mut n, o, e, id, true);
    }
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert_eq!(combat_state.samurai.sen, 7);
        assert_eq!(combat_state.samurai.iai(), 36966);
    }
    attack(&mut i, &mut n, o, e, 36966, false);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        let s = &combat_state.samurai;
        assert_eq!(s.sen, 0);
        assert_eq!(s.meditation, 1);
        assert_eq!(s.resolve(16483, 100), 36968);
        assert_eq!(&s.pack().to_le_bytes()[..3],&[0,0,0]);
        assert!(!active(s.tendo_until));
    }
    // 普通连击不能取消独立的燕回返预备。
    attack(&mut i, &mut n, o, e, 36963, false);
    attack(&mut i, &mut n, o, e, 36968, false);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert_eq!(combat_state.samurai.repeat, 0);
        assert_eq!(combat_state.samurai.meditation, 1);
        assert!(!Samurai.can_execute(36968, combat_state, 100));
    }
}

#[test]
fn samurai_ogi_has_recorded_30_second_gauge_separate_from_tsubame(){
    let(mut i,mut n,o,e)=fixture();attack(&mut i,&mut n,o,e,25781,false);
    if let Some(NetworkedActor::Player{combat_state,..})=i.find_actor_mut(o){let b=combat_state.samurai.pack().to_le_bytes();assert_eq!(b[2],4);assert!(u16::from_le_bytes([b[0],b[1]])>=29900);combat_state.samurai.ogi_repeat_until=Some(Instant::now()-Duration::from_secs(1));assert!(!Samurai.can_execute(25782,combat_state,100));}
}
#[test]
fn samurai_buff_packets_match_signed_bonus_and_sen_effect() {
    let (mut i, mut n, o, e) = fixture();
    let r = attack(&mut i, &mut n, o, e, 7479, true);
    assert!(r.targets.iter().flat_map(|(_, es)| es).any(|x| matches!(
        x.0,
        TargetEffectKind::GainEffectSelf {
            effect_id: 1299,
            unk1: 243,
            param: 0,
            ..
        }
    )));
    assert_eq!(
        i.find_actor(o)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(1299)
            .unwrap()
            .param,
        0
    );
    assert_eq!(speed(i.find_actor(o).unwrap()), 87);
    let r = attack(&mut i, &mut n, o, e, 7482, true);
    assert!(r.targets.iter().flat_map(|(_, es)| es).any(|x| matches!(
        x.0,
        TargetEffectKind::Unknown {
            magic: 62,
            param0: 4,
            value: 184,
            ..
        }
    )));
}
#[test]
fn samurai_meditation_stops_on_movement_and_cast_request() {
    let (mut i, mut n, o, e) = fixture();
    attack(&mut i, &mut n, o, e, 7497, false);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
        combat_state.samurai.meditate.as_mut().unwrap().3 = Instant::now() - Duration::from_secs(6);
    }
    effects::tick(&mut n, &mut i, o);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert_eq!(combat_state.samurai.kenki, 30);
        assert_eq!(combat_state.samurai.meditation, 3);
    }
    i.find_actor_mut(o)
        .unwrap()
        .get_common_spawn_mut()
        .position
        .0
        .x += 1.0;
    effects::tick(&mut n, &mut i, o);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert!(combat_state.samurai.meditate.is_none());
    }
    attack(&mut i, &mut n, o, e, 7497, false);
    Samurai.on_action_requested(7489, i.find_actor_mut(o).unwrap());
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert!(combat_state.samurai.meditate.is_none());
    }
}
#[test]
fn samurai_tengentsu_triggers_once_and_kenki_gates_actions() {
    let (mut i, mut n, o, _) = fixture();
    let a = i.find_actor_mut(o).unwrap();
    a.status_effects_mut()
        .unwrap()
        .add_with_source(3853, 10, 4.0, o);
    assert_eq!(mitigation(a), 0.9);
    on_damage(a);
    on_damage(a);
    effects::tick(&mut n, &mut i, o);
    let a = i.find_actor(o).unwrap();
    assert!(a.status_effects().unwrap().get(3853).is_none());
    assert!(a.status_effects().unwrap().get(3854).is_some());
    if let NetworkedActor::Player { combat_state, .. } = a {
        assert_eq!(combat_state.samurai.kenki, 10);
        assert!(!Samurai.can_execute(7490, combat_state, 100));
        assert!(Samurai.can_execute(7492, combat_state, 100));
    }
}
