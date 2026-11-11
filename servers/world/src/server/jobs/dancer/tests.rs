use super::*;
use crate::server::action::action_damage_modifiers;
use kawari::ipc::zone::SpawnNpc;
fn fixture() -> (Instance, NetworkState, ObjectId, ObjectId) {
    let mut i = Instance::default();
    let o = ObjectId(0x10000001);
    let e = ObjectId(0x40000001);
    i.insert_empty_actor(o);
    let a = i.find_actor_mut(o).unwrap();
    let c = a.get_common_spawn_mut();
    c.class_job = 38;
    c.level = 100;
    c.health_points = 10000;
    c.max_health_points = 10000;
    if let NetworkedActor::Player {
        parameters,
        combat_state,
        ..
    } = a
    {
        parameters.classjob_id = 38;
        parameters.level = 100;
        parameters.dexterity = 1000;
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

#[test]
fn dancer_improvisation_zone_change_clears_object_without_losing_esprit() {
    let (mut i, mut n, o, e) = fixture();
    act(&mut i, &mut n, o, e, 16014);
    Dancer.spawn_pet_after_action(&mut n, &mut i, o, 16014, o);
    let object = if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
        combat_state.dancer.esprit = 60;
        combat_state.dancer.improvisation_object.unwrap()
    } else {
        panic!()
    };
    let carried =
        crate::server::zone::take_combat_state_and_despawn_pets(&mut i, &mut n, o).unwrap();
    assert!(i.find_actor(object).is_none());
    assert!(carried.dancer.improvisation.is_none());
    assert_eq!(carried.dancer.esprit, 60);
}
fn act(i: &mut Instance, n: &mut NetworkState, o: ObjectId, e: ObjectId, id: u32) {
    let a = i.find_actor(o).unwrap();
    let s = a.status_effects().cloned().unwrap();
    let m = action_damage_modifiers(Some(a));
    effects::apply(
        n,
        i,
        JobAreaContext {
            caster: o,
            target: e,
            action: id,
            combo: false,
            ground: None,
            statuses: &s,
            effects: &[],
            modifiers: m,
        },
    )
    .unwrap();
}
#[test]
fn dancer_wrong_steps_do_not_advance_and_finish_requires_active_dance() {
    let (mut i, mut n, o, e) = fixture();
    act(&mut i, &mut n, o, e, 15997);
    let steps = if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert!(!Dancer.can_execute(16013, combat_state, 100));
        combat_state.dancer.steps
    } else {
        panic!()
    };
    assert_ne!(steps[0], steps[1]);
    assert_eq!(&steps[2..], &[0, 0]);
    act(&mut i, &mut n, o, e, 15998 + u32::from(steps[1]));
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert_eq!(combat_state.dancer.index, 0);
        assert_eq!(combat_state.dancer.finish(), 16003);
    }
    for step in &steps[..2] {
        act(&mut i, &mut n, o, e, 15998 + u32::from(*step));
    }
    act(&mut i, &mut n, o, e, 16192);
    let a = i.find_actor(o).unwrap();
    let s = a.status_effects().unwrap();
    assert_eq!(s.get(1821).unwrap().param, 0);
    assert_eq!(s.magnitude(1821), Some(5));
    assert!(s.get(3867).is_some());
    if let NetworkedActor::Player { combat_state, .. } = a {
        assert_eq!(combat_state.dancer.steps, [0; 4]);
        assert!(!Dancer.can_execute(16192, combat_state, 100));
    }
}
#[test]
fn dancer_normal_proc_is_consumed_before_flourish_and_gauges_are_bounded() {
    let (mut i, mut n, o, e) = fixture();
    act(&mut i, &mut n, o, e, 16013);
    if let Some(NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    }) = i.find_actor_mut(o)
    {
        combat_state
            .dancer
            .ready
            .insert(2693, Instant::now() + Duration::from_secs(30));
        combat_state.dancer.esprit = 95;
        combat_state.dancer.feathers = 4;
        status_effects.add_with_source(2693, 0, 30.0, o);
        status_effects.add_with_source(1847, 0, 60.0, o);
    }
    act(&mut i, &mut n, o, e, 15991);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert!(!combat_state.dancer.has(2693));
        assert!(combat_state.dancer.has(3017));
        assert_eq!(combat_state.dancer.feathers, 4);
        assert_eq!(combat_state.dancer.esprit, 100);
    }
    act(&mut i, &mut n, o, e, 15995);
    act(&mut i, &mut n, o, e, 16005);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert!(!combat_state.dancer.has(3017));
        assert_eq!(combat_state.dancer.esprit, 50);
    }
}
#[test]
fn dancer_improvisation_channels_and_barrier_uses_target_max_hp() {
    let (mut i, mut n, o, e) = fixture();
    act(&mut i, &mut n, o, e, 16014);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
        combat_state.dancer.improvisation.as_mut().unwrap().3 =
            Instant::now() - Duration::from_secs(9);
    }
    effects::tick(&mut n, &mut i, o);
    act(&mut i, &mut n, o, e, 25789);
    let s = i.find_actor(o).unwrap().status_effects().unwrap();
    assert_eq!(s.barrier_remaining(2697), 1000);
    assert!(s.get(2695).is_some());
    assert!(s.get(1827).is_none());
    act(&mut i, &mut n, o, e, 16014);
    i.find_actor_mut(o).unwrap().get_common_spawn_mut().rotation += 0.1;
    effects::tick(&mut n, &mut i, o);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert!(!Dancer.can_execute(25789, combat_state, 100));
    }
}
#[test]
fn dancer_technical_buff_uses_separate_delayed_action() {
    let (mut i, mut n, o, e) = fixture();
    act(&mut i, &mut n, o, e, 15998);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
        combat_state.dancer.index = 4;
    }
    act(&mut i, &mut n, o, e, 16196);
    assert!(
        i.find_actor(o)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(1822)
            .is_none()
    );
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
        combat_state.dancer.technical.as_mut().unwrap().0 = Instant::now();
    }
    effects::tick(&mut n, &mut i, o);
    let s = i.find_actor(o).unwrap().status_effects().unwrap();
    assert_eq!(s.magnitude(1822), Some(5));
    assert!(s.get(1848).is_some());
    let m = action_damage_modifiers(i.find_actor(o));
    assert_eq!(m.apply_base_damage(1000), 1050);
    let s = DancerState {
        feathers: 3,
        esprit: 50,
        steps: [4, 3, 2, 1],
        index: 2,
        ..Default::default()
    };
    assert_eq!(s.pack().to_le_bytes(), [3, 50, 4, 3, 2, 1, 2, 0]);
}
