use super::super::{
    native::{self, AreaAttack, Shape, mp, status},
    scholar, white_mage,
};
use super::*;
use crate::{
    TickDamageSnapshot, TickEffectKind,
    server::action::{
        area::{AreaResult, party_in_range},
        send_area_action_result,
    },
};
use kawari::{
    common::ObjectTypeId,
    ipc::zone::{ActorControlCategory, DamageType, TargetEffect, TargetEffectKind},
};

pub(super) fn potency(id: u32, l: u8) -> u32 {
    match id {
        24283 => {
            if l >= 64 {
                300
            } else if l >= 54 {
                250
            } else {
                180
            }
        }
        24289 => {
            if l >= 64 {
                400
            } else if l >= 54 {
                330
            } else {
                230
            }
        }
        24297 => 160,
        24304 => {
            if l >= 72 {
                300
            } else {
                240
            }
        }
        24306 => 320,
        24307 => 490,
        24312 | 24316 | 24318 => {
            if l >= 94 {
                380
            } else {
                330
            }
        }
        24313 | 37033 => 690,
        24315 => 170,
        _ => 0,
    }
}
fn magic(id: u32) -> bool {
    kardia_spell(id) || healing_spell(id) || id == 24290 || id == 24287
}
fn dot(id: u32, l: u8) -> Option<(u16, u16)> {
    Some(match id {
        24293 => (
            2614,
            if l >= 64 {
                40
            } else if l >= 54 {
                35
            } else {
                30
            },
        ),
        24308 => (2615, 60),
        24314 => (2616, if l >= 94 { 90 } else { 80 }),
        37032 => (3897, 40),
        _ => return None,
    })
}
fn acknowledgment(value: u16, n: u8) -> TargetEffect {
    TargetEffect(TargetEffectKind::Unknown {
        magic: 62,
        param0: n,
        param1: 0,
        param2: 0,
        param3: 0,
        param4: 0x80,
        value,
    })
}
fn no_effect(id: u16) -> TargetEffect {
    TargetEffect(TargetEffectKind::Unknown {
        magic: 20,
        param0: 0,
        param1: 0,
        param2: 0,
        param3: 0,
        param4: 0,
        value: id,
    })
}
fn append(r: &mut AreaResult, target: ObjectId, effects: impl IntoIterator<Item = TargetEffect>) {
    if let Some((_, row)) = r.targets.iter_mut().find(|(id, _)| id.object_id == target) {
        for e in effects {
            if let Some(slot) = row
                .iter_mut()
                .find(|e| matches!(e.0, TargetEffectKind::None))
            {
                *slot = e;
            }
        }
    } else {
        r.push(target, effects);
    }
}
pub(super) fn build(id: u32, a: &NetworkedActor) -> Option<EffectsBuilder> {
    if minimum(id) == 0 && id != 7571 {
        return None;
    }
    let mut b = EffectsBuilder::default();
    match id {
        24290 => b.effects.push(acknowledgment(262, 0)),
        24294 => b.effects.push(status(2610, 4, 15.0, true)),
        24300 => b.effects.push(status(2611, 50, 30.0, true)),
        24309 => b.effects.push(acknowledgment(258, 1)),
        24317 => b.effects.push(status(2622, 20, 10.0, false)),
        37035 => b.effects.push(status(3898, 20, 20.0, true)),
        7571 => b
            .effects
            .push(TargetEffect(TargetEffectKind::AttractCustom1 {
                speed: 12,
                min_distance: 1,
                unk: [0; 3],
                distance: 30,
            })),
        _ => {}
    }
    if gall_action(id) {
        b.effects
            .push(mp(a.get_common_spawn().max_resource_points * 7 / 100));
    }
    Some(b)
}
pub(in crate::server) fn incoming(a: &NetworkedActor) -> f64 {
    let Some(s) = a.status_effects() else {
        return 1.0;
    };
    (if live(s, 2621) { 1.1 } else { 1.0 }) * (if live(s, 2622) { 1.2 } else { 1.0 })
}
pub(in crate::server) fn mitigation(a: &NetworkedActor) -> f64 {
    let Some(s) = a.status_effects() else {
        return 1.0;
    };
    (if live(s, 2618) || live(s, 2619) {
        0.9
    } else {
        1.0
    }) * (if live(s, 3003) { 0.9 } else { 1.0 })
}
fn parameters(i: &Instance, id: ObjectId) -> Option<crate::zone_connection::BaseParameters> {
    if let Some(NetworkedActor::Player { parameters, .. }) = i.find_actor(id) {
        Some(parameters.clone())
    } else {
        None
    }
}
fn state_mut(i: &mut Instance, id: ObjectId) -> Option<&mut SageState> {
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(id) {
        Some(&mut combat_state.sage)
    } else {
        None
    }
}
fn add_haima(
    i: &mut Instance,
    target: ObjectId,
    source: ObjectId,
    pan: bool,
    amount: u32,
    cure: u32,
) -> Vec<TargetEffect> {
    let (shield, stacks_status) = if pan { (2613, 2643) } else { (2612, 2642) };
    let Some(a) = i.find_actor_mut(target) else {
        return Vec::new();
    };
    let cap = a.get_common_spawn().max_health_points;
    let Some(s) = a.status_effects_mut() else {
        return Vec::new();
    };
    s.add_barrier(shield, 0, 15.0, amount, source, cap);
    s.add_with_source(stacks_status, 5, 15.0, source);
    if let NetworkedActor::Player { combat_state, .. } = a {
        combat_state.sage.haima.retain(|h| h.shield != shield);
        combat_state.sage.haima.push(Haima {
            shield,
            stacks_status,
            stacks: 5,
            end: Instant::now() + Duration::from_secs(15),
            amount,
            cure,
            source,
        });
    }
    vec![
        status(shield, 0, 15.0, false),
        status(stacks_status, 5, 15.0, false),
    ]
}
pub(super) fn apply(
    n: &mut NetworkState,
    i: &mut Instance,
    c: JobAreaContext<'_>,
) -> Option<AreaResult> {
    if minimum(c.action) == 0 {
        return None;
    }
    let a = i.find_actor(c.caster)?;
    let p = parameters(i, c.caster)?;
    let level = a.get_common_spawn().level;
    let pos = a.position();
    let outgoing = white_mage::outgoing_heal_multiplier(Some(a), c.action)
        * (if healing_spell(c.action) && live(c.statuses, 2611) {
            1.5
        } else {
            1.0
        });
    let mut r = AreaResult::new(pos);
    let mut landed = false;
    let mut deferred = Vec::new();
    let amount = |i: &Instance, target: ObjectId, potency: u32, scale: f64| {
        let (base, crit) = p.roll_heal_amount(potency, false);
        (
            (base as f64 * scale * white_mage::incoming_heal_multiplier(i.find_actor(target)))
                as u32,
            crit,
        )
    };
    if potency(c.action, level) > 0 {
        let target = i
            .find_actor(c.target)
            .map(NetworkedActor::position)
            .unwrap_or(pos);
        let (center, shape, falloff) = match c.action {
            24297 | 24315 => (pos, Shape::Circle(5.0), 0),
            24318 => (
                pos,
                Shape::Line {
                    length: 25.0,
                    width: 4.0,
                },
                40,
            ),
            24289 => (target, Shape::Circle(5.0), 30),
            24307 | 24313 | 24304 | 24316 | 37033 => (target, Shape::Circle(5.0), 50),
            _ => (target, Shape::Circle(0.01), 0),
        };
        r = native::damage_area(
            i,
            c.caster,
            AreaAttack {
                center,
                direction: target.0 - pos.0,
                shape,
                primary: Some(c.target),
                potency: potency(c.action, level),
                falloff,
                damage_type: DamageType::Magic,
                limit: if matches!(c.action, 24283 | 24306 | 24312) {
                    1
                } else {
                    24
                },
            },
            c.modifiers,
        );
        landed = r.targets.iter().any(|(_, row)| {
            row.iter()
                .any(|e| matches!(e.0, TargetEffectKind::Damage { .. }))
        });
        if c.action == 24318 {
            for target in party_in_range(n, i, c.caster, pos.0, 20.0) {
                let (amount, critical) = amount(i, target, 600, outgoing);
                deferred.push(DeferredHeal {
                    target,
                    amount,
                    critical,
                    kind: 27524,
                });
            }
        }
    } else if let Some((buff, potency)) = dot(c.action, level) {
        let ids = if c.action == 37032 {
            native::targets(i, pos.0, glam::Vec3::Z, Shape::Circle(5.0))
        } else {
            vec![c.target]
        };
        for id in ids.into_iter().take(24) {
            let modifiers = c.modifiers.against_target(i.find_actor(id));
            let Some(a) = i.find_actor_mut(id) else {
                continue;
            };
            if matches!(
                a,
                NetworkedActor::Npc {
                    currently_invulnerable: true,
                    ..
                }
            ) {
                r.push(id, [TargetEffect(TargetEffectKind::Invincible {})]);
                continue;
            }
            let Some(s) = a.status_effects_mut() else {
                continue;
            };
            for other in [2614, 2615, 2616, 3897] {
                s.remove(other);
            }
            s.add_tick(
                buff,
                0,
                30.0,
                TickEffectKind::DamageMagic,
                potency,
                Some(TickDamageSnapshot {
                    base_amount: modifiers.apply_base_damage(p.calc_magical_damage(potency as u32)),
                    roll_modifiers: modifiers.roll,
                }),
                c.caster,
            );
            r.push(id, [status(buff, 0, 30.0, false)]);
            landed = true;
        }
    } else {
        match c.action {
            24284 | 24286 | 24291 | 24292 | 37034 | 24296 | 24299 | 24303 | 24310 => {
                let potency = match c.action {
                    24284 => {
                        if level >= 85 {
                            450
                        } else {
                            400
                        }
                    }
                    24286 | 24291 | 24310 => 300,
                    24292 | 37034 => 100,
                    24296 => 600,
                    24299 => 400,
                    _ => 700,
                };
                let radius = if c.action == 24310 { 30.0 } else { 20.0 };
                let ids = if matches!(c.action, 24286 | 24292 | 37034 | 24299 | 24310) {
                    party_in_range(n, i, c.caster, pos.0, radius)
                } else {
                    vec![c.target]
                };
                for id in ids.into_iter().take(24) {
                    if !i
                        .find_actor(id)
                        .is_some_and(|a| a.get_common_spawn().health_points > 0)
                    {
                        continue;
                    }
                    let (amount, critical) = amount(i, id, potency, outgoing);
                    scholar::restore(i, c.caster, id, amount);
                    let mut row = vec![scholar::critical_heal(amount, critical)];
                    if matches!(c.action, 24291 | 24292 | 37034 | 24310) {
                        let (buff, percent) = match c.action {
                            24291 => (2607, if level >= 85 { 180 } else { 125 }),
                            24292 => (2609, if level >= 85 { 320 } else { 160 }),
                            37034 => (2609, 360),
                            _ => (3365, 100),
                        };
                        let shield_amount = amount * percent / 100;
                        let a = i.find_actor_mut(id)?;
                        row.push(if scholar::shield(a, buff, shield_amount, 30.0, c.caster) {
                            status(buff, 0, 30.0, false)
                        } else {
                            no_effect(buff)
                        });
                        if c.action == 24291 && critical {
                            row.push(if scholar::shield(a, 2608, shield_amount, 30.0, c.caster) {
                                status(2608, 0, 30.0, false)
                            } else {
                                no_effect(2608)
                            });
                        }
                    }
                    if c.action == 24303 {
                        let s = i.find_actor_mut(id)?.status_effects_mut()?;
                        s.remove(2618);
                        s.add_with_source(2619, 10, 15.0, c.caster);
                        row.push(status(2619, 10, 15.0, false));
                    }
                    if c.action == 24310 {
                        i.find_actor_mut(id)?
                            .status_effects_mut()?
                            .add_with_source(3003, 10, 20.0, c.caster);
                        row.push(status(3003, 10, 20.0, false));
                    }
                    r.push(id, row);
                    white_mage::send_hp_mp(n, i, id);
                    landed = true;
                }
            }
            24288 | 24302 | 24298 => {
                let radius = if c.action == 24288 { 20.0 } else { 30.0 };
                for id in party_in_range(n, i, c.caster, pos.0, radius)
                    .into_iter()
                    .take(24)
                {
                    let s = i.find_actor_mut(id)?.status_effects_mut()?;
                    let mut row = Vec::new();
                    let (buff, potency) = match c.action {
                        24288 => (2617, 100),
                        24302 => (2620, 130),
                        _ => (2938, 100),
                    };
                    if c.action != 24298 || level >= 78 {
                        s.add_tick(buff, 0, 15.0, TickEffectKind::Heal, potency, None, c.caster);
                        row.push(status(buff, 0, 15.0, false));
                    }
                    if c.action == 24302 {
                        let duration = if level >= 98 { 15.0 } else { 10.0 };
                        s.add_with_source(2621, 10, duration, c.caster);
                        row.push(status(2621, 10, duration, false));
                    }
                    if c.action == 24298 {
                        s.remove(2619);
                        s.add_with_source(2618, 10, 15.0, c.caster);
                        row.push(status(2618, 10, 15.0, false));
                    }
                    r.push(id, row);
                }
            }
            24285 => {
                let old = state_mut(i, c.caster)?.kardia.replace(c.target);
                if let Some(old) = old {
                    if let Some(s) = i
                        .find_actor_mut(old)
                        .and_then(NetworkedActor::status_effects_mut)
                    {
                        s.remove_from(2605,c.caster);
                    }
                }
                i.find_actor_mut(c.caster)?
                    .status_effects_mut()?
                    .add_with_source(2604, 0, 0.0, c.caster);
                i.find_actor_mut(c.target)?
                    .status_effects_mut()?
                    .add_with_source(2605, if level >= 85 { 170 } else { 130 }, 0.0, c.caster);
                append(&mut r, c.caster, [status(2604, 0, 0.0, false)]);
                append(
                    &mut r,
                    c.target,
                    [status(
                        2605,
                        if level >= 85 { 170 } else { 130 },
                        0.0,
                        false,
                    )],
                );
            }
            24301 => {
                for id in party_in_range(n, i, c.caster, pos.0, 20.0)
                    .into_iter()
                    .take(24)
                {
                    let s = i.find_actor(id)?.status_effects()?;
                    let own = |buff| s.get(buff).is_some_and(|s| s.source_actor_id == c.caster);
                    let (buff, potency) = if own(2607) {
                        (2607, 450)
                    } else if own(2609) {
                        (2609, 350)
                    } else {
                        continue;
                    };
                    i.find_actor_mut(id)?.status_effects_mut()?.remove(buff);
                    let (amount, critical) = amount(i, id, potency, 1.0);
                    scholar::restore(i, c.caster, id, amount);
                    r.push(id, [scholar::critical_heal(amount, critical)]);
                    white_mage::send_hp_mp(n, i, id);
                }
            }
            24305 | 24311 => {
                let pan = c.action == 24311;
                let ids = if pan {
                    party_in_range(n, i, c.caster, pos.0, 30.0)
                } else {
                    vec![c.target]
                };
                for id in ids.into_iter().take(24) {
                    let (barrier, _) = amount(i, id, if pan { 200 } else { 300 }, 1.0);
                    let cure = p.calc_heal_amount(if pan { 100 } else { 150 });
                    r.push(id, add_haima(i, id, c.caster, pan, barrier, cure));
                }
            }
            37035 => {
                for id in party_in_range(n, i, c.caster, pos.0, 30.0)
                    .into_iter()
                    .take(24)
                {
                    i.find_actor_mut(id)?
                        .status_effects_mut()?
                        .add_with_source(3899, 150, 20.0, c.caster);
                    r.push(id, [status(3899, 150, 20.0, false)]);
                }
                append(&mut r, c.caster, c.effects.iter().copied());
            }
            _ => {
                r.push(c.target, c.effects.iter().copied());
                landed = true;
            }
        }
    }
    if gall_action(c.action) {
        append(
            &mut r,
            c.caster,
            c.effects
                .iter()
                .copied()
                .filter(|e| matches!(e.0, TargetEffectKind::MpGain { .. })),
        );
    }
    if let Some((_, row)) = r.targets.first_mut() {
        for effect in c
            .effects
            .iter()
            .filter(|e| matches!(e.0, TargetEffectKind::ExecuteCombo { .. }))
        {
            if let Some(slot) = row
                .iter_mut()
                .find(|e| matches!(e.0, TargetEffectKind::None))
            {
                *slot = *effect;
            }
        }
    }
    if landed && kardia_spell(c.action) {
        if let Some(target) = state_mut(i, c.caster)?.kardia.filter(|target| {
            i.find_actor(*target).is_some_and(|a| {
                a.get_common_spawn().health_points > 0
                    && a.status_effects()
                        .is_some_and(|s| s.get_from(2605,c.caster).is_some())
            })
        }) {
            let boosted = live(c.statuses, 2610);
            let (amount, critical) = amount(
                i,
                target,
                if level >= 85 { 170 } else { 130 },
                if boosted { 1.7 } else { 1.0 },
            );
            deferred.push(DeferredHeal {
                target,
                amount,
                critical,
                kind: 2605,
            });
            if boosted {
                let s = i.find_actor_mut(c.caster)?.status_effects_mut()?;
                if let Some(buff) = s.get(2610) {
                    if buff.param > 1 {
                        s.add_with_source(2610, buff.param - 1, buff.duration, c.caster);
                    } else {
                        s.remove(2610);
                    }
                }
            }
        }
    }
    if landed && magic(c.action) && live(c.statuses, 3898) {
        let ids: Vec<_> = i
            .actors
            .iter()
            .filter_map(|(id, a)| {
                (a.get_common_spawn().health_points > 0
                    && a.status_effects().is_some_and(|s| {
                        s.get_from(3899,c.caster).is_some_and(|s|s.duration>0.0)
                    }))
                .then_some(*id)
            })
            .collect();
        for target in ids {
            let (amount, critical) = amount(i, target, 150, 1.0);
            deferred.push(DeferredHeal {
                target,
                amount,
                critical,
                kind: 3899,
            });
        }
    }
    state_mut(i, c.caster)?.deferred_heals = deferred;
    Some(r)
}
pub(super) fn finish_heals(n: &mut NetworkState, i: &mut Instance, owner: ObjectId) {
    let Some(s) = state_mut(i, owner) else {
        return;
    };
    let heals = std::mem::take(&mut s.deferred_heals);
    let center = i
        .find_actor(owner)
        .map(NetworkedActor::position)
        .unwrap_or_default();
    let mut pneuma = AreaResult::new(center);
    for h in heals {
        if !i
            .find_actor(h.target)
            .is_some_and(|a| a.get_common_spawn().health_points > 0)
        {
            continue;
        }
        scholar::restore(i, owner, h.target, h.amount);
        if h.kind == 27524 {
            pneuma.push(h.target, [scholar::critical_heal(h.amount, h.critical)]);
        } else {
            n.send_ac_in_range_inclusive_instance(
                i,
                h.target,
                ActorControlCategory::TickHeal {
                    status_id: h.kind as u32,
                    amount: h.amount,
                    source_actor_id: owner,
                    unk2: u32::MAX,
                    unk3: 0,
                },
            );
        }
        white_mage::send_hp_mp(n, i, h.target);
    }
    if !pneuma.targets.is_empty() {
        send_area_action_result(
            n,
            i,
            owner,
            27524,
            ActionRequest {
                action_id: 27524,
                target: ObjectTypeId {
                    object_id: owner,
                    ..Default::default()
                },
                ..Default::default()
            },
            pneuma,
        );
    }
}

pub(in crate::server) fn barrier_broken(
    n: &mut NetworkState,
    i: &mut Instance,
    target: ObjectId,
    buff: u16,
    source: ObjectId,
) {
    if matches!(buff, 2607 | 2609) && (buff == 2607 || target == source) {
        if let Some(NetworkedActor::Player {
            combat_state,
            spawn,
            ..
        }) = i.find_actor_mut(source)
        {
            if spawn.common.class_job == 40 && spawn.common.level >= 66 {
                combat_state.sage.sting = (combat_state.sage.sting + 1).min(3);
                super::super::dispatch::send_job_gauge_update(
                    n,
                    source,
                    40,
                    combat_state.sage.pack(spawn.common.level),
                );
            }
        }
    }
    if !matches!(buff, 2612 | 2613) {
        return;
    }
    let Some(a) = i.find_actor_mut(target) else {
        return;
    };
    let NetworkedActor::Player {
        combat_state,
        status_effects,
        spawn,
        ..
    } = a
    else {
        return;
    };
    let Some(h) = combat_state
        .sage
        .haima
        .iter_mut()
        .find(|h| h.shield == buff && h.source == source)
    else {
        return;
    };
    if h.end <= Instant::now()
        || h.stacks == 0
        || !live(status_effects, h.stacks_status)
        || spawn.common.health_points == 0
    {
        return;
    }
    h.stacks -= 1;
    let duration = h
        .end
        .saturating_duration_since(Instant::now())
        .as_secs_f32();
    status_effects.add_barrier(
        h.shield,
        0,
        duration,
        h.amount,
        source,
        spawn.common.max_health_points,
    );
    if h.stacks > 0 {
        status_effects.add_with_source(h.stacks_status, h.stacks as u16, duration, source);
    } else {
        status_effects.remove(h.stacks_status);
    }
    crate::server::effect::send_effects_list_with(n, i, target);
}
pub(in crate::server) fn tick_support(n: &mut NetworkState, i: &mut Instance, target: ObjectId) {
    let Some(a) = i.find_actor_mut(target) else {
        return;
    };
    let NetworkedActor::Player {
        combat_state,
        status_effects,
        spawn,
        ..
    } = a
    else {
        return;
    };
    let now = Instant::now();
    let mut heals = Vec::new();
    combat_state.sage.haima.retain(|h| {
        if spawn.common.health_points == 0 {
            return false;
        }
        if now >= h.end {
            status_effects.remove(h.shield);
            status_effects.remove(h.stacks_status);
            if h.stacks > 0 {
                heals.push(*h);
            }
            return false;
        }
        h.stacks == 0 || live(status_effects, h.stacks_status)
    });
    for h in heals {
        let amount = (h.cure.saturating_mul(h.stacks as u32) as f64
            * white_mage::incoming_heal_multiplier(i.find_actor(target)))
            as u32;
        scholar::restore(i, h.source, target, amount);
        n.send_ac_in_range_inclusive_instance(
            i,
            target,
            ActorControlCategory::TickHeal {
                status_id: h.stacks_status as u32,
                amount,
                source_actor_id: h.source,
                unk2: u32::MAX,
                unk3: 0,
            },
        );
        white_mage::send_hp_mp(n, i, target);
        crate::server::effect::send_effects_list_with(n, i, target);
    }
}
