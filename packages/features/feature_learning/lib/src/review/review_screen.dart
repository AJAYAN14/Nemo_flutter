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
    final sessionAsync = ref.watch(reviewNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return sessionAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (session) {
        if (session.isCompleted) {
          return Scaffold(
            backgroundColor: isDark ? NemoColors.bgBaseDark : NemoColors.bgBase,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: NemoColors.textMain),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: const Center(child: Text('复学完成！', style: TextStyle(color: NemoColors.textSub, fontSize: 18))),
          );
        }

        if (session.items.isEmpty) {
          return Scaffold(
            backgroundColor: isDark ? NemoColors.bgBaseDark : NemoColors.bgBase,
            body: const Center(child: Text('当前没有需要复习的内容', style: TextStyle(color: NemoColors.textSub))),
          );
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
            onPrev: null,
            onNext: null,
            canGoPrev: false,
            canGoNext: false,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: PageView.builder(
                  key: ValueKey(session.items.hashCode),
                  itemCount: totalCount,
                  controller: PageController(initialPage: currentIndex),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = session.items[index];
                    
                    Widget card = const SizedBox.shrink();
                    
                    item.map(
                      word: (w) {
                        card = SRSLearningCard(
                          word: w.word,
                          isAnswerShown: index == currentIndex ? isAnswerShown : false,
                          badge: CardBadge.review,
                        );
                      },
                      grammar: (g) {
                        card = SRSGrammarCard(
                          grammar: g.grammar,
                          isAnswerShown: index == currentIndex ? isAnswerShown : false,
                        );
                      },
                    );

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
                  onShowAnswer: () => ref.read(reviewNotifierProvider.notifier).showAnswer(),
                  onRate: (score) {
                    final rating = switch (score) {
                      0 => ReviewRating.again,
                      1 => ReviewRating.hard,
                      2 => ReviewRating.good,
                      _ => ReviewRating.easy,
                    };
                    ref.read(reviewNotifierProvider.notifier).rate(rating);
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
      },
    );
  }
}
