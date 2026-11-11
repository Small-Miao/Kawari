use super::super::{
    dispatch::send_job_gauge_update,
    native::{self, AreaAttack, Shape, status},
    paladin, scholar, white_mage,
};
use super::*;
use crate::{
    TickEffectKind,
    server::action::area::{AreaResult, party_in_range},
};
use kawari::ipc::zone::{DamageType, TargetEffect, TargetEffectKind};
pub(super) fn potency(id: u32, l: u8) -> u32 {
    match id {
        53 => {
            if l >= 84 {
                220
            } else {
                180
            }
        }
        54 => {
            if l >= 84 {
                300
            } else {
                260
            }
        }
        56 => {
            if l >= 84 {
                270
            } else {
                230
            }
        }
        61 => {
            if l >= 94 {
                420
            } else if l >= 84 {
                380
            } else {
                340
            }
        }
        66 => {
            if l >= 94 {
                360
            } else if l >= 84 {
                320
            } else {
                280
            }
        }
        74 => {
            if l >= 94 {
                320
            } else if l >= 84 {
                280
            } else {
                240
            }
        }
        62 => 110,
        70 => 150,
        16473 => 140,
        25767 => 120,
        25761 => 180,
        3547 => {
            if l >= 84 {
                400
            } else {
                310
            }
        }
        25763 => 100,
        16474 => 160,
        16476 => {
            if l >= 94 {
                780
            } else {
                710
            }
        }
        3543 => 1200,
        3545 | 25882 => 800,
        25765 => 600,
        25768 | 36948 => 900,
        25769 => {
            if l >= 94 {
                1500
            } else {
                1400
            }
        }
        36945 => 260,
        36946 => 340,
        36947 => 310,
        36949 => 1040,
        36950 => 1400,
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
        69 => b.effects.push(status(110, 3, 20.0, true)),
        4262 => b.effects.push(status(2513, 0, 30.0, true)),
        7394 => {
            b.effects.push(status(1179, 20, 10.0, true));
            b.effects.push(status(3841, 0, 30.0, true));
        }
        7395 => {
            b.effects.push(status(1181, 15, 20.0, true));
            if l >= 100 {
                b.effects.push(status(3843, 0, 20.0, true));
            }
        }
        25766 => {
            b.effects.push(status(2687, 50, 15.0, true));
            if l >= 96 {
                b.effects.push(status(3842, 0, 15.0, true));
            }
        }
        _ => {}
    }
    Some(b)
}
fn append(r: &mut AreaResult, id: ObjectId, effects: impl IntoIterator<Item = TargetEffect>) {
    if let Some((_, row)) = r.targets.iter_mut().find(|(t, _)| t.object_id == id) {
        for (slot, e) in row
            .iter_mut()
            .filter(|e| matches!(e.0, TargetEffectKind::None))
            .zip(effects)
        {
            *slot = e;
        }
    } else {
        r.push(id, effects);
    }
}
pub(in crate::server) fn positional(a: &NetworkedActor, t: &NetworkedActor, rear: bool) -> bool {
    if a.status_effects().is_some_and(|s| s.get(1250).is_some()) {
        return true;
    }
    let delta = a.position().0 - t.position().0;
    let angle = delta.x.atan2(delta.z) - t.get_common_spawn().rotation;
    let cos = angle.cos();
    if rear {
        cos <= -std::f32::consts::FRAC_1_SQRT_2
    } else {
        cos.abs() <= std::f32::consts::FRAC_1_SQRT_2
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
    let pstats = parameters.clone();
    let s = combat_state.monk.clone();
    let l = spawn.common.level;
    let pos = a.position();
    let id = c.action;
    let mut p = potency(id, l);
    let mut r = AreaResult::new(pos);
    let mut self_effects = Vec::new();
    let f = form(id);
    if p > 0 {
        if matches!(id, 53 | 36945) && s.fury[0] > 0 {
            p += 200;
        }
        if matches!(id, 54 | 36946) && s.fury[1] > 0 {
            p += 200;
        }
        if matches!(id, 56 | 36947) && s.fury[2] > 0 {
            p += 150;
        }
        if matches!(id, 56 | 36947 | 66)
            && i.find_actor(c.target)
                .is_some_and(|t| positional(a, t, id == 66))
        {
            p += 60;
        }
        if id == 62 && s.allowed_form(1) {
            p = 120;
        }
        if id == 16476 {
            p += 80 * u32::from(s.chakra);
        }
        let mut mods = c.modifiers;
        if matches!(id, 53 | 36945 | 25767) && s.allowed_form(1) {
            mods.roll.force_critical = true;
        }
        let target = i
            .find_actor(c.target)
            .map(NetworkedActor::position)
            .unwrap_or(pos);
        let self_circle = matches!(id, 62 | 70 | 16473 | 25767 | 3545 | 25882 | 25768 | 36948);
        let line = matches!(id, 25763 | 16474 | 36949);
        let target_circle = matches!(id, 3543 | 25769 | 36950);
        let shape = if line {
            Shape::Line {
                length: 10.0,
                width: 4.0,
            }
        } else {
            Shape::Circle(if self_circle || target_circle {
                5.0
            } else {
                0.01
            })
        };
        r = native::damage_area(
            i,
            c.caster,
            AreaAttack {
                center: if self_circle || line { pos } else { target },
                direction: target.0 - pos.0,
                shape,
                primary: Some(c.target),
                potency: p,
                falloff: if blitz(id) && id != 25765 || matches!(id, 36949 | 36950) {
                    35
                } else {
                    0
                },
                damage_type: DamageType::Blunt,
                limit: if self_circle || line || target_circle {
                    31
                } else {
                    1
                },
            },
            mods,
        );
        let landed = r.targets.iter().any(|(_, es)| {
            es.iter()
                .any(|e| matches!(e.0, TargetEffectKind::Damage { .. }))
        });
        if landed {
            let a = i.find_actor_mut(c.caster)?;
            paladin::engage_auto_attack(a, c.target);
            let NetworkedActor::Player {
                combat_state,
                status_effects,
                ..
            } = a
            else {
                return None;
            };
            let m = &mut combat_state.monk;
            match id {
                53 | 36945 => m.fury[0] = m.fury[0].saturating_sub(1),
                54 | 36946 => m.fury[1] = m.fury[1].saturating_sub(1),
                56 | 36947 => m.fury[2] = m.fury[2].saturating_sub(1),
                74 if s.allowed_form(1) => m.fury[0] = 1,
                61 => m.fury[1] = 1,
                66 => m.fury[2] = 2,
                _ => {}
            }
            if f > 0 {
                for old in [107, 108, 109, 2513] {
                    status_effects.remove(old);
                }
                m.formless_until = None;
                if s.balance > 0 && active(s.balance_until) {
                    if l >= 60
                        && let Some(slot) = m.beast.iter_mut().find(|x| **x == 0)
                    {
                        *slot = f;
                        if !m.beast.contains(&0){m.blitz_until = until(20);}
                    }
                    m.balance = m.balance.saturating_sub(1);
                    m.form = 0;
                    m.form_until = None;
                    if m.balance == 0 {
                        m.balance_until = None;
                        status_effects.remove(110);
                    } else {
                        status_effects.add_with_source(
                            110,
                            m.balance as u16,
                            s.balance_until
                                .unwrap()
                                .saturating_duration_since(Instant::now())
                                .as_secs_f32(),
                            c.caster,
                        );
                    }
                } else {
                    let next = f % 3 + 1;
                    m.form = next;
                    m.form_until = until(30);
                    status_effects.add_with_source(106 + u16::from(next), 0, 30.0, c.caster);
                    self_effects.push(status(106 + u16::from(next), 0, 30.0, true));
                }
            }
            if matches!(id, 25761 | 3547 | 25763 | 16474) {
                m.chakra = m.chakra.saturating_sub(5);
            }
            if id == 16476 {
                m.chakra = 0;
                status_effects.add_with_source(2514, 20, 5.0, c.caster);
                self_effects.push(status(2514, 20, 5.0, true));
            }
            if blitz(id) {
                match id {
                    3543 | 25769 => m.nadi = 0,
                    3545 | 36948 => m.nadi |= 1,
                    25882 | 25768 => m.nadi |= 2,
                    25765 => m.nadi |= if m.nadi & 1 != 0 { 2 } else { 1 },
                    _ => {}
                }
                m.beast = [0; 3];
                m.blitz_until = None;
            }
            if blitz(id) || id == 36950 {
                m.formless_until = until(30);
                status_effects.add_with_source(2513, 0, 30.0, c.caster);
                self_effects.push(status(2513, 0, 30.0, true));
            }
            if id == 36949 {
                m.wind_until = None;
                status_effects.remove(3842);
            }
            if id == 36950 {
                m.fire_until = None;
                status_effects.remove(3843);
            }
        }
        // 每次战技仅产生一次身形/资源事件，保留录像里的连击动作标识。
        self_effects.push(TargetEffect(TargetEffectKind::ExecuteCombo {
            sequence: 0,
            unk2: 0,
            unk3: 0,
            unk4: 0,
            unk5: 128,
            action_id: id as u16,
        }));
    } else {
        match id {
            65 | 7396 => {
                for target in party_in_range(n, i, c.caster, pos.0, 30.0)
                    .into_iter()
                    .take(32)
                {
                    let a = i.find_actor_mut(target)?;
                    let status_effects = a.status_effects_mut()?;
                    if id == 65 {
                        status_effects.add_with_source(104, 10, 15.0, c.caster);
                        r.push(target, [status(104, 10, 15.0, false)]);
                    } else {
                        let chance = if target == c.caster && l >= 88 {
                            100
                        } else {
                            20
                        };
                        status_effects.add_with_source(1182, chance, 20.0, c.caster);
                        status_effects.add_with_source(1185, 5, 20.0, c.caster);
                        r.push(
                            target,
                            [
                                status(1182, chance, 20.0, false),
                                status(1185, 5, 20.0, false),
                            ],
                        );
                    }
                }
            }
            36944 => {
                for target in party_in_range(n, i, c.caster, pos.0, 5.0)
                    .into_iter()
                    .take(32)
                {
                    let (base, crit) = pstats.roll_heal_amount(
                        if c.statuses.get(1180).is_some() {
                            500
                        } else {
                            300
                        },
                        false,
                    );
                    let amount = (base as f64
                        * white_mage::incoming_heal_multiplier(i.find_actor(target)))
                        as u32;
                    scholar::restore(i, c.caster, target, amount);
                    r.push(target, [scholar::critical_heal(amount, crit)]);
                }
                if let Some(NetworkedActor::Player {
                    combat_state,
                    status_effects,
                    ..
                }) = i.find_actor_mut(c.caster)
                {
                    combat_state.monk.earth_until = None;
                    status_effects.remove(3841);
                }
            }
            69 => {
                if let Some(NetworkedActor::Player {
                    combat_state,
                    status_effects,
                    ..
                }) = i.find_actor_mut(c.caster)
                {
                    combat_state.monk.form = 0;
                    combat_state.monk.form_until = None;
                    for old in [107, 108, 109] {
                        status_effects.remove(old);
                    }
                }
            }
            _ => {}
        }
    }
    append(
        &mut r,
        c.caster,
        self_effects.into_iter().chain(
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
        send_job_gauge_update(n, c.caster, 20, combat_state.monk.pack(l));
    }
    for (t, _) in &r.targets {
        white_mage::send_hp_mp(n, i, t.object_id);
    }
    Some(r)
}
/// 所有职业的实际命中在一次动作结束后通知；能力、自动攻击与宠物不会触发金兰。
pub(in crate::server) fn notify_action(
    n: &mut NetworkState,
    i: &mut Instance,
    source: ObjectId,
    id: u32,
    category: u8,
    hit: bool,
    critical: bool,
) {
    if !matches!(category, 2 | 3) || category==3&&!hit {
        return;
    }
    let Some(a) = i.find_actor(source) else {
        return;
    };
    let c = a.get_common_spawn();
    let l = c.level;
    let own = matches!(c.class_job, 2 | 20);
    let brothers = a
        .status_effects()
        .map(|s|s.data().into_iter().filter(|s|s.effect_id==1182&&s.duration>0.0).map(|s|(s.source_actor_id,s.param)).collect::<Vec<_>>()).unwrap_or_default();
    if own
        && category == 3
        && id != 16476
        && critical
        && l >= 38
        && (l >= 74 || fastrand::u8(0..100) < 80)
    {
        if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(source) {
            combat_state.monk.gain(1);
        }
    }
    for (owner, chance) in brothers {
        if fastrand::u16(0..100) < chance
            && let Some(NetworkedActor::Player {
                combat_state,
                spawn,
                ..
            }) = i.find_actor_mut(owner)
        {
            if spawn.common.class_job == 20 && spawn.common.health_points > 0 {
                combat_state.monk.gain(1);
                send_job_gauge_update(n, owner, 20, combat_state.monk.pack(spawn.common.level));
            }
        }
    }
    if own && let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(source) {
        send_job_gauge_update(n, source, 20, combat_state.monk.pack(l));
    }
}
pub(super) fn tick(n: &mut NetworkState, i: &mut Instance, o: ObjectId) {
    let Some(a @ NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) else {
        return;
    };
    if !combat_state.monk.earth_hit {
        return;
    }
    let multiplier = white_mage::incoming_heal_multiplier(Some(a));
    if let Some(NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    }) = i.find_actor_mut(o)
    {
        combat_state.monk.earth_hit = false;
        status_effects.add_tick(1180, 0, 15.0, TickEffectKind::Heal, 100, None, o);
        status_effects.snapshot_healing_multiplier(1180, o, multiplier);
    }
    white_mage::send_hp_mp(n, i, o);
}
