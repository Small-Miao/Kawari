"""按已核对的国服构建提取匿名复活证据，区分技能和道具动作。"""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import struct

PROFILES = {
    14101351: dict(effects={189: 1, 319: 8, 912: 16, 158: 24, 630: 32},
                   control=408, self_control=486, prepare=304, position=992,
                   statuses=718, player_double=923, cast=769, move=None),
    14251465: dict(effects={400: 1, 563: 8, 281: 16, 924: 24, 221: 32},
                   control=735, self_control=169, prepare=688, position=934,
                   statuses=349, player_double=760, cast=352, move=174),
}
RAISES = {125, 173, 3603, 7523, 24287}
RAISE_STATUSES = {43, 44, 148, 418}


def packed_position(body, offset):
    return [round(v / 65535 * 2000 - 1000, 4)
            for v in struct.unpack_from('<HHH', body, offset)]


def parse_bytes(raw, source):
    if (len(raw) < 876 or raw[:11] != b'FFXIVREPLAY'
            or struct.unpack_from('<H', raw, 12)[0] != 5
            or struct.unpack_from('<I', raw, 72)[0] + 876 != len(raw)):
        raise ValueError('只接受完整的 v5 录像')
    build = struct.unpack_from('<I', raw, 16)[0]
    if build not in PROFILES:
        raise ValueError(f'未核对的构建 {build}，不能套用其他版本 opcode')
    profile = PROFILES[build]
    rows = []
    offset = 876
    while offset < len(raw):
        if offset + 12 > len(raw):
            raise ValueError('记录头截断')
        op, size, ms, actor = struct.unpack_from('<HHII', raw, offset)
        if offset + 12 + size > len(raw):
            raise ValueError('记录内容截断')
        rows.append((op, ms, actor, raw[offset + 12:offset + 12 + size]))
        offset += 12 + size
    candidates = Counter(a for op, _, a, _ in rows if op == profile['self_control']).most_common(2)
    # 没有本人控制包，或计数并列时不擅自标记第一人称。
    own = candidates[0][0] if candidates and (len(candidates) == 1 or candidates[0][1] > candidates[1][1]) else None
    aliases = {}

    def alias(actor):
        if actor in (0, 0xe0000000):
            return None
        if actor not in aliases:
            aliases[actor] = f'演员{len(aliases) + 1}'
        return aliases[actor]

    def status_list(data, double):
        expected = 744 if double else 384
        if len(data) != expected:
            raise ValueError('状态包长度不符')
        offsets = list(range(0, 360, 12)) + list(range(380, 740, 12)) if double else range(20, 380, 12)
        statuses = []
        for pos in offsets:
            sid, param, seconds, sender = struct.unpack_from('<HHfI', data, pos)
            if sid in RAISE_STATUSES:
                statuses.append(dict(id=sid, param=param, seconds=round(seconds, 3), source=alias(sender)))
        hp, maximum, mp, max_mp = struct.unpack_from('<IIHH', data, 364 if double else 4)
        return dict(kind='statuses', hp=hp, max_hp=maximum, mp=mp, max_mp=max_mp, statuses=statuses)

    raises = []
    casts = {}
    positions = {}
    for row_index, (op, ms, sender, body) in enumerate(rows):
        if op == profile['cast']:
            if len(body) != 32:
                raise ValueError('读条包长度不符')
            action, seconds, target = struct.unpack_from('<IfI', body, 4)
            position = packed_position(body, 24)
            casts[(sender, body[2], action, target)] = dict(ms=ms, seconds=round(seconds, 3), spell=struct.unpack_from('<H', body)[0], position=position)
            positions[sender] = dict(ms=ms, kind='cast', position=position)
        elif op == profile['move']:
            if len(body) != 16:
                raise ValueError('移动包长度不符')
            positions[sender] = dict(ms=ms, kind='move', position=packed_position(body, 6))
        if op not in profile['effects']:
            continue
        cap = profile['effects'][op]
        if len(body) < 48 + cap * 72 or body[33] > cap:
            raise ValueError('技能效果包长度或目标数不符')
        action = struct.unpack_from('<I', body, 8)[0]
        action_type = body[31]
        for index in range(body[33]):
            target = struct.unpack_from('<I', body, 48 + cap * 64 + index * 8)[0]
            effects = [body[42 + index * 64 + j * 8:50 + index * 64 + j * 8]
                       for j in range(8) if body[42 + index * 64 + j * 8]]
            has_offer = any(e[0] == 14 and struct.unpack_from('<H', e, 6)[0] == 148 for e in effects)
            if not has_offer and not (action_type == 1 and action in RAISES):
                continue
            trace = []
            for packet, time, actor, data in rows[row_index:]:
                if actor != target or not ms <= time <= ms + 15000:
                    continue
                entry = {'after_ms': time - ms}
                if packet in (profile['control'], profile['self_control']):
                    if len(data) < 12:
                        raise ValueError('控制包长度不符')
                    if struct.unpack_from('<H', data)[0] not in (2, 200, 212):
                        continue
                    entry.update(kind='control', category=struct.unpack_from('<H', data)[0],
                                 args=list(struct.unpack_from('<II', data, 4)))
                elif packet == profile['prepare'] and actor == own:
                    if len(data) != 16:
                        raise ValueError('迁移准备包长度不符')
                    if data[10] != 5:
                        trace.append(dict(after_ms=time - ms, kind='trace_end', reason='other_zoning', warp=data[10]))
                        break  # 离开副本后的状态清理不属于复活。
                    entry.update(kind='prepare_zoning', payload=data.hex())
                elif packet == profile['position']:
                    if len(data) != 24:
                        raise ValueError('定位包长度不符')
                    entry.update(kind='position', warp=data[2], argument=data[3],
                                 position=[round(v, 4) for v in struct.unpack_from('<fff', data, 8)])
                elif packet == profile['statuses']:
                    entry.update(status_list(data, False))
                elif packet == profile['player_double'] and actor == own:
                    entry.update(status_list(data, True))
                else:
                    continue
                trace.append(entry)
            cast = casts.get((sender, action_type, action, target))
            if cast and not 0 <= ms - cast['ms'] <= 30000:
                cast = None
            raises.append(dict(ms=ms, action=action, action_type=action_type,
                               action_kind={1: 'skill', 2: 'item'}.get(action_type, 'other'),
                               spell=struct.unpack_from('<H', body, 28)[0],
                               source=alias(sender), target=alias(target), first_person=target == own,
                               cast=cast, source_position=positions.get(sender),
                               effects=[e.hex() for e in effects], trace=trace))
    return dict(source=source, sha256=hashlib.sha256(raw).hexdigest(), build=build, raises=raises)


def parse(path):
    return parse_bytes(path.read_bytes(), path.name)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('inputs', nargs='+', type=Path)
    parser.add_argument('--out', required=True, type=Path)
    args = parser.parse_args()
    result = [parse(path) for path in args.inputs]
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({'files': len(result), 'raises': sum(len(r['raises']) for r in result),
                      'first_person': sum(e['first_person'] for r in result for e in r['raises'])}))
