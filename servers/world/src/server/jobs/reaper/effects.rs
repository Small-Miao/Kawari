use super::super::{
    dispatch::send_job_gauge_update,
    native::{self, AreaAttack, Shape},
    paladin, white_mage,
};
use super::*;
use crate::server::action::area::{AreaResult, party_in_range};
use kawari::ipc::zone::{DamageType, TargetEffect, TargetEffectKind};
pub(super) fn append(r: &mut AreaResult, t: ObjectId, es: impl IntoIterator<Item = TargetEffect>) {
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
fn gain(value: u16, amount: u8) -> TargetEffect {
    TargetEffect(TargetEffectKind::Unknown {
        magic: 62,
        param0: amount,
        param1: 0,
        param2: 0,
        param3: 0,
        param4: 128,
        value,
    })
}
pub(super) fn buff(id: u16, param: u16, seconds: f32, on_self: bool) -> TargetEffect {
    TargetEffect(if on_self {
        TargetEffectKind::GainEffectSelf {
            unk1: 0,
            unk2: 0,
            param,
            unk3: 128,
            effect_id: id,
            duration: seconds,
        }
    } else {
        TargetEffectKind::GainEffect {
            unk1: if id == 2586 {
                10
            } else if id == 2599 {
                3
            } else {
                0
            },
            unk2: 0,
            param,
            unk3: 0,
            effect_id: id,
            duration: seconds,
        }
    })
}
pub(super) fn grant(a: &mut NetworkedActor, o: ObjectId, b: u16, param: u16, seconds: u64) {
    if let NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    } = a
    {
        status_effects.add_with_source(b, param, seconds as f32, o);
        combat_state
            .reaper
            .ready
            .insert(b, Instant::now() + Duration::from_secs(seconds));
    }
}
fn potency(id: u32, combo: bool, enhanced: bool, position: bool, stacks: u8) -> u32 {
    match id {
        24373 => 420,
        24374 => {
            if combo {
                500
            } else {
                260
            }
        }
        24375 => {
            if combo {
                600
            } else {
                280
            }
        }
        24376 => 140,
        24377 => {
            if combo {
                180
            } else {
                120
            }
        }
        24378 | 24386 => 300,
        24379 => 100,
        24380 => 520,
        24381 => 180,
        24382 | 24383 => 500 + if enhanced { 60 } else { 0 } + if position { 60 } else { 0 },
        24384 => 200,
        24385 => 720 + 40 * u32::from(stacks.saturating_sub(1).min(7)),
        24388 => 800,
        24389 => 340,
        24390 | 24391 => 440,
        24392 => 140,
        24393 => 560,
        24395 | 24396 => 580 + if enhanced { 60 } else { 0 },
        24397 => 220,
        24398 => 1100,
        24399 => 280,
        24400 => 100,
        36969 => 700,
        36970 | 36971 => 700 + if enhanced { 60 } else { 0 } + if position { 60 } else { 0 },
        36972 => 260,
        36973 => 1300,
        _ => 0,
    }
}
pub(super) fn apply(
    n: &mut NetworkState,
    i: &mut Instance,
    c: JobAreaContext<'_>,
) -> Option<AreaResult> {
    let id = c.action;
    if !known(id) {
        return None;
    }
    let o = c.caster;
    let a = i.find_actor(o)?;
    let NetworkedActor::Player { combat_state, .. } = a else {
        return None;
    };
    let pre = combat_state.reaper.clone();
    let pos = a.position();
    let b = match id {
        24382 | 36970 => 2588,
        24383 | 36971 => 2589,
        24395 => 2590,
        24396 => 2591,
        _ => 0,
    };
    let enhanced = c.statuses.get(b).is_some();
    let directional = matches!(id, 24382 | 24383 | 36970 | 36971);
    let positional = directional
        && i.find_actor(c.target)
            .is_some_and(|t| super::super::monk::positional(a, t, matches!(id, 24383 | 36971)));
    let p = potency(id, c.combo, enhanced, positional, pre.sacrifice);
    let mut r = AreaResult::new(pos);
    let mut own = Vec::new();
    let mut additions = Vec::new();
    let hit = if p > 0 {
        let tp = i
            .find_actor(c.target)
            .map(NetworkedActor::position)
            .unwrap_or(pos);
        let circle = matches!(id, 24376 | 24377 | 24379 | 24381);
        let cone = matches!(id, 24384 | 24392 | 24397 | 24400 | 36972);
        let line = id == 24385;
        let splash = matches!(id, 24388 | 24393 | 24398 | 36969 | 36973);
        let area = circle || cone || line || splash;
        r = native::damage_area(
            i,
            o,
            AreaAttack {
                center: if circle || cone || line { pos } else { tp },
                direction: tp.0 - pos.0,
                shape: if cone {
                    Shape::Cone {
                        radius: 8.0,
                        half_angle: std::f32::consts::FRAC_PI_4,
                    }
                } else if line {
                    Shape::Line {
                        length: 15.0,
                        width: 4.0,
                    }
                } else {
                    Shape::Circle(if area { 5.0 } else { 0.01 })
                },
                primary: Some(c.target),
                potency: p,
                falloff: if id == 24388 {
                    40
                } else if id == 24393 {
                    25
                } else if line || splash {
                    20
                } else {
                    0
                },
                damage_type: if matches!(id, 24386 | 24388 | 24393 | 24398 | 36969) {
                    DamageType::Magic
                } else {
                    DamageType::Slashing
                },
                limit: if area { 31 } else { 1 },
            },
            c.modifiers,
        );
        r.targets.iter().any(|(_, es)| {
            es.iter()
                .any(|e| matches!(e.0, TargetEffectKind::Damage { .. }))
        })
    } else {
        false
    };
    if hit && matches!(id, 24378 | 24379) {
        let targets: Vec<_> = r
            .targets
            .iter()
            .filter(|(_, es)| {
                es.iter()
                    .any(|e| matches!(e.0, TargetEffectKind::Damage { .. }))
            })
            .map(|(t, _)| t.object_id)
            .collect();
        for t in targets {
            let secs = 30.0
                + pre
                    .marks
                    .get(&t)
                    .map_or(0.0, |end| {
                        end.saturating_duration_since(Instant::now()).as_secs_f32()
                    })
                    .min(30.0);
            if let Some(s) = i
                .find_actor_mut(t)
                .and_then(NetworkedActor::status_effects_mut)
            {
                s.add_with_source(2586, 10, secs, o);
            }
            if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
                combat_state
                    .reaper
                    .marks
                    .insert(t, Instant::now() + Duration::from_secs_f32(secs));
            }
            append(&mut r, t, [buff(2586, 10, secs, false)]);
        }
    }
    if id == 24405 {
        for t in party_in_range(n, i, o, pos.0, 30.0) {
            if let Some(a) = i.find_actor_mut(t) {
                a.status_effects_mut()?.add_with_source(2599, 0, 20.0, o);
                a.status_effects_mut()?.add_with_source(2600, 1, 5.0, o);
            }
            append(
                &mut r,
                t,
                [buff(2599, 0, 20.0, false), buff(2600, 1, 5.0, false)],
            );
        }
        additions.push((2972, 0, 6));
    }
    if id == 24404 {
        if let Some(a) = i.find_actor_mut(o) {
            let cap = a.get_common_spawn().max_health_points;
            a.status_effects_mut()?
                .add_barrier(2597, 0, 5.0, cap / 10, o, cap);
            own.push(buff(2597, 0, 5.0, true));
        }
    }
    if let Some(NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    }) = i.find_actor_mut(o)
    {
        let s = &mut combat_state.reaper;
        if gcd(id) {
            for (old, valid) in [
                (2587, matches!(id, 24382..=24384)),
                (3858, matches!(id, 36970..=36972)),
            ] {
                let count = if old == 2587 {
                    &mut s.reaver
                } else {
                    &mut s.execution
                };
                if valid {
                    *count = count.saturating_sub(1);
                } else {
                    *count = 0;
                }
                if *count == 0 {
                    s.ready.remove(&old);
                    status_effects.remove(old);
                } else {
                    let duration = s.ready.get(&old).map_or(0.0, |t| {
                        t.saturating_duration_since(Instant::now()).as_secs_f32()
                    });
                    status_effects.add_with_source(old, *count as u16, duration, o);
                }
            }
        }
        if matches!(id, 24389..=24393) {
            s.soul = s.soul.saturating_sub(50);
            if hit {
                let (exec, count) = if id == 24393 { (true, 2) } else { (false, 1) };
                s.reaver = if exec { 0 } else { 1 };
                s.execution = if exec { 2 } else { 0 };
                status_effects.remove(if exec { 2587 } else { 3858 });
                s.ready.remove(&if exec { 2587 } else { 3858 });
                additions.push((if exec { 3858 } else { 2587 }, count, 30));
            }
        }
        if hit {
            let soul = match id {
                24373 | 24376 | 24386 | 24388 => 10,
                24374 | 24375 | 24377 if c.combo => 10,
                24380 | 24381 => 50,
                _ => 0,
            };
            if soul > 0 {
                s.soul = (s.soul + soul).min(100);
                own.push(gain(256, soul));
            }
            if matches!(id,24382..=24384|36970..=36972) {
                s.shroud = (s.shroud + 10).min(100);
                own.push(gain(257, 10));
            }
            if matches!(id, 24382 | 24383 | 36970 | 36971) {
                status_effects.remove(2588);
                status_effects.remove(2589);
                s.ready.remove(&2588);
                s.ready.remove(&2589);
                additions.push((
                    if matches!(id, 24382 | 36970) {
                        2589
                    } else {
                        2588
                    },
                    0,
                    60,
                ));
            }
        }
        if id == 24387 {
            s.sown = true;
            status_effects.add_with_source(2594, 0, 0.0, o);
            own.push(buff(2594, 0, 0.0, true));
        }
        if id == 24388 {
            s.sown = false;
            status_effects.remove(2594);
        }
        if id == 24385 {
            s.sacrifice = 0;
            s.ready.remove(&2592);
            status_effects.remove(2592);
            if hit {
                additions.extend([(3905, 0, 30), (3859, 0, 30)]);
            }
        }
        if id == 24394 {
            if pre.has(3905) {
                s.ready.remove(&3905);
                status_effects.remove(3905);
            } else {
                s.shroud = s.shroud.saturating_sub(50);
            }
            s.lemure = 5;
            s.void = 0;
            s.avatar_until = until(30);
            status_effects.add_with_source(2593, 0, 30.0, o);
            s.ready.remove(&3860);
            status_effects.remove(3860);
            own.push(gain(260, 0));
            additions.push((3857, 0, 30));
        }
        if matches!(id, 24395..=24397) {
            s.lemure = s.lemure.saturating_sub(1);
            if hit {
                s.void = (s.void + 1).min(5);
                own.push(gain(259, 1));
            }
            if matches!(id, 24395 | 24396) {
                for b in [2590, 2591] {
                    status_effects.remove(b);
                    s.ready.remove(&b);
                }
                if hit {
                    additions.push((if id == 24395 { 2591 } else { 2590 }, 0, 30));
                }
            }
        }
        if matches!(id, 24399 | 24400) {
            s.void = s.void.saturating_sub(2);
        }
        if id == 24398 || pre.awake() && s.lemure == 0 {
            s.lemure = 0;
            s.void = 0;
            s.avatar_until = None;
            for b in [2590, 2591, 2593, 3857] {
                status_effects.remove(b);
                s.ready.remove(&b);
            }
            if id == 24398 && pre.has(3859) {
                status_effects.remove(3859);
                s.ready.remove(&3859);
                additions.push((3860, 0, 30));
            }
        }
        if id == 36969 {
            s.ready.remove(&3857);
            status_effects.remove(3857);
        }
        if id == 36973 {
            s.ready.remove(&3860);
            status_effects.remove(3860);
        }
        if matches!(id, 24401 | 24402) {
            additions.extend([(2595, if id == 24402 { 1 } else { 0 }, 10), (2845, 0, 10)]);
        }
        if id == 24386 && c.statuses.get(2845).is_some() {
            s.ready.remove(&2845);
            status_effects.remove(2845);
        }
    }
    if let Some(a) = i.find_actor_mut(o) {
        for (b, param, seconds) in additions {
            grant(a, o, b, param, seconds);
            own.push(buff(b, param, seconds as f32, true));
        }
        if hit {
            paladin::engage_auto_attack(a, c.target);
        }
    }
    if id == 24403 {
        if let Some((_, origin, _, _)) = pre.gate {
            r.center = origin;
        }
    }
    if id == 24386 && c.statuses.get(2845).is_some() {
        super::actors::shorten_gate_cooldown(n, i, o);
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
    if r.targets.is_empty() {
        r.push(o, []);
    }
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        send_job_gauge_update(n, o, 39, combat_state.reaper.pack());
    }
    for (t, _) in &r.targets {
        white_mage::send_hp_mp(n, i, t.object_id);
    }
    Some(r)
}
