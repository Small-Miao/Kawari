//! Black Mage (BLM) job-specific logic: elemental stance (Astral Fire / Umbral Ice),
//! Umbral Hearts, Astral Soul, Polyglot, Paradox, Ley Lines, and the job gauge.
//!
//! All numbers follow the CN 7.51 client data: action tooltips (actionaudit-BLM.json),
//! Trait/TraitTransient rows (极性精通 I-V = Aspect Mastery I-V) and Status rows from the
//! game sheets. Notable sources:
//!   - Trait#296/458/459 (Aspect Mastery I/II/III): stance damage & MP rules, per-tier values.
//!   - Trait#465 (Aspect Mastery V, Lv90): Paradox marker granted on swapping to the opposite
//!     element while at max stance AND max Umbral Hearts; marker clears when the stance ends.
//!   - Trait#616 (Enhanced Astral Fire, Lv100): Astral Soul (max 6) from Fire IV / Flare hits,
//!     and Despair becomes instant.
//!   - Trait#295/297/615: Umbral Heart (Lv58), Polyglot max 2 (Lv80) / 3 (Lv98).

use std::sync::Arc;
use std::time::{Duration, Instant};

use parking_lot::Mutex;
use serde::{Deserialize, Serialize};

use crate::{
    StatusEffects,
    server::{
        actor::NetworkedActor, combat_state::PlayerCombatState, instance::Instance,
        network::NetworkState,
    },
};
use kawari::{
    common::{ObjectId, Position},
    ipc::zone::{ActionRequest, ObjectKind, SpawnObject},
};

/// ClassJob row id for Black Mage (BLM).
const CLASSJOB_BLACK_MAGE: u8 = 25;
/// Class row id for Thaumaturge (THM), the base class — shares the entire elemental mechanic.
const CLASSJOB_THAUMATURGE: u8 = 7;
/// Some data paths carry the BLM ClassJobCategory row instead of the ClassJob row.
const CLASSJOB_CATEGORY_BLM: u8 = 26;

// ==================== Action IDs ====================

pub(crate) const ACTION_FIRE: u32 = 141;
pub(crate) const ACTION_BLIZZARD: u32 = 142;
const ACTION_THUNDER: u32 = 144;
const ACTION_FIRE_II: u32 = 147;
const ACTION_TRANSPOSE: u32 = 149;
const ACTION_FIRE_III: u32 = 152;
const ACTION_THUNDER_III: u32 = 153;
const ACTION_BLIZZARD_III: u32 = 154;
const ACTION_SCATHE: u32 = 156;
const ACTION_MANAFONT: u32 = 158;
const ACTION_FREEZE: u32 = 159;
const ACTION_FLARE: u32 = 162;
const ACTION_LEY_LINES: u32 = 3573;
const ACTION_BLIZZARD_IV: u32 = 3576;
const ACTION_FIRE_IV: u32 = 3577;
const ACTION_BETWEEN_THE_LINES: u32 = 7419;
const ACTION_THUNDER_IV: u32 = 7420;
const ACTION_TRIPLECAST: u32 = 7421;
const ACTION_FOUL: u32 = 7422;
const ACTION_THUNDER_II: u32 = 7447;
const ACTION_DESPAIR: u32 = 16505;
const ACTION_UMBRAL_SOUL: u32 = 16506;
const ACTION_XENOGLOSSY: u32 = 16507;
const ACTION_BLIZZARD_II: u32 = 25793;
const ACTION_HIGH_FIRE_II: u32 = 25794;
const ACTION_HIGH_BLIZZARD_II: u32 = 25795;
const ACTION_AMPLIFIER: u32 = 25796;
const ACTION_PARADOX: u32 = 25797;
const ACTION_HIGH_THUNDER: u32 = 36986;
const ACTION_HIGH_THUNDER_II: u32 = 36987;
const ACTION_RETRACE: u32 = 36988;
const ACTION_FLARE_STAR: u32 = 36989;

// ==================== Status IDs (from the CN 7.51 Status sheet) ====================

/// 火苗: next Fire III is instant and costs no MP. Permanent until consumed.
pub(crate) const STATUS_FIRESTARTER: u16 = 165;
/// 云砧: allows casting thunder magic. Permanent until consumed.
pub(crate) const STATUS_THUNDERHEAD: u16 = 3870;
/// 三连咏唱: next 3 spells have no cast time (15s).
pub(crate) const STATUS_TRIPLECAST: u16 = 1211;
/// 黑魔纹: the ground circle is placed (marker status, carries the remaining duration).
pub(crate) const STATUS_LEY_LINES: u16 = 737;
/// 魔纹环 (Circle of Power): the actual haste buff while standing inside.
pub(crate) const STATUS_CIRCLE_OF_POWER: u16 = 738;

/// All thunder DoT status ids. Only one may exist per caster on a given target
/// ("自身对目标附加的雷系魔法持续伤害效果同时只能存在一种").
pub(crate) const THUNDER_DOT_STATUSES: [u16; 6] = [161, 162, 163, 1210, 3871, 3872];

// ==================== Aspect values (Action.Aspect column) ====================

pub(crate) const ASPECT_FIRE: u8 = 1;
pub(crate) const ASPECT_ICE: u8 = 2;

// ==================== Level gates (Trait sheet) ====================

/// Aspect Mastery (Trait#296): 1 stance stack. Aspect Mastery II (#458, Lv20): 2 stacks.
const LEVEL_STANCE_STACKS_2: u8 = 20;
/// Aspect Mastery III (#459, Lv35): 3 stacks; Fire II/Blizzard II grant max stacks.
const LEVEL_STANCE_STACKS_3: u8 = 35;
/// Firestarter trait (#32, Lv42): Fire has a 40% chance to grant Firestarter.
const LEVEL_FIRESTARTER: u8 = 42;
/// Enochian (Trait#460, Lv56): +5% magic damage while in Astral Fire / Umbral Ice.
const LEVEL_ENOCHIAN: u8 = 56;
/// Umbral Heart trait (#295, Lv58).
const LEVEL_UMBRAL_HEART: u8 = 58;
/// Enhanced Enochian (#174, Lv70): Polyglot stack every 30s of maintained Enochian.
const LEVEL_POLYGLOT: u8 = 70;
/// Enhanced Polyglot (#297, Lv80): 2 stacks.
const LEVEL_POLYGLOT_2: u8 = 80;
/// Aspect Mastery V (#465, Lv90): Paradox marker.
const LEVEL_PARADOX: u8 = 90;
/// Enhanced Ley Lines (#614, Lv96): enables Retrace.
const LEVEL_RETRACE: u8 = 96;
/// Enhanced Polyglot II (#615, Lv98): 3 stacks.
const LEVEL_POLYGLOT_3: u8 = 98;
/// Enhanced Astral Fire (#616, Lv100): Astral Soul; Despair becomes instant.
const LEVEL_ASTRAL_SOUL: u8 = 100;

// ==================== Gameplay constants ====================

const MAX_ELEMENT_STANCE: i8 = 3;
const MAX_UMBRAL_HEARTS: u8 = 3;
const MAX_ASTRAL_SOUL: u8 = 6;
const POLYGLOT_INTERVAL: Duration = Duration::from_secs(30);
const TRIPLECAST_DURATION: Duration = Duration::from_secs(15);
const TRIPLECAST_STACKS: u8 = 3;
const LEY_LINES_DURATION: Duration = Duration::from_secs(20);
const LEY_LINES_RADIUS: f32 = 3.0;
/// VFX sheet row for the Ley Lines ground circle (from the retail ObjectSpawn: base_id 0x179).
const LEY_LINES_GROUND_VFX_ID: u32 = 377;
/// Circle of Power (魔纹环) is re-applied in 5-second windows while standing inside.
const CIRCLE_OF_POWER_DURATION: f32 = 5.0;
/// Ley Lines haste: cast/recast/auto-attack are shortened by 15% while inside.
const LEY_LINES_HASTE_PERCENT: u32 = 85;
/// Firestarter proc chance on Fire (Trait#32).
const FIRESTARTER_PROC_CHANCE_PERCENT: u8 = 40;
/// Scathe: 20% chance to deal double damage.
const SCATHE_DOUBLE_CHANCE_PERCENT: u8 = 20;
/// Paradox MP cost while in Astral Fire (free in Umbral Ice, per its tooltip).
const PARADOX_MP_COST: u32 = 1600;
/// Minimum MP required to cast Flare/Despair (they consume all remaining MP).
const ALL_MP_COST_MIN: u32 = 800;
/// MP restored when an ice-aspected spell hits while in Umbral Ice, per UI tier
/// (Aspect Mastery I/II/III: 2500/5000/10000).
const UMBRAL_ICE_MP_ON_HIT: [u32; 3] = [2500, 5000, 10000];
/// MP restored by Umbral Soul per UI tier.
const UMBRAL_SOUL_MP: [u32; 3] = [2500, 5000, 10000];
/// Out-of-combat Umbral Soul restores a flat 10000 MP.
const UMBRAL_SOUL_OOC_MP: u32 = 10000;

/// "Permanent" buffs (Firestarter, Thunderhead) use a far-future duration; the client shows
/// no countdown for very long statuses, and both are consumed server-side long before expiry.
const PERMANENT_STATUS_DURATION: f32 = 604800.0;

/// Black Mage job state tracked server-side.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq)]
pub struct BlmState {
    /// Elemental stance: 1-3 = Astral Fire stacks, -1..-3 = Umbral Ice stacks, 0 = none.
    pub element_stance: i8,
    /// Umbral Hearts (0-3). Each nullifies the AF fire MP increase for one cast; Flare
    /// consumes all of them to reduce its cost to 2/3.
    pub umbral_hearts: u8,
    /// Polyglot stacks (0-3, cap depends on level).
    pub polyglot_stacks: u8,
    /// Paradox marker (悖论水晶). Fire/Blizzard become Paradox while lit.
    pub paradox_active: bool,
    /// Astral Soul stacks (0-6), spent by Flare Star. Cleared when Astral Fire ends.
    pub astral_soul_stacks: u8,
    /// Remaining Triplecast instant-cast stacks.
    #[serde(skip)]
    pub triplecast_stacks: u8,
    #[serde(skip)]
    pub triplecast_expires_at: Option<Instant>,
    /// Next time a Polyglot stack is generated (every 30s while in a stance).
    #[serde(skip)]
    pub polyglot_next_at: Option<Instant>,
    /// Ley Lines placement (position + expiry). 7.51 places the circle at the caster's feet.
    #[serde(skip)]
    pub ley_lines_position: Option<glam::Vec3>,
    #[serde(skip)]
    pub ley_lines_expires_at: Option<Instant>,
    /// The spawned ground-circle VFX object, so it can be despawned on expiry/Retrace.
    #[serde(skip)]
    pub ley_lines_object_id: Option<ObjectId>,
}

impl BlmState {
    pub fn in_astral_fire(&self) -> bool {
        self.element_stance > 0
    }

    pub fn in_umbral_ice(&self) -> bool {
        self.element_stance < 0
    }

    pub fn astral_fire_stacks(&self) -> u8 {
        self.element_stance.max(0) as u8
    }

    pub fn umbral_ice_stacks(&self) -> u8 {
        (-self.element_stance.min(0)) as u8
    }

    pub fn has_ley_lines_active(&self) -> bool {
        self.ley_lines_expires_at.is_some_and(|t| t > Instant::now())
    }

    fn max_stance_stacks(level: u8) -> i8 {
        if level >= LEVEL_STANCE_STACKS_3 {
            3
        } else if level >= LEVEL_STANCE_STACKS_2 {
            2
        } else {
            1
        }
    }

    fn max_polyglot(level: u8) -> u8 {
        if level >= LEVEL_POLYGLOT_3 {
            3
        } else if level >= LEVEL_POLYGLOT_2 {
            2
        } else if level >= LEVEL_POLYGLOT {
            1
        } else {
            0
        }
    }

    /// MP restored when an ice spell hits in Umbral Ice, by current UI tier.
    fn umbral_ice_mp_on_hit(&self) -> u32 {
        let stacks = self.umbral_ice_stacks();
        if stacks == 0 {
            0
        } else {
            UMBRAL_ICE_MP_ON_HIT[(stacks as usize - 1).min(2)]
        }
    }
}

/// Check if the given class_job is Black Mage (or base class Thaumaturge).
pub(crate) fn is_black_mage(class_job: u8) -> bool {
    class_job == CLASSJOB_BLACK_MAGE
        || class_job == CLASSJOB_THAUMATURGE
        || class_job == CLASSJOB_CATEGORY_BLM
}

pub(crate) fn gauge_class_job_id() -> u8 {
    CLASSJOB_BLACK_MAGE
}

// ==================== Damage multipliers ====================

/// Enochian magic damage bonus (percent) by level: +5% at 56 (Trait#460), +10% at 70
/// (#174), +15% at 78 (#322), +22% at 86 (#509), +27% at 96 (#659). Applies to all magic
/// attacks while in Astral Fire or Umbral Ice ("天语状态").
fn enochian_damage_percent(level: u8) -> u32 {
    match level {
        96.. => 127,
        86.. => 122,
        78.. => 115,
        70.. => 110,
        LEVEL_ENOCHIAN.. => 105,
        _ => 100,
    }
}

/// Stance damage multiplier (percent) for an action of the given element
/// (Aspect Mastery I/II/III): AF boosts fire 140/160/180 and weakens ice 90/80/70;
/// UI weakens fire 90/80/70 and leaves ice unmodified. Unaspected/lightning actions
/// and the neutral stance are always 100. The Enochian magic bonus applies to every
/// magic attack while a stance is up, and Scathe rolls its 20% double here.
pub(crate) fn element_damage_percent(state: &BlmState, action_id: u32, aspect: u8, level: u8) -> u32 {
    // Scathe: 20% chance to deal double damage, rolled here because this multiplier is
    // applied to every damage instance of the cast (primary + AoE secondaries).
    let scathe = if action_id == ACTION_SCATHE
        && fastrand::u8(0..100) < SCATHE_DOUBLE_CHANCE_PERCENT
    {
        200
    } else {
        100
    };

    let elemental = match (state.element_stance, aspect) {
        (s, ASPECT_FIRE) if s > 0 => [140_u32, 160, 180][(s as usize - 1).min(2)],
        (s, ASPECT_ICE) if s > 0 => [90_u32, 80, 70][(s as usize - 1).min(2)],
        (s, ASPECT_FIRE) if s < 0 => [90_u32, 80, 70][(-s as usize - 1).min(2)],
        // Ice spells are unmodified in Umbral Ice; unaspected/lightning and the neutral
        // stance never get a multiplier.
        _ => 100,
    };

    let enochian = if state.element_stance != 0 {
        enochian_damage_percent(level)
    } else {
        100
    };

    elemental * scathe * enochian / 10000
}

// ==================== MP rules ====================

/// Effective MP cost of a BLM action, given the caster's current state (Aspect Mastery I):
///   - In Astral Fire: fire spells cost double; an Umbral Heart is consumed instead to
///     nullify the increase (handled in the after-action hook). Ice spells cost 0.
///   - In Umbral Ice: fire and ice spells cost 0.
///   - Flare consumes all MP (min 800); with any Umbral Hearts it costs 2/3 of max MP.
///   - Despair consumes all MP (min 800). Paradox costs 1600 in AF and 0 in UI.
///
/// `sheet_cost` is the Action-sheet MP cost (0 for the special cost types).
pub(crate) fn effective_mp_cost(
    state: &BlmState,
    action_id: u32,
    sheet_cost: u32,
    aspect: u8,
    current_mp: u32,
    max_mp: u32,
    has_firestarter: bool,
) -> u32 {
    match action_id {
        ACTION_FLARE => {
            if state.umbral_hearts > 0 {
                current_mp.min(max_mp * 2 / 3)
            } else {
                current_mp
            }
        }
        ACTION_DESPAIR => current_mp,
        ACTION_PARADOX => {
            if state.in_umbral_ice() {
                0
            } else {
                PARADOX_MP_COST
            }
        }
        ACTION_FIRE_III if has_firestarter => 0,
        _ => {
            if sheet_cost == 0 {
                return 0;
            }
            match aspect {
                ASPECT_FIRE => {
                    if state.in_umbral_ice() {
                        0
                    } else if state.in_astral_fire() {
                        if state.umbral_hearts > 0 {
                            sheet_cost
                        } else {
                            sheet_cost * 2
                        }
                    } else {
                        sheet_cost
                    }
                }
                // Ice spells are free in either stance (Aspect Mastery I).
                ASPECT_ICE if state.element_stance != 0 => 0,
                _ => sheet_cost,
            }
        }
    }
}

/// Whether casting this fire spell in AF consumes an Umbral Heart (MP increase nullified).
fn consumes_umbral_heart(state: &BlmState, action_id: u32, sheet_cost: u32, aspect: u8) -> bool {
    state.in_astral_fire()
        && state.umbral_hearts > 0
        && aspect == ASPECT_FIRE
        && sheet_cost > 0
        // Flare consumes *all* hearts for its own discount instead.
        && action_id != ACTION_FLARE
}

/// Minimum MP required to cast (Flare/Despair consume all MP but still demand 800+).
pub(crate) fn min_mp_requirement(action_id: u32) -> u32 {
    match action_id {
        ACTION_FLARE | ACTION_DESPAIR => ALL_MP_COST_MIN,
        _ => 0,
    }
}

// ==================== Cast time rules ====================

/// Whether this cast is instant for BLM-specific reasons: Firestarter Fire III, a
/// Triplecast stack, or Lv100 Despair (Trait#616). `base_centisec` must be > 0 — actions
/// that are already instant never consume Triplecast stacks.
pub(crate) fn requires_no_cast_time(
    state: &BlmState,
    action_id: u32,
    base_centisec: u32,
    level: u8,
    has_firestarter: bool,
) -> bool {
    if base_centisec == 0 {
        return false;
    }
    if action_id == ACTION_FIRE_III && has_firestarter {
        return true;
    }
    if state.triplecast_stacks > 0 {
        return true;
    }
    // Enhanced Astral Fire (#616, Lv100): Despair needs no cast time.
    action_id == ACTION_DESPAIR && level >= LEVEL_ASTRAL_SOUL
}

/// AF3 halves ice cast times and UI3 halves fire cast times (Aspect Mastery III).
pub(crate) fn cast_time_halved(state: &BlmState, aspect: u8) -> bool {
    (state.element_stance == MAX_ELEMENT_STANCE && aspect == ASPECT_ICE)
        || (state.element_stance == -MAX_ELEMENT_STANCE && aspect == ASPECT_FIRE)
}

/// Apply the Ley Lines haste (-15%) to a cast or recast time, in centiseconds.
pub(crate) fn apply_ley_lines_haste(centisec: u32, in_ley_lines: bool) -> u32 {
    if in_ley_lines && centisec > 0 {
        centisec * LEY_LINES_HASTE_PERCENT / 100
    } else {
        centisec
    }
}

// ==================== Action resolution & conditions ====================

/// Resolve BLM action remapping: level-based upgrade ladders (Aspect Mastery traits) and
/// the Paradox hotbar morph ("满足发动条件后，火炎和冰结变为悖论").
pub(crate) fn resolve_blm_action(
    request: &ActionRequest,
    combat_state: &PlayerCombatState,
    level: u8,
) -> u32 {
    let blm = &combat_state.blm;

    // Paradox replaces Fire/Blizzard while the marker is lit.
    if blm.paradox_active && matches!(request.action_id, ACTION_FIRE | ACTION_BLIZZARD) {
        return ACTION_PARADOX;
    }

    match request.action_id {
        // Thunder → Thunder III (Lv45) → High Thunder (Lv92)
        ACTION_THUNDER if level >= 92 => ACTION_HIGH_THUNDER,
        ACTION_THUNDER if level >= 45 => ACTION_THUNDER_III,
        // Thunder II → Thunder IV (Lv64) → High Thunder II (Lv92)
        ACTION_THUNDER_II if level >= 92 => ACTION_HIGH_THUNDER_II,
        ACTION_THUNDER_II if level >= 64 => ACTION_THUNDER_IV,
        // Fire II → High Fire II (Lv82), Blizzard II → High Blizzard II (Lv82)
        ACTION_FIRE_II if level >= 82 => ACTION_HIGH_FIRE_II,
        ACTION_BLIZZARD_II if level >= 82 => ACTION_HIGH_BLIZZARD_II,
        _ => request.action_id,
    }
}

/// Check if the BLM can execute the given (already resolved) action.
pub(crate) fn can_execute_blm_action(
    action_id: u32,
    combat_state: &PlayerCombatState,
    status_effects: &StatusEffects,
    level: u8,
) -> bool {
    let blm = &combat_state.blm;
    match action_id {
        ACTION_FIRE_IV | ACTION_DESPAIR | ACTION_FLARE => blm.in_astral_fire(),
        ACTION_BLIZZARD_IV | ACTION_FREEZE => blm.in_umbral_ice(),
        ACTION_FLARE_STAR => blm.astral_soul_stacks >= MAX_ASTRAL_SOUL,
        ACTION_XENOGLOSSY | ACTION_FOUL => {
            blm.polyglot_stacks > 0 && level >= LEVEL_POLYGLOT
        }
        ACTION_PARADOX => blm.paradox_active && level >= LEVEL_PARADOX,
        ACTION_THUNDER
        | ACTION_THUNDER_III
        | ACTION_HIGH_THUNDER
        | ACTION_THUNDER_II
        | ACTION_THUNDER_IV
        | ACTION_HIGH_THUNDER_II => status_effects.get(STATUS_THUNDERHEAD).is_some(),
        ACTION_AMPLIFIER => blm.element_stance != 0,
        ACTION_MANAFONT => blm.in_astral_fire(),
        ACTION_UMBRAL_SOUL => blm.in_umbral_ice(),
        ACTION_TRANSPOSE => blm.element_stance != 0,
        // "发动条件：非黑魔纹状态中"
        ACTION_LEY_LINES => !blm.has_ley_lines_active(),
        ACTION_BETWEEN_THE_LINES => blm.has_ley_lines_active(),
        // Trait#614 (Lv96) enables Retrace; it re-places the active circle.
        ACTION_RETRACE => level >= LEVEL_RETRACE && blm.has_ley_lines_active(),
        _ => true,
    }
}

// ==================== Stance transitions ====================

/// Result of the after-action hook.
#[derive(Debug, Default, Clone, Copy)]
pub(crate) struct BlmActionUpdate {
    /// Gauge-affecting state changed; the caller re-sends the job gauge.
    pub(crate) changed: bool,
    /// A status was added/removed; the caller pushes the effects list.
    pub(crate) status_changed: bool,
    /// MP was restored (ice-hit regen, Umbral Soul, Manafont); the caller syncs HP/MP.
    pub(crate) mp_changed: bool,
}

/// Grant Thunderhead if it isn't already present (one at a time, permanent until consumed).
fn grant_thunderhead(status_effects: &mut StatusEffects, owner_actor_id: ObjectId) -> bool {
    if status_effects.get(STATUS_THUNDERHEAD).is_some() {
        return false;
    }
    status_effects.add_with_source(STATUS_THUNDERHEAD, 0, PERMANENT_STATUS_DURATION, owner_actor_id);
    true
}

/// Grant Firestarter (permanent until consumed by Fire III).
fn grant_firestarter(status_effects: &mut StatusEffects, owner_actor_id: ObjectId) -> bool {
    if status_effects.get(STATUS_FIRESTARTER).is_some() {
        return false;
    }
    status_effects.add_with_source(STATUS_FIRESTARTER, 0, PERMANENT_STATUS_DURATION, owner_actor_id);
    true
}

/// Aspect Mastery V (#465): swapping to the opposite element while at max stance AND max
/// Umbral Hearts lights the Paradox marker.
fn maybe_grant_paradox_on_swap(
    blm: &mut BlmState,
    previous_stance: i8,
    level: u8,
) {
    if level >= LEVEL_PARADOX
        && previous_stance.abs() == MAX_ELEMENT_STANCE
        && blm.umbral_hearts >= MAX_UMBRAL_HEARTS
    {
        blm.paradox_active = true;
    }
}

/// Clear Astral Soul whenever Astral Fire ends (Fire IV / Flare tooltips).
fn clear_astral_soul_if_fire_ended(blm: &mut BlmState) {
    if !blm.in_astral_fire() {
        blm.astral_soul_stacks = 0;
    }
}

/// Update BLM state after an action executes. Mirrors the BRD/SMN hooks: stance transitions,
/// hearts/souls/polyglot/paradox bookkeeping, proc rolls, and MP restoration.
pub(crate) fn update_blm_state_after_action(
    action_id: u32,
    actor: &mut NetworkedActor,
    owner_actor_id: ObjectId,
    sheet_mp_cost: u32,
    aspect: u8,
) -> BlmActionUpdate {
    let level = actor.get_common_spawn().level;
    let NetworkedActor::Player {
        spawn,
        combat_state,
        status_effects,
        ..
    } = actor
    else {
        return BlmActionUpdate::default();
    };

    let blm = &mut combat_state.blm;
    let mut update = BlmActionUpdate::default();

    // An Umbral Heart pays for this fire cast's MP increase (AF only).
    if consumes_umbral_heart(blm, action_id, sheet_mp_cost, aspect) {
        blm.umbral_hearts -= 1;
        update.changed = true;
    }

    let previous_stance = blm.element_stance;
    let max_stacks = BlmState::max_stance_stacks(level);

    match action_id {
        ACTION_FIRE => {
            if blm.in_umbral_ice() {
                // "在处于灵极冰状态时只会解除该状态" — removal is not a swap, no Thunderhead.
                blm.element_stance = 0;
            } else {
                let gained_from_neutral = blm.element_stance == 0;
                blm.element_stance = (blm.element_stance + 1).min(max_stacks);
                if gained_from_neutral {
                    update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
                }
            }
            if level >= LEVEL_FIRESTARTER
                && fastrand::u8(0..100) < FIRESTARTER_PROC_CHANCE_PERCENT
            {
                update.status_changed |= grant_firestarter(status_effects, owner_actor_id);
            }
            update.changed = true;
        }
        ACTION_BLIZZARD => {
            if blm.in_astral_fire() {
                blm.element_stance = 0;
            } else {
                let gained_from_neutral = blm.element_stance == 0;
                blm.element_stance = (blm.element_stance - 1).max(-max_stacks);
                if gained_from_neutral {
                    update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
                }
            }
            update.changed = true;
        }
        ACTION_FIRE_III => {
            let was_swap_or_gain = blm.element_stance <= 0;
            blm.element_stance = max_stacks;
            if was_swap_or_gain {
                update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
                maybe_grant_paradox_on_swap(blm, previous_stance, level);
            }
            // Fire III consumes Firestarter (free + instant, handled at cast time).
            if status_effects.get(STATUS_FIRESTARTER).is_some() {
                status_effects.remove(STATUS_FIRESTARTER);
                update.status_changed = true;
            }
            update.changed = true;
        }
        ACTION_FIRE_II | ACTION_HIGH_FIRE_II => {
            let was_swap_or_gain = blm.element_stance <= 0;
            // Aspect Mastery III (Lv35) makes Fire II grant max stacks; below that it
            // builds one stack like Fire.
            if level >= LEVEL_STANCE_STACKS_3 {
                blm.element_stance = max_stacks;
            } else {
                blm.element_stance = (blm.element_stance + 1).min(max_stacks);
            }
            if was_swap_or_gain {
                update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
                maybe_grant_paradox_on_swap(blm, previous_stance, level);
            }
            update.changed = true;
        }
        ACTION_BLIZZARD_III => {
            let was_swap_or_gain = blm.element_stance >= 0;
            blm.element_stance = -max_stacks;
            if was_swap_or_gain {
                update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
                maybe_grant_paradox_on_swap(blm, previous_stance, level);
            }
            update.changed = true;
        }
        ACTION_BLIZZARD_II | ACTION_HIGH_BLIZZARD_II => {
            let was_swap_or_gain = blm.element_stance >= 0;
            if level >= LEVEL_STANCE_STACKS_3 {
                blm.element_stance = -max_stacks;
            } else {
                blm.element_stance = (blm.element_stance - 1).max(-max_stacks);
            }
            if was_swap_or_gain {
                update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
                maybe_grant_paradox_on_swap(blm, previous_stance, level);
            }
            update.changed = true;
        }
        ACTION_TRANSPOSE => {
            if blm.element_stance != 0 {
                blm.element_stance = -blm.element_stance.signum();
                update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
                maybe_grant_paradox_on_swap(blm, previous_stance, level);
                update.changed = true;
            }
        }
        ACTION_FIRE_IV => {
            if level >= LEVEL_ASTRAL_SOUL {
                blm.astral_soul_stacks = (blm.astral_soul_stacks + 1).min(MAX_ASTRAL_SOUL);
            }
            update.changed = true;
        }
        ACTION_BLIZZARD_IV | ACTION_FREEZE => {
            if level >= LEVEL_UMBRAL_HEART {
                blm.umbral_hearts = MAX_UMBRAL_HEARTS;
            }
            update.changed = true;
        }
        ACTION_DESPAIR => {
            blm.element_stance = max_stacks;
            update.changed = true;
        }
        ACTION_FLARE => {
            blm.element_stance = max_stacks;
            // Flare consumes all Umbral Hearts to reduce its MP cost to 2/3.
            blm.umbral_hearts = 0;
            if level >= LEVEL_ASTRAL_SOUL {
                blm.astral_soul_stacks = (blm.astral_soul_stacks + 3).min(MAX_ASTRAL_SOUL);
            }
            update.changed = true;
        }
        ACTION_FLARE_STAR => {
            blm.astral_soul_stacks = 0;
            update.changed = true;
        }
        ACTION_UMBRAL_SOUL => {
            let common = &mut spawn.common;
            if !combat_state.in_combat {
                // Out of combat: max UI, 3 hearts, and a flat 10000 MP.
                blm.element_stance = -MAX_ELEMENT_STANCE;
                blm.umbral_hearts = MAX_UMBRAL_HEARTS;
                let restored = common
                    .resource_points
                    .saturating_add(UMBRAL_SOUL_OOC_MP as u16)
                    .min(common.max_resource_points);
                common.resource_points = restored;
            } else {
                blm.element_stance = (blm.element_stance - 1).max(-max_stacks);
                blm.umbral_hearts = (blm.umbral_hearts + 1).min(MAX_UMBRAL_HEARTS);
                let mp = UMBRAL_SOUL_MP[(blm.umbral_ice_stacks() as usize - 1).min(2)];
                let restored = common
                    .resource_points
                    .saturating_add(mp.min(u16::MAX as u32) as u16)
                    .min(common.max_resource_points);
                common.resource_points = restored;
            }
            update.changed = true;
            update.mp_changed = true;
        }
        ACTION_MANAFONT => {
            let common = &mut spawn.common;
            common.resource_points = common.max_resource_points;
            blm.element_stance = max_stacks;
            blm.umbral_hearts = MAX_UMBRAL_HEARTS;
            update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
            if level >= LEVEL_PARADOX {
                blm.paradox_active = true;
            }
            update.changed = true;
            update.mp_changed = true;
        }
        ACTION_AMPLIFIER => {
            let cap = BlmState::max_polyglot(level);
            blm.polyglot_stacks = (blm.polyglot_stacks + 1).min(cap);
            update.changed = true;
        }
        ACTION_XENOGLOSSY | ACTION_FOUL => {
            blm.polyglot_stacks = blm.polyglot_stacks.saturating_sub(1);
            update.changed = true;
        }
        ACTION_PARADOX => {
            blm.paradox_active = false;
            if blm.in_astral_fire() {
                update.status_changed |= grant_firestarter(status_effects, owner_actor_id);
            }
            update.changed = true;
        }
        ACTION_THUNDER
        | ACTION_THUNDER_III
        | ACTION_HIGH_THUNDER
        | ACTION_THUNDER_II
        | ACTION_THUNDER_IV
        | ACTION_HIGH_THUNDER_II => {
            if status_effects.get(STATUS_THUNDERHEAD).is_some() {
                status_effects.remove(STATUS_THUNDERHEAD);
                update.status_changed = true;
            }
        }
        ACTION_TRIPLECAST => {
            blm.triplecast_stacks = TRIPLECAST_STACKS;
            blm.triplecast_expires_at = Some(Instant::now() + TRIPLECAST_DURATION);
            status_effects.add_with_source(
                STATUS_TRIPLECAST,
                u16::from(TRIPLECAST_STACKS),
                TRIPLECAST_DURATION.as_secs_f32(),
                owner_actor_id,
            );
            update.status_changed = true;
        }
        ACTION_LEY_LINES | ACTION_RETRACE => {
            // State/position/object handling lives in register_ley_lines_after_action,
            // which has instance + network access.
        }
        _ => {}
    }

    // Ice spells restore MP on hit while in Umbral Ice (Aspect Mastery I/II/III).
    if aspect == ASPECT_ICE && blm.in_umbral_ice() {
        let mp = blm.umbral_ice_mp_on_hit();
        if mp > 0 {
            let common = &mut spawn.common;
            common.resource_points = common
                .resource_points
                .saturating_add(mp.min(u16::MAX as u32) as u16)
                .min(common.max_resource_points);
            update.mp_changed = true;
        }
    }

    // (Triplecast stack consumption happens at the execute site via consume_triplecast_stack,
    // which knows whether the executed spell actually had a cast time.)

    // Stance ended → Astral Soul and the Paradox marker go out (Trait#465).
    if blm.element_stance == 0 && previous_stance != 0 {
        blm.paradox_active = false;
        blm.polyglot_next_at = None;
    }
    clear_astral_soul_if_fire_ended(blm);

    update.changed |= blm.element_stance != previous_stance;
    update
}

/// Consume one Triplecast stack when a spell with a base cast time executes; keeps the
/// Triplecast status in sync (stacks live in its param). Returns true if a stack was eaten.
pub(crate) fn consume_triplecast_stack(actor: &mut NetworkedActor, owner_actor_id: ObjectId) -> bool {
    let NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    } = actor
    else {
        return false;
    };

    let blm = &mut combat_state.blm;
    if blm.triplecast_stacks == 0 {
        return false;
    }
    if blm.triplecast_expires_at.is_some_and(|t| t <= Instant::now()) {
        blm.triplecast_stacks = 0;
        blm.triplecast_expires_at = None;
        return false;
    }

    blm.triplecast_stacks -= 1;
    if blm.triplecast_stacks == 0 {
        blm.triplecast_expires_at = None;
        status_effects.remove(STATUS_TRIPLECAST);
    } else {
        let remaining = blm
            .triplecast_expires_at
            .map(|t| t.saturating_duration_since(Instant::now()).as_secs_f32())
            .unwrap_or(1.0);
        status_effects.add_with_source(
            STATUS_TRIPLECAST,
            u16::from(blm.triplecast_stacks),
            remaining,
            owner_actor_id,
        );
    }
    true
}

// ==================== Thunder DoT exclusivity ====================

/// The status id each thunder action applies, used to drop the *other* thunder DoTs.
pub(crate) fn thunder_dot_status(action_id: u32) -> Option<u16> {
    match action_id {
        ACTION_THUNDER => Some(161),
        ACTION_THUNDER_II => Some(162),
        ACTION_THUNDER_III => Some(163),
        ACTION_THUNDER_IV => Some(1210),
        ACTION_HIGH_THUNDER => Some(3871),
        ACTION_HIGH_THUNDER_II => Some(3872),
        _ => None,
    }
}

// ==================== Runtime tick ====================

/// Result of the per-tick runtime refresh.
#[derive(Debug, Default, Clone, Copy)]
pub(crate) struct BlmRuntimeUpdate {
    pub(crate) changed: bool,
    pub(crate) status_changed: bool,
    /// A Ley Lines circle object that expired this tick and must be despawned.
    pub(crate) despawn_object_id: Option<ObjectId>,
}

/// Per-server-tick driver: Polyglot generation (every 30s in a stance), Ley Lines expiry,
/// and the standing-in-Ley-Lines status. Mirrors `refresh_bard_runtime_state_on_actor`.
pub(crate) fn refresh_blm_runtime_state_on_actor(
    _actor_id: ObjectId,
    actor: &mut NetworkedActor,
) -> BlmRuntimeUpdate {
    let level = actor.get_common_spawn().level;
    let position = actor.get_common_spawn().position.0;
    let NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    } = actor
    else {
        return BlmRuntimeUpdate::default();
    };

    let blm = &mut combat_state.blm;
    let now = Instant::now();
    let mut update = BlmRuntimeUpdate::default();

    // Triplecast expiry.
    if blm.triplecast_expires_at.is_some_and(|t| t <= now) {
        blm.triplecast_stacks = 0;
        blm.triplecast_expires_at = None;
        if status_effects.get(STATUS_TRIPLECAST).is_some() {
            status_effects.remove(STATUS_TRIPLECAST);
            update.status_changed = true;
        }
    }

    // Polyglot generation: one stack every 30s while in Astral Fire or Umbral Ice.
    let polyglot_cap = BlmState::max_polyglot(level);
    if blm.element_stance != 0 && polyglot_cap > 0 {
        if blm.polyglot_stacks >= polyglot_cap {
            blm.polyglot_next_at = None;
        } else {
            let next_at = blm.polyglot_next_at.get_or_insert(now + POLYGLOT_INTERVAL);
            if now >= *next_at {
                blm.polyglot_stacks += 1;
                blm.polyglot_next_at =
                    (blm.polyglot_stacks < polyglot_cap).then_some(now + POLYGLOT_INTERVAL);
                update.changed = true;
            }
        }
    } else {
        blm.polyglot_next_at = None;
    }

    // Ley Lines: expire, and maintain the marker (737) / standing-inside haste (738).
    if blm.ley_lines_expires_at.is_some_and(|t| t <= now) {
        blm.ley_lines_expires_at = None;
        blm.ley_lines_position = None;
        update.despawn_object_id = blm.ley_lines_object_id.take();
        for status in [STATUS_LEY_LINES, STATUS_CIRCLE_OF_POWER] {
            if status_effects.get(status).is_some() {
                status_effects.remove(status);
                update.status_changed = true;
            }
        }
    }
    if blm.has_ley_lines_active()
        && let Some(lines_position) = blm.ley_lines_position
    {
        // 黑魔纹 (737): "lines are down" marker carrying the remaining duration; only
        // re-applied when missing (the client counts it down locally).
        if status_effects.get(STATUS_LEY_LINES).is_none() {
            let remaining = blm
                .ley_lines_expires_at
                .map(|t| t.saturating_duration_since(now).as_secs_f32())
                .unwrap_or(1.0);
            status_effects.add_with_source(STATUS_LEY_LINES, 0, remaining, _actor_id);
            update.status_changed = true;
        }
        // 魔纹环 (738, Circle of Power): the actual haste buff, re-applied in 5-second
        // windows while standing inside the circle.
        let inside = position.distance(lines_position) <= LEY_LINES_RADIUS;
        let has_haste = status_effects.get(STATUS_CIRCLE_OF_POWER).is_some();
        if inside && !has_haste {
            status_effects.add_with_source(
                STATUS_CIRCLE_OF_POWER,
                0,
                CIRCLE_OF_POWER_DURATION,
                _actor_id,
            );
            update.status_changed = true;
        } else if !inside && has_haste {
            status_effects.remove(STATUS_CIRCLE_OF_POWER);
            update.status_changed = true;
        }
    }

    update
}

// ==================== Job gauge ====================

/// Pack the BLM job gauge. Byte layout (FFXIVClientStructs BlackMageGauge, data starts at
/// the struct's 0x08, which is what ActorGauge carries):
///   [0..2] EnochianTimer (i16 LE, ms — in 7.x this drives the Polyglot progress display:
///          remaining time until the next stack, 0 when capped or stance-less)
///   [2]    ElementStance (sbyte: +N = Astral Fire, -N = Umbral Ice — two's complement!)
///   [3]    UmbralHearts
///   [4]    PolyglotStacks
///   [5]    EnochianFlags (bit0 = Enochian, bit1 = Paradox, bits2-4 = AstralSoul 0-6)
///   [6..8] padding
pub(crate) fn build_blm_gauge_data(combat_state: &PlayerCombatState, level: u8) -> u64 {
    let blm = &combat_state.blm;

    let polyglot_timer_ms = if blm.element_stance != 0 && level >= LEVEL_POLYGLOT {
        blm.polyglot_next_at
            .map(|t| {
                t.saturating_duration_since(std::time::Instant::now())
                    .as_millis()
                    .min(u128::from(u16::MAX)) as u16
            })
            .unwrap_or(0)
    } else {
        0
    };

    let hearts = if level >= LEVEL_UMBRAL_HEART {
        blm.umbral_hearts
    } else {
        0
    };
    let polyglot = blm.polyglot_stacks.min(BlmState::max_polyglot(level));

    let mut flags = 0u8;
    if blm.element_stance != 0 && level >= LEVEL_ENOCHIAN {
        flags |= 1; // Enochian (天语, Trait#460 Lv56)
    }
    if blm.paradox_active && level >= LEVEL_PARADOX {
        flags |= 2; // Paradox
    }
    if level >= LEVEL_ASTRAL_SOUL {
        flags |= (blm.astral_soul_stacks & 7) << 2;
    }

    let [timer_lo, timer_hi] = polyglot_timer_ms.to_le_bytes();
    let bytes = [
        timer_lo,
        timer_hi,
        blm.element_stance as u8, // i8 two's complement: UI3 = 0xFD
        hearts,
        polyglot,
        flags,
        0,
        0,
    ];
    u64::from_le_bytes(bytes)
}

// ==================== Ley Lines ground circle ====================

/// Handle Ley Lines / Retrace after the action executes: (re)place the ground circle at the
/// requested position (the CN 7.51 client sends the caster's feet for these), spawn the VFX
/// object, and despawn the previous circle when Retrace replaces it. Mirrors the retail
/// ObjectSpawn (base_id 0x179, AreaObject, radius 3.0, not targetable).
pub(crate) fn register_ley_lines_after_action(
    network: Arc<Mutex<NetworkState>>,
    instance: &mut Instance,
    from_actor_id: ObjectId,
    action_id: u32,
    ground_position: Option<Position>,
) {
    if !matches!(action_id, ACTION_LEY_LINES | ACTION_RETRACE) {
        return;
    }

    let Some(actor) = instance.find_actor(from_actor_id) else {
        return;
    };
    let position = ground_position.unwrap_or_else(|| actor.position());
    let rotation = actor.get_common_spawn().rotation;

    let old_object_id;
    let object_id = ObjectId(fastrand::u32(..));
    {
        let Some(NetworkedActor::Player { combat_state, .. }) =
            instance.find_actor_mut(from_actor_id)
        else {
            return;
        };
        let blm = &mut combat_state.blm;

        old_object_id = blm.ley_lines_object_id.take();
        blm.ley_lines_position = Some(position.0);
        // Retrace inherits the remaining duration; a fresh Ley Lines starts the full 20s.
        if action_id == ACTION_LEY_LINES {
            blm.ley_lines_expires_at = Some(Instant::now() + LEY_LINES_DURATION);
        }
        blm.ley_lines_object_id = Some(object_id);
    }

    // Refresh the marker status so it shows the (possibly inherited) remaining duration.
    if let Some(NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    }) = instance.find_actor_mut(from_actor_id)
    {
        let remaining = combat_state
            .blm
            .ley_lines_expires_at
            .map(|t| t.saturating_duration_since(Instant::now()).as_secs_f32())
            .unwrap_or(LEY_LINES_DURATION.as_secs_f32());
        status_effects.add_with_source(STATUS_LEY_LINES, 0, remaining, from_actor_id);
    }

    let spawn = SpawnObject {
        kind: ObjectKind::AreaObject,
        not_targetable: true,
        base_id: LEY_LINES_GROUND_VFX_ID,
        entity_id: object_id,
        owner_id: from_actor_id,
        radius: LEY_LINES_RADIUS,
        rotation,
        position,
        ..Default::default()
    };
    instance.insert_object(object_id, spawn, String::default());

    let mut network = network.lock();
    network.spawn_inserted_object_in_range(instance, object_id);
    if let Some(old_object_id) = old_object_id {
        network.remove_actor(instance, old_object_id);
    }
}
