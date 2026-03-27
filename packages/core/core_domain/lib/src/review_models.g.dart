// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WordReviewItemImpl _$$WordReviewItemImplFromJson(Map<String, dynamic> json) =>
    _$WordReviewItemImpl(
      word: Word.fromJson(json['word'] as Map<String, dynamic>),
      intervalDays: (json['intervalDays'] as num?)?.toInt() ?? 0,
      easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 1.0,
      lastReviewed: json['lastReviewed'] == null
          ? null
          : DateTime.parse(json['lastReviewed'] as String),
      nextReviewDate: json['nextReviewDate'] == null
          ? null
          : DateTime.parse(json['nextReviewDate'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$WordReviewItemImplToJson(
  _$WordReviewItemImpl instance,
) => <String, dynamic>{
  'word': instance.word,
  'intervalDays': instance.intervalDays,
  'easeFactor': instance.easeFactor,
  'lastReviewed': instance.lastReviewed?.toIso8601String(),
  'nextReviewDate': instance.nextReviewDate?.toIso8601String(),
  'runtimeType': instance.$type,
};

_$GrammarReviewItemImpl _$$GrammarReviewItemImplFromJson(
  Map<String, dynamic> json,
) => _$GrammarReviewItemImpl(
  grammar: Grammar.fromJson(json['grammar'] as Map<String, dynamic>),
  intervalDays: (json['intervalDays'] as num?)?.toInt() ?? 0,
  easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 1.0,
  lastReviewed: json['lastReviewed'] == null
      ? null
      : DateTime.parse(json['lastReviewed'] as String),
  nextReviewDate: json['nextReviewDate'] == null
      ? null
      : DateTime.parse(json['nextReviewDate'] as String),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$GrammarReviewItemImplToJson(
  _$GrammarReviewItemImpl instance,
) => <String, dynamic>{
  'grammar': instance.grammar,
  'intervalDays': instance.intervalDays,
  'easeFactor': instance.easeFactor,
  'lastReviewed': instance.lastReviewed?.toIso8601String(),
  'nextReviewDate': instance.nextReviewDate?.toIso8601String(),
  'runtimeType': instance.$type,
};

_$ReviewSessionImpl _$$ReviewSessionImplFromJson(Map<String, dynamic> json) =>
    _$ReviewSessionImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => ReviewItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentIndex: (json['currentIndex'] as num?)?.toInt() ?? 0,
      showAnswer: json['showAnswer'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
      ratings:
          (json['ratings'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ReviewRatingEnumMap, e))
              .toList() ??
          const [],
      ratingIntervals:
          (json['ratingIntervals'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
    );

Map<String, dynamic> _$$ReviewSessionImplToJson(
  _$ReviewSessionImpl instance,
) => <String, dynamic>{
  'items': instance.items,
  'currentIndex': instance.currentIndex,
  'showAnswer': instance.showAnswer,
  'isCompleted': instance.isCompleted,
  'ratings': instance.ratings.map((e) => _$ReviewRatingEnumMap[e]!).toList(),
  'ratingIntervals': instance.ratingIntervals,
  'startTime': instance.startTime?.toIso8601String(),
};

const _$ReviewRatingEnumMap = {
  ReviewRating.again: 'again',
  ReviewRating.hard: 'hard',
  ReviewRating.good: 'good',
  ReviewRating.easy: 'easy',
};
