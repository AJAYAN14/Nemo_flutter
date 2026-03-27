import 'package:core_domain/core_domain.dart';
import 'package:core_storage/core_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/learning_item.dart';
import '../domain/srs_scheduler.dart';

part 'learning_repository.g.dart';

class LearningRepository {
  final WordDao _wordDao;
  final GrammarDao _grammarDao;
  final LearningDao _learningDao;
  final SrsScheduler _scheduler = SrsScheduler();

  LearningRepository({
    required WordDao wordDao,
    required GrammarDao grammarDao,
    required LearningDao learningDao,
  })  : _wordDao = wordDao,
        _grammarDao = grammarDao,
        _learningDao = learningDao;

  Future<List<LearningItem>> getLearningQueue({int newLimit = 10}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // 1. Get due items
    final dueProgress = await _learningDao.getDueItems(now);
    final List<LearningItem> items = [];

    for (final progress in dueProgress) {
      if (progress.itemType == 'word') {
        final word = await _wordDao.getWordWithExamples(progress.id.replaceFirst('word_', ''));
        if (word != null) {
          items.add(WordItem(word.toDomain()));
        }
      } else {
        final grammar = await _grammarDao.getGrammarWithDetails(progress.id.replaceFirst('grammar_', ''));
        if (grammar != null) {
          items.add(GrammarItem(grammar.toDomain()));
        }
      }
    }

    // 2. Get new items (those without progress)
    // This is a bit tricky with Drift if we don't have a direct query. 
    // For now, let's fetch some words and grammars and check if they have progress.
    if (items.length < newLimit) {
      final allWords = await _wordDao.getAllWords();
      for (final wordEntry in allWords) {
        if (items.length >= newLimit) break;
        final progress = await _learningDao.getProgress('word_${wordEntry.id}');
        if (progress == null) {
          final wordWithEx = await _wordDao.getWordWithExamples(wordEntry.id);
          if (wordWithEx != null) {
            items.add(WordItem(wordWithEx.toDomain()));
          }
        }
      }
    }

    return items;
  }

  Future<void> updateProgress(String id, String itemType, SrsRating rating) async {
    final fullId = '${itemType}_$id';
    final currentProgress = await _learningDao.getProgress(fullId);
    
    final result = _scheduler.schedule(
      id: fullId,
      itemType: itemType,
      rating: rating,
      currentProgress: currentProgress,
    );

    if (result is SrsRequeue) {
      await _learningDao.updateProgress(result.updatedProgress);
    } else if (result is SrsGraduate) {
      await _learningDao.updateProgress(result.updatedProgress);
    }
  }
}

@riverpod
LearningRepository learningRepository(LearningRepositoryRef ref) {
  return LearningRepository(
    wordDao: ref.watch(wordDaoProvider),
    grammarDao: ref.watch(grammarDaoProvider),
    learningDao: ref.watch(learningDaoProvider),
  );
}
