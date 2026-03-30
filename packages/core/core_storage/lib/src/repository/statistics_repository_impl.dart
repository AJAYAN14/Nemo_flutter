import 'dart:async';
import 'package:rxdart/rxdart.dart';
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
    final now = DateTimeUtils.getCurrentCompensatedMillis();
    final today = DateTimeUtils.getLearningDay(resetHour);
    final dayStart = DateTimeUtils.getLearningDayStart(resetHour);
    final dayEnd = DateTimeUtils.getLearningDayEnd(resetHour);

    return CombineLatestStream.combine9(
      _db.learningDao.watchDueItemsCount('word', now),
      _db.learningDao.watchDueItemsCount('grammar', now),
      _db.learningDao.watchNewItemsCount('word', dayStart, dayEnd),
      _db.learningDao.watchNewItemsCount('grammar', dayStart, dayEnd),
      _db.learningDao.watchReviewedItemsCount('word', dayStart, dayEnd),
      _db.learningDao.watchReviewedItemsCount('grammar', dayStart, dayEnd),
      _db.studyRecordDao.watchRecordByDate(today),
      _db.learningDao.watchAllProgress(),
      _db.studyRecordDao.watchAllRecords(),
      (dueW, dueG, newW, newG, revW, revG, recordToday, allProg, allRecords) {
        // 1:1 Parity: Mastered items have stability > 10 (FSRS logic)
        final masteredWords = allProg
            .where((e) => e.itemType == 'word' && e.stability > 10)
            .length;
        final masteredGrammars = allProg
            .where((e) => e.itemType == 'grammar' && e.stability > 10)
            .length;

        // Calculate Streak and Week Study Days
        final dateSet = allRecords.map((e) => e.date).toSet();
        final streak = _calculateCurrentStreak(dateSet, today);
        final weekStudyDays = _calculateWeekStudyDays(dateSet, today);

        return LearningStats(
          dailyStreak: streak,
          totalStudyDays: allRecords.length,
          todayLearnedWords: recordToday?.learnedWords ?? newW,
          todayLearnedGrammars: recordToday?.learnedGrammars ?? newG,
          todayReviewedWords: recordToday?.reviewedWords ?? revW,
          todayReviewedGrammars: recordToday?.reviewedGrammars ?? revG,
          masteredWords: masteredWords,
          masteredGrammars: masteredGrammars,
          dueWords: dueW,
          dueGrammars: dueG,
          weekStudyDays: weekStudyDays,
        );
      },
    ).asyncMap((stats) async {
      // Fetch total counts (level-based for words to match Kotlin)
      final levels = ['N1', 'N2', 'N3', 'N4', 'N5'];
      int totalWordsCount = 0;
      for (var level in levels) {
        final wordsInLevel = await _db.wordDao.getWordsByLevel(level);
        totalWordsCount += wordsInLevel.length;
      }
      
      final allGrammars = await _db.grammarDao.getAllGrammars();
      
      return stats.copyWith(
        totalWords: totalWordsCount,
        totalGrammars: allGrammars.length,
      );
    });
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
  Stream<List<HeatmapDay>> getHeatmapData(int resetHour) {
    final endDay = DateTimeUtils.getLearningDay(resetHour);
    final startDay = endDay - 364;

    return _db.studyRecordDao.watchRecordsInRange(startDay, endDay).map((list) {
      final map = {for (var e in list) e.date: e.toDomain().totalActivity};
      final result = <HeatmapDay>[];

      for (int d = startDay; d <= endDay; d++) {
        final count = map[d] ?? 0;
        result.add(HeatmapDay(
          date: d,
          count: count,
          level: _calculateHeatmapLevel(count),
        ));
      }
      return result;
    });
  }

  int _calculateHeatmapLevel(int count) {
    if (count == 0) return 0;
    if (count <= 10) return 1;
    if (count <= 30) return 2;
    if (count <= 60) return 3;
    return 4;
  }

  @override
  Stream<List<LearningItem>> getAllLearnedWords() {
    return _db.learningDao.watchAllProgressByType('word').asyncMap((progressList) async {
      final items = <LearningItem>[];
      for (var p in progressList) {
        final idStr = p.id.replaceFirst('word_', '');
        final word = await _db.wordDao.getWordWithExamples(idStr);
        if (word != null) {
          items.add(WordItem(word.toDomain(), progress: p.toDomain()));
        }
      }
      return items;
    });
  }

  @override
  Stream<List<LearningItem>> getAllLearnedGrammars() {
    return _db.learningDao.watchAllProgressByType('grammar').asyncMap((progressList) async {
      final items = <LearningItem>[];
      for (var p in progressList) {
        final idStr = p.id.replaceFirst('grammar_', '');
        final grammar = await _db.grammarDao.getGrammarWithDetails(idStr);
        if (grammar != null) {
          items.add(GrammarItem(grammar.toDomain(), progress: p.toDomain()));
        }
      }
      return items;
    });
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
