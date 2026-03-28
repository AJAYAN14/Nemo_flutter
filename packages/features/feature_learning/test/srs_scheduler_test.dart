import 'package:test/test.dart';
import 'package:feature_learning/src/domain/srs_scheduler.dart';
import 'package:feature_learning/src/domain/fsrs_algorithm.dart';
import 'package:core_storage/core_storage.dart';

void main() {
  final scheduler = SrsScheduler();
  const now = 1600000000000; // fixed timestamp in ms

  test('again on new item -> requeue with first relearning step', () {
    final res = scheduler.schedule(
      id: 'word_1',
      itemType: 'word',
      rating: SrsRating.again,
      currentProgress: null,
      learningSteps: [1, 10],
      relearningSteps: [5, 15],
      nowMillis: now,
    );

    expect(res is SrsRequeue, true);
    final r = res as SrsRequeue;
    final expectedDue = BigInt.from(now + 5 * 60 * 1000);
    expect(r.nextStep, 0);
    expect(r.dueTime, expectedDue);
    expect(r.companion.step.value, 0);
    expect(r.companion.dueTime.value, expectedDue);
  });

  test('good on new item -> advance to next learning step (requeue)', () {
    final res = scheduler.schedule(
      id: 'word_2',
      itemType: 'word',
      rating: SrsRating.good,
      currentProgress: null,
      learningSteps: [1, 10],
      relearningSteps: [5, 15],
      nowMillis: now,
    );

    expect(res is SrsRequeue, true);
    final r = res as SrsRequeue;
    final expectedDue = BigInt.from(now + 10 * 60 * 1000);
    expect(r.nextStep, 1);
    expect(r.dueTime, expectedDue);
    expect(r.companion.step.value, 1);
  });

  test('easy on new item -> graduate', () {
    final res = scheduler.schedule(
      id: 'word_3',
      itemType: 'word',
      rating: SrsRating.easy,
      currentProgress: null,
      learningSteps: [1, 10],
      relearningSteps: [5, 15],
      nowMillis: now,
    );

    expect(res is SrsGraduate, true);
    final g = res as SrsGraduate;
    expect(g.companion.repetitionCount.value, 1);
    expect(g.companion.step.value, 2); // learningSteps.length
    expect(g.rating, SrsRating.easy);
  });

  test('again causing leech returns SrsLeech', () {
    final progress = LearningProgressData(
      id: 'word_4',
      itemType: 'word',
      dueTime: BigInt.from(now),
      interval: 1,
      difficulty: 3.0,
      stability: 1.0,
      repetitionCount: 1,
      lastReviewed: BigInt.from(now - 1000),
      firstLearned: BigInt.from(now - 1000),
      step: 0,
      lapses: 4,
      isSuspended: false,
      isSkipped: false,
    );

    final res = scheduler.schedule(
      id: 'word_4',
      itemType: 'word',
      rating: SrsRating.again,
      currentProgress: progress,
      learningSteps: [1, 10],
      relearningSteps: [5, 15],
      leechThreshold: 5,
      nowMillis: now,
    );

    expect(res is SrsLeech, true);
    final l = res as SrsLeech;
    expect(l.totalLapses, 5);
    expect(l.companion.lapses.value, 5);
  });

  test('graduated item good uses fuzzed interval deterministically', () {
    final progress = LearningProgressData(
      id: 'word_5',
      itemType: 'word',
      dueTime: BigInt.from(now - 1000),
      interval: 10,
      difficulty: 3.5,
      stability: 5.5,
      repetitionCount: 2,
      lastReviewed: BigInt.from(now - (5 * 24 * 60 * 60 * 1000)),
      firstLearned: BigInt.from(now - (30 * 24 * 60 * 60 * 1000)),
      step: 2,
      lapses: 0,
      isSuspended: false,
      isSkipped: false,
    );

    // compute expected via FsrsAlgorithm to mirror scheduler's logic
    final alg = FsrsAlgorithm();
    final currentState = MemoryState(stability: progress.stability, difficulty: progress.difficulty);
    final elapsedDays = (now - progress.lastReviewed!.toInt()) / (24 * 60 * 60 * 1000);
    final fsrsRating = SrsRating.good.toFsrs();
    final newState = alg.step(currentState, fsrsRating, elapsedDays);
    final seed = 'word_5'.hashCode ^ now ^ SrsRating.good.index ^ progress.repetitionCount;
    final expectedInterval = alg.nextIntervalDaysWithFuzz(newState.stability, seed);
    final expectedDue = BigInt.from(now + expectedInterval * 24 * 60 * 60 * 1000);

    final res = scheduler.schedule(
      id: 'word_5',
      itemType: 'word',
      rating: SrsRating.good,
      currentProgress: progress,
      learningSteps: [1, 10],
      relearningSteps: [5, 15],
      nowMillis: now,
    );

    expect(res is SrsGraduate, true);
    final g = res as SrsGraduate;
    expect(g.companion.interval.value, expectedInterval);
    expect(g.companion.dueTime.value, expectedDue);
  });

  test('getIntervalPreviews returns expected strings for learning/new items', () {
    final previews = scheduler.getIntervalPreviews(
      currentProgress: null,
      learningSteps: [1, 10, 60],
      relearningSteps: [5, 15],
      nowMillis: now,
    );

    expect(previews[SrsRating.again], '5m');
    expect(previews[SrsRating.hard], '1m');
    expect(previews[SrsRating.good], '10m');
    // easy preview for new item should be days string
    expect(previews[SrsRating.easy]!.endsWith('d'), true);
  });
}
