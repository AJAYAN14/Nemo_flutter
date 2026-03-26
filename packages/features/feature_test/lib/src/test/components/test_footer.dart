import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../test_notifier.dart';

class TestFooter extends ConsumerWidget {
  const TestFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(testProvider);
    final currentQuestion = state.currentQuestion;

    if (currentQuestion == null) return const SizedBox.shrink();

    final isAnswered = currentQuestion.isAnswered;
    final isLast = state.isLastQuestion;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          // Previous Button
          Expanded(
            child: _AnimatedButton(
              text: "上一题",
              onPressed: () => ref.read(testProvider.notifier).previousQuestion(),
              enabled: state.currentIndex > 0,
              isOutlined: true,
            ),
          ),
          
          const SizedBox(width: 12),

          // Main Action Button (Submit / Next / Finish)
          Expanded(
            child: _AnimatedButton(
              text: _getButtonText(isAnswered, isLast),
              onPressed: () {
                if (!isAnswered) {
                  ref.read(testProvider.notifier).submitAnswer();
                } else if (!isLast) {
                  ref.read(testProvider.notifier).nextQuestion();
                } else {
                  ref.read(testProvider.notifier).finishTest();
                }
              },
              enabled: (isAnswered || state.selectedOptionIndex != -1) && !state.isAutoAdvancing,
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText(bool isAnswered, bool isLast) {
    if (!isAnswered) return "提交";
    if (isLast) return "完成测试";
    return "下一题";
  }
}

class _AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool enabled;
  final bool isOutlined;

  const _AnimatedButton({
    required this.text,
    required this.onPressed,
    required this.enabled,
    this.isOutlined = false,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Opacity(
      opacity: widget.enabled ? 1.0 : 0.4, // Slightly higher opacity for visibility
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          height: 50,
          child: widget.isOutlined
              ? OutlinedButton(
                  onPressed: widget.enabled ? widget.onPressed : null,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedCornerShape(16),
                    side: BorderSide(color: theme.colorScheme.primary),
                  ),
                  onLongPress: null, // To trigger tap down/up logic
                  child: _buildChild(),
                )
              : ElevatedButton(
                  onPressed: widget.enabled ? widget.onPressed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedCornerShape(16),
                  ),
                  child: _buildChild(),
                ),
        ),
      ),
    );
  }

  Widget _buildChild() {
    return Listener(
      onPointerDown: (_) => widget.enabled ? _controller.forward() : null,
      onPointerUp: (_) => _controller.reverse(),
      onPointerCancel: (_) => _controller.reverse(),
      child: Center(
        child: Text(
          widget.text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}

// Helper for RoundedCornerShape equivalent in Flutter
class RoundedCornerShape extends RoundedRectangleBorder {
  RoundedCornerShape(double radius) : super(borderRadius: BorderRadius.circular(radius));
}
