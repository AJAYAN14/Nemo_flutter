import 'package:flutter/material.dart';
import 'dart:math' as math;

class NemoSpeakerButton extends StatelessWidget {
  const NemoSpeakerButton({
    super.key,
    required this.isPlaying,
    required this.onClick,
    this.size = 44,
    this.tint,
    this.backgroundColor = Colors.transparent,
  });

  final bool isPlaying;
  final VoidCallback onClick;
  final double size;
  final Color? tint;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final color = tint ?? Theme.of(context).colorScheme.primary;
    final iconSize = size * 0.55;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: onClick,
        customBorder: const CircleBorder(),
        child: Center(
          child: isPlaying
              ? SoundWaveAnimation(color: color, size: iconSize)
              : Icon(
                  Icons.volume_up_rounded,
                  color: color,
                  size: iconSize,
                ),
        ),
      ),
    );
  }
}

class SoundWaveAnimation extends StatefulWidget {
  const SoundWaveAnimation({
    super.key,
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  State<SoundWaveAnimation> createState() => _SoundWaveAnimationState();
}

class _SoundWaveAnimationState extends State<SoundWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _SoundWavePainter(
            color: widget.color,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _SoundWavePainter extends CustomPainter {
  _SoundWavePainter({required this.color, required this.progress});

  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final barWidth = size.width / 5;
    final gap = barWidth * 0.5;
    final totalWidth = 3 * barWidth + 2 * gap;
    final startX = (size.width - totalWidth) / 2;

    // Heights based on Kotlin sound wave logic
    // Bar 1: 0.3 -> 1.0 (400ms approx)
    // Bar 2: 0.6 -> 0.3 (350ms approx)
    // Bar 3: 0.4 -> 0.9 (450ms approx)
    
    // Simple oscillation for each bar
    final bar1H = (0.3 + (0.7 * math.sin(progress * math.pi).abs())) * size.height;
    final bar2H = (0.3 + (0.4 * math.sin((progress + 0.3) * math.pi).abs())) * size.height;
    final bar3H = (0.4 + (0.5 * math.sin((progress + 0.6) * math.pi).abs())) * size.height;

    final heights = [bar1H, bar2H, bar3H];

    for (var i = 0; i < 3; i++) {
      final h = heights[i];
      final x = startX + i * (barWidth + gap);
      final y = (size.height - h) / 2;
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, h),
          Radius.circular(barWidth / 2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SoundWavePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
