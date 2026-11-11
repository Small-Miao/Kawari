//! 职能效果的共用结算；持续伤害和宠物攻击不触发浴血。
use super::white_mage;
use crate::server::{actor::NetworkedActor, instance::Instance, network::NetworkState};
use kawari::{
    common::ObjectId,
    ipc::zone::{ActorControlCategory, DamageType, TargetEffect, TargetEffectKind},
};

pub(in crate::server) fn bloodbath_amount(
    actor: &NetworkedActor,
    effects: impl IntoIterator<Item = TargetEffect>,
) -> u32 {
    if !actor
        .status_effects()
        .is_some_and(|s| s.get(84).is_some_and(|s| s.duration > 0.0))
    {
        return 0;
    }
    effects
        .into_iter()
        .filter_map(|e| match e.0 {
            TargetEffectKind::Damage {
                amount,
                damage_type: DamageType::Slashing | DamageType::Piercing | DamageType::Blunt,
                ..
            } => Some(amount / 4),
            _ => None,
        })
        .fold(0u32, u32::saturating_add)
}
pub(in crate::server) fn heal_from_damage(
    n: &mut NetworkState,
    i: &mut Instance,
    o: ObjectId,
    effects: impl IntoIterator<Item = TargetEffect>,
) {
    let Some(a) = i.find_actor_mut(o) else {
        return;
    };
    let amount = bloodbath_amount(a, effects);
    if amount == 0 || a.get_common_spawn().health_points == 0 {
        return;
    }
    a.apply_heal(amount);
    n.send_ac_in_range_inclusive_instance(
        i,
        o,
        ActorControlCategory::TickHeal {
            amount,
            source_actor_id: o,
            status_id: 84,
            unk2: 0,
            unk3: 0,
        },
    );
    white_mage::send_hp_mp(n, i, o);
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn crowd_control_distinguishes_bind_and_wakes_sleep_on_damage() {
        let mut i = Instance::default();
        let o = ObjectId(1);
        i.insert_empty_actor(o);
        let a = i.find_actor_mut(o).unwrap();
        a.get_common_spawn_mut().health_points = 1000;
        a.status_effects_mut()
            .unwrap()
            .add_with_source(13, 0, 6.0, o);
        assert!(a.is_movement_locked());
        assert!(!a.is_action_locked());
        a.status_effects_mut()
            .unwrap()
            .add_with_source(3, 0, 30.0, o);
        assert!(a.is_action_locked());
        a.apply_damage(100);
        assert!(!a.is_action_locked());
        assert!(!a.is_movement_locked());
        a.status_effects_mut()
            .unwrap()
            .add_with_source(2, 0, 3.0, o);
        a.apply_damage(100);
        assert!(a.is_action_locked());
    }
    #[test]
    fn bloodbath_counts_each_physical_hit_but_not_magic_or_invulnerability() {
        let mut i = Instance::default();
        let o = ObjectId(1);
        i.insert_empty_actor(o);
        let a = i.find_actor_mut(o).unwrap();
        a.status_effects_mut()
            .unwrap()
            .add_with_source(84, 0, 20.0, o);
        let effects = [
            super::super::native::damage(1000, DamageType::Slashing),
            super::super::native::damage(1200, DamageType::Piercing),
            super::super::native::damage(800, DamageType::Magic),
            TargetEffect(TargetEffectKind::Invincible {}),
        ];
        assert_eq!(bloodbath_amount(a, effects), 550);
        a.status_effects_mut().unwrap().remove(84);
        assert_eq!(bloodbath_amount(a, effects), 0);
    }
}
