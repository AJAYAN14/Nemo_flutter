import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics_models.freezed.dart';
part 'statistics_models.g.dart';

@freezed
class LearningStats with _$LearningStats {
  const factory LearningStats({
    required int dailyStreak,
    required int totalStudyDays,
    required int todayLearnedWords,
    required int todayLearnedGrammars,
    required int todayReviewedWords,
    required int todayReviewedGrammars,
    required int masteredWords,
    required int masteredGrammars,
    required int dueWords,
    required int dueGrammars,
    @Default(50) int wordDailyGoal,
    @Default(10) int grammarDailyGoal,
    @Default(0) int totalWords,
    @Default(0) int totalGrammars,
    @Default(0) int weekStudyDays,
  }) = _LearningStats;

  const LearningStats._();

  int get todayTotalLearned => todayLearnedWords + todayLearnedGrammars;
  int get todayTotalReviewed => todayReviewedWords + todayReviewedGrammars;
  int get totalMastered => masteredWords + masteredGrammars;
  int get totalDue => dueWords + dueGrammars;

  factory LearningStats.fromJson(Map<String, dynamic> json) => _$LearningStatsFromJson(json);

  static const initial = LearningStats(
    dailyStreak: 0,
    totalStudyDays: 0,
    todayLearnedWords: 0,
    todayLearnedGrammars: 0,
    todayReviewedWords: 0,
    todayReviewedGrammars: 0,
    masteredWords: 0,
    masteredGrammars: 0,
    dueWords: 0,
    dueGrammars: 0,
  );
}

@freezed
class StudyRecord with _$StudyRecord {
  const factory StudyRecord({
    /// Epoch Day
    required int date,
    @Default(0) int learnedWords,
    @Default(0) int learnedGrammars,
    @Default(0) int reviewedWords,
    @Default(0) int reviewedGrammars,
    @Default(0) int skippedWords,
    @Default(0) int skippedGrammars,
    @Default(0) int testCount,
    required int timestamp,
  }) = _StudyRecord;

  const StudyRecord._();

  int get totalLearned => learnedWords + learnedGrammars;
  int get totalReviewed => reviewedWords + reviewedGrammars;
  int get totalActivity => totalLearned + totalReviewed + testCount;

  factory StudyRecord.fromJson(Map<String, dynamic> json) => _$StudyRecordFromJson(json);
}

@freezed
class ReviewForecast with _$ReviewForecast {
  const factory ReviewForecast({
    required int date,
    required int count,
  }) = _ReviewForecast;

  factory ReviewForecast.fromJson(Map<String, dynamic> json) => _$ReviewForecastFromJson(json);
}

@freezed
class HeatmapDay with _$HeatmapDay {
  const factory HeatmapDay({
    required int date,
    required int count,
    @Default(0) int level, // 0-4 for visual representation
  }) = _HeatmapDay;

  factory HeatmapDay.fromJson(Map<String, dynamic> json) => _$HeatmapDayFromJson(json);
}
