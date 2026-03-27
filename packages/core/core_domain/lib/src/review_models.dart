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
  again,
  hard,
  good,
  easy;
}

@freezed
class ReviewSession with _$ReviewSession {
  const factory ReviewSession({
    required List<ReviewItem> items,
    @Default(0) int currentIndex,
    @Default(false) bool showAnswer,
    @Default(false) bool isCompleted,
    @Default([]) List<ReviewRating> ratings,
    @Default({}) Map<String, String> ratingIntervals,
    DateTime? startTime,
  }) = _ReviewSession;

  factory ReviewSession.fromJson(Map<String, dynamic> json) => _$ReviewSessionFromJson(json);
}
