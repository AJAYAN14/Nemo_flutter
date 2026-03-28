import 'package:flutter/material.dart';
import 'package:core_designsystem/core_designsystem.dart';

enum SRSRatingType {
  again,
  hard,
  good,
  easy;
}

class SRSRatingButton extends StatefulWidget {
  const SRSRatingButton({
    super.key,
    required this.label,
    required this.type,
    this.interval,
    required this.onPressed,
  });

  final String label;
  final SRSRatingType type;
  final String? interval;
  final VoidCallback onPressed;

  @override
  State<SRSRatingButton> createState() => _SRSRatingButtonState();
}

class _SRSRatingButtonState extends State<SRSRatingButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final (textColor, bgColor) = switch (widget.type) {
      SRSRatingType.again => isDark 
          ? (NemoColors.srsRoseTextDark, NemoColors.srsRoseBgDark)
          : (NemoColors.srsRoseText, NemoColors.srsRoseBg),
      SRSRatingType.hard => isDark
          ? (NemoColors.srsOrangeTextDark, NemoColors.srsOrangeBgDark)
          : (NemoColors.srsOrangeText, NemoColors.srsOrangeBg),
      SRSRatingType.good => isDark
          ? (NemoColors.srsBlueTextDark, NemoColors.srsBlueBgDark)
          : (NemoColors.srsBlueText, NemoColors.srsBlueBg),
      SRSRatingType.easy => isDark
          ? (NemoColors.srsEmeraldTextDark, NemoColors.srsEmeraldBgDark)
          : (NemoColors.srsEmeraldText, NemoColors.srsEmeraldBg),
    };

    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => _controller.reverse(), // Scale down
        onTapUp: (_) {
          _controller.forward(); // Scale up
          widget.onPressed();
        },
        onTapCancel: () => _controller.forward(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            height: 58,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: textColor.withValues(alpha: 0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : textColor).withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (widget.interval != null)
                  Text(
                    widget.interval!,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
