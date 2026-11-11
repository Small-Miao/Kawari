//! 钐镰客：灵魂/魂衣、夜游魂与虚无魂、门和队伍祭品独立管理。
mod actors;
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
pub struct ReaperState {
    pub soul: u8,
    pub shroud: u8,
    pub lemure: u8,
    pub void: u8,
    reaver: u8,
    execution: u8,
    sacrifice: u8,
    sown: bool,
    ready: HashMap<u16, Instant>,
    avatar_until: Option<Instant>,
    gate: Option<(ObjectId, Position, u32, Instant)>,
    gate_origin: Option<Position>,
    marks: HashMap<ObjectId, Instant>,
}
fn active(t: Option<Instant>) -> bool {
    t.is_some_and(|t| t > Instant::now())
}
fn until(s: u64) -> Option<Instant> {
    Some(Instant::now() + Duration::from_secs(s))
}
fn known(id: u32) -> bool {
    matches!(id,24373..=24405|36969..=36973)
}
fn gcd(id: u32) -> bool {
    matches!(id,24373..=24388|24395..=24398|36970..=36973)
}
impl ReaperState {
    fn has(&self, b: u16) -> bool {
        active(self.ready.get(&b).copied())
    }
    fn pack(&self) -> u64 {
        let t = self
            .avatar_until
            .map_or(0, |t| {
                t.saturating_duration_since(Instant::now())
                    .as_millis()
                    .min(30000) as u16
            })
            .to_le_bytes();
        u64::from_le_bytes([
            self.soul,
            self.shroud,
            t[0],
            t[1],
            self.lemure,
            self.void,
            0,
            0,
        ])
    }
    fn awake(&self) -> bool {
        self.lemure > 0 && active(self.avatar_until)
    }
    fn resolve(&self, id: u32) -> u32 {
        if id == 24387 && self.sown {
            return 24388;
        }
        if id == 24398 && self.has(3860) && !self.awake() {
            return 36973;
        }
        if let Some((_, _, from, end)) = self.gate {
            if Instant::now() < end && matches!(id, 24401 | 24402) && id != from {
                return 24403;
            }
        }
        if self.awake() {
            return match id {
                24382 => 24395,
                24383 => 24396,
                24384 => 24397,
                24389 | 24390 | 24391 => 24399,
                24392 => 24400,
                24393 => 36969,
                _ => id,
            };
        }
        if self.has(3858) && self.execution > 0 && matches!(id, 24382..=24384) {
            return 36970 + id - 24382;
        }
        if id == 24389 {
            if self.has(2588) {
                return 24390;
            }
            if self.has(2589) {
                return 24391;
            }
        }
        id
    }
}
pub(in crate::server) struct Reaper;
impl Job for Reaper {
    fn class_jobs(&self) -> &'static [u8] {
        &[39]
    }
    fn resolve_action(
        &self,
        r: &ActionRequest,
        c: &PlayerCombatState,
        _: u8,
        _: &mut GameData,
    ) -> u32 {
        c.reaper.resolve(r.action_id)
    }
    fn can_execute(&self, id: u32, c: &PlayerCombatState, _: u8) -> bool {
        let s = &c.reaper;
        let awake = s.awake();
        if awake && matches!(id,24373..=24377|24380..=24384|24389..=24394|36970..=36973) {
            return false;
        }
        match id {
            24389..=24393 => {
                s.soul >= 50
                    && match id {
                        24390 => s.has(2588),
                        24391 => s.has(2589),
                        _ => true,
                    }
            }
            24382..=24384 => s.reaver > 0 && s.has(2587),
            36970..=36972 => s.execution > 0 && s.has(3858),
            24394 => s.shroud >= 50 || s.has(3905),
            24395..=24398 => awake,
            24399 | 24400 => awake && s.void >= 2,
            24388 => s.sown,
            24385 => s.sacrifice > 0 && s.has(2592) && !s.has(2972),
            36969 => awake && s.has(3857),
            36973 => s.has(3860),
            24403 => s.gate.is_some_and(|(_, _, _, end)| end > Instant::now()) && s.has(2595),
            _ => true,
        }
    }
    fn preserves_combo(&self, id: u32) -> bool {
        !matches!(id, 24373..=24377 | 24386)
    }
    fn cast_100ms(&self, id: u32, a: &NetworkedActor) -> Option<u32> {
        if let NetworkedActor::Player {
            combat_state,
            status_effects,
            ..
        } = a
        {
            if id == 24387 && !combat_state.in_combat
                || id == 24386 && status_effects.get(2845).is_some()
            {
                return Some(0);
            }
        }
        None
    }
    fn recast_100ms(&self, id: u32, _: &NetworkedActor) -> Option<u32> {
        matches!(id, 24395..=24397).then_some(15)
    }
    fn fixed_recast(&self, id: u32) -> bool {
        matches!(id, 24395..=24397)
    }
    fn fixed_primary_recast(&self, id: u32) -> bool {
        matches!(id, 24380 | 24381)
    }
    fn animation_lock(&self, id: u32) -> f32 {
        if matches!(id, 24401..=24403) {
            0.8
        } else {
            0.6
        }
    }
    fn on_action_requested(&self, id: u32, a: &mut NetworkedActor) {
        let pos = a.position();
        if let NetworkedActor::Player { combat_state, .. } = a {
            if matches!(id, 24401 | 24402) {
                combat_state.reaper.gate_origin = Some(pos);
            }
        }
    }
    fn action_effects(
        &self,
        id: u32,
        _: &NetworkedActor,
        _: Option<&NetworkedActor>,
        _: bool,
    ) -> Option<EffectsBuilder> {
        known(id).then(EffectsBuilder::default)
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
        Some(c.reaper.pack())
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
        let s = &mut combat_state.reaper;
        let before = s.pack();
        s.ready
            .retain(|id, t| *t > Instant::now() && status_effects.get(*id).is_some());
        if !s.has(2587) {
            s.reaver = 0;
        }
        if !s.has(3858) {
            s.execution = 0;
        }
        if !s.has(2592) {
            s.sacrifice = 0;
        }
        if spawn.common.health_points == 0 || !active(s.avatar_until) {
            s.lemure = 0;
            s.void = 0;
            s.avatar_until = None;
            status_effects.remove(2593);
            status_effects.remove(2590);
            status_effects.remove(2591);
        }
        if spawn.common.health_points == 0 {
            s.soul = 0;
            s.shroud = 0;
            s.sown = false;
            s.ready.clear();
            s.reaver = 0;
            s.execution = 0;
            s.sacrifice = 0;
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
pub(in crate::server) use actors::{barrier_broken, notify_action};
