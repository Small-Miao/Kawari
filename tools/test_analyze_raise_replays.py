"""复活证据解析回归：匿名帧夹具使用已核对的录像字段。"""
import struct
import unittest

from analyze_raise_replays import parse_bytes, PROFILES

SOURCE, TARGET = 0x10000001, 0x10000002


def frame(opcode, ms, actor, body):
    return struct.pack('<HHII', opcode, len(body), ms, actor) + body


def replay(frames, build=14251465):
    header = bytearray(876)
    header[:11] = b'FFXIVREPLAY'
    struct.pack_into('<H', header, 12, 5)
    struct.pack_into('<I', header, 16, build)
    payload = b''.join(frames)
    struct.pack_into('<I', header, 72, len(payload))
    return bytes(header) + payload


def effect(action=4570, action_type=2, spell=43336, offer=True):
    body = bytearray(124)
    struct.pack_into('<I', body, 8, action)
    struct.pack_into('<H', body, 28, spell)
    body[31], body[33] = action_type, 1
    if offer:
        body[42:50] = bytes.fromhex('0e00140800009400')
    struct.pack_into('<I', body, 112, TARGET)
    return body


def control(category, arg1, arg2):
    body = bytearray(32)
    struct.pack_into('<H', body, 0, category)
    struct.pack_into('<II', body, 4, arg1, arg2)
    return body


def statuses(double=False):
    body = bytearray(744 if double else 384)
    struct.pack_into('<IIHH', body, 364 if double else 4, 6724, 33621, 2000, 10000)
    struct.pack_into('<HHfI', body, 0 if double else 20, 43, 0, 100, 0xe0000000)
    struct.pack_into('<HHfI', body, 380 if double else 32, 418, 0, 5, 0xe0000000)
    return body


class RaiseReplayTests(unittest.TestCase):
    def test_current_first_person_item_full_trace(self):
        cast = bytearray.fromhex('48a90200da11000000000041356d021055a50000000000e00f16598096a30000')
        struct.pack_into('<I', cast, 12, TARGET)
        data = replay([
            frame(352, 25158, SOURCE, cast),
            frame(400, 32660, SOURCE, effect()),
            frame(688, 34945, TARGET, bytes.fromhex('00000000aa03b5000000050203020000')),
            frame(934, 36388, TARGET, bytes.fromhex('ff7f050200000000d98e4fc4ada9364052088a4300000000')),
            frame(169, 36779, TARGET, control(200, 1, 1)),
            frame(349, 39762, TARGET, statuses()),
            frame(688, 41808, TARGET, bytes.fromhex('000000000000000000000d01010b0000')),
            frame(349, 41809, TARGET, statuses()),
        ])
        result = parse_bytes(data, '匿名样本.dat')
        raise_event, = result['raises']
        self.assertTrue(raise_event['first_person'])
        self.assertEqual((raise_event['action_kind'], raise_event['action'], raise_event['spell']), ('item', 4570, 43336))
        self.assertEqual(raise_event['cast']['seconds'], 8)
        trace = raise_event['trace']
        self.assertEqual([e['kind'] for e in trace], ['prepare_zoning', 'position', 'control', 'statuses', 'trace_end'])
        self.assertEqual(trace[1]['after_ms'] - trace[0]['after_ms'], 1443)
        self.assertEqual(trace[3]['after_ms'] - trace[2]['after_ms'], 2983)
        self.assertEqual(trace[3]['hp'], trace[3]['max_hp'] // 5)
        self.assertEqual(trace[3]['mp'], 2000)
        self.assertEqual(trace[3]['statuses'], [
            dict(id=43, param=0, seconds=100, source=None),
            dict(id=418, param=0, seconds=5, source=None),
        ])
        self.assertNotIn(str(SOURCE), str(result))
        self.assertNotIn(str(TARGET), str(result))

    def test_both_builds_and_both_status_layouts(self):
        for build, p in PROFILES.items():
            for double in (False, True):
                with self.subTest(build=build, double=double):
                    result = parse_bytes(replay([
                        frame(next(iter(p['effects'])), 0, SOURCE, effect(125, 1, 125)),
                        frame(p['self_control'], 100, TARGET, control(200, 1, 1)),
                        frame(p['player_double'] if double else p['statuses'], 3100, TARGET, statuses(double)),
                    ], build), '匿名样本.dat')
                    event, = result['raises']
                    self.assertEqual(event['action_kind'], 'skill')
                    self.assertEqual(event['trace'][-1]['hp'], 6724)
                    self.assertEqual([s['id'] for s in event['trace'][-1]['statuses']], [43, 418])

    def test_item_id_matching_spell_is_not_a_raise_without_offer(self):
        result = parse_bytes(replay([frame(400, 0, SOURCE, effect(125, 2, 125, False))]), '匿名样本.dat')
        self.assertEqual(result['raises'], [])

    def test_missing_or_ambiguous_perspective_not_claimed_as_first_person(self):
        for controls in ([], [frame(169, 10, SOURCE, control(200, 1, 1)),
                              frame(169, 10, TARGET, control(200, 1, 1))]):
            result = parse_bytes(replay([frame(400, 0, SOURCE, effect())] + controls), '匿名样本.dat')
            self.assertFalse(result['raises'][0]['first_person'])

    def test_unknown_build_rejected(self):
        with self.assertRaisesRegex(ValueError, '未核对'):
            parse_bytes(replay([], 123), '匿名样本.dat')

    def test_short_effect_and_invalid_target_count_rejected(self):
        bad_count = effect()
        bad_count[33] = 2
        for body in (b'\x00', bad_count):
            with self.assertRaisesRegex(ValueError, '技能效果'):
                parse_bytes(replay([frame(400, 0, SOURCE, body)]), '匿名样本.dat')

    def test_truncated_record_rejected(self):
        bad = bytearray(replay([frame(400, 0, SOURCE, effect())]))
        struct.pack_into('<H', bad, 878, 125)
        with self.assertRaisesRegex(ValueError, '截断'):
            parse_bytes(bytes(bad), '匿名样本.dat')

    def test_short_status_rejected(self):
        with self.assertRaisesRegex(ValueError, '状态包长度'):
            parse_bytes(replay([frame(400, 0, SOURCE, effect()),
                                frame(349, 1, TARGET, b'\x00')]), '匿名样本.dat')


if __name__ == '__main__':
    unittest.main()
