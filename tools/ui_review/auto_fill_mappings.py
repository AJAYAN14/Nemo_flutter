#!/usr/bin/env python3
import re
from pathlib import Path


def camel_to_snake(name: str) -> str:
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()


def parse_suggested(path: Path):
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
        status = 'not-started'
        notes = ''
        for ln in lines[1:]:
            ln = ln.strip()
            if ln.startswith('kotlin:'):
                kotlin = ln.split(':', 1)[1].strip()
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


def parse_manual(path: Path):
    if not path.exists():
        return {}
    txt = path.read_text(encoding='utf-8')
    parts = txt.split('\n  - id: ')
    manual = {}
    if len(parts) <= 1:
        return manual
    for part in parts[1:]:
        lines = part.splitlines()
        idv = lines[0].strip()
        flutter = ''
        for ln in lines[1:]:
            ln = ln.strip()
            if ln.startswith('flutter:'):
                flutter = ln.split(':', 1)[1].strip().strip("'\"")
        if flutter:
            manual[idv] = flutter
    return manual


def score_candidate(k_tokens, dart_path: Path, snake_name: str):
    score = 0
    fname = dart_path.name.lower()
    rel = str(dart_path).lower()
    if fname == f"{snake_name}.dart":
        score += 50
    if fname.startswith(snake_name):
        score += 20
    if snake_name in fname:
        score += 10
    for t in k_tokens:
        if t in fname:
            score += 5
        if t in rel:
            score += 2
    return score


def main():
    root = Path.cwd()
    suggested = root / 'tools' / 'ui_review' / 'screen_mapping_suggested.yaml'
    manual = root / 'tools' / 'ui_review' / 'screen_mapping.yaml'
    entries = parse_suggested(suggested)
    manual_map = parse_manual(manual)

    # collect dart files under feature_learning
    dart_files = list((root / 'packages' / 'features' / 'feature_learning' / 'lib').rglob('*.dart'))
    print(f'Found {len(dart_files)} dart files to match against')

    filled = []
    for e in entries:
        eid = e['id']
        kotlin = e['kotlin']
        kotlin_stem = Path(kotlin).stem if kotlin else eid
        snake = camel_to_snake(kotlin_stem)
        # tokens: split snake by _
        tokens = [t for t in re.split('[^a-zA-Z0-9]+', snake) if t]

        # prefer manual if exists
        if eid in manual_map:
            chosen = manual_map[eid]
            source = 'manual'
        else:
            best = None
            best_score = 0
            for d in dart_files:
                s = score_candidate(tokens, d, snake)
                if s > best_score:
                    best_score = s
                    best = d
            if best and best_score > 0:
                chosen = str(best).replace('\\\\', '/').replace('\\', '/')
                source = f'auto({best_score})'
            else:
                chosen = ''
                source = 'none'

        e['flutter'] = chosen
        e['status'] = 'auto-filled' if e.get('flutter') else 'not-found'
        e['notes'] = e.get('notes', '') + (f" (matched:{source})" if source != 'none' else '')
        filled.append(e)

    # write out mapped file
    out = root / 'tools' / 'ui_review' / 'screen_mapping_auto_filled.yaml'
    with out.open('w', encoding='utf-8') as f:
        f.write('# 自动匹配后生成的映射（请人工校验）\n')
        f.write('screens:\n')
        for e in filled:
            f.write(f"  - id: {e['id']}\n")
            f.write(f"    kotlin: {e['kotlin']}\n")
            f.write(f"    flutter: '{e['flutter']}'\n")
            f.write(f"    status: {e['status']}\n")
            f.write(f"    notes: '{e['notes']}'\n\n")

    # also update the main mapping file (overwrite)
    target = root / 'tools' / 'ui_review' / 'screen_mapping.yaml'
    with target.open('w', encoding='utf-8') as f:
        f.write('# Kotlin -> Flutter 屏幕映射（自动填充，需人工验证）\n')
        f.write('screens:\n')
        for e in filled:
            f.write(f"  - id: {e['id']}\n")
            f.write(f"    kotlin: {e['kotlin']}\n")
            f.write(f"    flutter: '{e['flutter']}'\n")
            f.write(f"    status: {e['status']}\n")
            f.write(f"    notes: '{e['notes']}'\n\n")

    print('Wrote', out, 'and updated', target)


if __name__ == '__main__':
    main()
