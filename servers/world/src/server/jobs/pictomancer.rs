//! 画家 PvE：画布、颜料、连击与限时预备；状态与量谱由同一状态机生成。

mod data;
mod effects;
use crate::{
    StatusEffects,
    gamedata::GameData,
    lua::GaugeAction,
    server::{
        actor::NetworkedActor,
        combat_state::PlayerCombatState,
        jobs::dispatch::{Job, JobActionUpdate, JobRefreshResult},
    },
};
pub(crate) use effects::{
    action_effects, deactivate, finish_action, on_barrier_break, refresh_field, support_result,
};
use kawari::{
    common::{ObjectId, Position},
    ipc::zone::ActionRequest,
};
use serde::{Deserialize, Serialize};
use std::time::{Duration, Instant};

pub(crate) const CLASS_JOB: u8 = 42;
pub(crate) const SUBTRACTIVE: u16 = 3674;
pub(crate) const HUE: u16 = 3675;
pub(crate) const HUE_II: u16 = 3676;
pub(crate) const RAINBOW: u16 = 3679;
pub(crate) const HAMMER: u16 = 3680;
pub(crate) const STARSTRUCK: u16 = 3681;
pub(crate) const SMUDGE: u16 = 3684;
pub(crate) const STARRY: u16 = 3685;
pub(crate) const COAT: u16 = 3686;
pub(crate) const GRASSA: u16 = 3687;
pub(crate) const HYPER: u16 = 3688;
pub(crate) const INSPIRATION: u16 = 3689;
pub(crate) const SPECTRUM: u16 = 3690;
pub(crate) const MONOCHROME: u16 = 3691;

#[derive(Debug, Clone, Default, Serialize, Deserialize, PartialEq)]
pub struct PictomancerState {
    pub palette: u8,
    pub paint: u8,
    pub canvas: u8,
    pub creature: u8,
    pub hue: u8,
    pub subtractive: u8,
    pub monochrome: bool,
    pub hammer: u8,
    pub hyper: u8,
    #[serde(skip)]
    pub hue_until: Option<Instant>,
    #[serde(skip)]
    pub hammer_until: Option<Instant>,
    #[serde(skip)]
    pub spectrum_until: Option<Instant>,
    #[serde(skip)]
    pub rainbow_until: Option<Instant>,
    #[serde(skip)]
    pub starstruck_until: Option<Instant>,
    #[serde(skip)]
    pub hyper_until: Option<Instant>,
    #[serde(skip)]
    pub field_until: Option<Instant>,
    #[serde(skip)]
    pub field_center: Option<Position>,
    #[serde(skip)]
    pub field_object: Option<ObjectId>,
    #[serde(skip)]
    pub coat_until: Option<Instant>,
    #[serde(skip)]
    pub muse_animation_until: Option<Instant>,
    pub inspired: bool,
}

fn active(until: Option<Instant>, now: Instant) -> bool {
    until.is_some_and(|t| t > now)
}
fn until(now: Instant, seconds: u64) -> Option<Instant> {
    Some(now + Duration::from_secs(seconds))
}
fn color(action: u32) -> Option<(bool, u8)> {
    (34650..=34661).contains(&action).then(|| {
        let index = action - 34650;
        ((index / 3) % 2 == 1, (index % 3) as u8)
    })
}
pub(crate) fn is_motif(action: u32) -> bool {
    (34664..=34669).contains(&action)
}
pub(crate) fn uses_inspiration(action: u32) -> bool {
    (34650..=34663).contains(&action) || action == 34681
}

impl PictomancerState {
    fn next_motif(&self, level: u8) -> u32 {
        if self.creature & 1 == 0 {
            34664
        } else if self.creature & 2 == 0 {
            34665
        } else if level >= 96 && self.creature & 4 == 0 {
            34666
        } else if level >= 96 {
            34667
        } else {
            34664
        }
    }
    fn live_hue(&self, now: Instant) -> u8 {
        if active(self.hue_until, now) {
            self.hue
        } else {
            0
        }
    }
    pub(crate) fn resolve(&self, action: u32, level: u8, now: Instant) -> u32 {
        match action {
            34650 | 34656 => {
                let base = action + if self.subtractive > 0 { 3 } else { 0 };
                let candidate = base + u32::from(self.live_hue(now));
                if data::level(candidate).is_some_and(|required| level < required) {
                    base
                } else {
                    candidate
                }
            }
            34689 => self.next_motif(level),
            34690 => 34668,
            34691 => 34669,
            35347 => match self.canvas & 15 {
                1 => 34670,
                2 => 34671,
                4 => 34672,
                8 => 34673,
                _ => 35347,
            },
            35348 => 34674,
            35349 => 34675,
            34676 if self.creature & 32 != 0 => 34677,
            34678 if level >= 86 && active(self.hammer_until, now) => {
                34678 + u32::from(3 - self.hammer.min(3))
            }
            34662 if self.monochrome => 34663,
            _ => action,
        }
    }
    pub(crate) fn can_execute(
        &self,
        action: u32,
        level: u8,
        in_combat: bool,
        now: Instant,
    ) -> bool {
        if let Some(required) = data::level(action) {
            if level < required {
                return false;
            }
        }
        if let Some((subtractive, hue)) = color(action) {
            let current = self.live_hue(now);
            let base = action - u32::from(hue);
            let fallback = hue == 0
                && data::level(base + u32::from(current)).is_some_and(|required| level < required);
            return (self.subtractive > 0) == subtractive && (current == hue || fallback);
        }
        match action {
            34662 => self.paint > 0 && !self.monochrome,
            34663 => self.paint > 0 && self.monochrome,
            34664..=34667 => self.canvas & 15 == 0 && action == self.next_motif(level),
            34668 => self.canvas & 16 == 0 && !active(self.hammer_until, now),
            34669 => self.canvas & 32 == 0 && !active(self.field_until, now),
            34670..=34673 => self.canvas & 15 == 1 << (action - 34670),
            34674 => in_combat && self.canvas & 16 != 0,
            34675 => in_combat && self.canvas & 32 != 0,
            34676 => self.creature & 16 != 0,
            34677 => self.creature & 32 != 0,
            34678..=34680 => {
                self.hammer > 0
                    && active(self.hammer_until, now)
                    && (if level >= 86 {
                        action == 34678 + u32::from(3 - self.hammer.min(3))
                    } else {
                        action == 34678
                    })
            }
            34681 => active(self.starstruck_until, now),
            34682 => false, // 星空棱光的治疗是服务端派生动作，客户端不能直接请求。
            34683 => {
                self.subtractive == 0 && (self.palette >= 50 || active(self.spectrum_until, now))
            }
            34686 => active(self.coat_until, now),
            34689..=34691 | 35347..=35349 => false,
            _ => true,
        }
    }
    pub(crate) fn gauge(&self, level: u8, now: Instant) -> u64 {
        u64::from_le_bytes([
            if level >= 60 { self.palette } else { 0 },
            0,
            if level >= 80 { self.paint } else { 0 },
            self.canvas,
            self.creature,
            u8::from(active(self.muse_animation_until, now)),
            0,
            0,
        ])
    }
    fn add_paint(&mut self, level: u8) {
        if level >= 80 {
            self.paint = (self.paint + 1).min(5);
        }
    }
    fn apply(&mut self, action: u32, level: u8, position: Position, now: Instant) {
        if let Some((subtractive, hue)) = color(action) {
            self.hue = (hue + 1) % 3;
            self.hue_until = if self.hue == 0 { None } else { until(now, 30) };
            if subtractive {
                self.subtractive = self.subtractive.saturating_sub(1);
            }
            if hue == 2 {
                if !subtractive && level >= 60 {
                    self.palette = (self.palette + 25).min(100);
                }
                self.add_paint(level);
            }
        }
        match action {
            34662 | 34663 => {
                self.paint = self.paint.saturating_sub(1);
                if action == 34663 {
                    self.monochrome = false;
                }
            }
            34664..=34669 => self.canvas |= 1 << (action - 34664),
            34670..=34673 => {
                self.canvas &= !15;
                self.creature |= 1 << (action - 34670);
                if action == 34671 {
                    self.creature = if level >= 96 { 3 | 16 } else { 16 };
                }
                if action == 34673 {
                    self.creature = 32;
                }
                self.muse_animation_until = until(now, 1);
            }
            34674 => {
                self.canvas &= !16;
                self.hammer = 3;
                self.hammer_until = until(now, 30);
            }
            34675 => {
                self.canvas &= !32;
                self.field_center = Some(position);
                self.field_until = until(now, 20);
                self.spectrum_until = until(now, 30);
                if level >= 82 {
                    self.hyper = 5;
                    self.hyper_until = until(now, 30);
                    self.inspired = true;
                }
                if level >= 100 {
                    self.starstruck_until = until(now, 20);
                }
            }
            34676 => self.creature &= !16,
            34677 => self.creature &= !32,
            34678..=34680 => {
                self.hammer = self.hammer.saturating_sub(1);
                if self.hammer == 0 {
                    self.hammer_until = None;
                }
            }
            34681 => self.starstruck_until = None,
            34683 => {
                if !active(self.spectrum_until, now) {
                    self.palette = self.palette.saturating_sub(50);
                }
                self.spectrum_until = None;
                self.subtractive = 3;
                if level >= 90 {
                    self.monochrome = true;
                }
            }
            34685 => self.coat_until = until(now, 10),
            34686 => self.coat_until = None,
            34688 => {
                self.add_paint(level);
                self.rainbow_until = None;
            }
            _ => {}
        }
        if uses_inspiration(action)
            && self.inspired
            && active(self.field_until, now)
            && active(self.hyper_until, now)
            && self.hyper > 0
        {
            self.hyper -= 1;
            if self.hyper == 0 {
                self.inspired = false;
                self.hyper_until = None;
                if level >= 92 {
                    self.rainbow_until = until(now, 30);
                }
            }
        }
    }
    fn sync(&mut self, effects: &mut StatusEffects, owner: ObjectId, now: Instant) {
        let live_hue = self.live_hue(now);
        if live_hue == 0 {
            self.hue = 0;
            self.hue_until = None;
        }
        if !active(self.hammer_until, now) {
            self.hammer = 0;
        }
        if !active(self.hyper_until, now) {
            self.hyper = 0;
            self.inspired = false;
        }
        for (id, param, expiry, enabled) in [
            (HUE, 0, self.hue_until, live_hue == 1),
            (HUE_II, 0, self.hue_until, live_hue == 2),
            (
                HAMMER,
                self.hammer as u16,
                self.hammer_until,
                self.hammer > 0,
            ),
            (
                RAINBOW,
                0,
                self.rainbow_until,
                active(self.rainbow_until, now),
            ),
            (
                SPECTRUM,
                0,
                self.spectrum_until,
                active(self.spectrum_until, now),
            ),
            (
                STARSTRUCK,
                0,
                self.starstruck_until,
                active(self.starstruck_until, now),
            ),
            (HYPER, self.hyper as u16, self.hyper_until, self.hyper > 0),
        ] {
            if enabled {
                effects.add_with_source(
                    id,
                    param,
                    expiry.unwrap().saturating_duration_since(now).as_secs_f32(),
                    owner,
                );
            } else {
                effects.remove(id);
            }
        }
        if self.subtractive > 0 {
            effects.add_with_source(SUBTRACTIVE, self.subtractive as u16, 0.0, owner);
        } else {
            effects.remove(SUBTRACTIVE);
        }
        if self.monochrome {
            effects.add_with_source(MONOCHROME, 0, 0.0, owner);
        } else {
            effects.remove(MONOCHROME);
        }
        if !self.inspired {
            effects.remove(INSPIRATION);
        }
    }
}

pub(crate) fn instant(actor: &NetworkedActor, action: u32) -> bool {
    let NetworkedActor::Player { combat_state, .. } = actor else {
        return false;
    };
    actor.get_common_spawn().class_job == CLASS_JOB
        && ((is_motif(action) && !combat_state.in_combat)
            || action == 34688 && active(combat_state.pictomancer.rainbow_until, Instant::now()))
}
pub(crate) fn haste(actor: &NetworkedActor, action: u32) -> bool {
    matches!(actor,NetworkedActor::Player {combat_state,..} if uses_inspiration(action) && combat_state.pictomancer.inspired && active(combat_state.pictomancer.field_until,Instant::now()) && combat_state.pictomancer.hyper>0)
}

pub(in crate::server) struct Pictomancer;
impl Job for Pictomancer {
    fn class_jobs(&self) -> &'static [u8] {
        &[CLASS_JOB]
    }
    fn resolve_action(
        &self,
        r: &ActionRequest,
        c: &PlayerCombatState,
        l: u8,
        _: &mut GameData,
    ) -> u32 {
        c.pictomancer.resolve(r.action_id, l, Instant::now())
    }
    fn can_execute(&self, a: u32, c: &PlayerCombatState, l: u8) -> bool {
        c.pictomancer.can_execute(a, l, c.in_combat, Instant::now())
    }
    fn apply_gauge_action(&self, _: &mut PlayerCombatState, _: &GaugeAction) {}
    fn update_state_after_action(
        &self,
        a: u32,
        actor: &mut NetworkedActor,
        owner: ObjectId,
    ) -> JobActionUpdate {
        let NetworkedActor::Player {
            combat_state,
            status_effects,
            spawn,
            ..
        } = actor
        else {
            return Default::default();
        };
        if !data::is_job_action(a) {
            return Default::default();
        }
        let now = Instant::now();
        combat_state
            .pictomancer
            .apply(a, spawn.common.level, spawn.common.position, now);
        if a == 34686 {
            status_effects.remove(COAT);
        }
        combat_state.pictomancer.sync(status_effects, owner, now);
        JobActionUpdate {
            changed: true,
            status_timer_refreshed: true,
            ..Default::default()
        }
    }
    fn build_gauge_data(&self, c: &PlayerCombatState, l: u8) -> Option<u64> {
        Some(c.pictomancer.gauge(l, Instant::now()))
    }
    fn refresh_runtime_state_on_actor(
        &self,
        owner: ObjectId,
        actor: &mut NetworkedActor,
    ) -> JobRefreshResult {
        let NetworkedActor::Player {
            combat_state,
            status_effects,
            spawn,
            ..
        } = actor
        else {
            return Default::default();
        };
        let now = Instant::now();
        let state = &mut combat_state.pictomancer;
        let before = state.clone();
        if state.coat_until.is_some() && status_effects.get(COAT).is_none() {
            state.coat_until = None;
        }
        // 仅到期时同步，避免每帧重发状态列表。
        if state.hue != 0 && !active(state.hue_until, now)
            || state.hammer > 0 && !active(state.hammer_until, now)
            || state.hyper > 0 && !active(state.hyper_until, now)
        {
            state.sync(status_effects, owner, now);
        }
        if state.muse_animation_until.is_some() && !active(state.muse_animation_until, now) {
            state.muse_animation_until = None;
        }
        let changed = *state != before;
        let _ = spawn;
        JobRefreshResult {
            changed,
            status_timer_refreshed: changed,
            ..Default::default()
        }
    }
}

/// 直线范围采用水平投影，拒绝身后、侧面与射程外目标。
pub(crate) fn line_contains(
    origin: glam::Vec3,
    target: glam::Vec3,
    point: glam::Vec3,
    length: f32,
    half_width: f32,
) -> bool {
    let forward = glam::Vec2::new(target.x - origin.x, target.z - origin.z).normalize_or_zero();
    let delta = glam::Vec2::new(point.x - origin.x, point.z - origin.z);
    let along = delta.dot(forward);
    along >= 0.0
        && along <= length
        && (delta.x * forward.y - delta.y * forward.x).abs() <= half_width
}

#[cfg(test)]
mod tests;
