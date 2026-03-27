import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_domain/core_domain.dart';
import '../domain/learning_item.dart';
import '../domain/srs_scheduler.dart';
import '../data/learning_repository.dart';
import '../learning/learning_providers.dart';
import '../domain/learning_session_state.dart';

part 'review_providers.g.dart';

@riverpod
class ReviewNotifier extends _$ReviewNotifier {
  final SrsScheduler _scheduler = SrsScheduler();

  @override
  FutureOr<LearningUiModel> build(String mode) async {
    final items = await ref.watch(learningRepositoryProvider).getReviewQueue(mode);
    return _buildStateWithItems(items, 0, 0);
  }

  LearningUiModel _buildStateWithItems(List<LearningItem> items, int currentIndex, int completedCount) {
    if (items.isEmpty) {
      return LearningUiModel(
        sessionState: const LearningSessionEmpty(),
      );
    }

    // Review usually doesn't have a "Waiting" state unless we want it, 
    // but we can apply it for consistency if getting items fails or if we implement learn-ahead.
    
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

  void showAnswer() {
    final value = state.valueOrNull;
    if (value == null || value.sessionState is! LearningSessionActive) return;
    
    final active = value.sessionState as LearningSessionActive;
    state = AsyncData(value.copyWith(
      sessionState: active.copyWith(isRevealed: true),
    ));
  }

  Future<void> rate(int score) async {
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

    final rating = SrsRating.fromInt(score);
    
    // Save snapshot for Undo
    final snapshot = SessionSnapshot(
      items: List.from(value.items),
      currentIndex: value.currentIndex,
      completedCount: value.completedCount,
      previousProgress: item.progress,
    );

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
      0, 
      value.completedCount + (result.isRequeue ? 0 : 1),
    ).copyWith(lastSnapshot: snapshot));
  }

  Future<void> undo() async {
    final value = state.valueOrNull;
    if (value == null || value.lastSnapshot == null) return;

    final snapshot = value.lastSnapshot!;
    final item = snapshot.items[snapshot.currentIndex];
    
    final String id = item is WordItem ? item.word.id : (item as GrammarItem).grammar.id;
    final String type = item is WordItem ? 'word' : 'grammar';

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

    await ref.read(learningRepositoryProvider).bury(id, type, 4); // Default reset hour
    
    final nextItems = List<LearningItem>.from(value.items);
    nextItems.removeAt(value.currentIndex);

    state = AsyncData(_buildStateWithItems(nextItems, 0, value.completedCount));
  }
}
