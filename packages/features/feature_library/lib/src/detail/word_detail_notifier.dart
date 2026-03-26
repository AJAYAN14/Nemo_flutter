import 'package:core_domain/core_domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../mock/mock_words.dart';

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
  WordDetailState build(String wordId) {
    // Note: In a real app, this would be an async fetch.
    // For now, we initialize from mock data.
    final state = _loadInitialWord(wordId);
    return state;
  }

  WordDetailState _loadInitialWord(String wordId) {
    try {
      final mockData = mockWords.firstWhere((w) => w.id == wordId, orElse: () => mockWords.first);
      final word = _mapMockToWord(mockData);
      
      final contextIds = mockWords
          .where((w) => w.level == word.level)
          .map((w) => w.id)
          .toList();

      return WordDetailState(
        currentWord: word,
        contextIds: contextIds,
        isLoading: false,
      );
    } catch (e) {
      return const WordDetailState(isLoading: false);
    }
  }

  /// Get a word by ID (for swiping)
  Word? getWordById(String id) {
    try {
      final mockData = mockWords.firstWhere((w) => w.id == id);
      return _mapMockToWord(mockData);
    } catch (_) {
      return null;
    }
  }

  void playAudio(String text, String audioId) async {
    state = state.copyWith(playingAudioId: audioId);
    // Simulate audio playback duration
    await Future.delayed(const Duration(seconds: 2));
    if (state.playingAudioId == audioId) {
      state = state.copyWith(playingAudioId: null);
    }
  }

  void stopAudio() {
    state = state.copyWith(playingAudioId: null);
  }

  Word _mapMockToWord(WordMockData mock) {
    return Word(
      id: mock.id,
      japanese: mock.kanji,
      hiragana: mock.hiragana,
      chinese: mock.meaning,
      level: mock.level,
      pos: mock.type,
      isFavorite: mock.isFavorite,
      furiganaData: mock.furiganaData.map((f) => FuriganaBlock(
        text: f.text,
        furigana: f.furigana,
      )).toList(),
      examples: mock.examples.map((e) => WordExample(
        japanese: e.japanese,
        chinese: e.chinese,
      )).toList(),
    );
  }
}
