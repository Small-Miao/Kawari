use super::super::{
    dispatch::send_job_gauge_update,
    native::{self, AreaAttack, Shape},
    scholar, white_mage,
};
use super::*;
use crate::server::action::area::{AreaResult, party_in_range};
use kawari::ipc::zone::{TargetEffect, TargetEffectKind};
fn append(r: &mut AreaResult, t: ObjectId, es: impl IntoIterator<Item = TargetEffect>) {
    if let Some((_, row)) = r.targets.iter_mut().find(|(id, _)| id.object_id == t) {
        for (slot, e) in row
            .iter_mut()
            .filter(|e| matches!(e.0, TargetEffectKind::None))
            .zip(es)
        {
            *slot = e;
        }
    } else {
        r.push(t, es);
    }
}
fn gain(white: u8, black: u8, value: u16) -> TargetEffect {
    TargetEffect(TargetEffectKind::Unknown {
        magic: 62,
        param0: white,
        param1: black,
        param2: 0,
        param3: 0,
        param4: 128,
        value,
    })
}
fn buff(id: u16, bonus: i8, param: u16, seconds: f32, self_effect: bool) -> TargetEffect {
    TargetEffect(if self_effect {
        TargetEffectKind::GainEffectSelf {
            unk1: bonus as u8,
            unk2: 0,
            param,
            unk3: 128,
            effect_id: id,
            duration: seconds,
        }
    } else {
        TargetEffectKind::GainEffect {
            unk1: bonus as u8,
            unk2: if id == 2707 { 5 } else { 0 },
            param,
            unk3: 0,
            effect_id: id,
            duration: seconds,
        }
    })
}
fn grant(a: &mut NetworkedActor, o: ObjectId, id: u16, param: u16, seconds: u64) {
    if let NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    } = a
    {
        status_effects.add_with_source(id, param, seconds as f32, o);
        combat_state.red_mage.mark(id, seconds);
    }
}
fn potency(id: u32, combo: bool, accel: bool) -> u32 {
    match id {
        7503 => 170,
        7524 => 280,
        37004 => 360,
        7505 | 7507 => 360,
        25855 | 25856 => 440,
        7509 => 120,
        16526 => 210 + if accel { 50 } else { 0 },
        7510 | 7511 => 380,
        16524 | 16525 => 140,
        37006 => 600,
        7504 => 130,
        7512 => {
            if combo {
                150
            } else {
                100
            }
        }
        7516 => {
            if combo {
                230
            } else {
                100
            }
        }
        7527 | 45960 => 340,
        7528 | 45961 => {
            if combo {
                380
            } else {
                190
            }
        }
        7529 | 45962 => {
            if combo {
                560
            } else {
                190
            }
        }
        7513 => 60,
        7530 => 130,
        37002 => 140,
        37003 => 150,
        16529 => 100,
        16528 => 420,
        7525 | 7526 => 650,
        16530 => 750,
        25858 => 850,
        37005 => 950,
        37007 => 1200,
        7506 => 130,
        7515 | 16527 => 180,
        7517 => 480,
        7519 => 420,
        _ => 0,
    }
}
pub(super) fn apply(
    n: &mut NetworkState,
    i: &mut Instance,
    c: JobAreaContext<'_>,
) -> Option<AreaResult> {
    if !known(c.action) {
        return None;
    }
    let o = c.caster;
    let id = c.action;
    let a = i.find_actor(o)?;
    let NetworkedActor::Player {
        parameters,
        combat_state,
        ..
    } = a
    else {
        return None;
    };
    let parameters = parameters.clone();
    let pre = combat_state.red_mage.clone();
    let pos = a.position();
    let accel = acceleration(a, id);
    let p = potency(id, c.combo, accel);
    let mut r = AreaResult::new(pos);
    let mut own = Vec::new();
    let hit = if p > 0 {
        let tp = i
            .find_actor(c.target)
            .map(NetworkedActor::position)
            .unwrap_or(pos);
        let cone = matches!(id, 7513 | 7530 | 37002 | 37003);
        let line = id == 25858;
        let aoe =
            cone || line || matches!(id,7509|7519|7525|7526|16524..=16526|16530|37005..=37007);
        let magic = spell(id) || enchanted_cost(id) > 0 || matches!(id, 37005 | 37007);
        let mut mods = c.modifiers;
        if magic && c.statuses.get(1239).is_some() {
            mods.job_damage_percent = 110;
        }
        r = native::damage_area(
            i,
            o,
            AreaAttack {
                center: if cone || line { pos } else { tp },
                direction: tp.0 - pos.0,
                shape: if cone {
                    Shape::Cone {
                        radius: 8.0,
                        half_angle: std::f32::consts::FRAC_PI_4,
                    }
                } else if line {
                    Shape::Line {
                        length: 25.0,
                        width: 4.0,
                    }
                } else {
                    Shape::Circle(if !aoe {
                        0.01
                    } else if id == 7519 {
                        6.0
                    } else {
                        5.0
                    })
                },
                primary: Some(c.target),
                potency: p,
                falloff: if matches!(id, 7525 | 7526 | 16530 | 25858 | 37005..=37007) {
                    55
                } else {
                    0
                },
                damage_type: if magic {
                    DamageType::Magic
                } else {
                    DamageType::Slashing
                },
                limit: if aoe { 31 } else { 1 },
            },
            mods,
        );
        r.targets.iter().any(|(_, es)| {
            es.iter()
                .any(|e| matches!(e.0, TargetEffectKind::Damage { .. }))
        })
    } else {
        false
    };
    if id == 7514 {
        let (base, crit) = parameters.roll_heal_amount(350, false);
        let amount =
            (base as f64 * white_mage::incoming_heal_multiplier(i.find_actor(c.target))) as u32;
        scholar::restore(i, o, c.target, amount);
        r.push(c.target, [scholar::critical_heal(amount, crit)]);
    }
    if matches!(id, 7520 | 25857) {
        for t in party_in_range(n, i, o, pos.0, 30.0) {
            let b = if id == 25857 {
                2707
            } else if t == o {
                1239
            } else {
                1297
            };
            let bonus = if b == 2707 {
                -10
            } else if t == o {
                10
            } else {
                5
            };
            let dur = if b == 2707 { 10 } else { 20 };
            if let Some(a) = i.find_actor_mut(t) {
                a.status_effects_mut()?.add_with_source(b, 0, dur as f32, o);
            }
            append(&mut r, t, [buff(b, bonus, 0, dur as f32, false)]);
        }
    }
    let mut additions = Vec::new();
    match id {
        7518 => {
            additions.extend([(1238, 0, 20), (3877, 0, 30)]);
        }
        7520 => additions.push((3876, 0, 30)),
        7521 => additions.extend([(1971, 0, 30), (3875, 3, 30), (3878, 0, 30)]),
        _ => {}
    }
    if hit {
        let proc = match id {
            7505 | 25855 => Some((1234, if accel { 1.0 } else { 0.5 })),
            7507 | 25856 => Some((1235, if accel { 1.0 } else { 0.5 })),
            7525 => Some((1234, if pre.white > pre.black { 1.0 } else { 0.2 })),
            7526 => Some((1235, if pre.black > pre.white { 1.0 } else { 0.2 })),
            _ => None,
        };
        if let Some((b, chance)) = proc {
            if fastrand::f64() < chance {
                additions.push((b, 0, 30));
            }
        }
    }
    if let Some(NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    }) = i.find_actor_mut(o)
    {
        let s = &mut combat_state.red_mage;
        if spell(id) || weapon(id) || id == 7521 {
            s.chain = if hit || id == 7521 { id } else { 0 };
            s.chain_until = until(30);
        }
        if spell(id) {
            s.stacks = 0;
        }
        let cost = enchanted_cost(id);
        if cost > 0 {
            if id != 16528 && pre.free > 0 && pre.has(3875) {
                s.free -= 1;
                if s.free == 0 {
                    s.ready.remove(&3875);
                    status_effects.remove(3875);
                } else {
                    status_effects.add_with_source(3875, s.free as u16, 30.0, o);
                }
            } else {
                s.white = s.white.saturating_sub(cost);
                s.black = s.black.saturating_sub(cost);
            }
            if hit && id != 16528 {
                s.stacks = (s.stacks + 1).min(3);
                own.push(gain(1, 0, 272));
            }
        }
        if id == 7521 {
            s.free = 3;
            s.stacks = 0;
        }
        if hit {
            let (w, b) = match id {
                7503 | 7524 | 37004 => (2, 2),
                7505 | 25855 => (0, 6),
                7507 | 25856 => (6, 0),
                7510 => (0, 5),
                7511 => (5, 0),
                7509 | 16526 | 37006 => (3, 3),
                16524 => (0, 7),
                16525 => (7, 0),
                7525 => (0, 11),
                7526 => (11, 0),
                16530 | 25858 => (4, 4),
                _ => (0, 0),
            };
            if w + b > 0 {
                s.gain(w, b);
                own.push(gain(w, b, 186));
            }
        }
        for b in match id {
            7510 => vec![1234],
            7511 => vec![1235],
            37005 => vec![3876],
            37006 => vec![3877],
            37007 => vec![3878],
            _ => vec![],
        } {
            s.ready.remove(&b);
            status_effects.remove(b);
        }
        if cast_base(id) > 0 {
            if accel {
                s.ready.remove(&1238);
                status_effects.remove(1238);
            } else if c.statuses.get(167).is_none() {
                if c.statuses.get(1249).is_some() {
                    status_effects.remove(1249);
                } else {
                    status_effects.add_with_source(1249, 0, 15.0, o);
                }
            }
        } else if (spell(id) && id != 37006) || weapon(id) {
            status_effects.remove(1249);
        }
    }
    if let Some(a) = i.find_actor_mut(o) {
        for (b, param, secs) in additions {
            grant(a, o, b, param, secs);
            own.push(buff(b, 0, param, secs as f32, !matches!(b, 1238 | 1971)));
        }
    }
    append(
        &mut r,
        o,
        own.into_iter().chain(
            c.effects
                .iter()
                .copied()
                .filter(|e| matches!(e.0, TargetEffectKind::ExecuteCombo { .. })),
        ),
    );
    if hit&&weapon(id){if let Some(a)=i.find_actor_mut(o){super::super::paladin::engage_auto_attack(a,c.target);}}
    if r.targets.is_empty() {
        r.push(o, []);
    }
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        send_job_gauge_update(n, o, 35, combat_state.red_mage.pack());
    }
    for (t, _) in &r.targets {
        white_mage::send_hp_mp(n, i, t.object_id);
    }
    Some(r)
}
