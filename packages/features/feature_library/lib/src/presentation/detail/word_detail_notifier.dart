import 'dart:convert';
import 'package:core_domain/core_domain.dart';
import 'package:core_storage/core_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'word_detail_notifier.g.dart';

/// State for the Word Detail screen
class WordDetailState {
  const WordDetailState({
    this.currentWord,
    this.contextIds = const [],
    this.isLoading = false,
    this.playingAudioId,
  });

  final Word? currentWord;
  final List<String> contextIds;
  final bool isLoading;
  final String? playingAudioId;

  WordDetailState copyWith({
    Word? currentWord,
    List<String>? contextIds,
    bool? isLoading,
    String? playingAudioId,
  }) {
    return WordDetailState(
      currentWord: currentWord ?? this.currentWord,
      contextIds: contextIds ?? this.contextIds,
      isLoading: isLoading ?? this.isLoading,
      playingAudioId: playingAudioId,
    );
  }
}

@riverpod
class WordDetail extends _$WordDetail {
  @override
  Future<WordDetailState> build(String wordId) async {
    final dao = ref.watch(wordDaoProvider);
    final data = await dao.getWordWithExamples(wordId);
    
    if (data == null) {
      return const WordDetailState(isLoading: false);
    }

    final word = _mapToWord(data);
    
    // Fetch neighbor words for swiping (same level)
    final allWords = await dao.getAllWords();
    final contextIds = allWords
        .where((w) => w.level == word.level)
        .map((w) => w.id)
        .toList();

    return WordDetailState(
      currentWord: word,
      contextIds: contextIds,
      isLoading: false,
    );
  }

  /// Get a word by ID (for swiping)
  Future<Word?> fetchWordById(String id) async {
    final data = await ref.read(wordDaoProvider).getWordWithExamples(id);
    if (data == null) return null;
    return _mapToWord(data);
  }

  void playAudio(String text, String audioId) async {
    state = AsyncValue.data(state.value!.copyWith(playingAudioId: audioId));
    // Simulate audio playback duration
    await Future.delayed(const Duration(seconds: 2));
    if (state.value?.playingAudioId == audioId) {
      state = AsyncValue.data(state.value!.copyWith(playingAudioId: null));
    }
  }

  void stopAudio() {
    state = AsyncValue.data(state.value!.copyWith(playingAudioId: null));
  }

  Word _mapToWord(WordWithExamples data) {
    final entry = data.word;
    List<FuriganaBlock> furigana = [];
    if (entry.furiganaDataJson != null) {
      final List<dynamic> jsonArr = jsonDecode(entry.furiganaDataJson!);
      furigana = jsonArr.map((f) => FuriganaBlock(
        text: f['text'] ?? '',
        furigana: f['furigana'] ?? '',
      )).toList();
    }

    return Word(
      id: entry.id,
      japanese: entry.japanese,
      hiragana: entry.hiragana,
      chinese: entry.chinese,
      level: entry.level,
      pos: entry.pos ?? '',
      isFavorite: entry.isFavorite,
      furiganaData: furigana,
      examples: data.examples.map((e) => WordExample(
        japanese: e.japanese,
        chinese: e.chinese,
      )).toList(),
    );
  }
}
