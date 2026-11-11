//! Job dispatch scaffolding: a `Job` lifecycle trait, a separate `JobActors` capability seam for
//! job-owned persistent actors/VFX/tasks, and a `job_for` registry that resolves a `class_job` id to
//! a `&'static dyn Job`.
//!
//! Each trait method is a thin delegating wrapper over an existing per-job free fn (see `bard.rs` /
//! `summoner.rs`), so routing a call site through the trait produces byte-identical behavior. Job
//! impls are zero-sized unit structs (`struct Bard;` / `struct Summoner;`) — all mutable state
//! already lives in `PlayerCombatState`.

use std::sync::Arc;

use parking_lot::Mutex;

use crate::FromServer;
use crate::gamedata::GameData;
use crate::lua::GaugeAction;
use crate::server::actor::NetworkedActor;
use crate::server::combat_state::{CarriedPet, PlayerCombatState};
use crate::server::instance::Instance;
use crate::server::jobs::astrologian::Astrologian;
use crate::server::jobs::bard::Bard;
use crate::server::jobs::paladin::Paladin;
use crate::server::jobs::summoner::Summoner;
use crate::server::network::{DestinationNetwork, NetworkState};
use kawari::common::ObjectId;
use kawari::ipc::zone::{ActionRequest, ServerZoneIpcData, ServerZoneIpcSegment, TargetEffect};

/// Unified per-action state-update result. Superset of the two existing job structs; jobs that don't
/// use a field leave it at `Default`.
#[derive(Debug, Default, Clone, Copy)]
pub(in crate::server) struct JobActionUpdate {
    /// Mirror `JobRefreshResult`; populated for job-wiring symmetry, not yet read on the action path.
    #[allow(dead_code)]
    pub changed: bool,
    /// Mirror `JobRefreshResult`; populated for job-wiring symmetry, not yet read on the action path.
    #[allow(dead_code)]
    pub status_timer_refreshed: bool,
    pub cooldown_update: Option<JobCooldownUpdate>,
}

/// Unified runtime-refresh result (superset of Bard/Summoner refresh results).
#[derive(Debug, Default, Clone, Copy)]
pub(in crate::server) struct JobRefreshResult {
    pub changed: bool,
    pub status_timer_refreshed: bool,
    /// Summoner-only; `false` for every other job.
    pub demi_just_ended: bool,
    pub cooldown_update: Option<JobCooldownUpdate>,
}

/// Neutral cooldown-update shape (field-identical to `bard::BardCooldownUpdate`).
#[derive(Debug, Default, Clone, Copy)]
pub(in crate::server) struct JobCooldownUpdate {
    pub cooldown_group: u32,
    /// Relative cooldown reduction in centiseconds.
    pub delta_centisec: u32,
}

/// Per-action lifecycle for a combat job. Implemented by ZST unit structs. All heavy logic stays in
/// the job module; each method delegates to the existing free fn.
pub(in crate::server) trait Job: Sync {
    /// Dispatch key(s) this job answers to (class + category ids), for the registry only.
    fn class_jobs(&self) -> &'static [u8];

    /// 原生效果优先于同 ID 的旧 Lua；未接管的动作继续走原有脚本。
    fn action_effects(
        &self,
        _action: u32,
        _actor: &NetworkedActor,
        _target: Option<&NetworkedActor>,
        _combo: bool,
    ) -> Option<crate::lua::EffectsBuilder> {
        None
    }

    fn preserves_combo(&self, _action: u32) -> bool {
        false
    }

    /// 升级战技沿用基础连击编号，与客户端 ActionCombo 和 ExecuteCombo 一致。
    fn combo_action_id(&self, action: u32) -> u16 { action as u16 }

    fn after_combo(&self, _action: u32, _actor: &mut NetworkedActor, _owner: ObjectId) {}

    fn forced_critical_direct(&self, _action: u32, _actor: &NetworkedActor) -> bool {
        false
    }

    fn hit_test(
        &self,
        _instance: &Instance,
        _caster: ObjectId,
        _target: ObjectId,
        _action: u32,
    ) -> bool {
        true
    }

    fn filter_missed_effects(&self, _action:u32, _effects: &mut crate::lua::EffectsBuilder) {}

    fn animation_lock(&self, _action: u32) -> f32 {
        0.6
    }

    fn damage_percent(&self, _actor: &NetworkedActor) -> u32 {
        100
    }

    fn mp_cost(&self, _action: u32, _actor: &NetworkedActor, _sheet_cost: u32) -> Option<u32> {
        None
    }

    fn recast_100ms(&self,_action:u32,_actor:&NetworkedActor)->Option<u32>{None}
    fn fixed_recast(&self,_action:u32)->bool{false}
    fn fixed_primary_recast(&self,_action:u32)->bool{false}
    fn additional_gcd_100ms(&self,_action:u32)->Option<u32>{None}
    fn speed_percent(&self,_actor:&NetworkedActor)->u32{100}
    fn cast_100ms(&self,_action:u32,_actor:&NetworkedActor)->Option<u32>{None}
    fn grants_combo(&self,_action:u32,_state:&PlayerCombatState)->bool{false}
    fn on_action_requested(&self,_action:u32,_actor:&mut NetworkedActor){}

    fn update_state_after_result(
        &self,
        action: u32,
        actor: &mut NetworkedActor,
        owner: ObjectId,
        _landed: bool,
    ) -> JobActionUpdate {
        self.update_state_after_action(action, actor, owner)
    }

    fn apply_area_action(
        &self,
        _network: &mut NetworkState,
        _instance: &mut Instance,
        _context: JobAreaContext<'_>,
    ) -> Option<crate::server::action::area::AreaResult> {
        None
    }

    /// Class-job id under which this job's `ActorGauge` packets are sent. Bard returns `CLASSJOB_BARD`
    /// regardless of the dispatch class; most jobs return the live `dispatch_class_job`.
    fn gauge_class_job_id(&self, dispatch_class_job: u8) -> u8 {
        dispatch_class_job
    }

    /// S1: action morph (Burst→Refulgent, Ruin→Astral Impulse, …). Pure; reads a clone of state.
    fn resolve_action(
        &self,
        request: &ActionRequest,
        combat_state: &PlayerCombatState,
        level: u8,
        game_data: &mut GameData,
    ) -> u32;

    /// S1: post-morph execution gate.
    fn can_execute(&self, action_id: u32, combat_state: &PlayerCombatState, level: u8) -> bool;

    /// S5: apply one Lua `modify_gauge` action to combat state.
    fn apply_gauge_action(&self, combat_state: &mut PlayerCombatState, action: &GaugeAction);

    /// S6: mutate job state after the action resolves. Returns the unified update (bard fills it;
    /// summoner returns `Default`).
    fn update_state_after_action(
        &self,
        action_id: u32,
        actor: &mut NetworkedActor,
        owner_actor_id: ObjectId,
    ) -> JobActionUpdate;

    /// S6/S8/zone/login: build the 8-byte `ActorGauge` tail. `None` = this job has no gauge.
    fn build_gauge_data(&self, combat_state: &PlayerCombatState, level: u8) -> Option<u64>;

    fn build_gauge_extra(&self, _state: &PlayerCombatState, _level: u8) -> [u8; 6] {
        [0; 6]
    }

    /// S6b: the party-propagatable status this action grants, if any.
    fn party_buff_for_action(
        &self,
        _action_id: u32,
        _radiant_finale_bonus_percent: u8,
    ) -> Option<(u16, u16, f32)> {
        None
    }

    /// mod.rs tick + zone refresh: advance timers, expire statuses. Returns the unified refresh result.
    fn refresh_runtime_state_on_actor(
        &self,
        owner_actor_id: ObjectId,
        actor: &mut NetworkedActor,
    ) -> JobRefreshResult;

    /// Capability hook for the SEPARATE persistent-actor/VFX/task seam. `None` for every job that owns
    /// no pets. Summoner returns `Some(&Summoner)`.
    fn persistent_actors(&self) -> Option<&dyn JobActors> {
        None
    }
}

pub(in crate::server) struct JobAreaContext<'a> {
    pub caster: ObjectId,
    pub target: ObjectId,
    pub action: u32,
    pub combo: bool,
    pub ground:Option<kawari::common::Position>,
    /// 消耗层数之前的状态；范围伤害不能用已经扣除的最后一层判断必暴。
    pub statuses: &'a crate::StatusEffects,
    pub effects: &'a [TargetEffect],
    pub modifiers:crate::server::action::ActionDamageModifiers,
}

/// 职业实体、领域及延迟动作独立于资源状态。默认方法不产生副作用，各职业只接管自己支持的生命周期。
/// 召唤师保留原有实现；其他职业无需实现半神或宝石兽专有的回调。
#[allow(unused_variables)]
pub(in crate::server) trait JobActors: Sync {
    /// 换区前撤销依赖旧实例的对象和任务；保留职业资源与冷却。
    fn on_zone_leaving(&self, network: &mut NetworkState, instance: &mut Instance, owner: ObjectId) {}

    /// S3: does this action drive a pet spawn/transition (deferred until after the result packet)?
    fn has_pet_transition_for_action(&self, action_id: u32) -> bool {false}

    /// S4: inject SummonPet/ready effects into the outgoing effect list (before AoE base capture).
    fn augment_action_result_effects(&self, action_id: u32, effects: &mut Vec<TargetEffect>) {}

    /// S2: reconcile the pet actor when the owner mounts.
    fn sync_pet_for_mount(
        &self,
        network: &mut NetworkState,
        instance: &mut Instance,
        owner: ObjectId,
    ) {}

    /// S7: register the Slipstream lingering ground-AoE task after the action resolves. `target` is
    /// the AoE center source (`resolved_request.target.object_id`).
    fn register_lingering_aoe_after_action(
        &self,
        instance: &mut Instance,
        owner: ObjectId,
        action_id: u32,
        target: ObjectId,
    ) {}

    /// S8 (pre-packet): stage the pet transition.
    fn prepare_pet_transition_for_action(
        &self,
        network: &mut NetworkState,
        instance: &mut Instance,
        owner: ObjectId,
        action_id: u32,
    ) {}

    /// S8 (post-packet): spawn the pet so it appears with animation.
    fn spawn_pet_after_action(
        &self,
        network: &mut NetworkState,
        instance: &mut Instance,
        owner: ObjectId,
        action_id: u32,
        target: ObjectId,
    ) {}

    /// S8: is this a demi summon (drives the demi-auto-attack schedule)?
    fn is_demi_summon(&self, action_id: u32) -> bool {false}

    /// S8: schedule the demi auto-attack task.
    fn schedule_demi_auto_attack(&self, instance: &mut Instance, owner: ObjectId) {}

    /// S8 (generic carbuncle path): spawn the summon-pet after the result packet.
    fn apply_summon_pet_effect(
        &self,
        network: Arc<Mutex<NetworkState>>,
        instance: &mut Instance,
        owner: ObjectId,
    ) {}

    /// Zone-in: re-instate a pet carried across the transition with its SAME object id, so no
    /// re-summon / birth animation plays (see `reinstate_carried_pet`). Delegated only by Summoner.
    fn reinstate_carried_pet(
        &self,
        network: Arc<Mutex<NetworkState>>,
        instance: &mut Instance,
        owner: ObjectId,
        carried: CarriedPet,
    ) {}

    /// Zone-in after a demi/primal was dropped (not carried): reset the gauge state and fade a FRESH
    /// carbuncle in via cat267, instead of the cat36 birth reveal `apply_summon_pet_effect` plays.
    /// Matches retail's mid-demi zone transition (see `spawn_carbuncle_with_fade_in`). Summoner only.
    fn reinstate_carbuncle_after_demi_zone(
        &self,
        network: Arc<Mutex<NetworkState>>,
        instance: &mut Instance,
        owner: ObjectId,
    ) {}

    /// mod.rs tick: the demi window just expired this refresh — tear down the demi actor, then
    /// re-spawn/re-bind carbuncle. `gauge_update` = the freshly-built `(gauge_class_job_id, gauge_data)`
    /// to re-send, or `None`. Delegates to `apply_demi_summon_revert`.
    fn on_demi_expired(
        &self,
        network: &mut NetworkState,
        instance: &mut Instance,
        owner: ObjectId,
        gauge_update: Option<(u8, u64)>,
    ) {}

    /// 推进职业实体的独立动作与领域效果；不依赖该职业是否需要刷新量谱。
    fn on_tick(&self,network:&mut NetworkState,instance:&mut Instance,owner:ObjectId) {}

    /// The owner switched away from this job — tear down its persistent actors (pets/VFX) and clear
    /// any re-summon flags. Defaulted no-op: jobs that own no persistent-actor lifecycle opt out.
    /// Summoner overrides this to kill live pets and clear `carbuncle_summoned`.
    fn on_job_deactivated(
        &self,
        _network: &mut NetworkState,
        _instance: &mut Instance,
        _owner: ObjectId,
    ) {
    }
}

/// The single per-job growth point. One arm per job; everything else is closed to extension.
pub(in crate::server) fn job_for(class_job: u8) -> Option<&'static dyn Job> {
    const PICTOMANCER: &super::pictomancer::Pictomancer = &super::pictomancer::Pictomancer;
    const ASTROLOGIAN: &Astrologian = &Astrologian;
    const BARD: &Bard = &Bard;
    const PALADIN: &Paladin = &Paladin;
    const SUMMONER: &Summoner = &Summoner;
    match class_job {
        3 | 21 => Some(&super::warrior::Warrior),
        32 => Some(&super::dark_knight::DarkKnight),
        37 => Some(&super::gunbreaker::Gunbreaker),
        28 => Some(&super::scholar::Scholar),
        40 => Some(&super::sage::Sage),
        31 => Some(&super::machinist::Machinist),
        2 | 20 => Some(&super::monk::Monk),
        34 => Some(&super::samurai::Samurai),
        38 => Some(&super::dancer::Dancer),
        41 => Some(&super::viper::Viper),
        35 => Some(&super::red_mage::RedMage),
        39 => Some(&super::reaper::Reaper),
        42 => Some(PICTOMANCER),
        cj if ASTROLOGIAN.class_jobs().contains(&cj) => Some(ASTROLOGIAN),
        cj if BARD.class_jobs().contains(&cj) => Some(BARD),
        cj if PALADIN.class_jobs().contains(&cj) => Some(PALADIN),
        cj if SUMMONER.class_jobs().contains(&cj) => Some(SUMMONER),
        _ => None,
    }
}

/// Send an `ActorGauge` packet carrying this job's freshly-built gauge tail. Shared by every job
/// (folded from the former per-module copies in `action.rs` / `summoner.rs`).
pub(in crate::server) fn send_job_gauge_update(
    network: &mut NetworkState,
    from_actor_id: ObjectId,
    classjob_id: u8,
    data: u64,
) {
    send_job_gauge_update_extended(network, from_actor_id, classjob_id, data, [0; 6]);
}

pub(in crate::server) fn send_job_gauge_update_extended(
    network: &mut NetworkState,
    from_actor_id: ObjectId,
    classjob_id: u8,
    data: u64,
    extra: [u8; 6],
) {
    let ipc = ServerZoneIpcSegment::new(ServerZoneIpcData::ActorGauge {
        classjob_id,
        data,
        extra,
    });
    network.send_to_by_actor_id(
        from_actor_id,
        FromServer::PacketSegment(ipc, from_actor_id),
        DestinationNetwork::ZoneClients,
    );
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn dark_knight_replay_gauge_keeps_combo_step_at_offset_ten() {
        use binrw::BinWrite;
        let packet = ServerZoneIpcSegment::new(ServerZoneIpcData::ActorGauge {
            classjob_id: 32,
            data: u64::from_le_bytes([30, 0, 118, 91, 0, 0, 48, 117]),
            extra: [1, 0, 0, 0, 0, 0],
        });
        let mut bytes = std::io::Cursor::new(Vec::new());
        packet.write_le(&mut bytes).unwrap();
        let wire = bytes.into_inner();
        assert_eq!(
            &wire[wire.len() - 16..],
            &[32, 0, 30, 0, 118, 91, 0, 0, 48, 117, 1, 0, 0, 0, 0, 0]
        );
    }

    #[test]
    fn job_for_resolves_known_classes_and_rejects_unknown() {
        // 吟游诗人和弓箭手使用 ClassJob ID，不混入职业分类表的 ID。
        for cj in Bard.class_jobs() {
            let job = job_for(*cj).expect("bard class id should resolve");
            assert!(job.class_jobs().contains(cj));
            assert!(job.persistent_actors().is_none());
        }

        // Summoner answers to its class id (27) and owns the persistent-actor seam.
        for cj in Summoner.class_jobs() {
            let job = job_for(*cj).expect("summoner class id should resolve");
            assert!(job.class_jobs().contains(cj));
            assert!(job.persistent_actors().is_some());
        }

        // An unhandled class id resolves to nothing.
        assert!(job_for(0).is_none());
        assert!(job_for(19).is_some());
    }

    #[test]
    fn merged_caster_jobs_do_not_overlap_bard_or_each_other() {
        use crate::server::jobs::{black_mage, white_mage};

        for class_job in [5, 23] {
            assert!(job_for(class_job).is_some());
            assert!(!black_mage::is_black_mage(class_job));
            assert!(!white_mage::is_white_mage(class_job));
        }
        for class_job in [6, 24] {
            assert!(job_for(class_job).is_none());
            assert!(white_mage::is_white_mage(class_job));
            assert!(!black_mage::is_black_mage(class_job));
        }
        for class_job in [7, 25] {
            assert!(job_for(class_job).is_none());
            assert!(black_mage::is_black_mage(class_job));
            assert!(!white_mage::is_white_mage(class_job));
        }
        // 秘术师不应因职业分类表 ID 冲突而走黑魔法师逻辑。
        assert!(!black_mage::is_black_mage(26));
        assert!(!white_mage::is_white_mage(26));
    }
}
