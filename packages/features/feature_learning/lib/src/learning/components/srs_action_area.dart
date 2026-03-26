import 'package:flutter/material.dart';
import 'srs_rating_button.dart';

class SRSActionArea extends StatelessWidget {
  const SRSActionArea({
    super.key,
    required this.showAnswer,
    required this.onShowAnswer,
    required this.onRate,
    this.ratingIntervals,
  });

  final bool showAnswer;
  final VoidCallback onShowAnswer;
  final Function(int) onRate;
  final Map<String, String>? ratingIntervals;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    // 100% 1:1 Floating Design: 
    // No background on the main container, only on the buttons themselves.
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding + 16),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: !showAnswer
            ? _ShowAnswerButton(onPressed: onShowAnswer)
            : Row(
                key: const ValueKey('rating_buttons'),
                children: [
                  SRSRatingButton(
                    type: SRSRatingType.again,
                    label: '重来',
                    interval: ratingIntervals?['again'] ?? '<1m',
                    onPressed: () => onRate(0),
                  ),
                  const SizedBox(width: 8),
                  SRSRatingButton(
                    type: SRSRatingType.hard,
                    label: '困难',
                    interval: ratingIntervals?['hard'] ?? '1d',
                    onPressed: () => onRate(1),
                  ),
                  const SizedBox(width: 8),
                  SRSRatingButton(
                    type: SRSRatingType.good,
                    label: '良好',
                    interval: ratingIntervals?['good'] ?? '3d',
                    onPressed: () => onRate(2),
                  ),
                  const SizedBox(width: 8),
                  SRSRatingButton(
                    type: SRSRatingType.easy,
                    label: '简单',
                    interval: ratingIntervals?['easy'] ?? '7d',
                    onPressed: () => onRate(3),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ShowAnswerButton extends StatefulWidget {
  const _ShowAnswerButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<_ShowAnswerButton> createState() => _ShowAnswerButtonState();
}

class _ShowAnswerButtonState extends State<_ShowAnswerButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.reverse(),
        onTapUp: (_) {
          _controller.forward();
          widget.onPressed();
        },
        onTapCancel: () => _controller.forward(),
        child: Container(
          width: double.infinity,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // Use 1:1 Dark/Gray colors for the button itself
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFF111827),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFFFACC15), size: 18),
              SizedBox(width: 8),
              Text(
                '显示答案',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
