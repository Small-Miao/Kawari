"""边界、匿名化与第一人称归属；不依赖个人录像文件。"""
import json
import struct
import unittest
import analyze_job_replays as audit


def replay(*records, build=14251465):
    header=bytearray(876)
    header[:11]=b'FFXIVREPLAY'
    struct.pack_into('<H',header,12,5)
    struct.pack_into('<I',header,16,build)
    body=b''.join(struct.pack('<HHII',op,len(payload),100,actor)+payload for op,actor,payload in records)
    struct.pack_into('<I',header,72,len(body))
    return bytes(header)+body


class ReplayTests(unittest.TestCase):
    def test_loose_replay_requires_performers_own_unique_gauge(self):
        rows=[dict(kind='action',actor='P2',action=24373),dict(kind='gauge',actor='P1',job=40)]
        with self.assertRaises(ValueError): audit.infer_job(rows)
        rows.append(dict(kind='gauge',actor='P2',job=39))
        self.assertEqual(audit.infer_job(rows),'RPR')
        rows.append(dict(kind='gauge',actor='P2',job=34))
        with self.assertRaises(ValueError): audit.infer_job(rows)

    def test_unknown_build_and_wrong_declared_length_fail_closed(self):
        for raw in [replay(build=14251466),replay()+b'extra',b'FFXIVREPLAY']:
            with self.assertRaises(ValueError): audit.parse(raw,'synthetic')

    def test_truncated_known_records_report_invalid_input(self):
        for op,size in [(803,9),(352,11),(219,7),(169,3),(735,5),(349,379),(374,655),(400,119)]:
            with self.subTest(op=op),self.assertRaises(ValueError): audit.parse(replay((op,0x10000001,bytes(size))),'synthetic')

    def test_target_count_cannot_exceed_packet_capacity(self):
        payload=bytearray(120);payload[33]=2
        with self.assertRaises(ValueError): audit.parse(replay((400,0x10000001,payload)),'synthetic')

    def test_anonymized_action_preserves_ids_and_flags_not_player_identity(self):
        payload=bytearray(120);struct.pack_into('<I',payload,8,185);payload[33]=1
        struct.pack_into('<8B',payload,42,4,0,32,0,0,0,100,0)
        struct.pack_into('<I',payload,112,0x10000002)
        result=audit.parse(replay((400,0x10000001,payload)),'synthetic')
        record=result['records'][0]
        self.assertEqual(record['action'],185);self.assertEqual(record['actor'],'P1')
        self.assertEqual(record['targets'][0]['actor'],'P2');self.assertEqual(record['targets'][0]['effects'][0]['params'][1],32)
        self.assertNotIn(str(0x10000001),json.dumps(result))

    def test_observer_gauge_does_not_prove_performer_first_person(self):
        records=[dict(kind='action',actor='P2',action=7402),dict(kind='gauge',actor='P1',job=40)]
        self.assertFalse(audit.perspective(records,'SAM')['first_person_evidence'])
        records.append(dict(kind='gauge',actor='P1',job=34))
        self.assertFalse(audit.perspective(records,'SAM')['first_person_evidence'])
        records.append(dict(kind='gauge',actor='P2',job=34))
        self.assertTrue(audit.perspective(records,'SAM')['first_person_evidence'])


if __name__=='__main__': unittest.main()
