import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_prefs/core_prefs.dart';
import 'package:feature_learning/src/srs_study/srs_study_providers.dart';
import 'package:feature_learning/src/srs_review/srs_review_providers.dart';
import '../learning/components/cards/srs_learning_card.dart';
import '../learning/components/cards/srs_grammar_card.dart';
import '../learning/components/srs_action_area.dart';
import '../learning/components/common/nemo_learn_header.dart';
import '../learning/components/common/nemo_completion_view.dart';
import '../domain/learning_session_state.dart';
import '../domain/learning_item.dart';

class SrsReviewScreen extends ConsumerWidget {
  const SrsReviewScreen({super.key, required this.mode});

  final String mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(srsReviewNotifierProvider(mode));
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer_outlined, size: 80, color: NemoColors.brandBlue),
                  const SizedBox(height: 16),
                  const Text('暂无到期项目', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('下一项将在 ${state.waitingUntil.difference(DateTime.now()).inMinutes} 分钟后开始'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(srsReviewNotifierProvider(mode)),
                    child: const Text('刷新'),
                  ),
                ],
              ),
            ),
          );
        }

        final activeState = state as LearningSessionActive;
        final currentIndex = activeState.currentIndex;
        final isAnswerShown = activeState.isRevealed;
        
        final autoSpeak = ref.watch(autoSpeakProvider);
        final showAnswerWait = ref.watch(showAnswerWaitProvider);
        final answerWaitDuration = ref.watch(answerWaitDurationProvider);

        final notifier = ref.read(srsReviewNotifierProvider(mode).notifier);

        return Scaffold(
          backgroundColor: isDark ? NemoColors.bgBaseDark : NemoColors.bgBase,
          appBar: NemoLearnHeader(
            title: mode == 'word' ? '单词复习' : '语法复习',
            remainingCount: session.items.length,
            progress: session.progress,
            onClose: () => Navigator.of(context).pop(),
            onPrev: () {
              // Note: PageController management could be added if needed, 
              // for now Review is single-item display based on queue.
            },
            onNext: () {
            },
            canGoPrev: currentIndex > 0,
            canGoNext: false, // Review queue is usually consumed one by one
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
                child: Center(
                  child: Builder(
                    builder: (context) {
                      final item = activeState.item;
                      if (item is WordItem) {
                        return SRSLearningCard(
                          word: item.word,
                          isAnswerShown: isAnswerShown,
                          badge: item.badge,
                        );
                      } else if (item is GrammarItem) {
                        return SRSGrammarCard(
                          grammar: item.grammar,
                          isAnswerShown: isAnswerShown,
                          badge: item.badge,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
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
