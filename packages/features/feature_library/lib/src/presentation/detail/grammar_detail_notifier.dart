import 'package:core_domain/core_domain.dart';
import 'package:core_storage/core_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'grammar_detail_notifier.g.dart';

@riverpod
class GrammarDetail extends _$GrammarDetail {
  @override
  Future<Grammar?> build(String grammarId) async {
    final dao = ref.watch(grammarDaoProvider);
    final data = await dao.getGrammarWithDetails(grammarId);
    
    if (data == null) return null;

    return _mapToGrammar(data);
  }

  /// Get siblings of the same level
  Future<List<String>> getContextIds() async {
    final dao = ref.read(grammarDaoProvider);
    final grammar = state.value;
    if (grammar == null) return [];
    
    final all = await dao.getAllGrammars();
    return all
        .where((e) => e.grammarLevel == grammar.grammarLevel)
        .map((e) => e.id)
        .toList();
  }

  // Audio Playback State
  String? _playingId;
  String? get playingId => _playingId;

  Future<void> playAudio(String text, String id) async {
    _playingId = id;
    // Trigger update for UI to show playing icon
    ref.notifyListeners();
    
    // Call TTS Service (Simulated)
    await Future.delayed(const Duration(seconds: 2));
    
    _playingId = null;
    ref.notifyListeners();
  }

  Grammar _mapToGrammar(GrammarWithDetails data) {
    final entry = data.grammar;
    return Grammar(
      id: entry.id,
      grammar: entry.grammar,
      grammarLevel: entry.grammarLevel,
      usages: data.usages.map((u) => GrammarUsage(
        connection: u.usage.connection,
        explanation: u.usage.explanation,
        notes: u.usage.notes ?? '',
        subtype: u.usage.subtype,
        examples: u.examples.map((e) => GrammarExample(
          sentence: e.sentence,
          translation: e.translation,
          source: e.source,
          isDialog: e.isDialog,
        )).toList(),
      )).toList(),
      lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
