import 'package:drift/drift.dart';
import 'package:core_storage/core_storage.dart';

enum SrsRating {
  again, // 0
  hard,  // 1
  good,  // 2
  easy;  // 3

  static SrsRating fromInt(int value) {
    return SrsRating.values[value.clamp(0, 3)];
  }
}

sealed class SrsScheduleResult {
  const SrsScheduleResult();
}

class SrsRequeue extends SrsScheduleResult {
  final LearningProgressCompanion updatedProgress;
  final int nextStep;
  final BigInt dueTime;

  const SrsRequeue({
    required this.updatedProgress,
    required this.nextStep,
    required this.dueTime,
  });
}

class SrsGraduate extends SrsScheduleResult {
  final LearningProgressCompanion updatedProgress;
  final SrsRating rating;

  const SrsGraduate({
    required this.updatedProgress,
    required this.rating,
  });
}

class SrsScheduler {
  static const List<int> learningSteps = [1, 10]; // Minutes

  SrsScheduleResult schedule({
    required String id,
    required String itemType,
    required SrsRating rating,
    required LearningProgressData? currentProgress,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final currentStep = currentProgress?.step ?? 0;

    switch (rating) {
      case SrsRating.again:
        return _handleAgain(id, itemType, now);
      case SrsRating.hard:
        return _handleHard(id, itemType, currentStep, now);
      case SrsRating.good:
        return _handleGood(id, itemType, currentStep, now);
      case SrsRating.easy:
        return _handleEasy(id, itemType, currentStep, now);
    }
  }

  SrsScheduleResult _handleAgain(String id, String itemType, int now) {
    final nextStep = 0;
    final intervalMin = learningSteps[nextStep];
    final dueTime = BigInt.from(now + intervalMin * 60 * 1000);

    final companion = LearningProgressCompanion(
      id: Value(id),
      itemType: Value(itemType),
      step: const Value(0),
      dueTime: Value(dueTime),
      lastReviewed: Value(BigInt.from(now)),
    );

    return SrsRequeue(
      updatedProgress: companion,
      nextStep: nextStep,
      dueTime: dueTime,
    );
  }

  SrsScheduleResult _handleHard(String id, String itemType, int currentStep, int now) {
    final intervalMin = learningSteps[currentStep];
    final dueTime = BigInt.from(now + intervalMin * 60 * 1000);

    final companion = LearningProgressCompanion(
      id: Value(id),
      itemType: Value(itemType),
      step: Value(currentStep),
      dueTime: Value(dueTime),
      lastReviewed: Value(BigInt.from(now)),
    );

    return SrsRequeue(
      updatedProgress: companion,
      nextStep: currentStep,
      dueTime: dueTime,
    );
  }

  SrsScheduleResult _handleGood(String id, String itemType, int currentStep, int now) {
    if (currentStep < learningSteps.length - 1) {
      final nextStep = currentStep + 1;
      final intervalMin = learningSteps[nextStep];
      final dueTime = BigInt.from(now + intervalMin * 60 * 1000);

      final companion = LearningProgressCompanion(
        id: Value(id),
        itemType: Value(itemType),
        step: Value(nextStep),
        dueTime: Value(dueTime),
        lastReviewed: Value(BigInt.from(now)),
      );

      return SrsRequeue(
        updatedProgress: companion,
        nextStep: nextStep,
        dueTime: dueTime,
      );
    } else {
      // Graduate
      final companion = LearningProgressCompanion(
        id: Value(id),
        itemType: Value(itemType),
        // Simple graduation logic: 1 day interval
        interval: const Value(1), 
        dueTime: Value(BigInt.from(now + 24 * 60 * 60 * 1000)),
        lastReviewed: Value(BigInt.from(now)),
        repetitionCount: Value((0) + 1), // This needs current count
      );
      return SrsGraduate(updatedProgress: companion, rating: SrsRating.good);
    }
  }

  SrsScheduleResult _handleEasy(String id, String itemType, int currentStep, int now) {
    // Immediate graduation
    final companion = LearningProgressCompanion(
      id: Value(id),
      itemType: Value(itemType),
      interval: const Value(4), // 4 days for Easy graduation
      dueTime: Value(BigInt.from(now + 4 * 24 * 60 * 60 * 1000)),
      lastReviewed: Value(BigInt.from(now)),
    );
    return SrsGraduate(updatedProgress: companion, rating: SrsRating.easy);
  }
}
