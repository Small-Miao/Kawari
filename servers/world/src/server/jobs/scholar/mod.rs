//! 学者：以太超流、异想以太、治疗结算与独立仙女演员。
//! 国服本地表及 SCH-01 录像为依据；未录到的炽天使动作另列在审计文档。
mod actors;
mod effects;
#[cfg(test)]
mod tests;
use super::dispatch::{
    Job, JobActionUpdate, JobActors, JobAreaContext, JobCooldownUpdate, JobRefreshResult,
};
use crate::{
    StatusEffects,
    gamedata::GameData,
    lua::{EffectsBuilder, GaugeAction},
    server::{
        actor::NetworkedActor, combat_state::PlayerCombatState, instance::Instance,
        network::NetworkState,
    },
};
use kawari::{
    common::{ObjectId, Position},
    ipc::zone::ActionRequest,
};
use std::time::{Duration, Instant};

#[derive(Debug, Clone, Default)]
pub struct ScholarState {
    pub aetherflow: u8,
    pub fairy_gauge: u8,
    pub fairy: Option<ObjectId>,
    pub fairy_kind: u16,
    pub seraph_until: Option<Instant>,
    pub dissipated_until: Option<Instant>,
    pub seraphism_until: Option<Instant>,
    pub recitation_until: Option<Instant>,
    pub baneful_until: Option<Instant>,
    pub tether: Option<ObjectId>,
    pub next_fairy_tick: Option<Instant>,
    pub next_follow: Option<Instant>,
    carried_fairy: Option<crate::server::combat_state::CarriedPet>,
    soil_center: Option<Position>,
    soil_until: Option<Instant>,
    soil_object: Option<ObjectId>,
    next_aura: Option<Instant>,
    /// 可附加给其他职业；由全角色周期入口处理。
    excogitation: Option<(Instant, u32, ObjectId)>,
    protraction: Option<(Instant, u32)>,
}
fn active(t: Option<Instant>) -> bool {
    t.is_some_and(|t| t > Instant::now())
}
fn deadline(s: u64) -> Option<Instant> {
    Some(Instant::now() + Duration::from_secs(s))
}
fn live(s: &StatusEffects, id: u16) -> bool {
    s.get(id).is_some_and(|s| s.duration > 0.0)
}
fn recitable(id: u32) -> bool {
    matches!(id, 185 | 186 | 37013 | 3583 | 7434)
}
fn flow_action(id: u32) -> bool {
    matches!(id, 167 | 188 | 189 | 3583 | 7434)
}
fn minimum(id: u32) -> u8 {
    match id {
        17869 => 1,
        17864 => 2,
        173 => 12,
        190 | 17215 => 4,
        16537 => 20,
        17865 => 26,
        185 => 30,
        186 => 35,
        17870 => 38,
        16538 => 40,
        166 | 167 | 189 => 45,
        16539 => 46,
        188 => 50,
        3583 => 52,
        3584 => 54,
        3585 => 56,
        3586 => 58,
        3587 => 60,
        7434 => 62,
        7435 => 64,
        7436 => 66,
        7437 | 7869 => 70,
        16540 | 16541 => 72,
        16542 => 74,
        16543 => 76,
        16545 | 16546 => 80,
        25865 | 25866 => 82,
        25867 => 86,
        25868 => 90,
        37012 => 92,
        37013 => 96,
        37014..=37016 | 37037 => 100,
        _ => 0,
    }
}
impl ScholarState {
    fn resolve(&self, id: u32, l: u8) -> u32 {
        match id {
            17869 | 3584 | 7435 | 16541 | 25865 => {
                if l >= 82 {
                    25865
                } else if l >= 72 {
                    16541
                } else if l >= 64 {
                    7435
                } else if l >= 54 {
                    3584
                } else {
                    17869
                }
            }
            17864 | 17865 | 16540 => {
                if l >= 72 {
                    16540
                } else if l >= 26 {
                    17865
                } else {
                    17864
                }
            }
            16539 | 25866 => {
                if l >= 82 {
                    25866
                } else {
                    16539
                }
            }
            185 if active(self.seraphism_until) => 37015,
            3586 if active(self.seraphism_until) => 37037,
            186 | 37013 if active(self.seraphism_until) => 37016,
            186 | 37013 => {
                if l >= 96 {
                    37013
                } else {
                    186
                }
            }
            7437 if self.tether.is_some() => 7869,
            _ => id,
        }
    }
    fn pack(&self, l: u8) -> u64 {
        let timer = self
            .seraph_until
            .map_or(0, |t| {
                t.saturating_duration_since(Instant::now())
                    .as_millis()
                    .min(22000) as u16
            })
            .to_le_bytes();
        let dismissed = if active(self.dissipated_until) {
            self.fairy_kind.max(6)
        } else {
            0
        }
        .to_le_bytes();
        u64::from_le_bytes([
            if l >= 45 { self.aetherflow } else { 0 },
            if l >= 70 { self.fairy_gauge } else { 0 },
            timer[0],
            timer[1],
            dismissed[0],
            dismissed[1],
            0,
            0,
        ])
    }
}
pub struct Scholar;
impl Job for Scholar {
    fn animation_lock(&self, id: u32) -> f32 {
        if matches!(
            id,
            185 | 186 | 190 | 17869 | 3584 | 7435 | 16541 | 25865 | 37013 | 17215
        ) {
            0.1
        } else {
            0.6
        }
    }
    fn class_jobs(&self) -> &'static [u8] {
        &[28]
    }
    fn resolve_action(
        &self,
        r: &ActionRequest,
        s: &PlayerCombatState,
        l: u8,
        _: &mut GameData,
    ) -> u32 {
        s.scholar.resolve(r.action_id, l)
    }
    fn can_execute(&self, id: u32, c: &PlayerCombatState, l: u8) -> bool {
        let s = &c.scholar;
        if l < minimum(id) {
            return false;
        }
        if flow_action(id) && !(s.aetherflow > 0 || recitable(id) && active(s.recitation_until)) {
            return false;
        }
        let fairy = s.fairy.is_some() && !active(s.dissipated_until);
        match id {
            166 => c.in_combat,
            17215 => !active(s.dissipated_until),
            3587 => c.in_combat && fairy && !active(s.seraph_until) && !active(s.seraphism_until),
            16537 | 16538 => fairy && s.tether.is_none(),
            16543 | 16545 => fairy && !active(s.seraph_until) && s.tether.is_none(),
            16546 => fairy && active(s.seraph_until),
            7437 => fairy && !active(s.seraph_until) && s.fairy_gauge >= 10,
            7869 => s.tether.is_some(),
            37012 => active(s.baneful_until),
            37014 => c.in_combat && fairy,
            37015 | 37016 | 37037 => active(s.seraphism_until),
            // 宠物技能必须由服务器的仙女控制器发出，不能冒充玩家请求。
            802 | 803 | 805 | 7438 | 16544 | 16547 | 16548 | 16550 | 16551 => false,
            _ => true,
        }
    }
    fn action_effects(
        &self,
        id: u32,
        a: &NetworkedActor,
        _: Option<&NetworkedActor>,
        _: bool,
    ) -> Option<EffectsBuilder> {
        effects::build(id, a)
    }
    fn apply_gauge_action(&self, _: &mut PlayerCombatState, _: &GaugeAction) {}
    fn mp_cost(&self, id: u32, a: &NetworkedActor, sheet: u32) -> Option<u32> {
        Some(
            if recitable(id) && a.status_effects().is_some_and(|s| live(s, 1896)) {
                0
            } else {
                sheet
            },
        )
    }
    fn recast_100ms(&self, id: u32, a: &NetworkedActor) -> Option<u32> {
        let l = a.get_common_spawn().level;
        match id {
            3585 => Some(if l >= 88 { 900 } else { 1200 }),
            16542 => Some(if l >= 98 { 600 } else { 900 }),
            37037 => Some(10),
            3586 => Some(if a.status_effects().is_some_and(|s| live(s, 3884)) {
                10
            } else {
                150
            }),
            _ => None,
        }
    }
    fn update_state_after_action(
        &self,
        id: u32,
        a: &mut NetworkedActor,
        owner: ObjectId,
    ) -> JobActionUpdate {
        self.update_state_after_result(id, a, owner, true)
    }
    fn update_state_after_result(
        &self,
        id: u32,
        a: &mut NetworkedActor,
        _: ObjectId,
        landed: bool,
    ) -> JobActionUpdate {
        let NetworkedActor::Player {
            combat_state: c,
            status_effects,
            spawn,
            ..
        } = a
        else {
            return Default::default();
        };
        let l = spawn.common.level;
        let s = &mut c.scholar;
        let free = recitable(id) && live(status_effects, 1896);
        if flow_action(id) && landed {
            if !free {
                s.aetherflow = s.aetherflow.saturating_sub(1);
            }
            if l >= 70 && c.in_combat && s.fairy.is_some() && !active(s.dissipated_until) {
                s.fairy_gauge = (s.fairy_gauge + 10).min(100);
            }
        }
        if free {
            s.recitation_until = None;
            status_effects.remove(1896);
        }
        if matches!(id, 185 | 186 | 37013 | 37015 | 37016) {
            status_effects.remove(792);
        }
        match id {
            166 => s.aetherflow = 3,
            3587 => {
                s.aetherflow = 3;
                s.dissipated_until = deadline(30);
                s.tether = None;
            }
            16542 => s.recitation_until = deadline(15),
            7436 if l >= 92 && landed => s.baneful_until = deadline(30),
            37012 => {
                s.baneful_until = None;
                status_effects.remove(3882);
            }
            16545 => {
                s.seraph_until = deadline(22);
                c.clear_cooldown(10);
                return JobActionUpdate {
                    changed: true,
                    cooldown_update: Some(JobCooldownUpdate {
                        cooldown_group: 10,
                        delta_centisec: 6000,
                    }),
                    ..Default::default()
                };
            }
            37014 => {
                s.seraphism_until = deadline(20);
                c.clear_cooldown(6);
                return JobActionUpdate {
                    changed: true,
                    cooldown_update: Some(JobCooldownUpdate {
                        cooldown_group: 6,
                        delta_centisec: 1500,
                    }),
                    ..Default::default()
                };
            }
            _ => {}
        }
        JobActionUpdate {
            changed: true,
            ..Default::default()
        }
    }
    fn build_gauge_data(&self, s: &PlayerCombatState, l: u8) -> Option<u64> {
        Some(s.scholar.pack(l))
    }
    fn apply_area_action(
        &self,
        n: &mut NetworkState,
        i: &mut Instance,
        c: JobAreaContext<'_>,
    ) -> Option<crate::server::action::area::AreaResult> {
        effects::apply(n, i, c)
    }
    fn refresh_runtime_state_on_actor(
        &self,
        _: ObjectId,
        a: &mut NetworkedActor,
    ) -> JobRefreshResult {
        let NetworkedActor::Player {
            combat_state: c,
            status_effects,
            spawn,
            ..
        } = a
        else {
            return Default::default();
        };
        let s = &mut c.scholar;
        let before = s.pack(spawn.common.level);
        if !live(status_effects, 1896) {
            s.recitation_until = None;
        }
        if !live(status_effects, 3882) {
            s.baneful_until = None;
        }
        if !live(status_effects, 3884) {
            s.seraphism_until = None;
        }
        if spawn.common.health_points == 0 {
            s.aetherflow = 0;
            s.fairy_gauge = 0;
        }
        JobRefreshResult {
            changed: before != s.pack(spawn.common.level),
            ..Default::default()
        }
    }
    fn persistent_actors(&self) -> Option<&dyn JobActors> {
        Some(self)
    }
}
pub(in crate::server) use actors::take_for_zone;
pub(in crate::server) use effects::{critical_heal, restore, shield};
pub(in crate::server) use effects::{mitigation, tick_support};
