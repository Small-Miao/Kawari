//! 蝰蛇剑士：基本体势与强碎/祖灵链分离；追加攻击保留 10 字节量谱。
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
use crate::{FromServer, server::network::DestinationNetwork};
use kawari::{
    common::ObjectId,
    ipc::zone::{
        ActionRequest, ActorControl, ActorControlCategory, ServerZoneIpcData, ServerZoneIpcSegment,
    },
};
use std::time::{Duration, Instant};

pub(in crate::server) const CLASS_JOB: u8 = 41;
const STATUS_REAWAKENED: u16 = 3670;
const STATUS_READY_TO_REAWAKEN: u16 = 3671;
#[derive(Debug, Clone, Default)]
pub struct ViperState {
    pub coils: u8,
    pub tribute: u8,
    pub offering: u8,
    pub dread: u8,
    pub follow: u8,
    pub follow_count: u8,
    basic: u32,
    basic_until: Option<Instant>,
    dread_until: Option<Instant>,
    awaken_until: Option<Instant>,
    follow_until: Option<Instant>,
    ready_until: Option<Instant>,
}
fn active(t: Option<Instant>) -> bool {
    t.is_some_and(|t| t > Instant::now())
}
fn until(s: u64) -> Option<Instant> {
    Some(Instant::now() + Duration::from_secs(s))
}
fn timer(t: Option<Instant>) -> [u8; 2] {
    t.map_or(0, |t| {
        t.saturating_duration_since(Instant::now())
            .as_millis()
            .min(30000) as u16
    })
    .to_le_bytes()
}
fn minimum(id: u32) -> u8 {
    match id {
        34606 => 1,
        34608 => 5,
        34607 => 10,
        34632 => 15,
        34609 => 20,
        34614 => 25,
        34610..=34613 => 30,
        34615 => 35,
        34616 | 34646 => 40,
        34617 => 45,
        34618 | 34619 => 50,
        34634 | 35920 => 55,
        34635 => 60,
        34620..=34622 => 65,
        34623..=34625 => 70,
        34636 | 34637 | 35921 | 35922 => 75,
        34638 | 34639 => 80,
        34633 => 82,
        34647 => 86,
        34626..=34630 => 90,
        34644 | 34645 => 92,
        34631 => 96,
        34640..=34643 => 100,
        _ => 0,
    }
}

pub(in crate::server) fn handles_action(id: u32) -> bool {
    minimum(id) != 0
}

pub(in crate::server) fn sync_reawaken_notifications(
    network: &mut NetworkState,
    instance: &Instance,
    actor_id: ObjectId,
    previous: &crate::StatusEffects,
) {
    let Some(current) = instance
        .find_actor(actor_id)
        .and_then(NetworkedActor::status_effects)
    else {
        return;
    };
    for id in [STATUS_READY_TO_REAWAKEN, STATUS_REAWAKENED] {
        let effect_id = u32::from(id);
        let notice = match (previous.get(id).is_some(), current.get(id).is_some()) {
            (true, false) => ActorControlCategory::LoseEffect {
                effect_id,
                unk2: 0,
                source_actor_id: ObjectId(0),
            },
            (false, true) if id == STATUS_REAWAKENED => ActorControlCategory::GainEffect {
                effect_id,
                param: 0,
                source_actor_id: ObjectId(0),
            },
            _ => continue,
        };
        let packet = ServerZoneIpcSegment::new(ServerZoneIpcData::ActorControl(ActorControl {
            category: notice,
        }));
        network.send_in_range_inclusive_instance(
            actor_id,
            instance,
            FromServer::PacketSegment(packet, actor_id),
            DestinationNetwork::ZoneClients,
        );
    }
}

fn weapon(id: u32) -> bool {
    matches!(id, 34606..=34633)
}
impl ViperState {
    fn pack(&self) -> u64 {
        let d = timer(self.dread_until);
        let a = timer(self.awaken_until);
        u64::from_le_bytes([
            self.coils,
            self.tribute,
            self.offering,
            self.dread,
            d[0],
            d[1],
            a[0],
            a[1],
        ])
    }
    fn extra(&self) -> [u8; 6] {
        [
            if active(self.follow_until) {
                self.follow << 2 | self.follow_count
            } else {
                0
            },
            0,
            0,
            0,
            0,
            0,
        ]
    }
    fn resolve(&self, id: u32) -> u32 {
        if self.tribute > 0 && active(self.awaken_until) {
            match id {
                34606 | 34614 => return 34627,
                34607 | 34615 => return 34628,
                34621 | 34624 => return 34629,
                34622 | 34625 => return 34630,
                34626 => return 34631,
                _ => {}
            }
        }
        if active(self.basic_until) {
            match (id, self.basic) {
                (34606, 34606 | 34607) => return 34608,
                (34607, 34606 | 34607) => return 34609,
                (34606, 34608) => return 34610,
                (34607, 34608) => return 34611,
                (34606, 34609) => return 34612,
                (34607, 34609) => return 34613,
                (34614, 34614 | 34615) => return 34616,
                (34615, 34614 | 34615) => return 34617,
                (34614, 34616 | 34617) => return 34618,
                (34615, 34616 | 34617) => return 34619,
                _ => {}
            }
        }
        if active(self.follow_until) && self.follow_count > 0 {
            match (id, self.follow) {
                (35920, 1) => return 34634,
                (35920, 2) => return 34635,
                (35920, 3..=6) => return 34637 + self.follow as u32,
                (35921, 7) => return 34636,
                (35922, 7) => return 34637,
                (35921, 8) => return 34638,
                (35922, 8) => return 34639,
                (35921, 9) => return 34644,
                (35922, 9) => return 34645,
                _ => {}
            }
        }
        id
    }
    fn set_follow(&mut self, kind: u8, count: u8) {
        self.follow = kind;
        self.follow_count = count;
        self.follow_until = until(30);
    }
    fn set_dread(&mut self, step: u8) {
        self.dread = step;
        self.dread_until = if step == 0 { None } else { until(30) };
    }
}
pub(in crate::server) struct Viper;
impl Job for Viper {
    fn class_jobs(&self) -> &'static [u8] {
        &[CLASS_JOB]
    }
    fn resolve_action(
        &self,
        r: &ActionRequest,
        c: &PlayerCombatState,
        _: u8,
        _: &mut GameData,
    ) -> u32 {
        c.viper.resolve(r.action_id)
    }
    fn can_execute(&self, id: u32, c: &PlayerCombatState, l: u8) -> bool {
        if l < minimum(id) {
            return false;
        }
        let s = &c.viper;
        let awake = s.tribute > 0 && active(s.awaken_until);
        if awake && weapon(id) && !matches!(id, 34627..=34631) {
            return false;
        }
        match id {
            34608 | 34609 => active(s.basic_until) && matches!(s.basic, 34606 | 34607),
            34610 | 34611 => active(s.basic_until) && s.basic == 34608,
            34612 | 34613 => active(s.basic_until) && s.basic == 34609,
            34616 | 34617 => active(s.basic_until) && matches!(s.basic, 34614 | 34615),
            34618 | 34619 => active(s.basic_until) && matches!(s.basic, 34616 | 34617),
            34621 => active(s.dread_until) && matches!(s.dread, 1 | 3),
            34622 => active(s.dread_until) && matches!(s.dread, 1 | 2),
            34624 => active(s.dread_until) && matches!(s.dread, 4 | 6),
            34625 => active(s.dread_until) && matches!(s.dread, 4 | 5),
            34626 => !awake && (s.offering >= 50 || active(s.ready_until)),
            34627..=34631 => awake,
            34633 => s.coils > 0,
            34634..=34645 => {
                let kind = match id {
                    34634 => 1,
                    34635 => 2,
                    34636 | 34637 => 7,
                    34638 | 34639 => 8,
                    34640..=34643 => (id - 34637) as u8,
                    _ => 9,
                };
                active(s.follow_until) && s.follow == kind && s.follow_count > 0
            }
            34647 => c.in_combat,
            35920..=35922 => false,
            _ => true,
        }
    }
    fn preserves_combo(&self, id: u32) -> bool {
        !matches!(id, 34606..=34619)
    }
    fn grants_combo(&self, id: u32, c: &PlayerCombatState) -> bool {
        matches!(id,34608..=34613|34616..=34619) && active(c.viper.basic_until)
    }
    fn damage_percent(&self, a: &NetworkedActor) -> u32 {
        if a.status_effects().is_some_and(|s| s.get(3668).is_some()) {
            110
        } else {
            100
        }
    }
    fn speed_percent(&self, a: &NetworkedActor) -> u32 {
        speed(a)
    }
    fn fixed_primary_recast(&self, id: u32) -> bool {
        matches!(id, 34620 | 34623)
    }
    fn additional_gcd_100ms(&self, id: u32) -> Option<u32> {
        matches!(id, 34620 | 34623).then_some(30)
    }
    fn action_effects(
        &self,
        id: u32,
        _: &NetworkedActor,
        _: Option<&NetworkedActor>,
        _: bool,
    ) -> Option<EffectsBuilder> {
        (minimum(id) > 0).then(EffectsBuilder::default)
    }
    fn apply_gauge_action(&self, _: &mut PlayerCombatState, _: &GaugeAction) {}
    fn update_state_after_action(
        &self,
        _: u32,
        _: &mut NetworkedActor,
        _: ObjectId,
    ) -> JobActionUpdate {
        Default::default()
    }
    fn build_gauge_data(&self, c: &PlayerCombatState, _: u8) -> Option<u64> {
        Some(c.viper.pack())
    }
    fn build_gauge_extra(&self, c: &PlayerCombatState, _: u8) -> [u8; 6] {
        c.viper.extra()
    }
    fn refresh_runtime_state_on_actor(
        &self,
        _: ObjectId,
        a: &mut NetworkedActor,
    ) -> JobRefreshResult {
        let NetworkedActor::Player {
            combat_state,
            spawn,
            status_effects,
            ..
        } = a
        else {
            return Default::default();
        };
        let s = &mut combat_state.viper;
        let before = (s.pack(), s.extra());
        if spawn.common.health_points == 0 {
            *s = Default::default();
        }
        if !active(s.basic_until) {
            s.basic = 0;
            s.basic_until = None;
        }
        if !active(s.dread_until) {
            s.set_dread(0);
        }
        if !active(s.awaken_until) {
            s.tribute = 0;
            s.awaken_until = None;
            status_effects.remove(STATUS_REAWAKENED);
        }
        if !active(s.follow_until) {
            s.follow = 0;
            s.follow_count = 0;
            s.follow_until = None;
        }
        JobRefreshResult {
            changed: before != (s.pack(), s.extra()),
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
impl JobActors for Viper {
    fn on_job_deactivated(&self, _: &mut NetworkState, i: &mut Instance, o: ObjectId) {
        if let Some(a) = i.find_actor_mut(o) {
            super::paladin::deactivate(a);
            if let NetworkedActor::Player {
                combat_state,
                status_effects,
                ..
            } = a
            {
                combat_state.viper = Default::default();
                for id in (3645..=3672).chain([3772]) {
                    status_effects.remove(id);
                }
            }
        }
    }
}
pub(in crate::server) fn speed(a: &NetworkedActor) -> u32 {
    if a.status_effects().is_some_and(|s| s.get(3669).is_some()) {
        85
    } else {
        100
    }
}
