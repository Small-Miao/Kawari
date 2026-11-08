"""只读 FFXIVREPLAY v5，提取录制器保存的开局 RSV / RSF，不导出身份数据。"""
import argparse
import hashlib
import json
from pathlib import Path
import struct


def extract(path):
    raw = path.read_bytes()
    if raw[:11] != b'FFXIVREPLAY' or struct.unpack_from('<H', raw, 12)[0] != 5:
        raise ValueError('需要 FFXIVREPLAY v5')
    if struct.unpack_from('<I', raw, 72)[0] + 876 != len(raw):
        raise ValueError('录像长度不匹配')
    packets = []
    off = 876
    while off < len(raw):
        op, size, ms, _ = struct.unpack_from('<HHII', raw, off)
        payload = raw[off + 12:off + 12 + size]
        if len(payload) != size:
            raise ValueError('录像被截断')
        off += 12 + size
        if op not in (0xF001, 0xF002):
            continue
        if ms != 0:
            raise ValueError('发现非开局资源更新，需要单独编排时序')
        if op == 0xF001:
            length = struct.unpack_from('<I', payload)[0]
            assert size == 52 + length and length <= 4096
            key = payload[4:52].split(b'\0', 1)[0]
            assert key.startswith(b'_rsv_') and len(key) < 48
            assert payload[4 + len(key):52] == bytes(48 - len(key))
            packets.append(dict(kind='rsv', key=key.decode('ascii'), value=payload[52:].decode('utf-8')))
        else:
            assert size == 72
            packets.append(dict(kind='rsf', key=f'{struct.unpack_from("<Q",payload)[0]:016x}', value=payload[8:].hex()))
    return dict(schema=1, source_sha256=hashlib.sha256(raw).hexdigest(), packets=packets)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('recording', type=Path)
    parser.add_argument('output', type=Path)
    args = parser.parse_args()
    data = extract(args.recording)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print({kind: sum(p['kind'] == kind for p in data['packets']) for kind in ('rsv', 'rsf')})
