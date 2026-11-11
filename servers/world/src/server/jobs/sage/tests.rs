use super::*;
fn fixture() -> (Instance, NetworkState, ObjectId, ObjectId) {
    let mut i = Instance::default();
    let source = ObjectId(0x10000001);
    let ally = ObjectId(0x10000002);
    for (id, job) in [(source, 40), (ally, 19)] {
        i.insert_empty_actor(id);
        let a = i.find_actor_mut(id).unwrap();
        let c = a.get_common_spawn_mut();
        c.class_job = job;
        c.level = 100;
        c.health_points = 100000;
        c.max_health_points = 100000;
        if let NetworkedActor::Player { parameters, .. } = a {
            parameters.classjob_id = job;
            parameters.level = 100;
            parameters.mind = 1000;
            parameters.magic_damage = 100;
        }
    }
    (i, NetworkState::default(), source, ally)
}
#[test]
fn sage_gauge_matches_replay_and_addersgall_advances_without_combat() {
    let mut s = SageState::default();
    assert_eq!(s.pack(100).to_le_bytes(), [0, 0, 3, 3, 0, 0, 0, 0]);
    s.eukrasia = true;
    assert_eq!(s.resolve(24283, 100), 24314);
    assert_eq!(s.resolve(24286, 100), 37034);
    let now = Instant::now();
    s.gall = 0;
    s.gall_started = Some(now - Duration::from_secs(41));
    s.advance(100, now);
    assert_eq!(s.gall, 2);
    s.advance(100, now + Duration::from_secs(19));
    assert_eq!(s.gall, 3);
    assert!(s.gall_started.is_none());
}

#[test]
fn sage_sting_requires_actual_absorption_and_correct_shield_owner() {
    let (mut i, mut n, source, ally) = fixture();
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(source) {
        combat_state.sage.sting = 0;
    }
    super::super::scholar::shield(i.find_actor_mut(ally).unwrap(), 2607, 100, 30.0, source);
    i.find_actor_mut(ally)
        .unwrap()
        .status_effects_mut()
        .unwrap()
        .remove(2607);
    super::super::pictomancer::on_barrier_break(&mut n, &mut i, ally);
    super::super::scholar::shield(i.find_actor_mut(ally).unwrap(), 2609, 100, 30.0, source);
    i.find_actor_mut(ally).unwrap().apply_damage(100);
    super::super::pictomancer::on_barrier_break(&mut n, &mut i, ally);
    let get = |i: &Instance| {
        if let NetworkedActor::Player { combat_state, .. } = i.find_actor(source).unwrap() {
            combat_state.sage.sting
        } else {
            99
        }
    };
    assert_eq!(get(&i), 0);
    super::super::scholar::shield(i.find_actor_mut(ally).unwrap(), 2607, 100, 30.0, source);
    i.find_actor_mut(ally).unwrap().apply_damage(100);
    super::super::pictomancer::on_barrier_break(&mut n, &mut i, ally);
    assert_eq!(get(&i), 1);
    super::super::scholar::shield(i.find_actor_mut(source).unwrap(), 2609, 100, 30.0, source);
    i.find_actor_mut(source).unwrap().apply_damage(100);
    super::super::pictomancer::on_barrier_break(&mut n, &mut i, source);
    assert_eq!(get(&i), 2);
}
#[test]
fn sage_haima_refills_one_layer_after_hit_and_heals_remaining_layers_on_expiry() {
    let (mut i, mut n, source, ally) = fixture();
    let statuses = StatusEffects::default();
    effects::apply(
        &mut n,
        &mut i,
        JobAreaContext {
            caster: source,
            target: ally,
            action: 24305,
            combo: false,
            ground: None,
            statuses: &statuses,
            effects: &[],
            modifiers: Default::default(),
        },
    );
    let shield = i
        .find_actor(ally)
        .unwrap()
        .status_effects()
        .unwrap()
        .barrier_remaining(2612);
    assert!(shield > 0);
    i.find_actor_mut(ally).unwrap().apply_damage(shield + 10);
    super::super::pictomancer::on_barrier_break(&mut n, &mut i, ally);
    assert_eq!(
        i.find_actor(ally).unwrap().get_common_spawn().health_points,
        99990
    );
    assert_eq!(
        i.find_actor(ally)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(2642)
            .unwrap()
            .param,
        4
    );
    assert_eq!(
        i.find_actor(ally)
            .unwrap()
            .status_effects()
            .unwrap()
            .barrier_remaining(2612),
        shield
    );
    let cure = if let Some(NetworkedActor::Player {
        combat_state,
        spawn,
        ..
    }) = i.find_actor_mut(ally)
    {
        spawn.common.health_points = 1;
        let h = &mut combat_state.sage.haima[0];
        h.end = Instant::now() - Duration::from_secs(1);
        h.cure * 4
    } else {
        0
    };
    effects::tick_support(&mut n, &mut i, ally);
    effects::tick_support(&mut n, &mut i, ally);
    assert_eq!(
        i.find_actor(ally).unwrap().get_common_spawn().health_points,
        (1 + cure).min(100000)
    );
    assert!(
        i.find_actor(ally)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(2612)
            .is_none()
    );
}
#[test]
fn sage_eukrasian_mp_and_recasts_are_distinct_from_normal_magic() {
    let (i, _, source, _) = fixture();
    let a = i.find_actor(source).unwrap();
    assert_eq!(Sage.mp_cost(24291, a, 0), Some(800));
    assert_eq!(Sage.mp_cost(24314, a, 0), Some(400));
    assert_eq!(Sage.recast_100ms(24290, a), Some(10));
    assert!(Sage.fixed_recast(24313));
    assert!(!Sage.fixed_recast(24312));
    assert_eq!(effects::potency(24312, 93), 330);
    assert_eq!(effects::potency(24312, 94), 380);
}
