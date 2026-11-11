//! 职业临时召唤物在结算后保留演出时间，再释放演员与客户端宠物绑定。

use crate::{
    ClientId, FromServer,
    server::{
        instance::{Instance, QueuedTaskData},
        network::{DestinationNetwork, NetworkState},
    },
};
use kawari::{common::ObjectId, ipc::zone::ActorControlCategory};
use std::time::Duration;

pub(crate) fn retire(instance: &mut Instance, owner: ObjectId, actor: ObjectId) {
    let bell = instance
        .find_actor(actor)
        .is_some_and(|p| p.get_common_spawn().pet_id == 33);
    for (delay, stage) in [
        (if bell { 1000 } else { 550 }, 0),
        (if bell { 3100 } else { 2600 }, 1),
        (if bell { 3700 } else { 3200 }, 2),
    ] {
        instance.insert_task(
            ClientId::default(),
            actor,
            Duration::from_millis(delay),
            QueuedTaskData::RetireJobPet {
                owner_id: owner,
                actor_id: actor,
                stage,
            },
        );
    }
}

pub(crate) fn finish(
    network: &mut NetworkState,
    instance: &mut Instance,
    owner: ObjectId,
    actor: ObjectId,
    stage: u8,
) {
    let Some(pet) = instance.find_actor(actor) else {
        return;
    };
    let common = pet.get_common_spawn();
    if common.owner_id != owner {
        return;
    }
    let pet_row = common.pet_id;
    if stage == 0 {
        if let Some(pet) = instance.find_actor_mut(actor) {
            pet.get_common_spawn_mut().health_points = 0;
            pet.get_common_spawn_mut().mode = kawari::common::CharacterMode::Dead;
            if let crate::server::actor::NetworkedActor::Npc { state, .. } = pet {
                *state = crate::server::actor::NpcState::Dead;
            }
        }
        network.send_ac_in_range_instance(
            instance,
            actor,
            ActorControlCategory::Kill { animation_id: 0 },
        );
        network.send_ac_in_range_instance(
            instance,
            actor,
            ActorControlCategory::SetMode {
                mode: kawari::common::CharacterMode::Dead,
                mode_arg: 0,
            },
        );
        return;
    }
    if stage == 1 {
        network.send_ac_in_range_instance(instance, actor, ActorControlCategory::DeadFadeOut {});
        return;
    }
    let class_job = match pet_row {
        11 => 33,
        33 => 24,
        _ => return,
    };
    // 旧爆炸结束时，新放置的地星/铃或切职后的召唤兽不能被解绑。
    let clear_binding = instance
        .find_actor(owner)
        .is_some_and(|p| p.get_common_spawn().class_job == class_job)
        && !instance.actors.iter().any(|(id, a)| {
            *id != actor
                && a.common_spawn()
                    .is_some_and(|c| c.owner_id == owner && c.pet_id != 0)
        });
    if clear_binding {
        network.send_to_by_actor_id(
            owner,
            FromServer::ActorControlSelf(ActorControlCategory::SetupPet {
                owner_id: owner,
                pet_id: pet_row,
                pet_actor_id: ObjectId(0xE0000000),
                dismiss: 1,
                storage_target: 1,
            }),
            DestinationNetwork::ZoneClients,
        );
    }
    network.remove_actor(instance, actor);
}
