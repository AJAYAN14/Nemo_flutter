import 'package:freezed_annotation/freezed_annotation.dart';
import 'word.dart';
import 'grammar.dart';

part 'review_models.freezed.dart';
part 'review_models.g.dart';

@freezed
class ReviewItem with _$ReviewItem {
  const factory ReviewItem.word({
    required Word word,
    @Default(0) int intervalDays,
    @Default(1.0) double easeFactor,
    DateTime? lastReviewed,
    DateTime? nextReviewDate,
  }) = WordReviewItem;

  const factory ReviewItem.grammar({
    required Grammar grammar,
    @Default(0) int intervalDays,
    @Default(1.0) double easeFactor,
    DateTime? lastReviewed,
    DateTime? nextReviewDate,
  }) = GrammarReviewItem;

  factory ReviewItem.fromJson(Map<String, dynamic> json) => _$ReviewItemFromJson(json);
}

enum ReviewRating {
  again, // 重新
  hard,  // 困难
  good,  // 良好
  easy;   // 简单

  String get label {
    switch (this) {
      case ReviewRating.again: return '重新';
      case ReviewRating.hard: return '困难';
      case ReviewRating.good: return '良好';
      case ReviewRating.easy: return '简单';
    }
  }

  String getIntervalLabel(int currentInterval) {
    // Simple mock SRS logic for labels as seen in premium apps
    switch (this) {
      case ReviewRating.again: return '1m';
      case ReviewRating.hard: return '${(currentInterval * 1.2).ceil().clamp(1, 365)}d';
      case ReviewRating.good: return '${(currentInterval * 2.5).ceil().clamp(1, 365)}d';
      case ReviewRating.easy: return '${(currentInterval * 4.0).ceil().clamp(1, 365)}d';
    }
  }
}

@freezed
class ReviewSession with _$ReviewSession {
  const factory ReviewSession({
    required List<ReviewItem> items,
    @Default(0) int currentIndex,
    @Default(false) bool showAnswer,
    @Default(false) bool isCompleted,
    @Default([]) List<ReviewRating> ratings,
    DateTime? startTime,
  }) = _ReviewSession;

  factory ReviewSession.fromJson(Map<String, dynamic> json) => _$ReviewSessionFromJson(json);
}
