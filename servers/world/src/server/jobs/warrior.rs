//! 战士：量谱、变招、连击和防御结算。技能编号以本地国服表和 AR 包为准。
use super::{
    dispatch::{Job, JobActionUpdate, JobAreaContext, JobCooldownUpdate, JobRefreshResult},
    native::{damage, heal, lose, status},
    paladin, white_mage,
};
use crate::{
    StatusEffects, TickEffectKind,
    gamedata::GameData,
    lua::{BarrierAction, EffectsBuilder, EnmityAction, GaugeAction, TickAction, TickKind},
    server::{
        action::{
            action_damage_modifiers,
            area::{AreaResult, enemies_in_range, party_in_range},
        },
        actor::NetworkedActor,
        combat_state::PlayerCombatState,
        director::notify_attack_hit,
        instance::Instance,
        network::NetworkState,
    },
};
use kawari::{
    common::ObjectId,
    ipc::zone::{ActionRequest, DamageType, TargetEffect, TargetEffectKind},
};
use std::time::{Duration, Instant};

pub(in crate::server) const SURGING_TEMPEST: u16 = 2677;
const CHAOS: u16 = 1897;
const RELEASE: u16 = 1177;
const BERSERK: u16 = 86;
const REND: u16 = 2624;
const FURY: u16 = 3833;
const WRATH: u16 = 3901;
const RUINATION: u16 = 3834;

#[derive(Debug, Clone, Default, PartialEq)]
pub struct WarriorState {
    pub beast: u8,
    chaos: Option<Instant>,
    release: Option<Instant>,
    release_stacks: u8,
    berserk: Option<Instant>,
    berserk_stacks: u8,
    rend: Option<Instant>,
    ruination: Option<Instant>,
    fury: u8,
    fury_until: Option<Instant>,
    wrath: Option<Instant>,
    nascent_target: Option<ObjectId>,
    thrill_bonus: u32,
    damnation_until: Option<Instant>,
    damnation_pending: bool,
}
fn active(until: Option<Instant>) -> bool {
    until.is_some_and(|t| t > Instant::now())
}
fn until(seconds: u64) -> Option<Instant> {
    Some(Instant::now() + Duration::from_secs(seconds))
}
pub(in crate::server) fn is_warrior(job: u8) -> bool {
    matches!(job, 3 | 21)
}
fn weapon(action: u32) -> bool {
    matches!(
        action,
        31 | 37 | 41 | 42 | 45 | 46 | 49 | 51 | 3549 | 3550 | 16462 | 16463 | 16465 | 25753 | 36925
    )
}
fn spender(action: u32) -> bool {
    matches!(action, 49 | 51 | 3549 | 3550 | 16463 | 16465)
}
fn area(action: u32) -> bool {
    matches!(
        action,
        41 | 51 | 3550 | 16462 | 16463 | 25752 | 25753 | 36924 | 36925
    )
}
fn live(statuses: &StatusEffects, id: u16) -> bool {
    statuses.get(id).is_some_and(|s| s.duration > 0.0)
}
fn forced(action: u32, statuses: &StatusEffects) -> bool {
    matches!(action, 16463 | 16465 | 25753 | 36925)
        || weapon(action) && live(statuses, BERSERK)
        || matches!(action, 3549 | 3550) && live(statuses, RELEASE)
}
fn extend_tempest(statuses: &mut StatusEffects, owner: ObjectId, seconds: f32, create: bool) {
    if create || live(statuses, SURGING_TEMPEST) {
        let remaining = statuses.get(SURGING_TEMPEST).map_or(0.0, |s| s.duration);
        statuses.add_with_source(SURGING_TEMPEST, 10, (remaining + seconds).min(60.0), owner);
    }
}
fn consume(statuses: &mut StatusEffects, owner: ObjectId, id: u16) {
    if let Some(s) = statuses.get(id) {
        if s.param <= 1 {
            statuses.remove(id);
        } else {
            statuses.add_with_source(id, s.param - 1, s.duration, owner);
        }
    }
}

impl WarriorState {
    fn resolve(&self, action: u32, level: u8) -> u32 {
        match action {
            49 if level >= 54 => self.resolve(3549, level),
            51 if level >= 60 => self.resolve(3550, level),
            3549 if level >= 80 && active(self.chaos) && self.beast >= 50 => 16465,
            3550 if level >= 72 && active(self.chaos) && self.beast >= 50 => 16463,
            38 if level >= 70 => self.resolve(7389, level),
            7389 if level >= 96 && active(self.wrath) => 36924,
            25753 if level >= 100 && active(self.ruination) => 36925,
            3551 if level >= 82 => 25751,
            44 if level >= 92 => 36923,
            _ => action,
        }
    }
    fn can_execute(&self, action: u32, in_combat: bool) -> bool {
        if spender(action)
            && self.beast < 50
            && !(matches!(action, 3549 | 3550) && active(self.release) && self.release_stacks > 0)
        {
            return false;
        }
        match action {
            7 => false,
            52 => in_combat,
            16463 | 16465 => active(self.chaos),
            25753 => active(self.rend),
            36925 => active(self.ruination),
            36924 => active(self.wrath),
            _ => true,
        }
    }
}

pub(in crate::server) struct Warrior;
impl Job for Warrior {
    fn class_jobs(&self) -> &'static [u8] {
        &[3, 21]
    }
    fn gauge_class_job_id(&self, _: u8) -> u8 {
        21
    }
    fn resolve_action(
        &self,
        request: &ActionRequest,
        state: &PlayerCombatState,
        level: u8,
        _: &mut GameData,
    ) -> u32 {
        state.warrior.resolve(request.action_id, level)
    }
    fn can_execute(&self, action: u32, state: &PlayerCombatState, level: u8) -> bool {
        let minimum = match action {
            31 => 1,
            37 => 4,
            38 => 6,
            41 | 48 | 32066 => 10,
            46 => 15,
            42 => 26,
            40 => 30,
            49 => 35,
            44 => 38,
            16462 => 40,
            43 => 42,
            51 => 45,
            45 | 52 => 50,
            3549 => 54,
            3551 => 56,
            3552 => 58,
            3550 => 60,
            7386 => 62,
            7387 => 64,
            7388 => 68,
            7389 => 70,
            16463 => 72,
            16464 => 76,
            16465 => 80,
            25751 => 82,
            25752 => 86,
            25753 => 90,
            36923 => 92,
            36924 => 96,
            36925 => 100,
            _ => 0,
        };
        level >= minimum && state.warrior.can_execute(action, state.in_combat)
    }
    fn apply_gauge_action(&self, _: &mut PlayerCombatState, _: &GaugeAction) {}
    fn preserves_combo(&self, action: u32) -> bool {
        !matches!(action, 31 | 37 | 42 | 45 | 41 | 16462)
    }
    fn forced_critical_direct(&self, action: u32, actor: &NetworkedActor) -> bool {
        actor.status_effects().is_some_and(|s| forced(action, s))
    }
    fn hit_test(
        &self,
        instance: &Instance,
        caster: ObjectId,
        target: ObjectId,
        action: u32,
    ) -> bool {
        let hittable = |id| matches!(instance.find_actor(id),Some(NetworkedActor::Npc{currently_invulnerable:false,targetable:true,spawn,..}) if spawn.common.health_points>0);
        if area(action) {
            let center = instance.find_actor(if matches!(action, 25753 | 36925) {
                target
            } else {
                caster
            });
            center.is_some_and(|a| {
                enemies_in_range(instance, a.position().0, 5.0)
                    .into_iter()
                    .any(hittable)
            })
        } else {
            hittable(target)
        }
    }
    fn filter_missed_effects(&self, _: u32, effects: &mut EffectsBuilder) {
        effects.effects.retain(|effect| {
            !matches!(
                effect.0,
                TargetEffectKind::GainEffectSelf {
                    effect_id: FURY | WRATH | SURGING_TEMPEST,
                    ..
                }
            )
        });
    }
    fn animation_lock(&self, action: u32) -> f32 {
        if action == 25753 { 1.15 } else { 0.6 }
    }
    fn after_combo(&self, action: u32, actor: &mut NetworkedActor, owner: ObjectId) {
        let level = actor.get_common_spawn().level;
        let NetworkedActor::Player {
            combat_state,
            status_effects,
            ..
        } = actor
        else {
            return;
        };
        let gain = match action {
            37 | 45 if level >= 35 => 10,
            42 if level >= 35 => 20,
            16462 if level >= 74 => 20,
            _ => 0,
        };
        combat_state.warrior.beast = (combat_state.warrior.beast + gain).min(100);
        let _ = (status_effects, owner); // 风暴状态由同一次 ActionEffect 授予，不重复延长。
    }
    fn update_state_after_action(
        &self,
        action: u32,
        actor: &mut NetworkedActor,
        owner: ObjectId,
    ) -> JobActionUpdate {
        self.update_state_after_result(action, actor, owner, true)
    }
    fn update_state_after_result(
        &self,
        action: u32,
        actor: &mut NetworkedActor,
        owner: ObjectId,
        landed: bool,
    ) -> JobActionUpdate {
        let level = actor.get_common_spawn().level;
        let NetworkedActor::Player {
            combat_state,
            status_effects,
            spawn,
            ..
        } = actor
        else {
            return Default::default();
        };
        let state = &mut combat_state.warrior;
        if spender(action) {
            if matches!(action, 3549 | 3550) && active(state.release) && state.release_stacks > 0 {
                state.release_stacks -= 1;
                consume(status_effects, owner, RELEASE);
                if level >= 96 && landed {
                    if !active(state.fury_until) {
                        state.fury = 0;
                    }
                    state.fury += 1;
                    state.fury_until = until(30);
                    if state.fury >= 3 {
                        state.fury = 0;
                        state.wrath = until(30);
                        status_effects.remove(FURY);
                        status_effects.add_with_source(WRATH, 0, 30.0, owner);
                    } else {
                        status_effects.add_with_source(FURY, state.fury.into(), 30.0, owner);
                    }
                }
            } else {
                state.beast = state.beast.saturating_sub(50);
            }
        }
        if weapon(action) && active(state.berserk) {
            state.berserk_stacks = state.berserk_stacks.saturating_sub(1);
            consume(status_effects, owner, BERSERK);
        }
        match action {
            52 => {
                state.beast = (state.beast + 50).min(100);
                if level >= 72 {
                    state.chaos = until(30);
                }
            }
            16463 | 16465 => {
                state.chaos = None;
                status_effects.remove(CHAOS);
            }
            38 => {
                state.berserk = until(15);
                state.berserk_stacks = 3;
                extend_tempest(status_effects, owner, 10.0, false);
            }
            7389 => {
                state.release = until(15);
                state.release_stacks = 3;
                if level >= 90 {
                    state.rend = until(30);
                }
                extend_tempest(status_effects, owner, 10.0, false);
            }
            25753 => {
                state.rend = None;
                status_effects.remove(REND);
                if level >= 100 {
                    state.ruination = until(20);
                }
            }
            36925 => {
                state.ruination = None;
                status_effects.remove(RUINATION);
            }
            36924 => {
                state.wrath = None;
                status_effects.remove(WRATH);
            }
            32066 => {
                status_effects.remove(91);
            }
            40 => {
                let base = spawn
                    .common
                    .max_health_points
                    .saturating_sub(state.thrill_bonus);
                state.thrill_bonus = base / 5;
                spawn.common.max_health_points = base.saturating_add(state.thrill_bonus);
                spawn.common.health_points = spawn
                    .common
                    .health_points
                    .saturating_add(state.thrill_bonus)
                    .min(spawn.common.max_health_points);
            }
            36923 => {
                state.damnation_until = until(15);
                state.damnation_pending = true;
            }
            _ => {}
        }
        let mut update = JobActionUpdate {
            changed: true,
            ..Default::default()
        };
        if level >= 66 && landed && matches!(action, 3549 | 3550 | 16463 | 16465) {
            if let Some(index) = combat_state
                .cooldowns
                .iter()
                .position(|cd| cd.as_ref().is_some_and(|cd| cd.action_id == 52))
            {
                combat_state.reduce_cooldown_recovery(index, Duration::from_secs(5));
                update.cooldown_update = Some(JobCooldownUpdate {
                    cooldown_group: index as u32,
                    delta_centisec: 500,
                });
            }
        }
        update
    }
    fn build_gauge_data(&self, state: &PlayerCombatState, level: u8) -> Option<u64> {
        Some(if level >= 35 {
            u64::from(state.warrior.beast)
        } else {
            0
        })
    }
    fn refresh_runtime_state_on_actor(
        &self,
        owner: ObjectId,
        actor: &mut NetworkedActor,
    ) -> JobRefreshResult {
        if actor.get_common_spawn().health_points == 0
            && matches!(actor,NetworkedActor::Player{combat_state,..} if combat_state.warrior!=WarriorState::default())
        {
            let stance = actor.status_effects().and_then(|s| s.get(91));
            deactivate(actor);
            if let Some(s) = stance {
                actor.status_effects_mut().unwrap().add_with_source(
                    91,
                    s.param,
                    s.duration,
                    s.source_actor_id,
                );
            }
            return JobRefreshResult {
                changed: true,
                status_timer_refreshed: true,
                ..Default::default()
            };
        }
        let NetworkedActor::Player {
            combat_state,
            status_effects,
            spawn,
            ..
        } = actor
        else {
            return Default::default();
        };
        let state = &mut combat_state.warrior;
        let mut changed = false;
        if state.thrill_bonus > 0 && !live(status_effects, 87) {
            spawn.common.max_health_points = spawn
                .common
                .max_health_points
                .saturating_sub(state.thrill_bonus);
            spawn.common.health_points = spawn
                .common
                .health_points
                .min(spawn.common.max_health_points);
            state.thrill_bonus = 0;
            changed = true;
        }
        if state.fury > 0 && !active(state.fury_until) {
            state.fury = 0;
            status_effects.remove(FURY);
            changed = true;
        }
        if !live(status_effects, 1857) {
            state.nascent_target = None;
        }
        if state.damnation_pending && !active(state.damnation_until) {
            state.damnation_pending = false;
            if spawn.common.health_points > 0 {
                add_damnation_regen(status_effects, owner);
            }
            changed = true;
        }
        JobRefreshResult {
            changed,
            status_timer_refreshed: changed,
            ..Default::default()
        }
    }
    fn action_effects(
        &self,
        action: u32,
        actor: &NetworkedActor,
        target: Option<&NetworkedActor>,
        combo: bool,
    ) -> Option<EffectsBuilder> {
        let mut result = action_effects(action, actor, combo)?;
        if action == 43 && matches!(target, Some(NetworkedActor::Npc { .. })) {
            result.effects.push(status(13, 0, 10.0, false));
        }
        if matches!(
            target,
            Some(NetworkedActor::Npc {
                currently_invulnerable: true,
                ..
            })
        ) {
            result
                .effects
                .retain(|e| !matches!(e.0, TargetEffectKind::Heal { .. }));
        }
        Some(result)
    }
    fn apply_area_action(
        &self,
        network: &mut NetworkState,
        instance: &mut Instance,
        context: JobAreaContext<'_>,
    ) -> Option<AreaResult> {
        apply_area_action(network, instance, context)
    }
}

fn tier(level: u8, base: u32, at84: u32, at94: u32) -> u32 {
    if level >= 94 {
        at94
    } else if level >= 84 {
        at84
    } else {
        base
    }
}
fn potency(action: u32, level: u8, combo: bool) -> u32 {
    match action {
        31 => tier(level, 150, 200, 240),
        37 => tier(
            level,
            if combo { 250 } else { 100 },
            if combo { 300 } else { 150 },
            if combo { 340 } else { 190 },
        ),
        42 | 45 => tier(
            level,
            if combo { 380 } else { 100 },
            if combo { 440 } else { 160 },
            if combo { 500 } else { 220 },
        ),
        41 => 110,
        46 | 7386 | 25752 => 150,
        49 => 330,
        51 => 160,
        3549 => {
            if level >= 94 {
                580
            } else {
                520
            }
        }
        3550 => 180,
        16462 => {
            if combo {
                140
            } else {
                100
            }
        }
        16463 => 200,
        16465 | 36924 => 700,
        25753 => 720,
        36925 => 800,
        7387 => {
            if level >= 94 {
                420
            } else {
                400
            }
        }
        _ => 0,
    }
}
fn has_blood_heal(statuses: &StatusEffects) -> bool {
    [735, 1857, 2678].into_iter().any(|id| live(statuses, id))
}

fn action_effects(action: u32, actor: &NetworkedActor, combo: bool) -> Option<EffectsBuilder> {
    if matches!(action, 7531 | 7533 | 7535 | 7537 | 7538 | 7540 | 7548) {
        return paladin::action_effects(action, actor, combo);
    }
    let NetworkedActor::Player {
        spawn,
        parameters,
        status_effects,
        combat_state,
        ..
    } = actor
    else {
        return None;
    };
    let level = spawn.common.level;
    let mut result = EffectsBuilder::default();
    let p = potency(action, level, combo);
    if p > 0 && !area(action) {
        result.effects.push(damage(
            parameters.calc_physical_damage(p),
            DamageType::Slashing,
        ));
    }
    match action {
        31 | 37 | 41 | 46 | 49 | 51 | 3549 | 3550 | 7386 | 7387 | 16462 | 16463 | 16465 | 25752 => {
        }
        42 => {
            if combo {
                result
                    .effects
                    .push(heal(parameters.calc_heal_amount(250), true));
            }
        }
        45 => {}
        48 => result.effects.push(status(91, 0, 604800.0, true)),
        32066 => result.effects.push(lose(91, true)),
        38 => result.effects.push(status(BERSERK, 3, 15.0, true)),
        7389 => {
            result
                .effects
                .extend([status(RELEASE, 3, 15.0, true), status(2663, 0, 15.0, true)]);
            if level >= 90 {
                result.effects.push(status(REND, 0, 30.0, true));
            }
        }
        52 => {
            result.effects.push(TargetEffect(TargetEffectKind::Unknown {
                magic: 62,
                param0: 50,
                param1: 0,
                param2: 0,
                param3: 0,
                param4: 0,
                value: 52,
            }));
            if level >= 72 {
                result.effects.push(status(CHAOS, 0, 30.0, true));
            }
        }
        25753 => {
            if level >= 100 {
                result.effects.push(status(RUINATION, 0, 20.0, true));
            }
        }
        36924 | 36925 => {}
        40 => result
            .effects
            .push(status(87, if level >= 78 { 20 } else { 0 }, 10.0, true)),
        43 => result.effects.push(status(409, 0, 10.0, true)),
        44 | 36923 => {
            result
                .effects
                .push(status(if action == 44 { 89 } else { 3832 }, 0, 15.0, true))
        }
        3552 => {
            result
                .effects
                .push(heal(parameters.calc_heal_amount(1200), true));
            if level >= 84 {
                result.effects.push(status(2681, 0, 15.0, true));
                result.tick_actions.push(TickAction {
                    effect_id: 2681,
                    param: 0,
                    duration: 15.0,
                    potency: 200,
                    kind: TickKind::Heal,
                    on_self: true,
                });
            }
        }
        3551 | 25751 => {
            let duration = if action == 25751 { 8.0 } else { 6.0 };
            result.effects.push(status(
                if action == 25751 { 2678 } else { 735 },
                0,
                duration,
                true,
            ));
            if action == 25751 {
                blood_defenses(&mut result, parameters.calc_heal_amount(400), true);
            }
        }
        16464 => {
            let duration = if level >= 82 { 8.0 } else { 6.0 };
            result.effects.extend([
                status(1857, 0, duration, true),
                status(1858, 0, duration, false),
            ]);
            if level >= 82 {
                blood_defenses(&mut result, parameters.calc_heal_amount(400), false);
            }
        }
        7388 => {}
        _ => return None,
    }
    if combo && matches!(action, 45 | 16462) {
        result.effects.push(status(
            SURGING_TEMPEST,
            10,
            (status_effects
                .get(SURGING_TEMPEST)
                .map_or(0.0, |s| s.duration)
                + 30.0)
                .min(60.0),
            true,
        ));
    }
    if matches!(action, 3549 | 3550) && live(status_effects, RELEASE) && level >= 96 {
        let stacks = combat_state.warrior.fury + 1;
        result.effects.push(status(
            if stacks == 3 { WRATH } else { FURY },
            if stacks == 3 { 0 } else { u16::from(stacks) },
            30.0,
            true,
        ));
    }
    if weapon(action) && !area(action) && has_blood_heal(status_effects) {
        result.effects.push(heal(
            parameters.calc_heal_amount_with_critical(400, forced(action, status_effects)),
            true,
        ));
    }
    if action == 46 {
        result
            .enmity_actions
            .push(EnmityAction::Add { amount: 1000 });
    }
    Some(result)
}
fn blood_defenses(result: &mut EffectsBuilder, amount: u32, on_self: bool) {
    result.effects.extend([
        status(2679, 0, 4.0, on_self),
        status(2680, 0, 20.0, on_self),
    ]);
    result.barrier_actions.push(BarrierAction {
        effect_id: 2680,
        param: 0,
        duration: 20.0,
        amount,
        on_self,
    });
}

pub(in crate::server) fn mitigation_multiplier(actor: &NetworkedActor) -> f64 {
    let Some(s) = actor.status_effects() else {
        return 1.0;
    };
    let passive = if is_warrior(actor.get_common_spawn().class_job) {
        0.8
    } else {
        1.0
    };
    [
        (89, 0.7),
        (3832, 0.6),
        (735, 0.9),
        (2678, 0.9),
        (2679, 0.9),
        (1858, 0.9),
    ]
    .into_iter()
    .filter(|(id, _)| live(s, *id))
    .fold(passive, |m, (_, scale)| m * scale)
}

fn add_damnation_regen(statuses: &mut StatusEffects, owner: ObjectId) {
    statuses.add_tick(3900, 0, 15.0, TickEffectKind::Heal, 300, None, owner);
}

pub(in crate::server) fn damage_taken(actor: &mut NetworkedActor) {
    let NetworkedActor::Player {
        combat_state,
        status_effects,
        spawn,
        ..
    } = actor
    else {
        return;
    };
    if combat_state.warrior.damnation_pending
        && spawn.common.health_points > 0
        && let Some(s) = status_effects.get(3832)
    {
        combat_state.warrior.damnation_pending = false;
        add_damnation_regen(status_effects, s.source_actor_id);
    }
}

pub(in crate::server) fn deactivate(actor: &mut NetworkedActor) {
    paladin::deactivate(actor);
    let NetworkedActor::Player {
        combat_state,
        status_effects,
        spawn,
        ..
    } = actor
    else {
        return;
    };
    spawn.common.max_health_points = spawn
        .common
        .max_health_points
        .saturating_sub(combat_state.warrior.thrill_bonus);
    spawn.common.health_points = spawn
        .common
        .health_points
        .min(spawn.common.max_health_points);
    combat_state.warrior = WarriorState::default();
    for id in [
        86, 87, 89, 91, 409, 735, 1177, 1857, 1897, 2624, 2663, 2677, 2678, 2679, 2680, 2681, 3832,
        3833, 3834, 3900, 3901,
    ] {
        status_effects.remove(id);
    }
}

/// 反击是受击事件，不是持续伤害；只对有效物理命中结算一次。
pub(in crate::server) fn retaliate(
    network: &mut NetworkState,
    instance: &mut Instance,
    attacker: ObjectId,
    victim: ObjectId,
    damage_type: DamageType,
    hit_amount: u32,
) {
    if attacker == victim
        || hit_amount == 0
        || matches!(
            damage_type,
            DamageType::Magic | DamageType::Unique | DamageType::LimitBreak
        )
    {
        return;
    }
    let Some(actor) = instance.find_actor(victim) else {
        return;
    };
    let NetworkedActor::Player {
        parameters,
        status_effects,
        spawn,
        ..
    } = actor
    else {
        return;
    };
    if spawn.common.health_points == 0 || ![89, 3832].into_iter().any(|id| live(status_effects, id))
    {
        return;
    }
    let status_id = if live(status_effects, 3832) { 3832 } else { 89 };
    let modifiers = action_damage_modifiers(Some(actor));
    let (amount, _) = parameters.roll_damage_with_modifiers(
        modifiers.apply_base_damage(parameters.calc_physical_damage(55)),
        modifiers.against_target(instance.find_actor(attacker)).roll,
    );
    let enmity = paladin::enmity_multiplier(actor);
    let Some(target) = instance.find_actor_mut(attacker) else {
        return;
    };
    if !matches!(
        target,
        NetworkedActor::Npc {
            currently_invulnerable: false,
            ..
        }
    ) || target.get_common_spawn().health_points == 0
    {
        return;
    }
    target.apply_damage(amount);
    if let Some(hate) = target.npc_hate_list_mut() {
        let v = hate.entry(victim).or_default();
        *v = v.saturating_add(amount.saturating_mul(enmity));
    }
    network.send_in_range_inclusive_instance(
        attacker,
        instance,
        crate::FromServer::ActorControl(
            attacker,
            kawari::ipc::zone::ActorControlCategory::TickDamage {
                status_id,
                amount,
                source_actor_id: victim,
                unk2: u32::MAX,
                unk3: 0,
            },
        ),
        crate::server::network::DestinationNetwork::ZoneClients,
    );
    white_mage::send_hp_mp(network, instance, attacker);
    notify_attack_hit(instance, victim, attacker, amount);
}

fn apply_area_action(
    network: &mut NetworkState,
    instance: &mut Instance,
    ctx: JobAreaContext<'_>,
) -> Option<AreaResult> {
    if ctx.action == 7535 {
        let effects: [TargetEffect; 8] =
            std::array::from_fn(|i| ctx.effects.get(i).copied().unwrap_or_default());
        return paladin::apply_area_action(
            network,
            instance,
            ctx.caster,
            ctx.action,
            ctx.combo,
            ctx.statuses,
            &effects,
        );
    }
    let actor = instance.find_actor(ctx.caster)?;
    let NetworkedActor::Player {
        parameters,
        combat_state,
        ..
    } = actor
    else {
        return None;
    };
    let parameters = parameters.clone();
    let level = actor.get_common_spawn().level;
    let caster_position = actor.position();
    let nascent = if live(ctx.statuses, 1857) {
        combat_state.warrior.nascent_target
    } else {
        None
    };
    let thrill_bonus = combat_state.warrior.thrill_bonus;
    let mut modifiers = ctx.modifiers;
    let enmity = paladin::enmity_multiplier(actor);
    if forced(ctx.action, ctx.statuses) {
        modifiers.roll.force_critical = true;
        modifiers.roll.force_direct_hit = true;
    }
    if ctx.action == 16464 {
        if let Some(NetworkedActor::Player { combat_state, .. }) =
            instance.find_actor_mut(ctx.caster)
        {
            combat_state.warrior.nascent_target = Some(ctx.target);
        }
        return None;
    }
    if ctx.action == 40 {
        crate::server::effect::send_effects_list_with(network, instance, ctx.caster);
        let mut r = AreaResult::new(caster_position);
        let mut effects = ctx.effects.to_vec();
        effects.push(heal(thrill_bonus, false));
        r.push(ctx.caster, effects);
        return Some(r);
    }
    if ctx.action == 7388 {
        let bonus = [87, 3832, 2678, 89]
            .into_iter()
            .filter(|id| live(ctx.statuses, *id))
            .count() as u32
            * 2;
        if let Some(actor) = instance.find_actor_mut(ctx.caster) {
            for id in [87, 3832, 2678, 89] {
                actor.status_effects_mut()?.remove(id);
            }
            if let NetworkedActor::Player { combat_state, .. } = actor {
                if combat_state.warrior.damnation_pending {
                    combat_state.warrior.damnation_until = Some(Instant::now());
                }
            }
            // 摆脱先移除战栗；自身的百分比护盾使用恢复后的最大体力。
            Warrior.refresh_runtime_state_on_actor(ctx.caster, actor);
        }
        let mut r = AreaResult::new(caster_position);
        for id in party_in_range(network, instance, ctx.caster, caster_position.0, 30.0)
            .into_iter()
            .take(32)
        {
            let target = instance.find_actor_mut(id)?;
            let cap = target.get_common_spawn().max_health_points;
            let amount = cap * (15 + bonus) / 100;
            target
                .status_effects_mut()?
                .add_barrier(1457, 0, 30.0, amount, ctx.caster, cap);
            target.status_effects_mut()?.add_tick(
                2108,
                0,
                15.0,
                TickEffectKind::Heal,
                100,
                None,
                ctx.caster,
            );
            let mut effects = vec![status(1457, 0, 30.0, false), status(2108, 0, 15.0, false)];
            if level >= 76 {
                let amount = restore(target, parameters.calc_heal_amount(300));
                effects.push(heal(amount, false));
            }
            r.push(id, effects);
        }
        return Some(r);
    }
    if !area(ctx.action) {
        if weapon(ctx.action) && nascent.is_some() {
            let mut r = AreaResult::new(caster_position);
            r.push(ctx.target, ctx.effects.iter().copied());
            let id = nascent?;
            if let Some(target) = instance.find_actor_mut(id) {
                let amount = restore(
                    target,
                    parameters
                        .calc_heal_amount_with_critical(400, forced(ctx.action, ctx.statuses)),
                );
                r.push(id, [heal(amount, false)]);
            }
            return Some(r);
        }
        return None;
    }
    let centered_on_target = matches!(ctx.action, 25753 | 36925);
    let center = if centered_on_target {
        instance.find_actor(ctx.target)?.position()
    } else {
        caster_position
    };
    let mut r = AreaResult::new(center);
    let mut targets = enemies_in_range(instance, center.0, 5.0);
    if centered_on_target {
        targets.sort_by_key(|id| *id != ctx.target);
    }
    let mut hits = 0;
    let caster_effects: Vec<_> = ctx
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
    // 为状态、吸血与勇猛联动预留演员槽，避免 32 目标包溢出。
    let slots = 32
        - usize::from(!caster_effects.is_empty() || has_blood_heal(ctx.statuses))
        - usize::from(nascent.is_some());
    for (index, id) in targets.into_iter().take(slots).enumerate() {
        let p = potency(ctx.action, level, ctx.combo);
        let p = if index > 0 && matches!(ctx.action, 25753 | 36924 | 36925) {
            p / 2
        } else {
            p
        };
        let (amount, kind) = parameters.roll_damage_with_modifiers(
            modifiers.apply_base_damage(parameters.calc_physical_damage(p)),
            modifiers.against_target(instance.find_actor(id)).roll,
        );
        let target = instance.find_actor_mut(id)?;
        if matches!(
            target,
            NetworkedActor::Npc {
                currently_invulnerable: true,
                ..
            }
        ) {
            r.push(id, [TargetEffect(TargetEffectKind::Invincible {})]);
            continue;
        }
        target.apply_damage(amount);
        if let Some(hate) = target.npc_hate_list_mut() {
            let v = hate.entry(ctx.caster).or_default();
            *v = v.saturating_add(amount.saturating_mul(enmity));
        }
        notify_attack_hit(instance, ctx.caster, id, amount);
        let mut effect = damage(amount, DamageType::Slashing);
        if let TargetEffectKind::Damage { damage_kind, .. } = &mut effect.0 {
            *damage_kind = kind;
        }
        r.push(id, [effect]);
        hits += 1;
    }
    let mut own = caster_effects;
    if weapon(ctx.action) && has_blood_heal(ctx.statuses) && hits > 0 {
        let base = (0..hits)
            .map(|_| {
                parameters.calc_heal_amount_with_critical(400, forced(ctx.action, ctx.statuses))
            })
            .sum();
        if let Some(actor) = instance.find_actor_mut(ctx.caster) {
            own.push(heal(restore(actor, base), false));
        }
        if let Some(id) = nascent
            && let Some(actor) = instance.find_actor_mut(id)
        {
            r.push(id, [heal(restore(actor, base), false)]);
        }
    }
    if !own.is_empty() {
        r.push(ctx.caster, own);
    }
    if hits > 0
        && let Some((target, _)) = r.targets.iter().find(|(id, _)| id.object_id != ctx.caster)
        && let Some(actor) = instance.find_actor_mut(ctx.caster)
    {
        paladin::engage_auto_attack(actor, target.object_id);
    }
    Some(r)
}
fn restore(actor: &mut NetworkedActor, base: u32) -> u32 {
    if actor.get_common_spawn().health_points == 0 {
        return 0;
    }
    let amount = (base as f64 * white_mage::incoming_heal_multiplier(Some(actor))) as u32;
    actor.apply_heal(amount);
    amount
}

#[cfg(test)]
mod tests {
    use super::*;
    fn actor() -> (ObjectId, NetworkedActor) {
        let id = ObjectId(0x10000001);
        let mut i = Instance::default();
        i.insert_empty_actor(id);
        let mut a = i.actors.remove(&id).unwrap();
        let c = a.get_common_spawn_mut();
        c.class_job = 21;
        c.level = 100;
        c.health_points = 10000;
        c.max_health_points = 10000;
        (id, a)
    }
    #[test]
    fn warrior_chaos_has_priority_and_does_not_consume_release_stack() {
        let (id, mut a) = actor();
        Warrior.update_state_after_action(7389, &mut a, id);
        Warrior.update_state_after_action(52, &mut a, id);
        let NetworkedActor::Player { combat_state, .. } = &a else {
            unreachable!()
        };
        assert_eq!(combat_state.warrior.resolve(3549, 100), 16465);
        Warrior.update_state_after_action(16465, &mut a, id);
        let NetworkedActor::Player { combat_state, .. } = &a else {
            unreachable!()
        };
        assert_eq!(combat_state.warrior.beast, 0);
        assert_eq!(combat_state.warrior.release_stacks, 3);
        assert!(!combat_state.warrior.can_execute(16465, true));
        for _ in 0..3 {
            Warrior.update_state_after_action(3549, &mut a, id);
        }
        let NetworkedActor::Player { combat_state, .. } = &a else {
            unreachable!()
        };
        assert_eq!(combat_state.warrior.release_stacks, 0);
        assert_eq!(combat_state.warrior.resolve(7389, 100), 36924);
        assert!(!combat_state.warrior.can_execute(3549, true));
    }
    #[test]
    fn warrior_combo_resources_and_level_sync() {
        let (id, mut a) = actor();
        for (action, expected) in [(37, 10), (42, 30), (45, 40), (16462, 60)] {
            Warrior.after_combo(action, &mut a, id);
            let NetworkedActor::Player { combat_state, .. } = &a else {
                unreachable!()
            };
            assert_eq!(combat_state.warrior.beast, expected);
        }
        a.get_common_spawn_mut().level = 34;
        Warrior.after_combo(42, &mut a, id);
        let NetworkedActor::Player { combat_state, .. } = &a else {
            unreachable!()
        };
        assert_eq!(combat_state.warrior.beast, 60);
        assert_eq!(Warrior.build_gauge_data(combat_state, 34), Some(0));
        assert_eq!(combat_state.warrior.resolve(49, 53), 49);
        assert_eq!(combat_state.warrior.resolve(49, 54), 3549);
        assert_eq!(combat_state.warrior.resolve(38, 69), 38);
        assert_eq!(combat_state.warrior.resolve(38, 70), 7389);
        assert!(!combat_state.warrior.can_execute(52, false));
    }
    #[test]
    fn warrior_holmgang_preserves_one_hp_but_does_not_resurrect() {
        let (id, mut a) = actor();
        a.status_effects_mut()
            .unwrap()
            .add_with_source(409, 0, 10.0, id);
        a.apply_damage(u32::MAX);
        assert_eq!(a.get_common_spawn().health_points, 1);
        a.get_common_spawn_mut().health_points = 0;
        a.apply_damage(1);
        assert_eq!(a.get_common_spawn().health_points, 0);
        a.get_common_spawn_mut().health_points = 10;
        a.status_effects_mut().unwrap().remove(409);
        a.apply_damage(100);
        assert_eq!(a.get_common_spawn().health_points, 0);
    }
    #[test]
    fn warrior_thrill_is_reversible_and_damnation_regen_only_triggers_once() {
        let (id, mut a) = actor();
        a.status_effects_mut()
            .unwrap()
            .add_with_source(87, 20, 10.0, id);
        Warrior.update_state_after_action(40, &mut a, id);
        assert_eq!(a.get_common_spawn().max_health_points, 12000);
        assert_eq!(a.get_common_spawn().health_points, 12000);
        a.status_effects_mut().unwrap().remove(87);
        Warrior.refresh_runtime_state_on_actor(id, &mut a);
        assert_eq!(a.get_common_spawn().max_health_points, 10000);
        a.status_effects_mut()
            .unwrap()
            .add_with_source(3832, 0, 15.0, id);
        Warrior.update_state_after_action(36923, &mut a, id);
        a.apply_damage(1);
        assert!(a.status_effects().unwrap().get(3900).is_some());
        a.status_effects_mut().unwrap().remove(3900);
        a.apply_damage(1);
        assert!(a.status_effects().unwrap().get(3900).is_none());
        Warrior.update_state_after_action(36923, &mut a, id);
        if let NetworkedActor::Player { combat_state, .. } = &mut a {
            combat_state.warrior.damnation_until = Some(Instant::now());
        }
        Warrior.refresh_runtime_state_on_actor(id, &mut a);
        assert!(a.status_effects().unwrap().get(3900).is_some());
    }
}
