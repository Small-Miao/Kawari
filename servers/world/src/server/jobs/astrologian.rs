//! 占星术士的卡牌、热键替换和客户端原生量谱。

mod effects;

use std::time::Instant;

use kawari::{common::ObjectId, ipc::zone::ActionRequest};

use crate::{
    gamedata::GameData,
    lua::GaugeAction,
    server::{
        actor::NetworkedActor,
        combat_state::PlayerCombatState,
        jobs::dispatch::{Job, JobActionUpdate, JobRefreshResult},
    },
};

use effects::EarthlyStar;
pub(in crate::server) use effects::{
    DelayedHeal, action_effects, apply_support_action, damage_bonus, finish_earthly_star_action,
    has_lightspeed, incoming_heal_multiplier, mitigation_multiplier, refresh_delayed_actions,
};

pub(crate) const CLASSJOB_ASTROLOGIAN: u8 = 33;
const LEVEL_DRAW: u8 = 30;
const LEVEL_MINOR_ARCANA: u8 = 70;

const ASTRAL_DRAW: u32 = 37017;
const UMBRAL_DRAW: u32 = 37018;
const PLAY_I: u32 = 37019;
const PLAY_II: u32 = 37020;
const PLAY_III: u32 = 37021;
const MINOR_ARCANA: u32 = 37022;
const BALANCE: u32 = 37023;
const ARROW: u32 = 37024;
const SPIRE: u32 = 37025;
const SPEAR: u32 = 37026;
const BOLE: u32 = 37027;
const EWER: u32 = 37028;
const LORD: u32 = 7444;
const LADY: u32 = 7445;
const DIVINATION: u32 = 16552;
const ORACLE: u32 = 37029;
const NEUTRAL_SECT: u32 = 16559;
const SUN_SIGN: u32 = 37031;
const HOROSCOPE: u32 = 16557;
const HOROSCOPE_HEAL: u32 = 16558;
const MACROCOSMOS: u32 = 25874;
const MICROCOSMOS: u32 = 25875;
const EARTHLY_STAR: u32 = 7439;
const STELLAR_DETONATION: u32 = 8324;

#[repr(u8)]
#[derive(Debug, Clone, Copy, Default, PartialEq, Eq)]
enum Card {
    #[default]
    Empty = 0,
    Balance = 1,
    Bole = 2,
    Arrow = 3,
    Spear = 4,
    Ewer = 5,
    Spire = 6,
    Lord = 7,
    Lady = 8,
}

impl Card {
    fn action(self) -> Option<u32> {
        Some(match self {
            Self::Empty => return None,
            Self::Balance => BALANCE,
            Self::Bole => BOLE,
            Self::Arrow => ARROW,
            Self::Spear => SPEAR,
            Self::Ewer => EWER,
            Self::Spire => SPIRE,
            Self::Lord => LORD,
            Self::Lady => LADY,
        })
    }
}

const ASTRAL_HAND: [Card; 4] = [Card::Balance, Card::Arrow, Card::Spire, Card::Lord];
const UMBRAL_HAND: [Card; 4] = [Card::Spear, Card::Bole, Card::Ewer, Card::Lady];

fn card_slot(action: u32) -> Option<usize> {
    match action {
        PLAY_I | BALANCE | SPEAR => Some(0),
        PLAY_II | ARROW | BOLE => Some(1),
        PLAY_III | SPIRE | EWER => Some(2),
        MINOR_ARCANA | LORD | LADY => Some(3),
        _ => None,
    }
}

#[derive(Debug, Clone)]
pub struct AstrologianState {
    hand: [Card; 4],
    next_umbral: bool,
    oracle_until: Option<Instant>,
    sun_sign_until: Option<Instant>,
    horoscope_until: Option<Instant>,
    macrocosmos_until: Option<Instant>,
    star: Option<EarthlyStar>,
    collective: Option<(kawari::common::Position, f32, Instant)>,
}

impl Default for AstrologianState {
    fn default() -> Self {
        Self {
            hand: ASTRAL_HAND,
            next_umbral: true,
            oracle_until: None,
            sun_sign_until: None,
            horoscope_until: None,
            macrocosmos_until: None,
            star: None,
            collective: None,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use binrw::BinWrite;
    use kawari::ipc::zone::{ServerZoneIpcData, ServerZoneIpcSegment};
    use std::io::Cursor;

    #[test]
    fn recorded_arcana_gauge_follows_both_hands() {
        let mut state = AstrologianState::default();
        let now = Instant::now();
        let steps = [
            (BALANCE, [0x30, 0x76, 1]),
            (ARROW, [0x00, 0x76, 1]),
            (SPIRE, [0x00, 0x70, 1]),
            (LORD, [0, 0, 1]),
            (UMBRAL_DRAW, [0x24, 0x85, 0]),
            (SPEAR, [0x20, 0x85, 0]),
            (BOLE, [0x00, 0x85, 0]),
            (EWER, [0x00, 0x80, 0]),
            (LADY, [0, 0, 0]),
            (ASTRAL_DRAW, [0x31, 0x76, 1]),
        ];
        assert_eq!(initial_gauge(100).to_le_bytes()[..3], [0x31, 0x76, 1]);
        assert_eq!(initial_gauge(69).to_le_bytes()[..3], [0x31, 0x06, 1]);
        assert_eq!(initial_gauge(29), 0);
        for (action, expected) in steps {
            assert!(state.can_execute(action, 100, now));
            assert!(state.apply_card_action(action));
            let ipc = ServerZoneIpcSegment::new(ServerZoneIpcData::ActorGauge {
                classjob_id: CLASSJOB_ASTROLOGIAN,
                data: state.gauge(100),
                extra: [0;6],
            });
            let mut wire = Cursor::new(Vec::new());
            ipc.write_le(&mut wire).unwrap();
            let bytes = wire.into_inner();
            let mut payload = [0; 16];
            payload[0] = 33;
            payload[2..5].copy_from_slice(&expected);
            assert_eq!(bytes[16..], payload);
        }
    }

    #[test]
    fn card_buttons_reject_empty_slots_and_cards_from_the_other_hand() {
        let now = Instant::now();
        let mut state = AstrologianState::default();
        assert_eq!(state.resolve(PLAY_I, 100, now), BALANCE);
        assert!(!state.can_execute(SPEAR, 100, now));
        assert!(!state.can_execute(LORD, 69, now));
        assert!(state.apply_card_action(BALANCE));
        assert!(!state.can_execute(BALANCE, 100, now));
        assert!(!state.can_execute(PLAY_I, 100, now));
        assert_eq!(state.resolve(ASTRAL_DRAW, 100, now), UMBRAL_DRAW);
    }
}

impl AstrologianState {
    pub(in crate::server) fn take_star_for_zone_change(&mut self) -> Option<ObjectId> {
        self.star.take().and_then(|star| star.object)
    }

    fn resolve(&self, action: u32, level: u8, now: Instant) -> u32 {
        match action {
            ASTRAL_DRAW if self.next_umbral => UMBRAL_DRAW,
            PLAY_I..=MINOR_ARCANA => self.hand[card_slot(action).unwrap()]
                .action()
                .unwrap_or(action),
            DIVINATION if self.oracle_until.is_some_and(|until| until > now) => ORACLE,
            NEUTRAL_SECT if self.sun_sign_until.is_some_and(|until| until > now) => SUN_SIGN,
            HOROSCOPE if self.horoscope_until.is_some_and(|until| until > now) => HOROSCOPE_HEAL,
            MACROCOSMOS if self.macrocosmos_until.is_some_and(|until| until > now) => MICROCOSMOS,
            EARTHLY_STAR if self.star.is_some() => STELLAR_DETONATION,
            3596 if level >= 82 => 25871,
            3596 if level >= 72 => 16555,
            3596 if level >= 64 => 7442,
            3596 if level >= 54 => 3598,
            3599 if level >= 72 => 16554,
            3599 if level >= 46 => 3608,
            3615 if level >= 82 => 25872,
            3601 if level >= 96 => 37030,
            _ => action,
        }
    }

    fn can_execute(&self, action: u32, level: u8, now: Instant) -> bool {
        if let Some(slot) = card_slot(action) {
            let unlock = if slot == 3 {
                LEVEL_MINOR_ARCANA
            } else {
                LEVEL_DRAW
            };
            return level >= unlock && self.hand[slot].action() == Some(action);
        }
        match action {
            ASTRAL_DRAW => level >= LEVEL_DRAW && !self.next_umbral,
            UMBRAL_DRAW => level >= LEVEL_DRAW && self.next_umbral,
            ORACLE => level >= 92 && self.oracle_until.is_some_and(|until| until > now),
            SUN_SIGN => level >= 100 && self.sun_sign_until.is_some_and(|until| until > now),
            HOROSCOPE_HEAL => self.horoscope_until.is_some_and(|until| until > now),
            MICROCOSMOS => self.macrocosmos_until.is_some_and(|until| until > now),
            STELLAR_DETONATION => self.star.is_some(),
            _ => true,
        }
    }

    fn apply_card_action(&mut self, action: u32) -> bool {
        match action {
            ASTRAL_DRAW | UMBRAL_DRAW => {
                let astral = action == ASTRAL_DRAW;
                self.hand = if astral { ASTRAL_HAND } else { UMBRAL_HAND };
                self.next_umbral = astral;
                true
            }
            _ if let Some(slot) = card_slot(action)
                && self.hand[slot].action() == Some(action) =>
            {
                self.hand[slot] = Card::Empty;
                true
            }
            _ => false,
        }
    }

    fn gauge(&self, level: u8) -> u64 {
        if level < LEVEL_DRAW {
            return 0;
        }
        let [play_i, play_ii, play_iii, crown] = self.hand.map(|card| card as u8);
        let crown = if level >= LEVEL_MINOR_ARCANA {
            crown
        } else {
            0
        };
        u64::from_le_bytes([
            play_i | (play_ii << 4),
            play_iii | (crown << 4),
            u8::from(self.next_umbral),
            0,
            0,
            0,
            0,
            0,
        ])
    }
}

pub(crate) fn initial_gauge(level: u8) -> u64 {
    AstrologianState::default().gauge(level)
}

pub(in crate::server) fn deactivate(actor: &mut NetworkedActor) -> Option<ObjectId> {
    effects::deactivate(actor)
}

pub(in crate::server) fn party_target_only(action: u32) -> bool {
    matches!(
        action,
        BALANCE | ARROW | SPIRE | SPEAR | BOLE | EWER | 3612 | 16556 | 25873
    )
}

pub(in crate::server) struct Astrologian;

impl Job for Astrologian {
    fn class_jobs(&self) -> &'static [u8] {
        &[CLASSJOB_ASTROLOGIAN]
    }

    fn resolve_action(
        &self,
        request: &ActionRequest,
        combat_state: &PlayerCombatState,
        level: u8,
        _game_data: &mut GameData,
    ) -> u32 {
        combat_state
            .astrologian
            .resolve(request.action_id, level, Instant::now())
    }

    fn can_execute(&self, action: u32, combat_state: &PlayerCombatState, level: u8) -> bool {
        combat_state
            .astrologian
            .can_execute(action, level, Instant::now())
    }

    fn apply_gauge_action(&self, _: &mut PlayerCombatState, _: &GaugeAction) {}

    fn update_state_after_action(
        &self,
        action: u32,
        actor: &mut NetworkedActor,
        _: ObjectId,
    ) -> JobActionUpdate {
        effects::update_procs(action, actor);
        let NetworkedActor::Player { combat_state, .. } = actor else {
            return JobActionUpdate::default();
        };
        JobActionUpdate {
            changed: combat_state.astrologian.apply_card_action(action),
            ..Default::default()
        }
    }

    fn build_gauge_data(&self, combat_state: &PlayerCombatState, level: u8) -> Option<u64> {
        Some(combat_state.astrologian.gauge(level))
    }

    fn refresh_runtime_state_on_actor(
        &self,
        _: ObjectId,
        _: &mut NetworkedActor,
    ) -> JobRefreshResult {
        JobRefreshResult::default()
    }
}
