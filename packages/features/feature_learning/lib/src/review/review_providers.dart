import 'package:core_domain/core_domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReviewNotifier extends Notifier<ReviewSession> {
  @override
  ReviewSession build() {
    return ReviewSession(
      items: reviewMockItems,
      startTime: DateTime.now(),
    );
  }

  void showAnswer() {
    state = state.copyWith(showAnswer: true);
  }

  void rate(ReviewRating rating) {
    if (state.isCompleted) return;

    final updatedRatings = [...state.ratings, rating];
    final isLast = state.currentIndex == state.items.length - 1;

    if (isLast) {
      state = state.copyWith(
        ratings: updatedRatings,
        isCompleted: true,
      );
    } else {
      state = state.copyWith(
        ratings: updatedRatings,
        currentIndex: state.currentIndex + 1,
        showAnswer: false,
      );
    }
  }

  void restart() {
    state = build();
  }
}

final reviewProvider = NotifierProvider<ReviewNotifier, ReviewSession>(
  ReviewNotifier.new,
);

final reviewMockItems = [
  ReviewItem.word(
    word: Word(
      id: '1',
      japanese: '勉強',
      hiragana: 'べんきょう',
      chinese: '学习',
      level: 'N5',
    ),
  ),
  ReviewItem.grammar(
    grammar: Grammar(
      id: 'g_2',
      grammar: '〜ている',
      grammarLevel: 'N5',
      lastModifiedTime: 0,
      usages: [
        GrammarUsage(
          connection: '动词连用形 + ている',
          explanation: '表示正在进行或状态的持续',
          examples: [],
        ),
      ],
    ),
  ),
];
