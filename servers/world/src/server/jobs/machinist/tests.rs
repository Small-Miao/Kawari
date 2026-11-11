use super::*;
use crate::server::action::action_damage_modifiers;
use kawari::ipc::zone::{SpawnNpc, TargetEffectKind};
fn fixture() -> (Instance, NetworkState, ObjectId, ObjectId) {
    let mut i = Instance::default();
    let owner = ObjectId(0x10000001);
    let enemy = ObjectId(0x40000001);
    i.insert_empty_actor(owner);
    let a = i.find_actor_mut(owner).unwrap();
    let c = a.get_common_spawn_mut();
    c.class_job = 31;
    c.level = 100;
    c.health_points = 100000;
    c.max_health_points = 100000;
    if let NetworkedActor::Player { parameters, .. } = a {
        parameters.classjob_id = 31;
        parameters.level = 100;
        parameters.dexterity = 1000;
        parameters.physical_damage = 100;
    }
    let mut spawn = SpawnNpc::default();
    spawn.common.owner_id = ObjectId(0xE0000000);
    spawn.common.health_points = 1000000;
    spawn.common.max_health_points = 1000000;
    spawn.common.position = Position(glam::Vec3::new(0.0, 0.0, 5.0));
    i.insert_npc(enemy, spawn);
    (i, NetworkState::default(), owner, enemy)
}
fn attack(
    i: &mut Instance,
    n: &mut NetworkState,
    owner: ObjectId,
    enemy: ObjectId,
    id: u32,
    combo: bool,
) -> crate::server::action::area::AreaResult {
    let a = i.find_actor(owner).unwrap();
    let statuses = a.status_effects().cloned().unwrap_or_default();
    let mods = action_damage_modifiers(Some(a));
    effects::apply(
        n,
        i,
        JobAreaContext {
            caster: owner,
            target: enemy,
            action: id,
            combo,
            ground: None,
            statuses: &statuses,
            effects: &[],
            modifiers: mods,
        },
    )
    .unwrap()
}
#[test]
fn machinist_combo_aliases_and_level_traits() {
    let s = MachinistState::default();
    for (input, l, output) in [
        (2866, 53, 2866),
        (2866, 54, 7411),
        (2864, 79, 2864),
        (2864, 80, 16501),
        (2874, 91, 2874),
        (2874, 92, 36979),
    ] {
        assert_eq!(s.resolve(input, l), output);
    }
    assert_eq!(Machinist.combo_action_id(7411), 2866);
    assert_eq!(Machinist.combo_action_id(7412), 2868);
    assert_eq!(effects::potency(7413, 83, true), 360);
    assert_eq!(effects::potency(7413, 84, true), 380);
    assert_eq!(effects::potency(7413, 94, true), 420);
    assert!(!Machinist.can_execute(36978, &PlayerCombatState::default(), 100));
}
#[test]
fn machinist_resource_and_reassemble_rules_do_not_depend_on_target_count() {
    let (mut i, mut n, o, e) = fixture();
    let e2 = ObjectId(0x40000002);
    let mut spawn = SpawnNpc::default();
    spawn.common.owner_id = ObjectId(0xE0000000);
    spawn.common.health_points = 1000000;
    spawn.common.max_health_points = 1000000;
    spawn.common.position = Position(glam::Vec3::new(0.0, 0.0, 6.0));
    i.insert_npc(e2, spawn);
    attack(&mut i, &mut n, o, e, 25786, false);
    attack(&mut i, &mut n, o, e, 7413, true);
    let a = i.find_actor_mut(o).unwrap();
    if let NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    } = a
    {
        assert_eq!(combat_state.machinist.heat, 15);
        assert_eq!(combat_state.machinist.battery, 10);
        status_effects.add_with_source(851, 0, 5.0, o);
    }
    let r = attack(&mut i, &mut n, o, e, 36982, false);
    assert_eq!(
        r.targets
            .iter()
            .filter(|(_, row)| row
                .iter()
                .any(|x| matches!(x.0, TargetEffectKind::Damage { .. })))
            .count(),
        2
    );
    assert!(
        i.find_actor(o)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(851)
            .is_some()
    );
    attack(&mut i, &mut n, o, e, 16498, false);
    assert!(
        i.find_actor(o)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(851)
            .is_none()
    );
}
#[test]
fn machinist_wildfire_counts_weapons_once_and_excludes_abilities() {
    let (mut i, mut n, o, e) = fixture();
    attack(&mut i, &mut n, o, e, 2878, false);
    for id in [7411, 36979, 7412, 36980, 7413, 16498, 16500, 25788, 36981] {
        attack(&mut i, &mut n, o, e, id, true);
    }
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor(o) {
        assert_eq!(combat_state.machinist.wildfire.as_ref().unwrap().hits, 6);
    }
    let before = i.find_actor(e).unwrap().get_common_spawn().health_points;
    Machinist.spawn_pet_after_action(&mut n, &mut i, o, 16766, e);
    let after = i.find_actor(e).unwrap().get_common_spawn().health_points;
    assert!(after < before);
    Machinist.spawn_pet_after_action(&mut n, &mut i, o, 16766, e);
    assert_eq!(
        i.find_actor(e).unwrap().get_common_spawn().health_points,
        after
    );
}
#[test]
fn machinist_flamethrower_stops_on_turn_and_zone_clears_robot() {
    let (mut i, mut n, o, e) = fixture();
    attack(&mut i, &mut n, o, e, 7418, false);
    Machinist.on_tick(&mut n, &mut i, o);
    let hp = i.find_actor(e).unwrap().get_common_spawn().health_points;
    assert!(hp < 1000000);
    i.find_actor_mut(o).unwrap().get_common_spawn_mut().rotation = 1.0;
    Machinist.on_tick(&mut n, &mut i, o);
    assert!(
        i.find_actor(o)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(1205)
            .is_none()
    );
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
        combat_state.machinist.battery = 70;
    }
    Machinist.update_state_after_action(16501, i.find_actor_mut(o).unwrap(), o);
    if let Some(NetworkedActor::Player { combat_state, .. }) = i.find_actor_mut(o) {
        combat_state.machinist.pet.as_mut().unwrap().start -= Duration::from_secs(1);
    }
    Machinist.on_tick(&mut n, &mut i, o);
    assert!(i.actors.values().any(|a|a.get_common_spawn().owner_id==o&&a.get_common_spawn().model_chara==2618));
    take_for_zone(&mut n, &mut i, o);
    assert!(
        !i.actors
            .values()
            .any(|a| a.get_common_spawn().owner_id == o)
    );
}
#[test]
fn machinist_heat_blast_uses_five_stacks_and_fixed_speed() {
    let (mut i, mut n, o, e) = fixture();
    if let Some(NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    }) = i.find_actor_mut(o)
    {
        combat_state.machinist.overheat_until = until(10);
        combat_state.machinist.overheat_stacks = 5;
        status_effects.add_with_source(2688, 5, 10.0, o);
    }
    for _ in 0..5 {
        attack(&mut i, &mut n, o, e, 36978, false);
    }
    let a = i.find_actor(o).unwrap();
    assert!(a.status_effects().unwrap().get(2688).is_none());
    assert_eq!(Machinist.recast_100ms(36978, a), Some(15));
    assert!(Machinist.fixed_recast(36978));
}
