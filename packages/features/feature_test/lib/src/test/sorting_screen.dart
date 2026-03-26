import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'components/test_header.dart';
import '../routes/test_routes.dart';
import 'components/test_footer.dart';
import 'components/simple_progress_indicator.dart';
import 'components/unified_test_screen.dart';
import '../presentation/components/sorting_test_content.dart';
import 'test_notifier.dart';

class SortingTestScreen extends HookConsumerWidget {
  const SortingTestScreen({super.key});

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
    
    // Track previous index to determine direction for slide animation
    final prevIndex = usePrevious(state.currentIndex) ?? 0;
    final isForward = state.currentIndex >= prevIndex;

    return UnifiedTestScreen(
      headerContent: const TestHeader(),
      progressContent: SimpleProgressIndicator(
        current: state.questions.where((q) => q.isAnswered).length,
        total: state.questions.length,
      ),
      testContent: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final isIncoming = child.key == ValueKey(state.currentIndex);
          
          if (isIncoming) {
            final beginOffset = isForward ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);
            return SlideTransition(
              position: Tween<Offset>(begin: beginOffset, end: Offset.zero)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          } else {
            // Outgoing
            final endOffset = isForward ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
            return SlideTransition(
              position: Tween<Offset>(begin: Offset.zero, end: endOffset)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.easeInCubic)),
              child: child,
            );
          }
        },
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild!,
            ],
          );
        },
        child: SortingTestContent(
          key: ValueKey(state.currentIndex),
        ),
      ),
      footerContent: const TestFooter(),
    );
  }
}
