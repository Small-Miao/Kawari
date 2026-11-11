//! 机工士：热量与电能、固定速率过热、野火、喷射器和独立机械演员。
mod actors;
mod effects;
#[cfg(test)]
mod tests;
use super::dispatch::{Job, JobActionUpdate, JobActors, JobAreaContext, JobRefreshResult};
use crate::{
    gamedata::GameData,
    lua::{EffectsBuilder, GaugeAction},
    server::{
        actor::NetworkedActor, combat_state::PlayerCombatState, instance::Instance,
        network::NetworkState,
    },
};
use kawari::common::{ObjectId, Position};
use kawari::ipc::zone::ActionRequest;
use std::time::{Duration, Instant};

#[derive(Debug, Clone, Default)]
pub struct MachinistState {
    pub heat: u8,
    pub battery: u8,
    pub spent: u8,
    pub overheat_until: Option<Instant>,
    pub overheat_stacks: u8,
    pub hypercharged_until: Option<Instant>,
    pub excavator_until: Option<Instant>,
    pub metal_until: Option<Instant>,
    wildfire: Option<Wildfire>,
    flame: Option<Flame>,
    pet: Option<Robot>,
}
#[derive(Debug, Clone)]
struct Wildfire {
    target: ObjectId,
    end: Instant,
    hits: u8,
}
#[derive(Debug, Clone)]
struct Flame {
    position: Position,
    rotation: f32,
    end: Instant,
    next: Instant,
}
#[derive(Debug, Clone)]
struct Robot {
    actor: Option<ObjectId>,
    target: Option<ObjectId>,
    start: Instant,
    end: Instant,
    next: Instant,
    queen: bool,
    step: u8,
    finisher: bool,
    remove_at: Option<Instant>,
}
fn active(t: Option<Instant>) -> bool {
    t.is_some_and(|t| t > Instant::now())
}
fn until(s: u64) -> Option<Instant> {
    Some(Instant::now() + Duration::from_secs(s))
}
fn minimum(id: u32) -> u8 {
    match id {
        2866 => 1,
        2868 => 2,
        2872 => 4,
        2876 => 10,
        2874 => 15,
        2870 => 18,
        2873 => 26,
        17209 => 30,
        7410 => 35,
        2864 | 7415 => 40,
        2878 | 16766 => 45,
        2890 => 50,
        16497 => 52,
        7411 => 54,
        16889 => 56,
        16498 => 58,
        7412 => 60,
        2887 => 62,
        7413 => 64,
        7414 => 66,
        36978 => 68,
        7418 => 70,
        16499 => 72,
        16500 => 76,
        16501 | 16502 => 80,
        25786 => 82,
        25788 => 90,
        36979 | 36980 => 92,
        36981 => 96,
        36982 => 100,
        _ => 0,
    }
}
fn weapon(id: u32) -> bool {
    matches!(id,2866|2868|2870|2872|2873|7410..=7413|16497..=16500|25786|25788|36978|36981|36982)
}
fn single_weapon(id: u32) -> bool {
    weapon(id) && !matches!(id, 2870 | 16497 | 16499 | 25786 | 25788 | 36981 | 36982)
}
fn overheated(s: &MachinistState) -> bool {
    active(s.overheat_until) && s.overheat_stacks > 0
}
impl MachinistState {
    fn resolve(&self, id: u32, l: u8) -> u32 {
        match id {
            2866 | 7411 => {
                if l >= 54 {
                    7411
                } else {
                    2866
                }
            }
            2868 | 7412 => {
                if l >= 60 {
                    7412
                } else {
                    2868
                }
            }
            2873 | 7413 => {
                if l >= 64 {
                    7413
                } else {
                    2873
                }
            }
            2870 | 25786 => {
                if l >= 82 {
                    25786
                } else {
                    2870
                }
            }
            2872 | 16500 => {
                if l >= 76 {
                    16500
                } else {
                    2872
                }
            }
            7410 | 36978 => {
                if l >= 68 {
                    36978
                } else {
                    7410
                }
            }
            2874 | 36979 => {
                if l >= 92 {
                    36979
                } else {
                    2874
                }
            }
            2890 | 36980 => {
                if l >= 92 {
                    36980
                } else {
                    2890
                }
            }
            2864 | 16501 => {
                if l >= 80 {
                    16501
                } else {
                    2864
                }
            }
            7415 | 16502 => {
                if l >= 80 {
                    16502
                } else {
                    7415
                }
            }
            2878 if self
                .wildfire
                .as_ref()
                .is_some_and(|w| w.end > Instant::now()) =>
            {
                16766
            }
            25788 if l >= 96 && active(self.excavator_until) => 36981,
            7414 if l >= 100 && active(self.metal_until) => 36982,
            _ => id,
        }
    }
    fn pack(&self, l: u8) -> u64 {
        let ms = |t: Option<Instant>| {
            t.map_or(0, |t| {
                t.saturating_duration_since(Instant::now())
                    .as_millis()
                    .min(65535) as u16
            })
        };
        let hot = ms(self.overheat_until).to_le_bytes();
        let pet = ms(self.pet.as_ref().map(|p| p.end)).to_le_bytes();
        u64::from_le_bytes([
            hot[0],
            hot[1],
            pet[0],
            pet[1],
            if l >= 30 { self.heat } else { 0 },
            if l >= 40 { self.battery } else { 0 },
            self.spent,
            (u8::from(overheated(self))) | (if self.pet.is_some() { 2 } else { 0 }),
        ])
    }
}
pub(in crate::server) struct Machinist;
pub(in crate::server) use actors::take_for_zone;
impl Job for Machinist {
    fn class_jobs(&self) -> &'static [u8] {
        &[31]
    }
    fn resolve_action(
        &self,
        r: &ActionRequest,
        c: &PlayerCombatState,
        l: u8,
        _: &mut GameData,
    ) -> u32 {
        c.machinist.resolve(r.action_id, l)
    }
    fn can_execute(&self, id: u32, c: &PlayerCombatState, l: u8) -> bool {
        if l < minimum(id) {
            return false;
        }
        let s = &c.machinist;
        match id {
            17209 => !overheated(s) && (s.heat >= 50 || active(s.hypercharged_until)),
            7410 | 36978 | 16497 => overheated(s),
            2864 | 16501 => s.battery >= 50 && s.pet.is_none(),
            7415 | 16502 => s.pet.as_ref().is_some_and(|p| !p.finisher),
            16766 => s.wildfire.is_some(),
            7414 => c.in_combat,
            36981 => active(s.excavator_until),
            36982 => active(s.metal_until),
            2891 | 7416 | 16503 | 16504 | 17206 | 25787 => false,
            _ => true,
        }
    }
    fn preserves_combo(&self, id: u32) -> bool {
        !matches!(id, 2866 | 2868 | 2873 | 7411..=7413 | 2870 | 25786)
    }
    fn combo_action_id(&self, id: u32) -> u16 {
        match id {
            7411 => 2866,
            7412 => 2868,
            7413 => 2873,
            _ => id as u16,
        }
    }
    fn recast_100ms(&self, id: u32, a: &NetworkedActor) -> Option<u32> {
        match id {
            7410 | 36978 | 16497 => Some(15),
            16889 => Some(if a.get_common_spawn().level >= 88 {
                900
            } else {
                1200
            }),
            _ => None,
        }
    }
    fn fixed_recast(&self, id: u32) -> bool {
        matches!(id, 7410 | 36978 | 16497)
    }
    fn action_effects(
        &self,
        id: u32,
        a: &NetworkedActor,
        _: Option<&NetworkedActor>,
        combo: bool,
    ) -> Option<EffectsBuilder> {
        effects::build(id, a, combo)
    }
    fn apply_gauge_action(&self, _: &mut PlayerCombatState, _: &GaugeAction) {}
    fn update_state_after_action(
        &self,
        id: u32,
        a: &mut NetworkedActor,
        _: ObjectId,
    ) -> JobActionUpdate {
        let NetworkedActor::Player {
            combat_state,
            spawn,
            status_effects,
            ..
        } = a
        else {
            return Default::default();
        };
        let s = &mut combat_state.machinist;
        let l = spawn.common.level;
        if id != 7418 {
            s.flame = None;
            status_effects.remove(1205);
        }
        match id {
            17209 => {
                if active(s.hypercharged_until) {
                    s.hypercharged_until = None;
                    status_effects.remove(3864);
                } else {
                    s.heat = s.heat.saturating_sub(50);
                }
                s.overheat_stacks = 5;
                s.overheat_until = until(10);
            }
            7414 => {
                s.hypercharged_until = until(30);
                if l >= 100 {
                    s.metal_until = until(30);
                }
            }
            36981 => {
                s.excavator_until = None;
                status_effects.remove(3865);
            }
            36982 => {
                s.metal_until = None;
                status_effects.remove(3866);
            }
            2864 | 16501 => {
                s.spent = s.battery;
                s.battery = 0;
                let now = Instant::now();
                s.pet = Some(Robot {
                    actor: None,
                    target: None,
                    start: now,
                    end: now + Duration::from_secs(if id == 16501 { 12 } else { 9 }),
                    next: now + Duration::from_millis(if id == 16501 { 5566 } else { 1500 }),
                    queen: id == 16501,
                    step: 0,
                    finisher: false,
                    remove_at: None,
                });
            }
            _ => {}
        }
        JobActionUpdate {
            changed: true,
            ..Default::default()
        }
    }
    fn build_gauge_data(&self, c: &PlayerCombatState, l: u8) -> Option<u64> {
        Some(c.machinist.pack(l))
    }
    fn refresh_runtime_state_on_actor(
        &self,
        _: ObjectId,
        a: &mut NetworkedActor,
    ) -> JobRefreshResult {
        let NetworkedActor::Player {
            combat_state,
            status_effects,
            ..
        } = a
        else {
            return Default::default();
        };
        let s = &mut combat_state.machinist;
        if !active(s.overheat_until) {
            s.overheat_until = None;
            s.overheat_stacks = 0;
            status_effects.remove(2688);
        }
        JobRefreshResult {
            changed: s.overheat_until.is_some() || s.pet.is_some(),
            ..Default::default()
        }
    }
    fn apply_area_action(
        &self,
        n: &mut NetworkState,
        i: &mut Instance,
        c: JobAreaContext<'_>,
    ) -> Option<crate::server::action::area::AreaResult> {
        effects::apply(n, i, c)
    }
    fn persistent_actors(&self) -> Option<&dyn JobActors> {
        Some(self)
    }
}
pub(in crate::server) fn mitigation(a: &NetworkedActor) -> f64 {
    a.status_effects()
        .and_then(|s| {
            [1826, 1934, 1951]
                .into_iter()
                .filter_map(|id| s.magnitude(id))
                .max()
        })
        .map_or(1.0, |value| if value >= 15 { 0.85 } else { 0.9 })
}
