import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../mock/home_mock_data.dart';

class LearningModeNotifier extends Notifier<LearningMode> {
  @override
  LearningMode build() => LearningMode.words;

  void setMode(LearningMode mode) {
    state = mode;
  }
}

class SelectedLevelNotifier extends Notifier<String> {
  @override
  String build() => 'N2';

  void setLevel(String level) {
    state = level;
  }
}

class HomeViewModel {
  const HomeViewModel({
    required this.mode,
    required this.dateText,
    required this.greeting,
    required this.learned,
    required this.goal,
    required this.reviewed,
    required this.reviewDue,
    required this.accuracy,
    required this.progress,
    required this.levelLabel,
    required this.highlightColor,
  });

  final LearningMode mode;
  final String dateText;
  final String greeting;
  final int learned;
  final int goal;
  final int reviewed;
  final int reviewDue;
  final int accuracy;
  final double progress;
  final String levelLabel;
  final Color highlightColor;
}

final learningModeProvider =
    NotifierProvider<LearningModeNotifier, LearningMode>(
  LearningModeNotifier.new,
);

final selectedLevelProvider =
    NotifierProvider<SelectedLevelNotifier, String>(
  SelectedLevelNotifier.new,
);

final homeMockMapProvider = Provider<Map<LearningMode, HomeMockStats>>(
  (ref) => homeMockStats,
);

final homeViewModelProvider = Provider<HomeViewModel>((ref) {
  final now = DateTime.now();
  final mode = ref.watch(learningModeProvider);
  final selectedLevel = ref.watch(selectedLevelProvider);
  final stats = ref.watch(homeMockMapProvider)[mode] ??
      const HomeMockStats(
        learned: 0,
        goal: 1,
        reviewed: 0,
        reviewDue: 0,
        accuracy: 0,
        levelLabel: 'Error',
        highlightColor: 0xFFEF4444,
      );

  final weekdays = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
  final dateText = '${weekdays[now.weekday % 7]}, ${now.month}月${now.day}日';

  final hour = now.hour;
  final timeGreeting = hour <= 4
      ? '夜深了'
      : hour <= 8
          ? '早上好'
          : hour <= 11
              ? '上午好'
              : hour <= 13
                  ? '中午好'
                  : hour <= 18
                      ? '下午好'
                      : '晚上好';

  final greeting = '$timeGreeting，Nemo';

  return HomeViewModel(
    mode: mode,
    dateText: dateText,
    greeting: greeting,
    learned: stats.learned,
    goal: stats.goal,
    reviewed: stats.reviewed,
    reviewDue: stats.reviewDue,
    accuracy: stats.accuracy,
    progress: stats.goal > 0 ? (stats.learned / stats.goal).clamp(0.0, 1.0) : 0.0,
    levelLabel: selectedLevel, // Use dynamic level
    highlightColor: Color(stats.highlightColor),
  );
});
