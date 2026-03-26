import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../test_notifier.dart';

class TestHeader extends ConsumerWidget {
  const TestHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(testProvider);
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  onPressed: () => _confirmExit(context, ref),
                  icon: Icon(
                    Icons.arrow_back,
                    size: 22,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
              ),

              // Timer
              if (state.timeLimitSeconds > 0)
                _TimerDisplay(
                  seconds: state.timeRemainingSeconds,
                  isUrgent: state.timeRemainingSeconds < 60,
                ),

              // Favorite Button (Placeholder logic for now)
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  onPressed: () {
                    // TODO: Implement toggle favorite
                  },
                  icon: const Icon(
                    Icons.favorite_border,
                    size: 24,
                    // Note: TestDanger red would be used if favorite
                  ),
                  color: theme.colorScheme.onBackground,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1, 
          thickness: 1, 
          color: theme.colorScheme.surfaceVariant,
        ),
      ],
    );
  }

  void _confirmExit(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("退出测试"),
        content: const Text("确定要放弃本次测试吗？进度将不会保留。"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("继续测试"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit test screen
            },
            child: Text(
              "退出",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerDisplay extends StatelessWidget {
  final int seconds;
  final bool isUrgent;

  const _TimerDisplay({required this.seconds, required this.isUrgent});

  @override
  Widget build(BuildContext context) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final timeStr = 
        "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        timeStr,
        style: TextStyle(
          fontFamily: 'Monospace',
          fontWeight: FontWeight.bold,
          color: isUrgent ? Colors.red : Theme.of(context).colorScheme.onBackground,
          fontSize: 16,
        ),
      ),
    );
  }
}
