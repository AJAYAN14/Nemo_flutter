// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CardMatchPairImpl _$$CardMatchPairImplFromJson(Map<String, dynamic> json) =>
    _$CardMatchPairImpl(
      id: json['id'] as String,
      term: json['term'] as String,
      definition: json['definition'] as String,
    );

Map<String, dynamic> _$$CardMatchPairImplToJson(_$CardMatchPairImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'term': instance.term,
      'definition': instance.definition,
    };

_$SortableCharImpl _$$SortableCharImplFromJson(Map<String, dynamic> json) =>
    _$SortableCharImpl(
      char: json['char'] as String,
      id: json['id'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
    );

Map<String, dynamic> _$$SortableCharImplToJson(_$SortableCharImpl instance) =>
    <String, dynamic>{
      'char': instance.char,
      'id': instance.id,
      'isSelected': instance.isSelected,
    };

_$TestQuestionImpl _$$TestQuestionImplFromJson(Map<String, dynamic> json) =>
    _$TestQuestionImpl(
      id: json['id'] as String,
      type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
      questionText: json['questionText'] as String,
      correctAnswer: json['correctAnswer'] as String,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      sortingOptions:
          (json['sortingOptions'] as List<dynamic>?)
              ?.map((e) => SortableChar.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      explanation: json['explanation'] as String?,
      isAnswered: json['isAnswered'] as bool? ?? false,
      isCorrect: json['isCorrect'] as bool? ?? false,
      userAnswerIndex: (json['userAnswerIndex'] as num?)?.toInt(),
      userAnswer: json['userAnswer'] as String?,
      wordId: json['wordId'] as String?,
      grammarId: json['grammarId'] as String?,
      typingQuestionType: (json['typingQuestionType'] as num?)?.toInt(),
      japanese: json['japanese'] as String?,
      hiragana: json['hiragana'] as String?,
      chinese: json['chinese'] as String?,
      matchPairs: (json['matchPairs'] as List<dynamic>?)
          ?.map((e) => CardMatchPair.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TestQuestionImplToJson(_$TestQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'questionText': instance.questionText,
      'correctAnswer': instance.correctAnswer,
      'options': instance.options,
      'sortingOptions': instance.sortingOptions,
      'explanation': instance.explanation,
      'isAnswered': instance.isAnswered,
      'isCorrect': instance.isCorrect,
      'userAnswerIndex': instance.userAnswerIndex,
      'userAnswer': instance.userAnswer,
      'wordId': instance.wordId,
      'grammarId': instance.grammarId,
      'typingQuestionType': instance.typingQuestionType,
      'japanese': instance.japanese,
      'hiragana': instance.hiragana,
      'chinese': instance.chinese,
      'matchPairs': instance.matchPairs,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.multipleChoice: 'multiple_choice',
  QuestionType.typing: 'typing',
  QuestionType.sorting: 'sorting',
  QuestionType.cardMatching: 'card_matching',
};

_$TestResultImpl _$$TestResultImplFromJson(Map<String, dynamic> json) =>
    _$TestResultImpl(
      questions: (json['questions'] as List<dynamic>)
          .map((e) => TestQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      correctCount: (json['correctCount'] as num).toInt(),
      score: (json['score'] as num).toInt(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      wordCount: (json['wordCount'] as num?)?.toInt() ?? 0,
      grammarCount: (json['grammarCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TestResultImplToJson(_$TestResultImpl instance) =>
    <String, dynamic>{
      'questions': instance.questions,
      'totalQuestions': instance.totalQuestions,
      'correctCount': instance.correctCount,
      'score': instance.score,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'duration': instance.duration.inMicroseconds,
      'wordCount': instance.wordCount,
      'grammarCount': instance.grammarCount,
    };
