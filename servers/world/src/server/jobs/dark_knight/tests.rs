use super::*;

fn fixture() -> (Instance, ObjectId, ObjectId) {
    let owner = ObjectId(0x10000001);
    let ally = ObjectId(0x10000002);
    let mut i = Instance::default();
    for id in [owner, ally] {
        i.insert_empty_actor(id);
        let a = i.find_actor_mut(id).unwrap();
        let c = a.get_common_spawn_mut();
        c.class_job = 32;
        c.level = 100;
        c.health_points = 10000;
        c.max_health_points = 10000;
    }
    (i, owner, ally)
}
#[test]
fn drk_living_dead_heal_threshold_preserves_deadline_and_never_resurrects() {
    let (mut i, id, _) = fixture();
    let a = i.find_actor_mut(id).unwrap();
    a.status_effects_mut()
        .unwrap()
        .add_with_source(810, 0, 10.0, id);
    a.apply_damage(20000);
    assert_eq!(a.get_common_spawn().health_points, 1);
    assert!(a.status_effects().unwrap().get(811).is_some());
    a.apply_heal(6000);
    a.apply_damage(2000);
    a.apply_heal(4000);
    assert!(a.status_effects().unwrap().get(811).is_none());
    assert!(a.status_effects().unwrap().get(3255).is_some());
    a.apply_damage(20000);
    assert_eq!(a.get_common_spawn().health_points, 1);
    if let NetworkedActor::Player { combat_state, .. } = a {
        combat_state.dark_knight.walking_dead_until = Some(Instant::now() - Duration::from_secs(1));
    }
    DarkKnight.refresh_runtime_state_on_actor(id, a);
    assert_eq!(a.get_common_spawn().health_points, 1);
    a.apply_damage(1);
    assert_eq!(a.get_common_spawn().health_points, 0);
    assert_eq!(a.apply_heal(10000), 0);
}
#[test]
fn drk_living_dead_failure_and_god_mode() {
    let (mut i, id, _) = fixture();
    let a = i.find_actor_mut(id).unwrap();
    a.status_effects_mut()
        .unwrap()
        .add_with_source(810, 0, 10.0, id);
    a.apply_damage(10000);
    if let NetworkedActor::Player { combat_state, .. } = a {
        combat_state.dark_knight.walking_dead_until = Some(Instant::now() - Duration::from_secs(1));
    }
    DarkKnight.refresh_runtime_state_on_actor(id, a);
    assert_eq!(a.get_common_spawn().health_points, 0);
    a.get_common_spawn_mut().health_points = 10000;
    if let NetworkedActor::Player { combat_state, .. } = a {
        combat_state.god_mode = true;
    }
    a.status_effects_mut()
        .unwrap()
        .add_with_source(810, 0, 10.0, id);
    a.apply_damage(50000);
    assert_eq!(a.get_common_spawn().health_points, 10000);
    assert!(a.status_effects().unwrap().get(811).is_none());
}
#[test]
fn drk_tbn_break_credits_source_but_expiration_does_not() {
    let (mut i, id, ally) = fixture();
    let mut net = NetworkState::default();
    i.find_actor_mut(ally)
        .unwrap()
        .status_effects_mut()
        .unwrap()
        .add_barrier(1178, 0, 7.0, 2500, id, 10000);
    i.find_actor_mut(ally).unwrap().apply_damage(2499);
    super::super::pictomancer::on_barrier_break(&mut net, &mut i, ally);
    let get = |i: &Instance, id| matches!(i.find_actor(id),Some(NetworkedActor::Player{combat_state,..})if combat_state.dark_knight.dark_arts);
    assert!(!get(&i, id));
    i.find_actor_mut(ally).unwrap().apply_damage(1);
    super::super::pictomancer::on_barrier_break(&mut net, &mut i, ally);
    assert!(get(&i, id));
    assert!(!get(&i, ally));
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(id) {
        combat_state.dark_knight.dark_arts = false;
    }
    let s = i
        .find_actor_mut(ally)
        .unwrap()
        .status_effects_mut()
        .unwrap();
    s.add_barrier(1178, 0, 7.0, 2500, id, 10000);
    s.remove(1178);
    super::super::pictomancer::on_barrier_break(&mut net, &mut i, ally);
    assert!(!get(&i, id));
}
#[test]
fn drk_delirium_steps_mp_and_blood_follow_first_person_capture() {
    let mut s = DarkKnightState {
        blood: 20,
        ..Default::default()
    };
    s.advance(7390, 100, false, true);
    for (id, step, blood) in [(36928, 1, 30), (36929, 2, 40), (36930, 0, 50)] {
        assert_eq!(s.resolve(7392, 100), id);
        assert_eq!(s.mp_on_hit(id, false), 800);
        s.advance(id, 100, false, true);
        assert_eq!(s.combo_step, step);
        assert_eq!(s.blood, blood);
        assert_eq!(s.extra(100)[0], step as u8);
    }
    assert_eq!(s.resolve(7392, 100), 7392);
    s.advance(7392, 100, false, true);
    assert_eq!(s.blood, 0);
    s.dark_arts = true;
    assert_eq!(s.mp_cost(16470, 3000), 0);
    assert_eq!(s.mp_cost(7393, 3000), 3000);
    s.advance(16470, 100, false, true);
    assert!(!s.dark_arts);
    assert!(s.has_darkside());
    for _ in 0..4 {
        s.advance(16470, 100, false, true);
    }
    assert!(timer(s.darkside_until) <= 60000);
    assert_eq!(s.pack(61) as u8, 0);
    assert_eq!(s.extra(95), [0; 6]);
}
#[test]
fn drk_ground_stays_at_cast_position_and_cleanup_removes_owned_actors() {
    let (mut i, id, _) = fixture();
    let mut n = NetworkState::default();
    let origin = Position(glam::Vec3::new(5.0, 0.0, 7.0));
    i.find_actor_mut(id)
        .unwrap()
        .get_common_spawn_mut()
        .position = origin;
    DarkKnight.spawn_pet_after_action(&mut n, &mut i, id, 3639, id);
    i.find_actor_mut(id)
        .unwrap()
        .get_common_spawn_mut()
        .position = Position(glam::Vec3::new(50.0, 0.0, 70.0));
    let object = if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(id) {
        assert_eq!(combat_state.dark_knight.salted_center, Some(origin));
        combat_state.dark_knight.salted_object.unwrap()
    } else {
        panic!()
    };
    assert!(i.find_actor(object).is_some());
    DarkKnight.on_job_deactivated(&mut n, &mut i, id);
    assert!(i.find_actor(object).is_none());
}
#[test]
fn drk_line_excludes_side_back_and_out_of_range() {
    let (mut i, id, _) = fixture();
    let mut expected = Vec::new();
    for (n, p) in [
        glam::Vec3::new(0.0, 0.0, 4.0),
        glam::Vec3::new(3.0, 0.0, 4.0),
        glam::Vec3::new(0.0, 0.0, -4.0),
        glam::Vec3::new(0.0, 0.0, 11.0),
    ]
    .into_iter()
    .enumerate()
    {
        let npc = ObjectId(0x40000001 + n as u32);
        let mut spawn = kawari::ipc::zone::SpawnNpc::default();
        spawn.common.health_points = 10000;
        spawn.common.owner_id = ObjectId(0xE0000000);
        spawn.common.position = Position(p);
        i.insert_npc(npc, spawn);
        if n == 0 {
            expected.push(npc);
        }
    }
    let got = super::super::native::targets(
        &i,
        i.find_actor(id).unwrap().position().0,
        glam::Vec3::Z,
        super::super::native::Shape::Line {
            length: 10.0,
            width: 4.0,
        },
    );
    assert_eq!(got, expected);
}

#[test]
fn drk_zone_change_removes_ground_but_preserves_blood() {
    let (mut i, o, _) = fixture();
    let mut n = NetworkState::default();
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
        combat_state.dark_knight.blood = 70;
    }
    DarkKnight.spawn_pet_after_action(&mut n, &mut i, o, 3639, o);
    let object = if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        combat_state.dark_knight.salted_object.unwrap()
    } else {
        panic!()
    };
    let carried =
        crate::server::zone::take_combat_state_and_despawn_pets(&mut i, &mut n, o).unwrap();
    assert!(i.find_actor(object).is_none());
    assert_eq!(carried.dark_knight.blood, 70);
    assert!(carried.dark_knight.salted_until.is_none());
}
