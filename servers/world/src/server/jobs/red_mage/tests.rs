use super::*;
use crate::server::action::{action_damage_modifiers, area::AreaResult};
use kawari::{common::Position, ipc::zone::SpawnNpc};
fn fixture() -> (Instance, NetworkState, ObjectId, ObjectId) {
    let mut i = Instance::default();
    let o = ObjectId(0x10000001);
    let e = ObjectId(0x40000001);
    i.insert_empty_actor(o);
    let a = i.find_actor_mut(o).unwrap();
    let c = a.get_common_spawn_mut();
    c.class_job = 35;
    c.level = 100;
    c.health_points = 10000;
    c.max_health_points = 10000;
    if let NetworkedActor::Player {
        parameters,
        combat_state,
        ..
    } = a
    {
        parameters.classjob_id = 35;
        parameters.level = 100;
        parameters.intelligence = 1000;
        parameters.magic_damage = 100;
        combat_state.in_combat = true;
    }
    let mut s = SpawnNpc::default();
    s.common.health_points = 1000000;
    s.common.max_health_points = 1000000;
    s.common.owner_id = ObjectId(0xE0000000);
    s.common.position = Position(glam::Vec3::new(0.0, 0.0, 2.0));
    i.insert_npc(e, s);
    (i, NetworkState::default(), o, e)
}
fn act(
    i: &mut Instance,
    n: &mut NetworkState,
    o: ObjectId,
    e: ObjectId,
    id: u32,
    combo: bool,
) -> AreaResult {
    let a = i.find_actor(o).unwrap();
    let statuses = a.status_effects().unwrap().clone();
    let modifiers = action_damage_modifiers(Some(a));
    effects::apply(
        n,
        i,
        JobAreaContext {
            caster: o,
            target: e,
            action: id,
            combo,
            ground: None,
            statuses: &statuses,
            effects: &[],
            modifiers,
        },
    )
    .unwrap()
}
#[test]
fn red_mage_recorded_free_swordplay_does_not_grant_mana() {
    let (mut i, mut n, o, e) = fixture();
    act(&mut i, &mut n, o, e, 37004, false);
    act(&mut i, &mut n, o, e, 7521, false);
    for id in [45960, 45961, 45962] {
        act(&mut i, &mut n, o, e, id, true);
    }
    if let NetworkedActor::Player { combat_state, .. } = i.find_actor(o).unwrap() {
        assert_eq!(combat_state.red_mage.pack().to_le_bytes()[..3], [2, 2, 3]);
        assert_eq!(combat_state.red_mage.free, 0);
    }
    for id in [7526, 16530, 25858] {
        act(&mut i, &mut n, o, e, id, true);
    }
    if let NetworkedActor::Player { combat_state, .. } = i.find_actor(o).unwrap() {
        assert_eq!(combat_state.red_mage.pack().to_le_bytes()[..3], [21, 10, 0]);
    }
}
#[test]
fn red_mage_grand_impact_keeps_dualcast_and_acceleration() {
    let (mut i, mut n, o, e) = fixture();
    act(&mut i, &mut n, o, e, 7518, false);
    act(&mut i, &mut n, o, e, 16525, false);
    act(&mut i, &mut n, o, e, 37006, false);
    let a = i.find_actor(o).unwrap();
    for id in [1238, 1249] {
        assert!(a.status_effects().unwrap().get(id).is_some());
    }
    act(&mut i, &mut n, o, e, 16524, false);
    assert!(
        i.find_actor(o)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(1249)
            .is_none()
    );
    act(&mut i, &mut n, o, e, 25855, false);
    let a = i.find_actor(o).unwrap();
    assert!(a.status_effects().unwrap().get(1238).is_none());
    assert!(a.status_effects().unwrap().get(1234).is_some());
    assert!(a.status_effects().unwrap().get(1249).is_none());
}
#[test]
fn red_mage_resource_imbalance_and_expiry_gate_actions() {
    let mut c = PlayerCombatState::default();
    c.red_mage.white = 50;
    c.red_mage.black = 20;
    c.red_mage.gain(0, 7);
    assert_eq!(c.red_mage.black, 27);
    c.red_mage.black = 19;
    c.red_mage.gain(0, 7);
    assert_eq!(c.red_mage.black, 22);
    c.red_mage.white = 0;
    assert!(!RedMage.can_execute(7527, &c, 100));
    c.red_mage.mark(3875, 30);
    c.red_mage.free = 3;
    assert!(RedMage.can_execute(7527, &c, 100));
    c.red_mage
        .ready
        .insert(3875, Instant::now() - Duration::from_secs(1));
    assert!(!RedMage.can_execute(7527, &c, 100));
    assert!(!RedMage.can_execute(16530, &c, 100));
}
#[test]
fn red_mage_magick_barrier_only_reduces_magic() {
    let (mut i, _, o, _) = fixture();
    let a = i.find_actor_mut(o).unwrap();
    a.status_effects_mut()
        .unwrap()
        .add_with_source(2707, 0, 10.0, o);
    assert_eq!(mitigation(a, DamageType::Magic), 0.9);
    assert_eq!(mitigation(a, DamageType::Slashing), 1.0);
    assert_eq!(
        super::super::white_mage::incoming_heal_multiplier(Some(a)),
        1.05
    );
}
