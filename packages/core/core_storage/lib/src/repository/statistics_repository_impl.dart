import 'dart:async';
import 'package:core_domain/core_domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/nemo_database.dart';

part 'statistics_repository_impl.g.dart';

class StudyRecordRepositoryImpl implements StudyRecordRepository {
  StudyRecordRepositoryImpl(this._dao);
  final StudyRecordDao _dao;

  @override
  Stream<StudyRecord?> getRecordByDate(int date) {
    return _dao.watchRecordByDate(date).map((entry) => entry?.toDomain());
  }

  @override
  Stream<StudyRecord?> getTodayRecord(int resetHour) {
    final today = DateTimeUtils.getLearningDay(resetHour);
    return getRecordByDate(today);
  }

  @override
  Stream<List<StudyRecord>> getAllRecords() {
    return _dao.watchAllRecords().map(
      (list) => list.map((e) => e.toDomain()).toList(),
    );
  }

  @override
  Stream<List<StudyRecord>> getRecordsBetween(int startDate, int endDate) {
    return _dao
        .watchRecordsInRange(startDate, endDate)
        .map((list) => list.map((e) => e.toDomain()).toList());
  }

  @override
  Stream<int> getTotalStudyDays() {
    return _dao.watchAllRecords().map((list) => list.length);
  }

  @override
  Stream<Map<int, int>> getDailyActivityCounts(int startDate, int endDate) {
    return _dao.watchRecordsInRange(startDate, endDate).map((list) {
      final map = <int, int>{};
      for (var e in list) {
        final domain = e.toDomain();
        map[e.date] = domain.totalActivity;
      }
      return map;
    });
  }

  @override
  Future<void> incrementLearnedWords({
    int count = 1,
    required int resetHour,
  }) async {
    final today = DateTimeUtils.getLearningDay(resetHour);
    await _dao.incrementLearnedWords(today, count);
  }

  @override
  Future<void> incrementLearnedGrammars({
    int count = 1,
    required int resetHour,
  }) async {
    final today = DateTimeUtils.getLearningDay(resetHour);
    await _dao.incrementLearnedGrammars(today, count);
  }

  @override
  Future<void> incrementReviewedWords({
    int count = 1,
    required int resetHour,
  }) async {
    final today = DateTimeUtils.getLearningDay(resetHour);
    await _dao.incrementReviewedWords(today, count);
  }

  @override
  Future<void> incrementReviewedGrammars({
    int count = 1,
    required int resetHour,
  }) async {
    final today = DateTimeUtils.getLearningDay(resetHour);
    await _dao.incrementReviewedGrammars(today, count);
  }

  @override
  Future<void> incrementSkippedWords({
    int count = 1,
    required int resetHour,
  }) async {
    final today = DateTimeUtils.getLearningDay(resetHour);
    await _dao.incrementSkippedWords(today, count);
  }

  @override
  Future<void> incrementSkippedGrammars({
    int count = 1,
    required int resetHour,
  }) async {
    final today = DateTimeUtils.getLearningDay(resetHour);
    await _dao.incrementSkippedGrammars(today, count);
  }

  @override
  Future<void> incrementTestCount({
    int count = 1,
    required int resetHour,
  }) async {
    final today = DateTimeUtils.getLearningDay(resetHour);
    await _dao.incrementTestCount(today, count);
  }

  @override
  Future<void> deleteByDate(int date) async {
    // Logic for deletion if needed
  }

  @override
  Future<void> deleteAll() async {
    // Logic for deletion if needed
  }
}

class StatisticsRepositoryImpl implements StatisticsRepository {
  StatisticsRepositoryImpl(this._db);
  final NemoDatabase _db;

  @override
  Stream<LearningStats> getLearningStats(int resetHour) {
    // This is a complex stream that combines several counts
    // For 1:1, we'll implement the logic to fetch due items, mastered items etc.
    return Stream.fromFuture(_fetchStats(resetHour));
    // Ideally this should be a continuous stream monitoring changes, but for Phase 1 we'll use Future.
  }

  Future<LearningStats> _fetchStats(int resetHour) async {
    final now = DateTimeUtils.getCurrentCompensatedMillis();
    final today = DateTimeUtils.getLearningDay(resetHour);

    final dueWords = await _db.learningDao.getDueItemsCount('word', now);
    final dueGrammars = await _db.learningDao.getDueItemsCount('grammar', now);

    final dayStart = DateTimeUtils.getLearningDayStart(resetHour);
    final dayEnd = DateTimeUtils.getLearningDayEnd(resetHour);

    // Fallback counts from learning_progress table
    final learnedWordsCount = await _db.learningDao.getNewItemsCount('word', dayStart, dayEnd);
    final learnedGrammarsCount = await _db.learningDao.getNewItemsCount('grammar', dayStart, dayEnd);
    final reviewedWordsCount = await _db.learningDao.getReviewedItemsCount('word', dayStart, dayEnd);
    final reviewedGrammarsCount = await _db.learningDao.getReviewedItemsCount('grammar', dayStart, dayEnd);

    // Prefer study_records table for finalized daily stats
    final todayRecord = await _db.studyRecordDao.getRecordByDate(today);
    
    // Mastered items (stability > 10.0 as per Kotlin implementation)
    final allProgress = await _db.learningDao.getAllProgress();
    final masteredWords = allProgress
        .where((e) => e.itemType == 'word' && e.stability > 10)
        .length;
    final masteredGrammars = allProgress
        .where((e) => e.itemType == 'grammar' && e.stability > 10)
        .length;

    // Streak and Total Days logic
    final allRecordsEntries = await _db.studyRecordDao.watchAllRecords().first;
    final allRecords = allRecordsEntries.map((e) => e.toDomain()).toList();
    final totalStudyDays = allRecords.length;
    
    final dateSet = allRecords.map((e) => e.date).toSet();
    final streak = _calculateCurrentStreak(dateSet, today);

    // Week study days (Monday start as per Kotlin WeekFields.of(Locale.CHINA))
    final weekStudyDays = _calculateWeekStudyDays(dateSet, today);

    return LearningStats(
      dailyStreak: streak,
      totalStudyDays: totalStudyDays,
      todayLearnedWords: todayRecord?.learnedWords ?? learnedWordsCount,
      todayLearnedGrammars: todayRecord?.learnedGrammars ?? learnedGrammarsCount,
      todayReviewedWords: todayRecord?.reviewedWords ?? reviewedWordsCount,
      todayReviewedGrammars: todayRecord?.reviewedGrammars ?? reviewedGrammarsCount,
      masteredWords: masteredWords,
      masteredGrammars: masteredGrammars,
      dueWords: dueWords,
      dueGrammars: dueGrammars,
      weekStudyDays: weekStudyDays,
    );
  }

  int _calculateCurrentStreak(Set<int> dates, int today) {
    if (dates.isEmpty) return 0;
    
    int cursor = today;
    if (!dates.contains(today)) {
      if (dates.contains(today - 1)) {
        cursor = today - 1;
      } else {
        return 0;
      }
    }

    int streak = 0;
    while (dates.contains(cursor)) {
      streak++;
      cursor--;
    }
    return streak;
  }

  int _calculateWeekStudyDays(Set<int> dates, int today) {
    // Logic for China week (Monday start)
    final dt = DateTime.fromMillisecondsSinceEpoch(today * 86400000, isUtc: true).toLocal();
    final dayOfWeek = dt.weekday; // 1 = Monday, 7 = Sunday
    final startOfWeek = today - (dayOfWeek - 1);
    
    int count = 0;
    for (int i = 0; i < 7; i++) {
      if (dates.contains(startOfWeek + i)) {
        count++;
      }
    }
    return count;
  }

  @override
  Stream<List<ReviewForecast>> getReviewForecast(int startDay, int endDay) {
    // Calculate forecast based on LearningProgress dueTime
    return Stream.fromFuture(_fetchForecast(startDay, endDay));
  }

  Future<List<ReviewForecast>> _fetchForecast(int startDay, int endDay) async {
    final all = await _db.learningDao.getAllProgress();
    final map = <int, int>{};

    // Default reset hour 4 if not provided (should be ideally passed down)
    const resetHour = 4;

    for (var p in all) {
      if (p.isSuspended || p.isSkipped) continue;
      final day = DateTimeUtils.toLearningDay(p.dueTime.toInt(), resetHour);
      if (day >= startDay && day <= endDay) {
        map[day] = (map[day] ?? 0) + 1;
      }
    }

    final result = <ReviewForecast>[];
    for (int d = startDay; d <= endDay; d++) {
      result.add(ReviewForecast(date: d, count: map[d] ?? 0));
    }
    return result;
  }

  @override
  Stream<List<HeatmapDay>> getHeatmapData() {
    // Implementation for heatmap
    return Stream.value([]);
  }
}

@riverpod
StudyRecordRepository studyRecordRepository(StudyRecordRepositoryRef ref) {
  final dao = ref.watch(nemoDatabaseProvider).studyRecordDao;
  return StudyRecordRepositoryImpl(dao);
}

@riverpod
StatisticsRepository statisticsRepository(StatisticsRepositoryRef ref) {
  final db = ref.watch(nemoDatabaseProvider);
  return StatisticsRepositoryImpl(db);
}
