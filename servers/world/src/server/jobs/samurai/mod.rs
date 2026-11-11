//! 武士：闪、剑气、剑压与各类回返独立，默想以动作/移动中断。
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
use std::time::{Duration, Instant};
#[derive(Debug, Clone, Default)]
pub struct SamuraiState {
    pub kenki: u8,
    pub sen: u8,
    pub meditation: u8,
    pub kaeshi: u8,
    meikyo: u8,
    meikyo_until: Option<Instant>,
    tendo_until: Option<Instant>,
    ogi_until: Option<Instant>,
    zanshin_until: Option<Instant>,
    repeat: u32,
    repeat_until: Option<Instant>,
    ogi_repeat: bool,
    ogi_repeat_until:Option<Instant>,
    meditate: Option<(Position, f32, Instant, Instant)>,
    eye_triggered: bool,
    gauge_dirty: bool,
}
fn active(t: Option<Instant>) -> bool {
    t.is_some_and(|t| t > Instant::now())
}
fn until(s: u64) -> Option<Instant> {
    Some(Instant::now() + Duration::from_secs(s))
}
fn iai(id: u32) -> bool {
    matches!(id, 7487..=7489 | 36965 | 36966)
}
fn repeat(id: u32) -> bool {
    matches!(id, 16485 | 16486 | 36967 | 36968)
}
fn basic(id: u32) -> bool {
    matches!(id, 7477..=7486 | 25780 | 36963)
}
fn minimum(id: u32) -> u8 {
    match id {
        7477 => 1,
        7478 => 4,
        7498 => 6,
        7486 => 15,
        7479 => 18,
        7483 => 26,
        7481 | 7489 | 7867 => 30,
        7484 => 35,
        7482 | 7488 => 40,
        7485 => 45,
        7480 | 7487 | 7499 => 50,
        7490 => 52,
        7492 => 54,
        7493 => 56,
        7497 => 60,
        7491 => 62,
        7495 | 16482 => 68,
        7496 => 70,
        16481 => 72,
        16483 | 16485 | 16486 => 74,
        16487 => 80,
        36962 => 82,
        25780 => 86,
        25781 | 25782 => 90,
        36963 => 92,
        36964 => 96,
        36965..=36968 => 100,
        _ => 0,
    }
}
fn cost(id: u32) -> u8 {
    match id {
        7490 | 7491 | 7496 | 16481 => 25,
        7492 | 7493 => 10,
        36964 => 50,
        _ => 0,
    }
}
impl SamuraiState {
    fn iai(&self) -> u32 {
        match self.sen.count_ones() {
            1 => 7489,
            2 => {
                if active(self.tendo_until) {
                    36965
                } else {
                    7488
                }
            }
            3 => {
                if active(self.tendo_until) {
                    36966
                } else {
                    7487
                }
            }
            _ => 7867,
        }
    }
    fn resolve(&self, id: u32, l: u8) -> u32 {
        match id {
            7477 | 36963 => {
                if l >= 92 {
                    36963
                } else {
                    7477
                }
            }
            7483 | 25780 => {
                if l >= 86 {
                    25780
                } else {
                    7483
                }
            }
            7498 | 36962 => {
                if l >= 82 {
                    36962
                } else {
                    7498
                }
            }
            7867 => self.iai(),
            16483 if active(self.repeat_until) => self.repeat,
            25781 if self.ogi_repeat&&active(self.ogi_repeat_until) => 25782,
            16482 if l >= 96 && active(self.zanshin_until) => 36964,
            _ => id,
        }
    }
    fn pack(&self) -> u64 {
        let t=if self.ogi_repeat {self.ogi_repeat_until.map_or(0,|t|t.saturating_duration_since(Instant::now()).as_millis().min(30000)as u16)}else{0};let time=t.to_le_bytes();
        u64::from_le_bytes([
            time[0],
            time[1],
            if t>0 { 4 } else { 0 },
            self.kenki,
            self.meditation,
            self.sen,
            0,
            0,
        ])
    }
    fn gain_kenki(&mut self, n: u8, l: u8) {
        if l >= 52 {
            self.kenki = self.kenki.saturating_add(n).min(100);
        }
    }
}
pub(in crate::server) struct Samurai;
impl Job for Samurai {
    fn class_jobs(&self) -> &'static [u8] {
        &[34]
    }
    fn resolve_action(
        &self,
        r: &ActionRequest,
        c: &PlayerCombatState,
        l: u8,
        _: &mut GameData,
    ) -> u32 {
        c.samurai.resolve(r.action_id, l)
    }
    fn can_execute(&self, id: u32, c: &PlayerCombatState, l: u8) -> bool {
        if l < minimum(id) {
            return false;
        }
        let s = &c.samurai;
        if s.kenki < cost(id) {
            return false;
        }
        if iai(id) {
            return id == s.iai();
        }
        if repeat(id) {
            return active(s.repeat_until) && s.repeat == id;
        }
        match id {
            7867 | 16483 | 16484 => false,
            7495 => s.sen != 0,
            16482 => c.in_combat,
            16487 => s.meditation >= 3,
            25781 => active(s.ogi_until),
            25782 => s.ogi_repeat&&active(s.ogi_repeat_until),
            36964 => active(s.zanshin_until),
            _ => true,
        }
    }
    fn preserves_combo(&self, id: u32) -> bool {
        !matches!(id, 7477..=7485 | 25780 | 36963)
    }
    fn combo_action_id(&self, id: u32) -> u16 {
        match id {
            36963 => 7477,
            25780 => 7483,
            _ => id as u16,
        }
    }
    fn grants_combo(&self, id: u32, c: &PlayerCombatState) -> bool {
        matches!(id, 7478..=7482 | 7484 | 7485)
            && c.samurai.meikyo > 0
            && active(c.samurai.meikyo_until)
    }
    fn speed_percent(&self, a: &NetworkedActor) -> u32 {
        speed(a)
    }
    fn damage_percent(&self, a: &NetworkedActor) -> u32 {
        if a.status_effects().is_some_and(|s| s.get(1298).is_some()) {
            if a.get_common_spawn().level >= 78 {
                113
            } else {
                110
            }
        } else {
            100
        }
    }
    fn cast_100ms(&self, id: u32, a: &NetworkedActor) -> Option<u32> {
        if iai(id) {
            Some(if a.get_common_spawn().level >= 74 {
                13
            } else {
                18
            })
        } else {
            None
        }
    }
    fn animation_lock(&self, id: u32) -> f32 {
        if iai(id) || id == 25781 { 0.1 } else { 0.6 }
    }
    fn recast_100ms(&self, id: u32, a: &NetworkedActor) -> Option<u32> {
        if matches!(id, 7496 | 16481) {
            Some(if a.get_common_spawn().level >= 94 {
                600
            } else {
                1200
            })
        } else {
            None
        }
    }
    fn on_action_requested(&self, id: u32, a: &mut NetworkedActor) {
        if id != 7497
            && let NetworkedActor::Player {
                combat_state,
                status_effects,
                ..
            } = a
        {
            combat_state.samurai.meditate = None;
            status_effects.remove(1231);
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
        self.on_action_requested(id, a);
        let NetworkedActor::Player {
            combat_state,
            spawn,
            ..
        } = a
        else {
            return Default::default();
        };
        let s = &mut combat_state.samurai;
        let l = spawn.common.level;
        match id {
            7499 => {
                s.meikyo = 3;
                s.meikyo_until = until(20);
                if l >= 100 {
                    s.tendo_until = until(30);
                }
            }
            7495 => {
                s.gain_kenki(s.sen.count_ones() as u8 * 10, l);
                s.sen = 0;
            }
            16482 => {
                s.gain_kenki(50, l);
                if l >= 90 {
                    s.ogi_until = until(30);
                }
                if l >= 96 {
                    s.zanshin_until = until(30);
                }
            }
            _ => {}
        }
        JobActionUpdate {
            changed: true,
            ..Default::default()
        }
    }
    fn build_gauge_data(&self, c: &PlayerCombatState, _: u8) -> Option<u64> {
        Some(c.samurai.pack())
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
        let s = &mut combat_state.samurai;
        let before = s.pack();
        if spawn.common.health_points == 0 {
            *s = Default::default();
        }
        if !active(s.meikyo_until) || status_effects.get(1233).is_none() {
            s.meikyo = 0;
            s.meikyo_until = None;
        }
        if !active(s.repeat_until) {
            s.repeat = 0;
            s.kaeshi = 0;
            s.repeat_until = None;
        }
        if !active(s.ogi_repeat_until){s.ogi_repeat=false;s.ogi_repeat_until=None;}
        let changed = before != s.pack() || s.gauge_dirty;
        s.gauge_dirty = false;
        JobRefreshResult {
            changed,
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
impl JobActors for Samurai {
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
                combat_state.samurai = Default::default();
                for id in [
                    1231, 1232, 1233, 1236, 1298, 1299, 2959, 3852, 3853, 3854, 3855, 3856, 4216,
                    4217, 4218,
                ] {
                    status_effects.remove(id);
                }
            }
        }
    }
}
pub(in crate::server) fn speed(a: &NetworkedActor) -> u32 {
    if a.status_effects().is_some_and(|s| s.get(1299).is_some()) {
        if a.get_common_spawn().level >= 78 {
            87
        } else {
            90
        }
    } else {
        100
    }
}
pub(in crate::server) fn mitigation(a: &NetworkedActor) -> f64 {
    let Some(s) = a.status_effects() else {
        return 1.0;
    };
    (if s.get(1232).is_some() || s.get(3853).is_some() {
        0.9
    } else {
        1.0
    }) * (if s.get(3854).is_some() { 0.9 } else { 1.0 })
}
pub(in crate::server) fn on_damage(a: &mut NetworkedActor) {
    if a.status_effects()
        .is_some_and(|s| s.get(1232).is_some() || s.get(3853).is_some())
        && let NetworkedActor::Player {
            combat_state,
            status_effects,
            spawn,
            ..
        } = a
    {
        combat_state.samurai.gain_kenki(10, spawn.common.level);
        combat_state.samurai.gauge_dirty = true;
        combat_state.samurai.eye_triggered = status_effects.get(3853).is_some();
        status_effects.remove(1232);
        status_effects.remove(3853);
    }
}
