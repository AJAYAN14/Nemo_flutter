import 'package:test/test.dart';
import 'package:feature_learning/src/domain/learning_queue_manager.dart';

void main() {
  final mgr = const LearningQueueManager();

  test('empty list returns Empty', () {
    final res = mgr.selectNextItem<int>([], (i) => 0, 0, 1000);
    expect(res is QueueEmpty, true);
  });

  test('selects earliest due', () {
    final items = ['a', 'b', 'c'];
    final due = [2000, 1000, 3000];
    final res = mgr.selectNextItem<String>(items, (s) => due[items.indexOf(s)], 1500, 1000);
    expect(res is QueueNext, true);
    final next = res as QueueNext<String>;
    expect(next.index, 1);
    expect(next.item, 'b');
  });

  test('tie-breaker prefers preferredIndex when appropriate', () {
    final items = ['a', 'b', 'c', 'd'];
    final due = [1000, 2000, 1000, 3000];
    // preferredIndex = 2 should prefer index 2 over index 0 when tie
    final res = mgr.selectNextItem<String>(items, (s) => due[items.indexOf(s)], 500, 1000, preferredIndex: 2);
    expect(res is QueueNext, true);
    final next = res as QueueNext<String>;
    expect(next.index, 2);
    expect(next.item, 'c');
  });

  test('wait vs learn-ahead behavior', () {
    final items = ['a'];
    final due = [2000];
    final now = 1000;
    // learnAheadLimitMs = 500 -> wait (waitTime 1000 > 500)
    final r1 = mgr.selectNextItem<String>(items, (s) => due[items.indexOf(s)], now, 500);
    expect(r1 is QueueWait, true);
    final w = r1 as QueueWait<String>;
    expect(w.waitingUntil, 2000);

    // learnAheadLimitMs = 1000 -> allow learn ahead (waitTime == limit)
    final r2 = mgr.selectNextItem<String>(items, (s) => due[items.indexOf(s)], now, 1000);
    expect(r2 is QueueNext, true);
  });
}
