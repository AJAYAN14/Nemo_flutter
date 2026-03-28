#!/usr/bin/env python3
"""
收集 Kotlin 学习模块 presentation 屏幕并生成映射草案（YAML 格式）。

用法：
  python tools/ui_review/collect_kotlin_screens.py

输出：tools/ui_review/screen_mapping_suggested.yaml
"""
from pathlib import Path

root = Path("old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation")
out = Path("tools/ui_review/screen_mapping_suggested.yaml")

screens = []
if not root.exists():
    print("Kotlin presentation 目录不存在:", root)
else:
    for p in sorted(root.rglob("*.kt")):
        rel = p.as_posix()
        screens.append(rel)

with out.open("w", encoding="utf-8") as f:
    f.write("# 自动生成的 Kotlin 屏幕映射草案，请补充 flutter 路径和备注\n")
    f.write("screens:\n")
    for s in screens:
        idname = Path(s).stem.replace('.','_').lower()
        f.write(f"  - id: {idname}\n")
        f.write(f"    kotlin: {s}\n")
        f.write("    flutter: ''\n")
        f.write("    status: not-started\n")
        f.write("    notes: ''\n\n")

print("建议已写入:", out)
