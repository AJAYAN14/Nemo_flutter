import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';

class PremiumCard extends StatefulWidget {
  const PremiumCard({
    super.key,
    this.onClick,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.borderRadius,
  });

  final VoidCallback? onClick;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onClick != null) _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onClick != null) _controller.reverse();
  }

  void _handleTapCancel() {
    if (widget.onClick != null) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // V2 Styling: White/SurfaceContainer + Soft Shadow
    final containerColor = isDark ? Theme.of(context).colorScheme.surfaceContainer : Colors.white;
    final borderRadius = widget.borderRadius ?? NemoMetrics.radius(24);
    
    final shadowElevation = isDark ? 2.0 : 8.0;
    final shadowColor = isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05);

    Widget card = Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: borderRadius,
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: shadowElevation * 2,
            offset: Offset(0, shadowElevation / 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Padding(
          padding: widget.padding,
          child: widget.child,
        ),
      ),
    );

    if (widget.onClick != null) {
      return GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onClick,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: card,
        ),
      );
    }

    return card;
  }
}

class SquircleListItem extends StatelessWidget {
  const SquircleListItem({
    super.key,
    required this.icon,
    this.iconColor,
    this.iconBgColor,
    required this.title,
    this.subtitle,
    this.onClick,
    this.trailing,
    this.showDivider = true,
  });

  final IconData icon;
  final Color? iconColor;
  final Color? iconBgColor;
  final String title;
  final String? subtitle;
  final VoidCallback? onClick;
  final Widget? trailing;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = iconColor ?? theme.colorScheme.primary;
    final bgColor = iconBgColor ?? color.withOpacity(0.15);

    return InkWell(
      onTap: onClick,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Squircle-like Icon Container (12dp radius)
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                    ),
              ],
            ),
          ),
          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(left: 74), // Align with text
              child: Divider(
                height: 0.5,
                thickness: 0.5,
                color: theme.colorScheme.outlineVariant.withOpacity(0.2),
              ),
            ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}
