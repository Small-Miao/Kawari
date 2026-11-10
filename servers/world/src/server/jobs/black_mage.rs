//! Black Mage (BLM) job-specific logic: elemental stance (Astral Fire / Umbral Ice),
//! Umbral Hearts, Astral Soul, Polyglot, Paradox, Ley Lines, and the job gauge.
//!
//! All numbers follow the CN 7.51 client data: action tooltips (actionaudit-BLM.json),
//! Trait/TraitTransient rows (极性精通 I-V = Aspect Mastery I-V) and Status rows from the
//! game sheets. Notable sources:
//!   - Trait#296/458/459 (Aspect Mastery I/II/III): stance damage & MP rules, per-tier values.
//!   - Trait#465 (Aspect Mastery V, Lv90): Paradox on a swap from AF III, or from UI III
//!     with three Umbral Hearts. The marker clears when the stance ends.
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
    common::{ANIMATION_LOCK_TIME, ObjectId, Position},
    ipc::zone::{ActionRequest, ObjectKind, SpawnObject, TargetEffectKind},
};

/// ClassJob row id for Black Mage (BLM).
const CLASSJOB_BLACK_MAGE: u8 = 25;
/// Class row id for Thaumaturge (THM), the base class — shares the entire elemental mechanic.
const CLASSJOB_THAUMATURGE: u8 = 7;

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
pub(crate) const ACTION_MANAFONT: u32 = 158;
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
/// MP restored by an ice spell hit or Umbral Soul, based on the tier before the action.
const UMBRAL_ICE_MP: [u16; 3] = [2500, 5000, 10000];
const UMBRAL_SOUL_OOC_MP: u16 = 10000;

/// "Permanent" buffs (Firestarter, Thunderhead) use a far-future duration; the client shows
/// no countdown for very long statuses, and both are consumed server-side long before expiry.
const PERMANENT_STATUS_DURATION: f32 = 604800.0;

/// Black Mage job state tracked server-side.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq)]
pub struct BlackMageState {
    /// Elemental stance: 1-3 = Astral Fire stacks, -1..-3 = Umbral Ice stacks, 0 = none.
    pub element_stance: i8,
    /// Umbral Hearts (0-3). Each nullifies the AF fire MP increase for one cast; Flare
    /// consumes all of them to reduce its cost to 66% of current MP.
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

impl BlackMageState {
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
        self.ley_lines_expires_at
            .is_some_and(|t| t > Instant::now())
    }

    pub(crate) fn has_triplecast(&self) -> bool {
        self.triplecast_stacks > 0
            && self
                .triplecast_expires_at
                .is_some_and(|t| t > Instant::now())
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

    fn umbral_ice_mp(&self) -> u16 {
        let stacks = self.umbral_ice_stacks();
        if stacks == 0 {
            0
        } else {
            UMBRAL_ICE_MP[(stacks as usize - 1).min(2)]
        }
    }

    fn update_polyglot_timer(&mut self, level: u8, now: Instant) -> bool {
        let cap = Self::max_polyglot(level);
        if self.element_stance == 0 || cap == 0 {
            return self.polyglot_next_at.take().is_some();
        }

        let Some(next_at) = self.polyglot_next_at else {
            self.polyglot_next_at = Some(now + POLYGLOT_INTERVAL);
            return true;
        };
        if now < next_at {
            return false;
        }

        self.polyglot_stacks = self.polyglot_stacks.saturating_add(1).min(cap);
        self.polyglot_next_at = Some(next_at + POLYGLOT_INTERVAL);
        true
    }
}

/// Check if the given class_job is Black Mage (or base class Thaumaturge).
pub(crate) fn is_black_mage(class_job: u8) -> bool {
    class_job == CLASSJOB_BLACK_MAGE || class_job == CLASSJOB_THAUMATURGE
}

pub(crate) fn gauge_class_job_id() -> u8 {
    CLASSJOB_BLACK_MAGE
}

pub(crate) fn deactivate(actor: &mut NetworkedActor) -> Option<ObjectId> {
    let NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    } = actor
    else {
        return None;
    };
    let previous = std::mem::take(&mut combat_state.black_mage);
    for status in [
        STATUS_FIRESTARTER,
        STATUS_THUNDERHEAD,
        STATUS_TRIPLECAST,
        STATUS_LEY_LINES,
        STATUS_CIRCLE_OF_POWER,
    ] {
        status_effects.remove(status);
    }
    previous.ley_lines_object_id
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
pub(crate) fn element_damage_percent(
    state: &BlackMageState,
    action_id: u32,
    aspect: u8,
    level: u8,
) -> u32 {
    // Scathe: 20% chance to deal double damage, rolled here because this multiplier is
    // applied to every damage instance of the cast (primary + AoE secondaries).
    let scathe =
        if action_id == ACTION_SCATHE && fastrand::u8(0..100) < SCATHE_DOUBLE_CHANCE_PERCENT {
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
///   - Flare consumes all MP (min 800); with any Umbral Hearts it costs 66% of current MP.
///   - Despair consumes all MP (min 800). Paradox costs 1600 in AF and 0 in UI.
///
/// `sheet_cost` is the Action-sheet MP cost (0 for the special cost types).
pub(crate) fn effective_mp_cost(
    state: &BlackMageState,
    action_id: u32,
    sheet_cost: u32,
    aspect: u8,
    current_mp: u32,
    has_firestarter: bool,
) -> u32 {
    match action_id {
        ACTION_FLARE => {
            if state.umbral_hearts > 0 {
                (u64::from(current_mp) * 66 / 100) as u32
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
fn consumes_umbral_heart(
    state: &BlackMageState,
    action_id: u32,
    actual_mp_cost: u32,
    aspect: u8,
) -> bool {
    state.in_astral_fire()
        && state.umbral_hearts > 0
        && aspect == ASPECT_FIRE
        && actual_mp_cost > 0
        // All-MP spells bypass the normal discount. Flare spends the whole stack separately.
        && !matches!(action_id, ACTION_FLARE | ACTION_DESPAIR)
}

/// Minimum MP required to cast (Flare/Despair consume all MP but still demand 800+).
pub(crate) fn min_mp_requirement(action_id: u32) -> u32 {
    match action_id {
        ACTION_FLARE | ACTION_DESPAIR => ALL_MP_COST_MIN,
        _ => 0,
    }
}

// ==================== Cast time rules ====================

/// These spells are already instant before applying Swiftcast or Triplecast.
pub(crate) fn is_instant_without_cast_buff(
    action_id: u32,
    level: u8,
    has_firestarter: bool,
) -> bool {
    match action_id {
        ACTION_FIRE_III => has_firestarter,
        ACTION_FOUL => level >= LEVEL_POLYGLOT_2,
        ACTION_DESPAIR => level >= LEVEL_ASTRAL_SOUL,
        _ => false,
    }
}

/// AF3 halves ice cast times and UI3 halves fire cast times (Aspect Mastery III).
pub(crate) fn cast_time_halved(state: &BlackMageState, aspect: u8) -> bool {
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
pub(crate) fn resolve_black_mage_action(
    request: &ActionRequest,
    combat_state: &PlayerCombatState,
    level: u8,
) -> u32 {
    let black_mage = &combat_state.black_mage;

    // Paradox replaces Fire/Blizzard while the marker is lit.
    if black_mage.paradox_active && matches!(request.action_id, ACTION_FIRE | ACTION_BLIZZARD) {
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
pub(crate) fn can_execute_black_mage_action(
    action_id: u32,
    combat_state: &PlayerCombatState,
    status_effects: &StatusEffects,
    level: u8,
) -> bool {
    let black_mage = &combat_state.black_mage;
    match action_id {
        ACTION_FIRE_IV | ACTION_DESPAIR | ACTION_FLARE => black_mage.in_astral_fire(),
        ACTION_BLIZZARD_IV | ACTION_FREEZE => black_mage.in_umbral_ice(),
        ACTION_FLARE_STAR => black_mage.astral_soul_stacks >= MAX_ASTRAL_SOUL,
        ACTION_XENOGLOSSY | ACTION_FOUL => {
            black_mage.polyglot_stacks > 0 && level >= LEVEL_POLYGLOT
        }
        ACTION_PARADOX => black_mage.paradox_active && level >= LEVEL_PARADOX,
        ACTION_THUNDER
        | ACTION_THUNDER_III
        | ACTION_HIGH_THUNDER
        | ACTION_THUNDER_II
        | ACTION_THUNDER_IV
        | ACTION_HIGH_THUNDER_II => status_effects.get(STATUS_THUNDERHEAD).is_some(),
        ACTION_AMPLIFIER => black_mage.element_stance != 0,
        ACTION_MANAFONT => black_mage.in_astral_fire(),
        ACTION_UMBRAL_SOUL => black_mage.in_umbral_ice(),
        ACTION_TRANSPOSE => black_mage.element_stance != 0,
        // "发动条件：非黑魔纹状态中"
        ACTION_LEY_LINES => !black_mage.has_ley_lines_active(),
        ACTION_BETWEEN_THE_LINES => black_mage.has_ley_lines_active(),
        // Trait#614 (Lv96) enables Retrace; it re-places the active circle.
        ACTION_RETRACE => level >= LEVEL_RETRACE && black_mage.has_ley_lines_active(),
        _ => true,
    }
}

// ==================== Stance transitions ====================

/// Result of the after-action hook.
#[derive(Debug, Default, Clone, Copy)]
pub(crate) struct BlackMageActionUpdate {
    /// Gauge-affecting state changed; the caller re-sends the job gauge.
    pub(crate) changed: bool,
    /// A status was added/removed; the caller pushes the effects list.
    pub(crate) status_changed: bool,
    /// Nominal MP restored before clamping to maximum MP, also sent in the action effect.
    pub(crate) mp_restored: u16,
}

/// Grant Thunderhead if it isn't already present (one at a time, permanent until consumed).
fn grant_thunderhead(status_effects: &mut StatusEffects, owner_actor_id: ObjectId) -> bool {
    if status_effects.get(STATUS_THUNDERHEAD).is_some() {
        return false;
    }
    status_effects.add_with_source(
        STATUS_THUNDERHEAD,
        0,
        PERMANENT_STATUS_DURATION,
        owner_actor_id,
    );
    true
}

/// Grant Firestarter (permanent until consumed by Fire III).
fn grant_firestarter(status_effects: &mut StatusEffects, owner_actor_id: ObjectId) -> bool {
    if status_effects.get(STATUS_FIRESTARTER).is_some() {
        return false;
    }
    status_effects.add_with_source(
        STATUS_FIRESTARTER,
        0,
        PERMANENT_STATUS_DURATION,
        owner_actor_id,
    );
    true
}

/// Aspect Mastery V (#465): AF III can swap directly; UI III also needs three hearts.
fn maybe_grant_paradox_on_swap(black_mage: &mut BlackMageState, previous_stance: i8, level: u8) {
    let from_max_fire = previous_stance == MAX_ELEMENT_STANCE && black_mage.in_umbral_ice();
    let from_full_ice = previous_stance == -MAX_ELEMENT_STANCE
        && black_mage.in_astral_fire()
        && black_mage.umbral_hearts >= MAX_UMBRAL_HEARTS;
    if level >= LEVEL_PARADOX && (from_max_fire || from_full_ice) {
        black_mage.paradox_active = true;
    }
}

/// Clear Astral Soul whenever Astral Fire ends (Fire IV / Flare tooltips).
fn clear_astral_soul_if_fire_ended(black_mage: &mut BlackMageState) {
    if !black_mage.in_astral_fire() {
        black_mage.astral_soul_stacks = 0;
    }
}

/// Update BLM state after an action executes. Mirrors the BRD/SMN hooks: stance transitions,
/// hearts/souls/polyglot/paradox bookkeeping, proc rolls, and MP restoration.
pub(crate) fn update_black_mage_state_after_action(
    action_id: u32,
    actor: &mut NetworkedActor,
    owner_actor_id: ObjectId,
    actual_mp_cost: u32,
    aspect: u8,
    landed_damage: bool,
) -> BlackMageActionUpdate {
    let level = actor.get_common_spawn().level;
    let NetworkedActor::Player {
        spawn,
        combat_state,
        status_effects,
        ..
    } = actor
    else {
        return BlackMageActionUpdate::default();
    };

    let black_mage = &mut combat_state.black_mage;
    let mut update = BlackMageActionUpdate::default();

    // An Umbral Heart pays for this fire cast's MP increase (AF only).
    if consumes_umbral_heart(black_mage, action_id, actual_mp_cost, aspect) {
        black_mage.umbral_hearts -= 1;
        update.changed = true;
    }

    let previous_stance = black_mage.element_stance;
    let max_stacks = BlackMageState::max_stance_stacks(level);
    let previous_ice_mp = black_mage.umbral_ice_mp();
    let mut mp_restore = if aspect == ASPECT_ICE && landed_damage {
        previous_ice_mp
    } else {
        0
    };

    match action_id {
        ACTION_FIRE => {
            if black_mage.in_umbral_ice() {
                // "在处于灵极冰状态时只会解除该状态" — removal is not a swap, no Thunderhead.
                black_mage.element_stance = 0;
            } else {
                let gained_from_neutral = black_mage.element_stance == 0;
                black_mage.element_stance = (black_mage.element_stance + 1).min(max_stacks);
                if gained_from_neutral {
                    update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
                }
            }
            if level >= LEVEL_FIRESTARTER && fastrand::u8(0..100) < FIRESTARTER_PROC_CHANCE_PERCENT
            {
                update.status_changed |= grant_firestarter(status_effects, owner_actor_id);
            }
            update.changed = true;
        }
        ACTION_BLIZZARD => {
            if black_mage.in_astral_fire() {
                black_mage.element_stance = 0;
            } else {
                let gained_from_neutral = black_mage.element_stance == 0;
                black_mage.element_stance = (black_mage.element_stance - 1).max(-max_stacks);
                if gained_from_neutral {
                    update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
                }
            }
            update.changed = true;
        }
        ACTION_FIRE_III => {
            let was_swap_or_gain = black_mage.element_stance <= 0;
            black_mage.element_stance = max_stacks;
            if was_swap_or_gain {
                update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
                maybe_grant_paradox_on_swap(black_mage, previous_stance, level);
            }
            // Fire III consumes Firestarter (free + instant, handled at cast time).
            if status_effects.get(STATUS_FIRESTARTER).is_some() {
                status_effects.remove(STATUS_FIRESTARTER);
                update.status_changed = true;
            }
            update.changed = true;
        }
        ACTION_FIRE_II | ACTION_HIGH_FIRE_II => {
            let was_swap_or_gain = black_mage.element_stance <= 0;
            // Aspect Mastery III (Lv35) makes Fire II grant max stacks; below that it
            // builds one stack like Fire.
            if level >= LEVEL_STANCE_STACKS_3 {
                black_mage.element_stance = max_stacks;
            } else {
                black_mage.element_stance = (black_mage.element_stance + 1).min(max_stacks);
            }
            if was_swap_or_gain {
                update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
                maybe_grant_paradox_on_swap(black_mage, previous_stance, level);
            }
            update.changed = true;
        }
        ACTION_BLIZZARD_III => {
            let was_swap_or_gain = black_mage.element_stance >= 0;
            black_mage.element_stance = -max_stacks;
            if was_swap_or_gain {
                update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
                maybe_grant_paradox_on_swap(black_mage, previous_stance, level);
            }
            update.changed = true;
        }
        ACTION_BLIZZARD_II | ACTION_HIGH_BLIZZARD_II => {
            let was_swap_or_gain = black_mage.element_stance >= 0;
            if level >= LEVEL_STANCE_STACKS_3 {
                black_mage.element_stance = -max_stacks;
            } else {
                black_mage.element_stance = (black_mage.element_stance - 1).max(-max_stacks);
            }
            if was_swap_or_gain {
                update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
                maybe_grant_paradox_on_swap(black_mage, previous_stance, level);
            }
            update.changed = true;
        }
        ACTION_TRANSPOSE => {
            if black_mage.element_stance != 0 {
                black_mage.element_stance = -black_mage.element_stance.signum();
                update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
                maybe_grant_paradox_on_swap(black_mage, previous_stance, level);
                update.changed = true;
            }
        }
        ACTION_FIRE_IV => {
            if level >= LEVEL_ASTRAL_SOUL && landed_damage {
                black_mage.astral_soul_stacks =
                    (black_mage.astral_soul_stacks + 1).min(MAX_ASTRAL_SOUL);
            }
            update.changed = true;
        }
        ACTION_BLIZZARD_IV | ACTION_FREEZE => {
            if level >= LEVEL_UMBRAL_HEART {
                black_mage.umbral_hearts = MAX_UMBRAL_HEARTS;
            }
            update.changed = true;
        }
        ACTION_DESPAIR => {
            black_mage.element_stance = max_stacks;
            update.changed = true;
        }
        ACTION_FLARE => {
            black_mage.element_stance = max_stacks;
            black_mage.umbral_hearts = 0;
            if level >= LEVEL_ASTRAL_SOUL && landed_damage {
                black_mage.astral_soul_stacks =
                    (black_mage.astral_soul_stacks + 3).min(MAX_ASTRAL_SOUL);
            }
            update.changed = true;
        }
        ACTION_FLARE_STAR => {
            black_mage.astral_soul_stacks = 0;
            update.changed = true;
        }
        ACTION_UMBRAL_SOUL => {
            if combat_state.in_combat {
                black_mage.element_stance = (black_mage.element_stance - 1).max(-max_stacks);
                black_mage.umbral_hearts = (black_mage.umbral_hearts + 1).min(MAX_UMBRAL_HEARTS);
                mp_restore = previous_ice_mp;
            } else {
                black_mage.element_stance = -max_stacks;
                black_mage.umbral_hearts = MAX_UMBRAL_HEARTS;
                mp_restore = UMBRAL_SOUL_OOC_MP;
            }
            update.changed = true;
        }
        ACTION_MANAFONT => {
            mp_restore = spawn.common.max_resource_points;
            black_mage.element_stance = max_stacks;
            black_mage.umbral_hearts = MAX_UMBRAL_HEARTS;
            update.status_changed |= grant_thunderhead(status_effects, owner_actor_id);
            if level >= LEVEL_PARADOX {
                black_mage.paradox_active = true;
            }
            update.changed = true;
        }
        ACTION_AMPLIFIER => {
            let cap = BlackMageState::max_polyglot(level);
            black_mage.polyglot_stacks = (black_mage.polyglot_stacks + 1).min(cap);
            update.changed = true;
        }
        ACTION_XENOGLOSSY | ACTION_FOUL => {
            black_mage.polyglot_stacks = black_mage.polyglot_stacks.saturating_sub(1);
            update.changed = true;
        }
        ACTION_PARADOX => {
            black_mage.paradox_active = false;
            if black_mage.in_astral_fire() {
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
            black_mage.triplecast_stacks = TRIPLECAST_STACKS;
            black_mage.triplecast_expires_at = Some(Instant::now() + TRIPLECAST_DURATION);
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

    if mp_restore > 0 {
        let common = &mut spawn.common;
        common.resource_points = common
            .resource_points
            .saturating_add(mp_restore)
            .min(common.max_resource_points);
        update.mp_restored = mp_restore;
    }

    // (Triplecast stack consumption happens at the execute site via consume_triplecast_stack,
    // which knows whether the executed spell actually had a cast time.)

    // Stance ended → Astral Soul and the Paradox marker go out (Trait#465).
    if black_mage.element_stance == 0 && previous_stance != 0 {
        black_mage.paradox_active = false;
        black_mage.umbral_hearts = 0;
    }
    clear_astral_soul_if_fire_ended(black_mage);

    update.changed |= black_mage.element_stance != previous_stance;
    update.changed |= black_mage.update_polyglot_timer(level, Instant::now());
    update
}

/// Consume one Triplecast stack when a spell with a base cast time executes; keeps the
/// Triplecast status in sync (stacks live in its param). Returns true if a stack was eaten.
pub(crate) fn consume_triplecast_stack(
    actor: &mut NetworkedActor,
    owner_actor_id: ObjectId,
) -> bool {
    let NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    } = actor
    else {
        return false;
    };

    let black_mage = &mut combat_state.black_mage;
    if black_mage.triplecast_stacks == 0 {
        return false;
    }
    if black_mage
        .triplecast_expires_at
        .is_some_and(|t| t <= Instant::now())
    {
        black_mage.triplecast_stacks = 0;
        black_mage.triplecast_expires_at = None;
        return false;
    }

    black_mage.triplecast_stacks -= 1;
    if black_mage.triplecast_stacks == 0 {
        black_mage.triplecast_expires_at = None;
        status_effects.remove(STATUS_TRIPLECAST);
    } else {
        let remaining = black_mage
            .triplecast_expires_at
            .map(|t| t.saturating_duration_since(Instant::now()).as_secs_f32())
            .unwrap_or(1.0);
        status_effects.add_with_source(
            STATUS_TRIPLECAST,
            u16::from(black_mage.triplecast_stacks),
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
pub(crate) struct BlackMageRuntimeUpdate {
    pub(crate) changed: bool,
    pub(crate) status_changed: bool,
    /// A Ley Lines circle object that expired this tick and must be despawned.
    pub(crate) despawn_object_id: Option<ObjectId>,
}

/// Per-server-tick driver: Polyglot generation (every 30s in a stance), Ley Lines expiry,
/// and the standing-in-Ley-Lines status. Mirrors `refresh_bard_runtime_state_on_actor`.
pub(crate) fn refresh_black_mage_runtime_state_on_actor(
    _actor_id: ObjectId,
    actor: &mut NetworkedActor,
) -> BlackMageRuntimeUpdate {
    let level = actor.get_common_spawn().level;
    let position = actor.get_common_spawn().position.0;
    let NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    } = actor
    else {
        return BlackMageRuntimeUpdate::default();
    };

    let black_mage = &mut combat_state.black_mage;
    let now = Instant::now();
    let mut update = BlackMageRuntimeUpdate::default();

    // Triplecast expiry.
    if black_mage.triplecast_expires_at.is_some_and(|t| t <= now) {
        black_mage.triplecast_stacks = 0;
        black_mage.triplecast_expires_at = None;
        if status_effects.get(STATUS_TRIPLECAST).is_some() {
            status_effects.remove(STATUS_TRIPLECAST);
            update.status_changed = true;
        }
    }

    update.changed |= black_mage.update_polyglot_timer(level, now);

    // Ley Lines: expire, and maintain the marker (737) / standing-inside haste (738).
    if black_mage.ley_lines_expires_at.is_some_and(|t| t <= now) {
        black_mage.ley_lines_expires_at = None;
        black_mage.ley_lines_position = None;
        update.despawn_object_id = black_mage.ley_lines_object_id.take();
        for status in [STATUS_LEY_LINES, STATUS_CIRCLE_OF_POWER] {
            if status_effects.get(status).is_some() {
                status_effects.remove(status);
                update.status_changed = true;
            }
        }
    }
    if black_mage.has_ley_lines_active()
        && let Some(lines_position) = black_mage.ley_lines_position
    {
        // 黑魔纹 (737): "lines are down" marker carrying the remaining duration; only
        // re-applied when missing (the client counts it down locally).
        if status_effects.get(STATUS_LEY_LINES).is_none() {
            let remaining = black_mage
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
///          remaining time until the next 30-second tick, 0 when stance-less)
///   [2]    ElementStance (sbyte: +N = Astral Fire, -N = Umbral Ice — two's complement!)
///   [3]    UmbralHearts
///   [4]    PolyglotStacks
///   [5]    EnochianFlags (bit0 = Enochian, bit1 = Paradox, bits2-4 = AstralSoul 0-6)
///   [6..8] padding
pub(crate) fn build_black_mage_gauge_data(combat_state: &PlayerCombatState, level: u8) -> u64 {
    pack_black_mage_gauge(&combat_state.black_mage, level, Instant::now())
}

fn pack_black_mage_gauge(black_mage: &BlackMageState, level: u8, now: Instant) -> u64 {
    let polyglot_cap = BlackMageState::max_polyglot(level);
    let polyglot = black_mage.polyglot_stacks.min(polyglot_cap);
    let polyglot_timer_ms = if black_mage.element_stance != 0 && polyglot_cap > 0 {
        black_mage
            .polyglot_next_at
            .map(|t| {
                t.saturating_duration_since(now)
                    .as_micros()
                    .div_ceil(1000)
                    .min(i16::MAX as u128) as i16
            })
            .unwrap_or(0)
    } else {
        0
    };

    let hearts = if level >= LEVEL_UMBRAL_HEART {
        black_mage.umbral_hearts
    } else {
        0
    };

    let mut flags = 0u8;
    if black_mage.element_stance != 0 && level >= LEVEL_ENOCHIAN {
        flags |= 1; // Enochian (天语, Trait#460 Lv56)
    }
    if black_mage.paradox_active && level >= LEVEL_PARADOX {
        flags |= 2; // Paradox
    }
    if level >= LEVEL_ASTRAL_SOUL {
        flags |= (black_mage.astral_soul_stacks & 7) << 2;
    }

    let [timer_lo, timer_hi] = polyglot_timer_ms.to_le_bytes();
    let bytes = [
        timer_lo,
        timer_hi,
        black_mage.element_stance as u8, // i8 two's complement: UI3 = 0xFD
        hearts,
        polyglot,
        flags,
        0,
        0,
    ];
    u64::from_le_bytes(bytes)
}

// ==================== Ley Lines ground circle ====================

pub(crate) fn ley_lines_action_result(
    actor: &NetworkedActor,
    action_id: u32,
) -> Option<(Position, TargetEffectKind, f32)> {
    let NetworkedActor::Player { combat_state, .. } = actor else {
        return None;
    };
    let (effect, animation_lock) = match action_id {
        ACTION_LEY_LINES => (
            TargetEffectKind::GainEffectSelf {
                unk1: 0,
                unk2: 0,
                unk3: 0,
                param: 0,
                effect_id: STATUS_LEY_LINES,
                duration: LEY_LINES_DURATION.as_secs_f32(),
            },
            ANIMATION_LOCK_TIME,
        ),
        ACTION_BETWEEN_THE_LINES => (
            TargetEffectKind::Teleport {
                unk: [0; 5],
                territory: 0,
            },
            0.8,
        ),
        _ => return None,
    };
    let black_mage = &combat_state.black_mage;
    if !black_mage.has_ley_lines_active() {
        return None;
    }
    Some((
        Position(black_mage.ley_lines_position?),
        effect,
        animation_lock,
    ))
}

/// Handle Ley Lines / Retrace after the action executes: (re)place the ground circle at the
/// requested position (the CN 7.51 client sends the caster's feet for these), spawn the VFX
/// object, and despawn the previous circle when Retrace replaces it. Mirrors the retail
/// ObjectSpawn (base_id 0x179, AreaObject, radius 3.0, flags 0x04).
/// Returns the inserted object so the caller can send its spawn after the action result.
pub(in crate::server) fn register_ley_lines_after_action(
    network: Arc<Mutex<NetworkState>>,
    instance: &mut Instance,
    from_actor_id: ObjectId,
    action_id: u32,
    ground_position: Option<Position>,
) -> Option<ObjectId> {
    if !matches!(action_id, ACTION_LEY_LINES | ACTION_RETRACE) {
        return None;
    }

    let actor = instance.find_actor(from_actor_id)?;
    let position = ground_position
        .filter(|position| position.0.is_finite())
        .unwrap_or_else(|| actor.position());

    let old_object_id;
    let object_id = loop {
        let candidate = ObjectId(fastrand::u32(0x4000_0000..0x5000_0000));
        if instance.find_actor(candidate).is_none() {
            break candidate;
        }
    };
    {
        let Some(NetworkedActor::Player {
            combat_state,
            status_effects,
            ..
        }) = instance.find_actor_mut(from_actor_id)
        else {
            return None;
        };
        let black_mage = &mut combat_state.black_mage;
        if action_id == ACTION_RETRACE && !black_mage.has_ley_lines_active() {
            return None;
        }

        old_object_id = black_mage.ley_lines_object_id.take();
        black_mage.ley_lines_position = Some(position.0);
        // Retrace inherits the remaining duration; a fresh Ley Lines starts the full 20s.
        if action_id == ACTION_LEY_LINES {
            black_mage.ley_lines_expires_at = Some(Instant::now() + LEY_LINES_DURATION);
        }
        black_mage.ley_lines_object_id = Some(object_id);
        let remaining = black_mage
            .ley_lines_expires_at
            .map(|t| t.saturating_duration_since(Instant::now()).as_secs_f32())
            .unwrap_or(LEY_LINES_DURATION.as_secs_f32());
        status_effects.add_with_source(STATUS_LEY_LINES, 0, remaining, from_actor_id);
    }

    let spawn = SpawnObject {
        kind: ObjectKind::AreaObject,
        extra_flags: 0x04,
        base_id: LEY_LINES_GROUND_VFX_ID,
        entity_id: object_id,
        owner_id: from_actor_id,
        radius: LEY_LINES_RADIUS,
        position,
        ..Default::default()
    };
    instance.insert_object(object_id, spawn, String::default());

    if let Some(old_object_id) = old_object_id {
        network.lock().remove_actor(instance, old_object_id);
    }
    Some(object_id)
}

#[cfg(test)]
mod tests {
    use super::*;
    use binrw::BinWrite;
    use kawari::ipc::zone::{ServerZoneIpcData, ServerZoneIpcSegment};
    use std::io::Cursor;

    const PLAYER: ObjectId = ObjectId(1);

    fn player(stance: i8, hearts: u8, mp: u16) -> NetworkedActor {
        let mut instance = Instance::default();
        instance.insert_empty_actor(PLAYER);
        let mut actor = instance.actors.remove(&PLAYER).unwrap();
        let NetworkedActor::Player {
            spawn,
            combat_state,
            ..
        } = &mut actor
        else {
            unreachable!();
        };
        spawn.common.class_job = CLASSJOB_BLACK_MAGE;
        spawn.common.level = 100;
        spawn.common.health_points = 1000;
        spawn.common.resource_points = mp;
        spawn.common.max_resource_points = 10000;
        combat_state.in_combat = true;
        combat_state.black_mage.element_stance = stance;
        combat_state.black_mage.umbral_hearts = hearts;
        actor
    }

    fn state(actor: &NetworkedActor) -> &BlackMageState {
        let NetworkedActor::Player { combat_state, .. } = actor else {
            unreachable!();
        };
        &combat_state.black_mage
    }

    fn cast(
        actor: &mut NetworkedActor,
        action: u32,
        sheet_cost: u32,
        aspect: u8,
        landed_damage: bool,
    ) -> BlackMageActionUpdate {
        let has_firestarter = actor
            .status_effects_mut()
            .unwrap()
            .get(STATUS_FIRESTARTER)
            .is_some();
        let current_mp = actor.get_common_spawn().resource_points;
        let cost = effective_mp_cost(
            state(actor),
            action,
            sheet_cost,
            aspect,
            u32::from(current_mp),
            has_firestarter,
        );
        actor.get_common_spawn_mut().resource_points -= cost as u16;
        update_black_mage_state_after_action(action, actor, PLAYER, cost, aspect, landed_damage)
    }

    #[test]
    fn replay_transpose_and_umbral_soul_update_the_elemental_gauge() {
        let mut actor = player(3, 0, 1256);
        cast(&mut actor, ACTION_TRANSPOSE, 0, 0, false);
        let ice = state(&actor);
        assert_eq!(ice.element_stance, -1);
        assert!(ice.paradox_active);

        for (tier, hearts, restore, expected_mp) in [
            (-2, 1, 2500, 3756),
            (-3, 2, 5000, 8756),
            (-3, 3, 10000, 10000),
        ] {
            let update = cast(&mut actor, ACTION_UMBRAL_SOUL, 0, 0, false);
            assert_eq!(update.mp_restored, restore);
            assert_eq!(actor.get_common_spawn().resource_points, expected_mp);
            assert_eq!(state(&actor).element_stance, tier);
            assert_eq!(state(&actor).umbral_hearts, hearts);
        }

        cast(&mut actor, ACTION_PARADOX, 1600, 0, true);
        assert!(!state(&actor).paradox_active);
        cast(&mut actor, ACTION_HIGH_FIRE_II, 1500, ASPECT_FIRE, true);
        assert!(state(&actor).paradox_active);
        assert_eq!(state(&actor).element_stance, 3);
        assert_eq!(state(&actor).umbral_hearts, 3);

        let mut two_hearts = player(-3, 2, 10000);
        cast(&mut two_hearts, ACTION_TRANSPOSE, 0, 0, false);
        assert!(!state(&two_hearts).paradox_active);
    }

    #[test]
    fn replay_ice_hits_use_the_stance_before_the_hit() {
        let mut actor = player(-1, 0, 200);
        let update = cast(&mut actor, ACTION_BLIZZARD_III, 800, ASPECT_ICE, true);
        assert_eq!(update.mp_restored, 2500);
        assert_eq!(actor.get_common_spawn().resource_points, 2700);
        assert_eq!(state(&actor).element_stance, -3);

        let miss = cast(&mut actor, ACTION_BLIZZARD_IV, 800, ASPECT_ICE, false);
        assert_eq!(miss.mp_restored, 0);
        let hit = cast(&mut actor, ACTION_BLIZZARD_IV, 800, ASPECT_ICE, true);
        assert_eq!(hit.mp_restored, 10000);
        assert_eq!(actor.get_common_spawn().resource_points, 10000);

        let mut from_fire = player(3, 2, 8000);
        let swap = cast(
            &mut from_fire,
            ACTION_HIGH_BLIZZARD_II,
            800,
            ASPECT_ICE,
            true,
        );
        assert_eq!(swap.mp_restored, 0);
        assert_eq!(from_fire.get_common_spawn().resource_points, 8000);
        assert_eq!(state(&from_fire).element_stance, -3);
    }

    #[test]
    fn replay_flare_spends_current_mp_and_builds_astral_soul() {
        let mut actor = player(3, 3, 8400);
        cast(&mut actor, ACTION_FLARE, 0, ASPECT_FIRE, true);
        assert_eq!(actor.get_common_spawn().resource_points, 2856);
        assert_eq!(state(&actor).umbral_hearts, 0);
        assert_eq!(state(&actor).astral_soul_stacks, 3);
        for _ in 0..3 {
            cast(&mut actor, ACTION_FIRE_IV, 800, ASPECT_FIRE, true);
            actor.get_common_spawn_mut().resource_points = 2856;
        }
        assert_eq!(state(&actor).astral_soul_stacks, 6);
        cast(&mut actor, ACTION_FLARE_STAR, 0, ASPECT_FIRE, true);
        assert_eq!(state(&actor).astral_soul_stacks, 0);
        cast(&mut actor, ACTION_FIRE_IV, 800, ASPECT_FIRE, true);
        cast(&mut actor, ACTION_TRANSPOSE, 0, 0, false);
        assert_eq!(state(&actor).astral_soul_stacks, 0);

        let mut despair = player(3, 3, 1200);
        cast(&mut despair, ACTION_DESPAIR, 0, ASPECT_FIRE, true);
        assert_eq!(despair.get_common_spawn().resource_points, 0);
        assert_eq!(state(&despair).umbral_hearts, 3);
    }

    #[test]
    fn replay_firestarter_fire_iii_does_not_spend_a_heart_or_a_cast_buff() {
        let mut actor = player(1, 3, 10000);
        actor
            .status_effects_mut()
            .unwrap()
            .add_with_source(STATUS_FIRESTARTER, 0, 60.0, PLAYER);
        cast(&mut actor, ACTION_TRIPLECAST, 0, 0, false);
        assert!(state(&actor).has_triplecast());
        assert!(is_instant_without_cast_buff(ACTION_FIRE_III, 100, true));
        assert!(!is_instant_without_cast_buff(ACTION_FIRE_III, 100, false));
        cast(&mut actor, ACTION_FIRE_III, 2000, ASPECT_FIRE, true);
        assert_eq!(actor.get_common_spawn().resource_points, 10000);
        assert_eq!(state(&actor).umbral_hearts, 3);
        assert_eq!(state(&actor).triplecast_stacks, 3);
        assert!(
            actor
                .status_effects_mut()
                .unwrap()
                .get(STATUS_FIRESTARTER)
                .is_none()
        );

        cast(&mut actor, ACTION_FIRE_III, 2000, ASPECT_FIRE, true);
        assert_eq!(actor.get_common_spawn().resource_points, 8000);
        assert_eq!(state(&actor).umbral_hearts, 2);
    }

    #[test]
    fn replay_polyglot_timer_starts_with_the_first_spell_and_survives_swaps() {
        let mut actor = player(0, 0, 10000);
        cast(&mut actor, ACTION_FIRE_III, 2000, ASPECT_FIRE, true);
        let start_deadline = state(&actor).polyglot_next_at.unwrap();
        cast(&mut actor, ACTION_AMPLIFIER, 0, 0, false);
        assert_eq!(state(&actor).polyglot_stacks, 1);
        cast(&mut actor, ACTION_XENOGLOSSY, 0, 0, true);
        assert_eq!(state(&actor).polyglot_stacks, 0);
        cast(&mut actor, ACTION_TRANSPOSE, 0, 0, false);
        assert_eq!(state(&actor).polyglot_next_at, Some(start_deadline));

        let mut state = state(&actor).clone();
        assert!(state.update_polyglot_timer(100, start_deadline));
        assert_eq!(state.polyglot_stacks, 1);
        assert_eq!(
            state.polyglot_next_at,
            Some(start_deadline + POLYGLOT_INTERVAL)
        );
        state.polyglot_stacks = 3;
        assert!(state.update_polyglot_timer(100, start_deadline + POLYGLOT_INTERVAL));
        assert_eq!(state.polyglot_stacks, 3);
        assert_eq!(
            state.polyglot_next_at,
            Some(start_deadline + 2 * POLYGLOT_INTERVAL)
        );
        state.element_stance = 0;
        assert!(state.update_polyglot_timer(100, start_deadline));
        assert_eq!(state.polyglot_next_at, None);
    }

    #[test]
    fn actor_gauge_serializes_to_the_recorded_payloads() {
        let now = Instant::now();
        let cases = [
            (30000, 3, 0, 0, false, 0, [0x30, 0x75, 0x03, 0, 0, 0x01]),
            (13048, 3, 2, 0, true, 6, [0xf8, 0x32, 0x03, 2, 0, 0x1b]),
            (25852, -3, 2, 1, true, 0, [0xfc, 0x64, 0xfd, 2, 1, 0x03]),
            (17842, -1, 0, 0, true, 0, [0xb2, 0x45, 0xff, 0, 0, 0x03]),
        ];
        for (ms, stance, hearts, stacks, paradox, soul, recorded) in cases {
            let state = BlackMageState {
                element_stance: stance,
                umbral_hearts: hearts,
                polyglot_stacks: stacks,
                paradox_active: paradox,
                astral_soul_stacks: soul,
                polyglot_next_at: Some(now + Duration::from_millis(ms)),
                ..Default::default()
            };
            let segment = ServerZoneIpcSegment::new(ServerZoneIpcData::ActorGauge {
                classjob_id: gauge_class_job_id(),
                data: pack_black_mage_gauge(&state, 100, now),
            });
            let mut wire = Cursor::new(Vec::new());
            segment.write_le(&mut wire).unwrap();
            let mut payload = [0; 16];
            payload[0] = 25;
            payload[2..8].copy_from_slice(&recorded);
            let wire = wire.into_inner();
            assert_eq!(&wire[2..4], &803u16.to_le_bytes());
            assert_eq!(&wire[16..], &payload);
        }
    }

    #[test]
    fn between_the_lines_uses_only_the_active_circle_as_destination() {
        let mut actor = player(3, 0, 10000);
        let position = glam::Vec3::new(-68.4, -194.0, -41.5);
        assert!(ley_lines_action_result(&actor, ACTION_BETWEEN_THE_LINES).is_none());
        let NetworkedActor::Player { combat_state, .. } = &mut actor else {
            unreachable!();
        };
        combat_state.black_mage.ley_lines_position = Some(position);
        combat_state.black_mage.ley_lines_expires_at = Some(Instant::now() + LEY_LINES_DURATION);
        let (center, effect, lock) =
            ley_lines_action_result(&actor, ACTION_BETWEEN_THE_LINES).unwrap();
        assert_eq!(center.0, position);
        assert_eq!(lock, 0.8);
        assert_eq!(
            effect,
            TargetEffectKind::Teleport {
                unk: [0; 5],
                territory: 0,
            }
        );
    }

    #[test]
    fn changing_jobs_clears_the_black_mage_gauge_and_circle() {
        let mut actor = player(3, 3, 10000);
        cast(&mut actor, ACTION_TRIPLECAST, 0, 0, false);
        let NetworkedActor::Player { combat_state, .. } = &mut actor else {
            unreachable!();
        };
        let circle = ObjectId(2);
        combat_state.black_mage.ley_lines_object_id = Some(circle);
        assert_eq!(deactivate(&mut actor), Some(circle));
        assert_eq!(*state(&actor), BlackMageState::default());
        assert!(
            actor
                .status_effects_mut()
                .unwrap()
                .get(STATUS_TRIPLECAST)
                .is_none()
        );
    }
}
