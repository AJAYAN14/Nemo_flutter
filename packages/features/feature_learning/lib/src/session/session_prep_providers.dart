import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../mock/session_prep_mock_data.dart';

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

final sessionPrepWordsProvider = Provider<List<SessionPrepWordItem>>(
  (ref) => sessionPrepMockWords,
);

final sessionPrepViewModelProvider = Provider<SessionPrepViewModel>((ref) {
  final words = ref.watch(sessionPrepWordsProvider);

  return SessionPrepViewModel(
    title: '今日学习准备',
    subtitle: '即将学习 ${words.length} 个内容',
    words: words,
    totalCount: words.length,
    reviewedCount: 0,
    remainingCount: words.length,
  );
});
