import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_prefs/core_prefs.dart';
import 'package:feature_learning/src/srs_study/srs_study_providers.dart';
import '../domain/learning_item.dart';
import '../learning/components/cards/srs_learning_card.dart';
import '../learning/components/cards/srs_grammar_card.dart';
import '../learning/components/srs_action_area.dart';
import '../learning/components/common/nemo_learn_header.dart';
import '../learning/components/common/nemo_completion_view.dart';
import '../domain/learning_session_state.dart';
import '../learning/typing_practice_dialog.dart';
import 'package:core_storage/core_storage.dart';

class SrsStudyScreen extends HookConsumerWidget {
  const SrsStudyScreen({super.key, required this.mode});

  final String mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(srsStudyNotifierProvider(mode));
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
                ref.invalidate(srsStudyNotifierProvider(mode));
              },
            ),
          );
        }

        final activeState = state as LearningSessionActive;
        final currentIndex = activeState.currentIndex;
        final currentId = session.currentId;
        final isAnswerShown = session.isRevealed(currentId);
        
        final autoSpeak = ref.watch(autoSpeakProvider);
        final showAnswerWait = ref.watch(showAnswerWaitProvider);
        final answerWaitDuration = ref.watch(answerWaitDurationProvider);

        // Synchronize PageController with state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (pageController.hasClients && pageController.page?.round() != currentIndex) {
            pageController.jumpToPage(currentIndex);
          }
        });

        final notifier = ref.read(srsStudyNotifierProvider(mode).notifier);

        return Scaffold(
          backgroundColor: isDark ? NemoColors.bgBaseDark : NemoColors.bgBase,
          appBar: NemoLearnHeader(
            title: activeState.item is WordItem ? '单词学习' : '语法学习',
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
            autoReadEnabled: autoSpeak,
            onToggleAutoRead: (val) => ref.read(autoSpeakProvider.notifier).toggle(),
            showAnswerWaitEnabled: showAnswerWait,
            onToggleShowAnswerWait: (val) => ref.read(showAnswerWaitProvider.notifier).toggle(),
            answerWaitDuration: answerWaitDuration.toDouble(),
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
                        badge: item.badge,
                        onSpeakWord: () => notifier.playWordAudio(item.word.hiragana),
                        onSpeakExample: (jp, cn, id) => notifier.playExampleAudio(jp),
                        onPracticeClick: () {
                          // Note: showTypingPracticeDialog needs a WordEntry
                          // Word domain object needs to be converted or we need to find the entry.
                          // For now, I'll assume we can pass the word or implement a conversion.
                          // Based on typing_practice_dialog.dart, it takes WordEntry.
                          // I'll check if the item contains the entry.
                          showTypingPracticeDialog(context, ref, word: WordEntry(
                            id: item.word.id,
                            japanese: item.word.japanese,
                            hiragana: item.word.hiragana,
                            chinese: item.word.chinese,
                            level: item.word.level,
                            isFavorite: false, // Defaulting as we don't have it in the card model yet
                          ));
                        },
                      );
                    } else if (item is GrammarItem) {
                      return SRSGrammarCard(
                        grammar: item.grammar,
                        isAnswerShown: isShown,
                        badge: item.badge,
                        onSpeakExample: (jp, cn, id) => notifier.playExampleAudio(jp),
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
                  onShowAnswer: () => notifier.showAnswer(currentId),
                  onRate: (rating) => notifier.submitSrsRating(rating),
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
