//! 副本运行期状态：隔离战斗轮次、演员取消和施法完成，保留重置快照。
use crate::server::actor::NetworkedActor;
use kawari::{
    common::ObjectId,
    ipc::zone::{ActorControlCategory, StatusEffect},
};
use std::{
    collections::HashMap,
    sync::atomic::{AtomicU64, Ordering},
};

static NEXT_GENERATION: AtomicU64 = AtomicU64::new(1);
fn generation() -> u64 {
    NEXT_GENERATION.fetch_add(1, Ordering::Relaxed)
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct AoeGuard {
    encounter: u64,
    source: u64,
    visual: u64,
}

#[derive(Debug, Clone, Copy)]
pub struct StatusChange {
    pub actor: ObjectId,
    pub effect: StatusEffect,
    pub gained: bool,
}

#[derive(Debug)]
pub struct EncounterRuntime {
    pub limit_break_gauge: Option<u32>,
    pub hit_trigger: Option<ObjectId>,
    pub map_effects: Vec<(u8, (u16, u16))>,
    pub bgm: Option<u32>,
    pub map_setup: Option<kawari::ipc::zone::MapEffects>,
    epoch: u64,
    actors: HashMap<ObjectId, u64>,
    pub casts: HashMap<ObjectId, (u64, u32)>,
    pub omens: HashMap<ObjectId, (u64, u32)>,
    pub omen_sources: HashMap<ObjectId, ObjectId>,
    pub initial_bosses: HashMap<ObjectId, NetworkedActor>,
    pub initial_controls: HashMap<ObjectId, Vec<ActorControlCategory>>,
    pub reset_bosses: Vec<ObjectId>,
    pub effects: HashMap<ObjectId, Vec<StatusEffect>>,
    pub owned_effects: HashMap<(ObjectId, u16), ObjectId>,
    pub status_changes: Vec<StatusChange>,
    pub controls: HashMap<ObjectId, Vec<ActorControlCategory>>,
    pub reset_on_deaggro: bool,
}

impl Default for EncounterRuntime {
    fn default() -> Self {
        Self {
            limit_break_gauge: None,
            hit_trigger: None,
            map_effects: Default::default(),
            bgm: None,
            map_setup: None,
            epoch: generation(),
            actors: HashMap::new(),
            casts: HashMap::new(),
            omens: HashMap::new(),
            omen_sources: HashMap::new(),
            initial_bosses: HashMap::new(),
            initial_controls: HashMap::new(),
            reset_bosses: Vec::new(),
            effects: HashMap::new(),
            owned_effects: HashMap::new(),
            status_changes: Vec::new(),
            controls: HashMap::new(),
            reset_on_deaggro: true,
        }
    }
}

impl EncounterRuntime {
    pub fn guard(&self, source: ObjectId, visual: ObjectId) -> AoeGuard {
        AoeGuard {
            encounter: self.epoch,
            source: *self.actors.get(&source).unwrap_or(&0),
            visual: *self.actors.get(&visual).unwrap_or(&0),
        }
    }
    pub fn valid(&self, guard: AoeGuard, source: ObjectId, visual: ObjectId) -> bool {
        guard == self.guard(source, visual)
    }
    pub fn cancel_actor(&mut self, actor: ObjectId) {
        self.actors.insert(actor, generation());
        self.casts.remove(&actor);
        self.omens.remove(&actor);
        self.omen_sources.remove(&actor);
    }
    pub fn cancel_all(&mut self) {
        self.epoch = generation();
        self.actors.clear();
        self.casts.clear();
        self.omens.clear();
        self.omen_sources.clear();
    }
    pub fn begin_cast(&mut self, actor: ObjectId, action: u32) {
        self.casts.insert(actor, (generation(), action));
    }
    pub fn begin_omen(&mut self, actor: ObjectId, action: u32) {
        self.omens.insert(actor, (generation(), action));
    }
    pub fn finish_omen(&mut self, actor: ObjectId, token: u64) {
        if self.omens.get(&actor).is_some_and(|c| c.0 == token) {
            self.omens.remove(&actor);
            self.omen_sources.remove(&actor);
        }
    }
    pub fn finish_cast(&mut self, actor: ObjectId, token: u64) -> bool {
        if self.casts.get(&actor).is_some_and(|c| c.0 == token) {
            self.casts.remove(&actor);
            true
        } else {
            false
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn cancellation_isolates_pulls_sources_and_helpers() {
        let mut runtime = EncounterRuntime::default();
        let (boss, helper, other) = (ObjectId(1), ObjectId(2), ObjectId(3));
        let old = runtime.guard(boss, helper);
        runtime.cancel_actor(other);
        assert!(runtime.valid(old, boss, helper));
        runtime.cancel_actor(helper);
        assert!(!runtime.valid(old, boss, helper));
        let next = runtime.guard(boss, helper);
        runtime.cancel_all();
        assert!(!runtime.valid(next, boss, helper));
        assert!(!EncounterRuntime::default().valid(runtime.guard(boss, helper), boss, helper));
    }
    #[test]
    fn old_completion_cannot_unlock_a_new_cast() {
        let mut runtime = EncounterRuntime::default();
        let boss = ObjectId(1);
        runtime.begin_cast(boss, 100);
        let old = runtime.casts[&boss].0;
        runtime.begin_cast(boss, 200);
        assert!(!runtime.finish_cast(boss, old));
        let current = runtime.casts[&boss].0;
        assert!(runtime.finish_cast(boss, current));
        assert!(runtime.casts.is_empty());
    }
}
