// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grammar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Grammar _$GrammarFromJson(Map<String, dynamic> json) {
  return _Grammar.fromJson(json);
}

/// @nodoc
mixin _$Grammar {
  int get id => throw _privateConstructorUsedError;
  String get grammar => throw _privateConstructorUsedError;
  String get grammarLevel => throw _privateConstructorUsedError;
  bool get isDelisted => throw _privateConstructorUsedError;
  List<GrammarUsage> get usages =>
      throw _privateConstructorUsedError; // SRS fields
  int get repetitionCount => throw _privateConstructorUsedError;
  int get interval => throw _privateConstructorUsedError;
  double get stability => throw _privateConstructorUsedError;
  double get difficulty => throw _privateConstructorUsedError;
  int get nextReviewDate => throw _privateConstructorUsedError;
  int? get lastReviewedDate => throw _privateConstructorUsedError;
  int? get firstLearnedDate => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  bool get isSkipped => throw _privateConstructorUsedError;
  int get buriedUntilDay => throw _privateConstructorUsedError;
  int get lastModifiedTime => throw _privateConstructorUsedError;

  /// Serializes this Grammar to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Grammar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GrammarCopyWith<Grammar> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GrammarCopyWith<$Res> {
  factory $GrammarCopyWith(Grammar value, $Res Function(Grammar) then) =
      _$GrammarCopyWithImpl<$Res, Grammar>;
  @useResult
  $Res call({
    int id,
    String grammar,
    String grammarLevel,
    bool isDelisted,
    List<GrammarUsage> usages,
    int repetitionCount,
    int interval,
    double stability,
    double difficulty,
    int nextReviewDate,
    int? lastReviewedDate,
    int? firstLearnedDate,
    bool isFavorite,
    bool isSkipped,
    int buriedUntilDay,
    int lastModifiedTime,
  });
}

/// @nodoc
class _$GrammarCopyWithImpl<$Res, $Val extends Grammar>
    implements $GrammarCopyWith<$Res> {
  _$GrammarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Grammar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? grammar = null,
    Object? grammarLevel = null,
    Object? isDelisted = null,
    Object? usages = null,
    Object? repetitionCount = null,
    Object? interval = null,
    Object? stability = null,
    Object? difficulty = null,
    Object? nextReviewDate = null,
    Object? lastReviewedDate = freezed,
    Object? firstLearnedDate = freezed,
    Object? isFavorite = null,
    Object? isSkipped = null,
    Object? buriedUntilDay = null,
    Object? lastModifiedTime = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            grammar: null == grammar
                ? _value.grammar
                : grammar // ignore: cast_nullable_to_non_nullable
                      as String,
            grammarLevel: null == grammarLevel
                ? _value.grammarLevel
                : grammarLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            isDelisted: null == isDelisted
                ? _value.isDelisted
                : isDelisted // ignore: cast_nullable_to_non_nullable
                      as bool,
            usages: null == usages
                ? _value.usages
                : usages // ignore: cast_nullable_to_non_nullable
                      as List<GrammarUsage>,
            repetitionCount: null == repetitionCount
                ? _value.repetitionCount
                : repetitionCount // ignore: cast_nullable_to_non_nullable
                      as int,
            interval: null == interval
                ? _value.interval
                : interval // ignore: cast_nullable_to_non_nullable
                      as int,
            stability: null == stability
                ? _value.stability
                : stability // ignore: cast_nullable_to_non_nullable
                      as double,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as double,
            nextReviewDate: null == nextReviewDate
                ? _value.nextReviewDate
                : nextReviewDate // ignore: cast_nullable_to_non_nullable
                      as int,
            lastReviewedDate: freezed == lastReviewedDate
                ? _value.lastReviewedDate
                : lastReviewedDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            firstLearnedDate: freezed == firstLearnedDate
                ? _value.firstLearnedDate
                : firstLearnedDate // ignore: cast_nullable_to_non_nullable
                      as int?,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSkipped: null == isSkipped
                ? _value.isSkipped
                : isSkipped // ignore: cast_nullable_to_non_nullable
                      as bool,
            buriedUntilDay: null == buriedUntilDay
                ? _value.buriedUntilDay
                : buriedUntilDay // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$GrammarImplCopyWith<$Res> implements $GrammarCopyWith<$Res> {
  factory _$$GrammarImplCopyWith(
    _$GrammarImpl value,
    $Res Function(_$GrammarImpl) then,
  ) = __$$GrammarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String grammar,
    String grammarLevel,
    bool isDelisted,
    List<GrammarUsage> usages,
    int repetitionCount,
    int interval,
    double stability,
    double difficulty,
    int nextReviewDate,
    int? lastReviewedDate,
    int? firstLearnedDate,
    bool isFavorite,
    bool isSkipped,
    int buriedUntilDay,
    int lastModifiedTime,
  });
}

/// @nodoc
class __$$GrammarImplCopyWithImpl<$Res>
    extends _$GrammarCopyWithImpl<$Res, _$GrammarImpl>
    implements _$$GrammarImplCopyWith<$Res> {
  __$$GrammarImplCopyWithImpl(
    _$GrammarImpl _value,
    $Res Function(_$GrammarImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Grammar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? grammar = null,
    Object? grammarLevel = null,
    Object? isDelisted = null,
    Object? usages = null,
    Object? repetitionCount = null,
    Object? interval = null,
    Object? stability = null,
    Object? difficulty = null,
    Object? nextReviewDate = null,
    Object? lastReviewedDate = freezed,
    Object? firstLearnedDate = freezed,
    Object? isFavorite = null,
    Object? isSkipped = null,
    Object? buriedUntilDay = null,
    Object? lastModifiedTime = null,
  }) {
    return _then(
      _$GrammarImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        grammar: null == grammar
            ? _value.grammar
            : grammar // ignore: cast_nullable_to_non_nullable
                  as String,
        grammarLevel: null == grammarLevel
            ? _value.grammarLevel
            : grammarLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        isDelisted: null == isDelisted
            ? _value.isDelisted
            : isDelisted // ignore: cast_nullable_to_non_nullable
                  as bool,
        usages: null == usages
            ? _value._usages
            : usages // ignore: cast_nullable_to_non_nullable
                  as List<GrammarUsage>,
        repetitionCount: null == repetitionCount
            ? _value.repetitionCount
            : repetitionCount // ignore: cast_nullable_to_non_nullable
                  as int,
        interval: null == interval
            ? _value.interval
            : interval // ignore: cast_nullable_to_non_nullable
                  as int,
        stability: null == stability
            ? _value.stability
            : stability // ignore: cast_nullable_to_non_nullable
                  as double,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as double,
        nextReviewDate: null == nextReviewDate
            ? _value.nextReviewDate
            : nextReviewDate // ignore: cast_nullable_to_non_nullable
                  as int,
        lastReviewedDate: freezed == lastReviewedDate
            ? _value.lastReviewedDate
            : lastReviewedDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        firstLearnedDate: freezed == firstLearnedDate
            ? _value.firstLearnedDate
            : firstLearnedDate // ignore: cast_nullable_to_non_nullable
                  as int?,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSkipped: null == isSkipped
            ? _value.isSkipped
            : isSkipped // ignore: cast_nullable_to_non_nullable
                  as bool,
        buriedUntilDay: null == buriedUntilDay
            ? _value.buriedUntilDay
            : buriedUntilDay // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$GrammarImpl implements _Grammar {
  const _$GrammarImpl({
    required this.id,
    required this.grammar,
    required this.grammarLevel,
    this.isDelisted = false,
    required final List<GrammarUsage> usages,
    this.repetitionCount = 0,
    this.interval = 0,
    this.stability = 0.0,
    this.difficulty = 0.0,
    this.nextReviewDate = 0,
    this.lastReviewedDate,
    this.firstLearnedDate,
    this.isFavorite = false,
    this.isSkipped = false,
    this.buriedUntilDay = 0,
    required this.lastModifiedTime,
  }) : _usages = usages;

  factory _$GrammarImpl.fromJson(Map<String, dynamic> json) =>
      _$$GrammarImplFromJson(json);

  @override
  final int id;
  @override
  final String grammar;
  @override
  final String grammarLevel;
  @override
  @JsonKey()
  final bool isDelisted;
  final List<GrammarUsage> _usages;
  @override
  List<GrammarUsage> get usages {
    if (_usages is EqualUnmodifiableListView) return _usages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_usages);
  }

  // SRS fields
  @override
  @JsonKey()
  final int repetitionCount;
  @override
  @JsonKey()
  final int interval;
  @override
  @JsonKey()
  final double stability;
  @override
  @JsonKey()
  final double difficulty;
  @override
  @JsonKey()
  final int nextReviewDate;
  @override
  final int? lastReviewedDate;
  @override
  final int? firstLearnedDate;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  @JsonKey()
  final bool isSkipped;
  @override
  @JsonKey()
  final int buriedUntilDay;
  @override
  final int lastModifiedTime;

  @override
  String toString() {
    return 'Grammar(id: $id, grammar: $grammar, grammarLevel: $grammarLevel, isDelisted: $isDelisted, usages: $usages, repetitionCount: $repetitionCount, interval: $interval, stability: $stability, difficulty: $difficulty, nextReviewDate: $nextReviewDate, lastReviewedDate: $lastReviewedDate, firstLearnedDate: $firstLearnedDate, isFavorite: $isFavorite, isSkipped: $isSkipped, buriedUntilDay: $buriedUntilDay, lastModifiedTime: $lastModifiedTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GrammarImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.grammar, grammar) || other.grammar == grammar) &&
            (identical(other.grammarLevel, grammarLevel) ||
                other.grammarLevel == grammarLevel) &&
            (identical(other.isDelisted, isDelisted) ||
                other.isDelisted == isDelisted) &&
            const DeepCollectionEquality().equals(other._usages, _usages) &&
            (identical(other.repetitionCount, repetitionCount) ||
                other.repetitionCount == repetitionCount) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.stability, stability) ||
                other.stability == stability) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.nextReviewDate, nextReviewDate) ||
                other.nextReviewDate == nextReviewDate) &&
            (identical(other.lastReviewedDate, lastReviewedDate) ||
                other.lastReviewedDate == lastReviewedDate) &&
            (identical(other.firstLearnedDate, firstLearnedDate) ||
                other.firstLearnedDate == firstLearnedDate) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isSkipped, isSkipped) ||
                other.isSkipped == isSkipped) &&
            (identical(other.buriedUntilDay, buriedUntilDay) ||
                other.buriedUntilDay == buriedUntilDay) &&
            (identical(other.lastModifiedTime, lastModifiedTime) ||
                other.lastModifiedTime == lastModifiedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    grammar,
    grammarLevel,
    isDelisted,
    const DeepCollectionEquality().hash(_usages),
    repetitionCount,
    interval,
    stability,
    difficulty,
    nextReviewDate,
    lastReviewedDate,
    firstLearnedDate,
    isFavorite,
    isSkipped,
    buriedUntilDay,
    lastModifiedTime,
  );

  /// Create a copy of Grammar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GrammarImplCopyWith<_$GrammarImpl> get copyWith =>
      __$$GrammarImplCopyWithImpl<_$GrammarImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GrammarImplToJson(this);
  }
}

abstract class _Grammar implements Grammar {
  const factory _Grammar({
    required final int id,
    required final String grammar,
    required final String grammarLevel,
    final bool isDelisted,
    required final List<GrammarUsage> usages,
    final int repetitionCount,
    final int interval,
    final double stability,
    final double difficulty,
    final int nextReviewDate,
    final int? lastReviewedDate,
    final int? firstLearnedDate,
    final bool isFavorite,
    final bool isSkipped,
    final int buriedUntilDay,
    required final int lastModifiedTime,
  }) = _$GrammarImpl;

  factory _Grammar.fromJson(Map<String, dynamic> json) = _$GrammarImpl.fromJson;

  @override
  int get id;
  @override
  String get grammar;
  @override
  String get grammarLevel;
  @override
  bool get isDelisted;
  @override
  List<GrammarUsage> get usages; // SRS fields
  @override
  int get repetitionCount;
  @override
  int get interval;
  @override
  double get stability;
  @override
  double get difficulty;
  @override
  int get nextReviewDate;
  @override
  int? get lastReviewedDate;
  @override
  int? get firstLearnedDate;
  @override
  bool get isFavorite;
  @override
  bool get isSkipped;
  @override
  int get buriedUntilDay;
  @override
  int get lastModifiedTime;

  /// Create a copy of Grammar
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GrammarImplCopyWith<_$GrammarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GrammarUsage _$GrammarUsageFromJson(Map<String, dynamic> json) {
  return _GrammarUsage.fromJson(json);
}

/// @nodoc
mixin _$GrammarUsage {
  String? get subtype => throw _privateConstructorUsedError;
  String get connection => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<GrammarExample> get examples => throw _privateConstructorUsedError;

  /// Serializes this GrammarUsage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GrammarUsage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GrammarUsageCopyWith<GrammarUsage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GrammarUsageCopyWith<$Res> {
  factory $GrammarUsageCopyWith(
    GrammarUsage value,
    $Res Function(GrammarUsage) then,
  ) = _$GrammarUsageCopyWithImpl<$Res, GrammarUsage>;
  @useResult
  $Res call({
    String? subtype,
    String connection,
    String explanation,
    String? notes,
    List<GrammarExample> examples,
  });
}

/// @nodoc
class _$GrammarUsageCopyWithImpl<$Res, $Val extends GrammarUsage>
    implements $GrammarUsageCopyWith<$Res> {
  _$GrammarUsageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GrammarUsage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtype = freezed,
    Object? connection = null,
    Object? explanation = null,
    Object? notes = freezed,
    Object? examples = null,
  }) {
    return _then(
      _value.copyWith(
            subtype: freezed == subtype
                ? _value.subtype
                : subtype // ignore: cast_nullable_to_non_nullable
                      as String?,
            connection: null == connection
                ? _value.connection
                : connection // ignore: cast_nullable_to_non_nullable
                      as String,
            explanation: null == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            examples: null == examples
                ? _value.examples
                : examples // ignore: cast_nullable_to_non_nullable
                      as List<GrammarExample>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GrammarUsageImplCopyWith<$Res>
    implements $GrammarUsageCopyWith<$Res> {
  factory _$$GrammarUsageImplCopyWith(
    _$GrammarUsageImpl value,
    $Res Function(_$GrammarUsageImpl) then,
  ) = __$$GrammarUsageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? subtype,
    String connection,
    String explanation,
    String? notes,
    List<GrammarExample> examples,
  });
}

/// @nodoc
class __$$GrammarUsageImplCopyWithImpl<$Res>
    extends _$GrammarUsageCopyWithImpl<$Res, _$GrammarUsageImpl>
    implements _$$GrammarUsageImplCopyWith<$Res> {
  __$$GrammarUsageImplCopyWithImpl(
    _$GrammarUsageImpl _value,
    $Res Function(_$GrammarUsageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GrammarUsage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtype = freezed,
    Object? connection = null,
    Object? explanation = null,
    Object? notes = freezed,
    Object? examples = null,
  }) {
    return _then(
      _$GrammarUsageImpl(
        subtype: freezed == subtype
            ? _value.subtype
            : subtype // ignore: cast_nullable_to_non_nullable
                  as String?,
        connection: null == connection
            ? _value.connection
            : connection // ignore: cast_nullable_to_non_nullable
                  as String,
        explanation: null == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        examples: null == examples
            ? _value._examples
            : examples // ignore: cast_nullable_to_non_nullable
                  as List<GrammarExample>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GrammarUsageImpl implements _GrammarUsage {
  const _$GrammarUsageImpl({
    this.subtype,
    required this.connection,
    required this.explanation,
    this.notes,
    required final List<GrammarExample> examples,
  }) : _examples = examples;

  factory _$GrammarUsageImpl.fromJson(Map<String, dynamic> json) =>
      _$$GrammarUsageImplFromJson(json);

  @override
  final String? subtype;
  @override
  final String connection;
  @override
  final String explanation;
  @override
  final String? notes;
  final List<GrammarExample> _examples;
  @override
  List<GrammarExample> get examples {
    if (_examples is EqualUnmodifiableListView) return _examples;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_examples);
  }

  @override
  String toString() {
    return 'GrammarUsage(subtype: $subtype, connection: $connection, explanation: $explanation, notes: $notes, examples: $examples)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GrammarUsageImpl &&
            (identical(other.subtype, subtype) || other.subtype == subtype) &&
            (identical(other.connection, connection) ||
                other.connection == connection) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._examples, _examples));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    subtype,
    connection,
    explanation,
    notes,
    const DeepCollectionEquality().hash(_examples),
  );

  /// Create a copy of GrammarUsage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GrammarUsageImplCopyWith<_$GrammarUsageImpl> get copyWith =>
      __$$GrammarUsageImplCopyWithImpl<_$GrammarUsageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GrammarUsageImplToJson(this);
  }
}

abstract class _GrammarUsage implements GrammarUsage {
  const factory _GrammarUsage({
    final String? subtype,
    required final String connection,
    required final String explanation,
    final String? notes,
    required final List<GrammarExample> examples,
  }) = _$GrammarUsageImpl;

  factory _GrammarUsage.fromJson(Map<String, dynamic> json) =
      _$GrammarUsageImpl.fromJson;

  @override
  String? get subtype;
  @override
  String get connection;
  @override
  String get explanation;
  @override
  String? get notes;
  @override
  List<GrammarExample> get examples;

  /// Create a copy of GrammarUsage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GrammarUsageImplCopyWith<_$GrammarUsageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GrammarExample _$GrammarExampleFromJson(Map<String, dynamic> json) {
  return _GrammarExample.fromJson(json);
}

/// @nodoc
mixin _$GrammarExample {
  String get sentence => throw _privateConstructorUsedError;
  String get translation => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  bool get isDialog => throw _privateConstructorUsedError;

  /// Serializes this GrammarExample to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GrammarExample
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GrammarExampleCopyWith<GrammarExample> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GrammarExampleCopyWith<$Res> {
  factory $GrammarExampleCopyWith(
    GrammarExample value,
    $Res Function(GrammarExample) then,
  ) = _$GrammarExampleCopyWithImpl<$Res, GrammarExample>;
  @useResult
  $Res call({
    String sentence,
    String translation,
    String? source,
    bool isDialog,
  });
}

/// @nodoc
class _$GrammarExampleCopyWithImpl<$Res, $Val extends GrammarExample>
    implements $GrammarExampleCopyWith<$Res> {
  _$GrammarExampleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GrammarExample
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sentence = null,
    Object? translation = null,
    Object? source = freezed,
    Object? isDialog = null,
  }) {
    return _then(
      _value.copyWith(
            sentence: null == sentence
                ? _value.sentence
                : sentence // ignore: cast_nullable_to_non_nullable
                      as String,
            translation: null == translation
                ? _value.translation
                : translation // ignore: cast_nullable_to_non_nullable
                      as String,
            source: freezed == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String?,
            isDialog: null == isDialog
                ? _value.isDialog
                : isDialog // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GrammarExampleImplCopyWith<$Res>
    implements $GrammarExampleCopyWith<$Res> {
  factory _$$GrammarExampleImplCopyWith(
    _$GrammarExampleImpl value,
    $Res Function(_$GrammarExampleImpl) then,
  ) = __$$GrammarExampleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String sentence,
    String translation,
    String? source,
    bool isDialog,
  });
}

/// @nodoc
class __$$GrammarExampleImplCopyWithImpl<$Res>
    extends _$GrammarExampleCopyWithImpl<$Res, _$GrammarExampleImpl>
    implements _$$GrammarExampleImplCopyWith<$Res> {
  __$$GrammarExampleImplCopyWithImpl(
    _$GrammarExampleImpl _value,
    $Res Function(_$GrammarExampleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GrammarExample
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sentence = null,
    Object? translation = null,
    Object? source = freezed,
    Object? isDialog = null,
  }) {
    return _then(
      _$GrammarExampleImpl(
        sentence: null == sentence
            ? _value.sentence
            : sentence // ignore: cast_nullable_to_non_nullable
                  as String,
        translation: null == translation
            ? _value.translation
            : translation // ignore: cast_nullable_to_non_nullable
                  as String,
        source: freezed == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String?,
        isDialog: null == isDialog
            ? _value.isDialog
            : isDialog // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GrammarExampleImpl implements _GrammarExample {
  const _$GrammarExampleImpl({
    required this.sentence,
    required this.translation,
    this.source,
    this.isDialog = false,
  });

  factory _$GrammarExampleImpl.fromJson(Map<String, dynamic> json) =>
      _$$GrammarExampleImplFromJson(json);

  @override
  final String sentence;
  @override
  final String translation;
  @override
  final String? source;
  @override
  @JsonKey()
  final bool isDialog;

  @override
  String toString() {
    return 'GrammarExample(sentence: $sentence, translation: $translation, source: $source, isDialog: $isDialog)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GrammarExampleImpl &&
            (identical(other.sentence, sentence) ||
                other.sentence == sentence) &&
            (identical(other.translation, translation) ||
                other.translation == translation) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.isDialog, isDialog) ||
                other.isDialog == isDialog));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, sentence, translation, source, isDialog);

  /// Create a copy of GrammarExample
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GrammarExampleImplCopyWith<_$GrammarExampleImpl> get copyWith =>
      __$$GrammarExampleImplCopyWithImpl<_$GrammarExampleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GrammarExampleImplToJson(this);
  }
}

abstract class _GrammarExample implements GrammarExample {
  const factory _GrammarExample({
    required final String sentence,
    required final String translation,
    final String? source,
    final bool isDialog,
  }) = _$GrammarExampleImpl;

  factory _GrammarExample.fromJson(Map<String, dynamic> json) =
      _$GrammarExampleImpl.fromJson;

  @override
  String get sentence;
  @override
  String get translation;
  @override
  String? get source;
  @override
  bool get isDialog;

  /// Create a copy of GrammarExample
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GrammarExampleImplCopyWith<_$GrammarExampleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
