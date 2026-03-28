import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:core_prefs/core_prefs.dart';
import 'package:feature_learning/src/srs_review/srs_review_providers.dart';
import '../learning/components/cards/srs_learning_card.dart';
import '../learning/components/cards/srs_grammar_card.dart';
import '../learning/components/srs_action_area.dart';
import '../learning/components/common/nemo_learn_header.dart';
import '../learning/components/common/nemo_completion_view.dart';
import '../domain/learning_session_state.dart';
import '../domain/learning_item.dart';
import '../learning/components/common/nemo_waiting_view.dart';
import '../learning/typing_practice_dialog.dart';
import 'package:core_storage/core_storage.dart';

class SrsReviewScreen extends HookConsumerWidget {
  const SrsReviewScreen({super.key, required this.mode});

  final String mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(srsReviewNotifierProvider(mode));
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
              title: '复习完成！',
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
            body: SafeArea(
              child: NemoWaitingView(
                until: state.waitingUntil,
                onContinue: () => ref.read(srsReviewNotifierProvider(mode).notifier).learnAhead(),
              ),
            ),
          );
        }

        final activeState = state as LearningSessionActive;
        final currentIndex = activeState.currentIndex;
        final isAnswerShown = session.isRevealed(session.currentId);
        
        final autoSpeak = ref.watch(autoSpeakProvider);
        final showAnswerWait = ref.watch(showAnswerWaitProvider);
        final answerWaitDuration = ref.watch(answerWaitDurationProvider);

        final notifier = ref.read(srsReviewNotifierProvider(mode).notifier);

        // Synchronize PageController with state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (pageController.hasClients && pageController.page?.round() != currentIndex) {
            pageController.jumpToPage(currentIndex);
          }
        });

        return Scaffold(
          backgroundColor: isDark ? NemoColors.bgBaseDark : NemoColors.bgBase,
          appBar: NemoLearnHeader(
            title: mode == 'word' ? '单词复习' : '语法复习',
            remainingCount: session.items.length,
            progress: session.progress,
            onClose: () => Navigator.of(context).pop(),
            onPrev: currentIndex > 0 ? () {
              pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } : null,
            onNext: currentIndex < session.items.length - 1 ? () {
              pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } : null,
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
                    final isRevealed = session.currentIndex == index && isAnswerShown;

                    if (item is WordItem) {
                      return SRSLearningCard(
                        word: item.word,
                        isAnswerShown: isRevealed,
                        badge: item.badge,
                        onSpeakWord: () => notifier.playWordAudio(item.word.hiragana),
                        onSpeakExample: (jp, cn, id) => notifier.playExampleAudio(jp, id),
                        onPracticeClick: () {
                          showTypingPracticeDialog(context, ref, word: WordEntry(
                            id: item.word.id,
                            japanese: item.word.japanese,
                            hiragana: item.word.hiragana,
                            chinese: item.word.chinese,
                            level: item.word.level,
                            isFavorite: false,
                          ));
                        },
                        playingAudioId: session.playingAudioId,
                      );
                    } else if (item is GrammarItem) {
                      return SRSGrammarCard(
                        grammar: item.grammar,
                        isAnswerShown: isRevealed,
                        badge: item.badge,
                        onSpeakExample: (jp, cn, id) => notifier.playExampleAudio(jp, id),
                        playingAudioId: session.playingAudioId,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              if (activeState.item is WordItem)
                _AudioWaveIndicator(playingId: session.playingAudioId),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SRSActionArea(
                  showAnswer: isAnswerShown,
                  onShowAnswer: () => notifier.showAnswer(),
                  onRate: (score) => notifier.submitSrsRating(score),
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

class _AudioWaveIndicator extends StatelessWidget {
  const _AudioWaveIndicator({required this.playingId});
  final String? playingId;

  @override
  Widget build(BuildContext context) {
    if (playingId == null) return const SizedBox.shrink();

    return Positioned(
      bottom: 120,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SoundWaveAnimation(color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                playingId == 'word' ? '正在播放发音...' : '正在播放例句...',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
