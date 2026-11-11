use std::time::{Duration, Instant};

use crate::zone_connection::DamageRollModifiers;
use kawari::common::ObjectId;
use kawari::ipc::zone::StatusEffect;

/// The kind of periodic (every-3-seconds) tick a status effect applies. Retail computes the tick
/// magnitude from the *action* that applied the status (the Status EXD sheet has no potency field),
/// so the potency is supplied by the action script and stored here, not derived from game data.
#[derive(Debug, Clone, Copy, PartialEq)]
pub enum TickEffectKind {
    /// Damage over time (magical). Resolved against the target's HP each tick.
    DamageMagic,
    /// Damage over time (physical).
    DamagePhysical,
    /// Heal over time.
    Heal,
    /// Fixed MP restoration over time.
    RestoreMp,
}

#[derive(Debug, Clone, Copy)]
pub struct TickDamageSnapshot {
    pub base_amount: u32,
    pub roll_modifiers: DamageRollModifiers,
}

/// A periodic effect attached to a status. Lives alongside the wire [`StatusEffect`] (which only
/// carries id/param/duration/source) so the every-3s regen tick can resolve DoTs/HoTs without
/// changing the network format.
#[derive(Debug, Clone, Copy)]
pub struct TickEffect {
    /// 宠物消失后仍持续的效果以主人读取参数，协议来源仍保留宠物 ID。
    pub stat_source_actor_id: Option<ObjectId>,
    /// The status this tick belongs to (so it's removed together with the status).
    pub effect_id: u16,
    pub kind: TickEffectKind,
    /// Per-tick potency, or raw MP amount for [`TickEffectKind::RestoreMp`].
    pub potency: u16,
    /// Damage modifiers captured when the DoT was applied or refreshed.
    pub damage_snapshot: Option<TickDamageSnapshot>,
    /// 持续治疗施加时锁定的治疗魔法增益；每跳仍独立计算治疗量。
    pub healing_multiplier: f64,
    /// Who applied the DoT/HoT, for damage attribution.
    pub source_actor_id: ObjectId,
}

/// A server-side damage barrier attached to a visible status effect. The wire status carries the
/// icon/duration/source; this stores the remaining absorb pool.
#[derive(Debug, Clone, Copy)]
pub struct BarrierEffect {
    pub effect_id: u16,
    pub remaining: u32,
}

#[derive(Debug, Clone, Copy)]
struct StatusExpiration {
    effect_id: u16,
    source_actor_id:ObjectId,
    expires_at: Instant,
}

/// How many statuses an actor can carry at once, matching the fixed-size array in the
/// `StatusEffectList` packet. Expired statuses leave their slot behind rather than shifting the
/// later ones down (the client keys buffs by slot index), so the list only ever grows and needs
/// this bound to stay inside the wire format.
pub const MAX_STATUS_EFFECTS: usize = 30;

#[derive(Debug, Default, Clone)]
pub struct StatusEffects {
    status_effects: Vec<StatusEffect>,
    expirations: Vec<StatusExpiration>,
    /// Periodic tick effects (DoT/HoT) keyed by their owning status id. Server-side only.
    tick_effects: Vec<TickEffect>,
    /// Damage barriers keyed by their owning status id. Server-side only.
    barriers: Vec<BarrierEffect>,
    broken_barriers: Vec<(u16, ObjectId)>,
    /// 服务端效果量独立于客户端层数参数，例如标准舞步的 2% / 5%。
    magnitudes: std::collections::HashMap<u16,u16>,
    /// 持续效果按施加者独立占槽；减伤/护盾仍遵循同名互斥规则。
    source_scoped:std::collections::HashSet<u16>,
    dirty: bool,
}

impl StatusEffects {
    fn scoped(&self,id:u16)->bool{self.source_scoped.contains(&id)||matches!(id,2586|1182|1847|1848|2600|2601|2605|3899)}
    pub fn set_magnitude(&mut self,id:u16,value:u16){if self.get(id).is_some(){self.magnitudes.insert(id,value);}}
    pub fn magnitude(&self,id:u16)->Option<u16>{self.get(id).map(|s|self.magnitudes.get(&id).copied().unwrap_or(s.param))}
    pub fn add(&mut self, effect_id: u16, effect_param: u16, duration: f32) {
        self.add_with_source(effect_id, effect_param, duration, ObjectId::default());
    }

    /// Like [`add`], but records who applied the status. The `source_actor_id` is written into the
    /// wire `StatusEffect` so the client attributes it correctly — a self-applied status (source ==
    /// the actor) shows a green timer, otherwise white. Without this the StatusEffectList reports
    /// source 0 while the accompanying GainEffect ACS reports the real source, and the client draws
    /// the status twice (one white, one green).
    pub fn add_with_source(
        &mut self,
        effect_id: u16,
        effect_param: u16,
        duration: f32,
        source_actor_id: ObjectId,
    ) {
        self.magnitudes.remove(&effect_id);
        let Some(status_effect) = self.find_or_create_status_effect(effect_id,source_actor_id) else {
            tracing::warn!(
                effect_id,
                "Dropping status effect: all {MAX_STATUS_EFFECTS} slots are in use."
            );
            return;
        };
        status_effect.param = effect_param;
        status_effect.duration = duration;
        status_effect.source_actor_id = source_actor_id;
        self.set_expiration(effect_id, source_actor_id,duration);
        self.dirty = true
    }

    /// Adds (or refreshes) a status effect that also ticks every 3 seconds (DoT/HoT). The wire
    /// status is added as usual; the periodic `kind`/`potency` is stored separately so the regen
    /// tick can resolve it. Re-applying the same status id replaces its tick effect (refresh).
    pub fn add_tick(
        &mut self,
        effect_id: u16,
        effect_param: u16,
        duration: f32,
        kind: TickEffectKind,
        potency: u16,
        damage_snapshot: Option<TickDamageSnapshot>,
        source_actor_id: ObjectId,
    ) {
        self.source_scoped.insert(effect_id);
        self.add_with_source(effect_id, effect_param, duration, source_actor_id);
        self.tick_effects.retain(|t| t.effect_id != effect_id||t.source_actor_id!=source_actor_id);
        self.tick_effects.push(TickEffect {
            stat_source_actor_id: None,
            effect_id,
            kind,
            potency,
            damage_snapshot,
            healing_multiplier: 1.0,
            source_actor_id,
        });
    }

    pub fn snapshot_healing_multiplier(
        &mut self,
        effect_id: u16,
        source: ObjectId,
        multiplier: f64,
    ) {
        if let Some(tick) = self.tick_effects.iter_mut().find(|t| {
            t.effect_id == effect_id
                && t.source_actor_id == source
                && t.kind == TickEffectKind::Heal
        }) {
            tick.healing_multiplier = multiplier;
        }
    }

    pub fn set_tick_stat_source(&mut self,effect_id:u16,source:ObjectId,stat_source:ObjectId){
        if let Some(tick)=self.tick_effects.iter_mut().find(|t|t.effect_id==effect_id&&t.source_actor_id==source){
            tick.stat_source_actor_id=Some(stat_source);
        }
    }

    /// Adds (or refreshes) a status effect that absorbs incoming damage until `amount` is consumed.
    /// Re-applying the same status id replaces its previous barrier pool.
    pub fn add_barrier(
        &mut self,
        effect_id: u16,
        effect_param: u16,
        duration: f32,
        amount: u32,
        source_actor_id: ObjectId,
        max_barrier_total: u32,
    ) {
        self.add_with_source(effect_id, effect_param, duration, source_actor_id);
        self.barriers.retain(|b| b.effect_id != effect_id);

        let available = max_barrier_total.saturating_sub(self.barrier_amount());
        let amount = amount.min(available);
        if amount > 0 {
            self.barriers.push(BarrierEffect {
                effect_id,
                remaining: amount,
            });
        }
        self.dirty = true;
    }

    /// Periodic effects whose owning status is still active at this tick.
    pub fn tick_effects(&self, now: Instant) -> impl Iterator<Item = TickEffect> + '_ {
        self.tick_effects.iter().copied().filter(move |tick| {
            self.position_of_from(tick.effect_id,tick.source_actor_id).is_some()
                && !self.expirations.iter().any(|expiration| {
                    expiration.effect_id == tick.effect_id && expiration.source_actor_id==tick.source_actor_id && expiration.expires_at <= now
                })
        })
    }

    pub fn expired_ids(&self, now: Instant) -> impl Iterator<Item = u16> + '_ {
        self.expirations
            .iter()
            .filter(move |expiration| expiration.expires_at <= now)
            .map(|expiration| expiration.effect_id)
    }

    pub fn expired_effects(&self,now:Instant)->impl Iterator<Item=(u16,ObjectId)>+'_ {
        self.expirations.iter().filter(move|e|e.expires_at<=now).map(|e|(e.effect_id,e.source_actor_id))
    }

    /// Total remaining barrier amount.
    pub fn barrier_amount(&self) -> u32 {
        self.barriers
            .iter()
            .fold(0u32, |sum, barrier| sum.saturating_add(barrier.remaining))
    }

    /// Shield percentage as expected by StatusEffectList/EffectResult packets.
    pub fn shield_percent(&self, max_hp: u32) -> u8 {
        if max_hp == 0 {
            return 0;
        }

        (((self.barrier_amount() as u64 * 100).div_ceil(max_hp as u64)).min(100)) as u8
    }

    /// Absorbs `damage` through active barriers and returns the leftover HP damage.
    pub(crate) fn take_broken_barriers(&mut self) -> Vec<(u16, ObjectId)> {
        std::mem::take(&mut self.broken_barriers)
    }

    /// 返回单个状态仍可吸收的伤害，用于展开和同类护盾强度比较。
    pub(crate) fn barrier_remaining(&self,effect_id:u16)->u32{
        self.barriers.iter().find(|b|b.effect_id==effect_id).map_or(0,|b|b.remaining)
    }

    pub fn absorb_damage(&mut self, damage: u32) -> u32 {
        if damage == 0 || self.barriers.is_empty() {
            return damage;
        }

        let mut remaining_damage = damage;
        let mut broke_barrier = false;

        for barrier in &mut self.barriers {
            if remaining_damage == 0 {
                break;
            }

            let absorbed = barrier.remaining.min(remaining_damage);
            if absorbed == 0 {
                continue;
            }

            barrier.remaining -= absorbed;
            remaining_damage -= absorbed;
            self.dirty = true;

            if barrier.remaining == 0 {
                broke_barrier = true;
            }
        }

        if broke_barrier {
            let broken_effect_ids: Vec<u16> = self
                .barriers
                .iter()
                .filter(|barrier| barrier.remaining == 0)
                .map(|barrier| barrier.effect_id)
                .collect();
            self.broken_barriers.extend(
                self.status_effects
                    .iter()
                    .filter(|s| {
                        matches!(s.effect_id, 1178 | 3686 | 3687 | 3903 | 2607 | 2609 | 2612 | 2613 | 2597)
                            && broken_effect_ids.contains(&s.effect_id)
                    })
                    .map(|s| (s.effect_id, s.source_actor_id)),
            );
            self.barriers.retain(|barrier| barrier.remaining > 0);
            // Blank the slots rather than compacting, for the same reason as `remove`.
            for effect in &mut self.status_effects {
                if broken_effect_ids.contains(&effect.effect_id) {
                    *effect = StatusEffect::default();
                }
            }
            self.expirations
                .retain(|expiration| !broken_effect_ids.contains(&expiration.effect_id));
            self.tick_effects
                .retain(|tick| !broken_effect_ids.contains(&tick.effect_id));
            self.dirty = true;
        }

        remaining_damage
    }

    /// Finds the slot holding `effect_id`, or claims a free one for it.
    ///
    /// A new status takes the first hole left behind by an expired one before extending the list,
    /// which is what retail does -- a second sprint cast came back in the slot the expired potion
    /// had occupied rather than landing past it. Returns `None` once all
    /// [`MAX_STATUS_EFFECTS`] slots are taken, since the wire packet cannot carry more.
    fn find_or_create_status_effect(&mut self, effect_id: u16, source:ObjectId) -> Option<&mut StatusEffect> {
        let scoped=self.scoped(effect_id);
        if let Some(i) = self
            .status_effects
            .iter()
            .position(|effect| effect.effect_id == effect_id&&(!scoped||effect.source_actor_id==source))
        {
            return Some(&mut self.status_effects[i]);
        }

        let free_slot = self
            .status_effects
            .iter()
            .position(|effect| effect.effect_id == 0);

        let i = match free_slot {
            Some(i) => i,
            None => {
                if self.status_effects.len() >= MAX_STATUS_EFFECTS {
                    return None;
                }
                self.status_effects.push(StatusEffect::default());
                self.status_effects.len() - 1
            }
        };

        self.status_effects[i] = StatusEffect {
            effect_id,
            ..Default::default()
        };
        Some(&mut self.status_effects[i])
    }

    fn set_expiration(&mut self, effect_id: u16,source_actor_id:ObjectId, duration: f32) {
        let scoped=self.scoped(effect_id);
        self.expirations
            .retain(|expiration| expiration.effect_id != effect_id||scoped&&expiration.source_actor_id!=source_actor_id);
        if duration > 0.0 {
            self.expirations.push(StatusExpiration {
                effect_id,
                source_actor_id,
                expires_at: Instant::now() + Duration::from_secs_f32(duration),
            });
        }
    }

    fn remaining_duration(&self, effect: StatusEffect) -> StatusEffect {
        let Some(expiration) = self
            .expirations
            .iter()
            .find(|expiration| expiration.effect_id == effect.effect_id&&expiration.source_actor_id==effect.source_actor_id)
        else {
            return effect;
        };

        StatusEffect {
            duration: expiration
                .expires_at
                .saturating_duration_since(Instant::now())
                .as_secs_f32(),
            ..effect
        }
    }

    pub fn get(&self, effect_id: u16) -> Option<StatusEffect> {
        if effect_id == 0 {
            return None;
        }
        self.status_effects
            .iter()
            .position(|effect| effect.effect_id == effect_id)
            .map(|i| self.remaining_duration(self.status_effects[i]))
    }

    /// Returns the slot index of a status by id, matching the layout sent in StatusEffectList. The
    /// client keys buffs by this slot, so packets referencing a status (e.g. EffectResult) must use
    /// the same index or the buff is drawn twice.
    pub fn position_of(&self, effect_id: u16) -> Option<usize> {
        if effect_id == 0 {
            return None;
        }
        self.status_effects
            .iter()
            .position(|effect| effect.effect_id == effect_id)
    }

    pub fn position_of_from(&self,id:u16,source:ObjectId)->Option<usize>{
        if id==0{return None;}self.status_effects.iter().position(|e|e.effect_id==id&&e.source_actor_id==source)
    }
    pub fn get_from(&self,id:u16,source:ObjectId)->Option<StatusEffect>{self.position_of_from(id,source).map(|i|self.remaining_duration(self.status_effects[i]))}
    pub fn remove_from(&mut self,id:u16,source:ObjectId){
        if !self.scoped(id){if self.get_from(id,source).is_some(){self.remove(id);}return;}
        if let Some(i)=self.position_of_from(id,source){self.status_effects[i]=StatusEffect::default();self.dirty=true;}
        self.expirations.retain(|e|e.effect_id!=id||e.source_actor_id!=source);
        self.tick_effects.retain(|e|e.effect_id!=id||e.source_actor_id!=source);
    }

    pub fn remove(&mut self, effect_id: u16) {
        self.magnitudes.remove(&effect_id);
        for effect in self.status_effects.iter_mut().filter(|e|e.effect_id==effect_id) {
            // Blank the slot instead of closing the gap. The client keys buffs by the slot index it
            // was handed in EffectResult, so shifting the later statuses down would redraw them in
            // the wrong places on the next full StatusEffectList. Retail leaves the same hole.
            *effect = StatusEffect::default();
            self.expirations
                .retain(|expiration| expiration.effect_id != effect_id);
            self.dirty = true;
        }
        self.tick_effects.retain(|t| t.effect_id != effect_id);
        let barrier_count = self.barriers.len();
        self.barriers.retain(|b| b.effect_id != effect_id);
        if self.barriers.len() != barrier_count {
            self.dirty = true;
        }
    }

    pub fn data(&self) -> Vec<StatusEffect> {
        self.status_effects
            .iter()
            .copied()
            .map(|effect| self.remaining_duration(effect))
            .collect()
    }

    /// If the list is dirty and must be propagated to the client
    pub fn is_dirty(&self) -> bool {
        self.dirty
    }

    pub fn reset_dirty(&mut self) {
        self.dirty = false;
    }

    /// Number of status effects.
    pub fn len(&self) -> usize {
        self.status_effects.len()
    }

    pub fn is_empty(&self) -> bool {
        self.status_effects.is_empty()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    /// Sprint. Used as the stand-in status here because effect id 0 marks an empty slot -- the Status
    /// sheet has no row 0, so a real status can never carry that id.
    const STATUS_SPRINT: u16 = 50;

    #[test]
    fn same_dot_from_two_players_keeps_separate_ticks_and_expirations(){
        let mut s=StatusEffects::default();let a=ObjectId(1);let b=ObjectId(2);
        s.add_tick(1228,0,2.0,TickEffectKind::DamagePhysical,50,None,a);
        s.add_tick(1228,0,30.0,TickEffectKind::DamagePhysical,50,None,b);
        assert_ne!(s.position_of_from(1228,a),s.position_of_from(1228,b));
        assert_eq!(s.tick_effects(Instant::now()).count(),2);
        let future=Instant::now()+Duration::from_secs(3);
        assert_eq!(s.expired_effects(future).collect::<Vec<_>>(),vec![(1228,a)]);
        assert_eq!(s.tick_effects(future).map(|t|t.source_actor_id).collect::<Vec<_>>(),vec![b]);
        s.remove_from(1228,a);assert!(s.get_from(1228,b).is_some());assert_eq!(s.tick_effects(Instant::now()).count(),1);
    }

    #[test]
    fn independent_hots_refresh_only_their_caster_and_global_clear_removes_all(){
        let mut s=StatusEffects::default();for source in[ObjectId(1),ObjectId(2)]{s.add_tick(143,0,15.0,TickEffectKind::Heal,100,None,source);}
        s.add_tick(143,0,15.0,TickEffectKind::Heal,200,None,ObjectId(1));
        let ticks=s.tick_effects(Instant::now()).collect::<Vec<_>>();assert_eq!(ticks.len(),2);assert_eq!(ticks.iter().find(|t|t.source_actor_id==ObjectId(2)).unwrap().potency,100);
        s.remove(143);assert!(s.get(143).is_none());assert_eq!(s.tick_effects(Instant::now()).count(),0);
    }

    #[test]
    fn source_scoped_marks_coexist_but_same_named_shields_stay_exclusive(){
        let mut s=StatusEffects::default();for source in[ObjectId(1),ObjectId(2)]{s.add_with_source(2586,10,30.0,source);s.add_barrier(297,0,30.0,500,source,10000);}
        assert!(s.get_from(2586,ObjectId(1)).is_some());assert!(s.get_from(2586,ObjectId(2)).is_some());assert_eq!(s.barrier_amount(),500);assert_eq!(s.get(297).unwrap().source_actor_id,ObjectId(2));
    }

    #[test]
    fn test_status_effects() {
        // Ensure sensible initial state
        let mut status_effects = StatusEffects::default();
        assert_eq!(status_effects.get(STATUS_SPRINT), None);
        assert_eq!(status_effects.is_dirty(), false);

        // Add a status effect, check that it can be grabbed again, and that the dirty flag is set:
        status_effects.add(STATUS_SPRINT, 0, 0.0);
        assert_eq!(
            status_effects.get(STATUS_SPRINT),
            Some(StatusEffect {
                effect_id: STATUS_SPRINT,
                param: 0,
                duration: 0.0,
                source_actor_id: Default::default()
            })
        );
        assert_eq!(status_effects.is_dirty(), true);

        // Try resetting the dirty flag:
        status_effects.reset_dirty();
        assert_eq!(status_effects.is_dirty(), false);

        // Removing a status should mark it as dirty, and it should really be gone:
        status_effects.remove(STATUS_SPRINT);
        assert_eq!(status_effects.get(STATUS_SPRINT), None);
        assert_eq!(status_effects.is_dirty(), true);
    }

    #[test]
    fn status_list_reports_remaining_duration_per_effect() {
        let mut status_effects = StatusEffects::default();
        status_effects.add(1200, 0, 1.0);
        std::thread::sleep(Duration::from_millis(50));
        status_effects.add(1201, 0, 1.0);

        let status_data = status_effects.data();
        let first = status_data
            .iter()
            .find(|effect| effect.effect_id == 1200)
            .unwrap();
        let second = status_data
            .iter()
            .find(|effect| effect.effect_id == 1201)
            .unwrap();

        assert!(first.duration < second.duration);
        assert!(first.duration < 1.0);
        assert!(second.duration <= 1.0);
    }

    #[test]
    fn test_barrier_absorbs_damage_and_removes_status_when_broken() {
        let mut status_effects = StatusEffects::default();
        status_effects.add_barrier(2702, 0, 30.0, 100, ObjectId(1), 1000);

        assert_eq!(status_effects.get(2702).unwrap().effect_id, 2702);
        assert_eq!(status_effects.barrier_amount(), 100);
        assert_eq!(status_effects.shield_percent(1000), 10);

        assert_eq!(status_effects.absorb_damage(40), 0);
        assert_eq!(status_effects.barrier_amount(), 60);
        assert!(status_effects.get(2702).is_some());

        assert_eq!(status_effects.absorb_damage(90), 30);
        assert_eq!(status_effects.barrier_amount(), 0);
        assert!(status_effects.get(2702).is_none());
    }

    #[test]
    fn test_barrier_total_is_capped_to_max_hp() {
        let mut status_effects = StatusEffects::default();
        status_effects.add_barrier(2702, 0, 30.0, 800, ObjectId(1), 1000);
        status_effects.add_barrier(297, 0, 30.0, 800, ObjectId(1), 1000);

        assert_eq!(status_effects.barrier_amount(), 1000);
        assert_eq!(status_effects.absorb_damage(1200), 200);
    }

    /// Retail leaves a hole behind when a status expires rather than closing the gap: a capture of
    /// a food (slot 0) + potion (slot 1) + sprint (slot 2) stack showed slot 1 reading id 0 once
    /// the potion ran out, with the food still sitting in slot 0.
    ///
    /// This matters because the client keys buffs by the slot index it was handed in EffectResult.
    /// Compacting the list shifts every later status one slot down, so the next full
    /// StatusEffectList redraws them in the wrong places -- the symptom being a buff that vanishes
    /// and reappears as unrelated statuses come and go.
    #[test]
    fn removing_a_status_leaves_the_later_slots_in_place() {
        let mut status_effects = StatusEffects::default();
        status_effects.add(48, 0, 1800.0);
        status_effects.add(49, 0, 30.0);
        status_effects.add(1199, 0, 30.0);

        assert_eq!(status_effects.position_of(1199), Some(2));

        status_effects.remove(49);

        assert_eq!(status_effects.position_of(48), Some(0));
        assert_eq!(status_effects.position_of(1199), Some(2));

        let data = status_effects.data();
        assert_eq!(data.len(), 3);
        assert_eq!(data[1].effect_id, 0);
        assert_eq!(data[1].duration, 0.0);
    }

    /// The counterpart to the hole: retail hands the *first* free slot to the next status. A second
    /// sprint cast after the potion had expired came back as slot 1, reusing the gap rather than
    /// landing past it.
    #[test]
    fn a_new_status_reuses_the_first_hole() {
        let mut status_effects = StatusEffects::default();
        status_effects.add(48, 0, 1800.0);
        status_effects.add(49, 0, 30.0);
        status_effects.add(1199, 0, 30.0);
        status_effects.remove(49);

        status_effects.add(STATUS_SPRINT, 0, 20.0);

        assert_eq!(status_effects.position_of(STATUS_SPRINT), Some(1));
        assert_eq!(status_effects.position_of(1199), Some(2));
        assert_eq!(status_effects.data().len(), 3);
    }

    /// Holes are never reclaimed by shrinking the list, so the slot count only ever grows. The wire
    /// packet is a fixed 30-entry array and `send_effects_list` copies straight into it, so going
    /// past 30 would panic on the slice bounds.
    #[test]
    fn the_status_list_never_grows_past_the_wire_limit() {
        let mut status_effects = StatusEffects::default();
        for i in 0..MAX_STATUS_EFFECTS {
            status_effects.add(100 + i as u16, 0, 30.0);
        }

        assert_eq!(status_effects.len(), MAX_STATUS_EFFECTS);

        status_effects.add(999, 0, 30.0);

        assert_eq!(status_effects.len(), MAX_STATUS_EFFECTS);
        assert_eq!(status_effects.get(999), None);
    }
}
