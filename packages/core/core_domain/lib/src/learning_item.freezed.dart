// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StudyProgress _$StudyProgressFromJson(Map<String, dynamic> json) {
  return _StudyProgress.fromJson(json);
}

/// @nodoc
mixin _$StudyProgress {
  String get id => throw _privateConstructorUsedError;
  String get itemType => throw _privateConstructorUsedError;
  int get repetitionCount => throw _privateConstructorUsedError;
  int get interval => throw _privateConstructorUsedError;
  double get easeFactor => throw _privateConstructorUsedError;
  int get dueTime => throw _privateConstructorUsedError;
  int? get lastReviewed => throw _privateConstructorUsedError;
  int? get firstLearned => throw _privateConstructorUsedError;
  int get step => throw _privateConstructorUsedError;
  bool get isSuspended => throw _privateConstructorUsedError;
  int get lapses => throw _privateConstructorUsedError;
  bool get isSkipped => throw _privateConstructorUsedError;
  int get lastModifiedTime => throw _privateConstructorUsedError;

  /// Serializes this StudyProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudyProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudyProgressCopyWith<StudyProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudyProgressCopyWith<$Res> {
  factory $StudyProgressCopyWith(
    StudyProgress value,
    $Res Function(StudyProgress) then,
  ) = _$StudyProgressCopyWithImpl<$Res, StudyProgress>;
  @useResult
  $Res call({
    String id,
    String itemType,
    int repetitionCount,
    int interval,
    double easeFactor,
    int dueTime,
    int? lastReviewed,
    int? firstLearned,
    int step,
    bool isSuspended,
    int lapses,
    bool isSkipped,
    int lastModifiedTime,
  });
}

/// @nodoc
class _$StudyProgressCopyWithImpl<$Res, $Val extends StudyProgress>
    implements $StudyProgressCopyWith<$Res> {
  _$StudyProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudyProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemType = null,
    Object? repetitionCount = null,
    Object? interval = null,
    Object? easeFactor = null,
    Object? dueTime = null,
    Object? lastReviewed = freezed,
    Object? firstLearned = freezed,
    Object? step = null,
    Object? isSuspended = null,
    Object? lapses = null,
    Object? isSkipped = null,
    Object? lastModifiedTime = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            itemType: null == itemType
                ? _value.itemType
                : itemType // ignore: cast_nullable_to_non_nullable
                      as String,
            repetitionCount: null == repetitionCount
                ? _value.repetitionCount
                : repetitionCount // ignore: cast_nullable_to_non_nullable
                      as int,
            interval: null == interval
                ? _value.interval
                : interval // ignore: cast_nullable_to_non_nullable
                      as int,
            easeFactor: null == easeFactor
                ? _value.easeFactor
                : easeFactor // ignore: cast_nullable_to_non_nullable
                      as double,
            dueTime: null == dueTime
                ? _value.dueTime
                : dueTime // ignore: cast_nullable_to_non_nullable
                      as int,
            lastReviewed: freezed == lastReviewed
                ? _value.lastReviewed
                : lastReviewed // ignore: cast_nullable_to_non_nullable
                      as int?,
            firstLearned: freezed == firstLearned
                ? _value.firstLearned
                : firstLearned // ignore: cast_nullable_to_non_nullable
                      as int?,
            step: null == step
                ? _value.step
                : step // ignore: cast_nullable_to_non_nullable
                      as int,
            isSuspended: null == isSuspended
                ? _value.isSuspended
                : isSuspended // ignore: cast_nullable_to_non_nullable
                      as bool,
            lapses: null == lapses
                ? _value.lapses
                : lapses // ignore: cast_nullable_to_non_nullable
                      as int,
            isSkipped: null == isSkipped
                ? _value.isSkipped
                : isSkipped // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastModifiedTime: null == lastModifiedTime
                ? _value.lastModifiedTime
                : lastModifiedTime // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudyProgressImplCopyWith<$Res>
    implements $StudyProgressCopyWith<$Res> {
  factory _$$StudyProgressImplCopyWith(
    _$StudyProgressImpl value,
    $Res Function(_$StudyProgressImpl) then,
  ) = __$$StudyProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String itemType,
    int repetitionCount,
    int interval,
    double easeFactor,
    int dueTime,
    int? lastReviewed,
    int? firstLearned,
    int step,
    bool isSuspended,
    int lapses,
    bool isSkipped,
    int lastModifiedTime,
  });
}

/// @nodoc
class __$$StudyProgressImplCopyWithImpl<$Res>
    extends _$StudyProgressCopyWithImpl<$Res, _$StudyProgressImpl>
    implements _$$StudyProgressImplCopyWith<$Res> {
  __$$StudyProgressImplCopyWithImpl(
    _$StudyProgressImpl _value,
    $Res Function(_$StudyProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudyProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemType = null,
    Object? repetitionCount = null,
    Object? interval = null,
    Object? easeFactor = null,
    Object? dueTime = null,
    Object? lastReviewed = freezed,
    Object? firstLearned = freezed,
    Object? step = null,
    Object? isSuspended = null,
    Object? lapses = null,
    Object? isSkipped = null,
    Object? lastModifiedTime = null,
  }) {
    return _then(
      _$StudyProgressImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        itemType: null == itemType
            ? _value.itemType
            : itemType // ignore: cast_nullable_to_non_nullable
                  as String,
        repetitionCount: null == repetitionCount
            ? _value.repetitionCount
            : repetitionCount // ignore: cast_nullable_to_non_nullable
                  as int,
        interval: null == interval
            ? _value.interval
            : interval // ignore: cast_nullable_to_non_nullable
                  as int,
        easeFactor: null == easeFactor
            ? _value.easeFactor
            : easeFactor // ignore: cast_nullable_to_non_nullable
                  as double,
        dueTime: null == dueTime
            ? _value.dueTime
            : dueTime // ignore: cast_nullable_to_non_nullable
                  as int,
        lastReviewed: freezed == lastReviewed
            ? _value.lastReviewed
            : lastReviewed // ignore: cast_nullable_to_non_nullable
                  as int?,
        firstLearned: freezed == firstLearned
            ? _value.firstLearned
            : firstLearned // ignore: cast_nullable_to_non_nullable
                  as int?,
        step: null == step
            ? _value.step
            : step // ignore: cast_nullable_to_non_nullable
                  as int,
        isSuspended: null == isSuspended
            ? _value.isSuspended
            : isSuspended // ignore: cast_nullable_to_non_nullable
                  as bool,
        lapses: null == lapses
            ? _value.lapses
            : lapses // ignore: cast_nullable_to_non_nullable
                  as int,
        isSkipped: null == isSkipped
            ? _value.isSkipped
            : isSkipped // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastModifiedTime: null == lastModifiedTime
            ? _value.lastModifiedTime
            : lastModifiedTime // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudyProgressImpl implements _StudyProgress {
  const _$StudyProgressImpl({
    required this.id,
    required this.itemType,
    this.repetitionCount = 0,
    this.interval = 0,
    this.easeFactor = 0.0,
    this.dueTime = 0,
    this.lastReviewed,
    this.firstLearned,
    this.step = 0,
    this.isSuspended = false,
    this.lapses = 0,
    this.isSkipped = false,
    this.lastModifiedTime = 0,
  });

  factory _$StudyProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudyProgressImplFromJson(json);

  @override
  final String id;
  @override
  final String itemType;
  @override
  @JsonKey()
  final int repetitionCount;
  @override
  @JsonKey()
  final int interval;
  @override
  @JsonKey()
  final double easeFactor;
  @override
  @JsonKey()
  final int dueTime;
  @override
  final int? lastReviewed;
  @override
  final int? firstLearned;
  @override
  @JsonKey()
  final int step;
  @override
  @JsonKey()
  final bool isSuspended;
  @override
  @JsonKey()
  final int lapses;
  @override
  @JsonKey()
  final bool isSkipped;
  @override
  @JsonKey()
  final int lastModifiedTime;

  @override
  String toString() {
    return 'StudyProgress(id: $id, itemType: $itemType, repetitionCount: $repetitionCount, interval: $interval, easeFactor: $easeFactor, dueTime: $dueTime, lastReviewed: $lastReviewed, firstLearned: $firstLearned, step: $step, isSuspended: $isSuspended, lapses: $lapses, isSkipped: $isSkipped, lastModifiedTime: $lastModifiedTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudyProgressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemType, itemType) ||
                other.itemType == itemType) &&
            (identical(other.repetitionCount, repetitionCount) ||
                other.repetitionCount == repetitionCount) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.easeFactor, easeFactor) ||
                other.easeFactor == easeFactor) &&
            (identical(other.dueTime, dueTime) || other.dueTime == dueTime) &&
            (identical(other.lastReviewed, lastReviewed) ||
                other.lastReviewed == lastReviewed) &&
            (identical(other.firstLearned, firstLearned) ||
                other.firstLearned == firstLearned) &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.isSuspended, isSuspended) ||
                other.isSuspended == isSuspended) &&
            (identical(other.lapses, lapses) || other.lapses == lapses) &&
            (identical(other.isSkipped, isSkipped) ||
                other.isSkipped == isSkipped) &&
            (identical(other.lastModifiedTime, lastModifiedTime) ||
                other.lastModifiedTime == lastModifiedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    itemType,
    repetitionCount,
    interval,
    easeFactor,
    dueTime,
    lastReviewed,
    firstLearned,
    step,
    isSuspended,
    lapses,
    isSkipped,
    lastModifiedTime,
  );

  /// Create a copy of StudyProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudyProgressImplCopyWith<_$StudyProgressImpl> get copyWith =>
      __$$StudyProgressImplCopyWithImpl<_$StudyProgressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudyProgressImplToJson(this);
  }
}

abstract class _StudyProgress implements StudyProgress {
  const factory _StudyProgress({
    required final String id,
    required final String itemType,
    final int repetitionCount,
    final int interval,
    final double easeFactor,
    final int dueTime,
    final int? lastReviewed,
    final int? firstLearned,
    final int step,
    final bool isSuspended,
    final int lapses,
    final bool isSkipped,
    final int lastModifiedTime,
  }) = _$StudyProgressImpl;

  factory _StudyProgress.fromJson(Map<String, dynamic> json) =
      _$StudyProgressImpl.fromJson;

  @override
  String get id;
  @override
  String get itemType;
  @override
  int get repetitionCount;
  @override
  int get interval;
  @override
  double get easeFactor;
  @override
  int get dueTime;
  @override
  int? get lastReviewed;
  @override
  int? get firstLearned;
  @override
  int get step;
  @override
  bool get isSuspended;
  @override
  int get lapses;
  @override
  bool get isSkipped;
  @override
  int get lastModifiedTime;

  /// Create a copy of StudyProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudyProgressImplCopyWith<_$StudyProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
