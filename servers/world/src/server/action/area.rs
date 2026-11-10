use glam::Vec3;
use kawari::{
    common::{ObjectId, ObjectTypeId, Position},
    ipc::zone::{DamageElement, DamageType, TargetEffect, TargetEffectKind},
};

use crate::{
    server::{
        action::{MAX_AOE_TARGETS, action_damage_modifiers},
        actor::{NetworkedActor, NpcState},
        director::notify_attack_hit,
        instance::Instance,
        network::NetworkState,
        party::get_party_id_from_actor_id,
    },
    zone_connection::BaseParameters,
};

pub(in crate::server) struct AreaResult {
    pub center: Position,
    pub targets: Vec<(ObjectTypeId, [TargetEffect; 8])>,
}

pub(in crate::server) struct AreaDamage {
    pub potency: u32,
    pub falloff: u32,
    pub radius: f32,
    pub damage_type: DamageType,
}

impl AreaResult {
    pub fn new(center: Position) -> Self {
        Self {
            center,
            targets: Vec::new(),
        }
    }

    pub fn push(&mut self, target: ObjectId, effects: impl IntoIterator<Item = TargetEffect>) {
        let mut row = [TargetEffect::default(); 8];
        for (slot, effect) in row.iter_mut().zip(effects) {
            *slot = effect;
        }
        self.targets.push((
            ObjectTypeId {
                object_id: target,
                ..Default::default()
            },
            row,
        ));
    }

    pub fn apply_damage(
        &mut self,
        instance: &mut Instance,
        caster: ObjectId,
        parameters: &BaseParameters,
        profile: AreaDamage,
    ) {
        let source = instance.find_actor(caster);
        let modifiers = action_damage_modifiers(source);
        let enmity = source.map_or(1, crate::server::jobs::paladin::enmity_multiplier);
        let capacity = MAX_AOE_TARGETS.saturating_sub(self.targets.len());
        for (index, id) in enemies_in_range(instance, self.center.0, profile.radius)
            .into_iter()
            .take(capacity)
            .enumerate()
        {
            let potency = if index == 0 {
                profile.potency
            } else {
                profile.potency * (100 - profile.falloff) / 100
            };
            let base = if profile.damage_type == DamageType::Magic {
                parameters.calc_magical_damage(potency)
            } else {
                parameters.calc_physical_damage(potency)
            };
            let (amount, kind) = parameters
                .roll_damage_with_modifiers(modifiers.apply_base_damage(base), modifiers.roll);
            let actor = instance.find_actor_mut(id).unwrap();
            if matches!(
                actor,
                NetworkedActor::Npc {
                    currently_invulnerable: true,
                    ..
                }
            ) {
                self.push(id, [TargetEffect(TargetEffectKind::Invincible {})]);
                continue;
            }
            actor.apply_damage(amount);
            if let Some(hate) = actor.npc_hate_list_mut() {
                let total = hate.entry(caster).or_default();
                *total = total.saturating_add(amount.saturating_mul(enmity));
            }
            notify_attack_hit(instance, caster, id, amount);
            self.push(
                id,
                [TargetEffect(TargetEffectKind::Damage {
                    damage_kind: kind,
                    damage_type: profile.damage_type,
                    damage_element: DamageElement::Unaspected,
                    bonus_percent: 0,
                    unk3: 0,
                    unk4: 0,
                    amount,
                })],
            );
        }
    }
}

pub(in crate::server) fn enemies_in_range(
    instance: &Instance,
    center: Vec3,
    radius: f32,
) -> Vec<ObjectId> {
    let mut actors: Vec<_> = instance
        .actors
        .iter()
        .filter_map(|(id, actor)| {
            let NetworkedActor::Npc {
                state,
                targetable,
                spawn,
                ..
            } = actor
            else {
                return None;
            };
            let distance = actor.position().0.distance_squared(center);
            (*state != NpcState::Dead
                && *targetable
                && spawn.common.health_points > 0
                && !spawn.common.owner_id.is_valid()
                && distance <= radius * radius)
                .then_some((*id, distance))
        })
        .collect();
    actors.sort_by(|a, b| a.1.total_cmp(&b.1).then(a.0.0.cmp(&b.0.0)));
    actors.into_iter().map(|(id, _)| id).collect()
}

pub(in crate::server) fn party_in_range(
    network: &NetworkState,
    instance: &Instance,
    caster: ObjectId,
    center: Vec3,
    radius: f32,
) -> Vec<ObjectId> {
    let party = get_party_id_from_actor_id(network, caster).and_then(|id| network.parties.get(&id));
    let mut recipients = vec![caster];
    if let Some(party) = party {
        for member in &party.members {
            if member.is_valid() && !recipients.contains(&member.actor_id) {
                recipients.push(member.actor_id);
            }
        }
    }
    recipients.retain(|id| {
        matches!(instance.find_actor(*id), Some(actor @ NetworkedActor::Player { .. })
            if actor.get_common_spawn().health_points > 0 && actor.position().0.distance(center) <= radius)
    });
    recipients
}
