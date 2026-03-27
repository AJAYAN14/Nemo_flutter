import 'package:core_domain/core_domain.dart';
import 'package:core_storage/core_storage.dart';
import 'package:core_prefs/core_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/learning_item.dart';
import '../domain/srs_scheduler.dart';

part 'learning_repository.g.dart';

class LearningRepository {
  final WordDao _wordDao;
  final GrammarDao _grammarDao;
  final LearningDao _learningDao;
  final SrsScheduler _scheduler = SrsScheduler();
  
  final int _wordGoal;
  final int _grammarGoal;
  final int _resetHour;
  final String _wordLevel;
  final String _grammarLevel;
  final bool _randomContent;

  LearningRepository({
    required WordDao wordDao,
    required GrammarDao grammarDao,
    required LearningDao learningDao,
    required int wordGoal,
    required int grammarGoal,
    required int resetHour,
    required String wordLevel,
    required String grammarLevel,
    required bool randomContent,
  })  : _wordDao = wordDao,
        _grammarDao = grammarDao,
        _learningDao = learningDao,
        _wordGoal = wordGoal,
        _grammarGoal = grammarGoal,
        _resetHour = resetHour,
        _wordLevel = wordLevel,
        _grammarLevel = grammarLevel,
        _randomContent = randomContent;

  Future<List<LearningItem>> getLearningQueue(String mode) async {
    final dayStartMillis = DateTimeUtils.getLearningDayStart(_resetHour);
    final dayEndMillis = DateTimeUtils.getLearningDayEnd(_resetHour);

    final List<LearningItem> items = await getReviewQueue(mode);

    // 2. Get new items (if mode matches)
    if (mode == 'word') {
      final wordsLearnedToday = await _learningDao.getNewItemsCount('word', dayStartMillis, dayEndMillis);
      final wordsToLearn = (_wordGoal - wordsLearnedToday).clamp(0, _wordGoal);
      
      int newWordsAdded = 0;
      final allWords = await _wordDao.getWordsByLevel(_wordLevel);
      final List<WordEntry> filteredWords = List.from(allWords);
      if (_randomContent) {
        filteredWords.shuffle();
      }
      
      for (final wordEntry in filteredWords) {
        if (newWordsAdded >= wordsToLearn) break;
        final progress = await _learningDao.getProgress('word_${wordEntry.id}');
        if (progress == null) {
          final wordWithEx = await _wordDao.getWordWithExamples(wordEntry.id);
          if (wordWithEx != null) {
            items.add(WordItem(wordWithEx.toDomain(), progress: null));
            newWordsAdded++;
          }
        }
      }
    } else if (mode == 'grammar') {
      final grammarsLearnedToday = await _learningDao.getNewItemsCount('grammar', dayStartMillis, dayEndMillis);
      final grammarsToLearn = (_grammarGoal - grammarsLearnedToday).clamp(0, _grammarGoal);
      
      int newGrammarsAdded = 0;
      final allGrammars = await _grammarDao.getGrammarsByLevel(_grammarLevel);
      final List<GrammarEntry> filteredGrammars = List.from(allGrammars);
      if (_randomContent) {
        filteredGrammars.shuffle();
      }

      for (final grammarEntry in filteredGrammars) {
        if (newGrammarsAdded >= grammarsToLearn) break;
        final progress = await _learningDao.getProgress('grammar_${grammarEntry.id}');
        if (progress == null) {
          final grammarWithDetails = await _grammarDao.getGrammarWithDetails(grammarEntry.id);
          if (grammarWithDetails != null) {
            items.add(GrammarItem(grammarWithDetails.toDomain(), progress: null));
            newGrammarsAdded++;
          }
        }
      }
    }

    return items;
  }

  Future<List<LearningItem>> getReviewQueue(String mode) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final List<LearningItem> items = [];

    // 1. Get due items (filtered by mode or all)
    final dueProgress = await _learningDao.getDueItems(
      now, 
      itemType: mode == 'all' ? null : mode,
    );
    
    for (final progress in dueProgress) {
      if (progress.itemType == 'word') {
        final idStr = progress.id.replaceFirst('word_', '');
        final word = await _wordDao.getWordWithExamples(idStr);
        if (word != null) {
          items.add(WordItem(word.toDomain(), progress: progress));
        }
      } else {
        final idStr = progress.id.replaceFirst('grammar_', '');
        final grammar = await _grammarDao.getGrammarWithDetails(idStr);
        if (grammar != null) {
          items.add(GrammarItem(grammar.toDomain(), progress: progress));
        }
      }
    }
    return items;
  }

  Future<List<LearningItem>> getUpcomingItems(int now, int withinMillis, {String? itemType}) async {
    final List<LearningItem> items = [];
    final upcomingProgress = await _learningDao.getUpcomingItems(
      now, 
      withinMillis,
      itemType: itemType == 'all' ? null : itemType,
    );
    
    for (final progress in upcomingProgress) {
      if (progress.itemType == 'word') {
        final idStr = progress.id.replaceFirst('word_', '');
        final word = await _wordDao.getWordWithExamples(idStr);
        if (word != null) {
          items.add(WordItem(word.toDomain(), progress: progress));
        }
      } else {
        final idStr = progress.id.replaceFirst('grammar_', '');
        final grammar = await _grammarDao.getGrammarWithDetails(idStr);
        if (grammar != null) {
          items.add(GrammarItem(grammar.toDomain(), progress: progress));
        }
      }
    }
    return items;
  }

  Future<List<LearningItem>> getItemsByIds(List<String> ids) async {
    final List<LearningItem> items = [];
    for (final id in ids) {
      if (id.startsWith('word_')) {
        final idStr = id.replaceFirst('word_', '');
        final word = await _wordDao.getWordWithExamples(idStr);
        final progress = await _learningDao.getProgress(id);
        if (word != null) {
          items.add(WordItem(word.toDomain(), progress: progress));
        }
      } else if (id.startsWith('grammar_')) {
        final idStr = id.replaceFirst('grammar_', '');
        final grammar = await _grammarDao.getGrammarWithDetails(idStr);
        final progress = await _learningDao.getProgress(id);
        if (grammar != null) {
          items.add(GrammarItem(grammar.toDomain(), progress: progress));
        }
      }
    }
    return items;
  }

  Future<SrsFinalResult> updateProgress(String id, String itemType, SrsRating rating) async {
    final fullId = '${itemType}_$id';
    final currentProgress = await _learningDao.getProgress(fullId);
    
    final result = _scheduler.schedule(
      id: fullId,
      itemType: itemType,
      rating: rating,
      currentProgress: currentProgress,
    );

    final LearningProgressData updatedData;
    if (result is SrsRequeue) {
      updatedData = await _learningDao.updateProgress(result.companion);
    } else {
      updatedData = await _learningDao.updateProgress((result as SrsGraduate).companion);
    }
    
    return SrsFinalResult(
      updatedProgress: updatedData,
      isRequeue: result is SrsRequeue,
    );
  }

  Future<void> undoUpdateProgress(String id, String itemType, LearningProgressData? oldData) async {
    if (oldData == null) {
      // If there was no progress before, we might want to delete it or just skip
      return; 
    }
    await _learningDao.updateProgress(oldData.toCompanion(true));
  }

  Future<void> suspend(String id, String itemType) async {
    final fullId = '${itemType}_$id';
    await _learningDao.setSuspended(fullId, true);
  }

  Future<void> bury(String id, String itemType, int resetHour) async {
    final fullId = '${itemType}_$id';
    // Move dueTime to the start of the next learning day
    final nextDayStart = DateTimeUtils.getLearningDayEnd(resetHour) + 1;
    await _learningDao.updateDueTime(fullId, nextDayStart);
  }
}

@riverpod
LearningRepository learningRepository(LearningRepositoryRef ref) {
  return LearningRepository(
    wordDao: ref.watch(wordDaoProvider),
    grammarDao: ref.watch(grammarDaoProvider),
    learningDao: ref.watch(learningDaoProvider),
    wordGoal: ref.watch(wordGoalProvider),
    grammarGoal: ref.watch(grammarGoalProvider),
    resetHour: ref.watch(resetHourProvider),
    wordLevel: ref.watch(wordLevelProvider),
    grammarLevel: ref.watch(grammarLevelProvider),
    randomContent: ref.watch(randomContentProvider),
  );
}
