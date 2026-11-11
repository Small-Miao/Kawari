use super::super::{
    dispatch::send_job_gauge_update,
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
        ActorControlCategory, BattleNpcSubKind, CharacterDataFlag, DamageType, DisplayFlag,
        ObjectKind, SpawnNpc, TargetEffectKind,
    },
};

fn state(i: &Instance, owner: ObjectId) -> Option<MachinistState> {
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(owner) {
        Some(combat_state.machinist.clone())
    } else {
        None
    }
}
fn state_mut(i: &mut Instance, owner: ObjectId) -> Option<&mut MachinistState> {
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(owner) {
        Some(&mut combat_state.machinist)
    } else {
        None
    }
}
pub(super) fn reduce_shots(n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
    for group in [14, 15] {
        if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(owner) {
            combat_state.reduce_cooldown_recovery(group, Duration::from_secs(15));
        }
        n.send_to_by_actor_id(
            owner,
            FromServer::ActorControlSelf(ActorControlCategory::IncrementRecast {
                cooldown_group: group as u32,
                delta_time_centisec: 1500,
            }),
            DestinationNetwork::ZoneClients,
        );
    }
}
fn detach(n: &mut NetworkState, owner: ObjectId) {
    n.send_to_by_actor_id(
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
}
fn remove_pet(n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
    if let Some(p) = state_mut(i, owner).and_then(|s| s.pet.take()) {
        if let Some(id) = p.actor {
            n.remove_actor(i, id);
        }
        detach(n, owner);
    }
}
fn cleanup(n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
    remove_pet(n, i, owner);
    let wildfire = state_mut(i, owner).and_then(|s| {
        s.flame = None;
        s.wildfire.take()
    });
    if let Some(w) = wildfire {
        if let Some(s) = i
            .find_actor_mut(w.target)
            .and_then(NetworkedActor::status_effects_mut)
        {
            if s.get(861).is_some_and(|b| b.source_actor_id == owner) {
                s.remove(861);
            }
        }
    }
    if let Some(a) = i.find_actor_mut(owner) {
        if let NetworkedActor::Player {
            combat_state,
            status_effects,
            ..
        } = a
        {
            combat_state.machinist = Default::default();
            for id in [851, 1205, 1946, 2688, 3864, 3865, 3866] {
                status_effects.remove(id);
            }
        }
    }
}
pub(in crate::server) fn take_for_zone(n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
    cleanup(n, i, owner);
}
fn detonate(n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
    let Some(w) = state_mut(i, owner).and_then(|s| s.wildfire.take()) else {
        return;
    };
    let amount = if let Some(
        a @ NetworkedActor::Player {
            parameters, spawn, ..
        },
    ) = i.find_actor(owner)
    {
        let p = u32::from(w.hits) * if spawn.common.level >= 78 { 240 } else { 100 };
        let base =
            action_damage_modifiers(Some(a)).apply_base_damage(parameters.calc_physical_damage(p));
        // 野火使用独立 TickDamage 通知，不能暴击/直击，也不计入自己的战技次数。
        (base as f64 * (0.95 + fastrand::f64() * 0.10)) as u32
    } else {
        0
    };
    if let Some(s) = i
        .find_actor_mut(owner)
        .and_then(NetworkedActor::status_effects_mut)
    {
        s.remove(1946);
    }
    let Some(a) = i.find_actor_mut(w.target) else {
        return;
    };
    let valid = a.get_common_spawn().health_points > 0
        && !matches!(
            a,
            NetworkedActor::Npc {
                currently_invulnerable: true,
                ..
            }
        );
    if let Some(s) = a.status_effects_mut() {
        if s.get(861).is_some_and(|s| s.source_actor_id == owner) {
            s.remove(861);
        }
    }
    if !valid || amount == 0 {
        return;
    }
    a.apply_damage(amount);
    if let Some(hate) = a.npc_hate_list_mut() {
        let h = hate.entry(owner).or_default();
        *h = h.saturating_add(amount);
    }
    crate::server::director::notify_attack_hit(i, owner, w.target, amount);
    n.send_ac_in_range_inclusive_instance(
        i,
        w.target,
        ActorControlCategory::TickDamage {
            status_id: 861,
            amount,
            source_actor_id: owner,
            unk2: u32::MAX,
            unk3: 0,
        },
    );
    white_mage::send_hp_mp(n, i, w.target);
}
fn flame_tick(n: &mut NetworkState, i: &mut Instance, owner: ObjectId, f: &Flame) {
    let mods = action_damage_modifiers(i.find_actor(owner));
    let r = native::damage_area(
        i,
        owner,
        AreaAttack {
            center: f.position,
            direction: glam::Vec3::new(f.rotation.sin(), 0.0, f.rotation.cos()),
            shape: Shape::Cone {
                radius: 12.0,
                half_angle: std::f32::consts::FRAC_PI_4,
            },
            primary: None,
            potency: 120,
            falloff: 0,
            damage_type: DamageType::Piercing,
            limit: 32,
        },
        mods,
    );
    for (id, row) in r.targets {
        for e in row {
            if let TargetEffectKind::Damage { amount, .. } = e.0 {
                n.send_ac_in_range_inclusive_instance(
                    i,
                    id.object_id,
                    ActorControlCategory::TickDamage {
                        status_id: 1205,
                        amount,
                        source_actor_id: owner,
                        unk2: u32::MAX,
                        unk3: 0,
                    },
                );
                white_mage::send_hp_mp(n, i, id.object_id);
            }
        }
    }
}
fn spawn_robot(
    n: &mut NetworkState,
    i: &mut Instance,
    owner: ObjectId,
    queen: bool,
) -> Option<ObjectId> {
    let c = i.find_actor(owner)?.get_common_spawn();
    let mut spawn = SpawnNpc::default();
    // 模型目录只提供检索线索；Base/Model/Name 已经由当前国服 SqPack 校验。
    spawn.common.base_id = if queen { 10490 } else { 3256 };
    spawn.common.name_id = if queen { 8230 } else { 3666 };
    spawn.common.model_chara = if queen { 2618 } else { 1027 };
    spawn.common.pet_id = if queen { 18 } else { 8 };
    spawn.common.owner_id = owner;
    spawn.common.object_kind = ObjectKind::BattleNpc(BattleNpcSubKind::Pet);
    spawn.common.display_flags = DisplayFlag::from_bits_retain(0x4002B);
    spawn.character_data_flags = CharacterDataFlag::from_bits_retain(1);
    spawn.common.class_job = 31;
    spawn.common.level = c.level;
    spawn.common.health_points = c.max_health_points;
    spawn.common.max_health_points = c.max_health_points;
    spawn.common.position = c.position;
    spawn.common.rotation = c.rotation;
    let id = Instance::generate_actor_id();
    i.insert_npc(id, spawn);
    if let Some(NetworkedActor::Npc {
        state,
        ai_paused,
        targetable,
        currently_invulnerable,
        ..
    }) = i.find_actor_mut(id)
    {
        *state = NpcState::Stay;
        *ai_paused = true;
        *targetable = false;
        *currently_invulnerable = true;
    }
    n.spawn_inserted_actor_in_range(i, id);
    n.send_to_by_actor_id(
        owner,
        FromServer::ActorControlSelf(ActorControlCategory::SetupPet {
            owner_id: owner,
            pet_id: if queen { 18 } else { 8 },
            pet_actor_id: id,
            dismiss: 1,
            storage_target: 1,
        }),
        DestinationNetwork::ZoneClients,
    );
    Some(id)
}
fn pet_hit(
    n: &mut NetworkState,
    i: &mut Instance,
    owner: ObjectId,
    pet: ObjectId,
    target: ObjectId,
    action: u32,
    spent: u8,
) {
    let Some(pos) = i.find_actor(target).map(NetworkedActor::position) else {
        return;
    };
    let Some(a) = i.find_actor(pet) else {
        return;
    };
    let mut own = a.position();
    let delta = pos.0 - own.0;
    let rotation = delta.x.atan2(delta.z);
    if matches!(action, 17206 | 16504 | 16503 | 25787) {
        own = Position(pos.0 - delta.normalize_or_zero() * 2.0);
    }
    if let Some(a) = i.find_actor_mut(pet) {
        a.get_common_spawn_mut().position = own;
        a.get_common_spawn_mut().rotation = rotation;
    }
    n.send_in_range_inclusive_instance(
        pet,
        i,
        FromServer::ActorMove(
            pet,
            own,
            rotation,
            MoveAnimationType::empty(),
            MoveAnimationState::empty(),
            JumpState::empty(),
        ),
        DestinationNetwork::ZoneClients,
    );
    let p = match action {
        17206 => 240,
        16504 => 120,
        16503 => 340,
        25787 => 390,
        2891 => 35,
        7416 => 160,
        _ => 0,
    } * u32::from(spent)
        / 50;
    let mods = action_damage_modifiers(i.find_actor(owner));
    let r = native::damage_area(
        i,
        owner,
        AreaAttack {
            center: pos,
            direction: delta,
            shape: Shape::Circle(0.01),
            primary: Some(target),
            potency: p,
            falloff: 0,
            damage_type: DamageType::Piercing,
            limit: 1,
        },
        mods,
    );
    send_area_action_result(
        n,
        i,
        pet,
        action,
        ActionRequest {
            action_id: action,
            target: ObjectTypeId {
                object_id: target,
                ..Default::default()
            },
            rotation1: rotation,
            ..Default::default()
        },
        r,
    );
    white_mage::send_hp_mp(n, i, target);
}
fn finish(s: &mut Robot, now: Instant) {
    if !s.finisher {
        s.finisher = true;
        s.step = 0;
        s.next = now;
    }
}
impl JobActors for Machinist {
    fn has_pet_transition_for_action(&self, _: u32) -> bool {
        true
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
            16766 => detonate(n, i, owner),
            2864 | 16501 => {
                if let Some(p) = state_mut(i, owner).and_then(|s| s.pet.as_mut()) {
                    p.target = Some(target);
                }
            }
            7415 | 16502 => {
                if let Some(p) = state_mut(i, owner).and_then(|s| s.pet.as_mut()) {
                    finish(p, Instant::now());
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
        let pos = a.position();
        let rot = a.get_common_spawn().rotation;
        let l = a.get_common_spawn().level;
        let Some(s) = state(i, owner) else {
            return;
        };
        let now = Instant::now();
        if s.wildfire.as_ref().is_some_and(|w| now >= w.end) {
            detonate(n, i, owner);
        }
        if let Some(mut f) = s.flame {
            let moved =
                pos.0.distance_squared(f.position.0) > 0.0001 || (rot - f.rotation).cos() < 0.9999;
            if !moved {
                while f.next <= now && f.next <= f.end {
                    flame_tick(n, i, owner, &f);
                    f.next += Duration::from_secs(1);
                }
            }
            if let Some(NetworkedActor::Player {
                combat_state,
                status_effects,
                ..
            }) = i.find_actor_mut(owner)
            {
                if moved || now >= f.end {
                    combat_state.machinist.flame = None;
                    status_effects.remove(1205);
                } else {
                    combat_state.machinist.flame = Some(f);
                }
            }
        }
        if let Some(mut p) = s.pet {
            if p.remove_at.is_some_and(|t| now >= t) {
                remove_pet(n, i, owner);
            } else {
                if p.actor.is_none() && now.duration_since(p.start) >= Duration::from_millis(666) {
                    p.actor = spawn_robot(n, i, owner, p.queen);
                }
                let valid = |id| matches!(i.find_actor(id),Some(a@NetworkedActor::Npc{targetable:true,currently_invulnerable:false,..})if a.get_common_spawn().health_points>0&&!a.get_common_spawn().owner_id.is_valid());
                let auto = if let Some(NetworkedActor::Player { combat_state, .. }) =
                    i.find_actor(owner)
                {
                    combat_state.paladin.auto_target
                } else {
                    None
                };
                p.target = p
                    .target
                    .filter(|id| valid(*id))
                    .or(auto.filter(|id| valid(*id)))
                    .or_else(|| {
                        i.actors.iter().find_map(|(id, a)| {
                            if valid(*id)
                                && a.npc_hate_list().is_some_and(|h| h.contains_key(&owner))
                            {
                                Some(*id)
                            } else {
                                None
                            }
                        })
                    });
                if now >= p.end {
                    finish(&mut p, now);
                }
                if now >= p.next && p.remove_at.is_none() {
                    if let (Some(actor), Some(target)) = (p.actor, p.target) {
                        let action = if p.finisher {
                            if p.queen {
                                if p.step == 0 { 16503 } else { 25787 }
                            } else {
                                7416
                            }
                        } else if p.queen {
                            if p.step == 0 { 17206 } else { 16504 }
                        } else {
                            2891
                        };
                        pet_hit(n, i, owner, actor, target, action, s.spent);
                        p.step += 1;
                        if p.finisher {
                            if p.queen && l >= 86 && p.step == 1 {
                                p.next = now + Duration::from_millis(2100);
                            } else {
                                p.remove_at = Some(now + Duration::from_secs(5));
                            }
                        } else {
                            p.next = now
                                + Duration::from_millis(if action == 17206 {
                                    3000
                                } else if p.queen {
                                    1500
                                } else {
                                    3000
                                });
                        }
                    } else if now >= p.end {
                        p.remove_at = Some(now);
                    }
                }
                if let Some(s) = state_mut(i, owner) {
                    s.pet = Some(p);
                }
            }
            if let Some(s) = state(i, owner) {
                send_job_gauge_update(n, owner, 31, s.pack(l));
            }
        }
    }
    fn on_job_deactivated(&self, n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
        cleanup(n, i, owner);
        if let Some(a) = i.find_actor_mut(owner) {
            super::super::paladin::deactivate(a);
        }
    }
}
