//! 玩家技能和治疗结算。治疗、护盾共用一次暴击结果，避免两个独立随机数。
use super::super::{
    native::{self, AreaAttack, Shape, damage, heal, mp, status},
    white_mage,
};
use super::*;
use crate::{
    TickDamageSnapshot, TickEffectKind,
    lua::{TickAction, TickKind},
    server::action::area::{AreaResult, party_in_range},
};
use kawari::ipc::zone::{ActorControlCategory, DamageType, TargetEffect, TargetEffectKind};

pub(super) fn potency(id: u32, l: u8) -> u32 {
    match id {
        17869 => 150,
        3584 => 220,
        7435 => 240,
        16541 => 255,
        25865 => {
            if l >= 94 {
                320
            } else {
                295
            }
        }
        17870 => {
            if l >= 82 {
                220
            } else if l >= 72 {
                200
            } else if l >= 64 {
                180
            } else if l >= 54 {
                160
            } else {
                140
            }
        }
        16539 => {
            if l >= 54 {
                165
            } else {
                150
            }
        }
        25866 => 180,
        167 => 100,
        _ => 0,
    }
}
pub(super) fn build(id: u32, a: &NetworkedActor) -> Option<EffectsBuilder> {
    let NetworkedActor::Player {
        parameters, spawn, ..
    } = a
    else {
        return None;
    };
    let l = spawn.common.level;
    let mut b = EffectsBuilder::default();
    match id {
        17869 | 3584 | 7435 | 16541 | 25865 | 17870 | 167 => b.effects.push(damage(
            parameters.calc_magical_damage(potency(id, l)),
            DamageType::Magic,
        )),
        17864 | 17865 | 16540 => {
            let (effect_id, potency) = match id {
                17864 => (179, 20),
                17865 => (189, 40),
                _ => (1895, if l >= 94 { 85 } else { 70 }),
            };
            b.effects.push(status(effect_id, 0, 30.0, false));
            b.tick_actions.push(TickAction {
                effect_id,
                param: 0,
                duration: 30.0,
                potency,
                kind: TickKind::DamageMagic,
                on_self: false,
            });
        }
        166 => b.effects.push(mp(spawn.common.max_resource_points / 5)),
        3586 | 37037 => b.effects.push(status(792, 0, 15.0, true)),
        3587 => b.effects.push(status(791, 20, 30.0, true)),
        16542 => b.effects.push(status(1896, 0, 15.0, true)),
        7436 => {
            b.effects.push(status(1221, 10, 20.0, false));
            if l >= 92 {
                b.effects.push(status(3882, 0, 30.0, true));
            }
        }
        37014 => b.effects.push(status(3884, 0, 20.0, true)),
        188 => {
            b.effects
                .push(status(if l >= 78 { 1944 } else { 298 }, 0, 15.0, true));
            b.effects.push(TargetEffect(TargetEffectKind::Unknown {
                magic: 62,
                param0: 10,
                param1: 0,
                param2: 0,
                param3: 0,
                param4: 0,
                value: 195,
            }));
        }
        17215 => b.effects.push(TargetEffect(TargetEffectKind::Unknown {
            magic: 62,
            param0: 0,
            param1: 0,
            param2: 0,
            param3: 0,
            param4: 0x80,
            value: 157,
        })),
        16545 => b
            .effects
            .push(TargetEffect(TargetEffectKind::SummonPet { unk: [0; 7] })),
        16537 | 16538 | 16543 | 16546 => b.effects.push(TargetEffect(TargetEffectKind::Unknown {
            magic: 61,
            param0: 0,
            param1: 0,
            param2: 0,
            param3: 0,
            param4: 0,
            value: 0,
        })),
        173 | 185 | 186 | 189 | 190 | 3583 | 3585 | 7434 | 7437 | 7869 | 16539 | 25866 | 25867
        | 25868 | 37012 | 37013 | 37015 | 37016 => {}
        7571 => b
            .effects
            .push(TargetEffect(TargetEffectKind::AttractCustom1 {
                speed: 12,
                min_distance: 1,
                unk: [0; 3],
                distance: 30,
            })),
        _ => return None,
    }
    Some(b)
}

pub(in crate::server) fn critical_heal(amount: u32, critical: bool) -> TargetEffect {
    TargetEffect(TargetEffectKind::Heal {
        amount,
        unk1: [0, if critical { 0x20 } else { 0 }, 0, 0, 0],
    })
}

fn preserve_cast_result(r: &mut AreaResult, c: &JobAreaContext<'_>) {
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
/// 鼓舞与贤者同类护盾竞争；较弱效果不刷新已有较强护盾的持续时间。
pub(in crate::server) fn shield(
    a: &mut NetworkedActor,
    id: u16,
    amount: u32,
    seconds: f32,
    source: ObjectId,
) -> bool {
    let cap = a.get_common_spawn().max_health_points;
    let Some(s) = a.status_effects_mut() else {
        return false;
    };
    let group: &[u16] = if matches!(id, 297 | 2607 | 2609) {
        &[297, 2607, 2609]
    } else {
        std::slice::from_ref(&id)
    };
    if group.iter().any(|id| s.barrier_remaining(*id) > amount) {
        return false;
    }
    for other in group {
        s.remove(*other);
    }
    s.add_barrier(id, 0, seconds, amount, source, cap);
    true
}
pub(in crate::server) fn restore(
    i: &mut Instance,
    source: ObjectId,
    target: ObjectId,
    amount: u32,
) {
    let restored = i.find_actor_mut(target).map_or(0, |a| a.apply_heal(amount));
    if restored == 0 {
        return;
    }
    let engaged: Vec<_> = i
        .actors
        .iter()
        .filter_map(|(id, a)| {
            a.npc_hate_list()
                .is_some_and(|h| h.contains_key(&target))
                .then_some(*id)
        })
        .collect();
    let each = (restored / 2) / (engaged.len().max(1) as u32);
    for id in engaged {
        if let Some(h) = i
            .find_actor_mut(id)
            .and_then(NetworkedActor::npc_hate_list_mut)
        {
            let v = h.entry(source).or_default();
            *v = v.saturating_add(each);
        }
    }
}
fn heal_profile(id: u32, l: u8) -> Option<(u32, u32, bool)> {
    Some(match id {
        185 => (300, if l >= 85 { 180 } else { 125 }, true),
        186 => (200, if l >= 85 { 160 } else { 125 }, false),
        37013 => (200, 180, false),
        37015 => (360, 180, true),
        37016 => (240, 180, false),
        190 => (if l >= 85 { 450 } else { 400 }, 0, false),
        189 => (600, 0, false),
        3583 => (400, 0, false),
        _ => return None,
    })
}
pub(super) fn apply(
    n: &mut NetworkState,
    i: &mut Instance,
    c: JobAreaContext<'_>,
) -> Option<AreaResult> {
    let a = i.find_actor(c.caster)?;
    let NetworkedActor::Player { parameters, .. } = a else {
        return None;
    };
    let parameters = parameters.clone();
    let l = a.get_common_spawn().level;
    let pos = a.position();
    let outgoing = white_mage::outgoing_heal_multiplier(Some(a), c.action);
    let mut r = AreaResult::new(pos);
    if let Some((potency, shield_percent, catalyze)) = heal_profile(c.action, l) {
        let ids = if matches!(c.action, 186 | 37013 | 37016 | 3583) {
            party_in_range(n, i, c.caster, pos.0, 20.0)
        } else {
            vec![c.target]
        };
        for id in ids.into_iter().take(32) {
            let Some(a) = i.find_actor(id) else {
                continue;
            };
            if a.get_common_spawn().health_points == 0 {
                continue;
            }
            let (base, critical) =
                parameters.roll_heal_amount(potency, recitable(c.action) && live(c.statuses, 1896));
            let amount =
                (base as f64 * outgoing * white_mage::incoming_heal_multiplier(Some(a))) as u32;
            restore(i, c.caster, id, amount);
            let mut effects = vec![critical_heal(amount, critical)];
            let shield_amount = amount.saturating_mul(shield_percent) / 100;
            if shield_percent > 0 {
                if live(c.statuses, 792) {
                    let extra =
                        shield_amount.saturating_mul(if catalyze && critical { 2 } else { 1 });
                    restore(i, c.caster, id, extra);
                    effects.push(critical_heal(extra, critical));
                } else {
                    let a = i.find_actor_mut(id)?;
                    effects.push(if shield(a, 297, shield_amount, 30.0, c.caster) {
                        status(297, 0, 30.0, false)
                    } else {
                        no_effect(297)
                    });
                    if catalyze && critical {
                        effects.push(if shield(a, 1918, shield_amount, 30.0, c.caster) {
                            status(1918, 0, 30.0, false)
                        } else {
                            no_effect(1918)
                        });
                    }
                }
            }
            r.push(id, effects);
            white_mage::send_hp_mp(n, i, id);
        }
        preserve_cast_result(&mut r, &c);
        return Some(r);
    }
    match c.action {
        167 => {
            let amount = c
                .effects
                .iter()
                .find_map(|e| {
                    if let TargetEffectKind::Damage { amount, .. } = e.0 {
                        Some(amount / 2)
                    } else {
                        None
                    }
                })
                .unwrap_or(0);
            let amount = (amount as f64
                * white_mage::incoming_heal_multiplier(i.find_actor(c.caster)))
                as u32;
            restore(i, c.caster, c.caster, amount);
            r.push(c.target, c.effects.iter().copied());
            r.push(c.caster, [heal(amount, false)]);
            white_mage::send_hp_mp(n, i, c.caster);
        }
        16539 | 25866 => {
            return Some(native::damage_area(
                i,
                c.caster,
                AreaAttack {
                    center: pos,
                    direction: glam::Vec3::Z,
                    shape: Shape::Circle(5.0),
                    primary: None,
                    potency: potency(c.action, l),
                    falloff: 0,
                    damage_type: DamageType::Magic,
                    limit: 32,
                },
                c.modifiers,
            ));
        }
        37012 => {
            let center = i.find_actor(c.target)?.position();
            r.center = center;
            for id in native::targets(i, center.0, glam::Vec3::Z, Shape::Circle(5.0))
                .into_iter()
                .take(32)
            {
                let roll = c.modifiers.against_target(i.find_actor(id)).roll;
                let a = i.find_actor_mut(id)?;
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
                a.status_effects_mut()?.add_tick(
                    3883,
                    0,
                    15.0,
                    TickEffectKind::DamageMagic,
                    140,
                    Some(TickDamageSnapshot {
                        base_amount: c
                            .modifiers
                            .apply_base_damage(parameters.calc_magical_damage(140)),
                        roll_modifiers: roll,
                    }),
                    c.caster,
                );
                r.push(id, [status(3883, 0, 15.0, false)]);
            }
        }
        3585 => {
            let source = i.find_actor(c.target)?;
            r.center = source.position();
            let s = source.status_effects()?;
            let Some(buff) = s
                .get(297)
                .filter(|s| s.source_actor_id == c.caster && s.duration > 0.0)
            else {
                return Some(r);
            };
            let seconds = buff.duration;
            let amount = s.barrier_remaining(297);
            for id in party_in_range(n, i, c.caster, r.center.0, 30.0)
                .into_iter()
                .filter(|id| *id != c.target)
                .take(32)
            {
                r.push(
                    id,
                    [
                        if shield(i.find_actor_mut(id)?, 297, amount, seconds, c.caster) {
                            status(297, 0, seconds, false)
                        } else {
                            no_effect(297)
                        },
                    ],
                );
            }
        }
        7434 => {
            let (base, _) = parameters.roll_heal_amount(800, live(c.statuses, 1896));
            if let Some(NetworkedActor::Player {
                combat_state,
                status_effects,
                ..
            }) = i.find_actor_mut(c.target)
            {
                combat_state.scholar.excogitation =
                    Some((Instant::now() + Duration::from_secs(45), base, c.caster));
                status_effects.add_with_source(1220, 50, 45.0, c.caster);
                r.push(c.target, [status(1220, 50, 45.0, false)]);
            }
            tick_support(n, i, c.target);
        }
        25867 => {
            let Some(NetworkedActor::Player {
                spawn,
                combat_state,
                status_effects,
                ..
            }) = i.find_actor_mut(c.target)
            else {
                return Some(r);
            };
            if let Some((_, bonus)) = combat_state.scholar.protraction.take() {
                spawn.common.max_health_points =
                    spawn.common.max_health_points.saturating_sub(bonus);
            }
            let bonus = spawn.common.max_health_points / 10;
            spawn.common.max_health_points += bonus;
            let amount = spawn.common.max_health_points / 10;
            combat_state.scholar.protraction =
                Some((Instant::now() + Duration::from_secs(10), bonus));
            status_effects.add_with_source(2710, 10, 10.0, c.caster);
            restore(i, c.caster, c.target, amount);
            r.push(
                c.target,
                [status(2710, 10, 10.0, false), heal(amount, false)],
            );
            white_mage::send_hp_mp(n, i, c.target);
        }
        25868 => {
            for id in party_in_range(n, i, c.caster, pos.0, 30.0)
                .into_iter()
                .take(32)
            {
                let s = i.find_actor_mut(id)?.status_effects_mut()?;
                s.add_with_source(2711, 10, 20.0, c.caster);
                s.add_with_source(2712, 0, 10.0, c.caster);
                r.push(
                    id,
                    [status(2711, 10, 20.0, false), status(2712, 0, 10.0, false)],
                );
            }
        }
        188 => {
            if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(c.caster) {
                let s = &mut combat_state.scholar;
                s.soil_center = Some(
                    c.ground
                        .filter(|p| p.0.is_finite() && p.0.distance(pos.0) <= 30.0)
                        .unwrap_or(pos),
                );
                s.soil_until = deadline(15);
            }
            return None;
        }
        _ => return None,
    }
    Some(r)
}
pub(in crate::server) fn mitigation(a: &NetworkedActor, kind: DamageType) -> f64 {
    let Some(s) = a.status_effects() else {
        return 1.0;
    };
    let mut m = 1.0;
    if live(s, 299) {
        m *= 0.9;
    }
    if live(s, 2711) {
        m *= 0.9;
    }
    if kind == DamageType::Magic && (live(s, 317) || live(s, 1875)) {
        m *= 0.95;
    }
    m
}
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
    let now = Instant::now();
    let mut changed = false;
    if let Some((end, bonus)) = combat_state.scholar.protraction {
        if now >= end || !live(status_effects, 2710) || spawn.common.health_points == 0 {
            combat_state.scholar.protraction = None;
            spawn.common.max_health_points =
                spawn.common.max_health_points.saturating_sub(bonus).max(1);
            spawn.common.health_points = spawn
                .common
                .health_points
                .min(spawn.common.max_health_points);
            status_effects.remove(2710);
            changed = true;
        }
    }
    let mut triggered = None;
    if let Some((end, amount, source)) = combat_state.scholar.excogitation {
        if spawn.common.health_points == 0 || now < end && !live(status_effects, 1220) {
            combat_state.scholar.excogitation = None;
        } else if now >= end
            || u64::from(spawn.common.health_points) * 2 < u64::from(spawn.common.max_health_points)
        {
            combat_state.scholar.excogitation = None;
            status_effects.remove(1220);
            triggered = Some((amount, source));
            changed = true;
        }
    }
    if let Some((amount, source)) = triggered {
        let amount = (amount as f64 * white_mage::incoming_heal_multiplier(Some(a))) as u32;
        restore(i, source, id, amount);
        n.send_ac_in_range_inclusive_instance(
            i,
            id,
            ActorControlCategory::TickHeal {
                status_id: 1220,
                amount,
                source_actor_id: source,
                unk2: u32::MAX,
                unk3: 0,
            },
        );
    }
    if changed {
        white_mage::send_hp_mp(n, i, id);
        crate::server::effect::send_effects_list_with(n, i, id);
    }
}
