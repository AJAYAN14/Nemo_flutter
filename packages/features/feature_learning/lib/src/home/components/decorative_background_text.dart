import 'package:flutter/material.dart';

class DecorativeBackgroundText extends StatelessWidget {
  const DecorativeBackgroundText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.offsetX,
    required this.offsetY,
    required this.rotationDegrees,
    this.alpha = 0.03,
  });

  final String text;
  final double fontSize;
  final double offsetX;
  final double offsetY;
  final double rotationDegrees;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    final radians = rotationDegrees * (3.141592653589793 / 180.0);
    return Positioned(
      right: offsetX < 0 ? null : -offsetX,
      left: offsetX < 0 ? offsetX : null,
      top: offsetY,
      child: Transform.rotate(
        angle: radians,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'serif',
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: alpha),
            height: 1.0,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
