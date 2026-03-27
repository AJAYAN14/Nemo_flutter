import 'package:core_domain/core_domain.dart';
import 'package:core_storage/core_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/learning_repository.dart';
import '../domain/srs_scheduler.dart';
import '../domain/learning_item.dart';

part 'review_providers.g.dart';

@riverpod
class ReviewNotifier extends _$ReviewNotifier {
  final SrsScheduler _scheduler = SrsScheduler();

  // Caching progress to avoid repeated DB lookups
  final Map<int, LearningProgressData?> _progressCache = {};

  @override
  FutureOr<ReviewSession> build(String mode) async {
    final rawItems = await ref.watch(learningRepositoryProvider).getReviewQueue(mode);
    
    // Cache progress
    for (int i = 0; i < rawItems.length; i++) {
       _progressCache[i] = rawItems[i].progress;
    }

    // Map raw items to ReviewItem
    final items = rawItems.map((item) {
      if (item is WordItem) {
        return ReviewItem.word(word: item.word);
      } else {
        return ReviewItem.grammar(grammar: (item as GrammarItem).grammar);
      }
    }).toList();

    Map<String, String> intervals = {};
    if (rawItems.isNotEmpty) {
      final srsIntervals = _scheduler.getIntervalPreviews(currentProgress: rawItems[0].progress);
      intervals = srsIntervals.map((key, value) => MapEntry(key.name, value));
    }

    return ReviewSession(
      items: items,
      ratingIntervals: intervals,
      startTime: DateTime.now(),
    );
  }

  void showAnswer() {
    final value = state.valueOrNull;
    if (value == null) return;
    state = AsyncData(value.copyWith(showAnswer: true));
  }

  Future<void> rate(ReviewRating rating) async {
    final value = state.valueOrNull;
    if (value == null || value.isCompleted) return;

    final item = value.items[value.currentIndex];
    String id = '';
    String type = '';
    
    item.map(
      word: (w) {
        id = w.word.id;
        type = 'word';
      },
      grammar: (g) {
        id = g.grammar.id;
        type = 'grammar';
      },
    );

    // Map ReviewRating to SrsRating
    final srsRating = switch (rating) {
      ReviewRating.again => SrsRating.again,
      ReviewRating.hard => SrsRating.hard,
      ReviewRating.good => SrsRating.good,
      ReviewRating.easy => SrsRating.easy,
    };

    // Update progress
    await ref.read(learningRepositoryProvider).updateProgress(
      id,
      type,
      srsRating,
    );

    final updatedRatings = [...value.ratings, rating];
    final isLast = value.currentIndex == value.items.length - 1;

    if (isLast) {
      state = AsyncData(value.copyWith(
        ratings: updatedRatings,
        isCompleted: true,
      ));
    } else {
      final nextIndex = value.currentIndex + 1;
      
      // Update cache with updated progress for current if it was requeued (but review doesn't normally requeue in this simple implementation)
      // Actually, let's just use the cached progress for the next item
      final srsIntervals = _scheduler.getIntervalPreviews(currentProgress: _progressCache[nextIndex]);
      final nextIntervals = srsIntervals.map((key, value) => MapEntry(key.name, value));

      state = AsyncData(value.copyWith(
        ratings: updatedRatings,
        currentIndex: nextIndex,
        showAnswer: false,
        ratingIntervals: nextIntervals,
      ));
    }
  }

  void restart() {
    ref.invalidateSelf();
  }
}
