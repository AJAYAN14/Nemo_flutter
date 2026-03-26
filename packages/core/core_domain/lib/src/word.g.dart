// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WordImpl _$$WordImplFromJson(Map<String, dynamic> json) => _$WordImpl(
  id: json['id'] as String,
  japanese: json['japanese'] as String,
  hiragana: json['hiragana'] as String,
  chinese: json['chinese'] as String,
  level: json['level'] as String,
  pos: json['pos'] as String?,
  examples:
      (json['examples'] as List<dynamic>?)
          ?.map((e) => WordExample.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  furiganaData:
      (json['furiganaData'] as List<dynamic>?)
          ?.map((e) => FuriganaBlock.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isFavorite: json['isFavorite'] as bool? ?? false,
);

Map<String, dynamic> _$$WordImplToJson(_$WordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'japanese': instance.japanese,
      'hiragana': instance.hiragana,
      'chinese': instance.chinese,
      'level': instance.level,
      'pos': instance.pos,
      'examples': instance.examples,
      'furiganaData': instance.furiganaData,
      'isFavorite': instance.isFavorite,
    };

_$WordExampleImpl _$$WordExampleImplFromJson(Map<String, dynamic> json) =>
    _$WordExampleImpl(
      japanese: json['japanese'] as String,
      chinese: json['chinese'] as String,
      audioId: json['audioId'] as String?,
    );

Map<String, dynamic> _$$WordExampleImplToJson(_$WordExampleImpl instance) =>
    <String, dynamic>{
      'japanese': instance.japanese,
      'chinese': instance.chinese,
      'audioId': instance.audioId,
    };

_$FuriganaBlockImpl _$$FuriganaBlockImplFromJson(Map<String, dynamic> json) =>
    _$FuriganaBlockImpl(
      text: json['text'] as String,
      furigana: json['furigana'] as String?,
    );

Map<String, dynamic> _$$FuriganaBlockImplToJson(_$FuriganaBlockImpl instance) =>
    <String, dynamic>{'text': instance.text, 'furigana': instance.furigana};
