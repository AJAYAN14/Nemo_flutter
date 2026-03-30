import 'dart:ui';

import 'package:flutter/material.dart';

class NemoMainShell extends StatelessWidget {
  const NemoMainShell({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: _CapsuleNavigationBar(
        currentIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}

class _CapsuleNavigationBar extends StatelessWidget {
  const _CapsuleNavigationBar({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    // 自动适配深浅色模式的毛玻璃底色
    final isDark = Theme.of(context).colorScheme.surface.computeLuminance() < 0.5;
    
    // 玻璃基础色与特效
    final glassColor = isDark 
        ? Colors.black.withOpacity(0.7) 
        : Colors.white.withOpacity(0.7);
    final borderColor = isDark
        ? Colors.white.withOpacity(0.12)
        : Colors.white.withOpacity(0.6);
    final innerShadowColor = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.white.withOpacity(0.4);

    return SafeArea(
      bottom: false,
      child: Container(
        height: 70,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
            // 内部高光，模拟玻璃质感
            BoxShadow(
              color: innerShadowColor,
              blurRadius: 1,
              offset: const Offset(0, 1),
              blurStyle: BlurStyle.inner,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: glassColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _NavItem(
                      icon: Icons.menu_book_rounded,
                      label: '学习',
                      isSelected: currentIndex == 0,
                      onTap: () => onDestinationSelected(0),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.bar_chart_rounded,
                      label: '进度',
                      isSelected: currentIndex == 1,
                      onTap: () => onDestinationSelected(1),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.interests_rounded,
                      label: '测试',
                      isSelected: currentIndex == 2,
                      onTap: () => onDestinationSelected(2),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.account_circle_rounded,
                      label: '个人',
                      isSelected: currentIndex == 3,
                      onTap: () => onDestinationSelected(3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).colorScheme.surface.computeLuminance() < 0.5;
    
    // 激活态的高反色效果
    final activeBgColor = isDark ? Colors.white : const Color(0xFF111827);
    final activeContentColor = isDark ? const Color(0xFF111827) : Colors.white;
    final inactiveIconColor = const Color(0xFF9CA3AF);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: const Cubic(0.34, 1.56, 0.64, 1), // Apple-like spring 原型曲线
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? activeBgColor : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected ? activeContentColor : inactiveIconColor,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: const Cubic(0.34, 1.56, 0.64, 1),
                child: isSelected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: activeContentColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
