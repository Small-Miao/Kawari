//! 仙女指令、跟随、持续治疗和野战治疗阵。宠物效果包以宠物为施法者。
use super::super::{native::status, white_mage};
use super::*;
use crate::{
    FromServer, TickEffectKind,
    server::{
        action::{
            area::{AreaResult, party_in_range},
            send_area_action_result,
        },
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

fn state(i: &Instance, id: ObjectId) -> Option<ScholarState> {
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(id) {
        Some(combat_state.scholar.clone())
    } else {
        None
    }
}
fn state_mut(i: &mut Instance, id: ObjectId) -> Option<&mut ScholarState> {
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(id) {
        Some(&mut combat_state.scholar)
    } else {
        None
    }
}
fn gauge(n: &mut NetworkState, i: &Instance, owner: ObjectId) {
    if let Some(NetworkedActor::Player {
        combat_state,
        spawn,
        ..
    }) = i.find_actor(owner)
    {
        super::super::dispatch::send_job_gauge_update(
            n,
            owner,
            28,
            combat_state.scholar.pack(spawn.common.level),
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
            dismiss: 0,
            storage_target: 0,
        }),
        DestinationNetwork::ZoneClients,
    );
}
fn stop_tether(n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
    if let Some(s) = state(i, owner) {
        if let Some(id) = s.tether {
            if let Some(a) = i.find_actor_mut(id) {
                if let Some(status) = a.status_effects_mut() {
                    status.remove(1223);
                }
            }
            crate::server::effect::send_effects_list_with(n, i, id);
        }
        if let Some(pet) = s.fairy {
            if let Some(a) = i.find_actor_mut(pet) {
                if let Some(status) = a.status_effects_mut() {
                    status.remove(1222);
                }
            }
        }
    }
    if let Some(s) = state_mut(i, owner) {
        s.tether = None;
    }
}
fn remove_fairy(n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
    stop_tether(n, i, owner);
    let old = state_mut(i, owner).and_then(|s| s.fairy.take());
    if let Some(id) = old {
        n.remove_actor(i, id);
        detach(n, owner);
    }
}
fn spawn_fairy(n: &mut NetworkState, i: &mut Instance, owner: ObjectId, seraph: bool) {
    remove_fairy(n, i, owner);
    let Some(a) = i.find_actor(owner) else {
        return;
    };
    let common = a.get_common_spawn().clone();
    let carried = state_mut(i, owner).and_then(|s| s.carried_fairy.take());
    let mut spawn = SpawnNpc::default();
    spawn.common.base_id = if seraph { 10487 } else { 1009 };
    spawn.common.name_id = if seraph { 8227 } else { 1398 };
    spawn.common.model_chara = if seraph { 2619 } else { 408 };
    spawn.common.pet_id = if seraph { 15 } else { 6 };
    let id = if let Some(carried) = carried {
        spawn = carried.spawn;
        carried.actor_id
    } else {
        Instance::generate_actor_id()
    };
    spawn.common.owner_id = owner;
    spawn.common.object_kind = ObjectKind::BattleNpc(BattleNpcSubKind::Pet);
    spawn.common.class_job = 28;
    spawn.common.level = common.level;
    spawn.common.max_health_points = common.max_health_points;
    spawn.common.health_points = common.max_health_points;
    spawn.common.position = Position(common.position.0 + glam::Vec3::new(1.5, 0.0, 1.5));
    spawn.common.rotation = common.rotation;
    spawn.common.display_flags = DisplayFlag::from_bits_retain(0x4002B);
    spawn.character_data_flags = CharacterDataFlag::from_bits_retain(1);
    let kind = spawn.common.pet_id;
    i.insert_npc(id, spawn);
    if let Some(NetworkedActor::Npc {
        state,
        ai_paused,
        targetable,
        currently_invulnerable,
        ..
    }) = i.find_actor_mut(id)
    {
        *state = NpcState::Follow;
        *ai_paused = true;
        *targetable = false;
        *currently_invulnerable = true;
    }
    n.spawn_inserted_actor_in_range(i, id);
    n.send_to_by_actor_id(
        owner,
        FromServer::ActorControlSelf(ActorControlCategory::SetupPet {
            owner_id: owner,
            pet_id: kind as u32,
            pet_actor_id: id,
            dismiss: 1,
            storage_target: 1,
        }),
        DestinationNetwork::ZoneClients,
    );
    n.send_to_by_actor_id(
        owner,
        FromServer::ActorControlSelf(ActorControlCategory::SetPetParameters {
            pet_id: kind as u32,
            pet_stance: 2,
            pet_guard_mode: 0,
            pet_auto_mode: 0,
            mount_state: 0,
        }),
        DestinationNetwork::ZoneClients,
    );
    if let Some(s) = state_mut(i, owner) {
        s.fairy = Some(id);
        if !seraph {
            s.fairy_kind = kind as u16;
        }
        s.next_fairy_tick = deadline(3);
    }
    gauge(n, i, owner);
}
fn pet_action(
    n: &mut NetworkState,
    i: &mut Instance,
    owner: ObjectId,
    pet: ObjectId,
    action: u32,
    target: Option<ObjectId>,
) {
    let Some(a) = i.find_actor(owner) else {
        return;
    };
    let NetworkedActor::Player { parameters, .. } = a else {
        return;
    };
    let parameters = parameters.clone();
    let level = a.get_common_spawn().level;
    let Some(p) = i.find_actor(pet) else {
        return;
    };
    let center = p.position();
    let mut r = AreaResult::new(center);
    let ids = if let Some(target) = target {
        vec![target]
    } else {
        party_in_range(
            n,
            i,
            owner,
            center.0,
            if matches!(action, 803 | 16550 | 16544) {
                20.0
            } else {
                30.0
            },
        )
    };
    for id in ids.into_iter().take(32) {
        let Some(a) = i.find_actor(id) else {
            continue;
        };
        if a.get_common_spawn().health_points == 0 {
            continue;
        }
        match action {
            803 | 16550 => {
                let buff = if action == 803 { 315 } else { 1874 };
                let s = i.find_actor_mut(id).unwrap().status_effects_mut().unwrap();
                s.add_tick(buff, 0, 21.0, TickEffectKind::Heal, 80, None, pet);
                s.set_tick_stat_source(buff, pet, owner);
                r.push(id, [status(buff, 0, 21.0, false)]);
            }
            805 | 16551 => {
                let buff = if action == 805 { 317 } else { 1875 };
                let s = i.find_actor_mut(id).unwrap().status_effects_mut().unwrap();
                s.remove(if buff == 317 { 1875 } else { 317 });
                s.add_with_source(buff, 0, 20.0, pet);
                r.push(id, [status(buff, 0, 20.0, false)]);
            }
            _ => {
                let potency = match action {
                    7438 => 300,
                    16544 => 320,
                    16547 => 250,
                    _ => {
                        if level >= 85 {
                            180
                        } else {
                            150
                        }
                    }
                };
                let (base, critical) = parameters.roll_heal_amount(potency, false);
                let amount = (base as f64 * white_mage::incoming_heal_multiplier(Some(a))) as u32;
                effects::restore(i, owner, id, amount);
                let mut e = vec![effects::critical_heal(amount, critical)];
                if matches!(action, 16547 | 16548) {
                    e.push(
                        if effects::shield(i.find_actor_mut(id).unwrap(), 1917, amount, 30.0, pet) {
                            status(1917, 0, 30.0, false)
                        } else {
                            super::super::native::heal(0, false)
                        },
                    );
                }
                r.push(id, e);
                white_mage::send_hp_mp(n, i, id);
            }
        }
    }
    send_area_action_result(
        n,
        i,
        pet,
        action,
        ActionRequest {
            action_id: action,
            target: ObjectTypeId {
                object_id: target.unwrap_or(pet),
                ..Default::default()
            },
            ..Default::default()
        },
        r,
    );
}
fn aura(n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
    let Some(s) = state(i, owner) else {
        return;
    };
    let Some(a) = i.find_actor(owner) else {
        return;
    };
    let level = a.get_common_spawn().level;
    let pos = a.position();
    if active(s.soil_until) {
        if let Some(center) = s.soil_center {
            for id in party_in_range(n, i, owner, center.0, 15.0) {
                if let Some(a) = i.find_actor_mut(id) {
                    if let Some(buff) = a.status_effects_mut() {
                        if level >= 78 {
                            buff.add_tick(299, 10, 3.5, TickEffectKind::Heal, 100, None, owner);
                        } else {
                            buff.add_with_source(299, 10, 3.5, owner);
                        }
                    }
                }
            }
        }
    }
    if active(s.seraphism_until) {
        for id in party_in_range(n, i, owner, pos.0, 50.0) {
            if let Some(a) = i.find_actor_mut(id) {
                if let Some(buff) = a.status_effects_mut() {
                    buff.add_tick(3885, 0, 3.5, TickEffectKind::Heal, 100, None, owner);
                }
            }
        }
    }
}
impl JobActors for Scholar {
    fn sync_pet_for_mount(&self, n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
        stop_tether(n, i, owner);
        super::super::summoner::sync_pet_for_mount(n, i, owner);
    }
    fn has_pet_transition_for_action(&self, id: u32) -> bool {
        matches!(
            id,
            17215 | 3587 | 16545 | 16537 | 16538 | 16543 | 16546 | 7437 | 7869 | 188 | 37014
        )
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
            17215 => spawn_fairy(n, i, owner, false),
            3587 => {
                remove_fairy(n, i, owner);
                gauge(n, i, owner);
            }
            16545 => spawn_fairy(n, i, owner, true),
            16537 | 16538 | 16543 | 16546 => {
                if let Some(s) = state(i, owner) {
                    if let Some(pet) = s.fairy {
                        let action = match id {
                            16537 => {
                                if active(s.seraph_until) {
                                    16550
                                } else {
                                    803
                                }
                            }
                            16538 => {
                                if active(s.seraph_until) {
                                    16551
                                } else {
                                    805
                                }
                            }
                            16543 => 16544,
                            _ => 16547,
                        };
                        pet_action(n, i, owner, pet, action, None);
                    }
                }
            }
            7437 => {
                if let Some(s) = state_mut(i, owner) {
                    s.tether = Some(target);
                    s.next_fairy_tick = Some(Instant::now());
                }
                if let Some(a) = i.find_actor_mut(target) {
                    if let Some(s) = a.status_effects_mut() {
                        s.add_with_source(1223, 0, 0.0, owner);
                    }
                }
                if let Some(pet) = state(i, owner).and_then(|s| s.fairy) {
                    if let Some(a) = i.find_actor_mut(pet) {
                        if let Some(s) = a.status_effects_mut() {
                            s.add_with_source(1222, 0, 0.0, owner);
                        }
                    }
                    let mut r = AreaResult::new(i.find_actor(pet).unwrap().position());
                    r.push(target, [status(1223, 0, 0.0, false)]);
                    send_area_action_result(
                        n,
                        i,
                        pet,
                        7438,
                        ActionRequest {
                            action_id: 7438,
                            target: ObjectTypeId {
                                object_id: target,
                                ..Default::default()
                            },
                            ..Default::default()
                        },
                        r,
                    );
                }
            }
            7869 => stop_tether(n, i, owner),
            188 => {
                if let Some(s) = state(i, owner) {
                    if let Some(position) = s.soil_center {
                        if let Some(old) = s.soil_object {
                            n.remove_actor(i, old);
                        }
                        let object = Instance::generate_actor_id();
                        let spawn = SpawnObject {
                            kind: ObjectKind::AreaObject,
                            base_id: 1770,
                            entity_id: object,
                            owner_id: owner,
                            radius: 15.0,
                            position,
                            ..Default::default()
                        };
                        i.insert_object(object, spawn, String::default());
                        n.spawn_inserted_object_in_range(i, object);
                        if let Some(s) = state_mut(i, owner) {
                            s.soil_object = Some(object);
                        }
                        aura(n, i, owner);
                    }
                }
            }
            37014 => aura(n, i, owner),
            _ => {}
        }
    }
    fn on_tick(&self, n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
        let Some(a) = i.find_actor(owner) else {
            return;
        };
        if a.get_common_spawn().health_points == 0 {
            self.on_job_deactivated(n, i, owner);
            return;
        }
        if a.get_common_spawn().current_mount != 0 {
            return;
        }
        let owner_pos = a.position();
        let Some(mut s) = state(i, owner) else {
            return;
        };
        if s.carried_fairy.is_some() {
            spawn_fairy(n, i, owner, active(s.seraph_until));
            s = state(i, owner).unwrap();
        }
        if s.dissipated_until.is_some() && !active(s.dissipated_until) {
            if let Some(st) = state_mut(i, owner) {
                st.dissipated_until = None;
            }
            spawn_fairy(n, i, owner, false);
            s = state(i, owner).unwrap();
        }
        if s.seraph_until.is_some() && !active(s.seraph_until) {
            if let Some(st) = state_mut(i, owner) {
                st.seraph_until = None;
            }
            spawn_fairy(n, i, owner, false);
            s = state(i, owner).unwrap();
        }
        if s.soil_until.is_some() && !active(s.soil_until) {
            if let Some(id) = s.soil_object {
                n.remove_actor(i, id);
            }
            if let Some(st) = state_mut(i, owner) {
                st.soil_object = None;
                st.soil_center = None;
                st.soil_until = None;
            }
        }
        if !active(s.next_aura) {
            aura(n, i, owner);
            if let Some(s) = state_mut(i, owner) {
                s.next_aura = deadline(1);
            }
        }
        let Some(pet) = s.fairy else {
            return;
        };
        if !matches!(i.find_actor(pet),Some(NetworkedActor::Npc{state,..})if *state!=NpcState::Dead)
        {
            stop_tether(n, i, owner);
            if let Some(st) = state_mut(i, owner) {
                st.fairy = None;
                st.fairy_kind = 0;
                st.seraph_until = None;
            }
            gauge(n, i, owner);
            return;
        }
        if !active(s.next_follow) {
            if let Some(NetworkedActor::Npc { spawn, state, .. }) = i.find_actor_mut(pet) {
                let delta = owner_pos.0 - spawn.common.position.0;
                if *state == NpcState::Follow && delta.length() > 4.0 && s.tether.is_none() {
                    spawn.common.position.0 +=
                        delta.normalize_or_zero() * (delta.length() - 3.0).min(6.0);
                    spawn.common.rotation = delta.x.atan2(delta.z);
                    let pos = spawn.common.position;
                    let rot = spawn.common.rotation;
                    n.send_in_range_inclusive_instance(
                        pet,
                        i,
                        FromServer::ActorMove(
                            pet,
                            pos,
                            rot,
                            MoveAnimationType::empty(),
                            MoveAnimationState::empty(),
                            JumpState::empty(),
                        ),
                        DestinationNetwork::ZoneClients,
                    );
                }
            }
            if let Some(st) = state_mut(i, owner) {
                st.next_follow = deadline(1);
            }
        }
        if active(s.next_fairy_tick) {
            return;
        }
        if let Some(st) = state_mut(i, owner) {
            st.next_fairy_tick = deadline(3);
        }
        let center = i.find_actor(pet).unwrap().position();
        if let Some(target) = s.tether {
            if s.fairy_gauge < 10
                || !i
                    .find_actor(target)
                    .is_some_and(|a| a.get_common_spawn().health_points > 0)
            {
                stop_tether(n, i, owner);
                return;
            }
            if i.find_actor(target)
                .unwrap()
                .position()
                .0
                .distance(center.0)
                <= 30.0
            {
                pet_action(n, i, owner, pet, 7438, Some(target));
                if let Some(st) = state_mut(i, owner) {
                    st.fairy_gauge = st.fairy_gauge.saturating_sub(10);
                }
                gauge(n, i, owner);
            }
        } else {
            let target = party_in_range(n, i, owner, center.0, 40.0)
                .into_iter()
                .filter_map(|id| {
                    let c = i.find_actor(id)?.get_common_spawn();
                    (c.health_points < c.max_health_points).then_some((
                        id,
                        c.health_points as f64 / c.max_health_points.max(1) as f64,
                    ))
                })
                .min_by(|a, b| a.1.total_cmp(&b.1).then(a.0.0.cmp(&b.0.0)))
                .map(|t| t.0);
            if let Some(target) = target {
                pet_action(
                    n,
                    i,
                    owner,
                    pet,
                    if active(s.seraph_until) { 16548 } else { 802 },
                    Some(target),
                );
            }
        }
    }
    fn on_job_deactivated(&self, n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
        remove_fairy(n, i, owner);
        if let Some(s) = state_mut(i, owner) {
            let field = s.soil_object.take();
            let reactive = s.excogitation;
            let hp = s.protraction;
            *s = ScholarState::default();
            s.excogitation = reactive;
            s.protraction = hp;
            if let Some(id) = field {
                n.remove_actor(i, id);
            }
        }
        if let Some(a) = i.find_actor_mut(owner) {
            if let Some(s) = a.status_effects_mut() {
                for id in [791, 792, 1896, 3882, 3884, 1944, 298] {
                    s.remove(id);
                }
            }
        }
    }
}
/// 换区保留仙女演员身份，领域仅属于原地图，不带走旧领域 ID。
pub(in crate::server) fn take_for_zone(n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
    let Some(s) = state(i, owner) else {
        return;
    };
    stop_tether(n, i, owner);
    let carried = s.fairy.and_then(|id| {
        if let Some(NetworkedActor::Npc { spawn, state, .. }) = i.find_actor(id) {
            (*state != NpcState::Dead).then(|| crate::server::combat_state::CarriedPet {
                actor_id: id,
                spawn: spawn.clone(),
            })
        } else {
            None
        }
    });
    if let Some(id) = s.soil_object {
        n.remove_actor(i, id);
    }
    if let Some(st) = state_mut(i, owner) {
        st.fairy = None;
        st.carried_fairy = carried;
        st.soil_object = None;
        st.soil_center = None;
        st.soil_until = None;
    }
    if let Some(a) = i.find_actor_mut(owner) {
        if let Some(s) = a.status_effects_mut() {
            s.remove(1944);
            s.remove(298);
        }
    }
}
