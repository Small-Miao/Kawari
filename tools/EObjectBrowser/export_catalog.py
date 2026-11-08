"""从本地国服 CSV 生成 EObj 目录；不复制游戏模型、贴图或特效。"""
import argparse
import csv
import json
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("csv_directory", type=Path)
parser.add_argument("output", type=Path)
args = parser.parse_args()

def rows(name):
    with (args.csv_directory / f"{name}.csv").open(encoding="utf-8-sig", newline="") as f:
        reader = csv.reader(f)
        next(reader); next(reader)
        types = next(reader)
        return types, list(reader)

_, names = rows("EObjName")
names = {int(r[0]): r[1] for r in names if r and r[0].isdigit()}
_, scenes = rows("ExportedSG")
scenes = {int(r[0]): r[1] for r in scenes if r and r[0].isdigit()}
types, objects = rows("EObj")
column = types.index("ExportedSG")
records = [{"id": int(r[0]), "name": names.get(int(r[0]), ""), "scene_id": int(r[column]), "path": scenes.get(int(r[column]), "")} for r in objects if r and r[0].isdigit()]
args.output.parent.mkdir(parents=True, exist_ok=True)
args.output.write_text(json.dumps({"schema": 1, "source": "国服 CSV 快照 2026-11-08", "objects": records}, ensure_ascii=False), encoding="utf-8")
print(f"{len(records)} EObj，{sum(bool(r['path']) for r in records)} 项有 SGB；输出 {args.output}")
