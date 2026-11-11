//! 赤魔法师：黑白魔元、独立的三层魔元集及当前国服魔元化变招。
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
    common::ObjectId,
    ipc::zone::{ActionRequest, DamageType},
};
use std::{
    collections::HashMap,
    time::{Duration, Instant},
};
#[derive(Debug, Clone, Default)]
pub struct RedMageState {
    pub white: u8,
    pub black: u8,
    pub stacks: u8,
    free: u8,
    ready: HashMap<u16, Instant>,
    chain: u32,
    chain_until: Option<Instant>,
}
fn active(t: Option<Instant>) -> bool {
    t.is_some_and(|t| t > Instant::now())
}
fn until(seconds: u64) -> Option<Instant> {
    Some(Instant::now() + Duration::from_secs(seconds))
}
pub(super) fn known(id: u32) -> bool {
    matches!(id,7503..=7507|7509..=7521|7523..=7530|16524..=16530|25855..=25858|37002..=37007|45960..=45962)
}
fn cast_base(id: u32) -> u32 {
    match id {
        7503 | 7510 | 7511 | 7514 | 7524 | 16524 | 16525 | 37004 => 20,
        7505 | 7507 | 7509 | 16526 | 25855 | 25856 => 50,
        7523 => 100,
        _ => 0,
    }
}
fn spell(id: u32) -> bool {
    cast_base(id) > 0 || matches!(id, 7525 | 7526 | 16530 | 25858 | 37006)
}
fn weapon(id: u32) -> bool {
    matches!(id,7504|7512|7513|7516|7527..=7530|16528|16529|37002|37003|45960..=45962)
}
fn enchanted_cost(id: u32) -> u8 {
    match id {
        7527 | 7530 | 45960 => 20,
        7528 | 7529 | 37002 | 37003 | 45961 | 45962 => 15,
        16528 => 5,
        _ => 0,
    }
}
pub(in crate::server) fn acceleration(a: &NetworkedActor, id: u32) -> bool {
    matches!(id, 7505 | 7507 | 7509 | 16526 | 25855 | 25856)
        && a.status_effects().is_some_and(|s| s.get(1238).is_some())
}
impl RedMageState {
    fn has(&self, id: u16) -> bool {
        active(self.ready.get(&id).copied())
    }
    fn mark(&mut self, id: u16, seconds: u64) {
        self.ready
            .insert(id, Instant::now() + Duration::from_secs(seconds));
    }
    fn pack(&self) -> u64 {
        u64::from_le_bytes([self.white, self.black, self.stacks, 0, 0, 0, 0, 0])
    }
    fn gain(&mut self, white: u8, black: u8) {
        // 判定使用增加前的差值，单次技能不会改变另一半魔元的倍率。
        let w = if self.black.saturating_sub(self.white) > 30 {
            white / 2
        } else {
            white
        };
        let b = if self.white.saturating_sub(self.black) > 30 {
            black / 2
        } else {
            black
        };
        self.white = self.white.saturating_add(w).min(100);
        self.black = self.black.saturating_add(b).min(100);
    }
    fn resolve(&self, id: u32) -> u32 {
        let chain = if active(self.chain_until) {
            self.chain
        } else {
            0
        };
        if matches!(id, 7503 | 7524 | 37004 | 7509 | 16526) {
            if matches!(chain, 7525 | 7526) {
                return 16530;
            }
            if chain == 16530 {
                return 25858;
            }
            if self.has(3877) {
                return 37006;
            }
        }
        if self.stacks == 3 {
            if matches!(id, 7505 | 25855 | 16524) {
                return 7525;
            }
            if matches!(id, 7507 | 25856 | 16525) {
                return 7526;
            }
        }
        if id == 7520 && self.has(3876) {
            return 37005;
        }
        if id == 7521 && self.has(3878) {
            return 37007;
        }
        let free = self.free > 0 && self.has(3875);
        let mut next = match id {
            7503 | 7524 => 37004,
            7505 => 25855,
            7507 => 25856,
            7509 => 16526,
            7504 if free || self.white.min(self.black) >= 20 => 7527,
            7512 if free || self.white.min(self.black) >= 15 => 7528,
            7516 if free || self.white.min(self.black) >= 15 => 7529,
            7513 | 7530
                if free
                    || self.white.min(self.black)
                        >= if matches!(chain, 7530 | 37002) {
                            15
                        } else {
                            20
                        } =>
            {
                match chain {
                    7530 => 37002,
                    37002 => 37003,
                    _ => 7530,
                }
            }
            16529 if self.white.min(self.black) >= 5 => 16528,
            _ => id,
        };
        if self.has(1971) && matches!(next, 7527..=7529) {
            next = 45960 + next - 7527;
        }
        next
    }
}
pub(in crate::server) struct RedMage;
impl Job for RedMage {
    fn class_jobs(&self) -> &'static [u8] {
        &[35]
    }
    fn resolve_action(
        &self,
        r: &ActionRequest,
        c: &PlayerCombatState,
        _: u8,
        _: &mut GameData,
    ) -> u32 {
        c.red_mage.resolve(r.action_id)
    }
    fn can_execute(&self, id: u32, c: &PlayerCombatState, _: u8) -> bool {
        let s = &c.red_mage;
        let cost = enchanted_cost(id);
        if cost > 0 && !(id != 16528 && s.free > 0 && s.has(3875)) && s.white.min(s.black) < cost {
            return false;
        }
        if matches!(id, 45960..=45962) && !s.has(1971) {
            return false;
        }
        match id {
            7510 => s.has(1234),
            7511 => s.has(1235),
            7521 => c.in_combat,
            7525 | 7526 => s.stacks == 3,
            16530 => active(s.chain_until) && matches!(s.chain, 7525 | 7526),
            25858 => active(s.chain_until) && s.chain == 16530,
            37002 => active(s.chain_until) && s.chain == 7530,
            37003 => active(s.chain_until) && s.chain == 37002,
            37005 => s.has(3876),
            37006 => s.has(3877),
            37007 => s.has(3878),
            _ => true,
        }
    }
    fn combo_action_id(&self, id: u32) -> u16 {
        (match id {
            7527 | 45960 => 7504,
            7528 | 45961 => 7512,
            _ => id,
        }) as u16
    }
    fn preserves_combo(&self, id: u32) -> bool {
        !spell(id) && !weapon(id) && id != 7521
    }
    fn grants_combo(&self, id: u32, c: &PlayerCombatState) -> bool {
        let s = &c.red_mage;
        if !active(s.chain_until) {
            return false;
        }
        matches!(
            (id, s.chain),
            (7512 | 7528 | 45961, 7504 | 7527 | 45960)
                | (7516 | 7529 | 45962, 7512 | 7528 | 45961)
                | (37002, 7530)
                | (37003, 37002)
                | (16530, 7525 | 7526)
                | (25858, 16530)
        )
    }
    fn cast_100ms(&self, id: u32, a: &NetworkedActor) -> Option<u32> {
        (cast_base(id) > 0
            && (acceleration(a, id) || a.status_effects().is_some_and(|s| s.get(1249).is_some())))
        .then_some(0)
    }
    fn recast_100ms(&self, id: u32, _: &NetworkedActor) -> Option<u32> {
        match id {
            7519 => Some(350),
            7518 => Some(550),
            7521 => Some(1100),
            _ => None,
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
        Some(c.red_mage.pack())
    }
    fn refresh_runtime_state_on_actor(
        &self,
        _: ObjectId,
        a: &mut NetworkedActor,
    ) -> JobRefreshResult {
        if let NetworkedActor::Player {
            spawn,
            combat_state,
            status_effects,
            ..
        } = a
        {
            let s = &mut combat_state.red_mage;
            let before = s.pack();
            if spawn.common.health_points == 0 {
                *s = Default::default();
            }
            s.ready
                .retain(|id, t| *t > Instant::now() && status_effects.get(*id).is_some());
            if !s.has(3875) {
                s.free = 0;
            }
            return JobRefreshResult {
                changed: before != s.pack(),
                ..Default::default()
            };
        }
        Default::default()
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
impl JobActors for RedMage {
    fn on_job_deactivated(&self, _: &mut NetworkState, i: &mut Instance, o: ObjectId) {
        if let Some(NetworkedActor::Player {
            combat_state,
            status_effects,
            ..
        }) = i.find_actor_mut(o)
        {
            combat_state.red_mage = Default::default();
            for id in [1234, 1235, 1238, 1239, 1249, 1971, 3875, 3876, 3877, 3878] {
                status_effects.remove(id);
            }
        }
    }
}
pub(in crate::server) fn mitigation(a: &NetworkedActor, t: DamageType) -> f64 {
    if t == DamageType::Magic && a.status_effects().is_some_and(|s| s.get(2707).is_some()) {
        0.9
    } else {
        1.0
    }
}
