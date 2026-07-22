//! White Mage (WHM) job-specific logic: the Lily/Blood Lily healing gauge, Afflatus
//! actions, Glare IV stacks, Asylum/Liturgy of the Bell ground areas, and the job gauge.
//!
//! All numbers follow the CN 7.51 client data: actionaudit-WHM.json action tooltips and the
//! Trait/TraitTransient/Status sheets:
//!   - Trait#196 神秘百合 (Secret of the Lily, Lv52): 1 Lily per 20s in combat, max 3.
//!   - Trait#309 安慰之心效果提高 (Lv74): Blood Lily (max 3) from Afflatus Solace/Rapture.
//!   - Trait#310 (Lv78): Asylum grants +10% healing received inside.
//!   - Trait#490/625 (Lv88/98): Divine Benison / Tetragrammaton 2 charges.
//!   - Trait#623 (Lv92): Presence of Mind grants 3 Glare IV stacks (闪飒预备, 30s).
//!   - Trait#626 (Lv100): Temperance grants Divine Caress ready (神爱抚预备, 30s).
//! Gauge layout follows FFXIVClientStructs WhiteMageGauge (LilyTimer@0x0A, Lily@0x0C,
//! BloodLily@0x0D).

use std::time::{Duration, Instant};

use serde::{Deserialize, Serialize};

use crate::{
    StatusEffects,
    server::{
        actor::{NetworkedActor, NpcState},
        combat_state::PlayerCombatState,
        instance::Instance,
        network::NetworkState,
        party::get_party_id_from_actor_id,
    },
};
use kawari::{
    common::{ObjectId, Position},
    ipc::zone::ActionRequest,
};

/// ClassJob row id for White Mage (WHM).
const CLASSJOB_WHITE_MAGE: u8 = 24;
/// Class row id for Conjurer (CNJ), the base class.
const CLASSJOB_CONJURER: u8 = 6;
/// Some data paths carry the WHM ClassJobCategory row instead of the ClassJob row.
const CLASSJOB_CATEGORY_WHM: u8 = 25;

// ==================== Action IDs ====================

const ACTION_STONE: u32 = 119;
const ACTION_CURE: u32 = 120;
const ACTION_AERO: u32 = 121;
const ACTION_MEDICA: u32 = 124;
pub(crate) const ACTION_RAISE: u32 = 125;
const ACTION_STONE_II: u32 = 127;
const ACTION_CURE_III: u32 = 131;
const ACTION_AERO_II: u32 = 132;
const ACTION_MEDICA_II: u32 = 133;
const ACTION_CURE_II: u32 = 135;
const ACTION_PRESENCE_OF_MIND: u32 = 136;
pub(crate) const ACTION_HOLY: u32 = 139;
const ACTION_ASYLUM: u32 = 3569;
#[allow(dead_code)]
const ACTION_TETRAGRAMMATON: u32 = 3570;
const ACTION_ASSIZE: u32 = 3571;
const ACTION_STONE_IV: u32 = 7431;
#[allow(dead_code)]
const ACTION_THIN_AIR: u32 = 7430;
#[allow(dead_code)]
const ACTION_DIVINE_BENISON: u32 = 7432;
const ACTION_PLENARY_INDULGENCE: u32 = 7433;
pub(crate) const ACTION_BENEDICTION: u32 = 140;
#[allow(dead_code)]
const ACTION_REPOSE: u32 = 16560;
#[allow(dead_code)]
const ACTION_AETHERIAL_SHIFT: u32 = 37008;
#[allow(dead_code)]
const ACTION_ESUNA: u32 = 7568;
#[allow(dead_code)]
const ACTION_RESCUE: u32 = 7571;
const ACTION_AFFLATUS_SOLACE: u32 = 16531;
const ACTION_DIA: u32 = 16532;
const ACTION_GLARE: u32 = 16533;
const ACTION_AFFLATUS_RAPTURE: u32 = 16534;
const ACTION_AFFLATUS_MISERY: u32 = 16535;
const ACTION_TEMPERANCE: u32 = 16536;
const ACTION_GLARE_III: u32 = 25859;
pub(crate) const ACTION_HOLY_III: u32 = 25860;
pub(crate) const ACTION_LITURGY_OF_THE_BELL: u32 = 25862;
const ACTION_MEDICA_III: u32 = 37010;
const ACTION_GLARE_IV: u32 = 37009;
pub(crate) const ACTION_DIVINE_CARESS: u32 = 37011;

// ==================== Status IDs (CN 7.51 Status sheet) ====================

/// 眩晕: Holy/Holy III stun (4s).
#[allow(dead_code)]
pub(crate) const STATUS_STUN: u16 = 2;
/// 救疗效果提高 (Freecure): next Cure II costs no MP (15s).
pub(crate) const STATUS_FREECURE: u16 = 155;
/// 神速咏唱: Presence of Mind haste (cast/recast -20%, 15s).
pub(crate) const STATUS_PRESENCE_OF_MIND: u16 = 157;
/// 医济: Medica II regen.
#[allow(dead_code)]
pub(crate) const STATUS_MEDICA_II: u16 = 150;
/// 医养: Medica III regen.
#[allow(dead_code)]
pub(crate) const STATUS_MEDICA_III: u16 = 3880;
/// 无中生有: Thin Air, next action costs no MP (12s).
pub(crate) const STATUS_THIN_AIR: u16 = 1217;
/// 神祝祷: Divine Benison barrier (500 cure potency absorb, 15s).
#[allow(dead_code)]
pub(crate) const STATUS_DIVINE_BENISON: u16 = 1218;
/// 告解: Plenary Indulgence (10% mitigation + bonus heal proc, 10s).
pub(crate) const STATUS_CONFESSION: u16 = 1219;
/// 节制: Temperance self buff (healing dealt +20%).
pub(crate) const STATUS_TEMPERANCE_SELF: u16 = 1872;
/// 节制: Temperance party buff (10% mitigation).
pub(crate) const STATUS_TEMPERANCE_PARTY: u16 = 1873;
/// 水流幕: Aquaveil (15% mitigation, 8s).
pub(crate) const STATUS_AQUAVEIL: u16 = 2708;
/// 礼仪之铃: Liturgy of the Bell stacks on the caster.
pub(crate) const STATUS_LITURGY_OF_THE_BELL: u16 = 2709;
/// 闪飒预备: Glare IV ready (stacks in param, 30s).
pub(crate) const STATUS_GLARE_IV_READY: u16 = 3879;
/// 神爱抚预备: Divine Caress ready (30s).
pub(crate) const STATUS_DIVINE_CARESS_READY: u16 = 3881;
/// 神爱抚: Divine Caress barrier (400 cure potency absorb, 10s).
pub(crate) const STATUS_DIVINE_CARESS_BARRIER: u16 = 3903;
/// 神爱环: Divine Caress follow-up regen.
pub(crate) const STATUS_DIVINE_CARESSED: u16 = 3904;
/// 庇护所: standing inside Asylum (+10% healing received).
pub(crate) const STATUS_ASYLUM_INSIDE: u16 = 1912;
/// 衰弱: Raise weakness.
pub(crate) const STATUS_WEAKNESS: u16 = 43;

// ==================== Level gates (Trait sheet) ====================

/// 神秘百合 (#196, Lv52): Lily gauge.
const LEVEL_LILY: u8 = 52;
/// 安慰之心效果提高 (#309, Lv74): Blood Lily from Afflatus actions.
const LEVEL_BLOOD_LILY: u8 = 74;
/// Afflatus Rapture unlock level.
const LEVEL_RAPTURE: u8 = 76;
/// 神速咏唱效果提高 (#623, Lv92): Presence of Mind grants 3 Glare IV stacks.
const LEVEL_GLARE_IV: u8 = 92;
/// 节制效果提高 (#626, Lv100): Temperance grants Divine Caress ready.
const LEVEL_DIVINE_CARESS: u8 = 100;

// ==================== Gameplay constants ====================

const MAX_LILY: u8 = 3;
const MAX_BLOOD_LILY: u8 = 3;
const LILY_INTERVAL: Duration = Duration::from_secs(20);
const GLARE_IV_READY_DURATION: Duration = Duration::from_secs(30);
const GLARE_IV_STACKS: u8 = 3;
const CARESS_READY_DURATION: Duration = Duration::from_secs(30);
const FREECURE_PROC_CHANCE_PERCENT: u8 = 15;
const FREECURE_DURATION: f32 = 15.0;
/// Presence of Mind: cast/recast are shortened by 20% (self-only haste).
const POM_HASTE_PERCENT: u32 = 80;
const ASYLUM_DURATION: Duration = Duration::from_secs(24);
const ASYLUM_RADIUS: f32 = 15.0;
const ASYLUM_TICK_INTERVAL: Duration = Duration::from_secs(3);
const ASYLUM_TICK_POTENCY: u32 = 100;
const BELL_DURATION: Duration = Duration::from_secs(20);
pub(crate) const BELL_RADIUS: f32 = 20.0;
const BELL_STACKS: u8 = 5;
const BELL_TRIGGER_POTENCY: u32 = 400;
const BELL_EXPIRE_POTENCY_PER_STACK: u32 = 200;
const BELL_TRIGGER_COOLDOWN: Duration = Duration::from_secs(1);
/// Assize restores 5% of max MP.
const ASSIZE_MP_RESTORE_PERCENT: u32 = 5;
/// Raise revives with this fraction of max HP, plus Weakness.
const RAISE_HP_PERCENT: u32 = 30;
const WEAKNESS_DURATION: f32 = 100.0;

/// White Mage job state tracked server-side.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq)]
pub struct WhmState {
    /// Lily stacks (0-3), generated one per 20s in combat.
    pub lily_stacks: u8,
    /// Blood Lily stacks (0-3), from Afflatus Solace/Rapture. Spent by Afflatus Misery.
    pub blood_lily_stacks: u8,
    /// Remaining Glare IV stacks from Presence of Mind.
    #[serde(skip)]
    pub glare_iv_stacks: u8,
    #[serde(skip)]
    pub glare_iv_expires_at: Option<Instant>,
    /// Next time a Lily is generated (20s cadence while in combat).
    #[serde(skip)]
    pub lily_next_at: Option<Instant>,
    /// Asylum ground area (position + expiry + tick cadence).
    #[serde(skip)]
    pub asylum_position: Option<glam::Vec3>,
    #[serde(skip)]
    pub asylum_expires_at: Option<Instant>,
    #[serde(skip)]
    pub asylum_next_tick_at: Option<Instant>,
    /// Liturgy of the Bell (position + stacks + expiry + 1/s trigger limiter).
    #[serde(skip)]
    pub bell_position: Option<glam::Vec3>,
    #[serde(skip)]
    pub bell_stacks: u8,
    #[serde(skip)]
    pub bell_expires_at: Option<Instant>,
    #[serde(skip)]
    pub bell_last_trigger_at: Option<Instant>,
}

impl WhmState {
    pub fn has_asylum_active(&self) -> bool {
        self.asylum_expires_at.is_some_and(|t| t > Instant::now())
    }

    pub fn has_bell_active(&self) -> bool {
        self.bell_expires_at.is_some_and(|t| t > Instant::now()) && self.bell_stacks > 0
    }
}

/// Check if the given class_job is White Mage (or base class Conjurer).
pub(crate) fn is_white_mage(class_job: u8) -> bool {
    class_job == CLASSJOB_WHITE_MAGE
        || class_job == CLASSJOB_CONJURER
        || class_job == CLASSJOB_CATEGORY_WHM
}

pub(crate) fn gauge_class_job_id() -> u8 {
    CLASSJOB_WHITE_MAGE
}

// ==================== MP rules ====================

/// Effective MP cost of a WHM action: Freecure makes Cure II free, Thin Air makes the
/// next action free.
pub(crate) fn effective_mp_cost(
    action_id: u32,
    sheet_cost: u32,
    has_freecure: bool,
    has_thin_air: bool,
) -> u32 {
    if has_thin_air && sheet_cost > 0 {
        return 0;
    }
    if action_id == ACTION_CURE_II && has_freecure {
        return 0;
    }
    sheet_cost
}

// ==================== Cast/recast haste ====================

/// Presence of Mind (神速咏唱) haste: -20% cast/recast while the status is up.
pub(crate) fn apply_pom_haste(centisec: u32, has_pom: bool) -> u32 {
    if has_pom && centisec > 0 {
        centisec * POM_HASTE_PERCENT / 100
    } else {
        centisec
    }
}

// ==================== Action resolution & conditions ====================

/// Resolve WHM action remapping: level-based upgrade ladders.
pub(crate) fn resolve_whm_action(request: &ActionRequest, level: u8) -> u32 {
    match request.action_id {
        // Stone → Stone II (18) → Stone III (54) → Stone IV (64) → Glare (72) → Glare III (82)
        ACTION_STONE if level >= 82 => ACTION_GLARE_III,
        ACTION_STONE if level >= 72 => ACTION_GLARE,
        ACTION_STONE if level >= 64 => ACTION_STONE_IV,
        ACTION_STONE if level >= 54 => 3568,
        ACTION_STONE if level >= 18 => ACTION_STONE_II,
        // Aero → Aero II (46) → Dia (72)
        ACTION_AERO if level >= 72 => ACTION_DIA,
        ACTION_AERO if level >= 46 => ACTION_AERO_II,
        // Medica II → Medica III (96)
        ACTION_MEDICA_II if level >= 96 => ACTION_MEDICA_III,
        // Holy → Holy III (82)
        ACTION_HOLY if level >= 82 => ACTION_HOLY_III,
        _ => request.action_id,
    }
}

/// Check if the WHM can execute the given (already resolved) action.
pub(crate) fn can_execute_whm_action(
    action_id: u32,
    combat_state: &PlayerCombatState,
    status_effects: &StatusEffects,
    level: u8,
) -> bool {
    let whm = &combat_state.whm;
    match action_id {
        ACTION_AFFLATUS_SOLACE => whm.lily_stacks > 0 && level >= LEVEL_LILY,
        ACTION_AFFLATUS_RAPTURE => whm.lily_stacks > 0 && level >= LEVEL_RAPTURE,
        ACTION_AFFLATUS_MISERY => whm.blood_lily_stacks >= MAX_BLOOD_LILY,
        ACTION_GLARE_IV => whm.glare_iv_stacks > 0,
        ACTION_DIVINE_CARESS => status_effects.get(STATUS_DIVINE_CARESS_READY).is_some(),
        ACTION_LITURGY_OF_THE_BELL => level >= 90,
        _ => true,
    }
}

// ==================== After-action hook ====================

/// Result of the after-action hook.
#[derive(Debug, Default, Clone, Copy)]
pub(crate) struct WhmActionUpdate {
    /// Gauge-affecting state changed; the caller re-sends the job gauge.
    pub(crate) changed: bool,
    /// A status was added/removed; the caller pushes the effects list.
    pub(crate) status_changed: bool,
    /// MP was restored (Assize); the caller syncs HP/MP.
    pub(crate) mp_changed: bool,
}

/// Update WHM state after an action executes: lily/blood-lily bookkeeping, Glare IV stack
/// consumption, Freecure procs/consumption, Thin Air consumption, Asylum/Bell placement,
/// Raise, Assize MP restore, Temperance's Divine Caress ready grant.
pub(crate) fn update_whm_state_after_action(
    action_id: u32,
    actor: &mut NetworkedActor,
    owner_actor_id: ObjectId,
    sheet_mp_cost: u32,
    ground_position: Option<Position>,
) -> WhmActionUpdate {
    let level = actor.get_common_spawn().level;
    let position = actor.get_common_spawn().position.0;
    let NetworkedActor::Player {
        spawn,
        combat_state,
        status_effects,
        ..
    } = actor
    else {
        return WhmActionUpdate::default();
    };

    let whm = &mut combat_state.whm;
    let mut update = WhmActionUpdate::default();

    // Thin Air is consumed by any action that would have cost MP.
    if sheet_mp_cost > 0
        && action_id != ACTION_CURE_II
        && status_effects.get(STATUS_THIN_AIR).is_some()
    {
        status_effects.remove(STATUS_THIN_AIR);
        update.status_changed = true;
    }

    match action_id {
        ACTION_CURE => {
            // Freecure: 15% chance to make the next Cure II free.
            if fastrand::u8(0..100) < FREECURE_PROC_CHANCE_PERCENT {
                status_effects.add_with_source(
                    STATUS_FREECURE,
                    0,
                    FREECURE_DURATION,
                    owner_actor_id,
                );
                update.status_changed = true;
            }
        }
        ACTION_CURE_II => {
            // Cure II consumes Freecure (free cast) or Thin Air.
            if status_effects.get(STATUS_FREECURE).is_some() {
                status_effects.remove(STATUS_FREECURE);
                update.status_changed = true;
            } else if status_effects.get(STATUS_THIN_AIR).is_some() {
                status_effects.remove(STATUS_THIN_AIR);
                update.status_changed = true;
            }
        }
        ACTION_AFFLATUS_SOLACE | ACTION_AFFLATUS_RAPTURE => {
            whm.lily_stacks = whm.lily_stacks.saturating_sub(1);
            if level >= LEVEL_BLOOD_LILY {
                whm.blood_lily_stacks = (whm.blood_lily_stacks + 1).min(MAX_BLOOD_LILY);
            }
            update.changed = true;
        }
        ACTION_AFFLATUS_MISERY => {
            whm.blood_lily_stacks = 0;
            update.changed = true;
        }
        ACTION_PRESENCE_OF_MIND => {
            if level >= LEVEL_GLARE_IV {
                whm.glare_iv_stacks = GLARE_IV_STACKS;
                whm.glare_iv_expires_at = Some(Instant::now() + GLARE_IV_READY_DURATION);
                status_effects.add_with_source(
                    STATUS_GLARE_IV_READY,
                    u16::from(GLARE_IV_STACKS),
                    GLARE_IV_READY_DURATION.as_secs_f32(),
                    owner_actor_id,
                );
                update.status_changed = true;
            }
        }
        ACTION_GLARE_IV => {
            whm.glare_iv_stacks = whm.glare_iv_stacks.saturating_sub(1);
            if whm.glare_iv_stacks == 0 {
                whm.glare_iv_expires_at = None;
                status_effects.remove(STATUS_GLARE_IV_READY);
            } else {
                let remaining = whm
                    .glare_iv_expires_at
                    .map(|t| t.saturating_duration_since(Instant::now()).as_secs_f32())
                    .unwrap_or(1.0);
                status_effects.add_with_source(
                    STATUS_GLARE_IV_READY,
                    u16::from(whm.glare_iv_stacks),
                    remaining,
                    owner_actor_id,
                );
            }
            update.status_changed = true;
        }
        ACTION_TEMPERANCE => {
            if level >= LEVEL_DIVINE_CARESS {
                status_effects.add_with_source(
                    STATUS_DIVINE_CARESS_READY,
                    0,
                    CARESS_READY_DURATION.as_secs_f32(),
                    owner_actor_id,
                );
                update.status_changed = true;
            }
        }
        ACTION_DIVINE_CARESS => {
            if status_effects.get(STATUS_DIVINE_CARESS_READY).is_some() {
                status_effects.remove(STATUS_DIVINE_CARESS_READY);
                update.status_changed = true;
            }
        }
        ACTION_ASYLUM => {
            let center = ground_position.map(|p| p.0).unwrap_or(position);
            whm.asylum_position = Some(center);
            whm.asylum_expires_at = Some(Instant::now() + ASYLUM_DURATION);
            whm.asylum_next_tick_at = Some(Instant::now() + ASYLUM_TICK_INTERVAL);
        }
        ACTION_LITURGY_OF_THE_BELL => {
            // Re-using while a bell is active detonates the old one first (heal is resolved
            // by the caller via take_bell_detonation before this hook runs).
            let center = ground_position.map(|p| p.0).unwrap_or(position);
            whm.bell_position = Some(center);
            whm.bell_stacks = BELL_STACKS;
            whm.bell_expires_at = Some(Instant::now() + BELL_DURATION);
            whm.bell_last_trigger_at = None;
            status_effects.add_with_source(
                STATUS_LITURGY_OF_THE_BELL,
                u16::from(BELL_STACKS),
                BELL_DURATION.as_secs_f32(),
                owner_actor_id,
            );
            update.status_changed = true;
        }
        ACTION_ASSIZE => {
            // Restore 5% of max MP.
            let common = &mut spawn.common;
            let restore = common
                .max_resource_points
                .saturating_mul(ASSIZE_MP_RESTORE_PERCENT as u16)
                / 100;
            common.resource_points = common
                .resource_points
                .saturating_add(restore)
                .min(common.max_resource_points);
            update.mp_changed = true;
        }
        _ => {}
    }

    update
}

/// Detonate the active bell (recast or expiry): heal party members within the bell's radius
/// by 200 potency per remaining stack. Returns the total heal amount, or None if no bell.
/// Clears the bell state and its status.
pub(crate) fn take_bell_detonation(
    actor: &mut NetworkedActor,
) -> Option<(glam::Vec3, u32)> {
    let NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    } = actor
    else {
        return None;
    };

    let whm = &mut combat_state.whm;
    if !whm.has_bell_active() && whm.bell_stacks == 0 {
        return None;
    }

    let position = whm.bell_position?;
    let total_potency = u32::from(whm.bell_stacks) * BELL_EXPIRE_POTENCY_PER_STACK;

    whm.bell_position = None;
    whm.bell_stacks = 0;
    whm.bell_expires_at = None;
    whm.bell_last_trigger_at = None;
    if status_effects.get(STATUS_LITURGY_OF_THE_BELL).is_some() {
        status_effects.remove(STATUS_LITURGY_OF_THE_BELL);
    }

    Some((position, total_potency))
}

// ==================== Healing & mitigation modifiers ====================

/// Outgoing heal multiplier from the caster's statuses (Temperance self: +20%).
pub(crate) fn outgoing_heal_multiplier(caster: Option<&NetworkedActor>) -> f64 {
    let Some(status_effects) = caster.and_then(NetworkedActor::status_effects) else {
        return 1.0;
    };
    if status_effects.get(STATUS_TEMPERANCE_SELF).is_some() {
        1.2
    } else {
        1.0
    }
}

/// Incoming heal multiplier on the heal target (Asylum inside: +10%).
pub(crate) fn incoming_heal_multiplier(target: Option<&NetworkedActor>) -> f64 {
    let Some(status_effects) = target.and_then(NetworkedActor::status_effects) else {
        return 1.0;
    };
    if status_effects.get(STATUS_ASYLUM_INSIDE).is_some() {
        1.1
    } else {
        1.0
    }
}

/// Damage mitigation multiplier from a player target's WHM statuses (Aquaveil 15%,
/// Temperance party 10%, Confession 10%), stacking multiplicatively like retail.
pub(crate) fn whm_mitigation_multiplier(target: Option<&NetworkedActor>) -> f64 {
    let Some(status_effects) = target.and_then(NetworkedActor::status_effects) else {
        return 1.0;
    };
    let mut multiplier = 1.0;
    if status_effects.get(STATUS_AQUAVEIL).is_some() {
        multiplier *= 0.85;
    }
    if status_effects.get(STATUS_TEMPERANCE_PARTY).is_some() {
        multiplier *= 0.9;
    }
    if status_effects.get(STATUS_CONFESSION).is_some() {
        multiplier *= 0.9;
    }
    multiplier
}

// ==================== AoE heal fan-out ====================

/// Party members of `from_actor_id` (actor ids), including the caster themselves.
fn party_member_actor_ids(network: &NetworkState, from_actor_id: ObjectId) -> Vec<ObjectId> {
    get_party_id_from_actor_id(network, from_actor_id)
        .and_then(|party_id| network.parties.get(&party_id))
        .map(|party| {
            party
                .members
                .iter()
                .filter(|m| m.is_valid())
                .map(|m| m.actor_id)
                .collect()
        })
        .unwrap_or_else(|| vec![from_actor_id])
}

/// The AoE heal actions that fan out to party members, with their radius and whether the
/// AoE centers on the caster (self) or the primary target.
pub(crate) fn aoe_heal_profile(action_id: u32) -> Option<(f32, bool)> {
    // (radius, centered_on_caster)
    match action_id {
        ACTION_MEDICA => Some((20.0, true)),
        ACTION_MEDICA_II => Some((20.0, true)),
        ACTION_MEDICA_III => Some((20.0, true)),
        ACTION_CURE_III => Some((10.0, false)),
        ACTION_AFFLATUS_RAPTURE => Some((20.0, true)),
        ACTION_ASSIZE => Some((20.0, true)),
        _ => None,
    }
}

/// Party buff actions that fan a status out to nearby party members (centered on the caster).
/// Returns `(radius, status_id, duration_seconds, param)`.
pub(crate) fn party_buff_profile(action_id: u32) -> Option<(f32, u16, f32, u16)> {
    match action_id {
        // Plenary Indulgence: Confession (10% mitigation + bonus heal proc, 10s).
        ACTION_PLENARY_INDULGENCE => Some((30.0, STATUS_CONFESSION, 10.0, 0)),
        // Temperance: party mitigation (10%, 20s). The caster's +20% heal buff is applied by Lua.
        ACTION_TEMPERANCE => Some((50.0, STATUS_TEMPERANCE_PARTY, 20.0, 0)),
        _ => None,
    }
}

/// Divine Caress fan-out radius (centered on the caster) if the action is Divine Caress.
pub(crate) fn divine_caress_radius(action_id: u32) -> Option<f32> {
    match action_id {
        ACTION_DIVINE_CARESS => Some(30.0),
        _ => None,
    }
}

/// Medica-line actions whose heal triggers the Confession bonus (Plenary Indulgence):
/// "对处于告解状态中的目标使用医治、愈疗、医养、狂喜之心并生效时" (extra 200 cure potency).
pub(crate) fn is_confession_trigger(action_id: u32) -> bool {
    matches!(
        action_id,
        ACTION_MEDICA | ACTION_CURE_III | ACTION_MEDICA_III | ACTION_AFFLATUS_RAPTURE
    )
}

/// Heal every party member within `radius` of `center` by `amount` (already rolled for the
/// primary), applying both the caster's outgoing-heal multiplier and the target's
/// incoming-heal multiplier, plus the Confession bonus where applicable. Also generates enmity
/// for the caster on every enemy engaged with each healed member. Returns the healed actor ids
/// so the caller can sync their HP/MP.
pub(crate) fn fan_out_aoe_heal(
    network: &NetworkState,
    instance: &mut Instance,
    from_actor_id: ObjectId,
    action_id: u32,
    center: glam::Vec3,
    radius: f32,
    base_amount: u32,
    outgoing_multiplier: f64,
) -> Vec<ObjectId> {
    let members = party_member_actor_ids(network, from_actor_id);
    let outgoing = outgoing_multiplier;

    let mut healed = Vec::new();
    for member_id in members {
        let Some(actor) = instance.find_actor(member_id) else {
            continue;
        };
        if actor.position().0.distance(center) > radius {
            continue;
        }

        let mut amount = (base_amount as f64
            * outgoing
            * incoming_heal_multiplier(Some(actor)))
            as u32;

        // Confession (告解): Medica-line heals on affected targets proc a bonus 200 potency.
        if is_confession_trigger(action_id)
            && let Some(status_effects) = actor.status_effects()
            && status_effects.get(STATUS_CONFESSION).is_some()
        {
            let bonus = instance
                .find_actor(from_actor_id)
                .and_then(|caster| match caster {
                    NetworkedActor::Player { parameters, .. } => {
                        Some(parameters.calc_heal_amount(200))
                    }
                    _ => None,
                })
                .unwrap_or(0);
            amount = amount.saturating_add(bonus);
        }

        let Some(actor) = instance.find_actor_mut(member_id) else {
            continue;
        };
        let common_spawn = actor.get_common_spawn_mut();
        let before = common_spawn.health_points;
        common_spawn.health_points = common_spawn
            .health_points
            .saturating_add(amount)
            .min(common_spawn.max_health_points);
        let amount_healed = common_spawn.health_points.saturating_sub(before);

        // Healing generates enmity for the caster, split across enemies engaged with the target.
        if amount_healed > 0 {
            let engaged: Vec<ObjectId> = instance
                .actors
                .iter()
                .filter_map(|(id, actor)| match actor {
                    NetworkedActor::Npc {
                        hate_list,
                        state,
                        spawn,
                        ..
                    } if *state != NpcState::Dead
                        && spawn.common.health_points > 0
                        && hate_list.contains_key(&member_id) =>
                    {
                        Some(*id)
                    }
                    _ => None,
                })
                .collect();
            if !engaged.is_empty() {
                let total = (amount_healed as f32 * 0.5).round() as u32;
                let each = (total / engaged.len() as u32).max(1);
                for npc_id in engaged {
                    if let Some(actor) = instance.find_actor_mut(npc_id)
                        && let Some(hate_list) = actor.npc_hate_list_mut()
                    {
                        let entry = hate_list.entry(from_actor_id).or_insert(0);
                        *entry = entry.saturating_add(each);
                    }
                }
            }
            healed.push(member_id);
        }
    }

    healed
}

/// Fan out a status buff to every party member within `radius` of `center`. Returns the actor
/// ids that received the buff so the caller can sync their effects lists.
pub(crate) fn fan_out_party_status(
    network: &NetworkState,
    instance: &mut Instance,
    from_actor_id: ObjectId,
    center: glam::Vec3,
    radius: f32,
    status_id: u16,
    param: u16,
    duration: f32,
) -> Vec<ObjectId> {
    let members = party_member_actor_ids(network, from_actor_id);

    let mut buffed = Vec::new();
    for member_id in members {
        let Some(actor) = instance.find_actor(member_id) else {
            continue;
        };
        if actor.position().0.distance(center) > radius {
            continue;
        }

        if let Some(NetworkedActor::Player { status_effects, .. }) =
            instance.find_actor_mut(member_id)
        {
            status_effects.add_with_source(status_id, param, duration, from_actor_id);
            buffed.push(member_id);
        }
    }

    buffed
}

/// Fan out Divine Caress: a 400-potency barrier plus a 200-potency HoT to every party member
/// within `radius` of `center`. Returns the actor ids that were buffed.
pub(crate) fn fan_out_divine_caress(
    network: &NetworkState,
    instance: &mut Instance,
    from_actor_id: ObjectId,
    center: glam::Vec3,
    radius: f32,
    base_parameters: &crate::zone_connection::BaseParameters,
) -> Vec<ObjectId> {
    let members = party_member_actor_ids(network, from_actor_id);

    let barrier_amount = base_parameters.calc_heal_amount(400);

    let mut buffed = Vec::new();
    for member_id in members {
        let Some(actor) = instance.find_actor(member_id) else {
            continue;
        };
        if actor.position().0.distance(center) > radius {
            continue;
        }
        let max_health_points = actor.get_common_spawn().max_health_points;

        let Some(NetworkedActor::Player { status_effects, .. }) = instance.find_actor_mut(member_id)
        else {
            continue;
        };

        status_effects.add_barrier(
            STATUS_DIVINE_CARESS_BARRIER,
            0,
            10.0,
            barrier_amount,
            from_actor_id,
            max_health_points,
        );
        status_effects.add_tick(
            STATUS_DIVINE_CARESSED,
            0,
            15.0,
            crate::TickEffectKind::Heal,
            200,
            None,
            from_actor_id,
        );
        // The barrier status itself is shown to the client as a normal gain effect.
        status_effects.add_with_source(STATUS_DIVINE_CARESS_BARRIER, 0, 10.0, from_actor_id);
        buffed.push(member_id);
    }

    buffed
}

// ==================== Runtime tick ====================

/// Result of the per-tick runtime refresh.
#[derive(Debug, Default, Clone, Copy)]
pub(crate) struct WhmRuntimeUpdate {
    pub(crate) changed: bool,
    pub(crate) status_changed: bool,
    /// Party members whose HP changed this tick (asylum tick / bell detonation).
    pub(crate) hp_changed: bool,
}

/// Per-server-tick driver: Lily generation (20s in combat), Glare IV expiry, Asylum ticks,
/// and Liturgy of the Bell expiry detonation.
pub(crate) fn refresh_whm_runtime_state_on_actor(
    network: &NetworkState,
    instance: &mut Instance,
    actor_id: ObjectId,
) -> WhmRuntimeUpdate {
    let mut update = WhmRuntimeUpdate::default();
    let now = Instant::now();

    let Some(actor) = instance.find_actor(actor_id) else {
        return update;
    };
    let level = actor.get_common_spawn().level;

    // ---- Actor-local state: lily generation, Glare IV expiry, asylum expiry ----
    let mut asylum_expired = false;
    {
        let Some(NetworkedActor::Player {
            combat_state,
            status_effects,
            ..
        }) = instance.find_actor_mut(actor_id)
        else {
            return update;
        };
        let whm = &mut combat_state.whm;

        // Lily generation: one per 20s in combat, max 3 (Trait#196).
        if level >= LEVEL_LILY && combat_state.in_combat && whm.lily_stacks < MAX_LILY {
            let next_at = whm.lily_next_at.get_or_insert(now + LILY_INTERVAL);
            if now >= *next_at {
                whm.lily_stacks += 1;
                whm.lily_next_at = (whm.lily_stacks < MAX_LILY).then_some(now + LILY_INTERVAL);
                update.changed = true;
            }
        } else {
            whm.lily_next_at = None;
        }

        // Glare IV expiry.
        if whm.glare_iv_expires_at.is_some_and(|t| t <= now) {
            whm.glare_iv_stacks = 0;
            whm.glare_iv_expires_at = None;
            if status_effects.get(STATUS_GLARE_IV_READY).is_some() {
                status_effects.remove(STATUS_GLARE_IV_READY);
                update.status_changed = true;
            }
        }

        // Asylum expiry (member status cleanup happens below, outside the actor borrow).
        if whm.asylum_expires_at.is_some_and(|t| t <= now) {
            whm.asylum_position = None;
            whm.asylum_expires_at = None;
            whm.asylum_next_tick_at = None;
            asylum_expired = true;
        }
    }

    // Strip the Asylum inside-status from every party member once the area ends.
    if asylum_expired {
        let members = party_member_actor_ids(network, actor_id);
        for member_id in members {
            if let Some(NetworkedActor::Player {
                status_effects, ..
            }) = instance.find_actor_mut(member_id)
                && status_effects.get(STATUS_ASYLUM_INSIDE).is_some()
            {
                status_effects.remove(STATUS_ASYLUM_INSIDE);
                update.status_changed = true;
            }
        }
    }

    // ---- Asylum tick: heal the party inside the area every 3s ----
    let asylum_tick = match instance.find_actor(actor_id) {
        Some(NetworkedActor::Player { combat_state, .. }) => {
            match (combat_state.whm.asylum_position, combat_state.whm.asylum_next_tick_at) {
                (Some(center), Some(next_tick)) if now >= next_tick => Some(center),
                _ => None,
            }
        }
        _ => None,
    };
    if let Some(center) = asylum_tick {
        let heal_amount = instance
            .find_actor(actor_id)
            .and_then(|caster| match caster {
                NetworkedActor::Player { parameters, .. } => {
                    let base = parameters.calc_heal_amount(ASYLUM_TICK_POTENCY);
                    // Temperance's self buff also boosts Asylum ticks.
                    Some((base as f64 * outgoing_heal_multiplier(Some(caster))) as u32)
                }
                _ => None,
            })
            .unwrap_or(0);

        let members = party_member_actor_ids(network, actor_id);
        for member_id in members {
            let Some(actor) = instance.find_actor(member_id) else {
                continue;
            };
            let inside = actor.position().0.distance(center) <= ASYLUM_RADIUS;
            let has_status = actor
                .status_effects()
                .is_some_and(|s| s.get(STATUS_ASYLUM_INSIDE).is_some());

            if inside {
                if !has_status {
                    if let Some(status_effects) = instance
                        .find_actor_mut(member_id)
                        .and_then(|a| a.status_effects_mut())
                    {
                        status_effects.add_with_source(
                            STATUS_ASYLUM_INSIDE,
                            0,
                            ASYLUM_TICK_INTERVAL.as_secs_f32() + 1.0,
                            actor_id,
                        );
                        update.status_changed = true;
                    }
                }
                // The +10% applies starting with the tick that finds the member already buffed.
                let amount = if has_status {
                    (heal_amount as f64 * 1.1) as u32
                } else {
                    heal_amount
                };
                let actor = instance.find_actor_mut(member_id).unwrap();
                let common_spawn = actor.get_common_spawn_mut();
                let before = common_spawn.health_points;
                common_spawn.health_points = common_spawn
                    .health_points
                    .saturating_add(amount)
                    .min(common_spawn.max_health_points);
                if common_spawn.health_points != before {
                    update.hp_changed = true;
                }
            } else if has_status {
                if let Some(status_effects) = instance
                    .find_actor_mut(member_id)
                    .and_then(|a| a.status_effects_mut())
                {
                    status_effects.remove(STATUS_ASYLUM_INSIDE);
                    update.status_changed = true;
                }
            }
        }

        if let Some(NetworkedActor::Player { combat_state, .. }) =
            instance.find_actor_mut(actor_id)
        {
            combat_state.whm.asylum_next_tick_at = Some(now + ASYLUM_TICK_INTERVAL);
        }
    }

    // ---- Bell expiry detonation ----
    let bell_expired = match instance.find_actor(actor_id) {
        Some(NetworkedActor::Player { combat_state, .. }) => {
            combat_state.whm.bell_stacks > 0
                && combat_state
                    .whm
                    .bell_expires_at
                    .is_some_and(|t| t <= now)
        }
        _ => false,
    };
    if bell_expired {
        let outgoing_multiplier = outgoing_heal_multiplier(instance.find_actor(actor_id));
        let detonation = instance
            .find_actor_mut(actor_id)
            .and_then(take_bell_detonation);
        if let Some((bell_center, total_potency)) = detonation {
            let base = instance
                .find_actor(actor_id)
                .and_then(|caster| match caster {
                    NetworkedActor::Player { parameters, .. } => {
                        Some(parameters.calc_heal_amount(total_potency))
                    }
                    _ => None,
                })
                .unwrap_or(0);
            let healed = fan_out_aoe_heal(
                network,
                instance,
                actor_id,
                0,
                bell_center,
                BELL_RADIUS,
                base,
                outgoing_multiplier,
            );
            update.hp_changed |= !healed.is_empty();
            update.status_changed = true;
            update.changed = true;
        }
    }

    update
}


// ==================== Bell damage trigger ====================

/// Called when a WHM player takes damage: consume one bell stack (1/s max) and heal the
/// party within the bell's radius by 400 potency. Returns true if HP changed anywhere.
pub(crate) fn on_whm_took_damage(
    network: &NetworkState,
    instance: &mut Instance,
    whm_actor_id: ObjectId,
) -> bool {
    let now = Instant::now();

    let (should_trigger, bell_center) = {
        let Some(NetworkedActor::Player { combat_state, .. }) =
            instance.find_actor_mut(whm_actor_id)
        else {
            return false;
        };
        let whm = &mut combat_state.whm;
        if !whm.has_bell_active() {
            return false;
        }
        if whm
            .bell_last_trigger_at
            .is_some_and(|t| now.duration_since(t) < BELL_TRIGGER_COOLDOWN)
        {
            return false;
        }

        whm.bell_stacks = whm.bell_stacks.saturating_sub(1);
        whm.bell_last_trigger_at = Some(now);
        (true, whm.bell_position.unwrap_or_default())
    };

    if !should_trigger {
        return false;
    }

    // Keep the bell status param in sync with the remaining stacks.
    {
        let Some(NetworkedActor::Player {
            combat_state,
            status_effects,
            ..
        }) = instance.find_actor_mut(whm_actor_id)
        else {
            return false;
        };
        let stacks = combat_state.whm.bell_stacks;
        if stacks == 0 {
            combat_state.whm.bell_position = None;
            combat_state.whm.bell_expires_at = None;
            status_effects.remove(STATUS_LITURGY_OF_THE_BELL);
        } else {
            let remaining = combat_state
                .whm
                .bell_expires_at
                .map(|t| t.saturating_duration_since(now).as_secs_f32())
                .unwrap_or(1.0);
            status_effects.add_with_source(
                STATUS_LITURGY_OF_THE_BELL,
                u16::from(stacks),
                remaining,
                whm_actor_id,
            );
        }
    }

    let (base, outgoing_multiplier) = instance
        .find_actor(whm_actor_id)
        .map(|caster| {
            let base = match caster {
                NetworkedActor::Player { parameters, .. } => {
                    parameters.calc_heal_amount(BELL_TRIGGER_POTENCY)
                }
                _ => 0,
            };
            (base, outgoing_heal_multiplier(Some(caster)))
        })
        .unwrap_or((0, 1.0));

    let healed = fan_out_aoe_heal(
        network,
        instance,
        whm_actor_id,
        0,
        bell_center,
        BELL_RADIUS,
        base,
        outgoing_multiplier,
    );
    !healed.is_empty()
}

// ==================== Job gauge ====================

/// Pack the WHM job gauge. Byte layout (FFXIVClientStructs WhiteMageGauge, data starts at
/// the struct's 0x08, which is what ActorGauge carries):
///   [0..2] unused
///   [2..4] LilyTimer (i16 LE, ms until the next Lily — runs only in combat)
///   [4]    Lily (0-3)
///   [5]    BloodLily (0-3)
///   [6..8] padding
pub(crate) fn build_whm_gauge_data(combat_state: &PlayerCombatState, level: u8) -> u64 {
    let whm = &combat_state.whm;

    let lily = if level >= LEVEL_LILY {
        whm.lily_stacks
    } else {
        0
    };
    let blood_lily = if level >= LEVEL_BLOOD_LILY {
        whm.blood_lily_stacks
    } else {
        0
    };
    let lily_timer_ms = if level >= LEVEL_LILY && combat_state.in_combat && lily < MAX_LILY {
        whm.lily_next_at
            .map(|t| {
                t.saturating_duration_since(Instant::now())
                    .as_millis()
                    .min(u128::from(u16::MAX)) as u16
            })
            .unwrap_or(20000)
    } else {
        0
    };

    let [timer_lo, timer_hi] = lily_timer_ms.to_le_bytes();
    let bytes = [0, 0, timer_lo, timer_hi, lily, blood_lily, 0, 0];
    u64::from_le_bytes(bytes)
}

// ==================== Raise ====================

/// Revive a dead party member: back to normal mode with a fraction of max HP, plus
/// Weakness (衰弱, 100s) as retail applies on raise. No-op if the target isn't dead.
pub(crate) fn apply_raise(instance: &mut Instance, target_actor_id: ObjectId) -> bool {
    let Some(actor) = instance.find_actor_mut(target_actor_id) else {
        return false;
    };

    let common_spawn = actor.get_common_spawn_mut();
    if common_spawn.health_points != 0 {
        return false;
    }

    common_spawn.mode = kawari::common::CharacterMode::Normal;
    common_spawn.health_points = common_spawn.max_health_points * RAISE_HP_PERCENT / 100;

    if let Some(status_effects) = actor.status_effects_mut() {
        status_effects.add_with_source(STATUS_WEAKNESS, 0, WEAKNESS_DURATION, target_actor_id);
    }
    true
}
