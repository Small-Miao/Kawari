"""从已下载的 Windows 构建依赖中收集许可证；不下载或更改依赖。"""
import json
import re
import shutil
import subprocess
from pathlib import Path

base = Path(__file__).resolve().parent
engine = base / "Engine"
tree = subprocess.check_output([
    "cargo", "tree", "--manifest-path", str(engine / "Cargo.toml"), "-p", "viewer",
    "--target", "x86_64-pc-windows-msvc", "-e", "normal,build", "--prefix", "none", "--format", "{p}", "--offline"
], text=True)
registry = Path.home() / ".cargo/registry/src"
output = base / "Licenses"
output.mkdir(exist_ok=True)
packages = sorted(set(re.findall(r"^([\w-]+) v([^\s]+)", tree, re.M)))
records = []
for name, version in packages:
    candidates = list(registry.glob(f"*/{name}-{version}"))
    if not candidates:
        continue
    folder = candidates[0]
    manifest = (folder / "Cargo.toml").read_text(encoding="utf-8")
    license_id = re.search(r'^license\s*=\s*"([^"]+)"', manifest, re.M)
    package_out = output / f"{name}-{version}"
    files = []
    for file in folder.iterdir():
        if file.is_file() and file.name.upper().startswith(("LICENSE", "LICENCE", "COPYING", "NOTICE", "UNLICENSE")):
            package_out.mkdir(exist_ok=True)
            shutil.copyfile(file, package_out / file.name)
            files.append(file.name)
    records.append({"name": name, "version": version, "license": license_id[1] if license_id else None, "files": files})
for submodule in [engine, engine / "deps/ironworks", engine / "deps/d3dasm"]:
    package_out = output / submodule.name
    package_out.mkdir(exist_ok=True)
    for file in submodule.iterdir():
        if file.is_file() and file.name.upper().startswith(("LICENSE", "COPYING", "NOTICE")):
            shutil.copyfile(file, package_out / file.name)
(output / "index.json").write_text(json.dumps(records, ensure_ascii=False, indent=2), encoding="utf-8")
print(f"已收集 {len(records)} 项 Windows 依赖的许可证信息")
