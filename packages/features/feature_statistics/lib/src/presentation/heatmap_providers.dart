import 'dart:math';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_prefs/core_prefs.dart';
import 'package:core_storage/core_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'heatmap_providers.freezed.dart';
part 'heatmap_providers.g.dart';

@freezed
class HeatmapUiState with _$HeatmapUiState {
  const factory HeatmapUiState({
    @Default([]) List<HeatmapDay> heatmapData,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default(0) int totalActiveDays,
    @Default(0) int bestDayCount,
    @Default(0) int bestDayDate,
    @Default(0) int dailyAverage,
    @Default(true) bool isLoading,
  }) = _HeatmapUiState;
}

@riverpod
Stream<HeatmapUiState> heatmapUiState(HeatmapUiStateRef ref) {
  final resetHour = ref.watch(resetHourProvider);
  return ref.watch(statisticsRepositoryProvider).getHeatmapData(resetHour).map((heatmap) {
    if (heatmap.isEmpty) return const HeatmapUiState(isLoading: false);

    final activeDays = heatmap.where((d) => d.count > 0).toList();
    final totalActiveDays = activeDays.length;
    final totalCount = activeDays.fold(0, (sum, d) => sum + d.count);
    final dailyAverage = totalActiveDays > 0 ? (totalCount / totalActiveDays).round() : 0;

    final bestDay = activeDays.isEmpty 
        ? null 
        : activeDays.reduce((a, b) => a.count > b.count ? a : b);
    
    final bestDayCount = bestDay?.count ?? 0;
    final bestDayDate = bestDay?.date ?? 0;

    // Calculate Streaks
    final sortedActiveDates = activeDays.map((d) => d.date).toList()..sort();
    
    int currentStreak = 0;
    int maxStreak = 0;
    int tempStreak = 0;
    int lastDate = -1;

    for (final date in sortedActiveDates) {
      if (lastDate == -1) {
        tempStreak = 1;
      } else if (date == lastDate + 1) {
        tempStreak++;
      } else {
        maxStreak = max(maxStreak, tempStreak);
        tempStreak = 1;
      }
      lastDate = date;
    }
    maxStreak = max(maxStreak, tempStreak);

    // Current Streak logic
    final todayEpoch = DateTimeUtils.getLearningDay(resetHour);
    final isTodayActive = sortedActiveDates.contains(todayEpoch);
    final isYesterdayActive = sortedActiveDates.contains(todayEpoch - 1);

    if (isTodayActive) {
      int streak = 0;
      int checkDate = todayEpoch;
      while (sortedActiveDates.contains(checkDate)) {
        streak++;
        checkDate--;
      }
      currentStreak = streak;
    } else if (isYesterdayActive) {
      int streak = 0;
      int checkDate = todayEpoch - 1;
      while (sortedActiveDates.contains(checkDate)) {
        streak++;
        checkDate--;
      }
      currentStreak = streak;
    } else {
      currentStreak = 0;
    }

    return HeatmapUiState(
      heatmapData: heatmap,
      currentStreak: currentStreak,
      longestStreak: maxStreak,
      totalActiveDays: totalActiveDays,
      bestDayCount: bestDayCount,
      bestDayDate: bestDayDate,
      dailyAverage: dailyAverage,
      isLoading: false,
    );
  });
}
