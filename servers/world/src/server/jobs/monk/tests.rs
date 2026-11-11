use super::*;
use crate::server::action::action_damage_modifiers;
use kawari::{common::Position, ipc::zone::SpawnNpc};
fn fixture() -> (Instance, NetworkState, ObjectId, ObjectId) {
    let mut i = Instance::default();
    let o = ObjectId(0x10000001);
    let e = ObjectId(0x40000001);
    i.insert_empty_actor(o);
    let a = i.find_actor_mut(o).unwrap();
    let c = a.get_common_spawn_mut();
    c.class_job = 20;
    c.level = 100;
    c.health_points = 10000;
    c.max_health_points = 10000;
    if let NetworkedActor::Player { parameters, .. } = a {
        parameters.classjob_id = 20;
        parameters.level = 100;
        parameters.strength = 1000;
        parameters.physical_damage = 100;
    }
    let mut spawn = SpawnNpc::default();
    spawn.common.health_points = 1000000;
    spawn.common.max_health_points = 1000000;
    spawn.common.owner_id = ObjectId(0xE0000000);
    spawn.common.position = Position(glam::Vec3::new(0.0, 0.0, 2.0));
    i.insert_npc(e, spawn);
    (i, NetworkState::default(), o, e)
}
fn attack(i: &mut Instance, n: &mut NetworkState, o: ObjectId, e: ObjectId, id: u32) {
    let a = i.find_actor(o).unwrap();
    let s = a.status_effects().cloned().unwrap_or_default();
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
fn monk_masterful_blitz_requires_complete_chakra_and_selects_each_nadi_route() {
    let mut s = MonkState::default();
    s.blitz_until = until(20);
    s.beast = [1, 1, 0];
    assert_eq!(s.masterful(100), 25764);
    s.beast = [1; 3];
    assert_eq!(s.masterful(91), 3545);
    assert_eq!(s.masterful(92), 36948);
    s.beast = [1, 2, 3];
    assert_eq!(s.masterful(85), 25882);
    assert_eq!(s.masterful(86), 25768);
    s.beast = [1, 1, 2];
    assert_eq!(s.masterful(100), 25765);
    s.nadi = 3;
    assert_eq!(s.masterful(89), 3543);
    assert_eq!(s.masterful(90), 25769);
    s.blitz_until = Some(Instant::now() - Duration::from_secs(1));
    assert_eq!(s.masterful(100), 25764);
}
#[test]
fn monk_form_and_fury_are_consumed_only_by_corresponding_weapons() {
    let (mut i, mut n, o, e) = fixture();
    attack(&mut i, &mut n, o, e, 74);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert_eq!(combat_state.monk.fury, [0, 0, 0]);
        assert_eq!(combat_state.monk.form, 2);
        assert!(Monk.can_execute(61, combat_state, 100));
        assert!(!Monk.can_execute(66, combat_state, 100));
    }
    attack(&mut i, &mut n, o, e, 61);
    attack(&mut i, &mut n, o, e, 66);
    attack(&mut i, &mut n, o, e, 74);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert_eq!(combat_state.monk.fury, [1, 1, 2]);
    }
    attack(&mut i, &mut n, o, e, 36946);
    attack(&mut i, &mut n, o, e, 36947);
    attack(&mut i, &mut n, o, e, 36945);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert_eq!(combat_state.monk.fury, [0, 0, 1]);
    }
}
#[test]
fn monk_chakra_cap_and_party_contribution_respect_source() {
    let (mut i, mut n, o, e) = fixture();
    if let Some(NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    }) = i.find_actor_mut(o)
    {
        combat_state.monk.chakra = 5;
        combat_state.monk.brotherhood_until = until(20);
        status_effects.add_with_source(1182, 100, 20.0, o);
    }
    effects::notify_action(&mut n, &mut i, o, 36945, 3, true, true);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert_eq!(combat_state.monk.chakra, 7);
    }
    effects::notify_action(&mut n, &mut i, o, 3547, 4, true, true);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert_eq!(combat_state.monk.chakra, 7);
    }
    attack(&mut i, &mut n, o, e, 16476);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert_eq!(combat_state.monk.chakra, 0);
    }
}
#[test]
fn monk_positional_and_haste_have_explicit_boundaries() {
    let (mut i, _, o, e) = fixture();
    i.find_actor_mut(o).unwrap().get_common_spawn_mut().position =
        Position(glam::Vec3::new(0.0, 0.0, 0.0));
    assert!(effects::positional(
        i.find_actor(o).unwrap(),
        i.find_actor(e).unwrap(),
        true
    ));
    assert!(!effects::positional(
        i.find_actor(o).unwrap(),
        i.find_actor(e).unwrap(),
        false
    ));
    for (l, p) in [(1, 95), (20, 90), (40, 85), (76, 80)] {
        assert_eq!(haste(l), p);
    }
    let s = MonkState {
        chakra: 7,
        beast: [1, 2, 3],
        fury: [1, 1, 2],
        nadi: 3,
        ..Default::default()
    };
    assert_eq!(s.pack(100).to_le_bytes(), [7, 1, 2, 3, 37, 3, 0, 0]);
}
