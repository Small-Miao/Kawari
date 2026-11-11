//! 原生职业共用的协议效果构造，不包含职业规则。
use kawari::ipc::zone::{DamageElement, DamageType, TargetEffect, TargetEffectKind};

pub fn status(id: u16, param: u16, duration: f32, on_self: bool) -> TargetEffect {
    TargetEffect(if on_self {
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

pub fn damage(amount: u32, damage_type: DamageType) -> TargetEffect {
    TargetEffect(TargetEffectKind::Damage {
        damage_kind: Default::default(),
        damage_type,
        damage_element: DamageElement::Unaspected,
        bonus_percent: 0,
        unk3: 0,
        unk4: 0,
        amount,
    })
}

pub fn heal(amount: u32, on_self: bool) -> TargetEffect {
    TargetEffect(TargetEffectKind::Heal {
        amount,
        unk1: [0, 0, 0, 0, if on_self { 0x80 } else { 0 }],
    })
}

pub fn lose(id: u16, on_self: bool) -> TargetEffect {
    TargetEffect(TargetEffectKind::Unknown {
        magic: 17,
        param0: 0,
        param1: 0,
        param2: 0,
        param3: 0,
        param4: if on_self { 0x80 } else { 0 },
        value: id,
    })
}

pub fn mp(amount: u16) -> TargetEffect {
    TargetEffect(TargetEffectKind::MpGain {
        params: [0, 0, 0, 0, 0x80],
        amount,
    })
}

/// 原生职业共用的命中几何；直线使用水平长度和全宽，不用圆形近似。
#[derive(Debug, Clone, Copy)]
pub enum Shape {
    Circle(f32),
    Line { length: f32, width: f32 },
    Cone { radius: f32, half_angle: f32 },
}

pub fn targets(
    instance: &crate::server::instance::Instance,
    center: glam::Vec3,
    direction: glam::Vec3,
    shape: Shape,
) -> Vec<kawari::common::ObjectId> {
    let bound = match shape {
        Shape::Circle(r) | Shape::Cone { radius: r, .. } => r,
        Shape::Line { length, width } => length.hypot(width * 0.5),
    };
    let forward = glam::Vec2::new(direction.x, direction.z).normalize_or_zero();
    crate::server::action::area::enemies_in_range(instance, center, bound)
        .into_iter()
        .filter(|id| {
            let offset = instance.find_actor(*id).unwrap().position().0 - center;
            let flat = glam::Vec2::new(offset.x, offset.z);
            match shape {
                Shape::Circle(r) => flat.length_squared() <= r * r,
                Shape::Line { length, width } => {
                    let depth = flat.dot(forward);
                    depth >= 0.0 && depth <= length && flat.perp_dot(forward).abs() <= width * 0.5
                }
                Shape::Cone { radius, half_angle } => {
                    flat.length_squared() <= radius * radius
                        && (flat.length_squared() < 0.001
                            || flat.normalize().dot(forward) >= half_angle.cos())
                }
            }
        })
        .collect()
}

pub struct AreaAttack {
    pub center: kawari::common::Position,
    pub direction: glam::Vec3,
    pub shape: Shape,
    pub primary: Option<kawari::common::ObjectId>,
    pub potency: u32,
    pub falloff: u32,
    pub damage_type: DamageType,
    pub limit: usize,
}

/// 返回逐目标结算；调用者据伤害效果统计有效命中，不能把无敌目标计入触发次数。
pub fn damage_area(
    instance: &mut crate::server::instance::Instance,
    caster: kawari::common::ObjectId,
    attack: AreaAttack,
    modifiers: crate::server::action::ActionDamageModifiers,
) -> crate::server::action::area::AreaResult {
    damage_area_snapshot(instance, caster, attack, modifiers, None)
}

pub fn damage_area_snapshot(
    instance: &mut crate::server::instance::Instance,
    caster: kawari::common::ObjectId,
    attack: AreaAttack,
    modifiers: crate::server::action::ActionDamageModifiers,
    snapshot: Option<&crate::zone_connection::BaseParameters>,
) -> crate::server::action::area::AreaResult {
    use crate::server::{action::area::AreaResult, actor::NetworkedActor};
    let mut result = AreaResult::new(attack.center);
    let Some(actor) = instance.find_actor(caster) else {
        return result;
    };
    let NetworkedActor::Player { parameters, .. } = actor else {
        return result;
    };
    let parameters = snapshot.unwrap_or(parameters).clone();
    let enmity = super::paladin::enmity_multiplier(actor);
    let mut ids = targets(instance, attack.center.0, attack.direction, attack.shape);
    if let Some(primary) = attack.primary {
        ids.sort_by_key(|id| *id != primary);
    }
    for (index, id) in ids.into_iter().take(attack.limit.min(32)).enumerate() {
        let potency = if index > 0 {
            attack.potency * (100 - attack.falloff.min(100)) / 100
        } else {
            attack.potency
        };
        let base = if attack.damage_type == DamageType::Magic {
            parameters.calc_magical_damage(potency)
        } else {
            parameters.calc_physical_damage(potency)
        };
        let mut modifiers=modifiers;
        modifiers.source_actor_id=Some(caster);
        let modifiers=modifiers.against_target(instance.find_actor(id));
        let (amount, kind) = parameters
            .roll_damage_with_modifiers(modifiers.apply_base_damage(base), modifiers.roll);
        let Some(target) = instance.find_actor_mut(id) else {
            continue;
        };
        if matches!(
            target,
            NetworkedActor::Npc {
                currently_invulnerable: true,
                ..
            }
        ) {
            result.push(id, [TargetEffect(TargetEffectKind::Invincible {})]);
            continue;
        }
        target.apply_damage(amount);
        if let Some(hate) = target.npc_hate_list_mut() {
            let v = hate.entry(caster).or_default();
            *v = v.saturating_add(amount.saturating_mul(enmity));
        }
        crate::server::director::notify_attack_hit(instance, caster, id, amount);
        let mut effect = damage(amount, attack.damage_type);
        if let TargetEffectKind::Damage { damage_kind, .. } = &mut effect.0 {
            *damage_kind = kind;
        }
        result.push(id, [effect]);
    }
    result
}
