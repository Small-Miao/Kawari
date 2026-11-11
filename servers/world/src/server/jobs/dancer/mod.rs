//! 舞者：舞步序列、独立触发、舞伴与即兴表演。
mod effects;
#[cfg(test)]
mod tests;
use super::dispatch::{Job, JobActionUpdate, JobActors, JobAreaContext, JobRefreshResult};
use crate::{
    gamedata::GameData,
    lua::{EffectsBuilder, GaugeAction},
    server::{
        actor::NetworkedActor, combat_state::PlayerCombatState, instance::Instance,
        network::NetworkState,
    },
};
use kawari::{
    common::{ObjectId, Position},
    ipc::zone::ActionRequest,
};
use std::{
    collections::HashMap,
    time::{Duration, Instant},
};
#[derive(Debug, Clone, Default)]
pub struct DancerState {
    pub feathers: u8,
    pub esprit: u8,
    pub steps: [u8; 4],
    pub index: u8,
    pub partner: Option<ObjectId>,
    dance: u8,
    dance_until: Option<Instant>,
    ready: HashMap<u16, Instant>,
    improvisation: Option<(Position, f32, Instant, Instant, u8)>,
    improvisation_object: Option<ObjectId>,
    technical: Option<(Instant, u8)>,
}
fn minimum(id: u32) -> u8 {
    match id {
        15989 => 1,
        15990 => 2,
        15993 | 15997 | 15999..=16003 | 16191 | 16192 => 15,
        15991 => 20,
        15994 => 25,
        16007 => 30,
        15995 => 35,
        15992 => 40,
        15996 => 45,
        16008 | 16010 => 50,
        16015 => 52,
        16012 => 56,
        16006 | 18073 => 60,
        16011 => 62,
        16009 => 66,
        15998 | 16004 | 16193..=16196 => 70,
        16013 => 72,
        16005 => 76,
        16014 | 25789 => 80,
        25790 => 82,
        25791 => 86,
        25792 => 90,
        36983 => 92,
        36984 => 96,
        36985 => 100,
        _ => 0,
    }
}
fn standard(id: u32) -> bool {
    matches!(id, 16003 | 16191 | 16192 | 36984)
}
fn technical(id: u32) -> bool {
    matches!(id, 16004 | 16193..=16196)
}
fn finisher(id: u32) -> bool {
    standard(id) || technical(id)
}
impl DancerState {
    fn pack(&self) -> u64 {
        u64::from_le_bytes([
            self.feathers,
            self.esprit,
            self.steps[0],
            self.steps[1],
            self.steps[2],
            self.steps[3],
            self.index,
            0,
        ])
    }
    fn dancing(&self) -> bool {
        self.dance_until.is_some_and(|t| t > Instant::now())
    }
    fn has(&self, id: u16) -> bool {
        self.ready.get(&id).is_some_and(|t| *t > Instant::now())
    }
    fn finish(&self) -> u32 {
        if self.dance == 2 {
            [16003, 16191, 16192][self.index.min(2) as usize]
        } else {
            [16004, 16193, 16194, 16195, 16196][self.index.min(4) as usize]
        }
    }
    fn resolve(&self, id: u32) -> u32 {
        if self.dancing() {
            return match id {
                15989 | 15993 => 15999,
                15990 | 15994 => 16000,
                15991 | 15995 => 16001,
                15992 | 15996 => 16002,
                15997 | 16003 if self.dance == 2 => self.finish(),
                15998 | 16004 if self.dance == 4 => self.finish(),
                _ => id,
            };
        }
        match id {
            15997 if self.has(3868) => 36984,
            16005 if self.has(3869) && self.esprit >= 50 => 36985,
            15998 | 16004 if self.has(2698) => 25790,
            16014 if self.improvisation.is_some() => 25789,
            16006 if self.partner.is_some() => 18073,
            _ => id,
        }
    }
    fn end_dance(&mut self) {
        self.steps = [0; 4];
        self.index = 0;
        self.dance = 0;
        self.dance_until = None;
    }
}
pub(in crate::server) struct Dancer;
impl Job for Dancer {
    fn class_jobs(&self) -> &'static [u8] {
        &[38]
    }
    fn resolve_action(
        &self,
        r: &ActionRequest,
        c: &PlayerCombatState,
        _: u8,
        _: &mut GameData,
    ) -> u32 {
        c.dancer.resolve(r.action_id)
    }
    fn can_execute(&self, id: u32, c: &PlayerCombatState, l: u8) -> bool {
        if l < minimum(id) {
            return false;
        }
        let s = &c.dancer;
        if s.dancing() {
            return match id {
                15999..=16002 | 16010 | 16012 | 16015 => true,
                _ if finisher(id) => id == s.finish(),
                _ => minimum(id) == 0,
            };
        }
        match id {
            15999..=16004 | 16191..=16196 => false,
            15991 | 15995 => s.has(2693) || s.has(3017),
            15992 | 15996 => s.has(2694) || s.has(3018),
            16007 | 16008 => s.feathers > 0,
            16009 => s.has(1820),
            16005 => s.esprit >= 50,
            16013 => c.in_combat,
            18073 => s.partner.is_some(),
            25789 => s.improvisation.is_some(),
            25790 => s.has(2698),
            25791 => s.has(2699),
            25792 => s.has(2700),
            36983 => s.has(3867),
            36984 => s.has(3868),
            36985 => s.has(3869) && s.esprit >= 50,
            _ => true,
        }
    }
    fn preserves_combo(&self, id: u32) -> bool {
        !matches!(id, 15989 | 15990 | 15993 | 15994)
    }
    fn fixed_recast(&self, id: u32) -> bool {
        matches!(id,15997..=16004|16191..=16196|36984)
    }
    fn recast_100ms(&self, id: u32, a: &NetworkedActor) -> Option<u32> {
        match id {
            15999..=16002 => Some(10),
            _ if finisher(id) && id != 36984 => Some(15),
            16012 => Some(if a.get_common_spawn().level >= 88 {
                900
            } else {
                1200
            }),
            _ => None,
        }
    }
    fn additional_gcd_100ms(&self, id: u32) -> Option<u32> {
        match id {
            15997 | 15998 => Some(15),
            36984 => Some(25),
            _ => None,
        }
    }
    fn animation_lock(&self, id: u32) -> f32 {
        if id == 33218 { 0.1 } else { 0.6 }
    }
    fn on_action_requested(&self, id: u32, a: &mut NetworkedActor) {
        if !matches!(id, 16014 | 25789)
            && let NetworkedActor::Player {
                combat_state,
                status_effects,
                ..
            } = a
        {
            combat_state.dancer.improvisation = None;
            status_effects.remove(1827);
            status_effects.remove(2696);
        }
    }
    fn action_effects(
        &self,
        id: u32,
        _: &NetworkedActor,
        _: Option<&NetworkedActor>,
        _: bool,
    ) -> Option<EffectsBuilder> {
        (minimum(id) > 0).then(EffectsBuilder::default)
    }
    fn apply_gauge_action(&self, _: &mut PlayerCombatState, _: &GaugeAction) {}
    fn update_state_after_action(
        &self,
        _: u32,
        _: &mut NetworkedActor,
        _: ObjectId,
    ) -> JobActionUpdate {
        Default::default()
    }
    fn build_gauge_data(&self, c: &PlayerCombatState, _: u8) -> Option<u64> {
        Some(c.dancer.pack())
    }
    fn refresh_runtime_state_on_actor(
        &self,
        _: ObjectId,
        a: &mut NetworkedActor,
    ) -> JobRefreshResult {
        let NetworkedActor::Player {
            combat_state,
            status_effects,
            spawn,
            ..
        } = a
        else {
            return Default::default();
        };
        let s = &mut combat_state.dancer;
        let before = s.pack();
        s.ready
            .retain(|id, t| *t > Instant::now() && status_effects.get(*id).is_some());
        if !s.dancing() {
            s.end_dance();
            status_effects.remove(1818);
            status_effects.remove(1819);
        }
        if spawn.common.health_points == 0 {
            let partner = s.partner;
            *s = Default::default();
            s.partner = partner;
        }
        JobRefreshResult {
            changed: before != s.pack(),
            ..Default::default()
        }
    }
    fn apply_area_action(
        &self,
        n: &mut NetworkState,
        i: &mut Instance,
        c: JobAreaContext<'_>,
    ) -> Option<crate::server::action::area::AreaResult> {
        effects::apply(n, i, c)
    }
    fn persistent_actors(&self) -> Option<&dyn JobActors> {
        Some(self)
    }
}
impl JobActors for Dancer {
    fn on_zone_leaving(&self, n: &mut NetworkState, i: &mut Instance, o: ObjectId) {
        let old = if let Some(NetworkedActor::Player {
            combat_state,
            status_effects,
            ..
        }) = i.find_actor_mut(o)
        {
            combat_state.dancer.improvisation = None;
            combat_state.dancer.ready.remove(&1827);
            status_effects.remove(1827);
            combat_state.dancer.improvisation_object.take()
        } else {
            None
        };
        if let Some(id) = old {
            n.remove_actor(i, id);
        }
    }
    fn has_pet_transition_for_action(&self, id: u32) -> bool {
        id == 16014
    }
    fn spawn_pet_after_action(
        &self,
        n: &mut NetworkState,
        i: &mut Instance,
        o: ObjectId,
        id: u32,
        _: ObjectId,
    ) {
        if id != 16014 {
            return;
        }
        let Some(a) = i.find_actor(o) else {
            return;
        };
        let pos = a.position();
        let obj = Instance::generate_actor_id();
        let old = if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
            combat_state.dancer.improvisation_object.replace(obj)
        } else {
            return;
        };
        if let Some(old) = old {
            n.remove_actor(i, old);
        }
        i.insert_object(
            obj,
            kawari::ipc::zone::SpawnObject {
                kind: kawari::ipc::zone::ObjectKind::AreaObject,
                base_id: 714,
                entity_id: obj,
                owner_id: o,
                radius: 8.0,
                position: pos,
                ..Default::default()
            },
            String::default(),
        );
        n.spawn_inserted_object_in_range(i, obj);
    }
    fn on_tick(&self, n: &mut NetworkState, i: &mut Instance, o: ObjectId) {
        effects::tick(n, i, o);
        let old = if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
            if combat_state.dancer.improvisation.is_none() {
                combat_state.dancer.improvisation_object.take()
            } else {
                None
            }
        } else {
            None
        };
        if let Some(old) = old {
            n.remove_actor(i, old);
        }
    }
    fn on_job_deactivated(&self, n: &mut NetworkState, i: &mut Instance, o: ObjectId) {
        let old = if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
            combat_state.dancer.improvisation_object.take()
        } else {
            None
        };
        if let Some(old) = old {
            n.remove_actor(i, old);
        }
        effects::unlink(i, o);
        if let Some(a) = i.find_actor_mut(o) {
            super::paladin::deactivate(a);
            if let NetworkedActor::Player {
                combat_state,
                status_effects,
                ..
            } = a
            {
                combat_state.dancer = Default::default();
                for id in [
                    1818, 1819, 1820, 1827, 2693, 2694, 2696, 2698, 2699, 2700, 3017, 3018, 3867,
                    3868, 3869,
                ] {
                    status_effects.remove(id);
                }
            }
        }
    }
}
pub(in crate::server) use effects::notify_action;
