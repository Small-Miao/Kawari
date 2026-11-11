//! 暗黑骑士：资源、状态生命周期及原生职业接入。
mod actors;
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
use kawari::common::{ObjectId, Position};
use kawari::ipc::zone::{ActionRequest, DamageType, TargetEffectKind};
use std::time::{Duration, Instant};

#[derive(Debug, Clone, Default)]
pub struct DarkKnightState {
    pub blood: u8,
    pub dark_arts: bool,
    pub darkside_until: Option<Instant>,
    pub shadow_until: Option<Instant>,
    pub delirium_until: Option<Instant>,
    pub delirium_stacks: u8,
    pub blood_weapon_until: Option<Instant>,
    pub blood_weapon_stacks: u8,
    pub combo_until: Option<Instant>,
    pub combo_step: u16,
    pub scorn_until: Option<Instant>,
    pub salted_center: Option<Position>,
    pub salted_until: Option<Instant>,
    pub salted_next_tick: Option<Instant>,
    pub salted_object: Option<ObjectId>,
    pub salted_modifiers: Option<crate::server::action::ActionDamageModifiers>,
    pub salted_parameters: Option<crate::zone_connection::BaseParameters>,
    pub shadow_actor: Option<ObjectId>,
    pub shadow_started: Option<Instant>,
    pub shadow_step: usize,
    pub shadow_target: Option<ObjectId>,
    pub walking_dead_until: Option<Instant>,
    pub walking_dead_healed: u32,
    pub vigil_until: Option<Instant>,
    pub vigil_pending: bool,
}

pub(super) fn active(until: Option<Instant>) -> bool {
    until.is_some_and(|t| t > Instant::now())
}
pub(super) fn deadline(seconds: u64) -> Option<Instant> {
    Some(Instant::now() + Duration::from_secs(seconds))
}
pub(super) fn darkside_action(id: u32) -> bool {
    matches!(id, 16466 | 16467 | 16469 | 16470)
}
pub(super) fn gcd(id: u32) -> bool {
    matches!(
        id,
        3617 | 3623 | 3632 | 3621 | 3624 | 16468 | 7391 | 7392 | 36928..=36931
    )
}
pub(super) fn timer(until: Option<Instant>) -> u16 {
    until.map_or(0, |t| {
        t.saturating_duration_since(Instant::now())
            .as_millis()
            .min(60000) as u16
    })
}

fn live(statuses: &StatusEffects, id: u16) -> bool {
    statuses.get(id).is_some_and(|s| s.duration > 0.0)
}
pub(in crate::server) struct DarkKnight;
impl Job for DarkKnight {
    fn class_jobs(&self) -> &'static [u8] {
        &[32]
    }
    fn animation_lock(&self, id: u32) -> f32 {
        if matches!(id, 17904..=17909 | 17915 | 25881 | 36933 | 38512) {
            2.2
        } else {
            0.6
        }
    }
    fn resolve_action(
        &self,
        r: &ActionRequest,
        s: &PlayerCombatState,
        l: u8,
        _: &mut GameData,
    ) -> u32 {
        s.dark_knight.resolve(r.action_id, l)
    }
    fn can_execute(&self, id: u32, s: &PlayerCombatState, l: u8) -> bool {
        s.dark_knight.can_execute(id, l)
    }
    fn apply_gauge_action(&self, _: &mut PlayerCombatState, _: &GaugeAction) {}
    fn action_effects(
        &self,
        id: u32,
        a: &NetworkedActor,
        t: Option<&NetworkedActor>,
        combo: bool,
    ) -> Option<EffectsBuilder> {
        effects::effects(id, a, t, combo)
    }
    fn preserves_combo(&self, id: u32) -> bool {
        !matches!(id, 3617 | 3623 | 3632 | 3621 | 16468)
    }
    fn damage_percent(&self, a: &NetworkedActor) -> u32 {
        if matches!(a,NetworkedActor::Player{combat_state,..} if combat_state.dark_knight.has_darkside())
        {
            110
        } else {
            100
        }
    }
    fn mp_cost(&self, id: u32, a: &NetworkedActor, c: u32) -> Option<u32> {
        if let NetworkedActor::Player { combat_state, .. } = a {
            Some(combat_state.dark_knight.mp_cost(id, c))
        } else {
            None
        }
    }
    fn hit_test(&self, instance: &Instance, caster: ObjectId, target: ObjectId, id: u32) -> bool {
        if effects::potency(id, 100, true) == 0 {
            return true;
        }
        let hittable = |id| matches!(instance.find_actor(id),Some(NetworkedActor::Npc{currently_invulnerable:false,spawn,..}) if spawn.common.health_points>0);
        if let Some((center, direction, shape)) = effects::geometry(instance, caster, target, id) {
            super::native::targets(instance, center.0, direction, shape)
                .into_iter()
                .any(hittable)
        } else {
            hittable(target)
        }
    }
    fn filter_missed_effects(&self, id: u32, r: &mut EffectsBuilder) {
        if effects::potency(id, 100, true) > 0 {
            r.effects.retain(|e| {
                !matches!(
                    e.0,
                    TargetEffectKind::Heal { .. } | TargetEffectKind::MpGain { .. }
                )
            });
        }
    }
    fn after_combo(&self, id: u32, a: &mut NetworkedActor, _: ObjectId) {
        if let NetworkedActor::Player {
            spawn,
            combat_state,
            ..
        } = a
        {
            if spawn.common.level >= 62 && matches!(id, 3632 | 16468) {
                combat_state.dark_knight.blood = (combat_state.dark_knight.blood + 20).min(100);
            }
        }
    }
    fn update_state_after_action(
        &self,
        id: u32,
        a: &mut NetworkedActor,
        owner: ObjectId,
    ) -> JobActionUpdate {
        self.update_state_after_result(id, a, owner, true)
    }
    fn update_state_after_result(
        &self,
        id: u32,
        a: &mut NetworkedActor,
        owner: ObjectId,
        hit: bool,
    ) -> JobActionUpdate {
        let NetworkedActor::Player {
            spawn,
            combat_state,
            status_effects,
            ..
        } = a
        else {
            return Default::default();
        };
        combat_state
            .dark_knight
            .advance(id, spawn.common.level, false, hit);
        let s = &combat_state.dark_knight;
        if gcd(id) {
            for (status, count, end) in [
                (742, s.blood_weapon_stacks, s.blood_weapon_until),
                (
                    if spawn.common.level >= 96 { 3836 } else { 1972 },
                    s.delirium_stacks,
                    s.delirium_until,
                ),
            ] {
                if status_effects.get(status).is_some() {
                    if count == 0 {
                        status_effects.remove(status);
                    } else {
                        status_effects.add_with_source(
                            status,
                            count as u16,
                            timer(end) as f32 / 1000.0,
                            owner,
                        );
                    }
                }
            }
        }
        let mut result = JobActionUpdate {
            changed: true,
            ..Default::default()
        };
        if id == 3624 && hit && spawn.common.level >= 84 {
            if let Some(index) = combat_state
                .cooldowns
                .iter()
                .position(|c| c.as_ref().is_some_and(|c| c.action_id == 36926))
            {
                combat_state.reduce_cooldown_recovery(index, Duration::from_secs(5));
                result.cooldown_update = Some(super::dispatch::JobCooldownUpdate {
                    cooldown_group: index as u32,
                    delta_centisec: 500,
                });
            }
        }
        result
    }
    fn build_gauge_data(&self, s: &PlayerCombatState, l: u8) -> Option<u64> {
        Some(s.dark_knight.pack(l))
    }
    fn build_gauge_extra(&self, s: &PlayerCombatState, l: u8) -> [u8; 6] {
        s.dark_knight.extra(l)
    }
    fn refresh_runtime_state_on_actor(
        &self,
        owner: ObjectId,
        a: &mut NetworkedActor,
    ) -> JobRefreshResult {
        let NetworkedActor::Player {
            spawn,
            combat_state,
            status_effects,
            parameters,
            ..
        } = a
        else {
            return Default::default();
        };
        let s = &mut combat_state.dark_knight;
        let mut changed = false;
        for end in [
            &mut s.darkside_until,
            &mut s.shadow_until,
            &mut s.scorn_until,
        ] {
            if end.is_some() && !active(*end) {
                *end = None;
                changed = true;
            }
        }
        if !active(s.combo_until) && s.combo_step != 0 {
            s.combo_step = 0;
            s.combo_until = None;
            changed = true;
        }
        if (!active(s.delirium_until) || !live(status_effects, 1972) && !live(status_effects, 3836))
            && s.delirium_stacks > 0
        {
            s.delirium_stacks = 0;
            status_effects.remove(1972);
            status_effects.remove(3836);
            changed = true;
        }
        if (!active(s.blood_weapon_until) || !live(status_effects, 742))
            && s.blood_weapon_stacks > 0
        {
            s.blood_weapon_stacks = 0;
            status_effects.remove(742);
            changed = true;
        }
        if s.walking_dead_until.is_some() && !active(s.walking_dead_until) {
            if s.walking_dead_healed < spawn.common.max_health_points && !combat_state.god_mode {
                spawn.common.health_points = 0;
            }
            s.walking_dead_until = None;
            status_effects.remove(811);
            status_effects.remove(3255);
            changed = true;
        }
        let heal = if s.vigil_pending
            && (!active(s.vigil_until)
                || spawn.common.health_points < spawn.common.max_health_points / 2)
        {
            s.vigil_pending = false;
            s.vigil_until = None;
            status_effects.remove(3902);
            changed = true;
            if spawn.common.health_points > 0 {
                parameters.calc_heal_amount(1200)
            } else {
                0
            }
        } else {
            0
        };
        if heal > 0 {
            let amount =
                (heal as f64 * super::white_mage::incoming_heal_multiplier(Some(a))) as u32;
            a.apply_heal(amount);
        }
        let dead = a.get_common_spawn().health_points == 0;
        if dead {
            if let NetworkedActor::Player {
                combat_state,
                status_effects,
                ..
            } = a
            {
                let s = &mut combat_state.dark_knight;
                changed |= s.blood > 0 || s.dark_arts || s.darkside_until.is_some();
                s.blood = 0;
                s.dark_arts = false;
                s.darkside_until = None;
                s.scorn_until = None;
                s.combo_until = None;
                s.combo_step = 0;
                s.delirium_stacks = 0;
                s.blood_weapon_stacks = 0;
                s.vigil_pending = false;
                for id in [742, 1972, 3836, 3837, 810, 811, 3255, 3902] {
                    status_effects.remove(id);
                }
            }
        }
        let _ = owner;
        JobRefreshResult {
            changed,
            status_timer_refreshed: changed,
            ..Default::default()
        }
    }
    fn apply_area_action(
        &self,
        n: &mut NetworkState,
        i: &mut Instance,
        c: JobAreaContext<'_>,
    ) -> Option<crate::server::action::area::AreaResult> {
        effects::area(n, i, c)
    }
    fn persistent_actors(&self) -> Option<&dyn JobActors> {
        Some(self)
    }
}

/// 致死伤害先激活行尸走肉，再由统一 HP 路径应用 1 HP 下限；不会复活尸体。
pub(in crate::server) fn death_floor(a: &mut NetworkedActor, damage: u32) -> bool {
    let NetworkedActor::Player {
        spawn,
        status_effects,
        combat_state,
        ..
    } = a
    else {
        return false;
    };
    if spawn.common.health_points == 0 {
        return false;
    }
    if live(status_effects, 810) && damage >= spawn.common.health_points {
        let source = status_effects.get(810).unwrap().source_actor_id;
        status_effects.remove(810);
        status_effects.add_with_source(811, 0, 10.0, source);
        combat_state.dark_knight.walking_dead_until = deadline(10);
        combat_state.dark_knight.walking_dead_healed = 0;
    }
    active(combat_state.dark_knight.walking_dead_until)
        && (live(status_effects, 811) || live(status_effects, 3255))
}

/// 累计收到的治疗量（包含溢出治疗），达标后继承原免死截止时间。
pub(in crate::server) fn healed(a: &mut NetworkedActor, amount: u32) {
    let NetworkedActor::Player {
        spawn,
        status_effects,
        combat_state,
        ..
    } = a
    else {
        return;
    };
    let s = &mut combat_state.dark_knight;
    if !active(s.walking_dead_until) || !live(status_effects, 811) {
        return;
    }
    s.walking_dead_healed = s.walking_dead_healed.saturating_add(amount);
    if s.walking_dead_healed >= spawn.common.max_health_points {
        let source = status_effects.get(811).unwrap().source_actor_id;
        status_effects.remove(811);
        status_effects.add_with_source(
            3255,
            0,
            timer(s.walking_dead_until) as f32 / 1000.0,
            source,
        );
    }
}
pub(in crate::server) fn mitigation(a: &NetworkedActor, kind: DamageType) -> f64 {
    let Some(s) = a.status_effects() else {
        return 1.0;
    };
    let mut m = if a.get_common_spawn().class_job == 32 {
        0.8
    } else {
        1.0
    };
    for (id, scale) in [
        (747, 0.7),
        (3835, 0.6),
        (2682, 0.9),
        (746, if kind == DamageType::Magic { 0.8 } else { 0.9 }),
        (1894, if kind == DamageType::Magic { 0.9 } else { 0.95 }),
    ] {
        if live(s, id) {
            m *= scale;
        }
    }
    m
}
pub(in crate::server) fn barrier_broken(
    network: &mut NetworkState,
    instance: &mut Instance,
    source: ObjectId,
) {
    let Some(NetworkedActor::Player {
        combat_state,
        spawn,
        ..
    }) = instance.find_actor_mut(source)
    else {
        return;
    };
    if spawn.common.class_job != 32 || spawn.common.health_points == 0 {
        return;
    }
    combat_state.dark_knight.dark_arts = true;
    super::dispatch::send_job_gauge_update_extended(
        network,
        source,
        32,
        combat_state.dark_knight.pack(spawn.common.level),
        combat_state.dark_knight.extra(spawn.common.level),
    );
}

impl DarkKnightState {
    pub fn has_darkside(&self) -> bool {
        active(self.darkside_until)
    }
    pub fn blood_weapon(&self) -> bool {
        active(self.blood_weapon_until) && self.blood_weapon_stacks > 0
    }
    pub fn delirium(&self) -> bool {
        active(self.delirium_until) && self.delirium_stacks > 0
    }
    pub fn resolve(&self, action: u32, level: u8) -> u32 {
        match action {
            3625 if level >= 68 => 7390,
            16466 if level >= 74 => 16469,
            16467 if level >= 74 => 16470,
            3636 if level >= 92 => 36927,
            7392 if level >= 96 && self.delirium() => match self.combo_step {
                1 => 36929,
                2 => 36930,
                _ => 36928,
            },
            7391 if level >= 96 && self.delirium() => 36931,
            3639 if level >= 86 && active(self.salted_until) => 25755,
            16472 if level >= 100 && active(self.scorn_until) => 36932,
            _ => action,
        }
    }
    pub fn can_execute(&self, action: u32, level: u8) -> bool {
        let minimum = match action {
            3617 => 1,
            3623 => 2,
            3621 => 6,
            3629 | 32067 => 10,
            3624 => 15,
            3632 => 26,
            16466 => 30,
            3625 => 35,
            16468 => 40,
            3634 => 45,
            3636 => 38,
            3638 => 50,
            3639 => 52,
            16467 => 40,
            3641 => 56,
            3643 => 60,
            7392 => 62,
            7391 => 64,
            7390 => 68,
            7393 => 70,
            16469 | 16470 => 74,
            16471 => 66,
            16472 => 80,
            25754 => 82,
            36926 => 54,
            25755 => 86,
            25757 => 90,
            36927 => 92,
            36928..=36931 => 96,
            36932 => 100,
            _ => 0,
        };
        if level < minimum {
            return false;
        }
        match action {
            7 => false,
            7391 | 7392 => self.blood >= 50 || self.delirium(),
            36928 => self.delirium() && self.combo_step == 0,
            36929 => self.delirium() && self.combo_step == 1 && active(self.combo_until),
            36930 => self.delirium() && self.combo_step == 2 && active(self.combo_until),
            36931 => self.delirium(),
            36932 => active(self.scorn_until),
            25755 => active(self.salted_until),
            25757 => self.has_darkside(),
            _ => true,
        }
    }
    pub fn pack(&self, level: u8) -> u64 {
        let side = timer(self.darkside_until).to_le_bytes();
        let shadow = if level >= 80 {
            timer(self.shadow_until)
        } else {
            0
        }
        .to_le_bytes();
        let combo = if level >= 96 {
            timer(self.combo_until)
        } else {
            0
        }
        .to_le_bytes();
        u64::from_le_bytes([
            if level >= 62 { self.blood } else { 0 },
            u8::from(level >= 70 && self.dark_arts),
            side[0],
            side[1],
            shadow[0],
            shadow[1],
            combo[0],
            combo[1],
        ])
    }
    pub fn extra(&self, level: u8) -> [u8; 6] {
        let step = if level >= 96 && active(self.combo_until) {
            self.combo_step
        } else {
            0
        }
        .to_le_bytes();
        [step[0], step[1], 0, 0, 0, 0]
    }
    pub fn mp_cost(&self, action: u32, sheet: u32) -> u32 {
        if darkside_action(action) && self.dark_arts {
            0
        } else {
            sheet
        }
    }
    /// 只计算命中产生的恢复；嗜血在范围攻击命中多目标时也只触发一次。
    pub fn mp_on_hit(&self, action: u32, combo: bool) -> u16 {
        let blood = if gcd(action) && self.blood_weapon() {
            600
        } else {
            0
        };
        let own = match action {
            3623 | 16468 if combo => 600,
            3643 | 3641 => 600,
            36928..=36930 => 200,
            36931 => 500,
            7392 if self.delirium() => 200,
            7391 if self.delirium() => 500,
            _ => 0,
        };
        blood + own
    }
    pub fn advance(&mut self, action: u32, level: u8, combo: bool, landed: bool) {
        if !active(self.combo_until) {
            self.combo_step = 0;
        }
        if matches!(action, 7391 | 7392) && !self.delirium() {
            self.blood = self.blood.saturating_sub(50);
        }
        if landed && gcd(action) && self.blood_weapon() {
            self.blood_weapon_stacks -= 1;
            if level >= 66 {
                self.blood = (self.blood + 10).min(100);
            }
        }
        if landed && combo && matches!(action, 3632 | 16468) && level >= 62 {
            self.blood = (self.blood + 20).min(100);
        }
        if matches!(action, 7391 | 7392 | 36928..=36931) && self.delirium() {
            self.delirium_stacks -= 1;
            self.combo_step = match action {
                36928 => 1,
                36929 => 2,
                _ => 0,
            };
            self.combo_until = if self.combo_step > 0 {
                deadline(30)
            } else {
                None
            };
        }
        if darkside_action(action) {
            self.dark_arts = false;
            let remaining = timer(self.darkside_until) as u64;
            self.darkside_until =
                Some(Instant::now() + Duration::from_millis((remaining + 30000).min(60000)));
        }
        match action {
            3625 | 7390 => {
                self.blood_weapon_until = deadline(15);
                self.blood_weapon_stacks = 3;
                if action == 7390 {
                    self.delirium_until = deadline(15);
                    self.delirium_stacks = 3;
                    self.combo_step = 0;
                    self.combo_until = None;
                }
            }
            16472 => {
                self.shadow_until = deadline(22);
                if level >= 100 {
                    self.scorn_until = deadline(30);
                }
            }
            36932 => self.scorn_until = None,
            36927 => {
                self.vigil_until = deadline(20);
                self.vigil_pending = true;
            }
            _ => {}
        }
    }
}
