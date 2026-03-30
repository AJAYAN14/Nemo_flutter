import 'package:core_domain/core_domain.dart';

sealed class LearningSessionState {
  const LearningSessionState();
}

class LearningSessionActive extends LearningSessionState {
  const LearningSessionActive({
    required this.item,
    required this.currentIndex,
    required this.totalItems,
    this.isRevealed = false,
  });

  final LearningItem item;
  final int currentIndex;
  final int totalItems;
  final bool isRevealed;

  LearningSessionActive copyWith({
    LearningItem? item,
    int? currentIndex,
    int? totalItems,
    bool? isRevealed,
  }) {
    return LearningSessionActive(
      item: item ?? this.item,
      currentIndex: currentIndex ?? this.currentIndex,
      totalItems: totalItems ?? this.totalItems,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }
}

class LearningSessionWaiting extends LearningSessionState {
  const LearningSessionWaiting({required this.waitingUntil});
  final DateTime waitingUntil;
}

class LearningSessionEmpty extends LearningSessionState {
  const LearningSessionEmpty();
}

class SessionSnapshot {
  const SessionSnapshot({
    required this.items,
    required this.currentIndex,
    required this.completedCount,
    required this.completedToday,
    required this.previousProgress,
  });

  final List<LearningItem> items;
  final int currentIndex;
  final int completedCount;
  final int completedToday;
  final StudyProgress? previousProgress;
}
