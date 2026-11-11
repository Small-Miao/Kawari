use super::*;
use crate::server::action::{action_damage_modifiers, area::AreaResult};
use kawari::ipc::zone::SpawnNpc;
fn fixture() -> (Instance, NetworkState, ObjectId, ObjectId) {
    let mut i = Instance::default();
    let o = ObjectId(0x10000001);
    let e = ObjectId(0x40000001);
    i.insert_empty_actor(o);
    let a = i.find_actor_mut(o).unwrap();
    let c = a.get_common_spawn_mut();
    c.class_job = 39;
    c.level = 100;
    c.health_points = 10000;
    c.max_health_points = 10000;
    if let NetworkedActor::Player {
        parameters,
        combat_state,
        ..
    } = a
    {
        parameters.classjob_id = 39;
        parameters.level = 100;
        parameters.strength = 1000;
        parameters.physical_damage = 100;
        parameters.magic_damage = 100;
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
fn reaper_zone_change_discards_portal_and_marks_not_resources() {
    let (mut i, mut n, o, e) = fixture();
    act(&mut i, &mut n, o, e, 24402, false);
    Reaper.spawn_pet_after_action(&mut n, &mut i, o, 24402, o);
    let object = if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
        combat_state.reaper.soul = 80;
        combat_state
            .reaper
            .marks
            .insert(e, Instant::now() + Duration::from_secs(30));
        combat_state.reaper.gate.unwrap().0
    } else {
        panic!()
    };
    let carried =
        crate::server::zone::take_combat_state_and_despawn_pets(&mut i, &mut n, o).unwrap();
    assert!(i.find_actor(object).is_none());
    assert!(carried.reaper.gate.is_none());
    assert!(carried.reaper.marks.is_empty());
    assert_eq!(carried.reaper.soul, 80);
}

#[test]
fn reaper_two_circles_grant_each_owner_one_contribution() {
    let (mut i, mut n, o, _) = fixture();
    let other = ObjectId(0x10000002);
    i.insert_empty_actor(other);
    let a = i.find_actor_mut(other).unwrap();
    a.get_common_spawn_mut().class_job = 39;
    a.get_common_spawn_mut().health_points = 1000;
    effects::grant(a, other, 2972, 0, 6);
    effects::grant(i.find_actor_mut(o).unwrap(), o, 2972, 0, 6);
    let s = i.find_actor_mut(o).unwrap().status_effects_mut().unwrap();
    s.add_with_source(2600, 0, 5.0, o);
    s.add_with_source(2600, 0, 5.0, other);
    notify_action(&mut n, &mut i, o, 3, true);
    notify_action(&mut n, &mut i, o, 3, true);
    for id in [o, other] {
        let NetworkedActor::Player { combat_state, .. } = i.find_actor(id).unwrap() else {
            panic!()
        };
        assert_eq!(combat_state.reaper.sacrifice, 1);
    }
}
fn act(
    i: &mut Instance,
    n: &mut NetworkState,
    o: ObjectId,
    e: ObjectId,
    id: u32,
    combo: bool,
) -> AreaResult {
    let a = i.find_actor(o).unwrap();
    let statuses = a.status_effects().unwrap().clone();
    let modifiers = action_damage_modifiers(Some(a));
    effects::apply(
        n,
        i,
        JobAreaContext {
            caster: o,
            target: e,
            action: id,
            combo,
            ground: None,
            statuses: &statuses,
            effects: &[],
            modifiers,
        },
    )
    .unwrap()
}
#[test]
fn reaper_supplement_free_enshroud_preserves_twenty_shroud() {
    let (mut i, mut n, o, e) = fixture();
    for id in [24380, 24393, 36970, 36971] {
        act(&mut i, &mut n, o, e, id, false);
    }
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
        combat_state.reaper.sacrifice = 1;
    }
    effects::grant(i.find_actor_mut(o).unwrap(), o, 2592, 1, 30);
    act(&mut i, &mut n, o, e, 24385, false);
    act(&mut i, &mut n, o, e, 24394, false);
    if let NetworkedActor::Player { combat_state, .. } = i.find_actor(o).unwrap() {
        let b = combat_state.reaper.pack().to_le_bytes();
        assert_eq!(b[..2], [0, 20]);
        assert_eq!(b[4..6], [5, 0]);
        assert!(u16::from_le_bytes([b[2], b[3]]) >= 29900);
    }
    for id in [36969, 24395, 24396, 24399, 24395, 24396, 24399, 24398] {
        act(&mut i, &mut n, o, e, id, false);
    }
    if let NetworkedActor::Player { combat_state, .. } = i.find_actor(o).unwrap() {
        assert_eq!(
            combat_state.reaper.pack().to_le_bytes()[..6],
            [0, 20, 0, 0, 0, 0]
        );
        assert!(Reaper.can_execute(36973, combat_state, 100));
    }
    act(&mut i, &mut n, o, e, 36973, false);
    assert!(
        i.find_actor(o)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(3860)
            .is_none()
    );
}
#[test]
fn reaper_other_weapons_cancel_execution_and_wrong_resources_reject() {
    let (mut i, mut n, o, e) = fixture();
    act(&mut i, &mut n, o, e, 24380, false);
    act(&mut i, &mut n, o, e, 24393, false);
    act(&mut i, &mut n, o, e, 24373, false);
    if let NetworkedActor::Player { combat_state, .. } = i.find_actor(o).unwrap() {
        assert!(!Reaper.can_execute(36970, combat_state, 100));
        assert!(!Reaper.can_execute(24394, combat_state, 100));
        assert!(!Reaper.can_execute(24399, combat_state, 100));
    }
}
#[test]
fn reaper_circle_accepts_one_contribution_per_actor_including_ability() {
    let (mut i, mut n, o, e) = fixture();
    act(&mut i, &mut n, o, e, 24405, false);
    notify_action(&mut n, &mut i, o, 4, true);
    notify_action(&mut n, &mut i, o, 3, true);
    if let NetworkedActor::Player { combat_state, .. } = i.find_actor(o).unwrap() {
        assert_eq!(combat_state.reaper.sacrifice, 1);
        assert!(!Reaper.can_execute(24385, combat_state, 100));
    }
    assert!(
        i.find_actor(o)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(2600)
            .is_none()
    );
}
#[test]
fn reaper_gate_is_fixed_and_removed_after_regress() {
    let (mut i, mut n, o, e) = fixture();
    act(&mut i, &mut n, o, e, 24402, false);
    Reaper.spawn_pet_after_action(&mut n, &mut i, o, 24402, o);
    let (gate, origin) =
        if let NetworkedActor::Player { combat_state, .. } = i.find_actor(o).unwrap() {
            let g = combat_state.reaper.gate.unwrap();
            (g.0, g.1)
        } else {
            panic!()
        };
    i.find_actor_mut(o).unwrap().get_common_spawn_mut().position =
        Position(glam::Vec3::new(0.0, 0.0, -15.0));
    let r = act(&mut i, &mut n, o, e, 24403, false);
    assert_eq!(r.center, origin);
    assert!(i.find_actor(gate).is_some());
    Reaper.spawn_pet_after_action(&mut n, &mut i, o, 24403, o);
    assert!(i.find_actor(gate).is_none());
}
#[test]
fn reaper_crest_requires_absorption_and_death_reward_only_once() {
    let (mut i, mut n, o, e) = fixture();
    act(&mut i, &mut n, o, e, 24404, false);
    i.find_actor_mut(o)
        .unwrap()
        .status_effects_mut()
        .unwrap()
        .remove(2597);
    super::super::pictomancer::on_barrier_break(&mut n, &mut i, o);
    assert!(
        i.find_actor(o)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(2598)
            .is_none()
    );
    act(&mut i, &mut n, o, e, 24404, false);
    i.find_actor_mut(o).unwrap().apply_damage(1000);
    super::super::pictomancer::on_barrier_break(&mut n, &mut i, o);
    assert!(
        i.find_actor(o)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(2598)
            .is_some()
    );
    act(&mut i, &mut n, o, e, 24378, false);
    let mut mods = action_damage_modifiers(i.find_actor(o));
    mods.source_actor_id = Some(o);
    assert_eq!(
        mods.against_target(i.find_actor(e)).apply_base_damage(1000),
        1100
    );
    i.find_actor_mut(e).unwrap().apply_damage(u32::MAX);
    Reaper.on_tick(&mut n, &mut i, o);
    Reaper.on_tick(&mut n, &mut i, o);
    if let NetworkedActor::Player { combat_state, .. } = i.find_actor(o).unwrap() {
        assert_eq!(combat_state.reaper.soul, 10);
    }
}
