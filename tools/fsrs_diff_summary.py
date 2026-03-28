import json

def main():
    path = r"E:\Nemo\fsrs_diff_report.json"
    with open(path, 'r', encoding='utf-8') as f:
        j = json.load(f)
    total = len(j['report'])
    diffs = [i for i in j['report'] if i['status'] == 'different']
    diff_count = len(diffs)
    maxdiff = 0.0
    maxinfo = None
    for i in diffs:
        for d in i['diffs']:
            if d['abs_diff'] > maxdiff:
                maxdiff = d['abs_diff']
                maxinfo = (i['id'], d['rating'], d['field'], d['kotlin'], d['dart'])
    print(f"total={total}, diff_count={diff_count}")
    print(f"max_abs_diff={maxdiff}")
    print(f"max_info={maxinfo}")

if __name__ == '__main__':
    main()
