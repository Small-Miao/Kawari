//! 骑士的连击、忠义和战斗技能。

use std::time::{Duration, Instant};

use kawari::{
    common::ObjectId,
    ipc::zone::{
        ActionEffect1, ActionRequest, ActionType, DamageElement, DamageType, ServerZoneIpcData,
        ServerZoneIpcSegment, TargetEffect, TargetEffectKind,
    },
};

use crate::{
    FromServer, StatusEffects, TickDamageSnapshot, TickEffectKind,
    gamedata::GameData,
    lua::{BarrierAction, EffectsBuilder, EnmityAction, GaugeAction, TickAction, TickKind},
    server::{
        action::{
            action_damage_modifiers,
            area::{AreaDamage, AreaResult, enemies_in_range, party_in_range},
        },
        actor::{NetworkedActor, NpcState},
        combat_state::PlayerCombatState,
        director::notify_attack_hit,
        instance::Instance,
        jobs::{
            dispatch::{Job, JobActionUpdate, JobRefreshResult, send_job_gauge_update},
            white_mage,
        },
        network::{DestinationNetwork, NetworkState},
    },
};

const GLADIATOR: u8 = 1;
const PALADIN: u8 = 19;
pub(in crate::server) const AUTO_ATTACK: u32 = 7;
pub(in crate::server) const IRON_WILL: u16 = 79;
const FIGHT_OR_FLIGHT: u16 = 76;
const DIVINE_MIGHT: u16 = 2673;
const REQUIESCAT: u16 = 1368;
const CONFITEOR_READY: u16 = 3019;
const ATONEMENT_READY: u16 = 1902;
const SUPPLICATION_READY: u16 = 3827;
const SEPULCHRE_READY: u16 = 3828;
const HONOR_READY: u16 = 3831;
const GORING_READY: u16 = 3847;

const FAST_BLADE: u32 = 9;
const RIOT_BLADE: u32 = 15;
const RAGE_OF_HALONE: u32 = 21;
const ROYAL_AUTHORITY: u32 = 3539;
const TOTAL_ECLIPSE: u32 = 7381;
const PROMINENCE: u32 = 16457;
const HOLY_SPIRIT: u32 = 7384;
const HOLY_CIRCLE: u32 = 16458;
const ATONEMENT: u32 = 16460;
const SUPPLICATION: u32 = 36918;
const SEPULCHRE: u32 = 36919;
const CONFITEOR: u32 = 16459;
const FAITH: u32 = 25748;
const TRUTH: u32 = 25749;
const VALOR: u32 = 25750;
const HONOR: u32 = 36922;
const GORING_BLADE: u32 = 3538;
const SHELTRON: u32 = 3542;
const HOLY_SHELTRON: u32 = 25746;
const COVER: u32 = 27;
const INTERVENTION: u32 = 7382;
const SENTINEL: u32 = 17;
const GUARDIAN: u32 = 36920;
const DIVINE_VEIL: u32 = 3540;
const CIRCLE_OF_SCORN: u32 = 23;
const REPRISAL: u32 = 7535;
const REQUIESCAT_ACTION: u32 = 7383;
const IMPERATOR: u32 = 36921;
const PASSAGE_OF_ARMS: u32 = 7385;

#[derive(Debug, Clone, Default)]
pub struct PaladinState {
    oath: u8,
    blade_step: u8,
    blade_until: Option<Instant>,
    atonement_step: u8,
    atonement_until: Option<Instant>,
    goring_until: Option<Instant>,
    confiteor_until: Option<Instant>,
    honor_until: Option<Instant>,
    auto_target: Option<ObjectId>,
    auto_next: Option<Instant>,
    auto_disabled: bool,
    passage: Option<(kawari::common::Position, f32, Instant)>,
}

fn ready(until: Option<Instant>, now: Instant) -> bool {
    until.is_some_and(|until| now < until)
}

fn oath_cost(action: u32) -> u8 {
    match action {
        SHELTRON | HOLY_SHELTRON | COVER | INTERVENTION => 50,
        _ => 0,
    }
}

pub(in crate::server) fn is_paladin(class_job: u8) -> bool {
    matches!(class_job, GLADIATOR | PALADIN)
}

pub(in crate::server) fn has_divine_magic_mastery(class_job: u8, level: u8) -> bool {
    class_job == PALADIN && level >= 64
}

pub(in crate::server) fn party_target_only(action: u32) -> bool {
    matches!(action, COVER | INTERVENTION | 7537)
}

pub(in crate::server) fn deactivate(actor: &mut NetworkedActor) {
    if let NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    } = actor
    {
        combat_state.paladin = PaladinState::default();
        for status in [
            IRON_WILL,
            FIGHT_OR_FLIGHT,
            DIVINE_MIGHT,
            REQUIESCAT,
            CONFITEOR_READY,
            ATONEMENT_READY,
            SUPPLICATION_READY,
            SEPULCHRE_READY,
            HONOR_READY,
            GORING_READY,
            1175,
        ] {
            status_effects.remove(status);
        }
    }
}

impl PaladinState {
    fn gauge(&self, level: u8, now: Instant) -> u64 {
        let ms = self
            .blade_until
            .map(|until| {
                until
                    .saturating_duration_since(now)
                    .as_micros()
                    .div_ceil(1000)
            })
            .unwrap_or_default()
            .min(30_000) as u16;
        let [lo, hi] = ms.to_le_bytes();
        let oath = if level >= 35 { self.oath } else { 0 };
        let step = if level >= 90 && ms > 0 {
            self.blade_step
        } else {
            0
        };
        let [lo, hi] = if step > 0 { [lo, hi] } else { [0, 0] };
        u64::from_le_bytes([oath, 0, lo, hi, step, 0, 0, 0])
    }

    fn resolve(&self, action: u32, level: u8, now: Instant) -> u32 {
        match action {
            RAGE_OF_HALONE if level >= 60 => ROYAL_AUTHORITY,
            SENTINEL if level >= 92 => GUARDIAN,
            SHELTRON if level >= 82 => HOLY_SHELTRON,
            29 if level >= 86 => 25747,
            REQUIESCAT_ACTION | IMPERATOR if level >= 100 && ready(self.honor_until, now) => HONOR,
            REQUIESCAT_ACTION if level >= 96 => IMPERATOR,
            ATONEMENT if ready(self.atonement_until, now) => match self.atonement_step {
                2 => SUPPLICATION,
                3 => SEPULCHRE,
                _ => ATONEMENT,
            },
            CONFITEOR if ready(self.blade_until, now) => match self.blade_step {
                1 => FAITH,
                2 => TRUTH,
                3 => VALOR,
                _ => CONFITEOR,
            },
            _ => action,
        }
    }

    fn can_execute(&self, action: u32, level: u8, now: Instant) -> bool {
        if oath_cost(action) > 0 && (level < 35 || self.oath < 50) {
            return false;
        }
        match action {
            AUTO_ATTACK => false,
            GORING_BLADE => ready(self.goring_until, now),
            ATONEMENT | SUPPLICATION | SEPULCHRE => {
                ready(self.atonement_until, now)
                    && self.atonement_step
                        == match action {
                            ATONEMENT => 1,
                            SUPPLICATION => 2,
                            _ => 3,
                        }
            }
            CONFITEOR => ready(self.confiteor_until, now),
            FAITH | TRUTH | VALOR => {
                ready(self.blade_until, now)
                    && self.blade_step
                        == match action {
                            FAITH => 1,
                            TRUTH => 2,
                            _ => 3,
                        }
            }
            HONOR => ready(self.honor_until, now),
            _ => true,
        }
    }
}

pub(in crate::server) struct Paladin;

impl Job for Paladin {
    fn class_jobs(&self) -> &'static [u8] {
        &[PALADIN, GLADIATOR]
    }
    fn resolve_action(
        &self,
        request: &ActionRequest,
        state: &PlayerCombatState,
        level: u8,
        _: &mut GameData,
    ) -> u32 {
        state
            .paladin
            .resolve(request.action_id, level, Instant::now())
    }
    fn can_execute(&self, action: u32, state: &PlayerCombatState, level: u8) -> bool {
        state.paladin.can_execute(action, level, Instant::now())
    }
    fn apply_gauge_action(&self, _: &mut PlayerCombatState, _: &GaugeAction) {}
    fn update_state_after_action(
        &self,
        action: u32,
        actor: &mut NetworkedActor,
        owner: ObjectId,
    ) -> JobActionUpdate {
        let level = actor.get_common_spawn().level;
        let position = actor.position();
        let rotation = actor.rotation();
        let NetworkedActor::Player {
            combat_state,
            status_effects,
            ..
        } = actor
        else {
            return JobActionUpdate::default();
        };
        let job = &mut combat_state.paladin;
        if action == PASSAGE_OF_ARMS {
            job.passage = Some((position, rotation, Instant::now() + Duration::from_secs(18)));
            job.auto_target = None;
        } else if job.passage.take().is_some() {
            status_effects.remove(1175);
        }
        let until = Some(Instant::now() + Duration::from_secs(30));
        let changed = oath_cost(action) > 0 || matches!(action, CONFITEOR | FAITH | TRUTH | VALOR);
        job.oath = job.oath.saturating_sub(oath_cost(action));
        match action {
            20 if level >= 54 => job.goring_until = until,
            GORING_BLADE => {
                job.goring_until = None;
                status_effects.remove(GORING_READY);
            }
            ATONEMENT | SUPPLICATION | SEPULCHRE => {
                let (old, next, step) = match action {
                    ATONEMENT => (ATONEMENT_READY, SUPPLICATION_READY, 2),
                    SUPPLICATION => (SUPPLICATION_READY, SEPULCHRE_READY, 3),
                    _ => (SEPULCHRE_READY, 0, 0),
                };
                status_effects.remove(old);
                if next != 0 {
                    status_effects.add_with_source(next, 0, 30.0, owner);
                }
                job.atonement_step = step;
                job.atonement_until = if step > 0 { until } else { None };
            }
            REQUIESCAT_ACTION | IMPERATOR if level >= 80 => job.confiteor_until = until,
            CONFITEOR | FAITH | TRUTH | VALOR => {
                let step = match action {
                    CONFITEOR if level >= 90 => 1,
                    FAITH => 2,
                    TRUTH => 3,
                    _ => 0,
                };
                job.blade_step = step;
                job.blade_until = if step > 0 { until } else { None };
                if action == CONFITEOR {
                    status_effects.remove(CONFITEOR_READY);
                    job.confiteor_until = None;
                }
                if action == VALOR && level >= 100 {
                    job.honor_until = until;
                }
                consume_requiescat(status_effects, owner);
            }
            HOLY_SPIRIT | HOLY_CIRCLE => {
                if status_effects.get(DIVINE_MIGHT).is_some() {
                    status_effects.remove(DIVINE_MIGHT);
                } else {
                    consume_requiescat(status_effects, owner);
                }
            }
            HONOR => {
                job.honor_until = None;
                status_effects.remove(HONOR_READY);
            }
            32065 => status_effects.remove(IRON_WILL),
            _ => {}
        }
        JobActionUpdate {
            changed,
            ..Default::default()
        }
    }
    fn build_gauge_data(&self, state: &PlayerCombatState, level: u8) -> Option<u64> {
        Some(state.paladin.gauge(level, Instant::now()))
    }
    fn refresh_runtime_state_on_actor(
        &self,
        _: ObjectId,
        actor: &mut NetworkedActor,
    ) -> JobRefreshResult {
        let NetworkedActor::Player { combat_state, .. } = actor else {
            return JobRefreshResult::default();
        };
        let state = &mut combat_state.paladin;
        if state.blade_step > 0 && !ready(state.blade_until, Instant::now()) {
            state.blade_step = 0;
            state.blade_until = None;
            return JobRefreshResult {
                changed: true,
                ..Default::default()
            };
        }
        JobRefreshResult::default()
    }
}

fn consume_requiescat(statuses: &mut crate::StatusEffects, owner: ObjectId) {
    if let Some(status) = statuses.get(REQUIESCAT) {
        let stacks = status.param.saturating_sub(1);
        if stacks == 0 {
            statuses.remove(REQUIESCAT);
        } else {
            statuses.add_with_source(REQUIESCAT, stacks, status.duration, owner);
        }
    }
}

pub(in crate::server) fn preserves_combo(action: u32) -> bool {
    !matches!(
        action,
        FAST_BLADE | RIOT_BLADE | ROYAL_AUTHORITY | RAGE_OF_HALONE | TOTAL_ECLIPSE | PROMINENCE
    )
}

pub(in crate::server) fn apply_combo_proc(actor: &mut NetworkedActor, action: u32) {
    if action != ROYAL_AUTHORITY || actor.get_common_spawn().level < 76 {
        return;
    }
    if let NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    } = actor
    {
        combat_state.paladin.atonement_step = 1;
        combat_state.paladin.atonement_until = Some(Instant::now() + Duration::from_secs(30));
        status_effects.remove(SUPPLICATION_READY);
        status_effects.remove(SEPULCHRE_READY);
    }
}

pub(in crate::server) fn instant_cast(actor: &NetworkedActor, action: u32) -> bool {
    actor.status_effects().is_some_and(|statuses| {
        statuses.get(REQUIESCAT).is_some()
            || (matches!(action, HOLY_SPIRIT | HOLY_CIRCLE) && statuses.get(DIVINE_MIGHT).is_some())
    })
}

pub(in crate::server) fn damage_bonus(actor: &NetworkedActor) -> bool {
    actor
        .status_effects()
        .is_some_and(|s| s.get(FIGHT_OR_FLIGHT).is_some())
}

pub(in crate::server) fn mitigation_multiplier(actor: &NetworkedActor) -> f64 {
    let Some(statuses) = actor.status_effects() else {
        return 1.0;
    };
    if statuses.get(82).is_some() {
        return 0.0;
    }
    let intervention = statuses
        .get(1174)
        .map_or(1.0, |status| if status.param == 20 { 0.8 } else { 0.9 });
    let resolve = statuses
        .get(2675)
        .map_or(1.0, |status| if status.param == 10 { 0.9 } else { 0.85 });
    let defenses = [
        (74, 0.7),
        (77, 0.8),
        (1175, 0.8),
        (1176, 0.85),
        (1856, 0.85),
        (2674, 0.85),
        (3829, 0.6),
        (1191, 0.8),
    ];
    defenses
        .into_iter()
        .filter(|(id, _)| statuses.get(*id).is_some())
        .fold(1.0, |multiplier, (_, scale)| multiplier * scale)
        * intervention
        * resolve
}

pub(in crate::server) fn outgoing_multiplier(actor: &NetworkedActor) -> f64 {
    if actor
        .status_effects()
        .is_some_and(|s| s.get(1193).is_some())
    {
        0.9
    } else {
        1.0
    }
}

pub(in crate::server) fn enmity_multiplier(actor: &NetworkedActor) -> u32 {
    if actor
        .status_effects()
        .is_some_and(|s| s.get(IRON_WILL).is_some())
    {
        10
    } else {
        1
    }
}

fn status(id: u16, param: u16, duration: f32, self_target: bool) -> TargetEffect {
    TargetEffect(if self_target {
        TargetEffectKind::GainEffectSelf {
            unk1: 0,
            unk2: 0,
            param,
            unk3: 0,
            effect_id: id,
            duration,
        }
    } else {
        TargetEffectKind::GainEffect {
            unk1: 0,
            unk2: 0,
            param,
            unk3: 0,
            effect_id: id,
            duration,
        }
    })
}

fn mp(amount: u16) -> TargetEffect {
    TargetEffect(TargetEffectKind::MpGain {
        params: [0, 0, 0, 0, 0x80],
        amount,
    })
}

fn damage(amount: u32, magical: bool) -> TargetEffect {
    TargetEffect(TargetEffectKind::Damage {
        damage_kind: Default::default(),
        damage_type: if magical {
            DamageType::Magic
        } else {
            DamageType::Slashing
        },
        damage_element: DamageElement::Unaspected,
        bonus_percent: 0,
        unk3: 0,
        unk4: 0,
        amount,
    })
}

fn heal(amount: u32, at_source: bool) -> TargetEffect {
    TargetEffect(TargetEffectKind::Heal {
        unk1: [0, 0, 0, 0, if at_source { 0x80 } else { 0 }],
        amount,
    })
}

fn trait_potency(level: u8, base: u32, at_84: u32, at_94: u32) -> u32 {
    match level {
        94.. => at_94,
        84.. => at_84,
        _ => base,
    }
}

pub(in crate::server) fn action_effects(
    action: u32,
    actor: &NetworkedActor,
    combo: bool,
) -> Option<EffectsBuilder> {
    let NetworkedActor::Player {
        parameters,
        status_effects,
        ..
    } = actor
    else {
        return None;
    };
    let level = actor.get_common_spawn().level;
    let mut builder = EffectsBuilder::default();
    let effects = &mut builder.effects;
    let requiescat = status_effects.get(REQUIESCAT).is_some();
    let divine = status_effects.get(DIVINE_MIGHT).is_some();
    let trait_damage = |base, mid, high| trait_potency(level, base, mid, high);
    let (potency, magical) = match action {
        FAST_BLADE => (trait_damage(150, 200, 220), false),
        RIOT_BLADE => (
            if combo {
                trait_damage(260, 300, 330)
            } else {
                trait_damage(100, 140, 170)
            },
            false,
        ),
        RAGE_OF_HALONE => (if combo { 330 } else { 100 }, false),
        ROYAL_AUTHORITY => (
            if combo {
                trait_damage(360, 400, 460)
            } else {
                trait_damage(100, 140, 200)
            },
            false,
        ),
        16 | 24 => (100, false),
        29 => (270, false),
        GORING_BLADE => (700, false),
        16461 => (150, false),
        ATONEMENT => (trait_damage(360, 400, 460), false),
        SUPPLICATION => (trait_damage(380, 420, 500), false),
        SEPULCHRE => (trait_damage(400, 440, 540), false),
        25747 => (450, false),
        REQUIESCAT_ACTION => (320, true),
        IMPERATOR => (580, true),
        HONOR => (1000, true),
        HOLY_SPIRIT => (
            trait_damage(300, 350, 400)
                + if divine {
                    100
                } else if requiescat {
                    300
                } else {
                    0
                },
            true,
        ),
        CONFITEOR | FAITH | TRUTH | VALOR => {
            let base = match action {
                CONFITEOR | VALOR => {
                    if level >= 94 {
                        500
                    } else {
                        420
                    }
                }
                FAITH => {
                    if level >= 94 {
                        260
                    } else {
                        220
                    }
                }
                _ => {
                    if level >= 94 {
                        380
                    } else {
                        320
                    }
                }
            };
            (base + if requiescat { 500 } else { 0 }, true)
        }
        _ => (0, false),
    };
    if potency > 0 {
        let base = if magical {
            parameters.calc_magical_damage(potency)
        } else {
            parameters.calc_physical_damage(potency)
        };
        effects.push(damage(base, magical));
    }
    match action {
        FAST_BLADE | RAGE_OF_HALONE | GORING_BLADE | 16461 | HONOR => {}
        RIOT_BLADE => {
            if combo {
                effects.push(mp(1000));
            }
        }
        ROYAL_AUTHORITY => {
            if combo {
                if level >= 76 {
                    effects.push(status(ATONEMENT_READY, 0, 30.0, true));
                }
                if level >= 64 {
                    effects.push(status(DIVINE_MIGHT, 0, 30.0, true));
                }
            }
        }
        16 | 7540 => effects.push(status(2, 0, if action == 16 { 6.0 } else { 5.0 }, false)),
        24 => builder
            .enmity_actions
            .push(EnmityAction::Add { amount: 1000 }),
        29 | 25747 => {
            if level >= 58 {
                effects.push(mp(500));
            }
        }
        ATONEMENT | SUPPLICATION | SEPULCHRE => {
            effects.push(mp(400));
            let proc = if action == ATONEMENT {
                SUPPLICATION_READY
            } else if action == SUPPLICATION {
                SEPULCHRE_READY
            } else {
                0
            };
            if proc > 0 {
                effects.push(status(proc, 0, 30.0, true));
            }
        }
        REQUIESCAT_ACTION | IMPERATOR => {
            effects.push(status(REQUIESCAT, 4, 30.0, true));
            if level >= 80 {
                effects.push(status(CONFITEOR_READY, 0, 30.0, true));
            }
        }
        HOLY_SPIRIT | CONFITEOR | FAITH | TRUTH | VALOR => {
            if level >= 84 {
                effects.push(heal(parameters.calc_heal_amount(400), true));
            }
            if action == VALOR && level >= 100 {
                effects.push(status(HONOR_READY, 0, 30.0, true));
            }
        }
        20 => {
            effects.push(status(FIGHT_OR_FLIGHT, 25, 20.0, true));
            if level >= 54 {
                effects.push(status(GORING_READY, 0, 30.0, true));
            }
        }
        28 => effects.push(status(IRON_WILL, 0, 604800.0, true)),
        32065 => effects.push(TargetEffect(TargetEffectKind::Unknown {
            magic: 17,
            param0: 0,
            param1: 0,
            param2: 0,
            param3: 0,
            param4: 0x80,
            value: IRON_WILL,
        })),
        SENTINEL => effects.push(status(74, 0, 15.0, true)),
        GUARDIAN => {
            effects.push(status(3829, 0, 15.0, true));
            effects.push(status(3830, 0, 15.0, true));
            builder.barrier_actions.push(BarrierAction {
                effect_id: 3830,
                param: 0,
                duration: 15.0,
                amount: parameters.calc_heal_amount(1000),
                on_self: true,
            });
        }
        22 => effects.push(status(77, 0, 10.0, true)),
        30 => effects.push(status(82, 0, 10.0, true)),
        SHELTRON => effects.push(status(1856, 0, 6.0, true)),
        HOLY_SHELTRON => {
            effects.push(status(2674, 0, 8.0, true));
            effects.push(status(2675, 0, 4.0, true));
            effects.push(status(2676, 0, 12.0, true));
            builder.tick_actions.push(TickAction {
                effect_id: 2676,
                param: 0,
                duration: 12.0,
                potency: 250,
                kind: TickKind::Heal,
                on_self: true,
            });
        }
        INTERVENTION => {
            let enhanced = [74, 3829, 1191]
                .into_iter()
                .any(|id| status_effects.get(id).is_some());
            effects.push(status(1174, if enhanced { 20 } else { 10 }, 8.0, false));
            if level >= 82 {
                effects.push(status(2675, 10, 4.0, false));
                effects.push(status(2676, 0, 12.0, false));
                builder.tick_actions.push(TickAction {
                    effect_id: 2676,
                    param: 0,
                    duration: 12.0,
                    potency: 250,
                    kind: TickKind::Heal,
                    on_self: false,
                });
            }
        }
        COVER => effects.push(status(80, 0, 12.0, false)),
        PASSAGE_OF_ARMS => effects.push(status(1175, 0, 18.0, true)),
        3541 => effects.push(heal(parameters.calc_heal_amount(1000), false)),
        7531 => effects.push(status(1191, 0, 20.0, true)),
        7548 => effects.push(status(1209, 0, 6.0, true)),
        7538 => effects.push(TargetEffect(TargetEffectKind::InterruptAction {})),
        7533 => builder.enmity_actions.push(EnmityAction::Provoke),
        7537 => builder
            .enmity_actions
            .push(EnmityAction::Transfer { percent: 25 }),
        PROMINENCE => {
            if combo && level >= 72 {
                effects.push(mp(1000));
                effects.push(status(DIVINE_MIGHT, 0, 30.0, true));
            }
        }
        HOLY_CIRCLE => {
            if level >= 84 {
                effects.push(heal(parameters.calc_heal_amount(400), true));
            }
        }
        TOTAL_ECLIPSE | CIRCLE_OF_SCORN | DIVINE_VEIL | REPRISAL => {}
        _ => return None,
    }
    Some(builder)
}

pub(in crate::server) fn apply_area_action(
    network: &mut NetworkState,
    instance: &mut Instance,
    caster: ObjectId,
    action: u32,
    combo: bool,
    before: &StatusEffects,
    caster_effects: &[TargetEffect; 8],
) -> Option<AreaResult> {
    let (potency, damage_type) = match action {
        TOTAL_ECLIPSE => (120, DamageType::Slashing),
        PROMINENCE => (if combo { 220 } else { 100 }, DamageType::Slashing),
        HOLY_CIRCLE => {
            let potency = if before.get(DIVINE_MIGHT).is_some() {
                250
            } else if before.get(REQUIESCAT).is_some() {
                350
            } else {
                100
            };
            (potency, DamageType::Magic)
        }
        CIRCLE_OF_SCORN => (140, DamageType::Slashing),
        REPRISAL | DIVINE_VEIL => (0, DamageType::Slashing),
        _ => return None,
    };
    let actor = instance.find_actor(caster)?;
    let NetworkedActor::Player { parameters, .. } = actor else {
        return None;
    };
    let parameters = parameters.clone();
    let common = actor.get_common_spawn();
    let level = common.level;
    let max_hp = common.max_health_points;
    let center = actor.position();
    let modifiers = action_damage_modifiers(Some(actor));
    let mut result = AreaResult::new(center);
    if action == DIVINE_VEIL {
        for id in party_in_range(network, instance, caster, center.0, 30.0) {
            let actor = instance.find_actor_mut(id).unwrap();
            let cap = actor.get_common_spawn().max_health_points;
            actor.status_effects_mut().unwrap().add_barrier(
                1362,
                0,
                30.0,
                max_hp / 10,
                caster,
                cap,
            );
            let mut effects = vec![status(1362, 0, 30.0, false)];
            if level >= 88 {
                let amount = (f64::from(parameters.calc_heal_amount(400))
                    * white_mage::incoming_heal_multiplier(Some(actor)))
                    as u32;
                let common = actor.get_common_spawn_mut();
                common.health_points = common.health_points.saturating_add(amount).min(cap);
                effects.push(heal(amount, false));
            }
            result.push(id, effects);
        }
        return Some(result);
    }
    if action == REPRISAL {
        let duration = if level >= 98 { 15.0 } else { 10.0 };
        for id in enemies_in_range(instance, center.0, 5.0)
            .into_iter()
            .take(32)
        {
            instance
                .find_actor_mut(id)
                .unwrap()
                .status_effects_mut()
                .unwrap()
                .add_with_source(1193, 0, duration, caster);
            result.push(id, [status(1193, 0, duration, false)]);
        }
        return Some(result);
    }

    if matches!(action, PROMINENCE | HOLY_CIRCLE) {
        let caster_effects = caster_effects.iter().copied().filter(|effect| {
            !matches!(
                effect.0,
                TargetEffectKind::None | TargetEffectKind::ExecuteCombo { .. }
            )
        });
        result.push(caster, caster_effects);
    }
    result.apply_damage(
        instance,
        caster,
        &parameters,
        AreaDamage {
            potency,
            falloff: 0,
            radius: 5.0,
            damage_type,
        },
    );
    if action == CIRCLE_OF_SCORN {
        let snapshot = TickDamageSnapshot {
            base_amount: modifiers.apply_base_damage(parameters.calc_physical_damage(30)),
            roll_modifiers: modifiers.roll,
        };
        for (target, row) in &mut result.targets {
            if matches!(row[0].0, TargetEffectKind::Damage { .. }) {
                instance
                    .find_actor_mut(target.object_id)
                    .unwrap()
                    .status_effects_mut()
                    .unwrap()
                    .add_tick(
                        248,
                        0,
                        15.0,
                        TickEffectKind::DamagePhysical,
                        30,
                        Some(snapshot),
                        caster,
                    );
                row[1] = status(248, 0, 15.0, false);
            }
        }
    }
    Some(result)
}

pub(in crate::server) fn engage_auto_attack(actor: &mut NetworkedActor, target: ObjectId) {
    if let NetworkedActor::Player { combat_state, .. } = actor
        && !combat_state.paladin.auto_disabled
    {
        combat_state.paladin.auto_target = Some(target);
    }
}

pub(in crate::server) fn toggle_auto_attack(
    actor: &mut NetworkedActor,
    on: bool,
    target: ObjectId,
    manual: bool,
) {
    if let NetworkedActor::Player { combat_state, .. } = actor {
        let state = &mut combat_state.paladin;
        if manual || on {
            state.auto_disabled = !on;
        }
        state.auto_target = on.then_some(target);
    }
}

pub(in crate::server) fn retarget_auto_attack(actor: &mut NetworkedActor, target: ObjectId) {
    if let NetworkedActor::Player { combat_state, .. } = actor
        && combat_state.paladin.auto_target.is_some()
    {
        combat_state.paladin.auto_target = target.is_valid().then_some(target);
    }
}

pub(in crate::server) fn refresh_auto_attacks(network: &mut NetworkState, instance: &mut Instance) {
    let now = Instant::now();
    refresh_passage(network, instance, now);
    let mut ready = Vec::new();
    for (&source, actor) in &instance.actors {
        let NetworkedActor::Player {
            spawn,
            combat_state,
            parameters,
            ..
        } = actor
        else {
            continue;
        };
        let state = &combat_state.paladin;
        if !is_paladin(spawn.common.class_job)
            || spawn.common.health_points == 0
            || state.auto_disabled
            || state.auto_next.is_some_and(|next| next > now)
            || actor.is_time_stopped()
            || actor
                .status_effects()
                .is_some_and(|statuses| statuses.get(1175).is_some())
        {
            continue;
        }
        let Some(target) = state.auto_target else {
            continue;
        };
        if !matches!(instance.find_actor(target),
            Some(enemy @ NetworkedActor::Npc { spawn, state, targetable: true, currently_invulnerable: false, .. })
                if *state != NpcState::Dead && !spawn.common.owner_id.is_valid()
                    && spawn.common.health_points > 0 && enemy.position().0.distance(actor.position().0) <= 3.0)
        {
            continue;
        }
        let delay = if parameters.delay > 0 {
            parameters.delay
        } else {
            2240
        };
        let modifiers = action_damage_modifiers(Some(actor));
        let base = parameters.calc_physical_damage(delay.saturating_mul(100) / 3000);
        let (amount, kind) = parameters
            .roll_damage_with_modifiers(modifiers.apply_base_damage(base), modifiers.roll);
        ready.push((
            source,
            target,
            delay,
            amount,
            kind,
            enmity_multiplier(actor),
        ));
    }
    for (source, target, delay, amount, kind, enmity) in ready {
        let Some(enemy) = instance.find_actor_mut(target) else {
            continue;
        };
        if enemy.get_common_spawn().health_points == 0 {
            continue;
        }
        enemy.apply_damage(amount);
        if let Some(hate) = enemy.npc_hate_list_mut() {
            let total = hate.entry(source).or_default();
            *total = total.saturating_add(amount.saturating_mul(enmity));
        }
        notify_attack_hit(instance, source, target, amount);
        let Some(NetworkedActor::Player {
            spawn,
            combat_state,
            ..
        }) = instance.find_actor_mut(source)
        else {
            continue;
        };
        let state = &mut combat_state.paladin;
        state.auto_next = Some(now + Duration::from_millis(u64::from(delay)));
        let level = spawn.common.level;
        record_oath_hit(state, level);
        let gauge = state.gauge(level, now);
        let job = spawn.common.class_job;
        let mut effects = [TargetEffect::default(); 8];
        effects[0] = damage(amount, false);
        if let TargetEffectKind::Damage { damage_kind, .. } = &mut effects[0].0 {
            *damage_kind = kind;
        }
        let target_id = kawari::common::ObjectTypeId {
            object_id: target,
            ..Default::default()
        };
        let ipc = ServerZoneIpcSegment::new(ServerZoneIpcData::ActionEffect1(ActionEffect1 {
            animation_target_id: target_id,
            target_id_again: target_id,
            action_id: AUTO_ATTACK,
            spell_id: AUTO_ATTACK as u16,
            action_type: ActionType::Action,
            target_count: 1,
            effects,
            global_sequence: network.global_action_sequence,
            ..Default::default()
        }));
        network.global_action_sequence += 1;
        network.send_in_range_inclusive_instance(
            source,
            instance,
            FromServer::PacketSegment(ipc, source),
            DestinationNetwork::ZoneClients,
        );
        if level >= 35 {
            send_job_gauge_update(network, source, job, gauge);
        }
        white_mage::send_hp_mp(network, instance, target);
    }
}

fn record_oath_hit(state: &mut PaladinState, level: u8) {
    if level >= 35 {
        state.oath = state.oath.saturating_add(5).min(100);
    }
}

fn refresh_passage(network: &mut NetworkState, instance: &mut Instance, now: Instant) {
    let mut active = Vec::new();
    let mut ended = Vec::new();
    for (&id, actor) in &mut instance.actors {
        let NetworkedActor::Player {
            spawn,
            status_effects,
            combat_state,
            ..
        } = actor
        else {
            continue;
        };
        if let Some((position, rotation, until)) = combat_state.paladin.passage {
            if now < until
                && spawn.common.health_points > 0
                && spawn.common.position.0.distance_squared(position.0) < 0.01
                && (spawn.common.rotation - rotation).cos() > 0.9999
            {
                active.push((id, position.0, rotation));
            } else {
                combat_state.paladin.passage = None;
                status_effects.remove(1175);
                ended.push(id);
            }
        }
    }
    for id in ended {
        crate::server::effect::send_effects_list_with(network, instance, id);
    }
    for (caster, center, rotation) in active {
        let behind = glam::Vec2::new(-rotation.sin(), -rotation.cos());
        for id in party_in_range(network, instance, caster, center, 8.0) {
            if id == caster {
                continue;
            }
            let actor = instance.find_actor_mut(id).unwrap();
            let offset = actor.position().0 - center;
            let direction = glam::Vec2::new(offset.x, offset.z).normalize_or_zero();
            if direction.dot(behind) < std::f32::consts::FRAC_1_SQRT_2 {
                continue;
            }
            let statuses = actor.status_effects_mut().unwrap();
            if statuses
                .get(1176)
                .is_none_or(|status| status.duration <= 2.0)
            {
                statuses.add_with_source(1176, 0, 5.0, caster);
                crate::server::effect::send_effects_list_with(network, instance, id);
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use binrw::BinWrite;
    use std::io::Cursor;

    const ACTOR: ObjectId = ObjectId(1);

    #[test]
    fn oath_gauge_spends_fifty_and_restores_five_per_landed_auto_attack() {
        let mut instance = Instance::default();
        instance.insert_empty_actor(ACTOR);
        let actor = instance.find_actor_mut(ACTOR).unwrap();
        actor.get_common_spawn_mut().level = 100;
        let NetworkedActor::Player { combat_state, .. } = actor else {
            unreachable!();
        };
        let state = &mut combat_state.paladin;
        for _ in 0..24 {
            record_oath_hit(state, 100);
        }
        assert_eq!(state.oath, 100);
        assert!(state.can_execute(HOLY_SHELTRON, 100, Instant::now()));
        Paladin.update_state_after_action(HOLY_SHELTRON, actor, ACTOR);
        let NetworkedActor::Player { combat_state, .. } = actor else {
            unreachable!();
        };
        assert_eq!(combat_state.paladin.oath, 50);
        record_oath_hit(&mut combat_state.paladin, 100);
        assert_eq!(combat_state.paladin.oath, 55);
        record_oath_hit(&mut combat_state.paladin, 34);
        assert_eq!(combat_state.paladin.oath, 55);
    }

    #[test]
    fn confiteor_chain_has_the_recorded_gauge_bytes_and_rejects_skipped_steps() {
        let mut instance = Instance::default();
        instance.insert_empty_actor(ACTOR);
        let actor = instance.find_actor_mut(ACTOR).unwrap();
        actor.get_common_spawn_mut().level = 100;
        Paladin.update_state_after_action(IMPERATOR, actor, ACTOR);
        for (action, next, step) in [
            (CONFITEOR, FAITH, 1),
            (FAITH, TRUTH, 2),
            (TRUTH, VALOR, 3),
            (VALOR, CONFITEOR, 0),
        ] {
            Paladin.update_state_after_action(action, actor, ACTOR);
            let NetworkedActor::Player { combat_state, .. } = actor else {
                unreachable!();
            };
            let state = &mut combat_state.paladin;
            state.oath = 100;
            let now = state
                .blade_until
                .map_or_else(Instant::now, |end| end - Duration::from_secs(30));
            assert_eq!(state.resolve(CONFITEOR, 100, now), next);
            if step == 1 {
                assert!(!state.can_execute(TRUTH, 100, now));
            }
            let packet = ServerZoneIpcSegment::new(ServerZoneIpcData::ActorGauge {
                classjob_id: PALADIN,
                data: state.gauge(100, now),
            });
            let mut wire = Cursor::new(Vec::new());
            packet.write_le(&mut wire).unwrap();
            let mut payload = [0; 16];
            payload[0] = 19;
            payload[2] = 100;
            if step > 0 {
                payload[4..7].copy_from_slice(&[0x30, 0x75, step]);
            }
            assert_eq!(wire.into_inner()[16..], payload);
        }
    }

    #[test]
    fn combo_bonuses_are_gated_and_abilities_preserve_the_sword_combo() {
        let mut instance = Instance::default();
        instance.insert_empty_actor(ACTOR);
        let actor = instance.find_actor_mut(ACTOR).unwrap();
        actor.get_common_spawn_mut().level = 100;
        let without_combo = action_effects(RIOT_BLADE, actor, false).unwrap();
        assert!(
            !without_combo
                .effects
                .iter()
                .any(|effect| matches!(effect.0, TargetEffectKind::MpGain { .. }))
        );
        let with_combo = action_effects(RIOT_BLADE, actor, true).unwrap();
        assert!(
            with_combo
                .effects
                .iter()
                .any(|effect| matches!(effect.0, TargetEffectKind::MpGain { amount: 1000, .. }))
        );
        assert!(preserves_combo(IMPERATOR));
        assert!(preserves_combo(ATONEMENT));
        assert!(!preserves_combo(ROYAL_AUTHORITY));
    }
}
