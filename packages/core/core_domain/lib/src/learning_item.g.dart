// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudyProgressImpl _$$StudyProgressImplFromJson(Map<String, dynamic> json) =>
    _$StudyProgressImpl(
      id: json['id'] as String,
      itemType: json['itemType'] as String,
      repetitionCount: (json['repetitionCount'] as num?)?.toInt() ?? 0,
      interval: (json['interval'] as num?)?.toInt() ?? 0,
      easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 0.0,
      dueTime: (json['dueTime'] as num?)?.toInt() ?? 0,
      lastReviewed: (json['lastReviewed'] as num?)?.toInt(),
      firstLearned: (json['firstLearned'] as num?)?.toInt(),
      step: (json['step'] as num?)?.toInt() ?? 0,
      isSuspended: json['isSuspended'] as bool? ?? false,
      lapses: (json['lapses'] as num?)?.toInt() ?? 0,
      isSkipped: json['isSkipped'] as bool? ?? false,
      buriedUntilDay: (json['buriedUntilDay'] as num?)?.toInt() ?? 0,
      lastModifiedTime: (json['lastModifiedTime'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$StudyProgressImplToJson(_$StudyProgressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemType': instance.itemType,
      'repetitionCount': instance.repetitionCount,
      'interval': instance.interval,
      'easeFactor': instance.easeFactor,
      'dueTime': instance.dueTime,
      'lastReviewed': instance.lastReviewed,
      'firstLearned': instance.firstLearned,
      'step': instance.step,
      'isSuspended': instance.isSuspended,
      'lapses': instance.lapses,
      'isSkipped': instance.isSkipped,
      'buriedUntilDay': instance.buriedUntilDay,
      'lastModifiedTime': instance.lastModifiedTime,
    };
