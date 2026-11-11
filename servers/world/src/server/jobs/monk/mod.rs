//! 武僧：身形、功力、斗气与脉轮分开管理，不从旁观者量谱反推本人资源。
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
use kawari::{common::ObjectId, ipc::zone::ActionRequest};
use std::time::{Duration, Instant};
#[derive(Debug, Clone, Default)]
pub struct MonkState {
    pub chakra: u8,
    pub beast: [u8; 3],
    pub fury: [u8; 3],
    pub nadi: u8,
    pub blitz_until: Option<Instant>,
    form: u8,
    form_until: Option<Instant>,
    formless_until: Option<Instant>,
    balance: u8,
    balance_until: Option<Instant>,
    earth_until: Option<Instant>,
    wind_until: Option<Instant>,
    fire_until: Option<Instant>,
    brotherhood_until: Option<Instant>,
    earth_hit: bool,
}
fn active(t: Option<Instant>) -> bool {
    t.is_some_and(|t| t > Instant::now())
}
fn until(s: u64) -> Option<Instant> {
    Some(Instant::now() + Duration::from_secs(s))
}
fn form(id: u32) -> u8 {
    match id {
        53 | 74 | 62 | 25767 | 36945 => 1,
        54 | 61 | 16473 | 36946 => 2,
        56 | 66 | 70 | 36947 => 3,
        _ => 0,
    }
}
fn blitz(id: u32) -> bool {
    matches!(id, 3543 | 3545 | 25765 | 25768 | 25769 | 25882 | 36948)
}
fn meditation(id: u32) -> bool {
    matches!(id, 3546 | 36940..=36943)
}
fn minimum(id: u32) -> u8 {
    match id {
        53 => 1,
        54 => 4,
        56 => 6,
        25761 | 36940 | 3546 => 15,
        61 => 18,
        62 => 26,
        66 | 70 => 30,
        25762 => 35,
        25763 | 36941 => 40,
        65 => 42,
        16473 => 45,
        69 | 74 => 50,
        4262 => 52,
        3547 | 36942 => 54,
        25764 | 3543 | 3545 | 25765 | 25882 => 60,
        7394 | 36944 => 64,
        7395 => 68,
        7396 => 70,
        25766 => 72,
        16474 | 36943 => 74,
        16476 => 80,
        25767 => 82,
        25768 => 86,
        25769 => 90,
        36945..=36948 => 92,
        36949 => 96,
        36950 => 100,
        _ => 0,
    }
}
impl MonkState {
    fn allowed_form(&self, f: u8) -> bool {
        f == 0
            || (active(self.form_until) && self.form == f)
            || active(self.formless_until)
            || (active(self.balance_until) && self.balance > 0)
    }
    fn masterful(&self, l: u8) -> u32 {
        if self.beast.contains(&0) || !active(self.blitz_until) {
            return 25764;
        }
        if self.nadi == 3 {
            return if l >= 90 { 25769 } else { 3543 };
        }
        if self.beast[0] == self.beast[1] && self.beast[1] == self.beast[2] {
            return if l >= 92 { 36948 } else { 3545 };
        }
        if self.beast[0] != self.beast[1]
            && self.beast[1] != self.beast[2]
            && self.beast[0] != self.beast[2]
        {
            return if l >= 86 { 25768 } else { 25882 };
        }
        25765
    }
    fn resolve(&self, id: u32, l: u8) -> u32 {
        match id {
            53 | 36945 => {
                if l >= 92 {
                    36945
                } else {
                    53
                }
            }
            54 | 36946 => {
                if l >= 92 {
                    36946
                } else {
                    54
                }
            }
            56 | 36947 => {
                if l >= 92 {
                    36947
                } else {
                    56
                }
            }
            62 | 25767 => {
                if l >= 82 {
                    25767
                } else {
                    62
                }
            }
            3546 | 36940 | 36942 | 25761 | 3547 => {
                if self.chakra >= 5 {
                    if l >= 54 { 3547 } else { 25761 }
                } else if l >= 54 {
                    36942
                } else {
                    36940
                }
            }
            36941 | 36943 | 25763 | 16474 => {
                if self.chakra >= 5 {
                    if l >= 74 { 16474 } else { 25763 }
                } else if l >= 74 {
                    36943
                } else {
                    36941
                }
            }
            25764 => self.masterful(l),
            7394 if active(self.earth_until) => 36944,
            7395 if l >= 100 && active(self.fire_until) => 36950,
            25766 if l >= 96 && active(self.wind_until) => 36949,
            _ => id,
        }
    }
    fn pack(&self, l: u8) -> u64 {
        let t = self
            .blitz_until
            .map_or(0, |t| {
                t.saturating_duration_since(Instant::now())
                    .as_millis()
                    .min(65535) as u16
            })
            .to_le_bytes();
        u64::from_le_bytes([
            if l >= 15 { self.chakra } else { 0 },
            self.beast[0],
            self.beast[1],
            self.beast[2],
            self.fury[0] | (self.fury[1] << 2) | (self.fury[2] << 4),
            self.nadi,
            t[0],
            t[1],
        ])
    }
    fn gain(&mut self, n: u8) {
        self.chakra = self
            .chakra
            .saturating_add(n)
            .min(if active(self.brotherhood_until) {
                10
            } else {
                5
            });
    }
}
pub(in crate::server) struct Monk;
impl Job for Monk {
    fn class_jobs(&self) -> &'static [u8] {
        &[2, 20]
    }
    fn resolve_action(
        &self,
        r: &ActionRequest,
        c: &PlayerCombatState,
        l: u8,
        _: &mut GameData,
    ) -> u32 {
        c.monk.resolve(r.action_id, l)
    }
    fn can_execute(&self, id: u32, c: &PlayerCombatState, l: u8) -> bool {
        if l < minimum(id) {
            return false;
        }
        let s = &c.monk;
        if meditation(id) {
            return s.chakra < 5;
        }
        if blitz(id) {
            return s.masterful(l) == id;
        }
        if form(id) > 1 && !s.allowed_form(form(id)) {
            return false;
        }
        match id {
            69 => c.in_combat && s.beast == [0; 3] && !active(s.balance_until),
            25761 | 3547 | 25763 | 16474 => c.in_combat && s.chakra >= 5,
            25764 => false,
            36944 => active(s.earth_until),
            36949 => active(s.wind_until),
            36950 => active(s.fire_until),
            _ => true,
        }
    }
    fn preserves_combo(&self, _: u32) -> bool {
        true
    }
    fn speed_percent(&self, a: &NetworkedActor) -> u32 {
        haste(a.get_common_spawn().level)
    }
    fn fixed_recast(&self, id: u32) -> bool {
        meditation(id)
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
            spawn,
            ..
        } = a
        else {
            return Default::default();
        };
        let s = &mut combat_state.monk;
        let l = spawn.common.level;
        if meditation(id) {
            s.chakra = if combat_state.in_combat {
                (s.chakra + 1).min(5)
            } else {
                5
            };
        }
        match id {
            69 => {
                s.balance = 3;
                s.balance_until = until(20);
            }
            4262 => s.formless_until = until(30),
            7394 => s.earth_until = until(30),
            7395 if l >= 100 => s.fire_until = until(20),
            25766 if l >= 96 => s.wind_until = until(15),
            7396 => s.brotherhood_until = until(20),
            _ => {}
        }
        JobActionUpdate {
            changed: true,
            ..Default::default()
        }
    }
    fn build_gauge_data(&self, c: &PlayerCombatState, l: u8) -> Option<u64> {
        Some(c.monk.pack(l))
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
        let s = &mut combat_state.monk;
        let before = s.pack(spawn.common.level);
        if spawn.common.health_points == 0 {
            *s = Default::default();
        }
        if !active(s.blitz_until) && !active(s.balance_until) {
            s.beast = [0; 3];
            s.blitz_until = None;
        }
        if !active(s.balance_until) || status_effects.get(110).is_none() {
            s.balance = 0;
            s.balance_until = None;
        }
        if !active(s.formless_until) || status_effects.get(2513).is_none() {
            s.formless_until = None;
        }
        if !active(s.brotherhood_until) {
            s.chakra = s.chakra.min(5);
        }
        JobRefreshResult {
            changed: before != s.pack(spawn.common.level) || s.blitz_until.is_some(),
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
impl JobActors for Monk {
    fn on_tick(&self, n: &mut NetworkState, i: &mut Instance, o: ObjectId) {
        effects::tick(n, i, o);
    }
    fn on_job_deactivated(&self, _: &mut NetworkState, i: &mut Instance, o: ObjectId) {
        if let Some(a) = i.find_actor_mut(o) {
            super::paladin::deactivate(a);
            if let NetworkedActor::Player {
                combat_state,
                status_effects,
                ..
            } = a
            {
                combat_state.monk = Default::default();
                for id in [
                    104, 107, 108, 109, 110, 1179, 1180, 1181, 1182, 1185, 2513, 2514, 2687, 3841,
                    3842, 3843,
                ] {
                    status_effects.remove(id);
                }
            }
        }
    }
}
pub(in crate::server) fn haste(l: u8) -> u32 {
    if l >= 76 {
        80
    } else if l >= 40 {
        85
    } else if l >= 20 {
        90
    } else {
        95
    }
}
pub(in crate::server) fn auto_haste(a: &NetworkedActor) -> u32 {
    let base = haste(a.get_common_spawn().level);
    if a.status_effects().is_some_and(|s| s.get(2687).is_some()) {
        base / 2
    } else {
        base
    }
}
pub(in crate::server) fn on_damage(a: &mut NetworkedActor) {
    if a.status_effects().is_some_and(|s| s.get(1179).is_some())
        && let NetworkedActor::Player { combat_state, .. } = a
    {
        combat_state.monk.earth_hit = true;
    }
}
pub(in crate::server) use effects::notify_action;
pub(in crate::server) use effects::positional;
