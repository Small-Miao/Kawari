use super::super::{
    dispatch::send_job_gauge_update,
    native::{self, AreaAttack, Shape, status},
    paladin, white_mage,
};
use super::*;
use crate::{TickDamageSnapshot, TickEffectKind, server::action::area::AreaResult};
use kawari::ipc::zone::{DamageType, TargetEffect, TargetEffectKind};
// 录像中增伤/急速位于效果包 Param0；状态列表 Param 为 0，不能混作层数。
fn bonus_status(id: u16, bonus: i8, param: u16, duration: f32) -> TargetEffect {
    TargetEffect(TargetEffectKind::GainEffectSelf {
        unk1: bonus as u8,
        unk2: 0,
        param,
        unk3: 128,
        effect_id: id,
        duration,
    })
}
pub(super) fn potency(id: u32, l: u8, combo: bool, enhanced_enpi: bool) -> u32 {
    match id {
        7477 => {
            if l >= 66 {
                200
            } else {
                180
            }
        }
        36963 => 240,
        7478 | 7479 => {
            (if l >= 94 {
                140
            } else if l >= 66 {
                120
            } else {
                100
            }) + if combo { 160 } else { 0 }
        }
        7480..=7482 => {
            (if l >= 94 {
                160
            } else if l >= 84 {
                110
            } else {
                100
            }) + if combo {
                if id == 7480 { 180 } else { 210 }
            } else {
                0
            }
        }
        7483 => 90,
        7484 | 7485 => {
            if combo {
                120
            } else {
                100
            }
        }
        25780 => 100,
        7486 => {
            if enhanced_enpi {
                if l >= 94 { 270 } else { 260 }
            } else {
                100
            }
        }
        7490 => 250,
        7491 | 7492 | 7493 => 100,
        7496 => 400,
        16481 => 800,
        16487 => {
            if l >= 94 {
                640
            } else {
                560
            }
        }
        7487 | 16486 => {
            if l >= 94 {
                680
            } else {
                620
            }
        }
        7488 | 16485 => 300,
        7489 => 200,
        25781 | 25782 => {
            if l >= 94 {
                1000
            } else {
                860
            }
        }
        36964 => 940,
        36965 | 36967 => 410,
        36966 | 36968 => 1100,
        _ => 0,
    }
}
pub(super) fn build(id: u32, a: &NetworkedActor) -> Option<EffectsBuilder> {
    if minimum(id) == 0 {
        return None;
    }
    let mut b = EffectsBuilder::default();
    let l = a.get_common_spawn().level;
    match id {
        7498 => b.effects.push(bonus_status(1232, -10, 10, 4.0)),
        36962 => b.effects.push(bonus_status(3853, -10, 10, 4.0)),
        7499 => {
            b.effects.push(status(1233, 3, 20.0, true));
            if l >= 100 {
                b.effects.push(status(3856, 0, 30.0, true));
            }
        }
        16482 => {
            if l >= 90 {
                b.effects.push(status(2959, 0, 30.0, true));
            }
            if l >= 96 {
                b.effects.push(status(3855, 0, 30.0, true));
            }
        }
        7497 => b.effects.push(status(1231, 0, 15.0, true)),
        _ => {}
    }
    Some(b)
}
fn append(r: &mut AreaResult, target: ObjectId, es: impl IntoIterator<Item = TargetEffect>) {
    if let Some((_, row)) = r.targets.iter_mut().find(|(t, _)| t.object_id == target) {
        for (slot, e) in row
            .iter_mut()
            .filter(|e| matches!(e.0, TargetEffectKind::None))
            .zip(es)
        {
            *slot = e;
        }
    } else {
        r.push(target, es);
    }
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
    let NetworkedActor::Player {
        parameters,
        combat_state,
        spawn,
        ..
    } = a
    else {
        return None;
    };
    let stats = parameters.clone();
    let pre = combat_state.samurai.clone();
    let l = spawn.common.level;
    let pos = a.position();
    let rot = spawn.common.rotation;
    let id = c.action;
    let meikyo = pre.meikyo > 0 && active(pre.meikyo_until);
    let combo = c.combo || meikyo;
    let mut p = potency(id, l, combo, c.statuses.get(1236).is_some());
    let mut r = AreaResult::new(pos);
    let mut own = Vec::new();
    let mut landed = false;
    if p > 0 {
        if matches!(id, 7481 | 7482)
            && i.find_actor(c.target)
                .is_some_and(|t| super::super::monk::positional(a, t, id == 7481))
        {
            p += 50;
        }
        let target = i
            .find_actor(c.target)
            .map(NetworkedActor::position)
            .unwrap_or(pos);
        let cone = matches!(id, 7483 | 25781 | 25782 | 36964);
        let circle = matches!(
            id,
            7484 | 7485 | 7491 | 7488 | 16485 | 25780 | 36965 | 36967
        );
        let line = matches!(id, 7496 | 16487);
        let shape = if cone {
            Shape::Cone {
                radius: 8.0,
                half_angle: std::f32::consts::FRAC_PI_4,
            }
        } else if line {
            Shape::Line {
                length: 10.0,
                width: 4.0,
            }
        } else {
            Shape::Circle(if matches!(id, 7488 | 16485 | 36965 | 36967) {
                8.0
            } else if circle {
                5.0
            } else {
                0.01
            })
        };
        let mut mods = c.modifiers;
        if matches!(id, 7487 | 16486 | 25781 | 25782 | 36966 | 36968) {
            mods.roll.force_critical = true;
        }
        r = native::damage_area(
            i,
            c.caster,
            AreaAttack {
                center: if cone || circle || line { pos } else { target },
                direction: target.0 - pos.0,
                shape,
                primary: Some(c.target),
                potency: p,
                falloff: if matches!(id, 16487 | 25781 | 25782 | 36964) {
                    40
                } else {
                    0
                },
                damage_type: DamageType::Slashing,
                limit: if cone || circle || line { 31 } else { 1 },
            },
            mods,
        );
        landed = r.targets.iter().any(|(_, es)| {
            es.iter()
                .any(|e| matches!(e.0, TargetEffectKind::Damage { .. }))
        });
        if id == 7489 && landed {
            let potency = if l >= 94 { 50 } else { 45 };
            let roll = c.modifiers.against_target(i.find_actor(c.target)).roll;
            i.find_actor_mut(c.target)?.status_effects_mut()?.add_tick(
                1228,
                0,
                60.0,
                TickEffectKind::DamagePhysical,
                potency,
                Some(TickDamageSnapshot {
                    base_amount: c
                        .modifiers
                        .apply_base_damage(stats.calc_physical_damage(u32::from(potency))),
                    roll_modifiers: roll,
                }),
                c.caster,
            );
            append(&mut r, c.target, [status(1228, 0, 60.0, false)]);
        }
    }
    if let Some(NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    }) = i.find_actor_mut(c.caster)
    {
        let s = &mut combat_state.samurai;
        s.kenki = s.kenki.saturating_sub(cost(id));
        if landed {
            let kenki = match id {
                7477 | 36963 | 7478 | 7479 | 7483
                    if (id == 7477 || id == 36963 || id == 7483 || combo) && l >= 62 =>
                {
                    5
                }
                7480 if combo => {
                    if l >= 62 {
                        15
                    } else {
                        10
                    }
                }
                7481 | 7482 | 7484 | 7485 if combo => {
                    if l >= 62 {
                        10
                    } else {
                        5
                    }
                }
                7486 => {
                    if l >= 62 {
                        10
                    } else {
                        5
                    }
                }
                25780 => 10,
                _ => 0,
            };
            s.gain_kenki(kenki, l);
            if combo {
                let sen = match id {
                    7480 => 1,
                    7481 | 7484 => 2,
                    7482 | 7485 => 4,
                    _ => 0,
                };
                if sen != 0 {
                    s.sen |= sen;
                    own.push(TargetEffect(TargetEffectKind::Unknown {
                        magic: 62,
                        param0: sen,
                        param1: 0,
                        param2: 0,
                        param3: 0,
                        param4: 128,
                        value: 184,
                    }));
                }
            }
            let buff = if combo && matches!(id, 7478 | 7484) || meikyo && id == 7481 {
                Some(1298)
            } else if combo && matches!(id, 7479 | 7485) || meikyo && id == 7482 {
                Some(1299)
            } else {
                None
            };
            if let Some(buff) = buff {
                let value = if l >= 78 { 13 } else { 10 };
                status_effects.add_with_source(buff, 0, 40.0, c.caster);
                own.push(bonus_status(
                    buff,
                    if buff == 1299 { -value } else { value },
                    0,
                    40.0,
                ));
            }
        }
        if basic(id) && meikyo {
            s.meikyo = s.meikyo.saturating_sub(1);
            if s.meikyo == 0 {
                s.meikyo_until = None;
                status_effects.remove(1233);
            } else {
                status_effects.add_with_source(
                    1233,
                    s.meikyo as u16,
                    pre.meikyo_until
                        .unwrap()
                        .saturating_duration_since(Instant::now())
                        .as_secs_f32(),
                    c.caster,
                );
            }
        }
        if iai(id) {
            s.sen = 0;
            if l >= 80 && landed {
                s.meditation = (s.meditation + 1).min(3);
                own.push(TargetEffect(TargetEffectKind::Unknown {
                    magic: 62,
                    param0: 1,
                    param1: 0,
                    param2: 0,
                    param3: 0,
                    param4: 128,
                    value: 255,
                }));
            }
            if id != 7489 && l >= 74 {
                let (repeat, buff, kaeshi) = match id {
                    7488 => (16485, 3852, 2),
                    7487 => (16486, 4216, 3),
                    36965 => (36967, 4217, 2),
                    _ => (36968, 4218, 3),
                };
                s.repeat = repeat;
                s.repeat_until = until(30);
                s.kaeshi = kaeshi;
                for old in [3852, 4216, 4217, 4218] {
                    status_effects.remove(old);
                }
                status_effects.add_with_source(buff, 0, 30.0, c.caster);
                own.push(status(buff, 0, 30.0, true));
            }
            if matches!(id, 36965 | 36966) {
                s.tendo_until = None;
                status_effects.remove(3856);
            }
        }
        if repeat(id) {
            s.repeat = 0;
            s.repeat_until = None;
            s.kaeshi = 0;
            for old in [3852, 4216, 4217, 4218] {
                status_effects.remove(old);
            }
        }
        if basic(id) || iai(id) || repeat(id) || matches!(id, 25781 | 25782) {
            s.ogi_repeat = false;
            s.ogi_repeat_until=None;
        }
        if id == 25781 {
            s.ogi_until = None;
            s.ogi_repeat = true;
            s.ogi_repeat_until=until(30);
            status_effects.remove(2959);
            if landed {
                s.meditation = (s.meditation + 1).min(3);
                own.push(TargetEffect(TargetEffectKind::Unknown {
                    magic: 62,
                    param0: 1,
                    param1: 0,
                    param2: 0,
                    param3: 0,
                    param4: 128,
                    value: 255,
                }));
            }
        }
        if id == 36964 {
            s.zanshin_until = None;
            status_effects.remove(3855);
        }
        if id == 16487 {
            s.meditation = 0;
        }
        if id == 7486 {
            status_effects.remove(1236);
        }
        if id == 7493 {
            status_effects.add_with_source(1236, 0, 15.0, c.caster);
            own.push(status(1236, 0, 15.0, true));
        }
        if id == 7497 {
            let now = Instant::now();
            s.meditate = Some((
                pos,
                rot,
                now + Duration::from_secs(15),
                now + Duration::from_secs(3),
            ));
            combat_state.paladin.auto_target = None;
        }
    }
    if landed && let Some(a) = i.find_actor_mut(c.caster) {
        paladin::engage_auto_attack(a, c.target);
    }
    append(
        &mut r,
        c.caster,
        own.into_iter().chain(
            c.effects
                .iter()
                .copied()
                .filter(|e| !matches!(e.0, TargetEffectKind::None)),
        ),
    );
    if r.targets.is_empty() {
        r.push(c.caster, []);
    }
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(c.caster) {
        send_job_gauge_update(n, c.caster, 34, combat_state.samurai.pack());
    }
    for (t, _) in &r.targets {
        white_mage::send_hp_mp(n, i, t.object_id);
    }
    Some(r)
}
pub(super) fn tick(n: &mut NetworkState, i: &mut Instance, o: ObjectId) {
    let Some(
        a @ NetworkedActor::Player {
            combat_state,
            spawn,
            ..
        },
    ) = i.find_actor(o)
    else {
        return;
    };
    let pre = combat_state.samurai.clone();
    let pos = a.position();
    let rot = spawn.common.rotation;
    let l = spawn.common.level;
    let alive = spawn.common.health_points > 0;
    let heal = white_mage::incoming_heal_multiplier(Some(a));
    let now = Instant::now();
    let Some(NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    }) = i.find_actor_mut(o)
    else {
        return;
    };
    let s = &mut combat_state.samurai;
    if pre.eye_triggered && alive {
        s.eye_triggered = false;
        status_effects.add_tick(3854, 10, 9.0, TickEffectKind::Heal, 200, None, o);
        status_effects.snapshot_healing_multiplier(3854, o, heal);
    }
    if let Some((origin, facing, end, mut next)) = pre.meditate {
        let moved = pos.0.distance_squared(origin.0) > 0.0001 || (rot - facing).cos() < 0.9999;
        if !moved && alive {
            while next <= now && next <= end {
                if combat_state.in_combat {
                    s.gain_kenki(10, l);
                    if l >= 80 {
                        s.meditation = (s.meditation + 1).min(3);
                    }
                }
                next += Duration::from_secs(3);
            }
        }
        if moved || !alive || now >= end {
            s.meditate = None;
            status_effects.remove(1231);
        } else {
            s.meditate = Some((origin, facing, end, next));
        }
    }
    if s.pack() != pre.pack() {
        send_job_gauge_update(n, o, 34, s.pack());
    }
}
