use super::super::{
    dispatch::send_job_gauge_update,
    native::{self, AreaAttack, Shape},
    paladin, scholar, white_mage,
};
use super::*;
use crate::{
    TickEffectKind,
    server::action::{
        area::{AreaResult, party_in_range},
        send_area_action_result,
    },
};
use kawari::{
    common::ObjectTypeId,
    ipc::zone::{DamageType, TargetEffect, TargetEffectKind},
};
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
fn bonus(id: u16, amount: i8, param: u16, duration: f32, own: bool) -> TargetEffect {
    let mut e = native::status(id, param, duration, own);
    match &mut e.0 {
        TargetEffectKind::GainEffect { unk1, .. }
        | TargetEffectKind::GainEffectSelf { unk1, .. } => *unk1 = amount as u8,
        _ => {}
    }
    e
}
fn grant(
    i: &mut Instance,
    r: &mut AreaResult,
    o: ObjectId,
    t: ObjectId,
    id: u16,
    amount: i8,
    duration: f32,
    own: bool,
) {
    if let Some(s) = i
        .find_actor_mut(t)
        .and_then(NetworkedActor::status_effects_mut)
    {
        s.add_with_source(id, 0, duration, o);
        s.set_magnitude(id, amount.unsigned_abs() as u16);
        append(r, t, [bonus(id, amount, 0, duration, own)]);
    }
}
fn ready(i: &mut Instance, r: &mut AreaResult, o: ObjectId, id: u16, duration: u64) {
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
        combat_state
            .dancer
            .ready
            .insert(id, Instant::now() + Duration::from_secs(duration));
    }
    grant(i, r, o, o, id, 0, duration as f32, true);
}
fn consume(i: &mut Instance, o: ObjectId, id: u16) {
    if let Some(NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    }) = i.find_actor_mut(o)
    {
        combat_state.dancer.ready.remove(&id);
        status_effects.remove(id);
    }
}
pub(super) fn unlink(i: &mut Instance, o: ObjectId) {
    let partner = if let Some(NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    }) = i.find_actor_mut(o)
    {
        status_effects.remove(1823);
        combat_state.dancer.partner.take()
    } else {
        None
    };
    if let Some(p) = partner
        && let Some(s) = i
            .find_actor_mut(p)
            .and_then(NetworkedActor::status_effects_mut)
    {
        if s.get(1824).is_some_and(|s| s.source_actor_id == o) {
            s.remove(1824);
        }
        if s.get(1847).is_some_and(|s| s.source_actor_id == o) {
            s.remove(1847);
        }
    }
}
fn pair(n: &NetworkState, i: &Instance, o: ObjectId) -> Vec<ObjectId> {
    let mut v = vec![o];
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o)
        && let Some(p) = combat_state.dancer.partner
    {
        let center = i.find_actor(o).unwrap().position().0;
        if party_in_range(n, i, o, center, 30.0).contains(&p)
            && i.find_actor(p)
                .and_then(NetworkedActor::status_effects)
                .is_some_and(|s| s.get(1824).is_some_and(|s| s.source_actor_id == o))
        {
            v.push(p);
        }
    }
    v
}
fn standard_buff(
    n: &NetworkState,
    i: &mut Instance,
    r: &mut AreaResult,
    o: ObjectId,
    amount: u8,
    l: u8,
) {
    for t in pair(n, i, o) {
        grant(i, r, o, t, 1821, amount as i8, 60.0, false);
        if l >= 76 {
            grant(i, r, o, t, 1847, 0, 60.0, false);
        }
    }
}
pub(super) fn potency(id: u32, l: u8, combo: bool) -> u32 {
    match id {
        15989 => {
            if l >= 94 {
                220
            } else {
                200
            }
        }
        15990 => (if l >= 94 { 120 } else { 100 }) + if combo { 160 } else { 0 },
        15991 => {
            if l >= 94 {
                280
            } else {
                260
            }
        }
        15992 => {
            if l >= 94 {
                340
            } else {
                320
            }
        }
        15993 => 120,
        15994 => {
            if combo {
                160
            } else {
                100
            }
        }
        15995 => 160,
        15996 => 200,
        16007 => {
            if l >= 94 {
                180
            } else {
                150
            }
        }
        16008 => 100,
        16009 => {
            if l >= 94 {
                220
            } else {
                200
            }
        }
        16005 => {
            if l >= 94 {
                540
            } else {
                480
            }
        }
        25791 => {
            if l >= 94 {
                460
            } else {
                420
            }
        }
        25792 | 25790 => 600,
        36983 => 540,
        36984 => 850,
        36985 => 1000,
        16003 => 360,
        16191 => 540,
        16192 => {
            if l >= 94 {
                850
            } else {
                720
            }
        }
        16004 => 350,
        16193 => 540,
        16194 => 720,
        16195 => 900,
        16196 => {
            if l >= 94 {
                1300
            } else {
                1200
            }
        }
        _ => 0,
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
        combat_state,
        parameters,
        spawn,
        ..
    } = a
    else {
        return None;
    };
    let pre = combat_state.dancer.clone();
    let stats = parameters.clone();
    let pos = a.position();
    let rot = spawn.common.rotation;
    let l = spawn.common.level;
    let id = c.action;
    let o = c.caster;
    let mut r = AreaResult::new(pos);
    let p = potency(id, l, c.combo);
    if p > 0 {
        let target = i
            .find_actor(c.target)
            .map(NetworkedActor::position)
            .unwrap_or(pos);
        let self_area = matches!(id, 15993..=15996 | 16008 | 25790) || finisher(id);
        let aoe = matches!(id, 16005 | 16009 | 36983 | 36985);
        let cone = id == 25791;
        let line = id == 25792;
        let mut mods = c.modifiers;
        if line {
            mods.roll.force_critical = true;
            mods.roll.force_direct_hit = true;
        }
        r = native::damage_area(
            i,
            o,
            AreaAttack {
                center: if self_area || cone || line {
                    pos
                } else {
                    target
                },
                direction: target.0 - pos.0,
                shape: if cone {
                    Shape::Cone {
                        radius: 15.0,
                        half_angle: std::f32::consts::FRAC_PI_4,
                    }
                } else if line {
                    Shape::Line {
                        length: 25.0,
                        width: 4.0,
                    }
                } else {
                    Shape::Circle(if finisher(id) || id == 25790 {
                        15.0
                    } else if self_area || aoe {
                        5.0
                    } else {
                        0.01
                    })
                },
                primary: Some(c.target),
                potency: p,
                falloff: if line {
                    75
                } else if aoe || cone || finisher(id) || id == 25790 {
                    60
                } else {
                    0
                },
                damage_type: DamageType::Slashing,
                limit: if self_area || aoe || cone || line {
                    24
                } else {
                    1
                },
            },
            mods,
        );
        let hit = r.targets.iter().any(|(_, es)| {
            es.iter()
                .any(|e| matches!(e.0, TargetEffectKind::Damage { .. }))
        });
        if matches!(id, 15991 | 15995 | 15992 | 15996) {
            let (normal, flourish) = if matches!(id, 15991 | 15995) {
                (2693, 3017)
            } else {
                (2694, 3018)
            };
            consume(i, o, if pre.has(normal) { normal } else { flourish });
        }
        for (action, buff) in [
            (16009, 1820),
            (25790, 2698),
            (25791, 2699),
            (25792, 2700),
            (36983, 3867),
            (36984, 3868),
            (36985, 3869),
        ] {
            if id == action {
                consume(i, o, buff);
            }
        }
        if hit && l >= 30 && matches!(id, 15991 | 15992 | 15995 | 15996) && fastrand::bool() {
            if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
                combat_state.dancer.feathers = (combat_state.dancer.feathers + 1).min(4);
            }
            append(
                &mut r,
                o,
                [TargetEffect(TargetEffectKind::Unknown {
                    magic: 62,
                    param0: 1,
                    param1: 0,
                    param2: 0,
                    param3: 0,
                    param4: 128,
                    value: 235,
                })],
            );
        }
        if hit && matches!(id, 15989 | 15993) && fastrand::bool() {
            ready(i, &mut r, o, 2693, 30);
        }
        if hit && c.combo && matches!(id, 15990 | 15994) && fastrand::bool() {
            ready(i, &mut r, o, 2694, 30);
        }
        if matches!(id, 16007 | 16008) {
            if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
                combat_state.dancer.feathers = combat_state.dancer.feathers.saturating_sub(1);
            }
            if hit && l >= 66 && fastrand::bool() {
                ready(i, &mut r, o, 1820, 30);
            }
        }
        if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
            let s = &mut combat_state.dancer;
            if matches!(id, 16005 | 36985) {
                s.esprit = s.esprit.saturating_sub(50);
            }
            if hit && id == 25790 {
                s.esprit = (s.esprit + 50).min(100);
            }
            if hit
                && (15989..=15996).contains(&id)
                && l >= 76
                && (c.statuses.get(1847).is_some() || c.statuses.get(1848).is_some())
            {
                let gain = if l >= 84 && matches!(id, 15991 | 15992 | 15995 | 15996) {
                    10
                } else {
                    5
                };
                s.esprit = (s.esprit + gain).min(100);
                append(
                    &mut r,
                    o,
                    [TargetEffect(TargetEffectKind::Unknown {
                        magic: 62,
                        param0: gain,
                        param1: 0,
                        param2: 0,
                        param3: 0,
                        param4: 128,
                        value: 236,
                    })],
                );
            }
        }
        if hit && id == 25790 {
            append(
                &mut r,
                o,
                [TargetEffect(TargetEffectKind::Unknown {
                    magic: 62,
                    param0: 50,
                    param1: 0,
                    param2: 0,
                    param3: 0,
                    param4: 128,
                    value: 236,
                })],
            );
        }
        if standard(id) {
            let count = if id == 36984 { 2 } else { pre.index };
            if count > 0 {
                standard_buff(n, i, &mut r, o, if count == 2 { 5 } else { 2 }, l);
                if l >= 92 {
                    ready(i, &mut r, o, 3867, 30);
                }
            }
        }
        if technical(id) && pre.index > 0 {
            let amount = [0, 1, 2, 3, 5][pre.index as usize];
            if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
                combat_state.dancer.technical =
                    Some((Instant::now() + Duration::from_millis(533), amount));
            }
            append(
                &mut r,
                o,
                [TargetEffect(TargetEffectKind::Unknown {
                    magic: 61,
                    param0: 0,
                    param1: 0,
                    param2: 0,
                    param3: 0,
                    param4: 0,
                    value: 0,
                })],
            );
            if l >= 82 {
                ready(i, &mut r, o, 2698, 30);
            }
            if l >= 100 {
                ready(i, &mut r, o, 3869, 30);
            }
        }
        if finisher(id)
            && let Some(NetworkedActor::Player {
                combat_state,
                status_effects,
                ..
            }) = i.find_actor_mut(o)
        {
            combat_state.dancer.end_dance();
            status_effects.remove(1818);
            status_effects.remove(1819);
        }
        if hit && let Some(a) = i.find_actor_mut(o) {
            paladin::engage_auto_attack(a, c.target);
        }
    } else {
        match id {
            15997 | 15998 => {
                let mut steps = [1, 2, 3, 4];
                for x in (1..4).rev() {
                    steps.swap(x, fastrand::usize(0..=x));
                }
                let count = if id == 15997 { 2 } else { 4 };
                if count == 2 {
                    steps[2..].fill(0);
                }
                if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
                    let s = &mut combat_state.dancer;
                    s.steps = steps;
                    s.index = 0;
                    s.dance = count;
                    s.dance_until = Some(Instant::now() + Duration::from_secs(15));
                }
                grant(
                    i,
                    &mut r,
                    o,
                    o,
                    if count == 2 { 1818 } else { 1819 },
                    0,
                    15.0,
                    false,
                );
            }
            15999..=16002 => {
                if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
                    let s = &mut combat_state.dancer;
                    if s.index < s.dance && s.steps[s.index as usize] == (id - 15998) as u8 {
                        s.index += 1;
                    }
                }
            }
            16006 => {
                unlink(i, o);
                if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
                    combat_state.dancer.partner = Some(c.target);
                }
                grant(i, &mut r, o, o, 1823, 0, 0.0, true);
                grant(i, &mut r, o, c.target, 1824, 0, 0.0, false);
            }
            18073 => unlink(i, o),
            16011 => {
                for t in pair(n, i, o) {
                    grant(i, &mut r, o, t, 1825, 20, 20.0, false);
                }
                if l >= 90 {
                    ready(i, &mut r, o, 2700, 20);
                }
            }
            16012 => {
                for t in party_in_range(n, i, o, pos.0, 30.0).into_iter().take(32) {
                    if let Some(s) = i
                        .find_actor_mut(t)
                        .and_then(NetworkedActor::status_effects_mut)
                    {
                        s.remove(1934);
                        s.remove(1951);
                    }
                    grant(
                        i,
                        &mut r,
                        o,
                        t,
                        1826,
                        if l >= 98 { -15 } else { -10 },
                        15.0,
                        false,
                    );
                }
            }
            16013 => {
                for buff in [3017, 3018, 1820] {
                    ready(i, &mut r, o, buff, 30);
                }
                if l >= 86 {
                    ready(i, &mut r, o, 2699, 30);
                }
                if l >= 96 {
                    ready(i, &mut r, o, 3868, 30);
                }
            }
            16015 => {
                for center in pair(n, i, o) {
                    let center = i.find_actor(center)?.position();
                    for t in party_in_range(n, i, o, center.0, 5.0).into_iter().take(8) {
                        let (base, crit) = stats.roll_heal_amount(300, false);
                        let amount = (base as f64
                            * white_mage::incoming_heal_multiplier(i.find_actor(t)))
                            as u32;
                        scholar::restore(i, o, t, amount);
                        append(&mut r, t, [scholar::critical_heal(amount, crit)]);
                    }
                }
            }
            16014 => {
                let now = Instant::now();
                if let Some(NetworkedActor::Player {
                    combat_state,
                    status_effects,
                    ..
                }) = i.find_actor_mut(o)
                {
                    combat_state.dancer.improvisation = Some((
                        pos,
                        rot,
                        now + Duration::from_secs(15),
                        now + Duration::from_secs(3),
                        0,
                    ));
                    combat_state.paladin.auto_target = None;
                    status_effects.add_with_source(1827, 7001, 15.0, o);
                }
                append(&mut r, o, [native::status(1827, 89, 15.0, true)]);
                regen(n, i, o, pos);
            }
            25789 => {
                let stacks = pre.improvisation.map_or(0, |x| x.4);
                let amount = [5, 6, 7, 8, 10][stacks as usize];
                for t in party_in_range(n, i, o, pos.0, 8.0).into_iter().take(32) {
                    let a = i.find_actor_mut(t)?;
                    let max = a.get_common_spawn().max_health_points;
                    a.status_effects_mut()?.add_barrier(
                        2697,
                        0,
                        30.0,
                        max * amount / 100,
                        o,
                        u32::MAX,
                    );
                    append(&mut r, t, [bonus(2697, 0, 0, 30.0, false)]);
                }
                if let Some(NetworkedActor::Player {
                    combat_state,
                    status_effects,
                    ..
                }) = i.find_actor_mut(o)
                {
                    combat_state.dancer.improvisation = None;
                    status_effects.remove(1827);
                    status_effects.remove(2696);
                }
            }
            _ => {}
        }
    }
    append(
        &mut r,
        o,
        c.effects
            .iter()
            .copied()
            .filter(|e| matches!(e.0, TargetEffectKind::ExecuteCombo { .. })),
    );
    if r.targets.is_empty() {
        r.push(o, []);
    }
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        send_job_gauge_update(n, o, 38, combat_state.dancer.pack());
    }
    for (t, _) in &r.targets {
        white_mage::send_hp_mp(n, i, t.object_id);
    }
    Some(r)
}
fn regen(n: &NetworkState, i: &mut Instance, o: ObjectId, pos: Position) {
    for t in party_in_range(n, i, o, pos.0, 8.0) {
        let multiplier = white_mage::incoming_heal_multiplier(i.find_actor(t));
        if let Some(s) = i
            .find_actor_mut(t)
            .and_then(NetworkedActor::status_effects_mut)
        {
            s.add_tick(2695, 0, 15.0, TickEffectKind::Heal, 100, None, o);
            s.snapshot_healing_multiplier(2695, o, multiplier);
        }
    }
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
    let pre = combat_state.dancer.clone();
    let pos = a.position();
    let rot = spawn.common.rotation;
    let alive = spawn.common.health_points > 0;
    let l = spawn.common.level;
    let now = Instant::now();
    if let Some((at, amount)) = pre.technical
        && now >= at
    {
        if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
            combat_state.dancer.technical = None;
        }
        if alive {
            let mut r = AreaResult::new(pos);
            for t in party_in_range(n, i, o, pos.0, 30.0).into_iter().take(32) {
                grant(i, &mut r, o, t, 1822, amount as i8, 20.0, false);
                if l >= 76 {
                    grant(i, &mut r, o, t, 1848, 0, 20.0, false);
                }
            }
            send_area_action_result(
                n,
                i,
                o,
                33218,
                ActionRequest {
                    action_id: 33218,
                    target: ObjectTypeId {
                        object_id: o,
                        ..Default::default()
                    },
                    ..Default::default()
                },
                r,
            );
        }
    }
    if let Some((origin, facing, end, mut next, mut stacks)) = pre.improvisation {
        let moved = origin.0.distance_squared(pos.0) > 0.0001 || (facing - rot).cos() < 0.9999;
        let mut pulse = false;
        if !moved && alive {
            while now >= next && next <= end {
                stacks = (stacks + 1).min(4);
                next += Duration::from_secs(3);
                pulse = true;
            }
        }
        if let Some(NetworkedActor::Player {
            combat_state,
            status_effects,
            ..
        }) = i.find_actor_mut(o)
        {
            if moved || !alive || now >= end {
                combat_state.dancer.improvisation = None;
                status_effects.remove(1827);
            } else {
                combat_state.dancer.improvisation = Some((origin, facing, end, next, stacks));
            }
            if pulse {
                status_effects.add_with_source(2696, stacks as u16, 30.0, o);
            }
        }
        if pulse {
            regen(n, i, o, pos);
        }
    }
}
/// 队友的伶俐由有效战技/魔法结算触发，不受目标数量影响；同一舞者的两种伶俐不重复计数。
pub(in crate::server) fn notify_action(
    n: &mut NetworkState,
    i: &mut Instance,
    source: ObjectId,
    category: u8,
    hit: bool,
) {
    if !matches!(category, 2 | 3) || category == 3 && !hit {
        return;
    }
    let Some(a) = i.find_actor(source) else {
        return;
    };
    let Some(s) = a.status_effects() else {
        return;
    };
    let mut owners = Vec::new();
    for e in s.data() {
        if matches!(e.effect_id, 1847 | 1848)
            && e.duration > 0.0
            && e.source_actor_id != source
            && !owners.contains(&e.source_actor_id)
        {
            owners.push(e.source_actor_id);
        }
    }
    // 国服逐职业概率尚无足够录像，集中保留 20% 近似值，审计文档明确标注。
    for owner in owners {
        if fastrand::u8(0..100) >= 20 {
            continue;
        }
        if let Some(NetworkedActor::Player {
            combat_state,
            spawn,
            ..
        }) = i.find_actor_mut(owner)
            && spawn.common.class_job == 38
            && spawn.common.health_points > 0
        {
            combat_state.dancer.esprit = (combat_state.dancer.esprit + 10).min(100);
            send_job_gauge_update(n, owner, 38, combat_state.dancer.pack());
        }
    }
}
