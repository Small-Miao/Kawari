//! 固定腐秽大地与独立英雄掠影。施法位置与演员时序不依赖玩家后续移动。
use super::super::{
    native::{self, AreaAttack, Shape},
    white_mage,
};
use super::*;
use crate::{
    FromServer,
    server::{
        action::{action_damage_modifiers, send_area_action_result},
        actor::NpcState,
        network::DestinationNetwork,
    },
};
use kawari::{
    common::{JumpState, MoveAnimationState, MoveAnimationType, ObjectTypeId},
    ipc::zone::{
        ActorControlCategory, BattleNpcSubKind, CharacterDataFlag, DisplayFlag, ObjectKind,
        SpawnNpc, SpawnObject,
    },
};

fn state(instance: &Instance, owner: ObjectId) -> Option<DarkKnightState> {
    if let Some(NetworkedActor::Player { combat_state, .. }) = instance.find_actor(owner) {
        Some(combat_state.dark_knight.clone())
    } else {
        None
    }
}
fn state_mut(instance: &mut Instance, owner: ObjectId) -> Option<&mut DarkKnightState> {
    if let Some(NetworkedActor::Player { combat_state, .. }) = instance.find_actor_mut(owner) {
        Some(&mut combat_state.dark_knight)
    } else {
        None
    }
}
fn cleanup(network: &mut NetworkState, instance: &mut Instance, owner: ObjectId) {
    let Some(s) = state_mut(instance, owner) else {
        return;
    };
    let old = [s.salted_object.take(), s.shadow_actor.take()];
    let had_pet = old[1].is_some();
    s.salted_until = None;
    s.salted_center = None;
    s.salted_next_tick = None;
    s.shadow_started = None;
    s.shadow_until = None;
    for id in old.into_iter().flatten() {
        network.remove_actor(instance, id);
    }
    if had_pet {
        detach_shadow(network, owner);
    }
}
fn detach_shadow(network: &mut NetworkState, owner: ObjectId) {
    network.send_to_by_actor_id(
        owner,
        FromServer::ActorControlSelf(ActorControlCategory::SetupPet {
            owner_id: owner,
            pet_id: 0,
            pet_actor_id: ObjectId(0xE0000000),
            dismiss: 1,
            storage_target: 1,
        }),
        DestinationNetwork::ZoneClients,
    );
    network.send_to_by_actor_id(
        owner,
        FromServer::ActorControlSelf(ActorControlCategory::SetPetParameters {
            pet_id: 0,
            pet_stance: 2,
            pet_guard_mode: 0,
            pet_auto_mode: 0,
            mount_state: 0,
        }),
        DestinationNetwork::ZoneClients,
    );
}
fn field_hit(
    network: &mut NetworkState,
    instance: &mut Instance,
    owner: ObjectId,
    center: Position,
    detonate: bool,
) {
    let captured = state(instance, owner);
    let modifiers = if detonate {
        action_damage_modifiers(instance.find_actor(owner))
    } else {
        captured
            .as_ref()
            .and_then(|s| s.salted_modifiers)
            .unwrap_or_default()
    };
    let snapshot = if detonate {
        None
    } else {
        captured.as_ref().and_then(|s| s.salted_parameters.as_ref())
    };
    let result = native::damage_area_snapshot(
        instance,
        owner,
        AreaAttack {
            center,
            direction: glam::Vec3::Z,
            shape: Shape::Circle(5.0),
            primary: None,
            potency: if detonate { 500 } else { 50 },
            falloff: if detonate { 25 } else { 0 },
            damage_type: DamageType::Magic,
            limit: 32,
        },
        modifiers,
        snapshot,
    );
    if detonate {
        send_area_action_result(
            network,
            instance,
            owner,
            25756,
            ActionRequest {
                action_id: 25756,
                target: ObjectTypeId {
                    object_id: owner,
                    ..Default::default()
                },
                ..Default::default()
            },
            result,
        );
    } else {
        for (target, effects) in result.targets {
            for e in effects {
                if let TargetEffectKind::Damage { amount, .. } = e.0 {
                    network.send_ac_in_range_inclusive_instance(
                        instance,
                        target.object_id,
                        ActorControlCategory::TickDamage {
                            status_id: 749,
                            amount,
                            source_actor_id: owner,
                            unk2: u32::MAX,
                            unk3: 0,
                        },
                    );
                    white_mage::send_hp_mp(network, instance, target.object_id);
                }
            }
        }
    }
}
fn spawn_shadow(
    network: &mut NetworkState,
    instance: &mut Instance,
    owner: ObjectId,
) -> Option<ObjectId> {
    let common = instance.find_actor(owner)?.get_common_spawn();
    let mut spawn = SpawnNpc::default();
    spawn.common.base_id = 10489;
    spawn.common.name_id = 8229;
    spawn.common.model_chara = 2621;
    spawn.common.main_weapon_model = kawari::common::WeaponModelId {
        id: 1599,
        model_type: 1,
        variant: 1,
        stains: [0; 2],
    };
    spawn.common.display_flags = DisplayFlag::from_bits_retain(0x4002B);
    spawn.common.pet_id = 17;
    spawn.common.owner_id = owner;
    spawn.common.object_kind = ObjectKind::BattleNpc(BattleNpcSubKind::Pet);
    spawn.common.level = common.level;
    spawn.common.class_job = 32;
    spawn.common.health_points = common.max_health_points;
    spawn.common.max_health_points = common.max_health_points;
    spawn.common.position = common.position;
    spawn.common.rotation = common.rotation;
    spawn.character_data_flags = CharacterDataFlag::from_bits_retain(1);
    let id = Instance::generate_actor_id();
    instance.insert_npc(id, spawn);
    if let Some(NetworkedActor::Npc {
        state,
        ai_paused,
        targetable,
        currently_invulnerable,
        ..
    }) = instance.find_actor_mut(id)
    {
        *state = NpcState::Stay;
        *ai_paused = true;
        *targetable = false;
        *currently_invulnerable = true;
    }
    network.spawn_inserted_actor_in_range(instance, id);
    network.send_to_by_actor_id(
        owner,
        FromServer::ActorControlSelf(ActorControlCategory::SetupPet {
            owner_id: owner,
            pet_id: 17,
            pet_actor_id: id,
            dismiss: 1,
            storage_target: 1,
        }),
        DestinationNetwork::ZoneClients,
    );
    Some(id)
}
fn shadow_hit(
    network: &mut NetworkState,
    instance: &mut Instance,
    owner: ObjectId,
    pet: ObjectId,
    target: ObjectId,
    step: usize,
) {
    let Some(owner_actor) = instance.find_actor(owner) else {
        return;
    };
    let level = owner_actor.get_common_spawn().level;
    let mut modifiers = action_damage_modifiers(Some(owner_actor));
    // 掠影拥有独立威力，不再次叠加玩家暗黑量谱的伤害提高。
    modifiers.job_damage_percent = 100;
    let Some(victim) = instance.find_actor(target) else {
        return;
    };
    let center = victim.position();
    let Some(pet_actor) = instance.find_actor(pet) else {
        return;
    };
    let mut position = pet_actor.position();
    let direction = center.0 - position.0;
    let rotation = direction.x.atan2(direction.z);
    let action = match step {
        0 => 17904,
        1 => 38512,
        2 => {
            if level >= 90 {
                25881
            } else {
                17907
            }
        }
        3 => 17908,
        4 => 17909,
        _ => {
            if level >= 100 {
                36933
            } else {
                17915
            }
        }
    };
    if step == 1 {
        position = Position(center.0 - direction.normalize_or_zero() * 2.0);
    }
    if let Some(actor) = instance.find_actor_mut(pet) {
        actor.get_common_spawn_mut().position = position;
        actor.get_common_spawn_mut().rotation = rotation;
    }
    network.send_in_range_inclusive_instance(
        pet,
        instance,
        FromServer::ActorMove(
            pet,
            position,
            rotation,
            MoveAnimationType::empty(),
            MoveAnimationState::empty(),
            JumpState::empty(),
        ),
        DestinationNetwork::ZoneClients,
    );
    let request = ActionRequest {
        action_id: action,
        target: ObjectTypeId {
            object_id: target,
            ..Default::default()
        },
        rotation1: rotation,
        ..Default::default()
    };
    let mut result = if step == 1 {
        crate::server::action::area::AreaResult::new(position)
    } else {
        let line = matches!(action, 17907 | 25881 | 36933);
        let p = match action {
            25881 => 570,
            36933 => 620,
            _ => {
                if level >= 88 {
                    420
                } else {
                    340
                }
            }
        };
        native::damage_area(
            instance,
            owner,
            AreaAttack {
                center: if line { position } else { center },
                direction,
                shape: if line {
                    Shape::Line {
                        length: 10.0,
                        width: 4.0,
                    }
                } else {
                    Shape::Circle(if step == 0 { 5.0 } else { 0.1 })
                },
                primary: Some(target),
                potency: p,
                falloff: if matches!(action, 25881 | 36933) {
                    25
                } else {
                    0
                },
                damage_type: if matches!(action, 17909 | 17915 | 36933) {
                    DamageType::Slashing
                } else {
                    DamageType::Magic
                },
                limit: if line || step == 0 { 32 } else { 1 },
            },
            modifiers,
        )
    };
    if step == 1 {
        result.push(target, []);
    }
    if step != 1 {
        for (_, row) in &mut result.targets {
            row[1] = kawari::ipc::zone::TargetEffect(TargetEffectKind::ExecuteCombo {
                sequence: 0,
                unk2: 0,
                unk3: 0,
                unk4: 0,
                unk5: 0x80,
                action_id: action as u16,
            });
        }
    }
    send_area_action_result(network, instance, pet, action, request, result);
}
impl JobActors for DarkKnight {
    fn on_zone_leaving(&self, n: &mut NetworkState, i: &mut Instance, o: ObjectId) {
        cleanup(n, i, o);
        if let Some(s) = i
            .find_actor_mut(o)
            .and_then(NetworkedActor::status_effects_mut)
        {
            s.remove(749);
        }
    }
    fn has_pet_transition_for_action(&self, id: u32) -> bool {
        matches!(id, 3639 | 25755 | 16472)
    }
    fn spawn_pet_after_action(
        &self,
        n: &mut NetworkState,
        i: &mut Instance,
        owner: ObjectId,
        id: u32,
        target: ObjectId,
    ) {
        match id {
            3639 => {
                let Some(position) = i.find_actor(owner).map(|a| a.position()) else {
                    return;
                };
                let object = Instance::generate_actor_id();
                let spawn = SpawnObject {
                    kind: ObjectKind::AreaObject,
                    base_id: 380,
                    entity_id: object,
                    owner_id: owner,
                    radius: 5.0,
                    position,
                    ..Default::default()
                };
                i.insert_object(object, spawn, String::default());
                n.spawn_inserted_object_in_range(i, object);
                let modifiers = action_damage_modifiers(i.find_actor(owner));
                let parameters =
                    if let Some(NetworkedActor::Player { parameters, .. }) = i.find_actor(owner) {
                        Some(parameters.clone())
                    } else {
                        None
                    };
                let Some(s) = state_mut(i, owner) else {
                    return;
                };
                let old = s.salted_object.replace(object);
                s.salted_center = Some(position);
                let placed = Instant::now();
                s.salted_until = Some(placed + Duration::from_secs(15));
                s.salted_next_tick = Some(placed + Duration::from_secs(3));
                s.salted_modifiers = Some(modifiers);
                s.salted_parameters = parameters;
                if let Some(old) = old {
                    n.remove_actor(i, old);
                }
            }
            25755 => {
                if let Some(s) = state(i, owner) {
                    if active(s.salted_until) {
                        if let Some(center) = s.salted_center {
                            field_hit(n, i, owner, center, true);
                        }
                    }
                }
            }
            16472 => {
                if let Some(s) = state_mut(i, owner) {
                    let old = s.shadow_actor.take();
                    s.shadow_started = Some(Instant::now());
                    s.shadow_step = 0;
                    s.shadow_target = Some(target);
                    if let Some(old) = old {
                        n.remove_actor(i, old);
                    }
                }
            }
            _ => {}
        }
    }
    fn on_tick(&self, n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
        let Some(a) = i.find_actor(owner) else {
            return;
        };
        if a.get_common_spawn().health_points == 0 {
            cleanup(n, i, owner);
            return;
        }
        let Some(s) = state(i, owner) else {
            return;
        };
        let now = Instant::now();
        if let Some(end) = s.salted_until {
            if let Some(mut tick) = s.salted_next_tick {
                while tick <= now && tick <= end {
                    if let Some(center) = s.salted_center {
                        field_hit(n, i, owner, center, false);
                    }
                    tick += Duration::from_secs(3);
                }
                if let Some(s) = state_mut(i, owner) {
                    s.salted_next_tick = Some(tick);
                }
            }
            if now >= end {
                if let Some(object) = s.salted_object {
                    n.remove_actor(i, object);
                }
                if let Some(s) = state_mut(i, owner) {
                    s.salted_object = None;
                    s.salted_until = None;
                    s.salted_center = None;
                    s.salted_next_tick = None;
                }
            }
        }
        if let Some(start) = s.shadow_started {
            if !active(s.shadow_until) {
                if let Some(pet) = s.shadow_actor {
                    n.remove_actor(i, pet);
                    detach_shadow(n, owner);
                }
                if let Some(s) = state_mut(i, owner) {
                    s.shadow_actor = None;
                    s.shadow_started = None;
                }
                return;
            }
            let elapsed = now.saturating_duration_since(start).as_millis();
            if s.shadow_actor.is_none() && elapsed >= 817 {
                if let Some(pet) = spawn_shadow(n, i, owner) {
                    if let Some(s) = state_mut(i, owner) {
                        s.shadow_actor = Some(pet);
                    }
                }
                return;
            }
            let times = [6934, 9084, 11317, 13416, 15601, 17817];
            if s.shadow_step < times.len() && elapsed >= times[s.shadow_step] {
                let valid = |id| matches!(i.find_actor(id),Some(NetworkedActor::Npc{spawn,targetable:true,currently_invulnerable:false,..})if spawn.common.health_points>0&&spawn.common.owner_id!=owner);
                let target = s.shadow_target.filter(|id| valid(*id)).or_else(|| {
                    i.actors.iter().find_map(|(id, a)| {
                        if valid(*id) && a.npc_hate_list().is_some_and(|h| h.contains_key(&owner)) {
                            Some(*id)
                        } else {
                            None
                        }
                    })
                });
                if let (Some(pet), Some(target)) = (s.shadow_actor, target) {
                    shadow_hit(n, i, owner, pet, target, s.shadow_step);
                    if let Some(s) = state_mut(i, owner) {
                        s.shadow_step += 1;
                        s.shadow_target = Some(target);
                    }
                }
            }
        }
    }
    fn on_job_deactivated(&self, n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
        cleanup(n, i, owner);
        if let Some(a) = i.find_actor_mut(owner) {
            super::super::paladin::deactivate(a);
            if let NetworkedActor::Player {
                combat_state,
                status_effects,
                ..
            } = a
            {
                combat_state.dark_knight = Default::default();
                for id in [
                    742, 743, 746, 747, 749, 810, 811, 1178, 1972, 2682, 3255, 3835, 3836, 3837,
                    3902,
                ] {
                    status_effects.remove(id);
                }
            }
        }
    }
}
