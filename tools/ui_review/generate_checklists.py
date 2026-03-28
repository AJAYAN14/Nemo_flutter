#!/usr/bin/env python3
"""
Generate per-screen UI checklist markdown files from screen_mapping.yaml.

Usage:
  python tools/ui_review/generate_checklists.py

Outputs:
  tools/ui_review/checklists/<id>.md
"""
from pathlib import Path


def parse_mapping(path: Path):
    txt = path.read_text(encoding='utf-8')
    parts = txt.split('\n  - id: ')
    entries = []
    if len(parts) <= 1:
        return entries
    for part in parts[1:]:
        lines = part.splitlines()
        idv = lines[0].strip()
        kotlin = ''
        flutter = ''
        status = ''
        notes = ''
        for ln in lines[1:]:
            ln = ln.strip()
            if ln.startswith('kotlin:'):
                kotlin = ln.split(':', 1)[1].strip().strip("'\"")
            elif ln.startswith('flutter:'):
                flutter = ln.split(':', 1)[1].strip().strip("'\"")
            elif ln.startswith('status:'):
                status = ln.split(':', 1)[1].strip()
            elif ln.startswith('notes:'):
                notes = ln.split(':', 1)[1].strip().strip("'\"")
        entries.append({
            'id': idv,
            'kotlin': kotlin,
            'flutter': flutter,
            'status': status,
            'notes': notes,
        })
    return entries


def render_checklist(entry: dict) -> str:
    idv = entry['id']
    kotlin = entry.get('kotlin', '')
    flutter = entry.get('flutter', '')
    notes = entry.get('notes', '')

    title = f"# UI 核对清单: {idv}\n\n"
    mapping = f"- Kotlin: {kotlin}\n- Flutter: {flutter}\n- Notes: {notes}\n\n"
    screenshots = (
        "- Kotlin screenshot: tools/ui_review/kotlin_baseline/<file>.png\n"
        "- Flutter screenshot: tools/ui_review/flutter_shots/<file>.png\n\n"
    )

    checks = (
        "## Checks\n\n"
        "- [ ] Pixel & Layout: 间距、外边距、卡片宽高、对齐 — Notes:\n"
        "- [ ] Typography: 字号/字重/行距 — Notes:\n"
        "- [ ] Colors & Iconography: 主题色、图标尺寸与位置 — Notes:\n"
        "- [ ] Copy & Labels: 页面标题、按钮文案、统计文本（列出 Kotlin 原文与 Flutter 文案） — Notes:\n"
        "- [ ] Accessibility: semanticsLabel、hint、可聚焦次序 — Notes:\n"
        "- [ ] Animations / Transitions: 关键帧、时长、缓动 — Notes:\n"
        "- [ ] Gestures / Controls: 滑动/点击/长按 行为与响应阈值 — Notes:\n"
        "- [ ] Dynamic Content: 数字/占位/空态 表现 — Notes:\n"
        "- [ ] Navigation & Actions: 返回、开始复习、跳转行为是否一致 — Notes:\n"
        "- [ ] Overall Verdict: Pass / Fail — Severity (Major/Minor/Info) — Notes:\n\n"
    )

    gh_issue = (
        "Suggested GitHub issue title:\n"
        f"`UI: Review {idv} — Kotlin vs Flutter`\n\n"
        "Suggested issue body: 请把本文件内容复制到新 issue，用作逐屏核对记录。\n"
    )

    return title + mapping + screenshots + checks + gh_issue


def main():
    root = Path.cwd()
    mapping_file = root / 'tools' / 'ui_review' / 'screen_mapping.yaml'
    if not mapping_file.exists():
        print('screen_mapping.yaml not found at', mapping_file)
        return

    entries = parse_mapping(mapping_file)
    out_dir = root / 'tools' / 'ui_review' / 'checklists'
    out_dir.mkdir(parents=True, exist_ok=True)

    for e in entries:
        fid = e['id']
        fname = out_dir / f"{fid}.md"
        content = render_checklist(e)
        fname.write_text(content, encoding='utf-8')
        print('Wrote', fname)

    print('Generated', len(entries), 'checklists under', out_dir)


if __name__ == '__main__':
    main()
