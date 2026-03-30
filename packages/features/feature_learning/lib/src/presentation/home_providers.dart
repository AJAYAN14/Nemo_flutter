import 'package:flutter/material.dart';
import 'package:core_prefs/core_prefs.dart';
import 'package:core_storage/core_storage.dart';
import 'package:core_domain/core_domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../mock/home_mock_data.dart';

part 'home_providers.g.dart';

@riverpod
class LearningModeNotifier extends _$LearningModeNotifier {
  @override
  LearningMode build() {
    final lastMode = ref.watch(lastLearningModeProvider);
    return lastMode == 'words' ? LearningMode.words : LearningMode.grammar;
  }

  Future<void> setMode(LearningMode mode) async {
    await ref.read(lastLearningModeProvider.notifier).set(mode.name);
  }
}

@riverpod
class SelectedLevelNotifier extends _$SelectedLevelNotifier {
  @override
  String build() {
    final mode = ref.watch(learningModeNotifierProvider);
    if (mode == LearningMode.words) {
      return ref.watch(wordLevelProvider);
    } else {
      return ref.watch(grammarLevelProvider);
    }
  }

  Future<void> setLevel(String level) async {
    final mode = ref.read(learningModeNotifierProvider);
    if (mode == LearningMode.words) {
      await ref.read(wordLevelProvider.notifier).set(level);
    } else {
      await ref.read(grammarLevelProvider.notifier).set(level);
    }
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

@riverpod
FutureOr<HomeViewModel> homeViewModel(Ref ref) async {
  final now = DateTime.fromMillisecondsSinceEpoch(DateTimeUtils.getCurrentCompensatedMillis());
  final mode = ref.watch(learningModeNotifierProvider);
  final selectedLevel = ref.watch(selectedLevelNotifierProvider);
  final wordGoal = ref.watch(wordGoalProvider);
  final grammarGoal = ref.watch(grammarGoalProvider);
  final resetHour = ref.watch(resetHourProvider);

  // Watch the statistics stream for real-time updates
  final statsAsync = ref.watch(todayStatsProvider);
  final stats = statsAsync.valueOrNull ?? LearningStats.initial;

  final learnedCount = mode == LearningMode.words ? stats.todayLearnedWords : stats.todayLearnedGrammars;
  final reviewedTotal = mode == LearningMode.words ? stats.todayReviewedWords : stats.todayReviewedGrammars;
  final dueCount = mode == LearningMode.words ? stats.dueWords : stats.dueGrammars;
  final goal = mode == LearningMode.words ? wordGoal : grammarGoal;
  
  // UI formatting
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
    learned: learnedCount,
    goal: goal,
    reviewed: reviewedTotal,
    reviewDue: dueCount,
    accuracy: goal > 0 ? ((learnedCount / goal) * 100).toInt().clamp(0, 100) : 0, 
    progress: goal > 0 ? (learnedCount / goal).clamp(0.0, 1.0) : 0.0,
    levelLabel: selectedLevel,
    highlightColor: mode == LearningMode.words ? const Color(0xFFF97316) : const Color(0xFF059669),
  );
}

@riverpod
Stream<LearningStats> todayStats(Ref ref) {
  final resetHour = ref.watch(resetHourProvider);
  return ref.watch(statisticsRepositoryProvider).getLearningStats(resetHour);
}
