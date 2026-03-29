import '../statistics_models.dart';

abstract class StudyRecordRepository {
  /// Get record for a specific epoch day
  Stream<StudyRecord?> getRecordByDate(int date);

  /// Get today's record
  Stream<StudyRecord?> getTodayRecord(int resetHour);

  /// Get all records sorted by date descending
  Stream<List<StudyRecord>> getAllRecords();

  /// Get records within range [startDate, endDate]
  Stream<List<StudyRecord>> getRecordsBetween(int startDate, int endDate);

  /// Get total unique study days
  Stream<int> getTotalStudyDays();

  /// Get daily activity counts for heatmap [startDate, endDate]
  Stream<Map<int, int>> getDailyActivityCounts(int startDate, int endDate);

  /// Increment stats for today
  Future<void> incrementLearnedWords({int count = 1, required int resetHour});
  Future<void> incrementLearnedGrammars({int count = 1, required int resetHour});
  Future<void> incrementReviewedWords({int count = 1, required int resetHour});
  Future<void> incrementReviewedGrammars({int count = 1, required int resetHour});
  Future<void> incrementSkippedWords({int count = 1, required int resetHour});
  Future<void> incrementSkippedGrammars({int count = 1, required int resetHour});
  Future<void> incrementTestCount({int count = 1, required int resetHour});

  /// Delete logic
  Future<void> deleteByDate(int date);
  Future<void> deleteAll();
}

abstract class StatisticsRepository {
  /// Get combined learning stats
  Stream<LearningStats> getLearningStats(int resetHour);

  /// Get review forecast for coming days
  Stream<List<ReviewForecast>> getReviewForecast(int startDay, int endDay);
  
  /// Get heatmap data (Summary/Level included)
  Stream<List<HeatmapDay>> getHeatmapData();
}
