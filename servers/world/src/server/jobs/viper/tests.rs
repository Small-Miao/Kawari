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
    c.class_job = 41;
    c.level = 100;
    c.health_points = 10000;
    c.max_health_points = 10000;
    if let NetworkedActor::Player {
        parameters,
        combat_state,
        ..
    } = a
    {
        parameters.classjob_id = 41;
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
fn state(i: &Instance, o: ObjectId) -> &ViperState {
    let NetworkedActor::Player { combat_state, .. } = i.find_actor(o).unwrap() else {
        panic!()
    };
    &combat_state.viper
}
#[test]
fn viper_follow_extension_matches_first_person_recording() {
    let (mut i, mut n, o, e) = fixture();
    act(&mut i, &mut n, o, e, 34620);
    act(&mut i, &mut n, o, e, 34647);
    act(&mut i, &mut n, o, e, 34621);
    assert_eq!(&state(&i, o).pack().to_le_bytes()[..4], &[2, 0, 5, 2]);
    assert_eq!(state(&i, o).extra()[0], 0x1e);
    act(&mut i, &mut n, o, e, 34636);
    assert_eq!(state(&i, o).extra()[0], 0x1d);
    act(&mut i, &mut n, o, e, 34637);
    assert_eq!(state(&i, o).extra()[0], 0);
    act(&mut i, &mut n, o, e, 34622);
    assert_eq!(
        &state(&i, o).pack().to_le_bytes()[..6],
        &[2, 0, 10, 0, 0, 0]
    );
    act(&mut i, &mut n, o, e, 34633);
    assert_eq!(state(&i, o).extra()[0], 0x26);
    act(&mut i, &mut n, o, e, 34644);
    assert_eq!(state(&i, o).extra()[0], 0x25);
    act(&mut i, &mut n, o, e, 34645);
    assert_eq!(state(&i, o).extra()[0], 0);
}
#[test]
fn viper_reawaken_retains_normal_combo_and_follows_recorded_gauge_chain() {
    let (mut i, mut n, o, e) = fixture();
    act(&mut i, &mut n, o, e, 34607);
    act(&mut i, &mut n, o, e, 34609);
    act(&mut i, &mut n, o, e, 34647);
    act(&mut i, &mut n, o, e, 34626);
    assert_eq!(state(&i, o).tribute, 5);
    assert_eq!(state(&i, o).dread, 7);
    for step in 0..4 {
        act(&mut i, &mut n, o, e, 34627 + step);
        assert_eq!(state(&i, o).tribute, 4 - step as u8);
        assert_eq!(state(&i,o).extra()[0],(((3+step)as u8)<<2)|1);
        act(&mut i, &mut n, o, e, 34640 + step);
    }
    act(&mut i, &mut n, o, e, 34631);
    assert_eq!(state(&i, o).tribute, 0);
    assert_eq!(state(&i, o).resolve(34607), 34613);
    assert!(
        i.find_actor(o)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(3670)
            .is_none()
    );
}
#[test]
fn viper_invalid_followups_and_same_coil_are_rejected() {
    let (mut i, mut n, o, e) = fixture();
    act(&mut i, &mut n, o, e, 34620);
    act(&mut i, &mut n, o, e, 34621);
    let NetworkedActor::Player { combat_state, .. } = i.find_actor(o).unwrap() else {
        panic!()
    };
    assert!(!Viper.can_execute(34621, combat_state, 100));
    assert!(Viper.can_execute(34622, combat_state, 100));
    assert!(!Viper.can_execute(34638, combat_state, 100));
    act(&mut i, &mut n, o, e, 34606);
    assert_eq!(state(&i, o).extra()[0], 0);
}
#[test]
fn viper_resources_are_per_cast_and_cap_at_recorded_limits() {
    let (mut i, mut n, o, e) = fixture();
    for _ in 0..5 {
        act(&mut i, &mut n, o, e, 34647);
    }
    assert_eq!(state(&i, o).coils, 3);
    for _ in 0..12 {
        act(&mut i, &mut n, o, e, 34619);
    }
    assert_eq!(state(&i, o).offering, 100);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
        combat_state.viper.ready_until = None;
    }
    act(&mut i, &mut n, o, e, 34626);
    assert_eq!(state(&i, o).offering, 50);
}
