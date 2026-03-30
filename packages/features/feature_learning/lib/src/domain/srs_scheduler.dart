import 'package:drift/drift.dart';
import 'package:core_storage/core_storage.dart';
import 'package:core_domain/core_domain.dart';
import 'fsrs_algorithm.dart';

enum SrsRating {
  again, // 0
  hard, // 1
  good, // 2
  easy; // 3

  static SrsRating fromInt(int value) {
    return SrsRating.values[value.clamp(0, 3)];
  }

  FsrsRating toFsrs() {
    return FsrsRating.values[index];
  }
}

sealed class SrsScheduleResult {
  const SrsScheduleResult();
}

class SrsRequeue extends SrsScheduleResult {
  final LearningProgressCompanion companion;
  final int nextStep;
  final BigInt dueTime;

  const SrsRequeue({
    required this.companion,
    required this.nextStep,
    required this.dueTime,
  });
}

class SrsLeech extends SrsScheduleResult {
  final LearningProgressCompanion companion;
  final int totalLapses;

  const SrsLeech({required this.companion, required this.totalLapses});
}

class SrsGraduate extends SrsScheduleResult {
  final LearningProgressCompanion companion;
  final SrsRating rating;

  const SrsGraduate({required this.companion, required this.rating});
}

/// A wrapper used by Repository to provide the actual Data object to the UI
class SrsFinalResult {
  final LearningProgressData updatedProgress;
  final bool isRequeue;
  final bool isLeech;

  const SrsFinalResult({
    required this.updatedProgress,
    required this.isRequeue,
    this.isLeech = false,
  });
}

class SrsScheduler {
  final FsrsAlgorithm _fsrs;

  /// Accepts optional optimized parameters — matches Kotlin SrsCalculatorImpl
  /// which loads personalized parameters asynchronously at startup.
  SrsScheduler({List<double>? optimizedParameters})
    : _fsrs = FsrsAlgorithm(parameters: optimizedParameters);

  SrsScheduleResult schedule({
    required String id,
    required String itemType,
    required SrsRating rating,
    required LearningProgressData? currentProgress,
    required List<int> learningSteps,
    required List<int> relearningSteps,
    int leechThreshold = 5,
    int? nowMillis,
  }) {
    final now = nowMillis ?? DateTimeUtils.getCurrentCompensatedMillis();
    final currentState = MemoryState(
      stability: currentProgress?.stability ?? 0.0,
      difficulty: currentProgress?.difficulty ?? 0.0,
    );

    final lastReviewed = currentProgress?.lastReviewed?.toInt() ?? now;
    final double elapsedDays =
        (currentProgress == null || currentProgress.lastReviewed == null)
        ? 0.0
        : (now - lastReviewed) / (24 * 60 * 60 * 1000);

    final firstLearned = currentProgress?.firstLearned ?? BigInt.from(now);
    final currentStep = currentProgress?.step ?? 0;
    final isNew =
        currentProgress == null || currentProgress.repetitionCount == 0;
    final isLearning = isNew || currentProgress.step < learningSteps.length;

    if (rating == SrsRating.again) {
      final currentLapses = currentProgress?.lapses ?? 0;
      final newLapseCount = currentLapses + 1;

      // Immediate Lapse Penalty calculation (to mimic Kotlin's immediate write-back)
      final newState = _fsrs.step(currentState, FsrsRating.again, elapsedDays);
      final penalizedInterval = _fsrs.nextIntervalDays(newState.stability);

      // Leech Detection
      if (newLapseCount >= leechThreshold) {
        final companion = LearningProgressCompanion(
          id: Value(id),
          itemType: Value(itemType),
          lapses: Value(newLapseCount),
          stability: Value(newState.stability),
          difficulty: Value(newState.difficulty),
          interval: Value(penalizedInterval),
          lastReviewed: Value(BigInt.from(now)),
          firstLearned: Value(firstLearned),
        );
        return SrsLeech(companion: companion, totalLapses: newLapseCount);
      }

      return _handleAgain(
        id,
        itemType,
        now,
        firstLearned,
        newLapseCount,
        relearningSteps,
        newState,
        penalizedInterval,
      );
    }

    if (isLearning) {
      if (rating == SrsRating.hard) {
        return _handleHard(
          id,
          itemType,
          currentStep,
          now,
          firstLearned,
          learningSteps,
        );
      } else if (rating == SrsRating.good) {
        if (currentStep < learningSteps.length - 1) {
          return _handleGoodStep(
            id,
            itemType,
            currentStep,
            now,
            firstLearned,
            learningSteps,
          );
        } else {
          return _handleGraduate(
            id,
            itemType,
            currentState,
            rating.toFsrs(),
            elapsedDays,
            now,
            firstLearned,
            currentProgress?.repetitionCount ?? 0,
            learningSteps,
            isRelearning: !isNew,
            currentInterval: currentProgress?.interval ?? 0,
          );
        }
      } else if (rating == SrsRating.easy) {
        return _handleGraduate(
          id,
          itemType,
          currentState,
          rating.toFsrs(),
          elapsedDays,
          now,
          firstLearned,
          currentProgress?.repetitionCount ?? 0,
          learningSteps,
          isRelearning: false, // Easy directly graduates using FSRS
          currentInterval: currentProgress?.interval ?? 0,
        );
      }
    } else {
      return _handleGraduate(
        id,
        itemType,
        currentState,
        rating.toFsrs(),
        elapsedDays,
        now,
        firstLearned,
        currentProgress.repetitionCount,
        learningSteps,
        isRelearning: false, // Normal review
        currentInterval: currentProgress.interval,
      );
    }

    return _handleAgain(
      id,
      itemType,
      now,
      firstLearned,
      (currentProgress?.lapses ?? 0),
      relearningSteps,
      currentState,
      currentProgress?.interval ?? 0,
    );
  }

  Map<SrsRating, String> getIntervalPreviews({
    required LearningProgressData? currentProgress,
    required List<int> learningSteps,
    required List<int> relearningSteps,
    int? nowMillis,
  }) {
    final now = nowMillis ?? DateTimeUtils.getCurrentCompensatedMillis();
    final currentState = MemoryState(
      stability: currentProgress?.stability ?? 0.0,
      difficulty: currentProgress?.difficulty ?? 0.0,
    );

    final lastReviewed = currentProgress?.lastReviewed?.toInt() ?? now;
    final double elapsedDays =
        (currentProgress == null || currentProgress.lastReviewed == null)
        ? 0.0
        : (now - lastReviewed) / (24 * 60 * 60 * 1000);

    final currentStep = currentProgress?.step ?? 0;
    final isNew =
        currentProgress == null || currentProgress.repetitionCount == 0;
    final isLearning = isNew || currentProgress.step < learningSteps.length;

    final Map<SrsRating, String> previews = {};
    previews[SrsRating.again] = '${relearningSteps[0]}m';

    if (isLearning) {
      previews[SrsRating.hard] = '${learningSteps[currentStep]}m';

      if (currentStep < learningSteps.length - 1) {
        previews[SrsRating.good] = '${learningSteps[currentStep + 1]}m';
      } else {
        if (!isNew) {
          // Relearning Graduation Preview: Show penalized interval
          previews[SrsRating.good] = '${currentProgress.interval}d';
        } else {
          final nextState = _fsrs.step(
            currentState,
            SrsRating.good.toFsrs(),
            elapsedDays,
          );
          previews[SrsRating.good] =
              '${_fsrs.nextIntervalDays(nextState.stability)}d';
        }
      }

      final nextStateEasy = _fsrs.step(
        currentState,
        SrsRating.easy.toFsrs(),
        elapsedDays,
      );
      previews[SrsRating.easy] =
          '${_fsrs.nextIntervalDays(nextStateEasy.stability)}d';
    } else {
      for (final rating in [SrsRating.hard, SrsRating.good, SrsRating.easy]) {
        final nextState = _fsrs.step(
          currentState,
          rating.toFsrs(),
          elapsedDays,
        );
        previews[rating] = '${_fsrs.nextIntervalDays(nextState.stability)}d';
      }
    }

    return previews;
  }

  SrsScheduleResult _handleAgain(
    String id,
    String itemType,
    int now,
    BigInt firstLearned,
    int lapses,
    List<int> relearningSteps,
    MemoryState newState,
    int penalizedInterval,
  ) {
    const nextStep = 0;
    final intervalMin = relearningSteps[nextStep];
    final dueTime = BigInt.from(now + intervalMin * 60 * 1000);

    final companion = LearningProgressCompanion(
      id: Value(id),
      itemType: Value(itemType),
      step: const Value(0),
      lapses: Value(lapses),
      stability: Value(newState.stability),
      difficulty: Value(newState.difficulty),
      interval: Value(penalizedInterval),
      dueTime: Value(dueTime),
      lastReviewed: Value(BigInt.from(now)),
      firstLearned: Value(firstLearned),
    );

    return SrsRequeue(
      companion: companion,
      nextStep: nextStep,
      dueTime: dueTime,
    );
  }

  SrsScheduleResult _handleHard(
    String id,
    String itemType,
    int currentStep,
    int now,
    BigInt firstLearned,
    List<int> learningSteps,
  ) {
    final intervalMin = learningSteps[currentStep];
    final dueTime = BigInt.from(now + intervalMin * 60 * 1000);

    final companion = LearningProgressCompanion(
      id: Value(id),
      itemType: Value(itemType),
      step: Value(currentStep),
      dueTime: Value(dueTime),
      lastReviewed: Value(BigInt.from(now)),
      firstLearned: Value(firstLearned),
    );

    return SrsRequeue(
      companion: companion,
      nextStep: currentStep,
      dueTime: dueTime,
    );
  }

  SrsScheduleResult _handleGoodStep(
    String id,
    String itemType,
    int currentStep,
    int now,
    BigInt firstLearned,
    List<int> learningSteps,
  ) {
    final nextStep = currentStep + 1;
    final intervalMin = learningSteps[nextStep];
    final dueTime = BigInt.from(now + intervalMin * 60 * 1000);

    final companion = LearningProgressCompanion(
      id: Value(id),
      itemType: Value(itemType),
      step: Value(nextStep),
      dueTime: Value(dueTime),
      lastReviewed: Value(BigInt.from(now)),
      firstLearned: Value(firstLearned),
    );

    return SrsRequeue(
      companion: companion,
      nextStep: nextStep,
      dueTime: dueTime,
    );
  }

  SrsScheduleResult _handleGraduate(
    String id,
    String itemType,
    MemoryState currentState,
    FsrsRating rating,
    double elapsedDays,
    int now,
    BigInt firstLearned,
    int repetitionCount,
    List<int> learningSteps, {
    required bool isRelearning,
    required int currentInterval,
  }) {
    double finalStability = currentState.stability;
    double finalDifficulty = currentState.difficulty;
    int newInterval = currentInterval;

    if (isRelearning && rating == FsrsRating.good) {
      // Relearning Graduation: retain penalized interval and state, do not re-run FSRS
      // newInterval is already currentInterval
    } else {
      final newState = _fsrs.step(currentState, rating, elapsedDays);
      finalStability = newState.stability;
      finalDifficulty = newState.difficulty;

      if (rating == FsrsRating.again) {
        newInterval = _fsrs.nextIntervalDays(newState.stability);
      } else {
        final kQuality = rating == FsrsRating.hard ? 3 : (rating == FsrsRating.good ? 4 : 5);
        final todayDay = now ~/ 86400000;
        final seed = id.hashCode ^ (todayDay << 8) ^ (kQuality << 4) ^ repetitionCount;
        newInterval = _fsrs.nextIntervalDaysWithFuzz(newState.stability, seed);
      }
    }

    final dueTime = BigInt.from(now + newInterval * 24 * 60 * 60 * 1000);

    final companion = LearningProgressCompanion(
      id: Value(id),
      itemType: Value(itemType),
      step: Value(learningSteps.length), // Graduate
      stability: Value(finalStability),
      difficulty: Value(finalDifficulty),
      interval: Value(newInterval),
      repetitionCount: Value(repetitionCount + 1),
      dueTime: Value(dueTime),
      lastReviewed: Value(BigInt.from(now)),
      firstLearned: Value(firstLearned),
    );

    return SrsGraduate(
      companion: companion,
      rating: SrsRating.values[rating.index],
    );
  }
}
