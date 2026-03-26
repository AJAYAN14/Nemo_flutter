import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'learning_providers.dart';
import '../mock/learning_mock_data.dart';
import 'components/cards/srs_learning_card.dart';
import 'components/cards/srs_grammar_card.dart';
import 'components/srs_action_area.dart';
import 'components/common/nemo_learn_header.dart';

class LearningScreen extends ConsumerWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(learningProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (session.items.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentIndex = session.currentIndex;
    final totalCount = session.items.length;
    
    // In Learning mode, reveal state is per-item
    final currentId = session.currentId;
    final isAnswerShown = session.isRevealed(currentId);
    final remainingCount = totalCount - (currentIndex + 1);

    return Scaffold(
      backgroundColor: isDark ? NemoColors.bgBaseDark : NemoColors.bgBase,
      appBar: NemoLearnHeader(
        title: '单词学习',
        remainingCount: remainingCount,
        progress: session.progress,
        onClose: () => Navigator.of(context).pop(),
        onPrev: () {
          if (currentIndex > 0) {
            ref.read(learningProvider.notifier).onPageChanged(currentIndex - 1);
          }
        },
        onNext: () {
          if (currentIndex < totalCount - 1) {
            ref.read(learningProvider.notifier).onPageChanged(currentIndex + 1);
          }
        },
        canGoPrev: currentIndex > 0,
        canGoNext: currentIndex < totalCount - 1 && isAnswerShown,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              itemCount: totalCount,
              controller: PageController(initialPage: currentIndex),
              physics: isAnswerShown ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
              onPageChanged: (index) {
                ref.read(learningProvider.notifier).onPageChanged(index);
              },
              itemBuilder: (context, index) {
                final item = session.items[index];
                final isShown = session.isRevealed(
                   item is WordItem ? item.word.id : (item as GrammarItem).grammar.id.toString()
                );

                if (item is WordItem) {
                  return SRSLearningCard(
                    word: item.word,
                    isAnswerShown: isShown,
                    badge: CardBadge.fresh,
                  );
                } else if (item is GrammarItem) {
                  return SRSGrammarCard(
                    grammar: item.grammar,
                    isAnswerShown: isShown,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SRSActionArea(
              showAnswer: isAnswerShown,
              onShowAnswer: () => ref.read(learningProvider.notifier).toggleReveal(currentId),
              onRate: (rating) => ref.read(learningProvider.notifier).onRate(rating),
              ratingIntervals: const {
                'again': '<1m',
                'hard': '1d',
                'good': '3d',
                'easy': '7d',
              },
            ),
          ),
        ],
      ),
    );
  }
}
