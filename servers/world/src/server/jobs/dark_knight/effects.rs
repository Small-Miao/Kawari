//! 技能效果、命中几何与范围结算。编号取自本地国服表和 DRK-03 录像。
use super::*;
use crate::lua::{BarrierAction, EffectsBuilder, EnmityAction};
use crate::server::action::area::{AreaResult, party_in_range};
use crate::server::jobs::{
    native::{self, AreaAttack, Shape, damage, heal, lose, mp, status},
    paladin, white_mage,
};
use kawari::ipc::zone::{DamageType, TargetEffect, TargetEffectKind};

fn tier(level: u8, a: u32, b: u32, c: u32) -> u32 {
    if level >= 94 {
        c
    } else if level >= 84 {
        b
    } else {
        a
    }
}
pub(super) fn potency(id: u32, level: u8, combo: bool) -> u32 {
    match id {
        3617 => tier(level, 150, 180, 300),
        3623 => {
            if combo {
                tier(level, 240, 260, 380)
            } else {
                tier(level, 100, 120, 240)
            }
        }
        3632 => {
            if combo {
                tier(level, 320, 360, 480)
            } else {
                tier(level, 100, 140, 260)
            }
        }
        3621 => 120,
        3624 => 150,
        3641 => 240,
        3643 => {
            if level >= 94 {
                540
            } else {
                510
            }
        }
        7391 => {
            if level >= 94 {
                240
            } else {
                200
            }
        }
        7392 => {
            if level >= 94 {
                600
            } else {
                500
            }
        }
        16466 => 100,
        16467 => 300,
        16469 => 160,
        16470 => 460,
        16468 => {
            if combo {
                if level >= 94 { 160 } else { 140 }
            } else if level >= 94 {
                120
            } else {
                100
            }
        }
        25757 => 600,
        36928 => 620,
        36929 => 720,
        36930 => 820,
        36931 => 300,
        36932 => 1000,
        _ => 0,
    }
}
pub(super) fn magic(id: u32) -> bool {
    matches!(id, 3621 | 3624 | 3641 | 16466..=16470 | 25757)
}
pub(super) fn shape(id: u32) -> Option<Shape> {
    match id {
        3621 | 3641 | 7391 | 16468 | 36931 => Some(Shape::Circle(5.0)),
        16466 | 16469 | 25757 | 36932 => Some(Shape::Line {
            length: 10.0,
            width: 4.0,
        }),
        _ => None,
    }
}
pub(super) fn geometry(
    instance: &Instance,
    caster: ObjectId,
    target: ObjectId,
    id: u32,
) -> Option<(Position, glam::Vec3, Shape)> {
    let actor = instance.find_actor(caster)?;
    let center = if id == 3641 {
        instance.find_actor(target)?.position()
    } else {
        actor.position()
    };
    let direction = instance
        .find_actor(target)
        .filter(|_| target != caster)
        .map(|t| t.position().0 - actor.position().0)
        .unwrap_or_else(|| {
            let r = actor.get_common_spawn().rotation;
            glam::Vec3::new(r.sin(), 0.0, r.cos())
        });
    Some((center, direction, shape(id)?))
}
pub(super) fn effects(
    id: u32,
    actor: &NetworkedActor,
    target: Option<&NetworkedActor>,
    combo: bool,
) -> Option<EffectsBuilder> {
    if matches!(id, 7531 | 7533 | 7535 | 7537 | 7538 | 7540 | 7548) {
        return paladin::action_effects(id, actor, combo);
    }
    let NetworkedActor::Player {
        spawn,
        parameters,
        combat_state,
        status_effects,
        ..
    } = actor
    else {
        return None;
    };
    let level = spawn.common.level;
    let p = potency(id, level, combo);
    let mut r = EffectsBuilder::default();
    if p > 0 && shape(id).is_none() {
        r.effects.push(damage(
            if magic(id) {
                parameters.calc_magical_damage(p)
            } else {
                parameters.calc_physical_damage(p)
            },
            if magic(id) {
                DamageType::Magic
            } else {
                DamageType::Slashing
            },
        ));
    }
    match id {
        3617 | 3621 | 3623 | 3624 | 7391 | 7392 | 16468 | 25757 | 36928..=36931 => {}
        3632 => {
            if combo {
                r.effects.push(heal(parameters.calc_heal_amount(300), true));
            }
        }
        3643 => r.effects.push(heal(parameters.calc_heal_amount(500), true)),
        3641 => {} // 吸收深渊逐命中目标治疗。
        3629 => r.effects.push(status(743, 0, 604800.0, true)),
        32067 => r.effects.push(lose(743, true)),
        3625 | 7390 => {
            r.effects.push(status(742, 3, 15.0, true));
            if id == 7390 {
                r.effects
                    .push(status(if level >= 96 { 3836 } else { 1972 }, 3, 15.0, true));
            }
        }
        3634 => r.effects.push(status(746, 0, 10.0, true)),
        3636 => r.effects.push(status(747, 0, 15.0, true)),
        36927 => r
            .effects
            .extend([status(3835, 0, 15.0, true), status(3902, 0, 20.0, true)]),
        3638 => r.effects.push(status(810, 0, 10.0, true)),
        3639 => r.effects.push(status(749, 0, 15.0, true)),
        25755 => {}
        7393 => {
            let cap = target.unwrap_or(actor).get_common_spawn().max_health_points;
            r.effects.push(status(1178, 0, 7.0, false));
            r.barrier_actions.push(BarrierAction {
                effect_id: 1178,
                param: 0,
                duration: 7.0,
                amount: cap / 4,
                on_self: false,
            });
        }
        25754 => r.effects.push(status(2682, 0, 10.0, false)),
        16471 => {} // 队伍结算统一下发，避免施法者重复。
        16472 => {
            r.effects.push(TargetEffect(TargetEffectKind::SummonPet {
                unk: [0, 0, 0, 0, 0x80, 17, 0],
            }));
            if level >= 100 {
                r.effects.push(status(3837, 0, 30.0, true));
            }
        }
        36932 => r.effects.push(lose(3837, true)),
        36926 => r.enmity_actions.push(EnmityAction::Add { amount: 10000 }),
        16466 | 16467 | 16469 | 16470 => r.effects.push(TargetEffect(TargetEffectKind::Unknown {
            magic: 62,
            param0: 0,
            param1: 0,
            param2: 0,
            param3: 0,
            param4: 0x80,
            value: 249,
        })),
        _ => return None,
    }
    let restored = combat_state.dark_knight.mp_on_hit(id, combo);
    if restored > 0 {
        r.effects.push(mp(restored));
    }
    if gcd(id) && shape(id).is_none() && live(status_effects, 811) {
        r.effects
            .push(heal(parameters.calc_heal_amount(1500), true));
    }
    if id == 3624 {
        r.enmity_actions.push(EnmityAction::Add { amount: 10000 });
    }
    Some(r)
}

pub(super) fn area(
    network: &mut NetworkState,
    instance: &mut Instance,
    ctx: JobAreaContext<'_>,
) -> Option<AreaResult> {
    if ctx.action == 7535 {
        let effects = std::array::from_fn(|i| ctx.effects.get(i).copied().unwrap_or_default());
        return paladin::apply_area_action(
            network,
            instance,
            ctx.caster,
            ctx.action,
            ctx.combo,
            ctx.statuses,
            &effects,
        );
    }
    let actor = instance.find_actor(ctx.caster)?;
    let NetworkedActor::Player { parameters, .. } = actor else {
        return None;
    };
    let parameters = parameters.clone();
    let level = actor.get_common_spawn().level;
    let position = actor.position();
    if ctx.action == 16471 {
        let mut result = AreaResult::new(position);
        for id in party_in_range(network, instance, ctx.caster, position.0, 30.0)
            .into_iter()
            .take(32)
        {
            instance
                .find_actor_mut(id)?
                .status_effects_mut()?
                .add_with_source(1894, 0, 15.0, ctx.caster);
            result.push(id, [status(1894, 0, 15.0, false)]);
        }
        return Some(result);
    }
    let (center, direction, shape) = geometry(instance, ctx.caster, ctx.target, ctx.action)?;
    let mut result = native::damage_area(
        instance,
        ctx.caster,
        AreaAttack {
            center,
            direction,
            shape,
            primary: Some(ctx.target),
            potency: potency(ctx.action, level, ctx.combo),
            falloff: if matches!(ctx.action, 25757 | 36932) {
                25
            } else {
                0
            },
            damage_type: if magic(ctx.action) {
                DamageType::Magic
            } else {
                DamageType::Slashing
            },
            limit: 31,
        },
        ctx.modifiers,
    );
    let hits = result
        .targets
        .iter()
        .filter(|(_, e)| {
            e.iter()
                .any(|e| matches!(e.0, TargetEffectKind::Damage { .. }))
        })
        .count() as u32;
    let mut self_effects: Vec<_> = ctx
        .effects
        .iter()
        .copied()
        .filter(|e| {
            !matches!(
                e.0,
                TargetEffectKind::None | TargetEffectKind::ExecuteCombo { .. }
            )
        })
        .collect();
    let heal_potency = if ctx.action == 3641 {
        500
    } else if gcd(ctx.action) && live(ctx.statuses, 811) {
        1500
    } else {
        0
    };
    if hits > 0 && heal_potency > 0 {
        let amount = (parameters.calc_heal_amount(heal_potency) * hits) as f64
            * white_mage::incoming_heal_multiplier(instance.find_actor(ctx.caster));
        instance
            .find_actor_mut(ctx.caster)?
            .apply_heal(amount as u32);
        self_effects.push(heal(amount as u32, true));
    }
    if !self_effects.is_empty() {
        result.push(ctx.caster, self_effects);
    }
    Some(result)
}
