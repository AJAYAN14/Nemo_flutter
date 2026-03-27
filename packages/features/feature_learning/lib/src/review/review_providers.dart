import 'package:core_domain/core_domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/learning_repository.dart';
import '../domain/srs_scheduler.dart';
import '../domain/learning_item.dart';

part 'review_providers.g.dart';

@riverpod
class ReviewNotifier extends _$ReviewNotifier {
  @override
  FutureOr<ReviewSession> build(String mode) async {
    final rawItems = await ref.watch(learningRepositoryProvider).getLearningQueue(mode);
    
    // Map raw items to ReviewItem
    final items = rawItems.map((item) {
      if (item is WordItem) {
        return ReviewItem.word(word: item.word);
      } else {
        return ReviewItem.grammar(grammar: (item as GrammarItem).grammar);
      }
    }).toList();

    return ReviewSession(
      items: items,
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
      state = AsyncData(value.copyWith(
        ratings: updatedRatings,
        currentIndex: value.currentIndex + 1,
        showAnswer: false,
      ));
    }
  }

  void restart() {
    ref.invalidateSelf();
  }
}
