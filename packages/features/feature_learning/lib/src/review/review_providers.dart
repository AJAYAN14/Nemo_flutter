import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_prefs/core_prefs.dart';
import '../domain/learning_item.dart';
import '../domain/srs_scheduler.dart';
import '../data/learning_repository.dart';
import '../learning/learning_providers.dart';
import '../domain/learning_session_state.dart';

part 'review_providers.g.dart';

@riverpod
class ReviewNotifier extends _$ReviewNotifier {
  late final SrsScheduler _scheduler = SrsScheduler();

  @override
  FutureOr<LearningUiModel> build(String mode) async {
    final repository = ref.watch(learningRepositoryProvider);
    final prefs = ref.watch(preferenceServiceProvider);
    
    final savedIds = prefs.getLearningSessionItems('${mode}_review');
    final savedIndex = prefs.getLearningSessionIndex('${mode}_review');

    if (savedIds.isNotEmpty) {
      final items = await repository.getItemsByIds(savedIds);
      if (items.isNotEmpty) {
        final index = savedIndex.clamp(0, items.length - 1);
        return _buildStateWithItems(items, index, 0);
      }
    }

    final items = await repository.getReviewQueue(mode);
    
    if (items.isEmpty) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final limitMinutes = ref.watch(learnAheadLimitProvider);
      
      final upcoming = await repository.getUpcomingItems(
        now, 
        limitMinutes * 60 * 1000, 
        itemType: mode,
      );

      if (upcoming.isNotEmpty) {
        final waitingUntilMillis = upcoming.first.progress?.dueTime.toInt() ?? 0;
        if (waitingUntilMillis > now) {
          return _buildStateWithItems([], 0, 0).copyWith(
            sessionState: LearningSessionWaiting(
              waitingUntil: DateTime.fromMillisecondsSinceEpoch(waitingUntilMillis),
            ),
          );
        }
      }
    }

    return _buildStateWithItems(items, 0, 0);
  }

  LearningUiModel _buildStateWithItems(List<LearningItem> items, int currentIndex, int completedCount) {
    if (items.isEmpty) {
      _clearSession();
      return LearningUiModel(
        sessionState: const LearningSessionEmpty(),
        items: const [],
        currentIndex: 0,
        totalItems: completedCount,
        completedCount: completedCount,
      );
    }

    _saveSession(items, currentIndex);

    final currentItem = items[currentIndex];
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

  Future<void> showAnswer() async {
    final stateValue = state.valueOrNull;
    if (stateValue == null) return;
    
    final sessionState = stateValue.sessionState;
    if (sessionState is! LearningSessionActive) return;

    if (!sessionState.isRevealed) {
      final showWait = ref.read(showAnswerWaitProvider);
      if (showWait) {
        final duration = ref.read(answerWaitDurationProvider);
        await Future.delayed(Duration(milliseconds: (duration * 1000).toInt()));
      }
    }

    state = AsyncData(stateValue.copyWith(
      sessionState: sessionState.copyWith(isRevealed: true),
    ));
  }

  Future<void> rate(int score) async {
    final value = state.valueOrNull;
    if (value == null || value.items.isEmpty) return;

    final item = value.items[value.currentIndex];
    final String id = item is WordItem ? item.word.id : (item as GrammarItem).grammar.id;
    final String type = item is WordItem ? 'word' : 'grammar';

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

    state = AsyncData(_buildStateWithItems(nextItems, 0, value.completedCount + (result.isRequeue ? 0 : 1))
      .copyWith(lastSnapshot: snapshot));
  }

  Future<void> undo() async {
    final value = state.valueOrNull;
    if (value == null || value.lastSnapshot == null) return;

    final snapshot = value.lastSnapshot!;
    final item = snapshot.items[snapshot.currentIndex];
    final String id = item is WordItem ? item.word.id : (item as GrammarItem).grammar.id;
    final String type = item is WordItem ? 'word' : 'grammar';

    await ref.read(learningRepositoryProvider).undoUpdateProgress(id, type, snapshot.previousProgress);

    state = AsyncData(_buildStateWithItems(snapshot.items, snapshot.currentIndex, snapshot.completedCount)
      .copyWith(lastSnapshot: null));
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

  void _saveSession(List<LearningItem> items, int currentIndex) {
    final prefs = ref.read(preferenceServiceProvider);
    final ids = items.map((item) {
      if (item is WordItem) return 'word_${item.word.id}';
      return 'grammar_${(item as GrammarItem).grammar.id}';
    }).toList();
    
    prefs.saveLearningSession(mode: '${mode}_review', itemIds: ids, currentIndex: currentIndex);
  }

  void _clearSession() {
    ref.read(preferenceServiceProvider).clearLearningSession('${mode}_review');
  }
}
