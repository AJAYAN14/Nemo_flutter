import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_domain/core_domain.dart';
import 'learning_providers.dart';
import '../domain/learning_item.dart';
import 'components/cards/srs_learning_card.dart';
import 'components/cards/srs_grammar_card.dart';
import 'components/srs_action_area.dart';
import 'components/common/nemo_learn_header.dart';
import 'components/common/nemo_completion_view.dart';
import '../domain/learning_session_state.dart';

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
        final state = session.sessionState;

        if (state is LearningSessionEmpty) {
          return Scaffold(
            body: NemoCompletionView(
              onClose: () => Navigator.of(context).pop(),
            ),
          );
        }

        if (state is LearningSessionWaiting) {
          return Scaffold(
            backgroundColor: isDark ? NemoColors.bgBaseDark : NemoColors.bgBase,
            appBar: NemoLearnHeader(
              title: mode == 'word' ? '单词复习' : '语法复习',
              remainingCount: session.items.length,
              progress: session.progress,
              onClose: () => Navigator.of(context).pop(),
              showMoreMenu: false,
            ),
            body: _WaitingView(
              until: state.waitingUntil,
              onStudyNow: () {
                // Learn ahead by overriding the local check if we want, 
                // but for now just refresh or wait.
                ref.invalidate(learningNotifierProvider(mode));
              },
            ),
          );
        }

        final activeState = state as LearningSessionActive;
        final currentIndex = activeState.currentIndex;
        final currentId = session.currentId;
        final isAnswerShown = activeState.isRevealed;
        
        final item = activeState.item;
        final title = item is WordItem ? '单词学习' : '语法学习';

        // Synchronize PageController with state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (pageController.hasClients && pageController.page?.round() != currentIndex) {
            pageController.jumpToPage(currentIndex);
          }
        });

        final notifier = ref.read(learningNotifierProvider(mode).notifier);

        return Scaffold(
          backgroundColor: isDark ? NemoColors.bgBaseDark : NemoColors.bgBase,
          appBar: NemoLearnHeader(
            title: title,
            remainingCount: session.items.length,
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
              if (currentIndex < session.items.length - 1) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            canGoPrev: currentIndex > 0,
            canGoNext: currentIndex < session.items.length - 1,
            onUndo: session.lastSnapshot != null ? () => notifier.undo() : null,
            onSuspend: () => notifier.suspendCurrent(),
            onBury: () => notifier.buryCurrent(),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: PageView.builder(
                  key: ValueKey(session.items.length), 
                  itemCount: session.items.length,
                  controller: pageController,
                  physics: isAnswerShown ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    notifier.onPageChanged(index);
                  },
                  itemBuilder: (context, index) {
                    final item = session.items[index];
                    final isShown = session.currentIndex == index && isAnswerShown;

                    if (item is WordItem) {
                      return SRSLearningCard(
                        word: item.word,
                        isAnswerShown: isShown,
                        badge: item.progress == null ? CardBadge.fresh : CardBadge.review,
                        onSpeakWord: () => _handleSpeak(item.word.japanese),
                        onSpeakExample: (jp, cn, id) => _handleSpeak(jp),
                        onPracticeClick: () => _handlePractice(item.word),
                      );
                    } else if (item is GrammarItem) {
                      return SRSGrammarCard(
                        grammar: item.grammar,
                        isAnswerShown: isShown,
                        onSpeakExample: (jp, cn, id) => _handleSpeak(jp),
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
                  onShowAnswer: () => notifier.toggleReveal(currentId),
                  onRate: (rating) => notifier.onRate(rating),
                  ratingIntervals: session.ratingIntervals,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSpeak(String text) {
    // TODO: Connect to TTS Service
    debugPrint('Speaking: $text');
  }

  void _handlePractice(Word word) {
    // TODO: Open practice dialog or screen
    debugPrint('Practice for: ${word.japanese}');
  }
}

class _WaitingView extends StatelessWidget {
  const _WaitingView({required this.until, required this.onStudyNow});
  final DateTime until;
  final VoidCallback onStudyNow;

  @override
  Widget build(BuildContext context) {
    final diff = until.difference(DateTime.now());
    final minutes = diff.inMinutes;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons. coffee_rounded, size: 80, color: NemoColors.brandBlue),
          const SizedBox(height: 24),
          const Text(
            '休息一下吧',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: NemoColors.textMain),
          ),
          const SizedBox(height: 8),
          Text(
            '下一项将在 $minutes 分钟后开始',
            style: const TextStyle(fontSize: 16, color: NemoColors.textMuted),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: onStudyNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: NemoColors.brandBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('提前开始学习', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
