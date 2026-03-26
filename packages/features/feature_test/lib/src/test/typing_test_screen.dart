import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'components/test_header.dart';
import '../routes/test_routes.dart';
import 'components/test_footer.dart';
import 'components/simple_progress_indicator.dart';
import 'components/unified_test_screen.dart';
import '../presentation/components/typing_test_content.dart';
import 'test_notifier.dart';

class TypingTestScreen extends HookConsumerWidget {
  const TypingTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(testProvider);
    final notifier = ref.read(testProvider.notifier);
    
    // Track previous index to determine direction
    final prevIndex = usePrevious(state.currentIndex) ?? 0;
    final isForward = state.currentIndex >= prevIndex;
 
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
    if (question == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return UnifiedTestScreen(
      headerContent: const TestHeader(),
      progressContent: SimpleProgressIndicator(
        current: state.questions.where((q) => q.isAnswered).length,
        total: state.questions.length,
      ),
      testContent: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final offset = isForward 
              ? Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
              : Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero);

          final isIncoming = child.key == ValueKey(state.currentIndex);
          
          if (isIncoming) {
            return SlideTransition(
              position: offset.animate(animation),
              child: child,
            );
          } else {
            // Outgoing
            final exitOffset = isForward
                ? Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                : Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero);
            
            return SlideTransition(
              position: exitOffset.animate(animation),
              child: child,
            );
          }
        },
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        child: TypingTestContent(
          key: ValueKey(state.currentIndex),
          question: question,
          userInput: state.userTypingInput,
          onInputChange: notifier.onTypingInputChange,
        ),
      ),
      footerContent: const TestFooter(),
    );
  }
}
