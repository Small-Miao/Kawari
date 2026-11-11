//! 小队战术板的定向重发、回执和实时主持人状态。
use std::collections::{HashMap, HashSet};

use kawari::{
    common::ObjectId,
    ipc::zone::{StrategyBoard, StrategyBoardUpdate},
};

use super::{ClientId, DestinationNetwork, FromServer, NetworkState, Party, PartyMember};

#[derive(Clone, Debug, Default)]
pub struct StrategyBoardSession {
    host: Option<u64>,
    viewers: HashSet<u64>,
    waiting_for_snapshot: HashSet<u64>,
    pending_receipts: HashMap<(u64, u8), HashSet<u64>>,
}

impl StrategyBoardSession {
    fn claim(&mut self, owner: u64, broadcast: bool) -> Result<(), u64> {
        match self.host {
            Some(host) if host != owner => Err(host),
            Some(_) => Ok(()),
            None if broadcast => {
                self.host = Some(owner);
                Ok(())
            }
            None => Err(0),
        }
    }

    fn record_share(&mut self, sender: u64, recipient: u64, index: u8, realtime: bool) {
        self.pending_receipts
            .entry((sender, index))
            .or_default()
            .insert(recipient);
        if realtime {
            self.waiting_for_snapshot.remove(&recipient);
            self.viewers.insert(recipient);
        }
    }

    fn accept_receipt(&mut self, sender: u64, recipient: u64, index: u8) -> bool {
        if index == 0 {
            return self.host == Some(sender) && self.waiting_for_snapshot.contains(&recipient);
        }
        let key = (sender, index);
        let Some(receivers) = self.pending_receipts.get_mut(&key) else {
            return false;
        };
        let matched = receivers.remove(&recipient);
        if receivers.is_empty() {
            self.pending_receipts.remove(&key);
        }
        matched
    }

    fn remove_member(&mut self, member: u64) {
        self.waiting_for_snapshot.remove(&member);
        self.viewers.remove(&member);
        self.pending_receipts.retain(|(sender, _), recipients| {
            recipients.remove(&member);
            *sender != member && !recipients.is_empty()
        });
    }

    fn clear_live(&mut self) -> bool {
        if self.host.take().is_none() {
            return false;
        }
        self.viewers.clear();
        self.waiting_for_snapshot.clear();
        true
    }
}

fn online(member: &PartyMember) -> bool {
    member.actor_id.is_valid() && member.zone_client_id != ClientId::default()
}

fn online_actor(party: &Party, content_id: u64) -> Option<ObjectId> {
    party
        .members
        .iter()
        .find(|member| member.content_id == content_id && online(member))
        .map(|member| member.actor_id)
}

fn send(network: &mut NetworkState, actor: ObjectId, message: FromServer) {
    network.send_to_by_actor_id(actor, message, DestinationNetwork::ZoneClients);
}

pub(super) fn share(
    network: &mut NetworkState,
    party_id: u64,
    actor: ObjectId,
    sender: u64,
    recipient: u64,
    board: &StrategyBoard,
) {
    let Some(info) = board.validate_share() else {
        return;
    };
    let Some(party) = network.parties.get_mut(&party_id) else {
        return;
    };
    if online_actor(party, sender) != Some(actor) || recipient == sender {
        return;
    }

    let recipients: Vec<_> = party
        .members
        .iter()
        .filter(|member| {
            online(member)
                && member.content_id != sender
                && (recipient == 0 || member.content_id == recipient)
        })
        .map(|member| (member.content_id, member.actor_id))
        .collect();
    if recipients.is_empty() {
        return;
    }

    let session = &mut party.strategy_board;
    if info.realtime
        && let Err(host) = session.claim(sender, recipient == 0)
    {
        if host != 0 {
            session.waiting_for_snapshot.insert(sender);
            send(network, actor, FromServer::StrategyBoardHost(host, 2));
        }
        return;
    }
    // 客户端发送初始快照前已设置本地主持人并进入编辑器。
    // 将主持人通知发回发送者会再次调用客户端界面切换逻辑。
    let recipients: Vec<_> = recipients
        .into_iter()
        .map(|(content_id, target)| {
            let announce = info.realtime && info.refresh && !session.viewers.contains(&content_id);
            session.record_share(sender, content_id, info.index, info.realtime);
            (target, announce)
        })
        .collect();
    for (target, announce) in recipients {
        if announce {
            send(network, target, FromServer::StrategyBoardHost(sender, 0));
        }
        send(
            network,
            target,
            FromServer::StrategyBoardShared(sender, board.clone()),
        );
    }
}

pub(super) fn acknowledge(
    network: &mut NetworkState,
    party_id: u64,
    receiver: u64,
    sender: u64,
    index: u8,
) {
    let Some(party) = network.parties.get_mut(&party_id) else {
        return;
    };
    if receiver == sender || online_actor(party, receiver).is_none() {
        return;
    }
    if let Some(actor) = online_actor(party, sender)
        && party.strategy_board.accept_receipt(sender, receiver, index)
    {
        send(
            network,
            actor,
            FromServer::StrategyBoardSharedAck(receiver, index),
        );
    }
}

pub(super) fn update(
    network: &mut NetworkState,
    party_id: u64,
    actor: ObjectId,
    sender: u64,
    update: &StrategyBoardUpdate,
) {
    let Some(party) = network.parties.get(&party_id) else {
        return;
    };
    let session = &party.strategy_board;
    if session.host != Some(sender)
        || online_actor(party, sender) != Some(actor)
        || !update.has_valid_checksum()
    {
        return;
    }
    let viewers: Vec<_> = session
        .viewers
        .iter()
        .filter_map(|id| online_actor(party, *id))
        .collect();
    for actor in viewers {
        send(
            network,
            actor,
            FromServer::StrategyBoardRealtimeUpdate(update.clone()),
        );
    }
}

pub(super) fn control(
    network: &mut NetworkState,
    party_id: u64,
    actor: ObjectId,
    sender: u64,
    operation: u8,
) {
    let Some(party) = network.parties.get_mut(&party_id) else {
        return;
    };
    if online_actor(party, sender) != Some(actor) {
        return;
    }
    let session = &mut party.strategy_board;
    if operation == 0 && session.host == Some(sender) {
        close(network, party_id);
    } else if operation == 3
        && let Some(host) = session.host
        && host != sender
    {
        // 客户端无法应用增量时，可能已丢失主持人 ID，无法主动发送编号 0 的回执。
        session.viewers.remove(&sender);
        session.waiting_for_snapshot.insert(sender);
        acknowledge(network, party_id, sender, host, 0);
    }
}

pub(super) fn close(network: &mut NetworkState, party_id: u64) {
    let Some(party) = network.parties.get_mut(&party_id) else {
        return;
    };
    if party.strategy_board.clear_live() {
        let actors: Vec<_> = party
            .members
            .iter()
            .filter(|member| online(member))
            .map(|member| member.actor_id)
            .collect();
        for actor in actors {
            send(network, actor, FromServer::StrategyBoardHost(0, 0));
        }
    }
}

pub(super) fn member_departed(
    network: &mut NetworkState,
    party_id: u64,
    content_id: u64,
    disbanding: bool,
) {
    let Some(party) = network.parties.get_mut(&party_id) else {
        return;
    };
    let actor = online_actor(party, content_id);
    let session = &mut party.strategy_board;
    let was_viewing =
        session.viewers.contains(&content_id) || session.waiting_for_snapshot.contains(&content_id);
    session.remove_member(content_id);
    if disbanding || session.host == Some(content_id) {
        close(network, party_id);
    } else if was_viewing && let Some(actor) = actor {
        send(network, actor, FromServer::StrategyBoardHost(0, 0));
    }
}

pub(super) fn member_joined(network: &mut NetworkState, party_id: u64, content_id: u64) {
    let Some(party) = network.parties.get_mut(&party_id) else {
        return;
    };
    if let Some(host) = party.strategy_board.host
        && host != content_id
        && let Some(actor) = online_actor(party, content_id)
    {
        party.strategy_board.viewers.remove(&content_id);
        party.strategy_board.waiting_for_snapshot.insert(content_id);
        send(network, actor, FromServer::StrategyBoardHost(host, 0));
    }
}

#[cfg(test)]
mod tests {
    use std::{
        io::Cursor,
        sync::{Arc, atomic::AtomicUsize},
    };

    use binrw::BinRead;
    use tokio::sync::mpsc::{Receiver, channel};

    use crate::{ClientHandle, common::ServerHandle};

    use super::*;

    const PARTY: u64 = 10;
    const HOST: u64 = 100;
    const VIEWER: u64 = 200;
    const JOINER: u64 = 300;

    fn add_player(network: &mut NetworkState, id: u64) -> Receiver<FromServer> {
        let (server, _) = channel(1);
        let ids = ServerHandle {
            chan: server,
            next_id: Arc::new(AtomicUsize::new(id as usize)),
        };
        let client_id = ids.next_id();
        let (channel, receiver) = channel(16);
        let actor_id = ObjectId(id as u32);
        network.clients.insert(
            client_id,
            (
                ClientHandle {
                    id: client_id,
                    channel,
                    actor_id,
                    content_id: id,
                    account_id: id,
                },
                Default::default(),
            ),
        );
        network
            .parties
            .entry(PARTY)
            .or_default()
            .members
            .push(PartyMember {
                actor_id,
                content_id: id,
                zone_client_id: client_id,
                ..Default::default()
            });
        receiver
    }

    fn board(flags: u8, index: u8, total: u8) -> StrategyBoard {
        let mut data = [0; 1176];
        // 三个零字节是客户端的空战术板，校验和覆盖完整的 1040 字节区域。
        data[..4].copy_from_slice(&match flags {
            1 => [0x67, 0x51, 0x1e, 0xed],
            3 => [0x00, 0xb0, 0x18, 0x84],
            4 => [0x3a, 0x60, 0x28, 0xe6],
            _ => [0xf4, 0xa2, 0x25, 0x34],
        });
        data[8..22].copy_from_slice(&[3, 0, flags, 0x78, 0x9c, 0x63, 0x60, 0x60, 0, 0, 0, 3, 0, 1]);
        data[1168] = index;
        data[1169] = total;
        StrategyBoard::read(&mut Cursor::new(data)).unwrap()
    }

    fn valid_update() -> StrategyBoardUpdate {
        let mut data = [0; 64];
        data[..4].copy_from_slice(&[0x49, 0xa5, 0xc8, 0xd3]);
        StrategyBoardUpdate::read(&mut Cursor::new(data)).unwrap()
    }

    #[test]
    fn shares_single_boards_and_folder_entries_with_indexed_receipts() {
        let mut network = NetworkState::default();
        let mut host = add_player(&mut network, HOST);
        let mut viewer = add_player(&mut network, VIEWER);
        let mut third = add_player(&mut network, JOINER);
        let actor = ObjectId(HOST as u32);

        share(&mut network, PARTY, actor, HOST, 0, &board(0, 1, 1));
        for recipient in [&mut viewer, &mut third] {
            assert!(matches!(
                recipient.try_recv().unwrap(),
                FromServer::StrategyBoardShared(HOST, _)
            ));
        }
        share(&mut network, PARTY, actor, HOST, VIEWER, &board(4, 2, 3));
        assert!(
            matches!(viewer.try_recv().unwrap(), FromServer::StrategyBoardShared(HOST, board) if board.validate_share().unwrap().index == 2)
        );
        acknowledge(&mut network, PARTY, JOINER, HOST, 2);
        assert!(third.try_recv().is_err());
        assert!(host.try_recv().is_err());
        acknowledge(&mut network, PARTY, VIEWER, HOST, 2);
        assert!(matches!(
            host.try_recv().unwrap(),
            FromServer::StrategyBoardSharedAck(VIEWER, 2)
        ));
        acknowledge(&mut network, PARTY, VIEWER, HOST, 2);
        share(&mut network, PARTY, actor, HOST, 0, &board(4, 4, 3));
        assert!(host.try_recv().is_err());
        assert!(viewer.try_recv().is_err());
    }

    #[test]
    fn live_host_controls_edits_snapshot_recovery_and_close() {
        let mut network = NetworkState::default();
        let mut host = add_player(&mut network, HOST);
        let mut viewer = add_player(&mut network, VIEWER);
        let host_actor = ObjectId(HOST as u32);
        let viewer_actor = ObjectId(VIEWER as u32);
        let edit = valid_update();

        share(&mut network, PARTY, host_actor, HOST, 0, &board(1, 1, 1));
        assert!(host.try_recv().is_err());
        assert!(matches!(
            viewer.try_recv().unwrap(),
            FromServer::StrategyBoardShared(HOST, _)
        ));
        update(&mut network, PARTY, viewer_actor, VIEWER, &edit);
        update(
            &mut network,
            PARTY,
            host_actor,
            HOST,
            &StrategyBoardUpdate::default(),
        );
        assert!(viewer.try_recv().is_err());
        update(&mut network, PARTY, host_actor, HOST, &edit);
        assert!(matches!(
            viewer.try_recv().unwrap(),
            FromServer::StrategyBoardRealtimeUpdate(_)
        ));

        let mut joiner = add_player(&mut network, JOINER);
        member_joined(&mut network, PARTY, JOINER);
        assert!(matches!(
            joiner.try_recv().unwrap(),
            FromServer::StrategyBoardHost(HOST, 0)
        ));
        control(&mut network, PARTY, viewer_actor, VIEWER, 3);
        assert!(matches!(
            host.try_recv().unwrap(),
            FromServer::StrategyBoardSharedAck(VIEWER, 0)
        ));
        acknowledge(&mut network, PARTY, JOINER, HOST, 0);
        assert!(matches!(
            host.try_recv().unwrap(),
            FromServer::StrategyBoardSharedAck(JOINER, 0)
        ));
        update(&mut network, PARTY, host_actor, HOST, &edit);
        assert!(viewer.try_recv().is_err());
        assert!(joiner.try_recv().is_err());
        share(
            &mut network,
            PARTY,
            host_actor,
            HOST,
            JOINER,
            &board(3, 1, 1),
        );
        assert!(matches!(
            joiner.try_recv().unwrap(),
            FromServer::StrategyBoardHost(HOST, 0)
        ));
        assert!(matches!(
            joiner.try_recv().unwrap(),
            FromServer::StrategyBoardShared(HOST, _)
        ));
        control(&mut network, PARTY, viewer_actor, VIEWER, 0);
        update(&mut network, PARTY, host_actor, HOST, &edit);
        assert!(matches!(
            joiner.try_recv().unwrap(),
            FromServer::StrategyBoardRealtimeUpdate(_)
        ));
        control(&mut network, PARTY, host_actor, HOST, 0);
        for recipient in [&mut host, &mut viewer, &mut joiner] {
            assert!(matches!(
                recipient.try_recv().unwrap(),
                FromServer::StrategyBoardHost(0, 0)
            ));
        }
        share(&mut network, PARTY, host_actor, HOST, 0, &board(1, 1, 1));
        assert!(host.try_recv().is_err());
        viewer.try_recv().unwrap();
        joiner.try_recv().unwrap();
        member_departed(&mut network, PARTY, HOST, false);
        assert!(matches!(
            viewer.try_recv().unwrap(),
            FromServer::StrategyBoardHost(0, 0)
        ));
    }
}
