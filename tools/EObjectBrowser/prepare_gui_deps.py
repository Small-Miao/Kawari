"""校验锁定的 GUI 源码归档，仅在本项目缓存中展开；不修改全局 Cargo 缓存。"""
import hashlib
import io
import json
import os
from pathlib import Path, PurePosixPath
import tarfile
import urllib.request

ROOT = Path(__file__).resolve().parent / "Engine/deps"
PACKAGES = {
    "eframe": "8dc8234e2f681b2afd2b2e8c332fa614de2fddbdcb28d0acf5c420449682ea90",
    "egui_glow": "52274b9bfb8d8e252cd0f00c9f6214f360d75a0962baa77a2d62ddb002fe99d4",
}
VERSION = "0.35.0"

def prepare(name, checksum):
    target = ROOT / f"eobject-{name}"
    marker = target / ".eobject-source.json"
    expected = {"name": name, "version": VERSION, "sha256": checksum}
    if target.exists():
        if not marker.exists() or json.loads(marker.read_text(encoding="utf-8")) != expected:
            raise RuntimeError(f"已有缓存来源不符，不会覆盖：{target}")
        return
    cargo_home = Path(os.environ.get("CARGO_HOME", Path.home() / ".cargo"))
    archives = list((cargo_home / "registry/cache").glob(f"*/{name}-{VERSION}.crate"))
    if archives:
        data = archives[0].read_bytes()
    else:
        with urllib.request.urlopen(f"https://static.crates.io/crates/{name}/{name}-{VERSION}.crate", timeout=60) as response:
            data = response.read()
    if hashlib.sha256(data).hexdigest() != checksum:
        raise RuntimeError(f"源码归档校验失败：{name}")
    files = []
    with tarfile.open(fileobj=io.BytesIO(data), mode="r:gz") as archive:
        for member in archive.getmembers():
            path = PurePosixPath(member.name)
            if "\\" in member.name or ":" in member.name or path.is_absolute() or ".." in path.parts or path.parts[0] != f"{name}-{VERSION}":
                raise RuntimeError("归档包含非法路径")
            if member.isdir():
                continue
            if not member.isfile():
                raise RuntimeError("归档包含不支持的链接或特殊文件")
            files.append((target.joinpath(*path.parts[1:]), archive.extractfile(member).read()))
    for path, content in files:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(content)
    marker.write_text(json.dumps(expected, indent=2), encoding="utf-8")

if __name__ == "__main__":
    for name, checksum in PACKAGES.items():
        prepare(name, checksum)
    print("GUI source archives verified")
