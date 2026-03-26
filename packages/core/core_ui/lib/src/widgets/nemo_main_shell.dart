import 'package:core_designsystem/core_designsystem.dart';
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
    final isDark = Theme.of(context).colorScheme.surface.computeLuminance() < 0.5;
    final navColor = isDark ? const Color(0xFF2C2C2C) : Colors.white;

    return Scaffold(
      body: child,
      bottomNavigationBar: ClipRRect(
        borderRadius: NemoMetrics.topRadius16,
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: navColor,
            height: NemoMetrics.navHeight,
            indicatorColor: NemoColors.brandBlue.withValues(alpha: 0.12),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? NemoColors.brandBlue : Colors.grey,
              );
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return IconThemeData(
                color: selected ? NemoColors.brandBlue : Colors.grey,
                size: 24,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.menu_book_rounded),
                label: '学习',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_rounded),
                label: '进度',
              ),
              NavigationDestination(
                icon: Icon(Icons.interests_rounded),
                label: '测试',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_circle_rounded),
                label: '个人',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
