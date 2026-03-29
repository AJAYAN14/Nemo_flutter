// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LearningStatsImpl _$$LearningStatsImplFromJson(Map<String, dynamic> json) =>
    _$LearningStatsImpl(
      dailyStreak: (json['dailyStreak'] as num).toInt(),
      totalStudyDays: (json['totalStudyDays'] as num).toInt(),
      todayLearnedWords: (json['todayLearnedWords'] as num).toInt(),
      todayLearnedGrammars: (json['todayLearnedGrammars'] as num).toInt(),
      todayReviewedWords: (json['todayReviewedWords'] as num).toInt(),
      todayReviewedGrammars: (json['todayReviewedGrammars'] as num).toInt(),
      masteredWords: (json['masteredWords'] as num).toInt(),
      masteredGrammars: (json['masteredGrammars'] as num).toInt(),
      dueWords: (json['dueWords'] as num).toInt(),
      dueGrammars: (json['dueGrammars'] as num).toInt(),
      wordDailyGoal: (json['wordDailyGoal'] as num?)?.toInt() ?? 50,
      grammarDailyGoal: (json['grammarDailyGoal'] as num?)?.toInt() ?? 10,
      totalWords: (json['totalWords'] as num?)?.toInt() ?? 0,
      totalGrammars: (json['totalGrammars'] as num?)?.toInt() ?? 0,
      weekStudyDays: (json['weekStudyDays'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$LearningStatsImplToJson(_$LearningStatsImpl instance) =>
    <String, dynamic>{
      'dailyStreak': instance.dailyStreak,
      'totalStudyDays': instance.totalStudyDays,
      'todayLearnedWords': instance.todayLearnedWords,
      'todayLearnedGrammars': instance.todayLearnedGrammars,
      'todayReviewedWords': instance.todayReviewedWords,
      'todayReviewedGrammars': instance.todayReviewedGrammars,
      'masteredWords': instance.masteredWords,
      'masteredGrammars': instance.masteredGrammars,
      'dueWords': instance.dueWords,
      'dueGrammars': instance.dueGrammars,
      'wordDailyGoal': instance.wordDailyGoal,
      'grammarDailyGoal': instance.grammarDailyGoal,
      'totalWords': instance.totalWords,
      'totalGrammars': instance.totalGrammars,
      'weekStudyDays': instance.weekStudyDays,
    };

_$StudyRecordImpl _$$StudyRecordImplFromJson(Map<String, dynamic> json) =>
    _$StudyRecordImpl(
      date: (json['date'] as num).toInt(),
      learnedWords: (json['learnedWords'] as num?)?.toInt() ?? 0,
      learnedGrammars: (json['learnedGrammars'] as num?)?.toInt() ?? 0,
      reviewedWords: (json['reviewedWords'] as num?)?.toInt() ?? 0,
      reviewedGrammars: (json['reviewedGrammars'] as num?)?.toInt() ?? 0,
      skippedWords: (json['skippedWords'] as num?)?.toInt() ?? 0,
      skippedGrammars: (json['skippedGrammars'] as num?)?.toInt() ?? 0,
      testCount: (json['testCount'] as num?)?.toInt() ?? 0,
      timestamp: (json['timestamp'] as num).toInt(),
    );

Map<String, dynamic> _$$StudyRecordImplToJson(_$StudyRecordImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'learnedWords': instance.learnedWords,
      'learnedGrammars': instance.learnedGrammars,
      'reviewedWords': instance.reviewedWords,
      'reviewedGrammars': instance.reviewedGrammars,
      'skippedWords': instance.skippedWords,
      'skippedGrammars': instance.skippedGrammars,
      'testCount': instance.testCount,
      'timestamp': instance.timestamp,
    };

_$ReviewForecastImpl _$$ReviewForecastImplFromJson(Map<String, dynamic> json) =>
    _$ReviewForecastImpl(
      date: (json['date'] as num).toInt(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$ReviewForecastImplToJson(
  _$ReviewForecastImpl instance,
) => <String, dynamic>{'date': instance.date, 'count': instance.count};

_$HeatmapDayImpl _$$HeatmapDayImplFromJson(Map<String, dynamic> json) =>
    _$HeatmapDayImpl(
      date: (json['date'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      level: (json['level'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$HeatmapDayImplToJson(_$HeatmapDayImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'count': instance.count,
      'level': instance.level,
    };
