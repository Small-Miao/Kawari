use super::super::dispatch::send_job_gauge_update;
use super::super::{
    native::{self, AreaAttack, Shape, status},
    paladin, white_mage,
};
use super::*;
use crate::{
    TickDamageSnapshot, TickEffectKind,
    server::action::area::{AreaResult, party_in_range},
};
use kawari::ipc::zone::{DamageType, TargetEffect, TargetEffectKind};

pub(super) fn potency(id: u32, l: u8, combo: bool) -> u32 {
    match id {
        2866 => 140,
        2868 => {
            if combo {
                210
            } else {
                100
            }
        }
        2873 => {
            if combo {
                270
            } else {
                100
            }
        }
        7411 => {
            if l >= 94 {
                220
            } else if l >= 84 {
                200
            } else {
                180
            }
        }
        7412 => {
            if combo {
                if l >= 94 {
                    320
                } else if l >= 84 {
                    300
                } else {
                    280
                }
            } else {
                if l >= 94 {
                    140
                } else if l >= 84 {
                    120
                } else {
                    100
                }
            }
        }
        7413 => {
            if combo {
                if l >= 94 {
                    420
                } else if l >= 84 {
                    380
                } else {
                    360
                }
            } else {
                if l >= 94 {
                    160
                } else if l >= 84 {
                    120
                } else {
                    100
                }
            }
        }
        2870 => 110,
        25786 => 130,
        2872 => 240,
        2874 | 2890 => 130,
        7410 => 200,
        36978 => {
            if l >= 94 {
                240
            } else {
                220
            }
        }
        16497 => {
            if l >= 94 {
                180
            } else {
                140
            }
        }
        16498 | 16500 | 25788 => {
            if l >= 94 {
                660
            } else {
                620
            }
        }
        16499 => 50,
        36979 | 36980 => 180,
        36981 => 660,
        36982 => 900,
        _ => 0,
    }
}
pub(super) fn build(id: u32, a: &NetworkedActor, _: bool) -> Option<EffectsBuilder> {
    if minimum(id) == 0 {
        return None;
    }
    let mut r = EffectsBuilder::default();
    let l = a.get_common_spawn().level;
    match id {
        2864 | 16501 => r.effects.push(TargetEffect(TargetEffectKind::SummonPet {
            unk: [0, 0, 0, 0, 128, if id == 16501 { 18 } else { 8 }, 0],
        })),
        7415 | 16502 => r.effects.push(TargetEffect(TargetEffectKind::Unknown {
            magic: 61,
            param0: 0,
            param1: 0,
            param2: 0,
            param3: 0,
            param4: 0,
            value: 0,
        })),
        2876 => r.effects.push(status(851, 0, 5.0, true)),
        17209 => r.effects.push(status(2688, 5, 10.0, true)),
        7414 => {
            r.effects.push(status(3864, 0, 30.0, true));
            if l >= 100 {
                r.effects.push(status(3866, 0, 30.0, true));
            }
        }
        2887 => r.effects.push(status(860, 10, 10.0, false)),
        _ => {}
    }
    Some(r)
}
fn append(r: &mut AreaResult, target: ObjectId, effects: impl IntoIterator<Item = TargetEffect>) {
    if let Some((_, row)) = r.targets.iter_mut().find(|(id, _)| id.object_id == target) {
        for (slot, e) in row
            .iter_mut()
            .filter(|e| matches!(e.0, TargetEffectKind::None))
            .zip(effects)
        {
            *slot = e;
        }
    } else {
        r.push(target, effects);
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
    let l = a.get_common_spawn().level;
    let pos = a.position();
    let rot = a.get_common_spawn().rotation;
    let NetworkedActor::Player { parameters, .. } = a else {
        return None;
    };
    let parameters = parameters.clone();
    let mut r = AreaResult::new(pos);
    let id = c.action;
    let mut p = potency(id, l, c.combo);
    if p > 0 {
        let target = i
            .find_actor(c.target)
            .map(NetworkedActor::position)
            .unwrap_or(pos);
        let cone = matches!(id, 2870 | 25786 | 16497 | 16499);
        let circle = matches!(id, 2890 | 36979..=36982);
        let shape = if cone {
            Shape::Cone {
                radius: 12.0,
                half_angle: std::f32::consts::FRAC_PI_4,
            }
        } else if id == 25788 {
            Shape::Line {
                length: 25.0,
                width: 4.0,
            }
        } else {
            Shape::Circle(if circle { 5.0 } else { 0.01 })
        };
        if single_weapon(id) && c.statuses.get(2688).is_some() {
            p += 20;
        }
        let mut mods = c.modifiers;
        if id == 36982 || (weapon(id) && c.statuses.get(851).is_some()) {
            mods.roll.force_critical = true;
            mods.roll.force_direct_hit = true;
        }
        r = native::damage_area(
            i,
            c.caster,
            AreaAttack {
                center: if cone || id == 25788 { pos } else { target },
                direction: target.0 - pos.0,
                shape,
                primary: Some(c.target),
                potency: p,
                falloff: if matches!(id, 2890 | 36979 | 36980) {
                    30
                } else if matches!(id, 25788 | 36981 | 36982) {
                    25
                } else {
                    0
                },
                damage_type: DamageType::Piercing,
                limit: if !cone && !circle && id != 25788 {
                    1
                } else {
                    32
                },
            },
            mods,
        );
        let hit = |es: &[TargetEffect]| {
            es.iter()
                .any(|e| matches!(e.0, TargetEffectKind::Damage { .. }))
        };
        let landed = r.targets.iter().any(|(_, es)| hit(es));
        if id == 16499 {
            for (target, row) in &mut r.targets {
                if !hit(row) {
                    continue;
                }
                let roll = c
                    .modifiers
                    .against_target(i.find_actor(target.object_id))
                    .roll;
                if let Some(s) = i
                    .find_actor_mut(target.object_id)
                    .and_then(NetworkedActor::status_effects_mut)
                {
                    s.add_tick(
                        1866,
                        0,
                        15.0,
                        TickEffectKind::DamagePhysical,
                        50,
                        Some(TickDamageSnapshot {
                            base_amount: c
                                .modifiers
                                .apply_base_damage(parameters.calc_physical_damage(50)),
                            roll_modifiers: roll,
                        }),
                        c.caster,
                    );
                    row[1] = status(1866, 0, 15.0, false);
                }
            }
        }
        if let Some(NetworkedActor::Player {
            combat_state,
            status_effects,
            ..
        }) = i.find_actor_mut(c.caster)
        {
            let s = &mut combat_state.machinist;
            if landed {
                if l >= 30 {
                    let heat = match id {
                        2866 | 7411 | 2870 => 5,
                        2868 | 7412 | 2873 | 7413 if c.combo => 5,
                        25786 => 10,
                        _ => 0,
                    };
                    s.heat = s.heat.saturating_add(heat).min(100);
                }
                if l >= 40 {
                    let battery = match id {
                        2873 | 7413 if c.combo => 10,
                        2872 | 16500 | 25788 | 36981 => 20,
                        _ => 0,
                    };
                    s.battery = s.battery.saturating_add(battery).min(100);
                }
                if id == 25788 && l >= 96 {
                    s.excavator_until = until(30);
                    status_effects.add_with_source(3865, 0, 30.0, c.caster);
                    append(&mut r, c.caster, [status(3865, 0, 30.0, true)]);
                }
                if weapon(id)
                    && let Some(w) = &mut s.wildfire
                {
                    if w.end > Instant::now()
                        && r.targets
                            .iter()
                            .any(|(t, es)| t.object_id == w.target && hit(es))
                    {
                        w.hits = (w.hits + 1).min(6);
                    }
                }
            }
            if matches!(id, 7410 | 36978 | 16497) {
                s.overheat_stacks = s.overheat_stacks.saturating_sub(1);
                if s.overheat_stacks == 0 {
                    s.overheat_until = None;
                    status_effects.remove(2688);
                } else {
                    let duration = s.overheat_until.map_or(0.0, |t| {
                        t.saturating_duration_since(Instant::now()).as_secs_f32()
                    });
                    status_effects.add_with_source(
                        2688,
                        s.overheat_stacks as u16,
                        duration,
                        c.caster,
                    );
                }
            }
            if weapon(id) && id != 36982 {
                status_effects.remove(851);
            }
        }
        if landed && let Some(a) = i.find_actor_mut(c.caster) {
            paladin::engage_auto_attack(a, c.target);
        }
        if matches!(id, 7410 | 36978) {
            actors::reduce_shots(n, i, c.caster);
        }
    } else {
        match id {
            2878 => {
                if matches!(
                    i.find_actor(c.target),
                    Some(NetworkedActor::Npc {
                        currently_invulnerable: true,
                        ..
                    })
                ) {
                    r.push(c.target, [TargetEffect(TargetEffectKind::Invincible {})]);
                } else if let Some(target) = i.find_actor_mut(c.target) {
                    target
                        .status_effects_mut()?
                        .add_with_source(861, 0, 10.0, c.caster);
                    r.push(c.target, [status(861, 0, 10.0, false)]);
                    if let Some(NetworkedActor::Player {
                        combat_state,
                        status_effects,
                        ..
                    }) = i.find_actor_mut(c.caster)
                    {
                        combat_state.machinist.wildfire = Some(Wildfire {
                            target: c.target,
                            end: Instant::now() + Duration::from_secs(10),
                            hits: 0,
                        });
                        status_effects.add_with_source(1946, 0, 10.0, c.caster);
                        r.push(c.caster, [status(1946, 0, 10.0, true)]);
                    }
                }
            }
            7418 => {
                if let Some(NetworkedActor::Player {
                    combat_state,
                    status_effects,
                    ..
                }) = i.find_actor_mut(c.caster)
                {
                    let now = Instant::now();
                    combat_state.machinist.flame = Some(Flame {
                        position: pos,
                        rotation: rot,
                        end: now + Duration::from_secs(10),
                        next: now,
                    });
                    combat_state.paladin.auto_target = None;
                    status_effects.add_with_source(1205, 0, 10.0, c.caster);
                    r.push(c.caster, [status(1205, 0, 10.0, true)]);
                }
            }
            16889 => {
                for target in party_in_range(n, i, c.caster, pos.0, 30.0)
                    .into_iter()
                    .take(32)
                {
                    let s = i.find_actor_mut(target)?.status_effects_mut()?;
                    // 三种远敏群减不能叠加；同名可刷新。
                    if [1826, 1934].into_iter().any(|id| s.get(id).is_some()) {
                        continue;
                    }
                    let percent = if l >= 98 { 15 } else { 10 };
                    s.add_with_source(1951, percent, 15.0, c.caster);
                    r.push(target, [status(1951, percent, 15.0, false)]);
                }
            }
            _ => {}
        }
    }
    // 保留核心已应用的状态、连击通知；不能给每个范围目标重复玩家资源事件。
    append(
        &mut r,
        if id == 2887 { c.target } else { c.caster },
        c.effects
            .iter()
            .copied()
            .filter(|e| !matches!(e.0, TargetEffectKind::None)),
    );
    if r.targets.is_empty() {
        r.push(c.caster, []);
    }
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(c.caster) {
        send_job_gauge_update(n, c.caster, 31, combat_state.machinist.pack(l));
    }
    for (target, _) in &r.targets {
        white_mage::send_hp_mp(n, i, target.object_id);
    }
    Some(r)
}
