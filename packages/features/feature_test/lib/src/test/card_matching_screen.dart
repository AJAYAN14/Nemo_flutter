import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/components/card_matching_components.dart';
import '../routes/test_routes.dart';
import 'test_notifier.dart';

class CardMatchingScreen extends HookConsumerWidget {
  const CardMatchingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(testProvider);
    final notifier = ref.read(testProvider.notifier);

    // Listen for test completion to navigate to result screen
    ref.listen(testProvider, (previous, next) {
      if (next.showResult && (previous == null || !previous.showResult) && next.testResult != null) {
        context.pushNamed(
          TestRouteNames.result,
          extra: {
            'result': next.testResult,
            'onRetake': () {
              notifier.startTest(questions: next.questions);
              context.pop();
            },
            'onExit': () {
              context.go(TestRoutePaths.dashboard);
            },
          },
        );
      }
    });
    final question = state.currentQuestion;

    if (question == null || question.matchPairs == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Prepare cards
    final matchPairs = question.matchPairs!;
    // In a real implementation, we would shuffle these every time they are displayed
    // but keep the same shuffle for the same question index.
    final termCards = useMemoized(() => [...matchPairs]..shuffle(), [state.currentIndex]);
    final definitionCards = useMemoized(() => [...matchPairs]..shuffle(), [state.currentIndex]);

    final isComplete = state.matchedCardIds.length == matchPairs.length * 2;
    
    // Auto-advance logic (1.5s delay)
    useEffect(() {
      if (isComplete && !state.isLoading) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (context.mounted && isComplete) {
            notifier.nextMatchSet();
          }
        });
      }
      return null;
    }, [isComplete]);

    final timeLabel = _formatTime(state.timeRemainingSeconds);
    final isTimeLow = state.timeRemainingSeconds <= 60;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          CardMatchingTestHeader(
            onBack: () => context.pop(),
            timeLabel: timeLabel,
            isTimeLow: isTimeLow,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 16, bottom: 100),
              child: CardMatchingContentArea(
                termCards: termCards,
                definitionCards: definitionCards,
                selectedId: state.selectedCardId,
                matchedIds: state.matchedCardIds,
                isError: state.isMatchError,
                onCardTap: notifier.selectCard,
              ),
            ),
          ),
        ],
      ),
      bottomSheet: isComplete || state.isMatchError
          ? MatchingFeedbackPanel(
              isComplete: isComplete,
              errorCount: state.matchErrorCount,
              onNext: notifier.nextMatchSet,
              onFinish: notifier.finishTest,
            )
          : null,
    );
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }
}
