import 'package:flutter/material.dart';
import 'package:core_designsystem/core_designsystem.dart';
import './scale_on_press.dart';

class LevelIndicator extends StatelessWidget {
  final String level;
  final VoidCallback onClick;

  const LevelIndicator({
    super.key,
    required this.level,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleOnPress(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE6F0FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'JLPT $level',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: NemoColors.brandBlue, // NemoPrimary in Kotlin
          ),
        ),
      ),
    );
  }
}

class GrammarSubHeader extends StatelessWidget {
  final bool isGrammarDailyGoalMet;
  final int todayLearnedGrammarCount;
  final int grammarDailyGoal;
  final String selectedGrammarLevel;
  final VoidCallback onLevelClick;

  const GrammarSubHeader({
    super.key,
    required this.isGrammarDailyGoalMet,
    required this.todayLearnedGrammarCount,
    required this.grammarDailyGoal,
    required this.selectedGrammarLevel,
    required this.onLevelClick,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (grammarDailyGoal - todayLearnedGrammarCount).clamp(0, grammarDailyGoal);
    final grammarProgressText = isGrammarDailyGoalMet ? '今日已完成' : '剩余 $remaining / $grammarDailyGoal';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            grammarProgressText,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          LevelIndicator(
            level: selectedGrammarLevel,
            onClick: onLevelClick,
          ),
        ],
      ),
    );
  }
}
