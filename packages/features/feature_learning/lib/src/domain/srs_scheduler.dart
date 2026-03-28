import 'package:drift/drift.dart';
import 'package:core_storage/core_storage.dart';
import 'fsrs_algorithm.dart';

enum SrsRating {
  again, // 0
  hard,  // 1
  good,  // 2
  easy;  // 3

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

  const SrsLeech({
    required this.companion,
    required this.totalLapses,
  });
}

class SrsGraduate extends SrsScheduleResult {
  final LearningProgressCompanion companion;
  final SrsRating rating;

  const SrsGraduate({
    required this.companion,
    required this.rating,
  });
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
  final FsrsAlgorithm _fsrs = FsrsAlgorithm();

  SrsScheduleResult schedule({
    required String id,
    required String itemType,
    required SrsRating rating,
    required LearningProgressData? currentProgress,
    required List<int> learningSteps,
    required List<int> relearningSteps,
    int leechThreshold = 5,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final currentState = MemoryState(
      stability: currentProgress?.stability ?? 0.0,
      difficulty: currentProgress?.difficulty ?? 0.0,
    );
    
    final lastReviewed = currentProgress?.lastReviewed?.toInt() ?? now;
    final double elapsedDays = (currentProgress == null || currentProgress.lastReviewed == null)
        ? 0.0
        : (now - lastReviewed) / (24 * 60 * 60 * 1000);

    final firstLearned = currentProgress?.firstLearned ?? BigInt.from(now);
    final currentStep = currentProgress?.step ?? 0;
    final isNew = currentProgress == null || currentProgress.repetitionCount == 0;
    final isLearning = isNew || currentProgress.step < learningSteps.length;

    if (rating == SrsRating.again) {
      final currentLapses = currentProgress?.lapses ?? 0;
      final newLapseCount = currentLapses + 1;

      // Leech Detection
      if (newLapseCount >= leechThreshold) {
        final companion = LearningProgressCompanion(
          id: Value(id),
          itemType: Value(itemType),
          lapses: Value(newLapseCount),
          lastReviewed: Value(BigInt.from(now)),
          firstLearned: Value(firstLearned),
        );
        return SrsLeech(
          companion: companion,
          totalLapses: newLapseCount,
        );
      }

      return _handleAgain(id, itemType, now, firstLearned, newLapseCount, relearningSteps);
    }

    if (isLearning) {
      if (rating == SrsRating.hard) {
        return _handleHard(id, itemType, currentStep, now, firstLearned, learningSteps);
      } else if (rating == SrsRating.good) {
        if (currentStep < learningSteps.length - 1) {
          return _handleGoodStep(id, itemType, currentStep, now, firstLearned, learningSteps);
        } else {
          return _handleGraduate(id, itemType, currentState, rating.toFsrs(), elapsedDays, now, firstLearned, currentProgress?.repetitionCount ?? 0, learningSteps);
        }
      } else if (rating == SrsRating.easy) {
        return _handleGraduate(id, itemType, currentState, rating.toFsrs(), elapsedDays, now, firstLearned, currentProgress?.repetitionCount ?? 0, learningSteps);
      }
    } else {
      return _handleGraduate(id, itemType, currentState, rating.toFsrs(), elapsedDays, now, firstLearned, currentProgress.repetitionCount, learningSteps);
    }

    return _handleAgain(id, itemType, now, firstLearned, (currentProgress?.lapses ?? 0), relearningSteps);
  }

  Map<SrsRating, String> getIntervalPreviews({
    required LearningProgressData? currentProgress,
    required List<int> learningSteps,
    required List<int> relearningSteps,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final currentState = MemoryState(
      stability: currentProgress?.stability ?? 0.0,
      difficulty: currentProgress?.difficulty ?? 0.0,
    );
    
    final lastReviewed = currentProgress?.lastReviewed?.toInt() ?? now;
    final double elapsedDays = (currentProgress == null || currentProgress.lastReviewed == null)
        ? 0.0
        : (now - lastReviewed) / (24 * 60 * 60 * 1000);

    final currentStep = currentProgress?.step ?? 0;
    final isNew = currentProgress == null || currentProgress.repetitionCount == 0;
    final isLearning = isNew || currentProgress.step < learningSteps.length;

    final Map<SrsRating, String> previews = {};
    previews[SrsRating.again] = '${relearningSteps[0]}m';

    if (isLearning) {
      previews[SrsRating.hard] = '${learningSteps[currentStep]}m';
      
      if (currentStep < learningSteps.length - 1) {
        previews[SrsRating.good] = '${learningSteps[currentStep + 1]}m';
      } else {
        final nextState = _fsrs.step(currentState, SrsRating.good.toFsrs(), elapsedDays);
        previews[SrsRating.good] = '${_fsrs.nextIntervalDays(nextState.stability)}d';
      }

      final nextStateEasy = _fsrs.step(currentState, SrsRating.easy.toFsrs(), elapsedDays);
      previews[SrsRating.easy] = '${_fsrs.nextIntervalDays(nextStateEasy.stability)}d';
    } else {
      for (final rating in [SrsRating.hard, SrsRating.good, SrsRating.easy]) {
        final nextState = _fsrs.step(currentState, rating.toFsrs(), elapsedDays);
        previews[rating] = '${_fsrs.nextIntervalDays(nextState.stability)}d';
      }
    }

    return previews;
  }

  SrsScheduleResult _handleAgain(String id, String itemType, int now, BigInt firstLearned, int lapses, List<int> relearningSteps) {
    const nextStep = 0;
    final intervalMin = relearningSteps[nextStep];
    final dueTime = BigInt.from(now + intervalMin * 60 * 1000);

    final companion = LearningProgressCompanion(
      id: Value(id),
      itemType: Value(itemType),
      step: const Value(0),
      lapses: Value(lapses),
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

  SrsScheduleResult _handleHard(String id, String itemType, int currentStep, int now, BigInt firstLearned, List<int> learningSteps) {
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

  SrsScheduleResult _handleGoodStep(String id, String itemType, int currentStep, int now, BigInt firstLearned, List<int> learningSteps) {
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
    List<int> learningSteps,
  ) {
    final newState = _fsrs.step(currentState, rating, elapsedDays);
    
    final int newInterval;
    if (rating.index < FsrsRating.good.index) {
       newInterval = _fsrs.nextIntervalDays(newState.stability);
    } else {
       final seed = id.hashCode ^ now ^ rating.index ^ repetitionCount;
       newInterval = _fsrs.nextIntervalDaysWithFuzz(newState.stability, seed);
    }

    final dueTime = BigInt.from(now + newInterval * 24 * 60 * 60 * 1000);

    final companion = LearningProgressCompanion(
      id: Value(id),
      itemType: Value(itemType),
      step: Value(learningSteps.length), // Graduate
      stability: Value(newState.stability),
      difficulty: Value(newState.difficulty),
      interval: Value(newInterval),
      repetitionCount: Value(repetitionCount + 1),
      dueTime: Value(dueTime),
      lastReviewed: Value(BigInt.from(now)),
      firstLearned: Value(firstLearned),
    );

    return SrsGraduate(companion: companion, rating: SrsRating.values[rating.index]);
  }
}
