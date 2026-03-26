// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReviewItem _$ReviewItemFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'word':
      return WordReviewItem.fromJson(json);
    case 'grammar':
      return GrammarReviewItem.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'ReviewItem',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$ReviewItem {
  int get intervalDays => throw _privateConstructorUsedError;
  double get easeFactor => throw _privateConstructorUsedError;
  DateTime? get lastReviewed => throw _privateConstructorUsedError;
  DateTime? get nextReviewDate => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      Word word,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )
    word,
    required TResult Function(
      Grammar grammar,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )
    grammar,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      Word word,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )?
    word,
    TResult? Function(
      Grammar grammar,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )?
    grammar,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      Word word,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )?
    word,
    TResult Function(
      Grammar grammar,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )?
    grammar,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WordReviewItem value) word,
    required TResult Function(GrammarReviewItem value) grammar,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WordReviewItem value)? word,
    TResult? Function(GrammarReviewItem value)? grammar,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WordReviewItem value)? word,
    TResult Function(GrammarReviewItem value)? grammar,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this ReviewItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewItemCopyWith<ReviewItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewItemCopyWith<$Res> {
  factory $ReviewItemCopyWith(
    ReviewItem value,
    $Res Function(ReviewItem) then,
  ) = _$ReviewItemCopyWithImpl<$Res, ReviewItem>;
  @useResult
  $Res call({
    int intervalDays,
    double easeFactor,
    DateTime? lastReviewed,
    DateTime? nextReviewDate,
  });
}

/// @nodoc
class _$ReviewItemCopyWithImpl<$Res, $Val extends ReviewItem>
    implements $ReviewItemCopyWith<$Res> {
  _$ReviewItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intervalDays = null,
    Object? easeFactor = null,
    Object? lastReviewed = freezed,
    Object? nextReviewDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            intervalDays: null == intervalDays
                ? _value.intervalDays
                : intervalDays // ignore: cast_nullable_to_non_nullable
                      as int,
            easeFactor: null == easeFactor
                ? _value.easeFactor
                : easeFactor // ignore: cast_nullable_to_non_nullable
                      as double,
            lastReviewed: freezed == lastReviewed
                ? _value.lastReviewed
                : lastReviewed // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            nextReviewDate: freezed == nextReviewDate
                ? _value.nextReviewDate
                : nextReviewDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WordReviewItemImplCopyWith<$Res>
    implements $ReviewItemCopyWith<$Res> {
  factory _$$WordReviewItemImplCopyWith(
    _$WordReviewItemImpl value,
    $Res Function(_$WordReviewItemImpl) then,
  ) = __$$WordReviewItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Word word,
    int intervalDays,
    double easeFactor,
    DateTime? lastReviewed,
    DateTime? nextReviewDate,
  });

  $WordCopyWith<$Res> get word;
}

/// @nodoc
class __$$WordReviewItemImplCopyWithImpl<$Res>
    extends _$ReviewItemCopyWithImpl<$Res, _$WordReviewItemImpl>
    implements _$$WordReviewItemImplCopyWith<$Res> {
  __$$WordReviewItemImplCopyWithImpl(
    _$WordReviewItemImpl _value,
    $Res Function(_$WordReviewItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? word = null,
    Object? intervalDays = null,
    Object? easeFactor = null,
    Object? lastReviewed = freezed,
    Object? nextReviewDate = freezed,
  }) {
    return _then(
      _$WordReviewItemImpl(
        word: null == word
            ? _value.word
            : word // ignore: cast_nullable_to_non_nullable
                  as Word,
        intervalDays: null == intervalDays
            ? _value.intervalDays
            : intervalDays // ignore: cast_nullable_to_non_nullable
                  as int,
        easeFactor: null == easeFactor
            ? _value.easeFactor
            : easeFactor // ignore: cast_nullable_to_non_nullable
                  as double,
        lastReviewed: freezed == lastReviewed
            ? _value.lastReviewed
            : lastReviewed // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        nextReviewDate: freezed == nextReviewDate
            ? _value.nextReviewDate
            : nextReviewDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }

  /// Create a copy of ReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WordCopyWith<$Res> get word {
    return $WordCopyWith<$Res>(_value.word, (value) {
      return _then(_value.copyWith(word: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$WordReviewItemImpl implements WordReviewItem {
  const _$WordReviewItemImpl({
    required this.word,
    this.intervalDays = 0,
    this.easeFactor = 1.0,
    this.lastReviewed,
    this.nextReviewDate,
    final String? $type,
  }) : $type = $type ?? 'word';

  factory _$WordReviewItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$WordReviewItemImplFromJson(json);

  @override
  final Word word;
  @override
  @JsonKey()
  final int intervalDays;
  @override
  @JsonKey()
  final double easeFactor;
  @override
  final DateTime? lastReviewed;
  @override
  final DateTime? nextReviewDate;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ReviewItem.word(word: $word, intervalDays: $intervalDays, easeFactor: $easeFactor, lastReviewed: $lastReviewed, nextReviewDate: $nextReviewDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordReviewItemImpl &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.intervalDays, intervalDays) ||
                other.intervalDays == intervalDays) &&
            (identical(other.easeFactor, easeFactor) ||
                other.easeFactor == easeFactor) &&
            (identical(other.lastReviewed, lastReviewed) ||
                other.lastReviewed == lastReviewed) &&
            (identical(other.nextReviewDate, nextReviewDate) ||
                other.nextReviewDate == nextReviewDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    word,
    intervalDays,
    easeFactor,
    lastReviewed,
    nextReviewDate,
  );

  /// Create a copy of ReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WordReviewItemImplCopyWith<_$WordReviewItemImpl> get copyWith =>
      __$$WordReviewItemImplCopyWithImpl<_$WordReviewItemImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      Word word,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )
    word,
    required TResult Function(
      Grammar grammar,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )
    grammar,
  }) {
    return word(
      this.word,
      intervalDays,
      easeFactor,
      lastReviewed,
      nextReviewDate,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      Word word,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )?
    word,
    TResult? Function(
      Grammar grammar,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )?
    grammar,
  }) {
    return word?.call(
      this.word,
      intervalDays,
      easeFactor,
      lastReviewed,
      nextReviewDate,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      Word word,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )?
    word,
    TResult Function(
      Grammar grammar,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )?
    grammar,
    required TResult orElse(),
  }) {
    if (word != null) {
      return word(
        this.word,
        intervalDays,
        easeFactor,
        lastReviewed,
        nextReviewDate,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WordReviewItem value) word,
    required TResult Function(GrammarReviewItem value) grammar,
  }) {
    return word(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WordReviewItem value)? word,
    TResult? Function(GrammarReviewItem value)? grammar,
  }) {
    return word?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WordReviewItem value)? word,
    TResult Function(GrammarReviewItem value)? grammar,
    required TResult orElse(),
  }) {
    if (word != null) {
      return word(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$WordReviewItemImplToJson(this);
  }
}

abstract class WordReviewItem implements ReviewItem {
  const factory WordReviewItem({
    required final Word word,
    final int intervalDays,
    final double easeFactor,
    final DateTime? lastReviewed,
    final DateTime? nextReviewDate,
  }) = _$WordReviewItemImpl;

  factory WordReviewItem.fromJson(Map<String, dynamic> json) =
      _$WordReviewItemImpl.fromJson;

  Word get word;
  @override
  int get intervalDays;
  @override
  double get easeFactor;
  @override
  DateTime? get lastReviewed;
  @override
  DateTime? get nextReviewDate;

  /// Create a copy of ReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WordReviewItemImplCopyWith<_$WordReviewItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GrammarReviewItemImplCopyWith<$Res>
    implements $ReviewItemCopyWith<$Res> {
  factory _$$GrammarReviewItemImplCopyWith(
    _$GrammarReviewItemImpl value,
    $Res Function(_$GrammarReviewItemImpl) then,
  ) = __$$GrammarReviewItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Grammar grammar,
    int intervalDays,
    double easeFactor,
    DateTime? lastReviewed,
    DateTime? nextReviewDate,
  });

  $GrammarCopyWith<$Res> get grammar;
}

/// @nodoc
class __$$GrammarReviewItemImplCopyWithImpl<$Res>
    extends _$ReviewItemCopyWithImpl<$Res, _$GrammarReviewItemImpl>
    implements _$$GrammarReviewItemImplCopyWith<$Res> {
  __$$GrammarReviewItemImplCopyWithImpl(
    _$GrammarReviewItemImpl _value,
    $Res Function(_$GrammarReviewItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grammar = null,
    Object? intervalDays = null,
    Object? easeFactor = null,
    Object? lastReviewed = freezed,
    Object? nextReviewDate = freezed,
  }) {
    return _then(
      _$GrammarReviewItemImpl(
        grammar: null == grammar
            ? _value.grammar
            : grammar // ignore: cast_nullable_to_non_nullable
                  as Grammar,
        intervalDays: null == intervalDays
            ? _value.intervalDays
            : intervalDays // ignore: cast_nullable_to_non_nullable
                  as int,
        easeFactor: null == easeFactor
            ? _value.easeFactor
            : easeFactor // ignore: cast_nullable_to_non_nullable
                  as double,
        lastReviewed: freezed == lastReviewed
            ? _value.lastReviewed
            : lastReviewed // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        nextReviewDate: freezed == nextReviewDate
            ? _value.nextReviewDate
            : nextReviewDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }

  /// Create a copy of ReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GrammarCopyWith<$Res> get grammar {
    return $GrammarCopyWith<$Res>(_value.grammar, (value) {
      return _then(_value.copyWith(grammar: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$GrammarReviewItemImpl implements GrammarReviewItem {
  const _$GrammarReviewItemImpl({
    required this.grammar,
    this.intervalDays = 0,
    this.easeFactor = 1.0,
    this.lastReviewed,
    this.nextReviewDate,
    final String? $type,
  }) : $type = $type ?? 'grammar';

  factory _$GrammarReviewItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$GrammarReviewItemImplFromJson(json);

  @override
  final Grammar grammar;
  @override
  @JsonKey()
  final int intervalDays;
  @override
  @JsonKey()
  final double easeFactor;
  @override
  final DateTime? lastReviewed;
  @override
  final DateTime? nextReviewDate;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ReviewItem.grammar(grammar: $grammar, intervalDays: $intervalDays, easeFactor: $easeFactor, lastReviewed: $lastReviewed, nextReviewDate: $nextReviewDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GrammarReviewItemImpl &&
            (identical(other.grammar, grammar) || other.grammar == grammar) &&
            (identical(other.intervalDays, intervalDays) ||
                other.intervalDays == intervalDays) &&
            (identical(other.easeFactor, easeFactor) ||
                other.easeFactor == easeFactor) &&
            (identical(other.lastReviewed, lastReviewed) ||
                other.lastReviewed == lastReviewed) &&
            (identical(other.nextReviewDate, nextReviewDate) ||
                other.nextReviewDate == nextReviewDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    grammar,
    intervalDays,
    easeFactor,
    lastReviewed,
    nextReviewDate,
  );

  /// Create a copy of ReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GrammarReviewItemImplCopyWith<_$GrammarReviewItemImpl> get copyWith =>
      __$$GrammarReviewItemImplCopyWithImpl<_$GrammarReviewItemImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      Word word,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )
    word,
    required TResult Function(
      Grammar grammar,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )
    grammar,
  }) {
    return grammar(
      this.grammar,
      intervalDays,
      easeFactor,
      lastReviewed,
      nextReviewDate,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      Word word,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )?
    word,
    TResult? Function(
      Grammar grammar,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )?
    grammar,
  }) {
    return grammar?.call(
      this.grammar,
      intervalDays,
      easeFactor,
      lastReviewed,
      nextReviewDate,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      Word word,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )?
    word,
    TResult Function(
      Grammar grammar,
      int intervalDays,
      double easeFactor,
      DateTime? lastReviewed,
      DateTime? nextReviewDate,
    )?
    grammar,
    required TResult orElse(),
  }) {
    if (grammar != null) {
      return grammar(
        this.grammar,
        intervalDays,
        easeFactor,
        lastReviewed,
        nextReviewDate,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WordReviewItem value) word,
    required TResult Function(GrammarReviewItem value) grammar,
  }) {
    return grammar(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WordReviewItem value)? word,
    TResult? Function(GrammarReviewItem value)? grammar,
  }) {
    return grammar?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WordReviewItem value)? word,
    TResult Function(GrammarReviewItem value)? grammar,
    required TResult orElse(),
  }) {
    if (grammar != null) {
      return grammar(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$GrammarReviewItemImplToJson(this);
  }
}

abstract class GrammarReviewItem implements ReviewItem {
  const factory GrammarReviewItem({
    required final Grammar grammar,
    final int intervalDays,
    final double easeFactor,
    final DateTime? lastReviewed,
    final DateTime? nextReviewDate,
  }) = _$GrammarReviewItemImpl;

  factory GrammarReviewItem.fromJson(Map<String, dynamic> json) =
      _$GrammarReviewItemImpl.fromJson;

  Grammar get grammar;
  @override
  int get intervalDays;
  @override
  double get easeFactor;
  @override
  DateTime? get lastReviewed;
  @override
  DateTime? get nextReviewDate;

  /// Create a copy of ReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GrammarReviewItemImplCopyWith<_$GrammarReviewItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewSession _$ReviewSessionFromJson(Map<String, dynamic> json) {
  return _ReviewSession.fromJson(json);
}

/// @nodoc
mixin _$ReviewSession {
  List<ReviewItem> get items => throw _privateConstructorUsedError;
  int get currentIndex => throw _privateConstructorUsedError;
  bool get showAnswer => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  List<ReviewRating> get ratings => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;

  /// Serializes this ReviewSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewSessionCopyWith<ReviewSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewSessionCopyWith<$Res> {
  factory $ReviewSessionCopyWith(
    ReviewSession value,
    $Res Function(ReviewSession) then,
  ) = _$ReviewSessionCopyWithImpl<$Res, ReviewSession>;
  @useResult
  $Res call({
    List<ReviewItem> items,
    int currentIndex,
    bool showAnswer,
    bool isCompleted,
    List<ReviewRating> ratings,
    DateTime? startTime,
  });
}

/// @nodoc
class _$ReviewSessionCopyWithImpl<$Res, $Val extends ReviewSession>
    implements $ReviewSessionCopyWith<$Res> {
  _$ReviewSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? currentIndex = null,
    Object? showAnswer = null,
    Object? isCompleted = null,
    Object? ratings = null,
    Object? startTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<ReviewItem>,
            currentIndex: null == currentIndex
                ? _value.currentIndex
                : currentIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            showAnswer: null == showAnswer
                ? _value.showAnswer
                : showAnswer // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            ratings: null == ratings
                ? _value.ratings
                : ratings // ignore: cast_nullable_to_non_nullable
                      as List<ReviewRating>,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReviewSessionImplCopyWith<$Res>
    implements $ReviewSessionCopyWith<$Res> {
  factory _$$ReviewSessionImplCopyWith(
    _$ReviewSessionImpl value,
    $Res Function(_$ReviewSessionImpl) then,
  ) = __$$ReviewSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<ReviewItem> items,
    int currentIndex,
    bool showAnswer,
    bool isCompleted,
    List<ReviewRating> ratings,
    DateTime? startTime,
  });
}

/// @nodoc
class __$$ReviewSessionImplCopyWithImpl<$Res>
    extends _$ReviewSessionCopyWithImpl<$Res, _$ReviewSessionImpl>
    implements _$$ReviewSessionImplCopyWith<$Res> {
  __$$ReviewSessionImplCopyWithImpl(
    _$ReviewSessionImpl _value,
    $Res Function(_$ReviewSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? currentIndex = null,
    Object? showAnswer = null,
    Object? isCompleted = null,
    Object? ratings = null,
    Object? startTime = freezed,
  }) {
    return _then(
      _$ReviewSessionImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<ReviewItem>,
        currentIndex: null == currentIndex
            ? _value.currentIndex
            : currentIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        showAnswer: null == showAnswer
            ? _value.showAnswer
            : showAnswer // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        ratings: null == ratings
            ? _value._ratings
            : ratings // ignore: cast_nullable_to_non_nullable
                  as List<ReviewRating>,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewSessionImpl implements _ReviewSession {
  const _$ReviewSessionImpl({
    required final List<ReviewItem> items,
    this.currentIndex = 0,
    this.showAnswer = false,
    this.isCompleted = false,
    final List<ReviewRating> ratings = const [],
    this.startTime,
  }) : _items = items,
       _ratings = ratings;

  factory _$ReviewSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewSessionImplFromJson(json);

  final List<ReviewItem> _items;
  @override
  List<ReviewItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final int currentIndex;
  @override
  @JsonKey()
  final bool showAnswer;
  @override
  @JsonKey()
  final bool isCompleted;
  final List<ReviewRating> _ratings;
  @override
  @JsonKey()
  List<ReviewRating> get ratings {
    if (_ratings is EqualUnmodifiableListView) return _ratings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ratings);
  }

  @override
  final DateTime? startTime;

  @override
  String toString() {
    return 'ReviewSession(items: $items, currentIndex: $currentIndex, showAnswer: $showAnswer, isCompleted: $isCompleted, ratings: $ratings, startTime: $startTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewSessionImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.showAnswer, showAnswer) ||
                other.showAnswer == showAnswer) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            const DeepCollectionEquality().equals(other._ratings, _ratings) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    currentIndex,
    showAnswer,
    isCompleted,
    const DeepCollectionEquality().hash(_ratings),
    startTime,
  );

  /// Create a copy of ReviewSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewSessionImplCopyWith<_$ReviewSessionImpl> get copyWith =>
      __$$ReviewSessionImplCopyWithImpl<_$ReviewSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewSessionImplToJson(this);
  }
}

abstract class _ReviewSession implements ReviewSession {
  const factory _ReviewSession({
    required final List<ReviewItem> items,
    final int currentIndex,
    final bool showAnswer,
    final bool isCompleted,
    final List<ReviewRating> ratings,
    final DateTime? startTime,
  }) = _$ReviewSessionImpl;

  factory _ReviewSession.fromJson(Map<String, dynamic> json) =
      _$ReviewSessionImpl.fromJson;

  @override
  List<ReviewItem> get items;
  @override
  int get currentIndex;
  @override
  bool get showAnswer;
  @override
  bool get isCompleted;
  @override
  List<ReviewRating> get ratings;
  @override
  DateTime? get startTime;

  /// Create a copy of ReviewSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewSessionImplCopyWith<_$ReviewSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
