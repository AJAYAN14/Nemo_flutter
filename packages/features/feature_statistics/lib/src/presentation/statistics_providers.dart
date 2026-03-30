import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_prefs/core_prefs.dart';
import 'package:core_storage/core_storage.dart';

part 'statistics_providers.g.dart';

@riverpod
Stream<LearningStats> dashboardStats(DashboardStatsRef ref) {
  final resetHour = ref.watch(resetHourProvider);
  final repository = ref.watch(statisticsRepositoryProvider);
  
  final wordGoal = ref.watch(wordGoalProvider);
  final grammarGoal = ref.watch(grammarGoalProvider);

  return repository.getLearningStats(resetHour).map((stats) {
    return stats.copyWith(
      wordDailyGoal: wordGoal,
      grammarDailyGoal: grammarGoal,
    );
  });
}
