import 'package:core_domain/core_domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../mock/mock_category_grammar.dart';

part 'grammar_detail_notifier.g.dart';

@riverpod
class GrammarDetail extends _$GrammarDetail {
  @override
  FutureOr<Grammar?> build(int grammarId) async {
    // For now, map ID to mock data index
    if (grammarId >= 0 && grammarId < mockGrammars.length) {
      final mock = mockGrammars[grammarId];
      return Grammar(
        id: grammarId,
        grammar: mock.title.contains('〜') ? mock.title : '飲[の]む', 
        grammarLevel: mock.level,
        usages: [
          GrammarUsage(
            connection: '動[どう]词[し]辞[じ]书[しょ]形[けい] + てしまう', 
            explanation: mock.meaning,
            notes: '口语中常说成「〜ちゃう」。',
            examples: mock.examples.map((e) => GrammarExample(
              sentence: e.japanese,
              translation: e.chinese,
              source: 'Nemo Official',
            )).toList(),
          ),
        ],
        lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
      );
    }
    return null;
  }

  /// Get siblings of the same level
  Future<List<int>> getContextIds() async {
    final grammar = state.value;
    if (grammar == null) return [];
    
    // In real app, fetch all grammars of same level from repo
    return mockGrammars
        .asMap()
        .entries
        .where((e) => e.value.level == grammar.grammarLevel)
        .map((e) => e.key)
        .toList();
  }

  // Audio Playback State (Placeholder)
  String? _playingId;
  String? get playingId => _playingId;

  Future<void> playAudio(String text, String id) async {
    _playingId = id;
    state = state; // Trigger update if using AsyncValue (though this is simple)
    // Call TTS Service
    await Future.delayed(const Duration(seconds: 2));
    _playingId = null;
    state = state;
  }
}
