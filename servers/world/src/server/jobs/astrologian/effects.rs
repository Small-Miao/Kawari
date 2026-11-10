use std::time::{Duration, Instant};

use kawari::{
    common::{ObjectId, Position},
    ipc::zone::{
        ActorControlCategory, BattleNpcSubKind, CharacterDataFlag, DamageElement, DamageType,
        DisplayFlag, ObjectKind, SpawnNpc, TargetEffect, TargetEffectKind,
    },
};

use crate::{
    FromServer, StatusEffects, TickEffectKind,
    lua::{BarrierAction, EffectsBuilder, TickAction, TickKind},
    server::{
        action::area::{AreaDamage, AreaResult, party_in_range},
        actor::NetworkedActor,
        effect::send_effects_list_with,
        instance::Instance,
        jobs::white_mage,
        network::{DestinationNetwork, NetworkState},
    },
    zone_connection::BaseParameters,
};

use super::*;

const LIGHTSPEED: u32 = 3606;
const BENEFIC: u32 = 3594;
const ASPECTED_BENEFIC: u32 = 3595;
const BENEFIC_II: u32 = 3610;
const HELIOS: u32 = 3600;
const ASPECTED_HELIOS: u32 = 3601;
const HELIOS_CONJUNCTION: u32 = 37030;
const SYNASTRY: u32 = 3612;
const COLLECTIVE: u32 = 3613;
const DIGNITY: u32 = 3614;
const OPPOSITION: u32 = 16553;
const INTERSECTION: u32 = 16556;
const EXALTATION: u32 = 25873;

const STATUS_LIGHTSPEED: u16 = 841;
const STATUS_BENEFIC: u16 = 815;
const STATUS_ASPECTED_BENEFIC: u16 = 835;
const STATUS_ASPECTED_HELIOS: u16 = 836;
const STATUS_SYNASTRY_SELF: u16 = 845;
const STATUS_SYNASTRY: u16 = 846;
const STATUS_COLLECTIVE_SELF: u16 = 848;
const STATUS_COLLECTIVE: u16 = 849;
const STATUS_WHEEL: u16 = 956;
const STATUS_DIVINATION: u16 = 1878;
const STATUS_OPPOSITION: u16 = 1879;
const STATUS_INTERSECTION: u16 = 1889;
const STATUS_HOROSCOPE: u16 = 1890;
const STATUS_HOROSCOPE_HELIOS: u16 = 1891;
const STATUS_NEUTRAL: u16 = 1892;
const STATUS_NEUTRAL_BARRIER: u16 = 1921;
const STATUS_EARTHLY: u16 = 1224;
const STATUS_GIANT: u16 = 1248;
const STATUS_EXALTATION: u16 = 2717;
const STATUS_MACROCOSMOS: u16 = 2718;
const STATUS_BALANCE: u16 = 3887;
const STATUS_ARROW: u16 = 3888;
const STATUS_SPEAR: u16 = 3889;
const STATUS_BOLE: u16 = 3890;
const STATUS_EWER: u16 = 3891;
const STATUS_SPIRE: u16 = 3892;
const STATUS_DIVINING: u16 = 3893;
const STATUS_CONJUNCTION: u16 = 3894;
const STATUS_SUNTOUCHED: u16 = 3895;
const STATUS_SUN_SIGN: u16 = 3896;
const EARTHLY_STAR_PET_ID: u32 = 11;
const STELLAR_BURST: u32 = 7440;
const STELLAR_EXPLOSION: u32 = 7441;

pub(in crate::server) fn has_lightspeed(actor: &NetworkedActor) -> bool {
    actor
        .status_effects()
        .is_some_and(|s| s.get(STATUS_LIGHTSPEED).is_some())
}

pub(in crate::server) fn damage_bonus(actor: &NetworkedActor) -> (u8, bool) {
    let Some(statuses) = actor.status_effects() else {
        return (0, false);
    };
    let card = [STATUS_BALANCE, STATUS_SPEAR]
        .into_iter()
        .filter_map(|id| statuses.get(id).map(|status| status.param as u8))
        .max()
        .unwrap_or_default();
    (card, statuses.get(STATUS_DIVINATION).is_some())
}

pub(in crate::server) fn incoming_heal_multiplier(actor: &NetworkedActor) -> f64 {
    if actor
        .status_effects()
        .is_some_and(|s| s.get(STATUS_ARROW).is_some())
    {
        1.1
    } else {
        1.0
    }
}

pub(in crate::server) fn mitigation_multiplier(actor: &NetworkedActor) -> f64 {
    let Some(statuses) = actor.status_effects() else {
        return 1.0;
    };
    [
        STATUS_BOLE,
        STATUS_EXALTATION,
        STATUS_SUN_SIGN,
        STATUS_COLLECTIVE,
    ]
    .into_iter()
    .filter(|id| statuses.get(*id).is_some())
    .fold(1.0, |multiplier, _| multiplier * 0.9)
}

fn gain(id: u16, param: u16, duration: f32, source: bool) -> TargetEffect {
    TargetEffect(if source {
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

fn heal(amount: u32) -> TargetEffect {
    TargetEffect(TargetEffectKind::Heal {
        unk1: [0; 5],
        amount,
    })
}

fn damage(amount: u32) -> TargetEffect {
    TargetEffect(TargetEffectKind::Damage {
        damage_kind: Default::default(),
        damage_type: DamageType::Magic,
        damage_element: DamageElement::Unaspected,
        bonus_percent: 0,
        unk3: 0,
        unk4: 0,
        amount,
    })
}

fn direct_tick(builder: &mut EffectsBuilder, id: u16, duration: f32, potency: u16, kind: TickKind) {
    builder.effects.push(gain(id, 0, duration, false));
    builder.tick_actions.push(TickAction {
        effect_id: id,
        param: 0,
        duration,
        potency,
        kind,
        on_self: false,
    });
}

fn direct_barrier(builder: &mut EffectsBuilder, id: u16, amount: u32) {
    builder.effects.push(gain(id, 0, 30.0, false));
    builder.barrier_actions.push(BarrierAction {
        effect_id: id,
        param: 0,
        duration: 30.0,
        amount,
        on_self: false,
    });
}

fn spell_heal_amount(caster: &NetworkedActor, parameters: &BaseParameters, potency: u32) -> u32 {
    let amount = parameters.calc_heal_amount(potency);
    if caster
        .status_effects()
        .is_some_and(|s| s.get(STATUS_NEUTRAL).is_some())
    {
        amount.saturating_mul(120) / 100
    } else {
        amount
    }
}

fn dignity_potency(hp: u32, max_hp: u32) -> u32 {
    let missing_percent = 100u64.saturating_sub(u64::from(hp) * 100 / u64::from(max_hp.max(1)));
    400 + (missing_percent.min(70) * 500 / 70) as u32
}

pub(in crate::server) fn action_effects(
    action: u32,
    caster: &NetworkedActor,
    target: Option<&NetworkedActor>,
    target_role: u8,
) -> Option<EffectsBuilder> {
    let NetworkedActor::Player {
        parameters,
        status_effects,
        ..
    } = caster
    else {
        return None;
    };
    let level = caster.get_common_spawn().level;
    let mut builder = EffectsBuilder::default();
    let effects = &mut builder.effects;
    match action {
        3596 | 3598 | 7442 | 16555 | 25871 | 3615 | 25872 | ORACLE => {
            let potency = match action {
                3596 => 150,
                3598 => 160,
                7442 => 190,
                16555 => 230,
                25871 => 270,
                3615 => 120,
                25872 => 140,
                _ => 860,
            };
            effects.push(damage(parameters.calc_magical_damage(potency)));
        }
        3599 => direct_tick(&mut builder, 838, 18.0, 50, TickKind::DamageMagic),
        3608 => direct_tick(&mut builder, 843, 30.0, 60, TickKind::DamageMagic),
        16554 => direct_tick(&mut builder, 1881, 30.0, 70, TickKind::DamageMagic),
        BENEFIC | BENEFIC_II | ASPECTED_BENEFIC => {
            let potency = match action {
                BENEFIC => {
                    if level >= 85 {
                        500
                    } else {
                        450
                    }
                }
                BENEFIC_II => {
                    if level >= 85 {
                        800
                    } else {
                        700
                    }
                }
                _ => 250,
            };
            let forced_critical =
                action == BENEFIC_II && status_effects.get(STATUS_BENEFIC).is_some();
            let amount = if forced_critical {
                let amount = parameters.calc_heal_amount_with_critical(potency, true);
                if status_effects.get(STATUS_NEUTRAL).is_some() {
                    amount.saturating_mul(120) / 100
                } else {
                    amount
                }
            } else {
                spell_heal_amount(caster, parameters, potency)
            };
            effects.push(heal(amount));
            if action == BENEFIC && level >= 36 && fastrand::u8(0..100) < 15 {
                effects.push(gain(STATUS_BENEFIC, 0, 15.0, true));
            }
            if action == ASPECTED_BENEFIC {
                direct_tick(
                    &mut builder,
                    STATUS_ASPECTED_BENEFIC,
                    15.0,
                    250,
                    TickKind::Heal,
                );
                if status_effects.get(STATUS_NEUTRAL).is_some() {
                    let multiplier = target.map_or(1.0, incoming_heal_multiplier);
                    direct_barrier(
                        &mut builder,
                        STATUS_NEUTRAL_BARRIER,
                        (f64::from(amount) * multiplier * 2.5) as u32,
                    );
                }
            }
        }
        DIGNITY => {
            let potency = target
                .and_then(NetworkedActor::common_spawn)
                .map_or(400, |spawn| {
                    dignity_potency(spawn.health_points, spawn.max_health_points)
                });
            effects.push(heal(parameters.calc_heal_amount(potency)));
        }
        INTERSECTION => {
            let amount = parameters.calc_heal_amount(200);
            effects.push(heal(amount));
            let multiplier = target.map_or(1.0, incoming_heal_multiplier);
            direct_barrier(
                &mut builder,
                STATUS_INTERSECTION,
                (f64::from(amount) * multiplier * 2.0) as u32,
            );
        }
        LIGHTSPEED => effects.push(gain(STATUS_LIGHTSPEED, 0, 15.0, true)),
        SYNASTRY => {
            effects.push(gain(STATUS_SYNASTRY, 0, 20.0, false));
            effects.push(gain(STATUS_SYNASTRY_SELF, 0, 20.0, true));
        }
        ASTRAL_DRAW | UMBRAL_DRAW => {
            let amount = caster.get_common_spawn().max_resource_points / 5;
            effects.push(TargetEffect(TargetEffectKind::MpGain {
                params: [0; 5],
                amount,
            }));
            effects.push(TargetEffect(TargetEffectKind::Unknown {
                magic: 62,
                param0: u8::from(action == UMBRAL_DRAW),
                param1: 0,
                param2: 0,
                param3: 0,
                param4: 0x80,
                value: 320,
            }));
        }
        BALANCE | SPEAR => {
            let melee_or_tank = matches!(target_role, 1 | 2);
            let bonus = if melee_or_tank == (action == BALANCE) {
                6
            } else {
                3
            };
            let status = if action == BALANCE {
                STATUS_BALANCE
            } else {
                STATUS_SPEAR
            };
            effects.push(gain(status, bonus, 15.0, false));
        }
        ARROW => effects.push(gain(STATUS_ARROW, 0, 15.0, false)),
        BOLE => effects.push(gain(STATUS_BOLE, 0, 15.0, false)),
        SPIRE => direct_barrier(&mut builder, STATUS_SPIRE, parameters.calc_heal_amount(400)),
        EWER => direct_tick(&mut builder, STATUS_EWER, 15.0, 200, TickKind::Heal),
        EXALTATION => effects.push(gain(STATUS_EXALTATION, 0, 8.0, false)),
        NEUTRAL_SECT => {
            effects.push(gain(STATUS_NEUTRAL, 20, 20.0, true));
            if level >= 100 {
                effects.push(gain(STATUS_SUNTOUCHED, 0, 30.0, true));
            }
        }
        STELLAR_DETONATION => effects.push(TargetEffect(TargetEffectKind::Teleport {
            unk: [0; 5],
            territory: 0,
        })),
        HELIOS | ASPECTED_HELIOS | HELIOS_CONJUNCTION | COLLECTIVE | OPPOSITION | DIVINATION
        | SUN_SIGN | HOROSCOPE | HOROSCOPE_HEAL | MACROCOSMOS | MICROCOSMOS | EARTHLY_STAR
        | LORD | LADY => {}
        _ => return None,
    }
    Some(builder)
}

pub(super) fn update_procs(action: u32, actor: &mut NetworkedActor) {
    let level = actor.get_common_spawn().level;
    let NetworkedActor::Player {
        status_effects,
        combat_state,
        ..
    } = actor
    else {
        return;
    };
    let job = &mut combat_state.astrologian;
    if action != COLLECTIVE && job.collective.take().is_some() {
        status_effects.remove(STATUS_COLLECTIVE_SELF);
    }
    match action {
        DIVINATION if level >= 92 => {
            job.oracle_until = Some(Instant::now() + Duration::from_secs(30))
        }
        NEUTRAL_SECT if level >= 100 => {
            job.sun_sign_until = Some(Instant::now() + Duration::from_secs(30))
        }
        ORACLE => {
            job.oracle_until = None;
            status_effects.remove(STATUS_DIVINING);
        }
        SUN_SIGN => {
            job.sun_sign_until = None;
            status_effects.remove(STATUS_SUNTOUCHED);
        }
        BENEFIC_II => status_effects.remove(STATUS_BENEFIC),
        _ => {}
    }
}

#[derive(Debug, Clone, Copy)]
pub(super) struct EarthlyStar {
    center: Position,
    placed_at: Instant,
    pub(super) object: Option<ObjectId>,
}

pub(super) fn deactivate(actor: &mut NetworkedActor) -> Option<ObjectId> {
    let NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    } = actor
    else {
        return None;
    };
    let state = std::mem::take(&mut combat_state.astrologian);
    for status in [
        STATUS_LIGHTSPEED,
        STATUS_DIVINING,
        STATUS_NEUTRAL,
        STATUS_SUNTOUCHED,
        STATUS_EARTHLY,
        STATUS_GIANT,
        STATUS_COLLECTIVE_SELF,
        STATUS_SYNASTRY_SELF,
    ] {
        status_effects.remove(status);
    }
    state.star.and_then(|star| star.object)
}

pub(in crate::server) fn finish_earthly_star_action(
    network: &mut NetworkState,
    instance: &mut Instance,
    owner: ObjectId,
    action: u32,
) {
    match action {
        EARTHLY_STAR => spawn_earthly_star_visual(network, instance, owner),
        STELLAR_DETONATION => detonate_earthly_star(network, instance, owner, Instant::now()),
        _ => {}
    }
}

fn spawn_earthly_star_visual(network: &mut NetworkState, instance: &mut Instance, owner: ObjectId) {
    let id = loop {
        let id = ObjectId(fastrand::u32(0x4000_0000..0x5000_0000));
        if instance.find_actor(id).is_none() {
            break id;
        }
    };
    let Some(NetworkedActor::Player {
        spawn,
        combat_state,
        ..
    }) = instance.find_actor_mut(owner)
    else {
        return;
    };
    let Some(star) = &mut combat_state.astrologian.star else {
        return;
    };
    if star.object.is_some() {
        return;
    }
    let mut visual = SpawnNpc::default();
    visual.common.base_id = 7245;
    visual.common.name_id = 6565;
    visual.common.owner_id = owner;
    visual.common.pet_id = EARTHLY_STAR_PET_ID;
    visual.common.object_kind = ObjectKind::BattleNpc(BattleNpcSubKind::Pet);
    visual.common.model_chara = 2023;
    visual.common.display_flags = DisplayFlag::UNK1 | DisplayFlag::UNK2;
    visual.character_data_flags = CharacterDataFlag::from_bits_retain(1);
    visual.common.level = spawn.common.level;
    visual.common.health_points = spawn.common.max_health_points.max(1);
    visual.common.max_health_points = visual.common.health_points;
    visual.common.max_resource_points = spawn.common.max_resource_points;
    visual.common.resource_points = visual.common.max_resource_points;
    visual.common.position = star.center;
    star.object = Some(id);
    instance.insert_npc(id, visual);
    if let Some(NetworkedActor::Npc {
        targetable,
        ai_paused,
        ..
    }) = instance.find_actor_mut(id)
    {
        *targetable = false;
        *ai_paused = true;
    }
    for category in [
        ActorControlCategory::SetupPet {
            owner_id: owner,
            pet_id: EARTHLY_STAR_PET_ID,
            pet_actor_id: id,
            dismiss: 1,
            storage_target: 1,
        },
        ActorControlCategory::SetPetParameters {
            pet_id: EARTHLY_STAR_PET_ID,
            pet_stance: 2,
            pet_guard_mode: 0,
            pet_auto_mode: 0,
            mount_state: 0,
        },
    ] {
        network.send_to_by_actor_id(
            owner,
            FromServer::ActorControlSelf(category),
            DestinationNetwork::ZoneClients,
        );
    }
    network.spawn_inserted_actor_in_range(instance, id);
}

fn detonate_earthly_star(
    network: &mut NetworkState,
    instance: &mut Instance,
    owner: ObjectId,
    now: Instant,
) {
    let Some(NetworkedActor::Player {
        parameters,
        status_effects,
        combat_state,
        ..
    }) = instance.find_actor_mut(owner)
    else {
        return;
    };
    let Some(star) = combat_state.astrologian.star.take() else {
        return;
    };
    let parameters = parameters.clone();
    status_effects.remove(STATUS_EARTHLY);
    status_effects.remove(STATUS_GIANT);

    let mature = now.saturating_duration_since(star.placed_at) >= Duration::from_secs(10);
    let (action, potency, cure_potency) = if mature {
        (STELLAR_EXPLOSION, 310, 720)
    } else {
        (STELLAR_BURST, 205, 540)
    };
    let mut result = AreaResult::new(star.center);
    for recipient in party_in_range(network, instance, owner, star.center.0, 20.0) {
        let actor = instance.find_actor_mut(recipient).unwrap();
        result.push(
            recipient,
            [heal(apply_heal(
                actor,
                parameters.calc_heal_amount(cure_potency),
            ))],
        );
    }
    result.apply_damage(
        instance,
        owner,
        &parameters,
        AreaDamage {
            potency,
            falloff: 0,
            radius: 20.0,
            damage_type: DamageType::Magic,
        },
    );
    let visual = star.object.filter(|&id| instance.find_actor(id).is_some());
    crate::server::action::send_area_action_result(
        network,
        instance,
        visual.unwrap_or(owner),
        action,
        ActionRequest::default(),
        result,
    );
    if let Some(id) = visual {
        network.remove_actor(instance, id);
    }
    send_effects_list_with(network, instance, owner);
}

#[derive(Debug, Clone, Copy)]
pub(in crate::server) struct DelayedHeal {
    source: ObjectId,
    status: u16,
    expires_at: Instant,
    base_heal: u32,
    upgraded_heal: u32,
    damage_taken: u32,
}

impl DelayedHeal {
    fn has_status(&self, statuses: &StatusEffects) -> bool {
        statuses
            .get(self.status)
            .is_some_and(|status| status.source_actor_id == self.source)
    }

    pub(in crate::server) fn record_damage(&mut self, amount: u32, now: Instant) {
        if self.status == STATUS_MACROCOSMOS && now < self.expires_at {
            self.damage_taken = self.damage_taken.saturating_add(amount);
        }
    }

    fn amount(self) -> u32 {
        self.base_heal.saturating_add(self.damage_taken / 2)
    }
}

fn change_hp(actor: &mut NetworkedActor, amount: u32) -> u32 {
    let common = actor.get_common_spawn_mut();
    if common.health_points == 0 {
        return 0;
    }
    common.health_points = common
        .health_points
        .saturating_add(amount)
        .min(common.max_health_points);
    amount
}

fn apply_heal(actor: &mut NetworkedActor, base: u32) -> u32 {
    let multiplier = white_mage::incoming_heal_multiplier(Some(actor));
    change_hp(actor, (f64::from(base) * multiplier) as u32)
}

fn pending_heal(actor: &mut NetworkedActor, pending: DelayedHeal, duration: f32) {
    if let NetworkedActor::Player {
        status_effects,
        combat_state,
        ..
    } = actor
    {
        status_effects.add_with_source(pending.status, 0, duration, pending.source);
        combat_state
            .astrologian_heals
            .retain(|old| old.status != pending.status);
        combat_state.astrologian_heals.push(pending);
    }
}

fn take_pending(
    actor: &mut NetworkedActor,
    source: ObjectId,
    statuses: &[u16],
) -> Option<DelayedHeal> {
    let NetworkedActor::Player {
        status_effects,
        combat_state,
        ..
    } = actor
    else {
        return None;
    };
    let now = Instant::now();
    let pos = combat_state.astrologian_heals.iter().position(|pending| {
        pending.source == source
            && statuses.contains(&pending.status)
            && pending.expires_at > now
            && pending.has_status(status_effects)
    })?;
    let pending = combat_state.astrologian_heals.remove(pos);
    status_effects.remove(pending.status);
    Some(pending)
}

fn party_status(
    actor: &mut NetworkedActor,
    caster: ObjectId,
    id: u16,
    duration: f32,
    effects: &mut Vec<TargetEffect>,
) {
    actor
        .status_effects_mut()
        .unwrap()
        .add_with_source(id, 0, duration, caster);
    effects.push(gain(id, 0, duration, false));
}

fn party_regen(
    actor: &mut NetworkedActor,
    caster: ObjectId,
    id: u16,
    potency: u16,
    effects: &mut Vec<TargetEffect>,
) {
    actor.status_effects_mut().unwrap().add_tick(
        id,
        0,
        15.0,
        TickEffectKind::Heal,
        potency,
        None,
        caster,
    );
    effects.push(gain(id, 0, 15.0, false));
}

pub(in crate::server) fn apply_support_action(
    network: &mut NetworkState,
    instance: &mut Instance,
    caster: ObjectId,
    target: ObjectId,
    action: u32,
    ground: Option<Position>,
    direct_heal: u32,
) -> Option<AreaResult> {
    let radius = match action {
        DIVINATION | SUN_SIGN | HOROSCOPE | HOROSCOPE_HEAL | COLLECTIVE => 30.0,
        HELIOS | ASPECTED_HELIOS | HELIOS_CONJUNCTION | OPPOSITION | LADY | LORD | MACROCOSMOS
        | MICROCOSMOS | EARTHLY_STAR => 20.0,
        EXALTATION | BENEFIC | BENEFIC_II | ASPECTED_BENEFIC => 0.0,
        _ => return None,
    };
    let now = Instant::now();
    let actor = instance.find_actor_mut(caster)?;
    let mut center = actor.position();
    let rotation = actor.rotation();
    let NetworkedActor::Player {
        parameters,
        status_effects,
        combat_state,
        ..
    } = actor
    else {
        return None;
    };
    let parameters = parameters.clone();
    let neutral = status_effects.get(STATUS_NEUTRAL).is_some();
    let synastry = status_effects.get(STATUS_SYNASTRY_SELF).is_some();
    let job = &mut combat_state.astrologian;
    let mut result = AreaResult::new(center);

    match action {
        EARTHLY_STAR => {
            center = ground
                .filter(|point| {
                    point.0.is_finite() && point.0.distance_squared(center.0) <= 30.0 * 30.0
                })
                .unwrap_or(center);
            job.star = Some(EarthlyStar {
                center,
                placed_at: now,
                object: None,
            });
            status_effects.add_with_source(STATUS_EARTHLY, 0, 10.0, caster);
            result.center = center;
            let mut status = gain(STATUS_EARTHLY, 0, 10.0, true);
            if let TargetEffectKind::GainEffectSelf { unk3, .. } = &mut status.0 {
                *unk3 = 0x80;
            }
            result.push(
                caster,
                vec![
                    status,
                    TargetEffect(TargetEffectKind::SummonPet {
                        unk: [0, 0, 0, 0, 0x80, 157, 0],
                    }),
                ],
            );
            return Some(result);
        }
        HOROSCOPE => job.horoscope_until = Some(now + Duration::from_secs(10)),
        HOROSCOPE_HEAL => job.horoscope_until = None,
        MACROCOSMOS => job.macrocosmos_until = Some(now + Duration::from_secs(15)),
        MICROCOSMOS => job.macrocosmos_until = None,
        COLLECTIVE => {
            job.collective = Some((center, rotation, now + Duration::from_secs(18)));
            status_effects.add_with_source(STATUS_COLLECTIVE_SELF, 0, 18.0, caster);
        }
        EXALTATION => {
            if let Some(actor) = instance.find_actor_mut(target) {
                pending_heal(
                    actor,
                    DelayedHeal {
                        source: caster,
                        status: STATUS_EXALTATION,
                        expires_at: now + Duration::from_secs(8),
                        base_heal: parameters.calc_heal_amount(500),
                        upgraded_heal: 0,
                        damage_taken: 0,
                    },
                    8.0,
                );
            }
            return None;
        }
        BENEFIC | BENEFIC_II | ASPECTED_BENEFIC => {
            if synastry && direct_heal > 0 {
                for id in party_in_range(network, instance, caster, center.0, 30.0) {
                    let actor = instance.find_actor_mut(id).unwrap();
                    if actor
                        .status_effects()
                        .unwrap()
                        .get(STATUS_SYNASTRY)
                        .is_some_and(|status| status.source_actor_id == caster)
                    {
                        let amount = change_hp(actor, direct_heal.saturating_mul(40) / 100);
                        white_mage::send_hp_mp(network, instance, id);
                        white_mage::send_tick_heal_popup(
                            network,
                            instance,
                            id,
                            STATUS_SYNASTRY.into(),
                            amount,
                            caster,
                        );
                    }
                }
            }
            return None;
        }
        _ => {}
    }

    let mut horoscope_upgraded = false;
    if action != LORD {
        for id in party_in_range(network, instance, caster, center.0, radius) {
            let actor = instance.find_actor_mut(id).unwrap();
            let mut effects = Vec::new();
            match action {
                HELIOS | ASPECTED_HELIOS | HELIOS_CONJUNCTION => {
                    let base =
                        parameters.calc_heal_amount(if action == HELIOS { 400 } else { 250 });
                    let base = if neutral {
                        base.saturating_mul(120) / 100
                    } else {
                        base
                    };
                    let amount = apply_heal(actor, base);
                    effects.push(heal(amount));
                    if action != HELIOS {
                        let (status, potency) = if action == ASPECTED_HELIOS {
                            (STATUS_ASPECTED_HELIOS, 150)
                        } else {
                            (STATUS_CONJUNCTION, 175)
                        };
                        party_regen(actor, caster, status, potency, &mut effects);
                        if neutral {
                            let barrier = actor.get_common_spawn().max_health_points;
                            actor.status_effects_mut().unwrap().add_barrier(
                                STATUS_NEUTRAL_BARRIER,
                                0,
                                30.0,
                                amount.saturating_mul(125) / 100,
                                caster,
                                barrier,
                            );
                            effects.push(gain(STATUS_NEUTRAL_BARRIER, 0, 30.0, false));
                        }
                    }
                    // Helios and its enhanced variants upgrade each existing caster's Horoscope.
                    let NetworkedActor::Player {
                        status_effects,
                        combat_state,
                        ..
                    } = actor
                    else {
                        unreachable!()
                    };
                    for pending in &mut combat_state.astrologian_heals {
                        if pending.status == STATUS_HOROSCOPE
                            && pending.expires_at > now
                            && pending.has_status(status_effects)
                        {
                            status_effects.remove(STATUS_HOROSCOPE);
                            pending.status = STATUS_HOROSCOPE_HELIOS;
                            pending.base_heal = pending.upgraded_heal;
                            pending.expires_at = now + Duration::from_secs(30);
                            status_effects.add_with_source(
                                STATUS_HOROSCOPE_HELIOS,
                                0,
                                30.0,
                                pending.source,
                            );
                            effects.push(gain(STATUS_HOROSCOPE_HELIOS, 0, 30.0, false));
                            horoscope_upgraded |= pending.source == caster;
                        }
                    }
                }
                OPPOSITION | LADY => {
                    let potency = if action == LADY { 400 } else { 200 };
                    effects.push(heal(apply_heal(
                        actor,
                        parameters.calc_heal_amount(potency),
                    )));
                    if action == OPPOSITION {
                        party_regen(actor, caster, STATUS_OPPOSITION, 100, &mut effects);
                    }
                }
                DIVINATION => {
                    party_status(actor, caster, STATUS_DIVINATION, 20.0, &mut effects);
                    if id == caster && actor.get_common_spawn().level >= 92 {
                        party_status(actor, caster, STATUS_DIVINING, 30.0, &mut effects);
                    }
                }
                SUN_SIGN => party_status(actor, caster, STATUS_SUN_SIGN, 15.0, &mut effects),
                COLLECTIVE => {
                    party_status(actor, caster, STATUS_COLLECTIVE, 10.0, &mut effects);
                    if actor.position().0.distance(center.0) <= 8.0 {
                        party_regen(actor, caster, STATUS_WHEEL, 100, &mut effects);
                    }
                }
                HOROSCOPE | MACROCOSMOS => {
                    let (status, duration) = if action == HOROSCOPE {
                        (STATUS_HOROSCOPE, 10)
                    } else {
                        (STATUS_MACROCOSMOS, 15)
                    };
                    pending_heal(
                        actor,
                        DelayedHeal {
                            source: caster,
                            status,
                            expires_at: now + Duration::from_secs(duration),
                            base_heal: parameters.calc_heal_amount(200),
                            upgraded_heal: if action == HOROSCOPE {
                                parameters.calc_heal_amount(400)
                            } else {
                                0
                            },
                            damage_taken: 0,
                        },
                        duration as f32,
                    );
                    effects.push(gain(status, 0, duration as f32, false));
                }
                HOROSCOPE_HEAL | MICROCOSMOS => {
                    let statuses: &[u16] = if action == HOROSCOPE_HEAL {
                        &[STATUS_HOROSCOPE, STATUS_HOROSCOPE_HELIOS]
                    } else {
                        &[STATUS_MACROCOSMOS]
                    };
                    if let Some(pending) = take_pending(actor, caster, statuses) {
                        effects.push(heal(apply_heal(actor, pending.amount())));
                    }
                }
                _ => {}
            }
            if !effects.is_empty() {
                result.push(id, effects);
            }
        }
    }
    if horoscope_upgraded
        && let Some(NetworkedActor::Player { combat_state, .. }) = instance.find_actor_mut(caster)
    {
        combat_state.astrologian.horoscope_until = Some(now + Duration::from_secs(30));
    }
    match action {
        LORD => result.apply_damage(
            instance,
            caster,
            &parameters,
            AreaDamage {
                potency: 400,
                falloff: 0,
                radius,
                damage_type: DamageType::Magic,
            },
        ),
        MACROCOSMOS => result.apply_damage(
            instance,
            caster,
            &parameters,
            AreaDamage {
                potency: 270,
                falloff: 40,
                radius,
                damage_type: DamageType::Magic,
            },
        ),
        _ => {}
    }
    Some(result)
}

pub(in crate::server) fn refresh_delayed_actions(
    network: &mut NetworkState,
    instance: &mut Instance,
) {
    let now = Instant::now();
    let mut heal_popups = Vec::new();
    let mut stars = Vec::new();
    let mut changed = Vec::new();
    let mut collectives = Vec::new();
    for (&id, actor) in &mut instance.actors {
        let position = actor.position().0;
        let rotation = actor.rotation();
        let NetworkedActor::Player {
            combat_state,
            status_effects,
            spawn,
            ..
        } = actor
        else {
            continue;
        };
        if let Some((center, start_rotation, until)) = combat_state.astrologian.collective {
            if now < until
                && spawn.common.health_points > 0
                && position.distance_squared(center.0) < 0.01
                && (rotation - start_rotation).cos() > 0.9999
            {
                collectives.push((id, center.0));
            } else {
                combat_state.astrologian.collective = None;
                status_effects.remove(STATUS_COLLECTIVE_SELF);
                changed.push(id);
            }
        }
        let mut expired = Vec::new();
        combat_state.astrologian_heals.retain(|pending| {
            if spawn.common.health_points == 0 || !pending.has_status(status_effects) {
                return false;
            }
            if now >= pending.expires_at {
                expired.push(*pending);
                return false;
            }
            true
        });
        for pending in expired {
            status_effects.remove(pending.status);
            heal_popups.push((id, pending));
        }
        if let Some(star) = combat_state.astrologian.star {
            let age = now.duration_since(star.placed_at);
            if age >= Duration::from_secs(20) {
                stars.push(id);
            } else if age >= Duration::from_secs(10) && status_effects.get(STATUS_GIANT).is_none() {
                status_effects.remove(STATUS_EARTHLY);
                status_effects.add_with_source(
                    STATUS_GIANT,
                    0,
                    (Duration::from_secs(20) - age).as_secs_f32(),
                    id,
                );
                changed.push(id);
            }
        }
    }
    for (id, pending) in heal_popups {
        let Some(actor) = instance.find_actor_mut(id) else {
            continue;
        };
        let amount = apply_heal(actor, pending.amount());
        white_mage::send_hp_mp(network, instance, id);
        send_effects_list_with(network, instance, id);
        if amount > 0 {
            white_mage::send_tick_heal_popup(
                network,
                instance,
                id,
                pending.status.into(),
                amount,
                pending.source,
            );
        }
    }
    for id in changed {
        send_effects_list_with(network, instance, id);
    }
    for (caster, center) in collectives {
        for id in party_in_range(network, instance, caster, center, 8.0) {
            let statuses = instance
                .find_actor_mut(id)
                .unwrap()
                .status_effects_mut()
                .unwrap();
            if statuses
                .get(STATUS_WHEEL)
                .is_none_or(|effect| effect.duration <= 12.0)
            {
                statuses.add_tick(
                    STATUS_WHEEL,
                    0,
                    15.0,
                    TickEffectKind::Heal,
                    100,
                    None,
                    caster,
                );
                send_effects_list_with(network, instance, id);
            }
        }
    }
    for caster in stars {
        detonate_earthly_star(network, instance, caster, now);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    #[ignore = "需要从工作区根目录读取配置中的国服 SqPack"]
    async fn cn_earthly_star_spawns_and_sends_manual_burst_before_removal() {
        use std::{io::Cursor, sync::Arc};

        use binrw::BinRead;
        use kawari::ipc::zone::{
            ActionType, ClientZoneIpcData, ClientZoneIpcSegment, ServerZoneIpcData,
        };
        use parking_lot::Mutex;

        use crate::{
            ClientHandle, ClientId, ToServer,
            common::SpawnKind,
            lua::KawariLua,
            server::{WorldServer, action::handle_action_messages},
        };

        let owner = ObjectId(0x1000_0001);
        let client = ClientId::default();
        let mut instance = Instance::default();
        instance.insert_empty_actor(owner);
        let NetworkedActor::Player {
            spawn, parameters, ..
        } = instance.find_actor_mut(owner).unwrap()
        else {
            unreachable!();
        };
        spawn.common.class_job = CLASSJOB_ASTROLOGIAN;
        spawn.common.level = 100;
        spawn.common.health_points = 1000;
        spawn.common.max_health_points = 20000;
        *parameters = BaseParameters {
            classjob_id: CLASSJOB_ASTROLOGIAN,
            level: 100,
            mind: 1000,
            magic_damage: 100,
            ..Default::default()
        };

        let world = Arc::new(Mutex::new(WorldServer {
            instances: vec![instance],
            ..Default::default()
        }));
        let network = Arc::new(Mutex::new(NetworkState::default()));
        let (sender, mut messages) = tokio::sync::mpsc::channel(32);
        network.lock().clients.insert(
            client,
            (
                ClientHandle {
                    id: client,
                    channel: sender,
                    actor_id: owner,
                    content_id: 0,
                    account_id: 0,
                },
                Default::default(),
            ),
        );
        let game_data = Arc::new(Mutex::new(GameData::new()));
        let mut lua = KawariLua::new();
        lua.init(game_data.clone()).unwrap();
        let lua = Arc::new(Mutex::new(lua));

        let mut wire = [0_u8; 40];
        wire[..4].copy_from_slice(&[0x14, 0, 0x6f, 0x02]);
        wire[16..20].copy_from_slice(&EARTHLY_STAR.to_le_bytes());
        wire[21] = ActionType::Action as u8;
        wire[22] = 3;
        wire[28..32].copy_from_slice(&5.0_f32.to_le_bytes());
        let ipc = ClientZoneIpcSegment::read_le_args(&mut Cursor::new(wire), (&24,)).unwrap();
        let ClientZoneIpcData::ActionRequestGroundTargeted(ground) = ipc.data else {
            panic!("地星请求未解码");
        };
        assert!(handle_action_messages(
            world.clone(),
            game_data.clone(),
            network.clone(),
            lua.clone(),
            &ToServer::ActionRequestGroundTargeted(client, owner, ground),
        ));

        let star = tokio::time::timeout(Duration::from_secs(3), async {
            let mut placed = false;
            loop {
                match messages.recv().await.unwrap() {
                    FromServer::PacketSegment(packet, source) => {
                        if let ServerZoneIpcData::ActionEffect8(result) = packet.data {
                            assert_eq!((source, result.header.action_id), (owner, EARTHLY_STAR));
                            assert_eq!(result.header.source_sequence, 3);
                            placed = true;
                        }
                    }
                    FromServer::ActorSpawn(id, SpawnKind::Npc(spawn)) => {
                        assert!(placed);
                        assert_eq!(spawn.common.pet_id, EARTHLY_STAR_PET_ID);
                        assert_eq!(spawn.common.model_chara, 2023);
                        assert_eq!(spawn.common.position.0.x, 5.0);
                        break id;
                    }
                    _ => {}
                }
            }
        })
        .await
        .expect("未收到地星生成");

        let request = ActionRequest {
            action_id: STELLAR_DETONATION,
            action_type: ActionType::Action,
            sequence: 4,
            ..Default::default()
        };
        assert!(handle_action_messages(
            world.clone(),
            game_data,
            network,
            lua,
            &ToServer::ActionRequest(client, owner, request),
        ));
        tokio::time::timeout(Duration::from_secs(3), async {
            let mut confirmed = false;
            let mut burst = false;
            loop {
                match messages.recv().await.unwrap() {
                    FromServer::PacketSegment(packet, source) => match packet.data {
                        ServerZoneIpcData::ActionEffect1(result) if result.action_id == STELLAR_DETONATION => {
                            assert_eq!(source, owner);
                            assert_eq!(result.source_sequence, 4);
                            confirmed = true;
                        }
                        ServerZoneIpcData::ActionEffect8(result) if result.header.action_id == STELLAR_BURST => {
                            assert!(confirmed);
                            assert_eq!(source, star);
                            assert!(matches!(result.effects[0][0].0, TargetEffectKind::Heal { amount, .. } if amount > 0));
                            burst = true;
                        }
                        _ => {}
                    },
                    FromServer::DeleteActor(id, _) => {
                        assert_eq!(id, star);
                        assert!(burst);
                        break;
                    }
                    _ => {}
                }
            }
        }).await.expect("未收到地星爆发和移除");
    }

    #[test]
    fn essential_dignity_reaches_its_cap_at_thirty_percent() {
        assert_eq!(dignity_potency(100, 100), 400);
        assert_eq!(dignity_potency(65, 100), 650);
        assert_eq!(dignity_potency(30, 100), 900);
        assert_eq!(dignity_potency(10, 100), 900);
    }

    #[test]
    fn macrocosmos_is_consumed_only_by_its_owner_and_counts_half_of_damage() {
        let target = ObjectId(1);
        let caster = ObjectId(2);
        let mut instance = Instance::default();
        instance.insert_empty_actor(target);
        let actor = instance.find_actor_mut(target).unwrap();
        let common = actor.get_common_spawn_mut();
        common.health_points = 8000;
        common.max_health_points = 10000;
        pending_heal(
            actor,
            DelayedHeal {
                source: caster,
                status: STATUS_MACROCOSMOS,
                expires_at: Instant::now() + Duration::from_secs(15),
                base_heal: 1000,
                upgraded_heal: 0,
                damage_taken: 0,
            },
            15.0,
        );
        actor.apply_damage(2000);
        assert!(take_pending(actor, ObjectId(3), &[STATUS_MACROCOSMOS]).is_none());
        let heal = take_pending(actor, caster, &[STATUS_MACROCOSMOS]).unwrap();
        assert_eq!(heal.amount(), 2000);
        apply_heal(actor, heal.amount());
        assert_eq!(actor.get_common_spawn().health_points, 8000);
        assert!(take_pending(actor, caster, &[STATUS_MACROCOSMOS]).is_none());
    }

    #[test]
    fn cleared_horoscope_and_macrocosmos_cannot_be_triggered_or_upgraded() {
        let caster = ObjectId(1);
        let mut instance = Instance::default();
        let mut network = NetworkState::default();
        instance.insert_empty_actor(caster);
        let actor = instance.find_actor_mut(caster).unwrap();
        actor.get_common_spawn_mut().health_points = 8000;
        actor.get_common_spawn_mut().max_health_points = 10000;
        for status in [STATUS_HOROSCOPE, STATUS_MACROCOSMOS] {
            pending_heal(
                actor,
                DelayedHeal {
                    source: caster,
                    status,
                    expires_at: Instant::now() + Duration::from_secs(15),
                    base_heal: 1000,
                    upgraded_heal: 2000,
                    damage_taken: 0,
                },
                15.0,
            );
            actor.status_effects_mut().unwrap().remove(status);
            assert!(take_pending(actor, caster, &[status]).is_none());
        }
        apply_support_action(
            &mut network,
            &mut instance,
            caster,
            caster,
            HELIOS_CONJUNCTION,
            None,
            0,
        );
        let actor = instance.find_actor(caster).unwrap();
        assert!(
            actor
                .status_effects()
                .unwrap()
                .get(STATUS_HOROSCOPE_HELIOS)
                .is_none()
        );
        refresh_delayed_actions(&mut network, &mut instance);
        let NetworkedActor::Player { combat_state, .. } = instance.find_actor(caster).unwrap()
        else {
            unreachable!();
        };
        assert!(combat_state.astrologian_heals.is_empty());
    }

    #[test]
    fn expired_macrocosmos_heals_once_through_the_natural_expiry_path() {
        let caster = ObjectId(1);
        let mut instance = Instance::default();
        let mut network = NetworkState::default();
        instance.insert_empty_actor(caster);
        let actor = instance.find_actor_mut(caster).unwrap();
        actor.get_common_spawn_mut().health_points = 8000;
        actor.get_common_spawn_mut().max_health_points = 10000;
        pending_heal(
            actor,
            DelayedHeal {
                source: caster,
                status: STATUS_MACROCOSMOS,
                expires_at: Instant::now(),
                base_heal: 1000,
                upgraded_heal: 0,
                damage_taken: 0,
            },
            15.0,
        );
        assert!(take_pending(actor, caster, &[STATUS_MACROCOSMOS]).is_none());
        for _ in 0..2 {
            refresh_delayed_actions(&mut network, &mut instance);
            let actor = instance.find_actor(caster).unwrap();
            assert_eq!(actor.get_common_spawn().health_points, 9000);
            assert!(
                actor
                    .status_effects()
                    .unwrap()
                    .get(STATUS_MACROCOSMOS)
                    .is_none()
            );
        }
    }
}
