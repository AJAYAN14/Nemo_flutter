import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_storage/core_storage.dart';
import 'package:core_prefs/core_prefs.dart';
import '../data/learning_repository.dart';

part 'session_prep_providers.g.dart';

class SessionPrepWordItem {
  const SessionPrepWordItem({
    required this.japanese,
    required this.hiragana,
    required this.meaning,
    required this.level,
    required this.example,
  });

  final String japanese;
  final String hiragana;
  final String meaning;
  final String level;
  final String example;
}

class SessionPrepViewModel {
  const SessionPrepViewModel({
    required this.title,
    required this.subtitle,
    required this.words,
    required this.totalCount,
    required this.reviewedCount,
    required this.remainingCount,
  });

  final String title;
  final String subtitle;
  final List<SessionPrepWordItem> words;
  final int totalCount;
  final int reviewedCount;
  final int remainingCount;
}

@riverpod
Future<List<SessionPrepWordItem>> sessionPrepWords(Ref ref) async {
  final repository = ref.watch(learningRepositoryProvider);
  // Default to 'all' to align with Kotlin unified review experience
  final items = await repository.getReviewQueue('all');
  
  return items.map((item) {
    if (item is WordItem) {
      return SessionPrepWordItem(
        japanese: item.word.japanese,
        hiragana: item.word.hiragana,
        meaning: item.word.chinese, // In WordDomain, chinese is the meaning
        level: item.word.level,
        example: item.word.examples.isNotEmpty ? item.word.examples.first.japanese : '',
      );
    } else if (item is GrammarItem) {
      return SessionPrepWordItem(
        japanese: item.grammar.grammar,
        hiragana: item.grammar.usages.isNotEmpty ? item.grammar.usages.first.connection : '',
        meaning: item.grammar.usages.isNotEmpty ? item.grammar.usages.first.explanation : '',
        level: item.grammar.grammarLevel,
        example: (item.grammar.usages.isNotEmpty && item.grammar.usages.first.examples.isNotEmpty) 
            ? item.grammar.usages.first.examples.first.sentence : '',
      );
    } else {
      throw Exception('Unknown learning item type');
    }
  }).toList();
}

@riverpod
Future<SessionPrepViewModel> sessionPrepViewModel(Ref ref) async {
  final wordsAsync = ref.watch(sessionPrepWordsProvider);
  final learningDao = ref.watch(learningDaoProvider);
  final resetHour = ref.watch(resetHourProvider);
  
  final dayStart = DateTimeUtils.getLearningDayStart(resetHour);
  final dayEnd = DateTimeUtils.getLearningDayEnd(resetHour);

  // Fetch real counts across all types
  final reviewedToday = await learningDao.getReviewedItemsCount('word', dayStart, dayEnd) + 
                       await learningDao.getReviewedItemsCount('grammar', dayStart, dayEnd);
  
  // Note: getDueItemsCount is already used via sessionPrepWords for the 'remaining' / 'total' count in this session.
  // However, totalCount in preparation usually refers to the total number of items assigned for the session.
  
  return wordsAsync.when(
    data: (words) => SessionPrepViewModel(
      title: '今日复习准备',
      subtitle: '即将复习 ${words.length} 个内容',
      words: words,
      totalCount: words.length,
      reviewedCount: reviewedToday,
      remainingCount: words.length,
    ),
    loading: () => const SessionPrepViewModel(
      title: '正在加载...',
      subtitle: '',
      words: [],
      totalCount: 0,
      reviewedCount: 0,
      remainingCount: 0,
    ),
    error: (err, stack) => SessionPrepViewModel(
      title: '加载失败',
      subtitle: err.toString(),
      words: [],
      totalCount: 0,
      reviewedCount: 0,
      remainingCount: 0,
    ),
  );
}
