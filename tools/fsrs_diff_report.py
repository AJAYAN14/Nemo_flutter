#!/usr/bin/env python3
import json
import sys
import struct

def load(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def main():
    kotlin_path = r"E:\Nemo\fsrs_kotlin_outputs.json"
    dart_path = r"E:\Nemo\fsrs_dart_outputs.json"
    kotlin = load(kotlin_path)
    dart = load(dart_path)

    kmap = {e['id']: e for e in kotlin}
    dmap = {e['id']: e for e in dart}

    ids = sorted(set(list(kmap.keys()) + list(dmap.keys())))

    report = []
    all_equal = True
    # Compare values after casting to 32-bit float to mirror Kotlin `Float` semantics
    def f32(x):
        return struct.unpack('f', struct.pack('f', float(x)))[0]
    eps = 0.0

    for idv in ids:
        ek = kmap.get(idv)
        ed = dmap.get(idv)
        if ek is None:
            report.append({'id': idv, 'status': 'missing_in_kotlin'})
            all_equal = False
            continue
        if ed is None:
            report.append({'id': idv, 'status': 'missing_in_dart'})
            all_equal = False
            continue

        diffs = []
        for rating in ['again','hard','good','easy']:
            ks = ek['nextStates'][rating]
            ds = ed['nextStates'][rating]
            for field in ['stability','difficulty','interval']:
                kv = float(ks[field])
                dv = float(ds[field])
                kv32 = f32(kv)
                dv32 = f32(dv)
                diff = abs(kv32 - dv32)
                if diff > eps:
                    diffs.append({'rating': rating, 'field': field, 'kotlin': kv, 'dart': dv, 'abs_diff': diff})

        if diffs:
            report.append({'id': idv, 'status': 'different', 'diffs': diffs})
            all_equal = False
        else:
            report.append({'id': idv, 'status': 'equal'})

    out_json = {'all_equal': all_equal, 'report': report}
    with open(r"E:\Nemo\fsrs_diff_report.json", 'w', encoding='utf-8') as f:
        json.dump(out_json, f, ensure_ascii=False, indent=2)

    with open(r"E:\Nemo\fsrs_diff_report.txt", 'w', encoding='utf-8') as f:
        for item in report:
            if item['status'] == 'equal':
                f.write(f"{item['id']}: equal\n")
            elif item['status'] == 'different':
                f.write(f"{item['id']}: DIFFERENCES\n")
                for d in item['diffs']:
                    f.write(f"  {d['rating']}.{d['field']}: kotlin={d['kotlin']}, dart={d['dart']}, diff={d['abs_diff']}\n")
            else:
                f.write(f"{item['id']}: {item['status']}\n")

    print('Wrote E:\\Nemo\\fsrs_diff_report.json and .txt')
    if not all_equal:
        print('Differences found')
        sys.exit(2)
    print('No differences')
    sys.exit(0)

if __name__ == '__main__':
    main()
