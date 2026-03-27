import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'learning_providers.dart';
import '../domain/learning_item.dart';
import 'components/cards/srs_learning_card.dart';
import 'components/cards/srs_grammar_card.dart';
import 'components/srs_action_area.dart';
import 'components/common/nemo_learn_header.dart';
import 'components/common/nemo_completion_view.dart';

class LearningScreen extends HookConsumerWidget {
  const LearningScreen({super.key, required this.mode});

  final String mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(learningNotifierProvider(mode));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageController = usePageController();

    return sessionAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (session) {
        if (session.items.isEmpty) {
          return Scaffold(
            body: NemoCompletionView(
              onClose: () => Navigator.of(context).pop(),
            ),
          );
        }

        final currentIndex = session.currentIndex;
        final totalCount = session.items.length;
        final currentId = session.currentId;
        final isAnswerShown = session.isRevealed(currentId);
        final remainingCount = totalCount;

        final item = session.items[currentIndex];
        final title = item is WordItem ? '单词学习' : '语法学习';

        // Synchronize PageController with state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (pageController.hasClients && pageController.page?.round() != currentIndex) {
            pageController.jumpToPage(currentIndex);
          }
        });

        return Scaffold(
          backgroundColor: isDark ? NemoColors.bgBaseDark : NemoColors.bgBase,
          appBar: NemoLearnHeader(
            title: title,
            remainingCount: remainingCount,
            progress: session.progress,
            onClose: () => Navigator.of(context).pop(),
            onPrev: () {
              if (currentIndex > 0) {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            onNext: () {
              if (currentIndex < totalCount - 1) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            canGoPrev: currentIndex > 0,
            canGoNext: currentIndex < totalCount - 1,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: PageView.builder(
                  key: ValueKey(session.items.length), // Rebuild if queue size changes substantially
                  itemCount: totalCount,
                  controller: pageController,
                  physics: isAnswerShown ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    ref.read(learningNotifierProvider(mode).notifier).onPageChanged(index);
                  },
                  itemBuilder: (context, index) {
                    final item = session.items[index];
                    final isShown = session.isRevealed(
                       item is WordItem ? item.word.id : (item as GrammarItem).grammar.id
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
                  onShowAnswer: () => ref.read(learningNotifierProvider(mode).notifier).toggleReveal(currentId),
                  onRate: (rating) => ref.read(learningNotifierProvider(mode).notifier).onRate(rating),
                  ratingIntervals: session.ratingIntervals,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
