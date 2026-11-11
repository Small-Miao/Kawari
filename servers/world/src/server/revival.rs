//! 普通复活确认流程。协议依据：国服 build 14101351 的职业复活，
//! 以及 build 14251465 的不死鸟之尾本人迁移/起身录像（共用后半段）。
//! 当前客户端窗口仍需实机验收；不要把服务端测试当作客户端验收。
use std::time::{Duration, Instant};

use super::{
    actor::NetworkedActor,
    effect::send_effects_list_with,
    instance::Instance,
    jobs::white_mage::send_hp_mp,
    network::{DestinationNetwork, NetworkState},
};
use crate::FromServer;
use kawari::{
    common::{CharacterMode, ObjectId, Position},
    ipc::zone::{
        ActorControlCategory, ActorSetPos, ClientTriggerCommand, ServerZoneIpcData,
        ServerZoneIpcSegment, TargetEffect, TargetEffectKind, WarpType,
    },
};

pub(super) const OFFER_STATUS: u16 = 148;
pub(super) const PROTECTION_STATUS: u16 = 418;
const OFFER_TIME: Duration = Duration::from_secs(60);
const MOVE_DELAY: Duration = Duration::from_millis(1500);
const ARRIVAL_TIMEOUT: Duration = Duration::from_secs(10);
const ANIMATION_TIME: Duration = Duration::from_secs(3);

#[derive(Debug, Clone, Copy)]
enum Stage {
    Offered,
    Transport,
    AwaitingArrival,
    Animating,
}

#[derive(Debug, Clone, Copy)]
pub(crate) struct PendingRaise {
    source: ObjectId,
    position: Position,
    stage: Stage,
    deadline: Instant,
    weakness: u16,
}

pub(super) fn is_raise(action: u32) -> bool {
    matches!(action, 125 | 173 | 3603 | 7523 | 24287)
}

pub(super) fn is_protected(actor: &NetworkedActor) -> bool {
    actor
        .status_effects()
        .is_some_and(|s| s.get(PROTECTION_STATUS).is_some_and(|s| s.duration > 0.0))
}

pub(super) fn valid_target(
    instance: &Instance,
    caster: ObjectId,
    target: ObjectId,
    action: u32,
) -> bool {
    let Some(source @ NetworkedActor::Player { spawn, .. }) = instance.find_actor(caster) else {
        return false;
    };
    let allowed = matches!(
        (spawn.common.class_job, action),
        (6 | 24, 125) | (26 | 27 | 28, 173) | (33, 3603) | (35, 7523) | (40, 24287)
    );
    allowed
        && spawn.common.health_points > 0
        && caster != target
        && instance.find_actor(target).is_some_and(|actor| {
            matches!(actor, NetworkedActor::Player { combat_state, .. }
                if combat_state.pending_raise.is_none_or(|p| matches!(p.stage, Stage::Offered)))
                && actor.get_common_spawn().health_points == 0
                && actor.get_common_spawn().max_health_points > 0
                && actor.can_be_raised()
                && source.position().0.is_finite()
                && source.position().0.distance(actor.position().0) <= 30.0
        })
}

/// ActionEffect 中的 0e 00 14 08 00 00 94 00，状态同步由普通技能路径完成。
pub(super) fn offer_effect() -> TargetEffect {
    TargetEffect(TargetEffectKind::GainEffect {
        unk1: 0,
        unk2: 20,
        param: 8,
        unk3: 0,
        effect_id: OFFER_STATUS,
        duration: 60.0,
    })
}

pub(super) fn offer(
    instance: &mut Instance,
    source: ObjectId,
    target: ObjectId,
    action: u32,
    now: Instant,
) -> bool {
    if !valid_target(instance, source, target, action) {
        return false;
    }
    let position = instance.find_actor(source).unwrap().position();
    let Some(NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    }) = instance.find_actor_mut(target)
    else {
        return false;
    };
    // 录像可见第二位施术者覆盖原请求；接受后禁止再替换。
    let weakness = if [43, 44]
        .iter()
        .any(|id| status_effects.get(*id).is_some_and(|s| s.duration > 0.0))
    {
        44
    } else {
        43
    };
    combat_state.pending_raise = Some(PendingRaise {
        source,
        position,
        stage: Stage::Offered,
        deadline: now + OFFER_TIME,
        weakness,
    });
    status_effects.add_with_source(OFFER_STATUS, 8, 60.0, source);
    true
}

fn pending(instance: &Instance, target: ObjectId) -> Option<PendingRaise> {
    match instance.find_actor(target)? {
        NetworkedActor::Player { combat_state, .. } => combat_state.pending_raise,
        _ => None,
    }
}

fn set_pending(instance: &mut Instance, target: ObjectId, value: Option<PendingRaise>) {
    if let Some(NetworkedActor::Player { combat_state, .. }) = instance.find_actor_mut(target) {
        combat_state.pending_raise = value;
    }
}

fn remove_status(network: &mut NetworkState, instance: &mut Instance, target: ObjectId, id: u16) {
    let removed = instance
        .find_actor_mut(target)
        .and_then(|a| a.status_effects_mut())
        .and_then(|s| {
            let effect = s.get(id)?;
            s.remove(id);
            Some(effect)
        });
    if let Some(effect) = removed {
        network.send_ac_in_range_inclusive_instance(
            instance,
            target,
            ActorControlCategory::LoseEffect {
                effect_id: id.into(),
                unk2: effect.param.into(),
                source_actor_id: effect.source_actor_id,
            },
        );
        send_effects_list_with(network, instance, target);
    }
}

pub(super) fn clear(network: &mut NetworkState, instance: &mut Instance, target: ObjectId) {
    if pending(instance, target).is_some_and(|p| !matches!(p.stage, Stage::Offered)) {
        network.send_ac_in_range_inclusive_instance(
            instance,
            target,
            ActorControlCategory::ZoneIn {
                warp_finish_anim: 1,
                raise_anim: 0,
                unk1: 0,
            },
        );
    }
    set_pending(instance, target, None);
    remove_status(network, instance, target, OFFER_STATUS);
}

pub(super) fn end_protection(
    network: &mut NetworkState,
    instance: &mut Instance,
    target: ObjectId,
) {
    remove_status(network, instance, target, PROTECTION_STATUS);
}

fn start_animation(
    network: &mut NetworkState,
    instance: &mut Instance,
    target: ObjectId,
    mut p: PendingRaise,
    now: Instant,
) {
    remove_status(network, instance, target, OFFER_STATUS);
    p.stage = Stage::Animating;
    p.deadline = now + ANIMATION_TIME;
    set_pending(instance, target, Some(p));
    network.send_ac_in_range_inclusive_instance(
        instance,
        target,
        ActorControlCategory::ZoneIn {
            warp_finish_anim: 1,
            raise_anim: 1,
            unk1: 0,
        },
    );
}

/// 返回 true 表示已消费复活相关消息；普通回出生点（action=8）不在此路径。
pub(super) fn handle_trigger(
    network: &mut NetworkState,
    instance: &mut Instance,
    target: ObjectId,
    trigger: &ClientTriggerCommand,
    now: Instant,
) -> bool {
    match trigger {
        ClientTriggerCommand::Revive { action: 5 } => {
            let Some(mut p) = pending(instance, target) else {
                return true;
            };
            if !matches!(p.stage, Stage::Offered) {
                return true;
            }
            let valid = now < p.deadline
                && instance.find_actor(target).is_some_and(|a| {
                    a.get_common_spawn().health_points == 0
                        && a.can_be_raised()
                        && a.status_effects().is_some_and(|s| {
                            s.get(OFFER_STATUS)
                                .is_some_and(|s| s.source_actor_id == p.source && s.duration > 0.0)
                        })
                });
            if !valid {
                clear(network, instance, target);
                return true;
            }
            p.stage = Stage::Transport;
            p.deadline = now + MOVE_DELAY;
            set_pending(instance, target, Some(p));
            let ipc = ServerZoneIpcSegment::new(ServerZoneIpcData::PrepareZoning {
                log_message: 0,
                target_zone: instance.zone.id,
                animation: 181,
                param4: 0,
                hide_character: 0,
                warp_type: WarpType::Unk5,
                param_7: 2,
                fade_out_time: 3,
                unk1: 2,
                unk2: 0,
            });
            network.send_to_by_actor_id(
                target,
                FromServer::PacketSegment(ipc, target),
                DestinationNetwork::ZoneClients,
            );
            network.send_ac_in_range_instance(
                instance,
                target,
                ActorControlCategory::ActorDespawnEffect {
                    warp_mode: 2,
                    animation: 181,
                },
            );
            true
        }
        ClientTriggerCommand::RejectRevive {} => {
            if pending(instance, target).is_some_and(|p| matches!(p.stage, Stage::Offered)) {
                clear(network, instance, target);
            }
            true
        }
        ClientTriggerCommand::FinishZoning {
            location_change_type: 5,
            ..
        } => {
            if let Some(p) = pending(instance, target)
                && matches!(p.stage, Stage::AwaitingArrival)
            {
                start_animation(network, instance, target, p, now);
            }
            true
        }
        _ => false,
    }
}

pub(super) fn tick(network: &mut NetworkState, instance: &mut Instance, now: Instant) {
    let pending: Vec<_> = instance
        .actors
        .keys()
        .filter_map(|id| pending(instance, *id).map(|p| (*id, p)))
        .collect();
    for (target, mut p) in pending {
        let valid = instance
            .find_actor(target)
            .is_some_and(|a| a.get_common_spawn().health_points == 0 && a.can_be_raised());
        if !valid {
            clear(network, instance, target);
            continue;
        }
        if matches!(p.stage, Stage::Offered)
            && !instance
                .find_actor(target)
                .unwrap()
                .status_effects()
                .unwrap()
                .get(OFFER_STATUS)
                .is_some_and(|s| s.source_actor_id == p.source)
        {
            clear(network, instance, target);
            continue;
        }
        if now < p.deadline {
            continue;
        }
        match p.stage {
            Stage::Offered | Stage::AwaitingArrival => {
                // 未确认或客户端没有完成迁移时取消，不能靠超时擅自复活。
                clear(network, instance, target);
            }
            Stage::Transport => {
                let actor = instance.find_actor_mut(target).unwrap();
                actor.get_common_spawn_mut().position = p.position;
                actor.get_common_spawn_mut().rotation = 0.0;
                let ipc = ServerZoneIpcSegment::new(ServerZoneIpcData::ActorSetPos(ActorSetPos {
                    position: p.position,
                    rotation: 0.0,
                    warp_type: WarpType::Unk5,
                    warp_type_arg: 2,
                    ..Default::default()
                }));
                network.send_in_range_inclusive_instance(
                    target,
                    instance,
                    FromServer::PacketSegment(ipc, target),
                    DestinationNetwork::ZoneClients,
                );
                p.stage = Stage::AwaitingArrival;
                p.deadline = now + ARRIVAL_TIMEOUT;
                set_pending(instance, target, Some(p));
            }
            Stage::Animating => {
                set_pending(instance, target, None);
                let actor = instance.find_actor_mut(target).unwrap();
                super::jobs::paladin::toggle_auto_attack(actor, false, ObjectId::default(), true);
                let common = actor.get_common_spawn_mut();
                common.mode = CharacterMode::Normal;
                common.health_points = (common.max_health_points / 5).max(1);
                common.resource_points = common.max_resource_points / 5;
                let statuses = actor.status_effects_mut().unwrap();
                statuses.remove(43);
                statuses.remove(44);
                // 录像中这两个系统状态没有角色施加者，不能归到施术者或受术者。
                statuses.add_with_source(p.weakness, 0, 100.0, ObjectId::default());
                statuses.add_with_source(PROTECTION_STATUS, 0, 5.0, ObjectId::default());
                network.send_ac_in_range_inclusive_instance(
                    instance,
                    target,
                    ActorControlCategory::SetMode {
                        mode: CharacterMode::Normal,
                        mode_arg: 0,
                    },
                );
                network.send_ac_in_range_inclusive_instance(
                    instance,
                    target,
                    ActorControlCategory::SetAutoAttack { auto_attack: false },
                );
                for id in [p.weakness, PROTECTION_STATUS] {
                    network.send_ac_in_range_inclusive_instance(
                        instance,
                        target,
                        ActorControlCategory::GainEffect {
                            effect_id: id.into(),
                            param: 0,
                            source_actor_id: ObjectId(0),
                        },
                    );
                }
                send_effects_list_with(network, instance, target);
                send_hp_mp(network, instance, target);
            }
        }
    }
}

#[cfg(test)]
mod tests;
