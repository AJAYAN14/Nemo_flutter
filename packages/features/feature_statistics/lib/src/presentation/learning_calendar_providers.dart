import 'package:core_domain/core_domain.dart';
import 'package:core_storage/core_storage.dart';
import 'package:core_prefs/core_prefs.dart';
import 'package:feature_learning/feature_learning.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'learning_calendar_providers.g.dart';

class LearningCalendarUiState {
  final bool isLoading;
  final DateTime selectedDate;
  final LearningStats? todayStats;
  final List<ReviewForecast> weekForecast;
  final StudyRecord? selectedDateRecord;
  final int todayEpochDay;
  final String? error;

  LearningCalendarUiState({
    this.isLoading = false,
    required this.selectedDate,
    this.todayStats,
    this.weekForecast = const [],
    this.selectedDateRecord,
    this.todayEpochDay = 0,
    this.error,
  });

  LearningCalendarUiState copyWith({
    bool? isLoading,
    DateTime? selectedDate,
    LearningStats? todayStats,
    List<ReviewForecast>? weekForecast,
    StudyRecord? selectedDateRecord,
    int? todayEpochDay,
    String? error,
  }) {
    return LearningCalendarUiState(
      isLoading: isLoading ?? this.isLoading,
      selectedDate: selectedDate ?? this.selectedDate,
      todayStats: todayStats ?? this.todayStats,
      weekForecast: weekForecast ?? this.weekForecast,
      selectedDateRecord: selectedDateRecord ?? this.selectedDateRecord,
      todayEpochDay: todayEpochDay ?? this.todayEpochDay,
      error: error ?? this.error,
    );
  }
}

@riverpod
class LearningCalendarNotifier extends _$LearningCalendarNotifier {
  @override
  LearningCalendarUiState build() {
    final resetHour = ref.watch(resetHourProvider);
    final todayEpoch = DateTimeUtils.getLearningDay(resetHour);
    final todayDate = _getDateWithZeroTime(DateTime.now());

    // Initial state
    state = LearningCalendarUiState(
      selectedDate: todayDate,
      todayEpochDay: todayEpoch,
    );

    _loadInitialData();
    _observeSelectedDate();

    return state;
  }

  void _loadInitialData() {
    final resetHour = ref.read(resetHourProvider);
    final statsRepo = ref.read(statisticsRepositoryProvider);

    // Load Today Stats
    statsRepo.getLearningStats(resetHour).listen((stats) {
      state = state.copyWith(todayStats: stats);
    }, onError: (e) => state = state.copyWith(error: e.toString()));

    // Load Week Forecast
    final today = DateTimeUtils.getLearningDay(resetHour);
    statsRepo.getReviewForecast(today, today + 6).listen((forecast) {
      state = state.copyWith(weekForecast: forecast);
    }, onError: (e) => state = state.copyWith(error: e.toString()));
  }

  void _observeSelectedDate() {
    final resetHour = ref.read(resetHourProvider);
    final todayEpochDay = DateTimeUtils.getLearningDay(resetHour);
    final recordRepo = ref.read(studyRecordRepositoryProvider);

    final selectedEpochDay = DateTimeUtils.dateToEpochDay(state.selectedDate);

    if (selectedEpochDay < todayEpochDay) {
      recordRepo.getRecordByDate(selectedEpochDay).listen((record) {
        state = state.copyWith(selectedDateRecord: record);
      });
    } else {
      state = state.copyWith(selectedDateRecord: null);
    }
  }

  void onDateSelected(DateTime date) {
    state = state.copyWith(selectedDate: _getDateWithZeroTime(date));
    _observeSelectedDate();
  }

  DateTime _getDateWithZeroTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}

@riverpod
Future<List<StudyItemWithStatus>> todayItems(TodayItemsRef ref) async {
  final resetHour = ref.watch(resetHourProvider);
  final db = ref.watch(nemoDatabaseProvider);
  final repo = ref.watch(learningRepositoryProvider);

  final start = DateTimeUtils.getLearningDayStart(resetHour);
  final end = DateTimeUtils.getLearningDayEnd(resetHour);

  final newWords = await db.learningDao.getNewItems('word', start, end);
  final newGrammars = await db.learningDao.getNewItems('grammar', start, end);
  final reviewedWords = await db.learningDao.getReviewedItems('word', start, end);
  final reviewedGrammars = await db.learningDao.getReviewedItems('grammar', start, end);

  final allNewIds = [...newWords.map((e) => e.id), ...newGrammars.map((e) => e.id)];
  final allReviewedIds = [...reviewedWords.map((e) => e.id), ...reviewedGrammars.map((e) => e.id)];

  // Get full items
  final newItems = await repo.getItemsByIds(allNewIds);
  final reviewedItems = await repo.getItemsByIds(allReviewedIds);

  final result = <StudyItemWithStatus>[];
  
  for (var item in newItems) {
    result.add(StudyItemWithStatus(item: item, isNew: true));
  }
  
  for (var item in reviewedItems) {
    // Avoid duplicates if same item was new AND reviewed (though we fixed that in Repo)
    if (!allNewIds.contains(item.id)) {
      result.add(StudyItemWithStatus(item: item, isNew: false));
    }
  }

  return result;
}

class StudyItemWithStatus {
  final LearningItem item;
  final bool isNew;
  StudyItemWithStatus({required this.item, required this.isNew});
}
