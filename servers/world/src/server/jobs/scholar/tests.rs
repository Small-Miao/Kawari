use super::*;
use crate::server::action::ActionDamageModifiers;
use kawari::ipc::zone::DamageType;
fn player() -> (ObjectId, NetworkedActor) {
    let id = ObjectId(0x10000001);
    let mut i = Instance::default();
    i.insert_empty_actor(id);
    let mut a = i.actors.remove(&id).unwrap();
    let c = a.get_common_spawn_mut();
    c.class_job = 28;
    c.level = 100;
    c.health_points = 10000;
    c.max_health_points = 10000;
    (id, a)
}
#[test]
fn scholar_level_morphs_and_potency_match_local_traits() {
    let s = ScholarState::default();
    for (level, id, p) in [
        (53, 17869, 150),
        (54, 3584, 220),
        (64, 7435, 240),
        (72, 16541, 255),
        (82, 25865, 295),
        (94, 25865, 320),
    ] {
        assert_eq!(s.resolve(17869, level), id);
        assert_eq!(effects::potency(id, level), p);
    }
    assert_eq!(s.resolve(186, 95), 186);
    assert_eq!(s.resolve(186, 96), 37013);
}
#[test]
fn scholar_replay_dissipation_gauge_preserves_sixteen_bit_fairy_kind() {
    let s = ScholarState {
        aetherflow: 3,
        fairy_gauge: 30,
        fairy_kind: 2054,
        dissipated_until: deadline(30),
        ..Default::default()
    };
    assert_eq!(s.pack(100).to_le_bytes(), [3, 30, 0, 0, 6, 8, 0, 0]);
    let mut c = PlayerCombatState {
        scholar: s,
        in_combat: true,
        ..Default::default()
    };
    assert!(!Scholar.can_execute(17215, &c, 100));
    assert!(!Scholar.can_execute(16538, &c, 100));
    c.scholar.recitation_until = deadline(15);
    c.scholar.aetherflow = 0;
    assert!(Scholar.can_execute(7434, &c, 100));
    assert!(!Scholar.can_execute(189, &c, 100));
    c.scholar.seraphism_until = deadline(20);
    assert_eq!(c.scholar.resolve(185, 100), 37015);
    assert_eq!(c.scholar.resolve(3586, 100), 37037);
    assert!(Scholar.can_execute(37037,&c,100));
    let (_,a)=player();
    assert!(matches!(effects::build(37037,&a).unwrap().effects[0].0,kawari::ipc::zone::TargetEffectKind::GainEffectSelf{effect_id:792,..}));
    c.scholar.seraphism_until=None;
    assert!(!Scholar.can_execute(37037,&c,100));
    assert!(!recitable(37015), "显灵不是秘策列出的治疗魔法");
}
#[test]
fn scholar_stronger_shield_and_catalyze_are_independent() {
    let (id, mut a) = player();
    assert!(effects::shield(&mut a, 297, 2000, 30.0, id));
    assert!(effects::shield(&mut a, 1918, 2000, 30.0, id));
    assert!(!effects::shield(&mut a, 297, 1000, 30.0, id));
    a.apply_damage(2500);
    assert_eq!(a.get_common_spawn().health_points, 10000);
    assert_eq!(a.status_effects().unwrap().barrier_amount(), 1500);
    assert!(effects::shield(&mut a, 2609, 2500, 30.0, id));
    assert!(a.status_effects().unwrap().get(297).is_none());
    assert_eq!(a.status_effects().unwrap().barrier_remaining(1918), 1500);
    assert_eq!(a.status_effects().unwrap().barrier_remaining(2609), 2500);
}
#[test]
fn scholar_excogitation_triggers_once_on_other_job_and_never_revives() {
    let (owner, mut a) = player();
    a.get_common_spawn_mut().class_job = 19;
    a.status_effects_mut()
        .unwrap()
        .add_with_source(1220, 50, 45.0, owner);
    if let NetworkedActor::Player { combat_state, .. } = &mut a {
        combat_state.scholar.excogitation =
            Some((Instant::now() + Duration::from_secs(45), 2000, owner));
    }
    let mut i = Instance::default();
    i.actors.insert(owner, a);
    let mut n = NetworkState::default();
    i.find_actor_mut(owner).unwrap().apply_damage(5000);
    effects::tick_support(&mut n, &mut i, owner);
    assert_eq!(
        i.find_actor(owner)
            .unwrap()
            .get_common_spawn()
            .health_points,
        5000
    );
    i.find_actor_mut(owner).unwrap().apply_damage(1);
    effects::tick_support(&mut n, &mut i, owner);
    effects::tick_support(&mut n, &mut i, owner);
    assert_eq!(
        i.find_actor(owner)
            .unwrap()
            .get_common_spawn()
            .health_points,
        6999
    );
    let a = i.find_actor_mut(owner).unwrap();
    a.get_common_spawn_mut().health_points = 0;
    if let NetworkedActor::Player { combat_state, .. } = a {
        combat_state.scholar.excogitation =
            Some((Instant::now() - Duration::from_secs(1), 2000, owner));
    }
    effects::tick_support(&mut n, &mut i, owner);
    assert_eq!(
        i.find_actor(owner)
            .unwrap()
            .get_common_spawn()
            .health_points,
        0
    );
}
#[test]
fn scholar_chain_is_target_scoped_and_magic_mitigation_is_typed() {
    let (owner, mut a) = player();
    let (_, b) = player();
    a.status_effects_mut()
        .unwrap()
        .add_with_source(1221, 10, 20.0, owner);
    assert_eq!(
        ActionDamageModifiers::default()
            .against_target(Some(&a))
            .roll
            .crit_rate_bonus,
        0.1
    );
    assert_eq!(
        ActionDamageModifiers::default()
            .against_target(Some(&b))
            .roll
            .crit_rate_bonus,
        0.0
    );
    a.status_effects_mut()
        .unwrap()
        .add_with_source(317, 0, 20.0, owner);
    a.status_effects_mut()
        .unwrap()
        .add_with_source(299, 10, 15.0, owner);
    assert!((effects::mitigation(&a, DamageType::Magic) - 0.855).abs() < 1e-6);
    assert!((effects::mitigation(&a, DamageType::Physical) - 0.9).abs() < 1e-6);
}

#[test]
fn scholar_soil_stays_at_cast_position_and_zone_removes_old_field() {
    let (owner, a) = player();
    let mut i = Instance::default();
    i.actors.insert(owner, a);
    let mut n = NetworkState::default();
    let initial = Position(glam::Vec3::new(12.0, 0.0, 4.0));
    let statuses = StatusEffects::default();
    effects::apply(
        &mut n,
        &mut i,
        JobAreaContext {
            caster: owner,
            target: owner,
            action: 188,
            combo: false,
            ground: Some(initial),
            statuses: &statuses,
            effects: &[],
            modifiers: Default::default(),
        },
    );
    Scholar.spawn_pet_after_action(&mut n, &mut i, owner, 188, owner);
    let object = if let NetworkedActor::Player { combat_state, .. } = i.find_actor(owner).unwrap() {
        combat_state.scholar.soil_object.unwrap()
    } else {
        panic!()
    };
    i.find_actor_mut(owner)
        .unwrap()
        .get_common_spawn_mut()
        .position = Position(glam::Vec3::new(-20.0, 0.0, 0.0));
    Scholar.on_tick(&mut n, &mut i, owner);
    let NetworkedActor::Player { combat_state, .. } = i.find_actor(owner).unwrap() else {
        panic!()
    };
    assert_eq!(combat_state.scholar.soil_center.unwrap().0, initial.0);
    actors::take_for_zone(&mut n, &mut i, owner);
    assert!(!i.actors.contains_key(&object));
    let NetworkedActor::Player { combat_state, .. } = i.find_actor(owner).unwrap() else {
        panic!()
    };
    assert!(combat_state.scholar.soil_center.is_none());
}
