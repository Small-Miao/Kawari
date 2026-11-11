//! 画家技能结算、星空领域、队伍屏障及派生治疗。
use super::*;
use crate::{
    FromServer,
    lua::{BarrierAction, EffectsBuilder},
    server::{
        action::{
            area::{AreaResult, party_in_range},
            send_area_action_result,
        },
        effect::send_effects_list_with,
        instance::Instance,
        network::{DestinationNetwork, NetworkState},
    },
};
use kawari::{
    common::ObjectTypeId,
    ipc::zone::{
        ActionType, ActorControlCategory, DamageElement, DamageType, ObjectKind, SpawnObject,
        TargetEffect, TargetEffectKind,
    },
};

fn gain(id: u16, param: u16, duration: f32, on_self: bool) -> TargetEffect {
    TargetEffect(if on_self {
        TargetEffectKind::GainEffectSelf {
            unk1: 0,
            unk2: 0,
            param,
            unk3: 0,
            effect_id: id,
            duration,
        }
    } else {
        TargetEffectKind::GainEffect {
            unk1: 0,
            unk2: 0,
            param,
            unk3: 0,
            effect_id: id,
            duration,
        }
    })
}
pub(crate) fn action_effects(action: u32, actor: &NetworkedActor) -> Option<EffectsBuilder> {
    if !data::is_job_action(action) {
        return None;
    }
    let NetworkedActor::Player {
        parameters,
        spawn,
        combat_state,
        ..
    } = actor
    else {
        return None;
    };
    let level = spawn.common.level;
    let mut b = EffectsBuilder::default();
    let potency = data::potency(action, level);
    if potency > 0 {
        let element = match action {
            34650 | 34656 => DamageElement::Fire,
            34651 | 34657 => DamageElement::Air,
            34652 | 34658 => DamageElement::Water,
            34653 | 34659 => DamageElement::Ice,
            34654 | 34660 => DamageElement::Earth,
            34655 | 34661 => DamageElement::Lightning,
            _ => DamageElement::Unaspected,
        };
        b.effects.push(TargetEffect(TargetEffectKind::Damage {
            damage_kind: Default::default(),
            damage_type: DamageType::Magic,
            damage_element: element,
            bonus_percent: 0,
            unk3: 0,
            unk4: 0,
            amount: parameters.calc_magical_damage(potency),
        }));
    }
    if let Some((_, hue)) = color(action) {
        if hue < 2 {
            b.effects
                .push(gain(if hue == 0 { HUE } else { HUE_II }, 0, 30.0, true));
        }
    }
    match action {
        34674 => b.effects.push(gain(HAMMER, 3, 30.0, true)),
        34675 => {
            b.effects.push(gain(STARRY, 0, 20.0, true));
            b.effects.push(gain(SPECTRUM, 0, 30.0, true));
            if level >= 82 {
                b.effects.push(gain(HYPER, 5, 30.0, true));
            }
            if level >= 100 {
                b.effects.push(gain(STARSTRUCK, 0, 20.0, true));
            }
        }
        34683 => {
            b.effects.push(gain(SUBTRACTIVE, 3, 0.0, true));
            if level >= 90 {
                b.effects.push(gain(MONOCHROME, 0, 0.0, true));
            }
        }
        34684 if level >= 84 => b.effects.push(gain(SMUDGE, 30, 5.0, true)),
        34685 => {
            b.effects.push(gain(COAT, 0, 10.0, true));
            b.barrier_actions.push(BarrierAction {
                effect_id: COAT,
                param: 0,
                duration: 10.0,
                amount: spawn.common.max_health_points / 5,
                on_self: true,
            });
        }
        _ => {}
    }
    // 录像中的量谱演出参数，与 ActorGauge 的持久状态分开下发。
    let mut marker = |value: u16, param: u8| {
        b.effects.push(TargetEffect(TargetEffectKind::Unknown {
            magic: 62,
            param0: param,
            param1: 0,
            param2: 0,
            param3: 0,
            param4: 0x80,
            value,
        }))
    };
    match action {
        34652 | 34658 => {
            if level >= 60 {
                marker(308, 25);
            }
            if level >= 80 {
                marker(309, 1);
            }
        }
        34655 | 34661 | 34688 if level >= 80 => marker(309, 1),
        34664..=34669 => marker(311, 1 << (action - 34664)),
        34670..=34673 => {
            marker(312, 1 << (action - 34670));
            if action == 34671 {
                marker(312, 16);
            }
            if action == 34673 {
                marker(312, 32);
            }
        }
        _ => {}
    }
    if matches!(action, 34670..=34673 | 34681) {
        b.effects.push(TargetEffect(TargetEffectKind::Teleport {
            unk: [0; 5],
            territory: 0,
        }));
    }
    if matches!(action, 34674 | 34678..=34680) {
        b.effects.push(TargetEffect(TargetEffectKind::ExecuteCombo {
            sequence: u8::from(action >= 34679),
            unk2: 0,
            unk3: 0,
            unk4: 0,
            unk5: 0x80,
            action_id: action as u16,
        }));
    }
    let _ = combat_state;
    Some(b)
}

pub(crate) fn support_result(
    network: &NetworkState,
    instance: &mut Instance,
    owner: ObjectId,
    action: u32,
) -> Option<AreaResult> {
    if !matches!(action, 34675 | 34686) {
        return None;
    }
    let actor = instance.find_actor(owner)?;
    let center = actor.position();
    let level = actor.get_common_spawn().level;
    let shield = actor.get_common_spawn().max_health_points / 10;
    let mut result = AreaResult::new(center);
    for id in party_in_range(network, instance, owner, center.0, 30.0) {
        let actor = instance.find_actor_mut(id).unwrap();
        let cap = actor.get_common_spawn().max_health_points;
        let status = actor.status_effects_mut().unwrap();
        if action == 34686 {
            status.add_barrier(GRASSA, 0, 10.0, shield, owner, cap);
            result.push(id, [gain(GRASSA, 0, 10.0, false)]);
        } else {
            status.add_with_source(STARRY, 0, 20.0, owner);
            let mut entries = vec![gain(STARRY, 0, 20.0, false)];
            if id == owner {
                entries.push(gain(SPECTRUM, 0, 30.0, true));
                if level >= 82 {
                    entries.push(gain(HYPER, 5, 30.0, true));
                }
                if level >= 100 {
                    entries.push(gain(STARSTRUCK, 0, 20.0, true));
                }
            }
            result.push(id, entries);
        }
    }
    Some(result)
}

pub(crate) fn finish_action(
    network: &mut NetworkState,
    instance: &mut Instance,
    owner: ObjectId,
    action: u32,
    target: ObjectId,
) {
    if action == 34675 {
        let Some(actor) = instance.find_actor(owner) else {
            return;
        };
        let center = actor.position();
        let object = loop {
            let id = ObjectId(fastrand::u32(0x4000_0000..0x5000_0000));
            if !instance.actors.contains_key(&id) {
                break id;
            }
        };
        // 录像 49.079s ObjectSpawn：VFX#1759、半径 8、标志 4。
        instance.insert_object(
            object,
            SpawnObject {
                kind: ObjectKind::AreaObject,
                base_id: 1759,
                entity_id: object,
                owner_id: owner,
                extra_flags: 4,
                radius: 8.0,
                position: center,
                ..Default::default()
            },
            String::new(),
        );
        if let Some(NetworkedActor::Player { combat_state, .. }) = instance.find_actor_mut(owner) {
            combat_state.pictomancer.field_object = Some(object);
        }
        network.spawn_inserted_object_in_range(instance, object);
        refresh_field(network, instance, owner);
    } else if action == 34681 {
        let center = instance
            .find_actor(target)
            .map(NetworkedActor::position)
            .unwrap_or_default();
        let Some(NetworkedActor::Player { parameters, .. }) = instance.find_actor(owner) else {
            return;
        };
        let amount = parameters.calc_heal_amount(400);
        let healed = super::super::white_mage::fan_out_aoe_heal(
            network, instance, owner, 0, center.0, 30.0, amount, 1.0,
        );
        let mut result = AreaResult::new(center);
        for (id, amount) in healed {
            result.push(
                id,
                [TargetEffect(TargetEffectKind::Heal {
                    unk1: [0; 5],
                    amount,
                })],
            );
        }
        send_area_action_result(
            network,
            instance,
            owner,
            34682,
            ActionRequest {
                target: ObjectTypeId {
                    object_id: owner,
                    ..Default::default()
                },
                action_type: ActionType::Action,
                ..Default::default()
            },
            result,
        );
    }
}

pub(crate) fn refresh_field(network: &mut NetworkState, instance: &mut Instance, owner: ObjectId) {
    let Some(NetworkedActor::Player {
        combat_state,
        status_effects,
        spawn,
        ..
    }) = instance.find_actor_mut(owner)
    else {
        return;
    };
    let state = &mut combat_state.pictomancer;
    let now = Instant::now();
    let exists = active(state.field_until, now) && spawn.common.health_points > 0;
    let inside = exists
        && state.hyper > 0
        && active(state.hyper_until, now)
        && state
            .field_center
            .is_some_and(|center| center.0.distance(spawn.common.position.0) <= 8.0);
    let previous = state.inspired;
    state.inspired = inside;
    if inside && status_effects.get(INSPIRATION).is_none() {
        status_effects.add_with_source(INSPIRATION, 0, 5.0, owner);
    }
    // 站在领域内续期，离开立即失效；领域以服务器位置作判定。
    if inside
        && status_effects
            .get(INSPIRATION)
            .is_some_and(|s| s.duration < 2.0)
    {
        status_effects.add_with_source(INSPIRATION, 0, 5.0, owner);
    }
    if !inside {
        status_effects.remove(INSPIRATION);
    }
    let removed = if !exists {
        state.field_center = None;
        state.field_until = None;
        state.field_object.take()
    } else {
        None
    };
    if previous != inside {
        send_effects_list_with(network, instance, owner);
    }
    if let Some(object) = removed {
        network.remove_actor(instance, object);
    }
}

pub(crate) fn deactivate(actor: &mut NetworkedActor) -> Option<ObjectId> {
    let NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    } = actor
    else {
        return None;
    };
    let state = std::mem::take(&mut combat_state.pictomancer);
    for id in [
        SUBTRACTIVE,
        HUE,
        HUE_II,
        RAINBOW,
        HAMMER,
        STARSTRUCK,
        SMUDGE,
        STARRY,
        COAT,
        GRASSA,
        HYPER,
        INSPIRATION,
        SPECTRUM,
        MONOCHROME,
    ] {
        status_effects.remove(id);
    }
    state.field_object
}

pub(crate) fn on_barrier_break(
    network: &mut NetworkState,
    instance: &mut Instance,
    owner: ObjectId,
) {
    let Some(NetworkedActor::Player {
        status_effects,
        spawn,
        ..
    }) = instance.find_actor_mut(owner)
    else {
        return;
    };
    let broken = status_effects.take_broken_barriers();
    let class_job = spawn.common.class_job;
    let caress_source = broken
        .iter()
        .find(|(id, _)| *id == 3903)
        .map(|(_, source)| *source);
    if let Some(source) = caress_source {
        super::super::white_mage::grant_divine_caressed(network, instance, owner, source);
    }
    for (_,source) in broken.iter().filter(|(id,_)|*id==1178) {
        super::super::dark_knight::barrier_broken(network,instance,*source);
    }
    for (id,source) in &broken {
        if *id==2597{super::super::reaper::barrier_broken(network,instance,*source);}
        if matches!(*id,2607|2609|2612|2613){super::super::sage::barrier_broken(network,instance,owner,*id,*source);}
    }
    let Some(NetworkedActor::Player { combat_state, .. }) = instance.find_actor_mut(owner) else {
        return;
    };
    if class_job != 42 {
        return;
    }
    let seconds = if broken.contains(&(COAT, owner)) {
        combat_state.pictomancer.coat_until = None;
        60
    } else if broken.contains(&(GRASSA, owner)) {
        30
    } else {
        return;
    };
    let Some(group) = combat_state
        .cooldowns
        .iter()
        .position(|c| c.as_ref().is_some_and(|c| c.action_id == 34685))
    else {
        return;
    };
    if let Some((elapsed_centisec, total_centisec)) =
        combat_state.reduce_cooldown_recovery(group, Duration::from_secs(seconds))
    {
        network.send_to_by_actor_id(
            owner,
            FromServer::ActorControlSelf(ActorControlCategory::SetCooldownTimer {
                cooldown_group: group as u32,
                elapsed_centisec,
                total_centisec,
            }),
            DestinationNetwork::ZoneClients,
        );
    }
}
