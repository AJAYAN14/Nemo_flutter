import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_prefs/core_prefs.dart';
import '../domain/learning_item.dart';
import '../domain/srs_scheduler.dart';
import '../data/learning_repository.dart';
import '../domain/learning_session_state.dart';

part 'learning_providers.g.dart';

class LearningUiModel {
  const LearningUiModel({
    this.sessionState = const LearningSessionEmpty(),
    this.items = const [],
    this.currentIndex = 0,
    this.revealedItemIds = const {},
    this.totalItems = 0,
    this.completedCount = 0,
    this.ratingIntervals = const {},
    this.lastSnapshot,
  });

  final LearningSessionState sessionState;
  final List<LearningItem> items;
  final int currentIndex;
  final Set<String> revealedItemIds;
  final int totalItems;
  final int completedCount;
  final Map<SrsRating, String> ratingIntervals;
  final SessionSnapshot? lastSnapshot;

  bool get isCompleted => sessionState is LearningSessionEmpty;

  String get currentId {
    if (sessionState is! LearningSessionActive) return '';
    final item = (sessionState as LearningSessionActive).item;
    if (item is WordItem) return item.word.id;
    if (item is GrammarItem) return item.grammar.id;
    return '';
  }

  bool isRevealed(String id) => revealedItemIds.contains(id);

  double get progress {
    if (totalItems == 0) return 0;
    return (completedCount) / totalItems;
  }

  LearningUiModel copyWith({
    LearningSessionState? sessionState,
    List<LearningItem>? items,
    int? currentIndex,
    Set<String>? revealedItemIds,
    int? totalItems,
    int? completedCount,
    Map<SrsRating, String>? ratingIntervals,
    SessionSnapshot? lastSnapshot,
  }) {
    return LearningUiModel(
      sessionState: sessionState ?? this.sessionState,
      items: items ?? this.items,
      currentIndex: currentIndex ?? this.currentIndex,
      revealedItemIds: revealedItemIds ?? this.revealedItemIds,
      totalItems: totalItems ?? this.totalItems,
      completedCount: completedCount ?? this.completedCount,
      ratingIntervals: ratingIntervals ?? this.ratingIntervals,
      lastSnapshot: lastSnapshot ?? this.lastSnapshot,
    );
  }

  static const LearningUiModel initial = LearningUiModel();
}

@riverpod
class LearningNotifier extends _$LearningNotifier {
  final SrsScheduler _scheduler = SrsScheduler();

  @override
  FutureOr<LearningUiModel> build(String mode) async {
    final items = await ref.watch(learningRepositoryProvider).getLearningQueue(mode);
    return _buildStateWithItems(items, 0, 0);
  }

  LearningUiModel _buildStateWithItems(List<LearningItem> items, int currentIndex, int completedCount) {
    if (items.isEmpty) {
      return LearningUiModel(
        sessionState: const LearningSessionEmpty(),
        items: [],
        currentIndex: 0,
        totalItems: completedCount,
        completedCount: completedCount,
      );
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    // P1: learn-ahead logic (default 20 mins)
    final learnAheadLimit = ref.read(learnAheadLimitProvider).inMilliseconds;

    // Check if the current item is actually due
    final currentItem = items[currentIndex];
    final dueTime = currentItem.progress?.dueTime.toInt() ?? 0;

    if (dueTime > now + learnAheadLimit) {
      return LearningUiModel(
        sessionState: LearningSessionWaiting(
          waitingUntil: DateTime.fromMillisecondsSinceEpoch(dueTime),
        ),
        items: items,
        currentIndex: currentIndex,
        totalItems: items.length + completedCount,
        completedCount: completedCount,
      );
    }

    final intervals = _scheduler.getIntervalPreviews(currentProgress: currentItem.progress);

    return LearningUiModel(
      sessionState: LearningSessionActive(
        item: currentItem,
        currentIndex: currentIndex,
        totalItems: items.length + completedCount,
      ),
      items: items,
      currentIndex: currentIndex,
      totalItems: items.length + completedCount,
      completedCount: completedCount,
      ratingIntervals: intervals,
    );
  }

  void onPageChanged(int index) {
    final value = state.valueOrNull;
    if (value == null || index < 0 || index >= value.items.length) {
      return;
    }
    state = AsyncData(_buildStateWithItems(value.items, index, value.completedCount));
  }

  void toggleReveal(String id) {
    final value = state.valueOrNull;
    if (value == null) return;

    final next = <String>{...value.revealedItemIds};
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    state = AsyncData(value.copyWith(revealedItemIds: next));
  }

  Future<void> onRate(int score) async {
    final value = state.valueOrNull;
    if (value == null || value.items.isEmpty) return;

    final item = value.items[value.currentIndex];
    final String id;
    final String type;
    if (item is WordItem) {
      id = item.word.id;
      type = 'word';
    } else {
      id = (item as GrammarItem).grammar.id;
      type = 'grammar';
    }

    // Save snapshot for Undo
    final snapshot = SessionSnapshot(
      items: List.from(value.items),
      currentIndex: value.currentIndex,
      completedCount: value.completedCount,
      previousProgress: item.progress,
    );

    final rating = SrsRating.fromInt(score);
    final result = await ref.read(learningRepositoryProvider).updateProgress(id, type, rating);

    final nextItems = List<LearningItem>.from(value.items);
    nextItems.removeAt(value.currentIndex);

    if (result.isRequeue) {
      final reItem = item is WordItem 
          ? item.copyWith(progress: result.updatedProgress)
          : (item as GrammarItem).copyWith(progress: result.updatedProgress);
      nextItems.add(reItem);
    }

    state = AsyncData(_buildStateWithItems(
      nextItems, 
      0, // Always go back to 0 to find the next most due item if sorted
      value.completedCount + (result.isRequeue ? 0 : 1),
    ).copyWith(
      lastSnapshot: snapshot,
      revealedItemIds: {...value.revealedItemIds}..remove(id),
    ));
  }

  Future<void> undo() async {
    final value = state.valueOrNull;
    if (value == null || value.lastSnapshot == null) return;

    final snapshot = value.lastSnapshot!;
    final item = snapshot.items[snapshot.currentIndex];
    
    final String id;
    final String type;
    if (item is WordItem) {
      id = item.word.id;
      type = 'word';
    } else {
      id = (item as GrammarItem).grammar.id;
      type = 'grammar';
    }

    await ref.read(learningRepositoryProvider).undoUpdateProgress(
      id, 
      type, 
      snapshot.previousProgress,
    );

    state = AsyncData(_buildStateWithItems(
      snapshot.items,
      snapshot.currentIndex,
      snapshot.completedCount,
    ).copyWith(lastSnapshot: null));
  }

  Future<void> suspendCurrent() async {
    final value = state.valueOrNull;
    if (value == null || value.sessionState is! LearningSessionActive) return;

    final item = (value.sessionState as LearningSessionActive).item;
    final String id = item is WordItem ? item.word.id : (item as GrammarItem).grammar.id;
    final String type = item is WordItem ? 'word' : 'grammar';

    await ref.read(learningRepositoryProvider).suspend(id, type);
    
    final nextItems = List<LearningItem>.from(value.items);
    nextItems.removeAt(value.currentIndex);

    state = AsyncData(_buildStateWithItems(nextItems, 0, value.completedCount));
  }

  Future<void> buryCurrent() async {
    final value = state.valueOrNull;
    if (value == null || value.sessionState is! LearningSessionActive) return;

    final item = (value.sessionState as LearningSessionActive).item;
    final String id = item is WordItem ? item.word.id : (item as GrammarItem).grammar.id;
    final String type = item is WordItem ? 'word' : 'grammar';
    final resetHour = ref.read(resetHourProvider);

    await ref.read(learningRepositoryProvider).bury(id, type, resetHour);
    
    final nextItems = List<LearningItem>.from(value.items);
    nextItems.removeAt(value.currentIndex);

    state = AsyncData(_buildStateWithItems(nextItems, 0, value.completedCount));
  }
}

@riverpod
Duration learnAheadLimit(LearnAheadLimitRef ref) {
  // Can be connected to SharedPreferences later
  return const Duration(minutes: 20);
}
