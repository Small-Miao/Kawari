//! 最终阶段练习实例的三级极限技。由 Director 显式开启，普通实例不走此路径。
use super::{
    action::update_actor_hp_mp,
    actor::NetworkedActor,
    director::AoeShape,
    effect::{gain_effect_instance, remove_effect_instance},
    instance::Instance,
    network::{DestinationNetwork, NetworkState},
};
use crate::{ClientId, FromServer};
use kawari::{
    common::{CharacterMode, ObjectId, ObjectTypeId, ObjectTypeKind},
    ipc::zone::{
        ActionEffect32, ActionEffectHeader, ActionRequest, ActionType, ActorControlCategory,
        ActorControlSelf, DamageElement, DamageKind, DamageType, ServerZoneIpcData,
        ServerZoneIpcSegment, TargetEffect, TargetEffectKind,
    },
};
use parking_lot::Mutex;
use std::sync::Arc;

#[derive(Clone, Copy, Debug, PartialEq)]
pub enum Kind {
    Tank(u16),
    Heal,
    Melee,
    Caster,
    Ranged,
}

pub fn specification(action: u32) -> Option<(u8, Kind)> {
    Some(match action {
        199 => (19, Kind::Tank(196)),
        4240 => (21, Kind::Tank(863)),
        4241 => (32, Kind::Tank(864)),
        17105 => (37, Kind::Tank(1931)),
        208 => (24, Kind::Heal),
        4247 => (28, Kind::Heal),
        4248 => (33, Kind::Heal),
        24859 => (40, Kind::Heal),
        202 => (20, Kind::Melee),
        4242 => (22, Kind::Melee),
        4243 => (30, Kind::Melee),
        7861 => (34, Kind::Melee),
        24858 => (39, Kind::Melee),
        34866 => (41, Kind::Melee),
        205 => (25, Kind::Caster),
        4246 => (27, Kind::Caster),
        7862 => (35, Kind::Caster),
        34867 => (42, Kind::Caster),
        4244 => (23, Kind::Ranged),
        4245 => (31, Kind::Ranged),
        17106 => (38, Kind::Ranged),
        _ => return None,
    })
}

pub fn set_gauge(network: &mut NetworkState, instance: &mut Instance, value: u32) {
    let value = value.min(30000);
    if let Some(d) = &mut instance.director {
        d.runtime.limit_break_gauge = Some(value);
    }
    let ids: Vec<_> = instance
        .actors
        .iter()
        .filter_map(|(id, a)| matches!(a, NetworkedActor::Player { .. }).then_some(*id))
        .collect();
    for id in ids {
        network.send_to_by_actor_id(
            id,
            FromServer::PacketSegment(
                ServerZoneIpcSegment::new(ServerZoneIpcData::ActorControlSelf(ActorControlSelf {
                    category: ActorControlCategory::LimitBreakGauge {
                        bars: 3,
                        current_value: value,
                        max_value_per_bar: 10000,
                        unk4: 0,
                        lb_type: 0,
                    },
                })),
                id,
            ),
            DestinationNetwork::ZoneClients,
        );
    }
}

pub fn allowed(instance: &Instance, source: ObjectId, action: u32) -> bool {
    let Some((job, _)) = specification(action) else {
        return false;
    };
    instance.director.as_ref().is_some_and(|d| {
        d.battle_started_at.is_some() && d.runtime.limit_break_gauge == Some(30000)
    }) && instance.find_actor(source).is_some_and(|a| {
        matches!(a, NetworkedActor::Player { .. })
            && !a.is_time_stopped()
            && a.get_common_spawn().class_job == job
            && a.get_common_spawn().health_points > 0
    })
}

/// 只在到期任务执行时检查；治疗 LB 已移除状态便不会再触发。
pub fn expire_magic_number(
    network: Arc<Mutex<NetworkState>>,
    instance: &mut Instance,
    actor: ObjectId,
) {
    if !instance
        .director
        .as_ref()
        .is_some_and(|d| d.runtime.owned_effects.contains_key(&(actor, 3532)))
    {
        return;
    }
    if let Some(a) = instance.find_actor_mut(actor)
        && a.status_effects().is_some_and(|s| s.get(3532).is_some())
    {
        a.apply_damage(9999999);
        update_actor_hp_mp(network, instance, actor);
    }
}

pub fn execute(
    network: Arc<Mutex<NetworkState>>,
    instance: &mut Instance,
    source: ObjectId,
    request: &ActionRequest,
) -> bool {
    let Some((_, kind)) = specification(request.action_id) else {
        return false;
    };
    if request.action_type != ActionType::Action
        || !instance
            .director
            .as_ref()
            .is_some_and(|d| d.runtime.limit_break_gauge.is_some())
    {
        return false;
    }
    if !allowed(instance, source, request.action_id) {
        network.lock().send_ac_in_range_inclusive_instance(
            instance,
            source,
            ActorControlCategory::CancelCast {
                log_message_id: 0,
                action_type: 1,
                action_id: request.action_id,
                interrupted: true,
            },
        );
        return true;
    }
    let origin = instance.find_actor(source).unwrap().position();
    let destination = instance
        .find_actor(request.target.object_id)
        .map(|a| a.position())
        .unwrap_or(origin);
    let dx = destination.0.x - origin.0.x;
    let dz = destination.0.z - origin.0.z;
    let rotation = dx.atan2(dz);
    let refund = instance
        .find_actor(source)
        .and_then(|a| a.status_effects())
        .is_some_and(|s| s.get(3446).is_some());
    set_gauge(&mut network.lock(), instance, 0);
    let mut targets: Vec<_> = instance
        .actors
        .iter()
        .filter_map(|(id, a)| {
            let p = a.common_spawn()?;
            let hit = match kind {
                Kind::Tank(_) | Kind::Heal => {
                    matches!(a, NetworkedActor::Player { .. })
                        && p.position.0.distance(origin.0) <= 50.0
                        && (!matches!(kind, Kind::Heal) || p.health_points > 0 || a.can_be_raised())
                }
                Kind::Melee => {
                    *id == request.target.object_id
                        && matches!(
                            a,
                            NetworkedActor::Npc {
                                targetable: true,
                                ..
                            }
                        )
                        && p.health_points > 0
                }
                Kind::Caster => {
                    matches!(
                        a,
                        NetworkedActor::Npc {
                            targetable: true,
                            ..
                        }
                    ) && p.health_points > 0
                        && AoeShape::Circle { radius: 15.0 }.contains(
                            p.position.0,
                            destination.0,
                            0.0,
                        )
                }
                Kind::Ranged => {
                    matches!(
                        a,
                        NetworkedActor::Npc {
                            targetable: true,
                            ..
                        }
                    ) && p.health_points > 0
                        && AoeShape::Rect {
                            length: 30.0,
                            width: 16.0,
                        }
                        .contains(p.position.0, origin.0, rotation)
                }
            };
            hit.then_some(*id)
        })
        .collect();
    targets.sort_by_key(|id| id.0);
    targets.truncate(32);
    let mut effects = [[TargetEffect::default(); 8]; 32];
    let mut ids = [ObjectTypeId::default(); 32];
    for (i, id) in targets.iter().enumerate() {
        ids[i] = ObjectTypeId {
            object_id: *id,
            object_type: ObjectTypeKind::None,
        };
        match kind {
            Kind::Tank(status) => {
                gain_effect_instance(
                    network.clone(),
                    ClientId::default(),
                    instance,
                    *id,
                    status,
                    0,
                    8.0,
                    source,
                    true,
                );
                instance
                    .director
                    .as_mut()
                    .unwrap()
                    .runtime
                    .owned_effects
                    .insert((*id, status), source);
            }
            Kind::Heal => {
                for status in [3532, 43, 44] {
                    remove_effect_instance(network.clone(), instance, *id, status);
                }
                let amount = if let Some(a) = instance.find_actor_mut(*id) {
                    let p = a.get_common_spawn_mut();
                    let amount = p.max_health_points - p.health_points;
                    p.health_points = p.max_health_points;
                    p.resource_points = p.max_resource_points;
                    amount
                } else {
                    0
                };
                super::set_character_mode(
                    instance,
                    &mut network.lock(),
                    *id,
                    CharacterMode::Normal,
                    0,
                );
                effects[i][0] = TargetEffect(TargetEffectKind::Heal {
                    amount,
                    unk1: [0; 5],
                });
            }
            _ => {
                // 当前练习数值：小彗星需要法系 LB，大陨石需要法系和远敏 LB。
                // 后续可与完整队伍武器装等公式合并；不会直接删除天体或强制改为死亡。
                let amount = match kind {
                    Kind::Melee => 500000,
                    Kind::Caster => 250000,
                    _ => 260000,
                };
                if let Some(a) = instance.find_actor_mut(*id) {
                    a.apply_damage(amount);
                }
                effects[i][0] = TargetEffect(TargetEffectKind::Damage {
                    damage_kind: DamageKind::empty(),
                    damage_type: DamageType::LimitBreak,
                    damage_element: DamageElement::Unaspected,
                    bonus_percent: 0,
                    unk3: 0,
                    unk4: 0,
                    amount,
                });
            }
        }
    }
    let seq = {
        let mut n = network.lock();
        let v = n.global_action_sequence;
        n.global_action_sequence = n.global_action_sequence.wrapping_add(1);
        v
    };
    let packet = ServerZoneIpcSegment::new(ServerZoneIpcData::ActionEffect32(Box::new(
        ActionEffect32 {
            header: ActionEffectHeader {
                animation_target_id: request.target,
                action_id: request.action_id,
                spell_id: request.action_id as u16,
                source_sequence: request.sequence,
                global_sequence: seq,
                animation_lock: 3.0,
                rotation,
                action_type: ActionType::Action,
                target_count: targets.len() as u8,
                ..Default::default()
            },
            effects,
            target_ids: ids,
            position: destination,
        },
    )));
    network.lock().send_in_range_inclusive_instance(
        source,
        instance,
        FromServer::PacketSegment(packet, source),
        DestinationNetwork::ZoneClients,
    );
    for id in targets {
        let current_hp = instance
            .find_actor(id)
            .unwrap()
            .get_common_spawn()
            .health_points;
        network.lock().send_in_range_inclusive_instance(
            id,
            instance,
            FromServer::PacketSegment(
                ServerZoneIpcSegment::new(ServerZoneIpcData::EffectResultBasic {
                    unk1: 1,
                    unk2: seq,
                    target_id: id,
                    current_hp,
                    unk3: 0,
                    unk4: 0,
                }),
                id,
            ),
            DestinationNetwork::ZoneClients,
        );
        update_actor_hp_mp(network.clone(), instance, id);
    }
    if refund {
        remove_effect_instance(network.clone(), instance, source, 3446);
        gain_effect_instance(
            network.clone(),
            ClientId::default(),
            instance,
            source,
            3448,
            0,
            0.0,
            source,
            true,
        );
        instance
            .director
            .as_mut()
            .unwrap()
            .runtime
            .owned_effects
            .insert((source, 3448), source);
        set_gauge(&mut network.lock(), instance, 30000);
    }
    true
}
