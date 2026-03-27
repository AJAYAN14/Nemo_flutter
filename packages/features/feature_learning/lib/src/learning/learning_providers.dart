import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/learning_item.dart';
import '../domain/srs_scheduler.dart';
import '../data/learning_repository.dart';

part 'learning_providers.g.dart';

class LearningUiModel {
  const LearningUiModel({
    required this.items,
    required this.currentIndex,
    required this.revealedItemIds,
    required this.totalItems,
    this.completedCount = 0,
    this.ratingIntervals = const {},
    this.isCompleted = false,
  });

  final List<LearningItem> items;
  final int currentIndex;
  final Set<String> revealedItemIds;
  final int totalItems;
  final int completedCount;
  final Map<SrsRating, String> ratingIntervals;
  final bool isCompleted;

  String get currentId {
    if (items.isEmpty || currentIndex >= items.length) return '';
    final item = items[currentIndex];
    if (item is WordItem) return item.word.id;
    if (item is GrammarItem) return item.grammar.id.toString();
    return '';
  }

  bool isRevealed(String id) => revealedItemIds.contains(id);

  double get progress {
    if (totalItems == 0) return 0;
    return (completedCount) / totalItems;
  }

  LearningUiModel copyWith({
    List<LearningItem>? items,
    int? currentIndex,
    Set<String>? revealedItemIds,
    int? totalItems,
    int? completedCount,
    Map<SrsRating, String>? ratingIntervals,
    bool? isCompleted,
  }) {
    return LearningUiModel(
      items: items ?? this.items,
      currentIndex: currentIndex ?? this.currentIndex,
      revealedItemIds: revealedItemIds ?? this.revealedItemIds,
      totalItems: totalItems ?? this.totalItems,
      completedCount: completedCount ?? this.completedCount,
      ratingIntervals: ratingIntervals ?? this.ratingIntervals,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  static const LearningUiModel initial = LearningUiModel(
    items: [],
    currentIndex: 0,
    revealedItemIds: <String>{},
    totalItems: 0,
    completedCount: 0,
    ratingIntervals: {},
    isCompleted: false,
  );
}

@riverpod
class LearningNotifier extends _$LearningNotifier {
  final SrsScheduler _scheduler = SrsScheduler();

  @override
  FutureOr<LearningUiModel> build(String mode) async {
    final items = await ref.watch(learningRepositoryProvider).getLearningQueue(mode);
    final intervals = items.isNotEmpty 
        ? _scheduler.getIntervalPreviews(currentProgress: items[0].progress)
        : <SrsRating, String>{};
        
    return LearningUiModel(
      items: items,
      currentIndex: 0,
      revealedItemIds: {},
      totalItems: items.length,
      ratingIntervals: intervals,
    );
  }

  void onPageChanged(int index) {
    final value = state.valueOrNull;
    if (value == null || index < 0 || index >= value.items.length) {
      return;
    }
    
    // Recalculate intervals for the new page
    final intervals = _scheduler.getIntervalPreviews(
      currentProgress: value.items[index].progress,
    );

    state = AsyncData(value.copyWith(
      currentIndex: index,
      ratingIntervals: intervals,
    ));
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
    if (value == null || value.isCompleted || value.items.isEmpty) return;

    final item = value.items[value.currentIndex];
    final String id;
    final String type;
    if (item is WordItem) {
      id = item.word.id;
      type = 'word';
    } else {
      id = (item as GrammarItem).grammar.id.toString();
      type = 'grammar';
    }

    final rating = SrsRating.fromInt(score);

    // Update progress in database
    final result = await ref.read(learningRepositoryProvider).updateProgress(
      id,
      type,
      rating,
    );

    final nextItems = List<LearningItem>.from(value.items);
    final currentItem = nextItems.removeAt(value.currentIndex);

    if (result.isRequeue) {
      final reItem = currentItem is WordItem 
          ? currentItem.copyWith(progress: result.updatedProgress)
          : (currentItem as GrammarItem).copyWith(progress: result.updatedProgress);
      nextItems.add(reItem);
    }

    if (nextItems.isEmpty) {
      state = AsyncData(value.copyWith(
        items: [],
        currentIndex: 0,
        completedCount: value.completedCount + 1,
        isCompleted: true,
      ));
    } else {
      // Clamping in case we were at the end and didn't requeue
      final nextIndex = value.currentIndex.clamp(0, nextItems.length - 1);
      final intervals = _scheduler.getIntervalPreviews(
        currentProgress: nextItems[nextIndex].progress,
      );
      
      state = AsyncData(value.copyWith(
        items: nextItems,
        currentIndex: nextIndex,
        completedCount: value.completedCount + (result.isRequeue ? 0 : 1),
        ratingIntervals: intervals,
        revealedItemIds: {...value.revealedItemIds}..remove(id),
      ));
    }
  }
}
