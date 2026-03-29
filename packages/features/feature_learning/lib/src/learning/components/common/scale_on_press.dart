import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ScaleOnPress extends HookWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double targetScale;

  const ScaleOnPress({
    super.key,
    required this.child,
    this.onTap,
    this.targetScale = 0.95,
  });

  @override
  Widget build(BuildContext context) {
    final isPressed = useState(false);
    
    return GestureDetector(
      onTapDown: (_) => isPressed.value = true,
      onTapUp: (_) => isPressed.value = false,
      onTapCancel: () => isPressed.value = false,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: isPressed.value ? targetScale : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: child,
      ),
    );
  }
}
