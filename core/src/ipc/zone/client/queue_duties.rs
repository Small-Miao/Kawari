use binrw::binrw;
use bitflags::bitflags;

use crate::ipc::zone::SocialListUILanguages;

#[binrw]
#[derive(Clone, Copy, Eq, PartialEq, Default)]
pub struct DutyFinderSetting(u64);

bitflags! {
    impl DutyFinderSetting: u64 {
        /// Enables join party in progress mode.
        const JOIN_PARTY_IN_PROGRESS = 0x2;
        /// ???
        const INITIATED_BY_PARTY_MEMBER = 0x4;
        /// ???
        const IN_PROGRESS_PARTY = 0x80;
        /// ???
        const GREED_ONLY = 0x800;
        /// Enables unrestricted party mode.
        const UNRESTRICTED_PARTY = 0x2000;
        /// Enables minimum item level mode.
        const MINIMUM_ITEM_LEVEL = 0x4000;
        /// ???
        const LOOTMASTER = 0x10000;
        /// Enables level sync mode.
        const LEVEL_SYNC = 0x200000;
        /// ???
        const LIMITED_LEVELING_ROULETTE = 0x400000;
        /// Enables silence echo mode.
        const SILENCE_ECHO = 0x10000000;
        /// Enables explorer mode. If the client enables this, no other flags are sent.
        const EXPLORER_MODE = 0x100000000;
    }
}

impl std::fmt::Debug for DutyFinderSetting {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        bitflags::parser::to_writer(self, f)
    }
}

impl DutyFinderSetting {
    /// The DutyFinderSetting "mode word" Kawari writes into the ContentFinder ready packets.
    /// Forces bit 0x20 — a server-authored "organized party / no-withdrawal-penalty" context bit
    /// that the client never sends itself but reads back: it gates ContentsFinderQueueInfo+0x5E,
    /// which controls whether the ready-popup Withdraw button shows the (false, for Kawari) duty-
    /// abandonment penalty dialog. Without it every pop shows the penalty warning. The user's
    /// selected icon flags (unrestricted/sync/etc.) ride along unchanged; the Explorer bit is NOT
    /// added. (0x20's exact retail name is inferred from behavior.)
    pub fn to_ready_mode_word(self) -> u64 {
        self.bits() | 0x20
    }
}

#[binrw]
#[derive(Debug, Clone, Default)]
pub struct QueueDuties {
    unk1: [u8; 8],
    /// The settings the client is queuing with.
    pub settings: DutyFinderSetting,
    /// Selected languages to match with.
    pub languages: SocialListUILanguages,
    unk3: u8,
    unk6: u8,
    unk4: [u8; 7],
    /// List of Content Finder Condition IDs the player signed up for.
    pub content_ids: [u16; 5],
    unk5: [u8; 4],
}
