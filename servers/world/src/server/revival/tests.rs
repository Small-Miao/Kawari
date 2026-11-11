use super::*;
use crate::{ClientHandle, ClientId};
use binrw::BinWrite;

const CASTER: ObjectId = ObjectId(0x10000001);
const TARGET: ObjectId = ObjectId(0x10000002);

fn fixture() -> (
    Instance,
    NetworkState,
    tokio::sync::mpsc::Receiver<FromServer>,
) {
    let mut i = Instance::default();
    for id in [CASTER, TARGET] {
        i.insert_empty_actor(id);
        let a = i.find_actor_mut(id).unwrap();
        let s = a.get_common_spawn_mut();
        s.class_job = 24;
        s.max_health_points = 100_000;
        s.max_resource_points = 10_000;
        s.health_points = if id == CASTER { 100_000 } else { 0 };
        s.mode = if id == CASTER {
            CharacterMode::Normal
        } else {
            CharacterMode::Dead
        };
    }
    i.find_actor_mut(CASTER)
        .unwrap()
        .get_common_spawn_mut()
        .position = Position(glam::Vec3::new(4.0, 0.0, 8.0));
    let mut n = NetworkState::default();
    let (channel, receiver) = tokio::sync::mpsc::channel(128);
    n.clients.insert(
        ClientId::default(),
        (
            ClientHandle {
                id: ClientId::default(),
                actor_id: TARGET,
                channel,
                content_id: 0,
                account_id: 0,
            },
            Default::default(),
        ),
    );
    (i, n, receiver)
}

fn accept(n: &mut NetworkState, i: &mut Instance, now: Instant) {
    assert!(handle_trigger(
        n,
        i,
        TARGET,
        &ClientTriggerCommand::Revive { action: 5 },
        now
    ));
}

#[test]
fn raise_offer_wire_matches_recording_and_keeps_target_dead() {
    let (mut i, _, _) = fixture();
    let now = Instant::now();
    assert!(offer(&mut i, CASTER, TARGET, 125, now));
    let a = i.find_actor(TARGET).unwrap();
    assert_eq!(a.get_common_spawn().health_points, 0);
    assert_eq!(a.get_common_spawn().mode, CharacterMode::Dead);
    let s = a.status_effects().unwrap().get(OFFER_STATUS).unwrap();
    assert_eq!(s.source_actor_id, CASTER);
    assert_eq!(s.param, 8);
    assert!(s.duration > 59.0);
    assert!(a.status_effects().unwrap().get(43).is_none());
    let mut bytes = std::io::Cursor::new(Vec::new());
    offer_effect().write_le(&mut bytes).unwrap();
    assert_eq!(bytes.into_inner(), [14, 0, 20, 8, 0, 0, 148, 0]);
}

#[test]
fn raise_accept_moves_then_waits_for_arrival_and_animation() {
    let (mut i, mut n, mut messages) = fixture();
    let now = Instant::now();
    offer(&mut i, CASTER, TARGET, 125, now);
    accept(&mut n, &mut i, now);
    assert!(
        matches!(messages.try_recv().unwrap(), FromServer::PacketSegment(p, _) if matches!(p.data, ServerZoneIpcData::PrepareZoning { animation: 181, warp_type: WarpType::Unk5, param_7: 2, fade_out_time: 3, .. }))
    );
    accept(&mut n, &mut i, now); // 重复确认不能再发送迁移包。
    assert!(messages.try_recv().is_err());
    tick(&mut n, &mut i, now + MOVE_DELAY);
    assert_eq!(
        i.find_actor(TARGET).unwrap().position(),
        i.find_actor(CASTER).unwrap().position()
    );
    assert_eq!(
        i.find_actor(TARGET)
            .unwrap()
            .get_common_spawn()
            .health_points,
        0
    );
    let arrived = now + MOVE_DELAY + Duration::from_millis(200);
    handle_trigger(
        &mut n,
        &mut i,
        TARGET,
        &ClientTriggerCommand::FinishZoning {
            location_change_type: 5,
            position_change_type: 2,
        },
        arrived,
    );
    tick(
        &mut n,
        &mut i,
        arrived + ANIMATION_TIME - Duration::from_millis(1),
    );
    assert_eq!(
        i.find_actor(TARGET)
            .unwrap()
            .get_common_spawn()
            .health_points,
        0
    );
    tick(&mut n, &mut i, arrived + ANIMATION_TIME);
    let a = i.find_actor_mut(TARGET).unwrap();
    assert_eq!(a.get_common_spawn().health_points, 20_000);
    assert_eq!(a.get_common_spawn().resource_points, 2_000);
    assert_eq!(a.get_common_spawn().mode, CharacterMode::Normal);
    assert!(a.status_effects().unwrap().get(OFFER_STATUS).is_none());
    assert!(a.status_effects().unwrap().get(43).is_some());
    assert_eq!(
        a.status_effects().unwrap().get(43).unwrap().source_actor_id,
        ObjectId::default()
    );
    assert_eq!(a.apply_damage(99_999), 0);
    assert_eq!(
        crate::server::action::apply_target_player_mitigation(
            99999,
            Some(a),
            kawari::ipc::zone::DamageType::Magic
        ),
        0
    );
    end_protection(&mut n, &mut i, TARGET);
    assert_eq!(i.find_actor_mut(TARGET).unwrap().apply_damage(100), 100);
    assert!(pending(&i, TARGET).is_none());
}

#[test]
fn raise_transport_wire_matches_current_build_first_person_recording() {
    // 帕戈尔赞 build 14251465：道具请求后的迁移/起身流程。
    // 道具 4570 和演出 43336 不作为职业技能加入 is_raise。
    let (mut i, mut n, mut messages) = fixture();
    i.zone.id = 938;
    i.find_actor_mut(CASTER)
        .unwrap()
        .get_common_spawn_mut()
        .position = Position(glam::Vec3::new(-830.232, 2.8541062, 276.065));
    let target = i.find_actor_mut(TARGET).unwrap().get_common_spawn_mut();
    target.max_health_points = 33621;
    target.position = Position(glam::Vec3::new(-835.0, 2.0, 270.0));
    let now = Instant::now();
    assert!(offer(&mut i, CASTER, TARGET, 125, now));
    accept(&mut n, &mut i, now);
    let FromServer::PacketSegment(prepare, _) = messages.try_recv().unwrap() else {
        panic!("未收到迁移准备包");
    };
    let mut bytes = std::io::Cursor::new(Vec::new());
    prepare.data.write_le(&mut bytes).unwrap();
    assert_eq!(
        bytes.into_inner(),
        [0, 0, 0, 0, 0xaa, 3, 0xb5, 0, 0, 0, 5, 2, 3, 2, 0, 0]
    );
    tick(&mut n, &mut i, now + MOVE_DELAY);
    let FromServer::PacketSegment(position, _) = messages.try_recv().unwrap() else {
        panic!("未收到定位包");
    };
    let mut bytes = std::io::Cursor::new(Vec::new());
    position.data.write_le(&mut bytes).unwrap();
    assert_eq!(
        bytes.into_inner(),
        [
            0xff, 0x7f, 5, 2, 0, 0, 0, 0, 0xd9, 0x8e, 0x4f, 0xc4, 0xad, 0xa9, 0x36, 0x40, 0x52, 8,
            0x8a, 0x43, 0, 0, 0, 0,
        ]
    );
    let arrived = now + MOVE_DELAY + Duration::from_millis(391);
    handle_trigger(
        &mut n,
        &mut i,
        TARGET,
        &ClientTriggerCommand::FinishZoning {
            location_change_type: 5,
            position_change_type: 2,
        },
        arrived,
    );
    tick(&mut n, &mut i, arrived + ANIMATION_TIME);
    let actor = i.find_actor(TARGET).unwrap();
    assert_eq!(actor.get_common_spawn().health_points, 6724);
    assert_eq!(actor.get_common_spawn().resource_points, 2000);
    for (id, duration) in [(43, 100.0), (418, 5.0)] {
        let status = actor.status_effects().unwrap().get(id).unwrap();
        // get() 返回按 Instant 扣除经过时间后的剩余秒数。
        assert!(status.duration > duration - 1.0 && status.duration <= duration);
        assert_eq!(status.source_actor_id, ObjectId::default());
    }
    assert!(!is_raise(4570));
    assert!(!is_raise(43336));
}

#[test]
fn raise_decline_expiry_and_unsolicited_accept_never_revive() {
    let (mut i, mut n, _) = fixture();
    let now = Instant::now();
    accept(&mut n, &mut i, now);
    assert!(pending(&i, TARGET).is_none());
    offer(&mut i, CASTER, TARGET, 125, now);
    handle_trigger(
        &mut n,
        &mut i,
        TARGET,
        &ClientTriggerCommand::RejectRevive {},
        now,
    );
    accept(&mut n, &mut i, now);
    assert!(pending(&i, TARGET).is_none());
    offer(&mut i, CASTER, TARGET, 125, now);
    accept(&mut n, &mut i, now + OFFER_TIME);
    assert!(pending(&i, TARGET).is_none());
    offer(&mut i, CASTER, TARGET, 125, now);
    tick(&mut n, &mut i, now + OFFER_TIME);
    assert!(pending(&i, TARGET).is_none());
    assert!(
        i.find_actor(TARGET)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(OFFER_STATUS)
            .is_none()
    );
    assert_eq!(
        i.find_actor(TARGET)
            .unwrap()
            .get_common_spawn()
            .health_points,
        0
    );
}

#[test]
fn raise_replacement_keeps_latest_source_and_zone_leaving_clears_offer() {
    let (mut i, mut n, _) = fixture();
    let now = Instant::now();
    offer(&mut i, CASTER, TARGET, 125, now);
    let other = ObjectId(0x10000003);
    i.insert_empty_actor(other);
    let s = i.find_actor_mut(other).unwrap().get_common_spawn_mut();
    s.class_job = 40;
    s.health_points = 10;
    s.position = Position(glam::Vec3::new(1.0, 0.0, 0.0));
    assert!(offer(&mut i, other, TARGET, 24287, now));
    assert_eq!(pending(&i, TARGET).unwrap().source, other);
    assert_eq!(
        i.find_actor(TARGET)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(OFFER_STATUS)
            .unwrap()
            .source_actor_id,
        other
    );
    accept(&mut n, &mut i, now);
    assert!(!offer(&mut i, CASTER, TARGET, 125, now));
    let carried =
        crate::server::zone::take_combat_state_and_despawn_pets(&mut i, &mut n, TARGET).unwrap();
    assert!(carried.pending_raise.is_none());
    assert!(
        i.find_actor(TARGET)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(OFFER_STATUS)
            .is_none()
    );
}

#[test]
fn raise_rejects_wrong_job_living_out_of_range_and_forbidden_targets() {
    let (mut i, mut n, _) = fixture();
    let now = Instant::now();
    assert!(!offer(&mut i, CASTER, TARGET, 24287, now));
    assert!(!offer(&mut i, CASTER, CASTER, 125, now));
    i.find_actor_mut(TARGET)
        .unwrap()
        .get_common_spawn_mut()
        .position = Position(glam::Vec3::splat(100.0));
    assert!(!offer(&mut i, CASTER, TARGET, 125, now));
    i.find_actor_mut(TARGET)
        .unwrap()
        .get_common_spawn_mut()
        .position = Position::default();
    offer(&mut i, CASTER, TARGET, 125, now);
    i.find_actor_mut(TARGET)
        .unwrap()
        .status_effects_mut()
        .unwrap()
        .add_with_source(5144, 0, 60.0, TARGET);
    accept(&mut n, &mut i, now);
    assert!(pending(&i, TARGET).is_none());
    assert_eq!(
        i.find_actor(TARGET)
            .unwrap()
            .get_common_spawn()
            .health_points,
        0
    );
}

#[test]
fn raise_missing_arrival_cancels_without_restoring_hp() {
    let (mut i, mut n, _) = fixture();
    let now = Instant::now();
    offer(&mut i, CASTER, TARGET, 125, now);
    accept(&mut n, &mut i, now);
    tick(&mut n, &mut i, now + MOVE_DELAY);
    tick(&mut n, &mut i, now + MOVE_DELAY + ARRIVAL_TIMEOUT);
    assert!(pending(&i, TARGET).is_none());
    assert_eq!(
        i.find_actor(TARGET)
            .unwrap()
            .get_common_spawn()
            .health_points,
        0
    );
}

#[test]
fn raise_with_existing_weakness_grants_brink_of_death() {
    let (mut i, mut n, _) = fixture();
    i.find_actor_mut(TARGET)
        .unwrap()
        .status_effects_mut()
        .unwrap()
        .add_with_source(43, 0, 100.0, TARGET);
    let now = Instant::now();
    offer(&mut i, CASTER, TARGET, 125, now);
    accept(&mut n, &mut i, now);
    tick(&mut n, &mut i, now + MOVE_DELAY);
    handle_trigger(
        &mut n,
        &mut i,
        TARGET,
        &ClientTriggerCommand::FinishZoning {
            location_change_type: 5,
            position_change_type: 2,
        },
        now + MOVE_DELAY,
    );
    tick(&mut n, &mut i, now + MOVE_DELAY + ANIMATION_TIME);
    let statuses = i.find_actor(TARGET).unwrap().status_effects().unwrap();
    assert!(statuses.get(43).is_none());
    assert!(statuses.get(44).is_some());
}
