import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_models.freezed.dart';
part 'test_models.g.dart';

enum QuestionType {
  @JsonValue('multiple_choice')
  multipleChoice,
  @JsonValue('typing')
  typing,
  @JsonValue('sorting')
  sorting,
  @JsonValue('card_matching')
  cardMatching,
}

@freezed
class CardMatchPair with _$CardMatchPair {
  const factory CardMatchPair({
    required String id,
    required String term,
    required String definition,
  }) = _CardMatchPair;

  factory CardMatchPair.fromJson(Map<String, dynamic> json) => _$CardMatchPairFromJson(json);
}

@freezed
class SortableChar with _$SortableChar {
  const factory SortableChar({
    required String char,
    required String id,
    @Default(false) bool isSelected,
  }) = _SortableChar;

  factory SortableChar.fromJson(Map<String, dynamic> json) => _$SortableCharFromJson(json);
}

@freezed
class TestQuestion with _$TestQuestion {
  const factory TestQuestion({
    required String id,
    required QuestionType type,
    required String questionText,
    required String correctAnswer,
    @Default([]) List<String> options,
    @Default([]) List<SortableChar> sortingOptions, // For sorting mode
    String? explanation,
    @Default(false) bool isAnswered,
    @Default(false) bool isCorrect,
    int? userAnswerIndex, // For multiple choice
    String? userAnswer, // For typing/sorting
    // Metadata for Furigana support & Typing feedback
    String? wordId,
    String? grammarId,
    int? typingQuestionType, // 1-6 for typing hints
    String? japanese, // Kanji (for feedback card)
    String? hiragana, // Kana (for feedback card)
    String? chinese,  // Meaning (for feedback card)
    List<CardMatchPair>? matchPairs, // For card matching mode
  }) = _TestQuestion;

  factory TestQuestion.fromJson(Map<String, dynamic> json) => _$TestQuestionFromJson(json);
}

@freezed
class TestResult with _$TestResult {
  const factory TestResult({
    required List<TestQuestion> questions,
    required int totalQuestions,
    required int correctCount,
    required int score,
    required DateTime startTime,
    required DateTime endTime,
    required Duration duration,
    @Default(0) int wordCount,
    @Default(0) int grammarCount,
  }) = _TestResult;

  factory TestResult.fromJson(Map<String, dynamic> json) => _$TestResultFromJson(json);

  factory TestResult.calculate({
    required List<TestQuestion> questions,
    required DateTime startTime,
    required DateTime endTime,
  }) {
    final correctCount = questions.where((q) => q.isCorrect).length;
    final total = questions.length;
    final score = total > 0 ? (correctCount * 100 ~/ total) : 0;

    final wordCount = questions.where((q) => q.wordId != null).length;
    final grammarCount = questions.where((q) => q.grammarId != null).length;
    
    return TestResult(
      questions: questions,
      totalQuestions: total,
      correctCount: correctCount,
      score: score,
      startTime: startTime,
      endTime: endTime,
      duration: endTime.difference(startTime),
      wordCount: wordCount,
      grammarCount: grammarCount,
    );
  }
}
