// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grammar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GrammarImpl _$$GrammarImplFromJson(Map<String, dynamic> json) =>
    _$GrammarImpl(
      id: (json['id'] as num).toInt(),
      grammar: json['grammar'] as String,
      grammarLevel: json['grammarLevel'] as String,
      isDelisted: json['isDelisted'] as bool? ?? false,
      usages: (json['usages'] as List<dynamic>)
          .map((e) => GrammarUsage.fromJson(e as Map<String, dynamic>))
          .toList(),
      repetitionCount: (json['repetitionCount'] as num?)?.toInt() ?? 0,
      interval: (json['interval'] as num?)?.toInt() ?? 0,
      stability: (json['stability'] as num?)?.toDouble() ?? 0.0,
      difficulty: (json['difficulty'] as num?)?.toDouble() ?? 0.0,
      nextReviewDate: (json['nextReviewDate'] as num?)?.toInt() ?? 0,
      lastReviewedDate: (json['lastReviewedDate'] as num?)?.toInt(),
      firstLearnedDate: (json['firstLearnedDate'] as num?)?.toInt(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      isSkipped: json['isSkipped'] as bool? ?? false,
      buriedUntilDay: (json['buriedUntilDay'] as num?)?.toInt() ?? 0,
      lastModifiedTime: (json['lastModifiedTime'] as num).toInt(),
    );

Map<String, dynamic> _$$GrammarImplToJson(_$GrammarImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'grammar': instance.grammar,
      'grammarLevel': instance.grammarLevel,
      'isDelisted': instance.isDelisted,
      'usages': instance.usages,
      'repetitionCount': instance.repetitionCount,
      'interval': instance.interval,
      'stability': instance.stability,
      'difficulty': instance.difficulty,
      'nextReviewDate': instance.nextReviewDate,
      'lastReviewedDate': instance.lastReviewedDate,
      'firstLearnedDate': instance.firstLearnedDate,
      'isFavorite': instance.isFavorite,
      'isSkipped': instance.isSkipped,
      'buriedUntilDay': instance.buriedUntilDay,
      'lastModifiedTime': instance.lastModifiedTime,
    };

_$GrammarUsageImpl _$$GrammarUsageImplFromJson(Map<String, dynamic> json) =>
    _$GrammarUsageImpl(
      subtype: json['subtype'] as String?,
      connection: json['connection'] as String,
      explanation: json['explanation'] as String,
      notes: json['notes'] as String?,
      examples: (json['examples'] as List<dynamic>)
          .map((e) => GrammarExample.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GrammarUsageImplToJson(_$GrammarUsageImpl instance) =>
    <String, dynamic>{
      'subtype': instance.subtype,
      'connection': instance.connection,
      'explanation': instance.explanation,
      'notes': instance.notes,
      'examples': instance.examples,
    };

_$GrammarExampleImpl _$$GrammarExampleImplFromJson(Map<String, dynamic> json) =>
    _$GrammarExampleImpl(
      sentence: json['sentence'] as String,
      translation: json['translation'] as String,
      source: json['source'] as String?,
      isDialog: json['isDialog'] as bool? ?? false,
    );

Map<String, dynamic> _$$GrammarExampleImplToJson(
  _$GrammarExampleImpl instance,
) => <String, dynamic>{
  'sentence': instance.sentence,
  'translation': instance.translation,
  'source': instance.source,
  'isDialog': instance.isDialog,
};
