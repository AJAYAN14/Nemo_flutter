import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_domain/core_domain.dart';
import 'review_providers.dart';
import '../learning/components/cards/srs_learning_card.dart';
import '../learning/components/cards/srs_grammar_card.dart';
import '../learning/components/srs_action_area.dart';
import '../learning/components/common/nemo_learn_header.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(reviewProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (session.items.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentIndex = session.currentIndex;
    final totalCount = session.items.length;
    final isAnswerShown = session.showAnswer;
    final remainingCount = totalCount - (currentIndex + 1);

    return Scaffold(
      backgroundColor: isDark ? NemoColors.bgBaseDark : NemoColors.bgBase,
      appBar: NemoLearnHeader(
        title: '复习',
        remainingCount: remainingCount,
        progress: totalCount > 0 ? (currentIndex + 1) / totalCount : 0,
        onClose: () => Navigator.of(context).pop(),
        onPrev: null, // Review usually 1-way or controlled by buttons
        onNext: null,
        canGoPrev: false,
        canGoNext: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              itemCount: totalCount,
              controller: PageController(initialPage: currentIndex),
              physics: const NeverScrollableScrollPhysics(), // Forced sequential in review
              itemBuilder: (context, index) {
                final item = session.items[index];
                
                Widget card = const SizedBox.shrink();
                
                if (item is WordReviewItem) {
                  card = SRSLearningCard(
                    word: item.word,
                    isAnswerShown: index == currentIndex ? isAnswerShown : false,
                    badge: CardBadge.review,
                  );
                } else if (item is GrammarReviewItem) {
                  card = SRSGrammarCard(
                    grammar: item.grammar,
                    isAnswerShown: index == currentIndex ? isAnswerShown : false,
                  );
                }

                return card;
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SRSActionArea(
              showAnswer: isAnswerShown,
              onShowAnswer: () => ref.read(reviewProvider.notifier).showAnswer(),
              onRate: (score) {
                final rating = switch (score) {
                  0 => ReviewRating.again,
                  1 => ReviewRating.hard,
                  2 => ReviewRating.good,
                  _ => ReviewRating.easy,
                };
                ref.read(reviewProvider.notifier).rate(rating);
              },
              ratingIntervals: const {
                'again': '<1m',
                'hard': '2d',
                'good': '4d',
                'easy': '7d',
              },
            ),
          ),
        ],
      ),
    );
  }
}
