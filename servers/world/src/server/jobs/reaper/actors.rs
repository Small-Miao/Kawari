use super::super::{dispatch::send_job_gauge_update, white_mage};
use super::effects::grant;
use super::*;
use crate::{
    FromServer,
    server::{action::area::party_in_range, network::DestinationNetwork},
    status_effects::TickEffectKind,
};
use kawari::ipc::zone::{ActorControlCategory, ObjectKind, SpawnObject};
fn clear_gate(n: &mut NetworkState, i: &mut Instance, o: ObjectId) {
    let gate = if let Some(NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    }) = i.find_actor_mut(o)
    {
        status_effects.remove(2595);
        combat_state.reaper.ready.remove(&2595);
        combat_state.reaper.gate.take()
    } else {
        None
    };
    if let Some((obj, _, _, _)) = gate {
        n.remove_actor(i, obj);
    }
}
impl JobActors for Reaper {
    fn on_zone_leaving(&self, n: &mut NetworkState, i: &mut Instance, o: ObjectId) {
        clear_gate(n, i, o);
        if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
            combat_state.reaper.gate_origin = None;
            combat_state.reaper.marks.clear();
        }
    }
    fn has_pet_transition_for_action(&self, id: u32) -> bool {
        matches!(id, 24401..=24403)
    }
    fn spawn_pet_after_action(
        &self,
        n: &mut NetworkState,
        i: &mut Instance,
        o: ObjectId,
        id: u32,
        _: ObjectId,
    ) {
        if id == 24403 {
            clear_gate(n, i, o);
            return;
        }
        if !matches!(id, 24401 | 24402) {
            return;
        }
        let Some(a) = i.find_actor(o) else {
            return;
        };
        let pos = a.position();
        let origin = if let NetworkedActor::Player { combat_state, .. } = a {
            combat_state.reaper.gate_origin.unwrap_or(pos)
        } else {
            pos
        };
        let old = if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
            combat_state.reaper.gate.take()
        } else {
            None
        };
        if let Some((obj, _, _, _)) = old {
            n.remove_actor(i, obj);
        }
        let obj = Instance::generate_actor_id();
        i.insert_object(
            obj,
            SpawnObject {
                kind: ObjectKind::AreaObject,
                base_id: 1219,
                entity_id: obj,
                owner_id: o,
                position: origin,
                ..Default::default()
            },
            String::default(),
        );
        n.spawn_inserted_object_in_range(i, obj);
        if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
            combat_state.reaper.gate =
                Some((obj, origin, id, Instant::now() + Duration::from_secs(10)));
            combat_state.reaper.gate_origin = None;
        }
    }
    fn on_tick(&self, n: &mut NetworkState, i: &mut Instance, o: ObjectId) {
        let Some(a) = i.find_actor(o) else {
            return;
        };
        let NetworkedActor::Player { combat_state, .. } = a else {
            return;
        };
        let s = combat_state.reaper.clone();
        let alive = a.get_common_spawn().health_points > 0;
        if s.gate
            .is_some_and(|(_, _, _, end)| end <= Instant::now() || !alive)
        {
            clear_gate(n, i, o);
        }
        let ended: Vec<_> = s
            .marks
            .iter()
            .filter_map(|(id, end)| {
                let a = i.find_actor(*id);
                let dead = a.is_some_and(|a| a.get_common_spawn().health_points == 0);
                (dead || *end <= Instant::now() || a.is_none())
                    .then_some((*id, dead && *end > Instant::now()))
            })
            .collect();
        let gained = ended.iter().filter(|(_, dead)| *dead).count() as u8;
        if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
            for (id, _) in ended {
                combat_state.reaper.marks.remove(&id);
            }
            if alive && gained > 0 {
                combat_state.reaper.soul = combat_state
                    .reaper
                    .soul
                    .saturating_add(gained.saturating_mul(10))
                    .min(100);
                send_job_gauge_update(n, o, 39, combat_state.reaper.pack());
            }
        }
    }
    fn on_job_deactivated(&self, n: &mut NetworkState, i: &mut Instance, o: ObjectId) {
        clear_gate(n, i, o);
        if let Some(a) = i.find_actor_mut(o) {
            super::super::paladin::deactivate(a);
            if let NetworkedActor::Player {
                combat_state,
                status_effects,
                ..
            } = a
            {
                combat_state.reaper = Default::default();
                for id in [
                    2587, 2588, 2589, 2590, 2591, 2592, 2593, 2594, 2845, 2972, 3857, 3858, 3859,
                    3860, 3905,
                ] {
                    status_effects.remove(id);
                }
            }
        }
    }
}
/// 每名受祭祀环影响的角色至多贡献一次；攻击型能力在当前国服也能贡献。
pub(in crate::server) fn notify_action(
    n: &mut NetworkState,
    i: &mut Instance,
    source: ObjectId,
    category: u8,
    hit: bool,
) {
    if !hit || !matches!(category, 2 | 3 | 4) {
        return;
    }
    let owners = i
        .find_actor(source)
        .and_then(NetworkedActor::status_effects)
        .map(|s| {
            s.data()
                .into_iter()
                .filter(|s| s.effect_id == 2600 && s.duration > 0.0)
                .map(|s| s.source_actor_id)
                .collect::<Vec<_>>()
        })
        .unwrap_or_default();
    for owner in owners {
        let valid = matches!(i.find_actor(owner),Some(NetworkedActor::Player{combat_state,spawn,..})if spawn.common.class_job==39&&spawn.common.health_points>0&&combat_state.reaper.has(2972));
        if !valid {
            continue;
        }
        if let Some(s) = i
            .find_actor_mut(source)
            .and_then(NetworkedActor::status_effects_mut)
        {
            s.remove_from(2600, owner);
        }
        if let Some(a) = i.find_actor_mut(owner) {
            let count = if let NetworkedActor::Player { combat_state, .. } = a {
                let s = &mut combat_state.reaper;
                s.sacrifice = (s.sacrifice + 1).min(8);
                s.sacrifice
            } else {
                return;
            };
            grant(a, owner, 2592, count as u16, 30);
        }
    }
    let _ = n;
}
pub(in crate::server) fn barrier_broken(n: &mut NetworkState, i: &mut Instance, o: ObjectId) {
    let Some(a) = i.find_actor(o) else {
        return;
    };
    if a.get_common_spawn().class_job != 39 || a.get_common_spawn().level < 84 {
        return;
    }
    let pos = a.position();
    for t in party_in_range(n, i, o, pos.0, 15.0) {
        if let Some(s) = i
            .find_actor_mut(t)
            .and_then(NetworkedActor::status_effects_mut)
        {
            s.add_tick(2598, 0, 15.0, TickEffectKind::Heal, 50, None, o);
        }
        n.send_ac_in_range_inclusive_instance(
            i,
            t,
            ActorControlCategory::GainEffect {
                effect_id: 2598,
                param: 0,
                source_actor_id: o,
            },
        );
    }
    white_mage::send_hp_mp(n, i, o);
}
pub(super) fn shorten_gate_cooldown(n: &mut NetworkState, i: &mut Instance, o: ObjectId) {
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
        if let Some((elapsed_centisec, total_centisec)) =
            combat_state.reduce_cooldown_recovery(4, Duration::from_secs(5))
        {
            n.send_to_by_actor_id(
                o,
                FromServer::ActorControlSelf(ActorControlCategory::SetCooldownTimer {
                    cooldown_group: 4,
                    elapsed_centisec,
                    total_centisec,
                }),
                DestinationNetwork::ZoneClients,
            );
        }
    }
}
