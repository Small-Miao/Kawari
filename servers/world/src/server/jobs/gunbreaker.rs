//! 绝枪战士：晶壤、特殊连击、续剑和队友防御。使用国服本地表及 GNB-08 包。
use super::{
    dispatch::{Job, JobActionUpdate, JobAreaContext, JobRefreshResult},
    native::{self, AreaAttack, Shape, damage, heal, lose, status},
    paladin, white_mage,
};
use crate::{
    StatusEffects,
    gamedata::GameData,
    lua::{BarrierAction, EffectsBuilder, EnmityAction, GaugeAction, TickAction, TickKind},
    server::{
        action::area::{AreaResult, party_in_range},
        actor::NetworkedActor,
        combat_state::PlayerCombatState,
        instance::Instance,
        network::NetworkState,
    },
};
use kawari::{
    common::ObjectId,
    ipc::zone::{ActionRequest, DamageType, TargetEffect, TargetEffectKind},
};
use std::time::{Duration, Instant};

#[derive(Debug, Clone, Default)]
pub struct GunbreakerState {
    pub ammo: u8,
    pub combo_step: u8,
    pub combo_until: Option<Instant>,
    pub continuation: u16,
    pub continuation_until: Option<Instant>,
    pub bloodfest_until: Option<Instant>,
    pub sonic_until: Option<Instant>,
    pub lion_until: Option<Instant>,
    nebula_bonus: u32,
    corundum: Option<(Instant, u32, ObjectId)>,
}
fn active(t: Option<Instant>) -> bool {
    t.is_some_and(|t| t > Instant::now())
}
fn until(s: u64) -> Option<Instant> {
    Some(Instant::now() + Duration::from_secs(s))
}
fn live(s: &StatusEffects, id: u16) -> bool {
    s.get(id).is_some_and(|s| s.duration > 0.0)
}
fn gcd(id: u32) -> bool {
    matches!(
        id,
        16137
            | 16139
            | 16141
            | 16143
            | 16145
            | 16146
            | 16147
            | 16149
            | 16150
            | 16153
            | 16162
            | 16163
            | 25760
            | 36937..=36939
    )
}
fn area(id: u32) -> bool {
    matches!(id, 16141 | 16149 | 16159 | 16163 | 25760 | 36936..=36939)
}
fn proc_for(id: u32, level: u8) -> u16 {
    match id {
        16146 if level >= 70 => 1842,
        16147 if level >= 70 => 1843,
        16150 if level >= 70 => 1844,
        16162 if level >= 86 => 2686,
        16163 if level >= 96 => 3839,
        _ => 0,
    }
}
fn proc_needed(id: u32) -> u16 {
    match id {
        16156 => 1842,
        16157 => 1843,
        16158 => 1844,
        25759 => 2686,
        36936 => 3839,
        _ => 0,
    }
}
fn minimum(id: u32) -> u8 {
    match id {
        16137 => 1,
        16138 => 2,
        16139 => 4,
        16140 => 6,
        16141 | 16142 | 32068 => 10,
        16143 => 15,
        16144 => 18,
        16145 => 26,
        16162 => 30,
        16148 => 38,
        16149 => 40,
        16151 => 45,
        16152 => 50,
        16153 => 54,
        36934 => 56,
        16146 | 16147 | 16150 => 60,
        16159 => 62,
        16160 => 64,
        16161 => 68,
        16155..=16158 => 70,
        16163 => 72,
        16164 => 76,
        16165 => 80,
        25758 => 82,
        25759 => 86,
        25760 => 90,
        36935 => 92,
        36936 => 96,
        36937..=36939 => 100,
        _ => 0,
    }
}
impl GunbreakerState {
    fn cap(&self, level: u8) -> u8 {
        let base = if level >= 88 { 3 } else { 2 };
        if active(self.bloodfest_until) {
            base * 2
        } else {
            base
        }
    }
    fn resolve(&self, id: u32, level: u8) -> u32 {
        match id {
            16144 if level >= 80 => 16165,
            16148 if level >= 92 => 36935,
            16161 if level >= 82 => 25758,
            16146 if active(self.combo_until) && self.combo_step == 1 => 16147,
            16146 if active(self.combo_until) && self.combo_step == 2 => 16150,
            36937 if active(self.combo_until) && self.combo_step == 3 => 36938,
            36937 if active(self.combo_until) && self.combo_step == 4 => 36939,
            16155 if active(self.continuation_until) => match self.continuation {
                1842 => 16156,
                1843 => 16157,
                1844 => 16158,
                2686 => 25759,
                3839 => 36936,
                _ => 16155,
            },
            _ => id,
        }
    }
    fn can_execute(&self, id: u32, level: u8) -> bool {
        if level < minimum(id) {
            return false;
        }
        let p = proc_needed(id);
        if p != 0 {
            return active(self.continuation_until) && self.continuation == p;
        }
        match id {
            7 | 16155 => false,
            16146 | 16162 | 16163 => self.ammo > 0,
            25760 => self.ammo >= 2,
            16147 => self.combo_step == 1 && active(self.combo_until),
            16150 => self.combo_step == 2 && active(self.combo_until),
            36938 => self.combo_step == 3 && active(self.combo_until),
            36939 => self.combo_step == 4 && active(self.combo_until),
            16153 => active(self.sonic_until),
            36937 => active(self.lion_until),
            _ => true,
        }
    }
    fn pack(&self, level: u8) -> u64 {
        let time = self
            .combo_until
            .map_or(0, |t| {
                t.saturating_duration_since(Instant::now())
                    .as_millis()
                    .min(30000) as u16
            })
            .to_le_bytes();
        u64::from_le_bytes([
            if level >= 30 { self.ammo } else { 0 },
            0,
            time[0],
            time[1],
            if active(self.combo_until) {
                self.combo_step
            } else {
                0
            },
            0,
            0,
            0,
        ])
    }
}
fn potency(id: u32, l: u8, combo: bool) -> u32 {
    let tier = |a, b, c| {
        if l >= 94 {
            c
        } else if l >= 84 {
            b
        } else {
            a
        }
    };
    let late = |a, b| if l >= 94 { b } else { a };
    match id {
        16137 => tier(150, 200, 300),
        16139 => {
            if combo {
                tier(240, 300, 380)
            } else {
                tier(100, 160, 240)
            }
        }
        16145 => {
            if combo {
                tier(320, 360, 460)
            } else {
                tier(100, 140, 240)
            }
        }
        16141 => 100,
        16149 => {
            if combo {
                160
            } else {
                100
            }
        }
        16143 | 16159 => 150,
        16144 => 250,
        16146 => late(330, 440),
        16147 => late(410, 500),
        16150 => late(490, 560),
        16153 => 340,
        16156 => late(180, 220),
        16157 => late(220, 260),
        16158 => late(260, 300),
        16162 => late(340, 420),
        16163 => 300,
        16165 => late(720, 800),
        25759 => late(140, 180),
        25760 | 36939 => 1000,
        36936 => 120,
        36937 => 800,
        36938 => 900,
        _ => 0,
    }
}
pub(in crate::server) struct Gunbreaker;
impl Job for Gunbreaker {
    fn class_jobs(&self) -> &'static [u8] {
        &[37]
    }
    fn resolve_action(
        &self,
        r: &ActionRequest,
        s: &PlayerCombatState,
        l: u8,
        _: &mut GameData,
    ) -> u32 {
        s.gunbreaker.resolve(r.action_id, l)
    }
    fn can_execute(&self, id: u32, s: &PlayerCombatState, l: u8) -> bool {
        s.gunbreaker.can_execute(id, l)
    }
    fn apply_gauge_action(&self, _: &mut PlayerCombatState, _: &GaugeAction) {}
    fn preserves_combo(&self, id: u32) -> bool {
        !matches!(id, 16137 | 16139 | 16145 | 16141 | 16149)
    }
    fn damage_percent(&self, a: &NetworkedActor) -> u32 {
        if a.status_effects().is_some_and(|s| live(s, 1831)) {
            120
        } else {
            100
        }
    }
    fn build_gauge_data(&self, s: &PlayerCombatState, l: u8) -> Option<u64> {
        Some(s.gunbreaker.pack(l))
    }
    fn hit_test(&self, i: &Instance, c: ObjectId, t: ObjectId, id: u32) -> bool {
        if potency(id, 100, true) == 0 {
            return true;
        }
        let valid = |id| matches!(i.find_actor(id),Some(NetworkedActor::Npc{spawn,currently_invulnerable:false,..})if spawn.common.health_points>0);
        if area(id) {
            i.find_actor(if matches!(id, 36937..=36939) { t } else { c })
                .is_some_and(|a| {
                    native::targets(i, a.position().0, glam::Vec3::Z, Shape::Circle(5.0))
                        .into_iter()
                        .any(valid)
                })
        } else {
            valid(t)
        }
    }
    fn filter_missed_effects(&self, id: u32, r: &mut EffectsBuilder) {
        if potency(id, 100, true) > 0 {
            r.effects.retain(|e| {
                !matches!(
                    e.0,
                    TargetEffectKind::Heal { .. }
                        | TargetEffectKind::GainEffectSelf {
                            effect_id: 1898,
                            ..
                        }
                        | TargetEffectKind::GainEffect {
                            effect_id: 1837,
                            ..
                        }
                )
            });
            r.barrier_actions.clear();
            r.tick_actions.clear();
        }
    }
    fn after_combo(&self, id: u32, a: &mut NetworkedActor, _: ObjectId) {
        if let NetworkedActor::Player {
            combat_state,
            spawn,
            ..
        } = a
        {
            if spawn.common.level >= 30 && matches!(id, 16145 | 16149) {
                let s = &mut combat_state.gunbreaker;
                s.ammo = (s.ammo + 1).min(s.cap(spawn.common.level));
            }
        }
    }
    fn action_effects(
        &self,
        id: u32,
        a: &NetworkedActor,
        t: Option<&NetworkedActor>,
        combo: bool,
    ) -> Option<EffectsBuilder> {
        effects(id, a, t, combo)
    }
    fn update_state_after_action(
        &self,
        id: u32,
        a: &mut NetworkedActor,
        owner: ObjectId,
    ) -> JobActionUpdate {
        let NetworkedActor::Player {
            combat_state,
            spawn,
            status_effects,
            parameters,
            ..
        } = a
        else {
            return Default::default();
        };
        let level = spawn.common.level;
        let s = &mut combat_state.gunbreaker;
        if gcd(id) {
            for id in [1842, 1843, 1844, 2686, 3839] {
                status_effects.remove(id);
            }
            s.continuation = proc_for(id, level);
            s.continuation_until = if s.continuation != 0 { until(10) } else { None };
            if s.continuation != 0 {
                status_effects.add_with_source(s.continuation, 0, 10.0, owner);
            }
            s.combo_step = match id {
                16146 => 1,
                16147 => 2,
                36937 => 3,
                36938 => 4,
                _ => 0,
            };
            s.combo_until = if s.combo_step != 0 { until(30) } else { None };
        }
        if proc_needed(id) != 0 {
            status_effects.remove(s.continuation);
            s.continuation = 0;
            s.continuation_until = None;
        }
        match id {
            16146 | 16162 | 16163 => s.ammo = s.ammo.saturating_sub(1),
            25760 => s.ammo = s.ammo.saturating_sub(2),
            16138 if level >= 54 => s.sonic_until = until(30),
            16153 => {
                s.sonic_until = None;
                status_effects.remove(3886);
            }
            16164 => {
                s.bloodfest_until = until(30);
                s.ammo = (s.ammo + if level >= 88 { 3 } else { 2 }).min(s.cap(level));
                if level >= 100 {
                    s.lion_until = until(30);
                }
            }
            36937 => {
                s.lion_until = None;
                status_effects.remove(3840);
            }
            36935 => {
                let old = spawn
                    .common
                    .max_health_points
                    .saturating_sub(s.nebula_bonus);
                s.nebula_bonus = old / 5;
                spawn.common.max_health_points = old + s.nebula_bonus;
                spawn.common.health_points = spawn
                    .common
                    .health_points
                    .saturating_add(spawn.common.max_health_points / 5)
                    .min(spawn.common.max_health_points);
            }
            16152 => {
                spawn.common.health_points = spawn
                    .common
                    .health_points
                    .min(spawn.common.max_health_points / 2)
            }
            _ => {}
        }
        let _ = parameters;
        JobActionUpdate {
            changed: true,
            ..Default::default()
        }
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
        let s = &mut combat_state.gunbreaker;
        let dead = spawn.common.health_points == 0;
        let mut changed = false;
        if (!live(status_effects, 3838) || dead) && s.nebula_bonus > 0 {
            spawn.common.max_health_points = spawn
                .common
                .max_health_points
                .saturating_sub(s.nebula_bonus);
            spawn.common.health_points = spawn
                .common
                .health_points
                .min(spawn.common.max_health_points);
            s.nebula_bonus = 0;
            changed = true;
        }
        if !active(s.bloodfest_until) || dead {
            let cap = if spawn.common.level >= 88 { 3 } else { 2 };
            if s.ammo > cap {
                s.ammo = cap;
                changed = true;
            }
            s.bloodfest_until = None;
        }
        if (!active(s.combo_until) || dead) && s.combo_step != 0 {
            s.combo_step = 0;
            s.combo_until = None;
            changed = true;
        }
        if (!active(s.continuation_until) || dead) && s.continuation != 0 {
            status_effects.remove(s.continuation);
            s.continuation = 0;
            s.continuation_until = None;
            changed = true;
        }
        if dead {
            changed |= s.ammo != 0;
            s.ammo = 0;
            s.sonic_until = None;
            s.lion_until = None;
            for id in [3886, 3840, 5051] {
                status_effects.remove(id);
            }
        }
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
    ) -> Option<AreaResult> {
        apply_area(n, i, c)
    }
}

fn effects(
    id: u32,
    a: &NetworkedActor,
    t: Option<&NetworkedActor>,
    combo: bool,
) -> Option<EffectsBuilder> {
    if matches!(id, 7531 | 7533 | 7535 | 7537 | 7538 | 7540 | 7548) {
        return paladin::action_effects(id, a, combo);
    }
    let NetworkedActor::Player {
        spawn, parameters, ..
    } = a
    else {
        return None;
    };
    let level = spawn.common.level;
    let mut r = EffectsBuilder::default();
    let p = potency(id, level, combo);
    if p > 0 && !area(id) {
        r.effects.push(damage(
            parameters.calc_physical_damage(p),
            DamageType::Slashing,
        ));
    }
    match id {
        16137
        | 16141
        | 16143
        | 16144
        | 16145
        | 16146
        | 16147
        | 16149
        | 16150
        | 16156..=16159
        | 16162
        | 16163
        | 16165
        | 25759
        | 25760
        | 36936..=36939 => {}
        16139 if combo => {
            let amount = parameters.calc_heal_amount(200);
            r.effects.push(heal(amount, true));
            if level >= 52 {
                r.effects.push(status(1898, 0, 30.0, true));
                r.barrier_actions.push(BarrierAction {
                    effect_id: 1898,
                    param: 0,
                    duration: 30.0,
                    amount,
                    on_self: true,
                });
            }
        }
        16139 => {}
        16138 => {
            r.effects.push(status(1831, 20, 20.0, true));
            if level >= 54 {
                r.effects.push(status(3886, 0, 30.0, true));
            }
        }
        16140 => r.effects.push(status(1832, 50, 20.0, true)),
        16142 => r.effects.push(status(1833, 0, 604800.0, true)),
        32068 => r.effects.push(lose(1833, true)),
        16148 => r.effects.push(status(1834, 0, 15.0, true)),
        36935 => r.effects.push(status(3838, 20, 15.0, true)),
        16152 => r.effects.push(status(1836, 0, 10.0, true)),
        16151 => {
            r.effects.push(status(1835, 0, 18.0, false));
            r.tick_actions.push(TickAction {
                effect_id: 1835,
                param: 0,
                duration: 18.0,
                potency: 300,
                kind: TickKind::Heal,
                on_self: false,
            });
        }
        16153 => {
            r.effects
                .extend([status(1837, 0, 15.0, false), lose(3886, true)]);
            r.tick_actions.push(TickAction {
                effect_id: 1837,
                param: 0,
                duration: 15.0,
                potency: 120,
                kind: TickKind::DamagePhysical,
                on_self: false,
            });
        }
        16160 => {}
        16161 => r.effects.push(status(1840, 0, 7.0, false)),
        25758 => r.effects.extend([
            status(2683, 0, 8.0, false),
            status(2684, 0, 4.0, false),
            status(2685, 50, 20.0, false),
        ]),
        16164 => {
            r.effects.push(status(5051, 0, 30.0, true));
            if level >= 100 {
                r.effects.push(status(3840, 0, 30.0, true));
            }
        }
        36934 => {}
        _ => return None,
    }
    let ready = proc_for(id, level);
    if ready != 0 {
        r.effects.push(status(ready, 0, 10.0, true));
    }
    let consumed = proc_needed(id);
    if consumed != 0 {
        r.effects.push(lose(consumed, true));
    }
    if id == 36937 {
        r.effects.push(lose(3840, true));
    }
    if matches!(id, 16143 | 36934) {
        r.enmity_actions.push(EnmityAction::Add { amount: 10000 });
    }
    let _ = t;
    Some(r)
}

fn apply_area(n: &mut NetworkState, i: &mut Instance, c: JobAreaContext<'_>) -> Option<AreaResult> {
    if c.action == 7535 {
        let effects = std::array::from_fn(|x| c.effects.get(x).copied().unwrap_or_default());
        return paladin::apply_area_action(n, i, c.caster, c.action, c.combo, c.statuses, &effects);
    }
    let actor = i.find_actor(c.caster)?;
    let NetworkedActor::Player { parameters, .. } = actor else {
        return None;
    };
    let parameters = parameters.clone();
    let level = actor.get_common_spawn().level;
    let pos = actor.position();
    if matches!(c.action, 16161 | 25758) {
        let transferred = if c.target != c.caster && live(c.statuses, 1898) {
            Some(parameters.calc_heal_amount(200))
        } else {
            None
        };
        let target = i.find_actor_mut(c.target)?;
        if c.action == 25758 {
            if let NetworkedActor::Player { combat_state, .. } = target {
                combat_state.gunbreaker.corundum = Some((
                    Instant::now() + Duration::from_secs(20),
                    parameters.calc_heal_amount(900),
                    c.caster,
                ));
            }
        }
        if let Some(amount) = transferred {
            let cap = target.get_common_spawn().max_health_points;
            target
                .status_effects_mut()?
                .add_barrier(1898, 0, 30.0, amount, c.caster, cap);
            let mut r = AreaResult::new(pos);
            let mut effects = c.effects.to_vec();
            effects.push(status(1898, 0, 30.0, false));
            r.push(c.target, effects);
            return Some(r);
        }
        return None;
    }
    if c.action == 36935 {
        let amount = i.find_actor(c.caster)?.get_common_spawn().max_health_points / 5;
        let mut r = AreaResult::new(pos);
        let mut effects = c.effects.to_vec();
        effects.push(heal(amount, false));
        r.push(c.caster, effects);
        return Some(r);
    }
    if c.action == 16152 {
        white_mage::send_hp_mp(n, i, c.caster);
        return None;
    }
    if c.action == 16160 {
        let mut r = AreaResult::new(pos);
        for id in party_in_range(n, i, c.caster, pos.0, 30.0)
            .into_iter()
            .take(32)
        {
            i.find_actor_mut(id)?
                .status_effects_mut()?
                .add_with_source(1839, 0, 15.0, c.caster);
            r.push(id, [status(1839, 0, 15.0, false)]);
        }
        return Some(r);
    }
    if !area(c.action) {
        return None;
    }
    let center = if matches!(c.action, 36937..=36939) {
        i.find_actor(c.target)?.position()
    } else {
        pos
    };
    let mut r = native::damage_area(
        i,
        c.caster,
        AreaAttack {
            center,
            direction: glam::Vec3::Z,
            shape: Shape::Circle(5.0),
            primary: Some(c.target),
            potency: potency(c.action, level, c.combo),
            falloff: if matches!(c.action, 36937..=36939) {
                60
            } else if c.action == 25760 {
                15
            } else {
                0
            },
            damage_type: DamageType::Slashing,
            limit: 31,
        },
        c.modifiers,
    );
    if c.action == 16159 {
        for (id, effects) in &mut r.targets {
            if effects
                .iter()
                .any(|e| matches!(e.0, TargetEffectKind::Damage { .. }))
            {
                let target_roll=c.modifiers.against_target(i.find_actor(id.object_id)).roll;
                i.find_actor_mut(id.object_id)?
                    .status_effects_mut()?
                    .add_tick(
                        1838,
                        0,
                        15.0,
                        crate::TickEffectKind::DamagePhysical,
                        60,
                        Some(crate::TickDamageSnapshot {
                            base_amount: c
                                .modifiers
                                .apply_base_damage(parameters.calc_physical_damage(60)),
                            roll_modifiers: target_roll,
                        }),
                        c.caster,
                    );
                effects[1] = status(1838, 0, 15.0, false);
            }
        }
    }
    let effects: Vec<_> = c
        .effects
        .iter()
        .copied()
        .filter(|e| {
            !matches!(
                e.0,
                TargetEffectKind::None | TargetEffectKind::ExecuteCombo { .. }
            )
        })
        .collect();
    if !effects.is_empty() {
        r.push(c.caster, effects);
    }
    Some(r)
}
pub(in crate::server) fn mitigation(a: &NetworkedActor, kind: DamageType) -> f64 {
    let Some(s) = a.status_effects() else {
        return 1.0;
    };
    if live(s, 1836) {
        return 0.0;
    }
    let mut m = if a.get_common_spawn().class_job == 37 {
        0.8
    } else {
        1.0
    };
    for (id, scale) in [
        (1832, 0.9),
        (1834, 0.7),
        (3838, 0.6),
        (1840, 0.85),
        (2683, 0.85),
        (2684, 0.85),
        (1839, if kind == DamageType::Magic { 0.9 } else { 0.95 }),
    ] {
        if live(s, id) {
            m *= scale;
        }
    }
    if kind != DamageType::Magic && live(s, 1832) && fastrand::f64() < 0.5 {
        m *= 0.8;
    }
    m
}
/// 刚玉之净可附加给其他职业，因此在全体角色的周期入口推进。
pub(in crate::server) fn tick_support(n: &mut NetworkState, i: &mut Instance, id: ObjectId) {
    let Some(a) = i.find_actor_mut(id) else {
        return;
    };
    let NetworkedActor::Player {
        combat_state,
        spawn,
        status_effects,
        ..
    } = a
    else {
        return;
    };
    let Some((end, base, source)) = combat_state.gunbreaker.corundum else {
        return;
    };
    let expired = Instant::now() >= end;
    if spawn.common.health_points == 0 || (!expired && !live(status_effects, 2685)) {
        combat_state.gunbreaker.corundum = None;
        return;
    }
    if expired || spawn.common.health_points < spawn.common.max_health_points / 2 {
        combat_state.gunbreaker.corundum = None;
        status_effects.remove(2685);
        let amount = (base as f64 * white_mage::incoming_heal_multiplier(Some(a))) as u32;
        a.apply_heal(amount);
        n.send_ac_in_range_inclusive_instance(
            i,
            id,
            kawari::ipc::zone::ActorControlCategory::TickHeal {
                status_id: 2685,
                amount,
                source_actor_id: source,
                unk2: u32::MAX,
                unk3: 0,
            },
        );
        white_mage::send_hp_mp(n, i, id);
        crate::server::effect::send_effects_list_with(n, i, id);
    }
}
pub(in crate::server) fn deactivate(a: &mut NetworkedActor) {
    paladin::deactivate(a);
    if let NetworkedActor::Player {
        spawn,
        combat_state,
        status_effects,
        ..
    } = a
    {
        let old = std::mem::take(&mut combat_state.gunbreaker);
        spawn.common.max_health_points = spawn
            .common
            .max_health_points
            .saturating_sub(old.nebula_bonus);
        spawn.common.health_points = spawn
            .common
            .health_points
            .min(spawn.common.max_health_points);
        for id in [
            1831, 1832, 1833, 1834, 1836, 1842, 1843, 1844, 2686, 3838, 3839, 3840, 3886, 5051,
        ] {
            status_effects.remove(id);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn player() -> (ObjectId, NetworkedActor) {
        let id = ObjectId(0x10000001);
        let mut i = Instance::default();
        i.insert_empty_actor(id);
        let mut a = i.actors.remove(&id).unwrap();
        let c = a.get_common_spawn_mut();
        c.class_job = 37;
        c.level = 100;
        c.health_points = 10000;
        c.max_health_points = 10000;
        (id, a)
    }
    #[test]
    fn gnb_ammo_and_continuations_expire_and_cancel_on_next_weaponskill() {
        let (id, mut a) = player();
        Gunbreaker.update_state_after_action(16164, &mut a, id);
        if let NetworkedActor::Player { combat_state, .. } = &a {
            assert_eq!(combat_state.gunbreaker.ammo, 3);
            assert_eq!(combat_state.gunbreaker.cap(100), 6);
        }
        Gunbreaker.update_state_after_action(16146, &mut a, id);
        if let NetworkedActor::Player { combat_state, .. } = &a {
            assert_eq!(combat_state.gunbreaker.resolve(16146, 100), 16147);
            assert_eq!(combat_state.gunbreaker.resolve(16155, 100), 16156);
            assert_eq!(combat_state.gunbreaker.ammo, 2);
        }
        Gunbreaker.update_state_after_action(16147, &mut a, id);
        assert!(a.status_effects().unwrap().get(1842).is_none());
        assert!(a.status_effects().unwrap().get(1843).is_some());
        if let NetworkedActor::Player { combat_state, .. } = &a {
            assert!(!combat_state.gunbreaker.can_execute(16158, 100));
            assert!(combat_state.gunbreaker.can_execute(16157, 100));
        }
        Gunbreaker.update_state_after_action(16157, &mut a, id);
        Gunbreaker.update_state_after_action(16137, &mut a, id);
        if let NetworkedActor::Player { combat_state, .. } = &a {
            assert_eq!(combat_state.gunbreaker.combo_step, 0);
            assert_eq!(combat_state.gunbreaker.continuation, 0);
        }
    }
    #[test]
    fn gnb_bloodfest_capacity_matches_client_trait_427_and_status_5051() {
        let mut s = GunbreakerState::default();
        assert_eq!(s.cap(87), 2);
        assert_eq!(s.cap(88), 3);
        s.bloodfest_until = until(30);
        assert_eq!(s.cap(87), 4);
        assert_eq!(s.cap(88), 6);
        s.ammo = 1;
        assert!(!s.can_execute(25760, 100));
        assert!(s.can_execute(16162, 100));
        assert!(!s.can_execute(36937, 100));
    }
    #[test]
    fn gnb_nebula_max_hp_restores_on_expiry_and_superbolide_does_not_heal() {
        let (id, mut a) = player();
        a.status_effects_mut()
            .unwrap()
            .add_with_source(3838, 20, 15.0, id);
        Gunbreaker.update_state_after_action(36935, &mut a, id);
        assert_eq!(a.get_common_spawn().max_health_points, 12000);
        assert_eq!(a.get_common_spawn().health_points, 12000);
        Gunbreaker.update_state_after_action(16152, &mut a, id);
        assert_eq!(a.get_common_spawn().health_points, 6000);
        a.get_common_spawn_mut().health_points = 100;
        Gunbreaker.update_state_after_action(16152, &mut a, id);
        assert_eq!(a.get_common_spawn().health_points, 100);
        a.status_effects_mut().unwrap().remove(3838);
        Gunbreaker.refresh_runtime_state_on_actor(id, &mut a);
        assert_eq!(a.get_common_spawn().max_health_points, 10000);
        deactivate(&mut a);
        assert_eq!(a.get_common_spawn().max_health_points, 10000);
    }
    #[test]
    fn gnb_corundum_follows_other_job_target_and_cannot_fire_twice() {
        let (id, mut a) = player();
        a.get_common_spawn_mut().class_job = 32;
        a.get_common_spawn_mut().health_points = 4000;
        a.status_effects_mut()
            .unwrap()
            .add_with_source(2685, 50, 20.0, ObjectId(7));
        if let NetworkedActor::Player { combat_state, .. } = &mut a {
            combat_state.gunbreaker.corundum =
                Some((Instant::now() + Duration::from_secs(20), 900, ObjectId(7)));
        }
        let mut i = Instance::default();
        i.actors.insert(id, a);
        let mut n = NetworkState::default();
        tick_support(&mut n, &mut i, id);
        assert_eq!(
            i.find_actor(id).unwrap().get_common_spawn().health_points,
            4900
        );
        tick_support(&mut n, &mut i, id);
        assert_eq!(
            i.find_actor(id).unwrap().get_common_spawn().health_points,
            4900
        );
    }
}
