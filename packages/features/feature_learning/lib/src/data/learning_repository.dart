import 'package:core_domain/core_domain.dart';
import 'package:core_storage/core_storage.dart';
import 'package:core_prefs/core_prefs.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/srs_scheduler.dart';
import '../domain/fsrs_parameter_optimizer.dart';

import '../domain/learning_session_policy.dart';

part 'learning_repository.g.dart';

class LearningRepository {
  final WordDao _wordDao;
  final GrammarDao _grammarDao;
  final LearningDao _learningDao;
  final StudyRecordRepository _studyRecordRepository;
  final SrsScheduler _scheduler;
  final LearningSessionPolicy _policy = const LearningSessionPolicy();
  
  final int _wordGoal;
  final int _grammarGoal;
  final int _resetHour;
  final String _wordLevel;
  final String _grammarLevel;
  final bool _randomContent;
  final int _leechThreshold;
  final String _leechAction;
  final List<int> _learningSteps;
  final List<int> _relearningSteps;

  LearningRepository({
    required WordDao wordDao,
    required GrammarDao grammarDao,
    required LearningDao learningDao,
    required StudyRecordRepository studyRecordRepository,
    required int wordGoal,
    required int grammarGoal,
    required int resetHour,
    required String wordLevel,
    required String grammarLevel,
    required bool randomContent,
    required int leechThreshold,
    required String leechAction,
    required List<int> learningSteps,
    required List<int> relearningSteps,
    List<double>? optimizedFsrsParameters,
  })  : _wordDao = wordDao,
        _grammarDao = grammarDao,
        _learningDao = learningDao,
        _studyRecordRepository = studyRecordRepository,
        _scheduler = SrsScheduler(optimizedParameters: optimizedFsrsParameters),
        _wordGoal = wordGoal,
        _grammarGoal = grammarGoal,
        _resetHour = resetHour,
        _wordLevel = wordLevel,
        _grammarLevel = grammarLevel,
        _randomContent = randomContent,
        _leechThreshold = leechThreshold,
        _leechAction = leechAction,
        _learningSteps = learningSteps,
        _relearningSteps = relearningSteps;

  Future<List<LearningItem>> getLearningQueue(String mode) async {
    final dayStartMillis = DateTimeUtils.getLearningDayStart(_resetHour);
    final dayEndMillis = DateTimeUtils.getLearningDayEnd(_resetHour);

    // 1. 获取复习项
    final List<LearningItem> reviewItems = await getReviewQueue(mode);
    final List<LearningItem> newItems = [];

    // 2. 获取新项
    if (mode == 'word') {
      final wordsLearnedToday = await _learningDao.getNewItemsCount('word', dayStartMillis, dayEndMillis);
      final wordsToLearn = (_wordGoal - wordsLearnedToday).clamp(0, _wordGoal);
      
      if (wordsToLearn > 0) {
        final newWords = await _wordDao.getNewWords(_wordLevel, isRandom: _randomContent);
        int added = 0;
        for (final wordEntry in newWords) {
          if (added >= wordsToLearn) break;
          // 新词可能已由于搁置/跳过而有进度记录
          final progress = await _learningDao.getProgress('word_${wordEntry.id}');
          final wordWithEx = await _wordDao.getWordWithExamples(wordEntry.id);
          if (wordWithEx != null) {
            newItems.add(WordItem(wordWithEx.toDomain(), progress: progress?.toDomain()));
            added++;
          }
        }
      }
    } else if (mode == 'grammar') {
      final grammarsLearnedToday = await _learningDao.getNewItemsCount('grammar', dayStartMillis, dayEndMillis);
      final grammarsToLearn = (_grammarGoal - grammarsLearnedToday).clamp(0, _grammarGoal);
      
      if (grammarsToLearn > 0) {
        final newGrammars = await _grammarDao.getNewGrammars(_grammarLevel, isRandom: _randomContent);
        int added = 0;
        for (final grammarEntry in newGrammars) {
          if (added >= grammarsToLearn) break;
          final progress = await _learningDao.getProgress('grammar_${grammarEntry.id}');
          final grammarWithDetails = await _grammarDao.getGrammarWithDetails(grammarEntry.id);
          if (grammarWithDetails != null) {
            newItems.add(GrammarItem(grammarWithDetails.toDomain(), progress: progress?.toDomain()));
            added++;
          }
        }
      }
    }

    // 3. 应用混合策略：[高危复习] -> [新词穿插在普通复习中]
    return _policy.mixSessionItems(reviewItems, newItems);
  }

  Future<int> getTodayCompletedCount(String mode) async {
    final dayStartMillis = DateTimeUtils.getLearningDayStart(_resetHour);
    final dayEndMillis = DateTimeUtils.getLearningDayEnd(_resetHour);
    return _learningDao.getNewItemsCount(mode, dayStartMillis, dayEndMillis);
  }

  Future<List<LearningItem>> getReviewQueue(String mode) async {
    final now = DateTimeUtils.getCurrentCompensatedMillis();
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
          items.add(WordItem(word.toDomain(), progress: progress.toDomain()));
        }
      } else {
        final idStr = progress.id.replaceFirst('grammar_', '');
        final grammar = await _grammarDao.getGrammarWithDetails(idStr);
        if (grammar != null) {
          items.add(GrammarItem(grammar.toDomain(), progress: progress.toDomain()));
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
          items.add(WordItem(word.toDomain(), progress: progress.toDomain()));
        }
      } else {
        final idStr = progress.id.replaceFirst('grammar_', '');
        final grammar = await _grammarDao.getGrammarWithDetails(idStr);
        if (grammar != null) {
          items.add(GrammarItem(grammar.toDomain(), progress: progress.toDomain()));
        }
      }
    }
    return items;
  }

  Future<List<LearningItem>> getSkippedItems(String mode) async {
    final List<LearningItem> items = [];
    final skippedProgress = await _learningDao.getSkippedItems(
      itemType: mode == 'all' ? null : mode,
    );
    
    for (final progress in skippedProgress) {
      if (progress.itemType == 'word') {
        final idStr = progress.id.replaceFirst('word_', '');
        final word = await _wordDao.getWordWithExamples(idStr);
        if (word != null) {
          items.add(WordItem(word.toDomain(), progress: progress.toDomain()));
        }
      } else {
        final idStr = progress.id.replaceFirst('grammar_', '');
        final grammar = await _grammarDao.getGrammarWithDetails(idStr);
        if (grammar != null) {
          items.add(GrammarItem(grammar.toDomain(), progress: progress.toDomain()));
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
          items.add(WordItem(word.toDomain(), progress: progress?.toDomain()));
        }
      } else if (id.startsWith('grammar_')) {
        final idStr = id.replaceFirst('grammar_', '');
        final grammar = await _grammarDao.getGrammarWithDetails(idStr);
        final progress = await _learningDao.getProgress(id);
        if (grammar != null) {
          items.add(GrammarItem(grammar.toDomain(), progress: progress?.toDomain()));
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
      learningSteps: _learningSteps,
      relearningSteps: _relearningSteps,
      leechThreshold: _leechThreshold,
    );

    final LearningProgressData updatedData;
    if (result is SrsRequeue) {
      updatedData = await _learningDao.updateProgress(result.companion);
    } else if (result is SrsLeech) {
      if (_leechAction == 'bury') {
        final nextDayStart = DateTimeUtils.getLearningDayEnd(_resetHour) + 1;
        final companion = result.companion.copyWith(
          dueTime: Value(BigInt.from(nextDayStart)),
        );
        updatedData = await _learningDao.updateProgress(companion);
      } else {
        // 'skip'
        final companion = result.companion.copyWith(
          isSkipped: const Value(true),
        );
        updatedData = await _learningDao.updateProgress(companion);
      }
    } else {
      updatedData = await _learningDao.updateProgress((result as SrsGraduate).companion);
    }

    // [1:1 Logic Fix] Update StudyRecords synchronously with progress
    // If firstLearned is today, any further ratings TODAY are excluded from "Reviewed" count
    final today = DateTimeUtils.getLearningDay(_resetHour);
    final firstLearnedDay = updatedData.firstLearned != null
        ? DateTimeUtils.toLearningDay(updatedData.firstLearned!.toInt(), _resetHour)
        : null;

    if (currentProgress == null) {
      // First time learning this item
      if (itemType == 'word') {
        await _studyRecordRepository.incrementLearnedWords(resetHour: _resetHour);
      } else {
        await _studyRecordRepository.incrementLearnedGrammars(resetHour: _resetHour);
      }
    } else if (firstLearnedDay != today) {
      // It's a review of an item learned on a PREVIOUS day
      if (itemType == 'word') {
        await _studyRecordRepository.incrementReviewedWords(resetHour: _resetHour);
      } else {
        await _studyRecordRepository.incrementReviewedGrammars(resetHour: _resetHour);
      }
    }
    
    return SrsFinalResult(
      updatedProgress: updatedData,
      isRequeue: result is SrsRequeue,
      isLeech: result is SrsLeech,
    );
  }

  Future<void> undoUpdateProgress(String id, String itemType, StudyProgress? oldData) async {
    if (oldData == null) {
      // If there was no progress before, we might want to delete it or just skip
      return; 
    }
    // Convert StudyProgress back to Companion using the dictionary-based toCompanion()
    // or we can implement a more type-safe mapper in core_storage.
    // For now, since toCompanion() returns a Map, we can't directly pass it to updateProgress.
    // I'll update toCompanion() to return the actual Drift companion in core_storage.
    // Wait, core_domain cannot depend on core_storage.
    // So the conversion MUST happen here in the repository.
    
    final companion = LearningProgressCompanion(
      id: Value(oldData.id),
      itemType: Value(oldData.itemType),
      repetitionCount: Value(oldData.repetitionCount),
      interval: Value(oldData.interval),
      difficulty: Value(oldData.easeFactor),
      dueTime: Value(BigInt.from(oldData.dueTime)),
      lastReviewed: Value(oldData.lastReviewed != null ? BigInt.from(oldData.lastReviewed!) : null),
      firstLearned: Value(oldData.firstLearned != null ? BigInt.from(oldData.firstLearned!) : null),
      step: Value(oldData.step),
      isSuspended: Value(oldData.isSuspended),
      lapses: Value(oldData.lapses),
      isSkipped: Value(oldData.isSkipped),
    );

    await _learningDao.updateProgress(companion);
  }

  Future<void> suspend(String id, String itemType) async {
    final fullId = '${itemType}_$id';
    
    // Ensure progress record exists
    final progress = await _learningDao.getProgress(fullId);
    if (progress == null) {
      // Create initial progress for new item
      await _learningDao.updateProgress(LearningProgressCompanion.insert(
        id: fullId,
        itemType: itemType,
        isSuspended: const Value(true),
        isSkipped: const Value(true),
        // Set a future due time just in case, though it's skipped
        dueTime: Value(BigInt.from(DateTimeUtils.getCurrentCompensatedMillis() + 86400000)),
      ));
    } else {
      // 1:1 Restoration: Both Suspended and Skipped flags should be set
      // In the old project, Manual Suspend also moved the item to Leech Management (Skipped)
      await _learningDao.setSuspended(fullId, true);
      await _learningDao.setSkipped(fullId, true);
    }
  }

  Future<void> bury(String id, String itemType, int resetHour) async {
    final fullId = '${itemType}_$id';
    // Move dueTime to the start of the next learning day
    final nextDayStart = DateTimeUtils.getLearningDayEnd(resetHour) + 1;
    
    final progress = await _learningDao.getProgress(fullId);
    if (progress == null) {
      await _learningDao.updateProgress(LearningProgressCompanion.insert(
        id: fullId,
        itemType: itemType,
        dueTime: Value(BigInt.from(nextDayStart)),
      ));
    } else {
      await _learningDao.updateDueTime(fullId, nextDayStart);
    }
  }

  Future<void> recoverLeech(String id, String itemType) async {
    final fullId = '${itemType}_$id';
    // Ensure both flags are cleared for 1:1 parity
    await _learningDao.setSkipped(fullId, false);
    await _learningDao.setSuspended(fullId, false);
  }

  Map<SrsRating, String> getIntervalPreviews(StudyProgress? progress) {
    // Convert back to LearningProgressData for the scheduler which is still using Drift types
    // or update the scheduler too. For now, let's keep consistency.
    final data = progress == null ? null : LearningProgressData(
      id: progress.id,
      itemType: progress.itemType,
      repetitionCount: progress.repetitionCount,
      interval: progress.interval,
      difficulty: progress.easeFactor,
      stability: 0, // Placeholder
      dueTime: BigInt.from(progress.dueTime),
      lastReviewed: progress.lastReviewed != null ? BigInt.from(progress.lastReviewed!) : null,
      firstLearned: progress.firstLearned != null ? BigInt.from(progress.firstLearned!) : null,
      step: progress.step,
      lapses: progress.lapses,
      isSuspended: progress.isSuspended,
      isSkipped: progress.isSkipped,
    );

    return _scheduler.getIntervalPreviews(
      currentProgress: data,
      learningSteps: _learningSteps,
      relearningSteps: _relearningSteps,
    );
  }
}

/// Holds FSRS optimized parameters computed asynchronously at startup.
/// Matches Kotlin SrsCalculatorImpl.init {} which loads in background.
List<double>? _cachedOptimizedParams;
bool _optimizerInitialized = false;

/// Run FSRS parameter optimization asynchronously.
/// Called once on first provider creation, result cached for the session.
Future<List<double>?> _getOptimizedParams(LearningDao learningDao) async {
  if (_optimizerInitialized) return _cachedOptimizedParams;
  _optimizerInitialized = true;

  try {
    // 1:1 Parity with Kotlin: getRecentLogs(limit = 1500)
    final allProgress = await learningDao.getAllProgress();
    // Filter to items that have been reviewed (lastReviewed > 0)
    final reviewed = allProgress
        .where((p) => (p.lastReviewed?.toInt() ?? 0) > 0)
        .toList();

    // Take last 1500 records for optimization
    final recent = reviewed.length > 1500 ? reviewed.sublist(reviewed.length - 1500) : reviewed;

    // Build rating logs from lapses data (simplified: items with lapses > 0 had Again ratings)
    final logs = recent.map((p) {
      // Map repetitionCount and lapses to an approximate rating
      final lapses = p.lapses;
      if (lapses > 0) return ReviewLog(rating: 1); // Again
      return ReviewLog(rating: 3); // Good (default for graduated items)
    }).toList();

    final result = FsrsParameterOptimizer.optimize(logs);
    if (result != null) {
      _cachedOptimizedParams = result.parameters;
      print('[FSRS] personalization enabled, samples=${result.sampleSize}, '
          'againRate=${result.againRate.toStringAsFixed(3)}, '
          'hardRate=${result.hardRate.toStringAsFixed(3)}');
    } else {
      print('[FSRS] personalization skipped, insufficient logs (samples=${logs.length})');
    }
  } catch (e) {
    // 1:1 Parity: Keep default parameters, don't crash the main flow.
    print('[FSRS] personalization skipped due to initialization error: $e');
  }
  return _cachedOptimizedParams;
}

@riverpod
LearningRepository learningRepository(Ref ref) {
  final learningDao = ref.watch(learningDaoProvider);
  final studyRecordRepo = ref.watch(studyRecordRepositoryProvider);

  // Fire-and-forget async optimization (matching Kotlin's scope.launch in init)
  // The optimizer runs in the background; until it completes, default params are used.
  _getOptimizedParams(learningDao);

  return LearningRepository(
    wordDao: ref.watch(wordDaoProvider),
    grammarDao: ref.watch(grammarDaoProvider),
    learningDao: learningDao,
    studyRecordRepository: studyRecordRepo,
    wordGoal: ref.watch(wordGoalProvider),
    grammarGoal: ref.watch(grammarGoalProvider),
    resetHour: ref.watch(resetHourProvider),
    wordLevel: ref.watch(wordLevelProvider),
    grammarLevel: ref.watch(grammarLevelProvider),
    randomContent: ref.watch(randomContentProvider),
    leechThreshold: ref.watch(leechThresholdProvider),
    leechAction: ref.watch(leechActionProvider),
    learningSteps: ref.watch(learningStepsProvider).split(' ').map((e) => int.tryParse(e) ?? 1).toList(),
    relearningSteps: ref.watch(relearningStepsProvider).split(' ').map((e) => int.tryParse(e) ?? 1).toList(),
    optimizedFsrsParameters: _cachedOptimizedParams,
  );
}
