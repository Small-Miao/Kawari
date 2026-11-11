//! 状态机与当前国服录像的关键量谱快照回归。
use super::*;
use crate::server::{instance::Instance, network::NetworkState};
use glam::Vec3;

#[test]
fn replay_canvas_sequence_matches_wire_payload() {
    let now = Instant::now();
    let mut s = PictomancerState {
        canvas: 0x31,
        ..Default::default()
    };
    for (action, expected) in [
        (34650, [0, 0, 0, 0x31, 0]),
        (34651, [0, 0, 0, 0x31, 0]),
        (34652, [25, 0, 1, 0x31, 0]),
        (34670, [25, 0, 1, 0x30, 1]),
        (34674, [25, 0, 1, 0x20, 1]),
        (34678, [25, 0, 1, 0x20, 1]),
        (34679, [25, 0, 1, 0x20, 1]),
        (34680, [25, 0, 1, 0x20, 1]),
        (34665, [25, 0, 1, 0x22, 1]),
        (34671, [25, 0, 1, 0x20, 0x13]),
        (34676, [25, 0, 1, 0x20, 3]),
        (34666, [25, 0, 1, 0x24, 3]),
        (34672, [25, 0, 1, 0x20, 7]),
        (34667, [25, 0, 1, 0x28, 7]),
        (34673, [25, 0, 1, 0x20, 0x20]),
        (34677, [25, 0, 1, 0x20, 0]),
    ] {
        assert!(
            s.can_execute(action, 100, true, now),
            "动作 {action} 被错误拒绝"
        );
        s.apply(action, 100, Position::default(), now);
        assert_eq!(
            &s.gauge(100, now).to_le_bytes()[..5],
            &expected,
            "动作 {action}"
        );
    }
}

#[test]
fn palette_spectrum_black_paint_and_caps() {
    let now = Instant::now();
    let mut s = PictomancerState {
        palette: 100,
        paint: 5,
        canvas: 32,
        ..Default::default()
    };
    s.apply(34675, 100, Position::default(), now);
    s.apply(34683, 100, Position::default(), now);
    assert_eq!((s.palette, s.subtractive, s.monochrome), (100, 3, true));
    assert!(!s.can_execute(34683, 100, true, now));
    for a in [34653, 34654, 34655] {
        assert!(s.can_execute(a, 100, true, now));
        s.apply(a, 100, Position::default(), now);
    }
    assert_eq!((s.paint, s.subtractive), (5, 0));
    assert_eq!(s.resolve(34662, 100, now), 34663);
    s.apply(34663, 100, Position::default(), now);
    assert_eq!((s.paint, s.monochrome), (4, false));
    s.apply(34683, 100, Position::default(), now);
    assert_eq!(s.palette, 50);
}

#[test]
fn hyperphantasia_requires_field_and_grants_rainbow_only_at_92() {
    for level in [70, 80, 82, 91, 92, 100] {
        let now = Instant::now();
        let mut s = PictomancerState {
            canvas: 32,
            ..Default::default()
        };
        s.apply(34675, level, Position::default(), now);
        assert_eq!(s.hyper, if level >= 82 { 5 } else { 0 });
        assert_eq!(active(s.starstruck_until, now), level >= 100);
        for a in [34650, 34651, 34652, 34650, 34651] {
            s.apply(a, level, Position::default(), now);
        }
        assert_eq!(s.hyper, 0);
        assert_eq!(active(s.rainbow_until, now), level >= 92);
    }
    let now = Instant::now();
    let mut s = PictomancerState {
        canvas: 32,
        ..Default::default()
    };
    s.apply(34675, 100, Position::default(), now);
    s.inspired = false;
    s.apply(34650, 100, Position::default(), now);
    assert_eq!(s.hyper, 5);
}

#[test]
fn expiry_and_level_gates_reject_stale_packets() {
    let now = Instant::now();
    let mut s = PictomancerState {
        canvas: 16,
        ..Default::default()
    };
    assert!(!s.can_execute(34674, 100, false, now));
    s.apply(34674, 100, Position::default(), now);
    assert!(!s.can_execute(34679, 100, true, now));
    assert!(!s.can_execute(34678, 100, true, now + Duration::from_secs(31)));
    assert!(!s.can_execute(34681, 100, true, now));
    assert!(!s.can_execute(34682, 100, true, now));
    assert!(!s.can_execute(34666, 95, true, now));
    assert_eq!(data::potency(34650, 53), 250);
    assert_eq!(data::potency(34650, 54), 310);
    assert_eq!(data::potency(34650, 94), 490);
    assert_eq!(data::potency(34678, 85), 540);
}

#[test]
fn low_level_creature_cycles_back_to_pom() {
    let now = Instant::now();
    let mut s = PictomancerState::default();
    for a in [34664, 34670, 34665, 34671] {
        s.apply(a, 95, Position::default(), now);
    }
    assert_eq!(s.resolve(34689, 95, now), 34664);
    assert_eq!(s.creature, 16);
}

#[test]
fn line_geometry_excludes_circle_only_targets() {
    let origin = Vec3::ZERO;
    let target = Vec3::new(0.0, 0.0, 20.0);
    assert!(line_contains(
        origin,
        target,
        Vec3::new(1.0, 0.0, 10.0),
        25.0,
        2.0
    ));
    for p in [
        Vec3::new(5.0, 0.0, 20.0),
        Vec3::new(0.0, 0.0, -1.0),
        Vec3::new(0.0, 0.0, 26.0),
    ] {
        assert!(!line_contains(origin, target, p, 25.0, 2.0));
    }
}

#[test]
fn field_entry_exit_expiry_and_job_change_cleanup() {
    let id = ObjectId(0x10000001);
    let mut i = Instance::default();
    let mut n = NetworkState::default();
    i.insert_empty_actor(id);
    let a = i.find_actor_mut(id).unwrap();
    a.get_common_spawn_mut().class_job = 42;
    a.get_common_spawn_mut().level = 100;
    a.get_common_spawn_mut().health_points = 100;
    if let NetworkedActor::Player { combat_state, .. } = a {
        combat_state
            .pictomancer
            .apply(34675, 100, Position::default(), Instant::now());
    }
    finish_action(&mut n, &mut i, id, 34675, id);
    let object = if let NetworkedActor::Player { combat_state, .. } = i.find_actor(id).unwrap() {
        combat_state.pictomancer.field_object.unwrap()
    } else {
        unreachable!()
    };
    assert!(i.find_actor(object).is_some());
    i.find_actor_mut(id)
        .unwrap()
        .get_common_spawn_mut()
        .position = Position(Vec3::new(9.0, 0.0, 0.0));
    refresh_field(&mut n, &mut i, id);
    assert!(
        i.find_actor(id)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(INSPIRATION)
            .is_none()
    );
    i.find_actor_mut(id)
        .unwrap()
        .get_common_spawn_mut()
        .position = Position::default();
    refresh_field(&mut n, &mut i, id);
    assert!(
        i.find_actor(id)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(INSPIRATION)
            .is_some()
    );
    let removed = deactivate(i.find_actor_mut(id).unwrap());
    assert_eq!(removed, Some(object));
    assert!(
        i.find_actor(id)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(INSPIRATION)
            .is_none()
    );
}

#[test]
fn coat_break_refunds_only_the_owner_and_only_once() {
    let owner = ObjectId(1);
    let ally = ObjectId(2);
    let mut i = Instance::default();
    let mut n = NetworkState::default();
    for id in [owner, ally] {
        i.insert_empty_actor(id);
        if let NetworkedActor::Player {
            spawn,
            combat_state,
            status_effects,
            ..
        } = i.find_actor_mut(id).unwrap()
        {
            spawn.common.class_job = 42;
            spawn.common.health_points = 1000;
            spawn.common.max_health_points = 1000;
            combat_state.start_cooldown(5, 34685, Duration::from_secs(120), 1, Duration::ZERO);
            status_effects.add_barrier(GRASSA, 0, 10.0, 100, owner, 1000);
            assert_eq!(status_effects.absorb_damage(150), 50);
        }
        on_barrier_break(&mut n, &mut i, id);
        on_barrier_break(&mut n, &mut i, id);
        if let NetworkedActor::Player { combat_state, .. } = i.find_actor_mut(id).unwrap() {
            let remaining = combat_state.cooldown_remaining(5).as_secs();
            assert!((if id == owner { 88..=90 } else { 118..=120 }).contains(&remaining));
        }
    }
}
