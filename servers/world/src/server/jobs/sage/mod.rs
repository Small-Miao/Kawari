//! 贤者：均衡、蛇胆/蛇刺、关心与可连续刷新的输血盾。
mod effects;
#[cfg(test)]
mod tests;
use super::dispatch::{Job, JobActionUpdate, JobActors, JobAreaContext, JobRefreshResult};
use crate::{
    StatusEffects,
    gamedata::GameData,
    lua::{EffectsBuilder, GaugeAction},
    server::{
        actor::NetworkedActor, combat_state::PlayerCombatState, instance::Instance,
        network::NetworkState,
    },
};
use kawari::{common::ObjectId, ipc::zone::ActionRequest};
use std::time::{Duration, Instant};

#[derive(Debug, Clone)]
pub struct SageState {
    pub gall: u8,
    pub sting: u8,
    pub eukrasia: bool,
    pub gall_started: Option<Instant>,
    pub kardia: Option<ObjectId>,
    haima: Vec<Haima>,
    deferred_heals: Vec<DeferredHeal>,
}
impl Default for SageState {
    fn default() -> Self {
        Self {
            gall: 3,
            sting: 3,
            eukrasia: false,
            gall_started: None,
            kardia: None,
            haima: Vec::new(),
            deferred_heals: Vec::new(),
        }
    }
}
#[derive(Debug, Clone, Copy)]
struct DeferredHeal {
    target: ObjectId,
    amount: u32,
    critical: bool,
    kind: u16,
}
#[derive(Debug, Clone, Copy)]
struct Haima {
    shield: u16,
    stacks_status: u16,
    stacks: u8,
    end: Instant,
    amount: u32,
    cure: u32,
    source: ObjectId,
}
fn live(s: &StatusEffects, id: u16) -> bool {
    s.get(id).is_some_and(|s| s.duration >= 0.0)
}
fn euk_action(id: u32) -> bool {
    matches!(id, 24291..=24293 | 24308 | 24314 | 37032 | 37034)
}
fn gall_action(id: u32) -> bool {
    matches!(id, 24296 | 24298 | 24299 | 24303)
}
fn healing_spell(id: u32) -> bool {
    matches!(id, 24284 | 24286 | 24291 | 24292 | 37034 | 24318)
}
fn kardia_spell(id: u32) -> bool {
    matches!(
        id,
        24283 | 24289 | 24293 | 24297 | 24304 | 24306 | 24307 | 24308 | 24312
            ..=24316 | 24318 | 37032
    )
}
fn minimum(id: u32) -> u8 {
    match id {
        24283 => 1,
        24284 => 2,
        24285 => 4,
        24286 => 10,
        24287 => 12,
        24288 => 20,
        24289 => 26,
        24290..=24293 => 30,
        24294 => 35,
        24295 => 40,
        24296 => 45,
        24297 => 46,
        24298 => 50,
        24299 => 52,
        24300 => 56,
        24301 => 58,
        24302 => 60,
        24303 => 62,
        24304 => 66,
        24305 => 70,
        24306..=24308 => 72,
        24309 => 74,
        24310 => 76,
        24311 => 80,
        24312..=24316 | 37032 => 82,
        24317 => 86,
        24318 => 90,
        37033 => 92,
        37034 => 96,
        37035 => 100,
        _ => 0,
    }
}
impl SageState {
    fn resolve(&self, id: u32, l: u8) -> u32 {
        let dosis = if l >= 82 {
            24312
        } else if l >= 72 {
            24306
        } else {
            24283
        };
        let eukdosis = if l >= 82 {
            24314
        } else if l >= 72 {
            24308
        } else {
            24293
        };
        match id {
            24283 | 24306 | 24312 => {
                if self.eukrasia {
                    eukdosis
                } else {
                    dosis
                }
            }
            24293 | 24308 | 24314 => eukdosis,
            24284 if self.eukrasia => 24291,
            24286 if self.eukrasia => {
                if l >= 96 {
                    37034
                } else {
                    24292
                }
            }
            24292 | 37034 => {
                if l >= 96 {
                    37034
                } else {
                    24292
                }
            }
            24288 | 24302 => {
                if l >= 60 {
                    24302
                } else {
                    24288
                }
            }
            24289 | 24307 | 24313 => {
                if l >= 82 {
                    24313
                } else if l >= 72 {
                    24307
                } else {
                    24289
                }
            }
            24297 | 24315 => {
                if self.eukrasia && l >= 82 {
                    37032
                } else if l >= 82 {
                    24315
                } else {
                    24297
                }
            }
            24304 | 24316 => {
                if l >= 82 {
                    24316
                } else {
                    24304
                }
            }
            _ => id,
        }
    }
    fn pack(&self, l: u8) -> u64 {
        let ms = if self.gall < 3 {
            self.gall_started
                .map_or(0, |t| t.elapsed().as_millis().min(19999) as u16)
        } else {
            0
        }
        .to_le_bytes();
        u64::from_le_bytes([
            ms[0],
            ms[1],
            if l >= 45 { self.gall } else { 0 },
            if l >= 66 { self.sting } else { 0 },
            u8::from(l >= 30 && self.eukrasia),
            0,
            0,
            0,
        ])
    }
    fn advance(&mut self, l: u8, now: Instant) {
        if l < 45 {
            self.gall_started = None;
            return;
        }
        if self.gall >= 3 {
            self.gall_started = None;
            return;
        }
        let started = self.gall_started.get_or_insert(now);
        while self.gall < 3 && now.saturating_duration_since(*started) >= Duration::from_secs(20) {
            self.gall += 1;
            *started += Duration::from_secs(20);
        }
        if self.gall >= 3 {
            self.gall_started = None;
        }
    }
}
pub struct Sage;
impl Job for Sage {
    fn class_jobs(&self) -> &'static [u8] {
        &[40]
    }
    fn resolve_action(
        &self,
        r: &ActionRequest,
        s: &PlayerCombatState,
        l: u8,
        _: &mut GameData,
    ) -> u32 {
        s.sage.resolve(r.action_id, l)
    }
    fn can_execute(&self, id: u32, c: &PlayerCombatState, l: u8) -> bool {
        if l < minimum(id) {
            return false;
        }
        if euk_action(id) {
            return c.sage.eukrasia;
        }
        if gall_action(id) {
            return c.sage.gall > 0;
        }
        match id {
            24304 | 24316 => c.sage.sting > 0,
            24290 => !c.sage.eukrasia,
            27524 => false,
            _ => true,
        }
    }
    fn mp_cost(&self, id: u32, _: &NetworkedActor, sheet: u32) -> Option<u32> {
        Some(match id {
            24291 | 24292 | 37034 => 800,
            24293 | 24308 | 24314 | 37032 => 400,
            _ => sheet,
        })
    }
    fn recast_100ms(&self, id: u32, a: &NetworkedActor) -> Option<u32> {
        let l = a.get_common_spawn().level;
        match id {
            24290 => Some(10),
            24300 => Some(if l >= 88 { 900 } else { 1200 }),
            24294 => Some(if l >= 94 { 600 } else { 900 }),
            _ => None,
        }
    }
    fn fixed_recast(&self, id: u32) -> bool {
        euk_action(id) || matches!(id, 24290 | 24289 | 24307 | 24313 | 24318)
    }
    fn animation_lock(&self, id: u32) -> f32 {
        if matches!(id, 24283 | 24306 | 24312 | 24284 | 24286 | 24287 | 24318) {
            0.1
        } else {
            0.6
        }
    }
    fn action_effects(
        &self,
        id: u32,
        a: &NetworkedActor,
        _: Option<&NetworkedActor>,
        _: bool,
    ) -> Option<EffectsBuilder> {
        effects::build(id, a)
    }
    fn apply_gauge_action(&self, _: &mut PlayerCombatState, _: &GaugeAction) {}
    fn update_state_after_action(
        &self,
        id: u32,
        a: &mut NetworkedActor,
        _: ObjectId,
    ) -> JobActionUpdate {
        let NetworkedActor::Player {
            combat_state,
            status_effects,
            ..
        } = a
        else {
            return Default::default();
        };
        let s = &mut combat_state.sage;
        if gall_action(id) {
            if s.gall == 3 {
                s.gall_started = Some(Instant::now());
            }
            s.gall = s.gall.saturating_sub(1);
        }
        if matches!(id, 24304 | 24316) {
            s.sting = s.sting.saturating_sub(1);
        }
        if id == 24290 {
            s.eukrasia = true;
        } else if euk_action(id) {
            s.eukrasia = false;
            status_effects.remove(2606);
        }
        if id == 24309 {
            s.gall = (s.gall + 1).min(3);
            if s.gall == 3 {
                s.gall_started = None;
            }
        }
        if healing_spell(id) {
            status_effects.remove(2611);
        }
        JobActionUpdate {
            changed: true,
            ..Default::default()
        }
    }
    fn build_gauge_data(&self, c: &PlayerCombatState, l: u8) -> Option<u64> {
        Some(c.sage.pack(l))
    }
    fn refresh_runtime_state_on_actor(
        &self,
        _: ObjectId,
        a: &mut NetworkedActor,
    ) -> JobRefreshResult {
        let NetworkedActor::Player {
            combat_state,
            spawn,
            status_effects,
            ..
        } = a
        else {
            return Default::default();
        };
        let s = &mut combat_state.sage;
        let before = s.pack(spawn.common.level);
        s.advance(spawn.common.level, Instant::now());
        if spawn.common.health_points == 0 {
            s.eukrasia = false;
            s.sting = 0;
            s.kardia = None;
        }
        if !live(status_effects, 2604) {
            s.kardia = None;
        }
        JobRefreshResult {
            changed: before != s.pack(spawn.common.level),
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
impl JobActors for Sage {
    fn has_pet_transition_for_action(&self, _: u32) -> bool {
        true
    }
    fn spawn_pet_after_action(
        &self,
        n: &mut NetworkState,
        i: &mut Instance,
        owner: ObjectId,
        _: u32,
        _: ObjectId,
    ) {
        effects::finish_heals(n, i, owner);
    }
    fn on_job_deactivated(&self, _: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
        if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(owner) {
            combat_state.sage.kardia = None;
            combat_state.sage.eukrasia = false;
            combat_state.sage.deferred_heals.clear();
        }
    }
}
pub(in crate::server) use effects::{barrier_broken, incoming, mitigation, tick_support};
