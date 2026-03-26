// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CardMatchPair _$CardMatchPairFromJson(Map<String, dynamic> json) {
  return _CardMatchPair.fromJson(json);
}

/// @nodoc
mixin _$CardMatchPair {
  String get id => throw _privateConstructorUsedError;
  String get term => throw _privateConstructorUsedError;
  String get definition => throw _privateConstructorUsedError;

  /// Serializes this CardMatchPair to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CardMatchPair
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CardMatchPairCopyWith<CardMatchPair> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardMatchPairCopyWith<$Res> {
  factory $CardMatchPairCopyWith(
    CardMatchPair value,
    $Res Function(CardMatchPair) then,
  ) = _$CardMatchPairCopyWithImpl<$Res, CardMatchPair>;
  @useResult
  $Res call({String id, String term, String definition});
}

/// @nodoc
class _$CardMatchPairCopyWithImpl<$Res, $Val extends CardMatchPair>
    implements $CardMatchPairCopyWith<$Res> {
  _$CardMatchPairCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CardMatchPair
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? term = null,
    Object? definition = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            term: null == term
                ? _value.term
                : term // ignore: cast_nullable_to_non_nullable
                      as String,
            definition: null == definition
                ? _value.definition
                : definition // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CardMatchPairImplCopyWith<$Res>
    implements $CardMatchPairCopyWith<$Res> {
  factory _$$CardMatchPairImplCopyWith(
    _$CardMatchPairImpl value,
    $Res Function(_$CardMatchPairImpl) then,
  ) = __$$CardMatchPairImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String term, String definition});
}

/// @nodoc
class __$$CardMatchPairImplCopyWithImpl<$Res>
    extends _$CardMatchPairCopyWithImpl<$Res, _$CardMatchPairImpl>
    implements _$$CardMatchPairImplCopyWith<$Res> {
  __$$CardMatchPairImplCopyWithImpl(
    _$CardMatchPairImpl _value,
    $Res Function(_$CardMatchPairImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CardMatchPair
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? term = null,
    Object? definition = null,
  }) {
    return _then(
      _$CardMatchPairImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        term: null == term
            ? _value.term
            : term // ignore: cast_nullable_to_non_nullable
                  as String,
        definition: null == definition
            ? _value.definition
            : definition // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CardMatchPairImpl implements _CardMatchPair {
  const _$CardMatchPairImpl({
    required this.id,
    required this.term,
    required this.definition,
  });

  factory _$CardMatchPairImpl.fromJson(Map<String, dynamic> json) =>
      _$$CardMatchPairImplFromJson(json);

  @override
  final String id;
  @override
  final String term;
  @override
  final String definition;

  @override
  String toString() {
    return 'CardMatchPair(id: $id, term: $term, definition: $definition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardMatchPairImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.term, term) || other.term == term) &&
            (identical(other.definition, definition) ||
                other.definition == definition));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, term, definition);

  /// Create a copy of CardMatchPair
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CardMatchPairImplCopyWith<_$CardMatchPairImpl> get copyWith =>
      __$$CardMatchPairImplCopyWithImpl<_$CardMatchPairImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CardMatchPairImplToJson(this);
  }
}

abstract class _CardMatchPair implements CardMatchPair {
  const factory _CardMatchPair({
    required final String id,
    required final String term,
    required final String definition,
  }) = _$CardMatchPairImpl;

  factory _CardMatchPair.fromJson(Map<String, dynamic> json) =
      _$CardMatchPairImpl.fromJson;

  @override
  String get id;
  @override
  String get term;
  @override
  String get definition;

  /// Create a copy of CardMatchPair
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CardMatchPairImplCopyWith<_$CardMatchPairImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SortableChar _$SortableCharFromJson(Map<String, dynamic> json) {
  return _SortableChar.fromJson(json);
}

/// @nodoc
mixin _$SortableChar {
  String get char => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;

  /// Serializes this SortableChar to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SortableChar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SortableCharCopyWith<SortableChar> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SortableCharCopyWith<$Res> {
  factory $SortableCharCopyWith(
    SortableChar value,
    $Res Function(SortableChar) then,
  ) = _$SortableCharCopyWithImpl<$Res, SortableChar>;
  @useResult
  $Res call({String char, String id, bool isSelected});
}

/// @nodoc
class _$SortableCharCopyWithImpl<$Res, $Val extends SortableChar>
    implements $SortableCharCopyWith<$Res> {
  _$SortableCharCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SortableChar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? char = null,
    Object? id = null,
    Object? isSelected = null,
  }) {
    return _then(
      _value.copyWith(
            char: null == char
                ? _value.char
                : char // ignore: cast_nullable_to_non_nullable
                      as String,
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            isSelected: null == isSelected
                ? _value.isSelected
                : isSelected // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SortableCharImplCopyWith<$Res>
    implements $SortableCharCopyWith<$Res> {
  factory _$$SortableCharImplCopyWith(
    _$SortableCharImpl value,
    $Res Function(_$SortableCharImpl) then,
  ) = __$$SortableCharImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String char, String id, bool isSelected});
}

/// @nodoc
class __$$SortableCharImplCopyWithImpl<$Res>
    extends _$SortableCharCopyWithImpl<$Res, _$SortableCharImpl>
    implements _$$SortableCharImplCopyWith<$Res> {
  __$$SortableCharImplCopyWithImpl(
    _$SortableCharImpl _value,
    $Res Function(_$SortableCharImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SortableChar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? char = null,
    Object? id = null,
    Object? isSelected = null,
  }) {
    return _then(
      _$SortableCharImpl(
        char: null == char
            ? _value.char
            : char // ignore: cast_nullable_to_non_nullable
                  as String,
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        isSelected: null == isSelected
            ? _value.isSelected
            : isSelected // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SortableCharImpl implements _SortableChar {
  const _$SortableCharImpl({
    required this.char,
    required this.id,
    this.isSelected = false,
  });

  factory _$SortableCharImpl.fromJson(Map<String, dynamic> json) =>
      _$$SortableCharImplFromJson(json);

  @override
  final String char;
  @override
  final String id;
  @override
  @JsonKey()
  final bool isSelected;

  @override
  String toString() {
    return 'SortableChar(char: $char, id: $id, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SortableCharImpl &&
            (identical(other.char, char) || other.char == char) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, char, id, isSelected);

  /// Create a copy of SortableChar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SortableCharImplCopyWith<_$SortableCharImpl> get copyWith =>
      __$$SortableCharImplCopyWithImpl<_$SortableCharImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SortableCharImplToJson(this);
  }
}

abstract class _SortableChar implements SortableChar {
  const factory _SortableChar({
    required final String char,
    required final String id,
    final bool isSelected,
  }) = _$SortableCharImpl;

  factory _SortableChar.fromJson(Map<String, dynamic> json) =
      _$SortableCharImpl.fromJson;

  @override
  String get char;
  @override
  String get id;
  @override
  bool get isSelected;

  /// Create a copy of SortableChar
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SortableCharImplCopyWith<_$SortableCharImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TestQuestion _$TestQuestionFromJson(Map<String, dynamic> json) {
  return _TestQuestion.fromJson(json);
}

/// @nodoc
mixin _$TestQuestion {
  String get id => throw _privateConstructorUsedError;
  QuestionType get type => throw _privateConstructorUsedError;
  String get questionText => throw _privateConstructorUsedError;
  String get correctAnswer => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;
  List<SortableChar> get sortingOptions =>
      throw _privateConstructorUsedError; // For sorting mode
  String? get explanation => throw _privateConstructorUsedError;
  bool get isAnswered => throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;
  int? get userAnswerIndex =>
      throw _privateConstructorUsedError; // For multiple choice
  String? get userAnswer =>
      throw _privateConstructorUsedError; // For typing/sorting
  // Metadata for Furigana support & Typing feedback
  String? get wordId => throw _privateConstructorUsedError;
  String? get grammarId => throw _privateConstructorUsedError;
  int? get typingQuestionType =>
      throw _privateConstructorUsedError; // 1-6 for typing hints
  String? get japanese =>
      throw _privateConstructorUsedError; // Kanji (for feedback card)
  String? get hiragana =>
      throw _privateConstructorUsedError; // Kana (for feedback card)
  String? get chinese =>
      throw _privateConstructorUsedError; // Meaning (for feedback card)
  List<CardMatchPair>? get matchPairs => throw _privateConstructorUsedError;

  /// Serializes this TestQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TestQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TestQuestionCopyWith<TestQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestQuestionCopyWith<$Res> {
  factory $TestQuestionCopyWith(
    TestQuestion value,
    $Res Function(TestQuestion) then,
  ) = _$TestQuestionCopyWithImpl<$Res, TestQuestion>;
  @useResult
  $Res call({
    String id,
    QuestionType type,
    String questionText,
    String correctAnswer,
    List<String> options,
    List<SortableChar> sortingOptions,
    String? explanation,
    bool isAnswered,
    bool isCorrect,
    int? userAnswerIndex,
    String? userAnswer,
    String? wordId,
    String? grammarId,
    int? typingQuestionType,
    String? japanese,
    String? hiragana,
    String? chinese,
    List<CardMatchPair>? matchPairs,
  });
}

/// @nodoc
class _$TestQuestionCopyWithImpl<$Res, $Val extends TestQuestion>
    implements $TestQuestionCopyWith<$Res> {
  _$TestQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TestQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? questionText = null,
    Object? correctAnswer = null,
    Object? options = null,
    Object? sortingOptions = null,
    Object? explanation = freezed,
    Object? isAnswered = null,
    Object? isCorrect = null,
    Object? userAnswerIndex = freezed,
    Object? userAnswer = freezed,
    Object? wordId = freezed,
    Object? grammarId = freezed,
    Object? typingQuestionType = freezed,
    Object? japanese = freezed,
    Object? hiragana = freezed,
    Object? chinese = freezed,
    Object? matchPairs = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as QuestionType,
            questionText: null == questionText
                ? _value.questionText
                : questionText // ignore: cast_nullable_to_non_nullable
                      as String,
            correctAnswer: null == correctAnswer
                ? _value.correctAnswer
                : correctAnswer // ignore: cast_nullable_to_non_nullable
                      as String,
            options: null == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            sortingOptions: null == sortingOptions
                ? _value.sortingOptions
                : sortingOptions // ignore: cast_nullable_to_non_nullable
                      as List<SortableChar>,
            explanation: freezed == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String?,
            isAnswered: null == isAnswered
                ? _value.isAnswered
                : isAnswered // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCorrect: null == isCorrect
                ? _value.isCorrect
                : isCorrect // ignore: cast_nullable_to_non_nullable
                      as bool,
            userAnswerIndex: freezed == userAnswerIndex
                ? _value.userAnswerIndex
                : userAnswerIndex // ignore: cast_nullable_to_non_nullable
                      as int?,
            userAnswer: freezed == userAnswer
                ? _value.userAnswer
                : userAnswer // ignore: cast_nullable_to_non_nullable
                      as String?,
            wordId: freezed == wordId
                ? _value.wordId
                : wordId // ignore: cast_nullable_to_non_nullable
                      as String?,
            grammarId: freezed == grammarId
                ? _value.grammarId
                : grammarId // ignore: cast_nullable_to_non_nullable
                      as String?,
            typingQuestionType: freezed == typingQuestionType
                ? _value.typingQuestionType
                : typingQuestionType // ignore: cast_nullable_to_non_nullable
                      as int?,
            japanese: freezed == japanese
                ? _value.japanese
                : japanese // ignore: cast_nullable_to_non_nullable
                      as String?,
            hiragana: freezed == hiragana
                ? _value.hiragana
                : hiragana // ignore: cast_nullable_to_non_nullable
                      as String?,
            chinese: freezed == chinese
                ? _value.chinese
                : chinese // ignore: cast_nullable_to_non_nullable
                      as String?,
            matchPairs: freezed == matchPairs
                ? _value.matchPairs
                : matchPairs // ignore: cast_nullable_to_non_nullable
                      as List<CardMatchPair>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TestQuestionImplCopyWith<$Res>
    implements $TestQuestionCopyWith<$Res> {
  factory _$$TestQuestionImplCopyWith(
    _$TestQuestionImpl value,
    $Res Function(_$TestQuestionImpl) then,
  ) = __$$TestQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    QuestionType type,
    String questionText,
    String correctAnswer,
    List<String> options,
    List<SortableChar> sortingOptions,
    String? explanation,
    bool isAnswered,
    bool isCorrect,
    int? userAnswerIndex,
    String? userAnswer,
    String? wordId,
    String? grammarId,
    int? typingQuestionType,
    String? japanese,
    String? hiragana,
    String? chinese,
    List<CardMatchPair>? matchPairs,
  });
}

/// @nodoc
class __$$TestQuestionImplCopyWithImpl<$Res>
    extends _$TestQuestionCopyWithImpl<$Res, _$TestQuestionImpl>
    implements _$$TestQuestionImplCopyWith<$Res> {
  __$$TestQuestionImplCopyWithImpl(
    _$TestQuestionImpl _value,
    $Res Function(_$TestQuestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TestQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? questionText = null,
    Object? correctAnswer = null,
    Object? options = null,
    Object? sortingOptions = null,
    Object? explanation = freezed,
    Object? isAnswered = null,
    Object? isCorrect = null,
    Object? userAnswerIndex = freezed,
    Object? userAnswer = freezed,
    Object? wordId = freezed,
    Object? grammarId = freezed,
    Object? typingQuestionType = freezed,
    Object? japanese = freezed,
    Object? hiragana = freezed,
    Object? chinese = freezed,
    Object? matchPairs = freezed,
  }) {
    return _then(
      _$TestQuestionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as QuestionType,
        questionText: null == questionText
            ? _value.questionText
            : questionText // ignore: cast_nullable_to_non_nullable
                  as String,
        correctAnswer: null == correctAnswer
            ? _value.correctAnswer
            : correctAnswer // ignore: cast_nullable_to_non_nullable
                  as String,
        options: null == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        sortingOptions: null == sortingOptions
            ? _value._sortingOptions
            : sortingOptions // ignore: cast_nullable_to_non_nullable
                  as List<SortableChar>,
        explanation: freezed == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String?,
        isAnswered: null == isAnswered
            ? _value.isAnswered
            : isAnswered // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCorrect: null == isCorrect
            ? _value.isCorrect
            : isCorrect // ignore: cast_nullable_to_non_nullable
                  as bool,
        userAnswerIndex: freezed == userAnswerIndex
            ? _value.userAnswerIndex
            : userAnswerIndex // ignore: cast_nullable_to_non_nullable
                  as int?,
        userAnswer: freezed == userAnswer
            ? _value.userAnswer
            : userAnswer // ignore: cast_nullable_to_non_nullable
                  as String?,
        wordId: freezed == wordId
            ? _value.wordId
            : wordId // ignore: cast_nullable_to_non_nullable
                  as String?,
        grammarId: freezed == grammarId
            ? _value.grammarId
            : grammarId // ignore: cast_nullable_to_non_nullable
                  as String?,
        typingQuestionType: freezed == typingQuestionType
            ? _value.typingQuestionType
            : typingQuestionType // ignore: cast_nullable_to_non_nullable
                  as int?,
        japanese: freezed == japanese
            ? _value.japanese
            : japanese // ignore: cast_nullable_to_non_nullable
                  as String?,
        hiragana: freezed == hiragana
            ? _value.hiragana
            : hiragana // ignore: cast_nullable_to_non_nullable
                  as String?,
        chinese: freezed == chinese
            ? _value.chinese
            : chinese // ignore: cast_nullable_to_non_nullable
                  as String?,
        matchPairs: freezed == matchPairs
            ? _value._matchPairs
            : matchPairs // ignore: cast_nullable_to_non_nullable
                  as List<CardMatchPair>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TestQuestionImpl implements _TestQuestion {
  const _$TestQuestionImpl({
    required this.id,
    required this.type,
    required this.questionText,
    required this.correctAnswer,
    final List<String> options = const [],
    final List<SortableChar> sortingOptions = const [],
    this.explanation,
    this.isAnswered = false,
    this.isCorrect = false,
    this.userAnswerIndex,
    this.userAnswer,
    this.wordId,
    this.grammarId,
    this.typingQuestionType,
    this.japanese,
    this.hiragana,
    this.chinese,
    final List<CardMatchPair>? matchPairs,
  }) : _options = options,
       _sortingOptions = sortingOptions,
       _matchPairs = matchPairs;

  factory _$TestQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TestQuestionImplFromJson(json);

  @override
  final String id;
  @override
  final QuestionType type;
  @override
  final String questionText;
  @override
  final String correctAnswer;
  final List<String> _options;
  @override
  @JsonKey()
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  final List<SortableChar> _sortingOptions;
  @override
  @JsonKey()
  List<SortableChar> get sortingOptions {
    if (_sortingOptions is EqualUnmodifiableListView) return _sortingOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sortingOptions);
  }

  // For sorting mode
  @override
  final String? explanation;
  @override
  @JsonKey()
  final bool isAnswered;
  @override
  @JsonKey()
  final bool isCorrect;
  @override
  final int? userAnswerIndex;
  // For multiple choice
  @override
  final String? userAnswer;
  // For typing/sorting
  // Metadata for Furigana support & Typing feedback
  @override
  final String? wordId;
  @override
  final String? grammarId;
  @override
  final int? typingQuestionType;
  // 1-6 for typing hints
  @override
  final String? japanese;
  // Kanji (for feedback card)
  @override
  final String? hiragana;
  // Kana (for feedback card)
  @override
  final String? chinese;
  // Meaning (for feedback card)
  final List<CardMatchPair>? _matchPairs;
  // Meaning (for feedback card)
  @override
  List<CardMatchPair>? get matchPairs {
    final value = _matchPairs;
    if (value == null) return null;
    if (_matchPairs is EqualUnmodifiableListView) return _matchPairs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TestQuestion(id: $id, type: $type, questionText: $questionText, correctAnswer: $correctAnswer, options: $options, sortingOptions: $sortingOptions, explanation: $explanation, isAnswered: $isAnswered, isCorrect: $isCorrect, userAnswerIndex: $userAnswerIndex, userAnswer: $userAnswer, wordId: $wordId, grammarId: $grammarId, typingQuestionType: $typingQuestionType, japanese: $japanese, hiragana: $hiragana, chinese: $chinese, matchPairs: $matchPairs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            const DeepCollectionEquality().equals(
              other._sortingOptions,
              _sortingOptions,
            ) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.isAnswered, isAnswered) ||
                other.isAnswered == isAnswered) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.userAnswerIndex, userAnswerIndex) ||
                other.userAnswerIndex == userAnswerIndex) &&
            (identical(other.userAnswer, userAnswer) ||
                other.userAnswer == userAnswer) &&
            (identical(other.wordId, wordId) || other.wordId == wordId) &&
            (identical(other.grammarId, grammarId) ||
                other.grammarId == grammarId) &&
            (identical(other.typingQuestionType, typingQuestionType) ||
                other.typingQuestionType == typingQuestionType) &&
            (identical(other.japanese, japanese) ||
                other.japanese == japanese) &&
            (identical(other.hiragana, hiragana) ||
                other.hiragana == hiragana) &&
            (identical(other.chinese, chinese) || other.chinese == chinese) &&
            const DeepCollectionEquality().equals(
              other._matchPairs,
              _matchPairs,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    questionText,
    correctAnswer,
    const DeepCollectionEquality().hash(_options),
    const DeepCollectionEquality().hash(_sortingOptions),
    explanation,
    isAnswered,
    isCorrect,
    userAnswerIndex,
    userAnswer,
    wordId,
    grammarId,
    typingQuestionType,
    japanese,
    hiragana,
    chinese,
    const DeepCollectionEquality().hash(_matchPairs),
  );

  /// Create a copy of TestQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TestQuestionImplCopyWith<_$TestQuestionImpl> get copyWith =>
      __$$TestQuestionImplCopyWithImpl<_$TestQuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TestQuestionImplToJson(this);
  }
}

abstract class _TestQuestion implements TestQuestion {
  const factory _TestQuestion({
    required final String id,
    required final QuestionType type,
    required final String questionText,
    required final String correctAnswer,
    final List<String> options,
    final List<SortableChar> sortingOptions,
    final String? explanation,
    final bool isAnswered,
    final bool isCorrect,
    final int? userAnswerIndex,
    final String? userAnswer,
    final String? wordId,
    final String? grammarId,
    final int? typingQuestionType,
    final String? japanese,
    final String? hiragana,
    final String? chinese,
    final List<CardMatchPair>? matchPairs,
  }) = _$TestQuestionImpl;

  factory _TestQuestion.fromJson(Map<String, dynamic> json) =
      _$TestQuestionImpl.fromJson;

  @override
  String get id;
  @override
  QuestionType get type;
  @override
  String get questionText;
  @override
  String get correctAnswer;
  @override
  List<String> get options;
  @override
  List<SortableChar> get sortingOptions; // For sorting mode
  @override
  String? get explanation;
  @override
  bool get isAnswered;
  @override
  bool get isCorrect;
  @override
  int? get userAnswerIndex; // For multiple choice
  @override
  String? get userAnswer; // For typing/sorting
  // Metadata for Furigana support & Typing feedback
  @override
  String? get wordId;
  @override
  String? get grammarId;
  @override
  int? get typingQuestionType; // 1-6 for typing hints
  @override
  String? get japanese; // Kanji (for feedback card)
  @override
  String? get hiragana; // Kana (for feedback card)
  @override
  String? get chinese; // Meaning (for feedback card)
  @override
  List<CardMatchPair>? get matchPairs;

  /// Create a copy of TestQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TestQuestionImplCopyWith<_$TestQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TestResult _$TestResultFromJson(Map<String, dynamic> json) {
  return _TestResult.fromJson(json);
}

/// @nodoc
mixin _$TestResult {
  List<TestQuestion> get questions => throw _privateConstructorUsedError;
  int get totalQuestions => throw _privateConstructorUsedError;
  int get correctCount => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  int get wordCount => throw _privateConstructorUsedError;
  int get grammarCount => throw _privateConstructorUsedError;

  /// Serializes this TestResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TestResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TestResultCopyWith<TestResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestResultCopyWith<$Res> {
  factory $TestResultCopyWith(
    TestResult value,
    $Res Function(TestResult) then,
  ) = _$TestResultCopyWithImpl<$Res, TestResult>;
  @useResult
  $Res call({
    List<TestQuestion> questions,
    int totalQuestions,
    int correctCount,
    int score,
    DateTime startTime,
    DateTime endTime,
    Duration duration,
    int wordCount,
    int grammarCount,
  });
}

/// @nodoc
class _$TestResultCopyWithImpl<$Res, $Val extends TestResult>
    implements $TestResultCopyWith<$Res> {
  _$TestResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TestResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questions = null,
    Object? totalQuestions = null,
    Object? correctCount = null,
    Object? score = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? duration = null,
    Object? wordCount = null,
    Object? grammarCount = null,
  }) {
    return _then(
      _value.copyWith(
            questions: null == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<TestQuestion>,
            totalQuestions: null == totalQuestions
                ? _value.totalQuestions
                : totalQuestions // ignore: cast_nullable_to_non_nullable
                      as int,
            correctCount: null == correctCount
                ? _value.correctCount
                : correctCount // ignore: cast_nullable_to_non_nullable
                      as int,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as Duration,
            wordCount: null == wordCount
                ? _value.wordCount
                : wordCount // ignore: cast_nullable_to_non_nullable
                      as int,
            grammarCount: null == grammarCount
                ? _value.grammarCount
                : grammarCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TestResultImplCopyWith<$Res>
    implements $TestResultCopyWith<$Res> {
  factory _$$TestResultImplCopyWith(
    _$TestResultImpl value,
    $Res Function(_$TestResultImpl) then,
  ) = __$$TestResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<TestQuestion> questions,
    int totalQuestions,
    int correctCount,
    int score,
    DateTime startTime,
    DateTime endTime,
    Duration duration,
    int wordCount,
    int grammarCount,
  });
}

/// @nodoc
class __$$TestResultImplCopyWithImpl<$Res>
    extends _$TestResultCopyWithImpl<$Res, _$TestResultImpl>
    implements _$$TestResultImplCopyWith<$Res> {
  __$$TestResultImplCopyWithImpl(
    _$TestResultImpl _value,
    $Res Function(_$TestResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TestResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questions = null,
    Object? totalQuestions = null,
    Object? correctCount = null,
    Object? score = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? duration = null,
    Object? wordCount = null,
    Object? grammarCount = null,
  }) {
    return _then(
      _$TestResultImpl(
        questions: null == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<TestQuestion>,
        totalQuestions: null == totalQuestions
            ? _value.totalQuestions
            : totalQuestions // ignore: cast_nullable_to_non_nullable
                  as int,
        correctCount: null == correctCount
            ? _value.correctCount
            : correctCount // ignore: cast_nullable_to_non_nullable
                  as int,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as Duration,
        wordCount: null == wordCount
            ? _value.wordCount
            : wordCount // ignore: cast_nullable_to_non_nullable
                  as int,
        grammarCount: null == grammarCount
            ? _value.grammarCount
            : grammarCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TestResultImpl implements _TestResult {
  const _$TestResultImpl({
    required final List<TestQuestion> questions,
    required this.totalQuestions,
    required this.correctCount,
    required this.score,
    required this.startTime,
    required this.endTime,
    required this.duration,
    this.wordCount = 0,
    this.grammarCount = 0,
  }) : _questions = questions;

  factory _$TestResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TestResultImplFromJson(json);

  final List<TestQuestion> _questions;
  @override
  List<TestQuestion> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  final int totalQuestions;
  @override
  final int correctCount;
  @override
  final int score;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final Duration duration;
  @override
  @JsonKey()
  final int wordCount;
  @override
  @JsonKey()
  final int grammarCount;

  @override
  String toString() {
    return 'TestResult(questions: $questions, totalQuestions: $totalQuestions, correctCount: $correctCount, score: $score, startTime: $startTime, endTime: $endTime, duration: $duration, wordCount: $wordCount, grammarCount: $grammarCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestResultImpl &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.correctCount, correctCount) ||
                other.correctCount == correctCount) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.wordCount, wordCount) ||
                other.wordCount == wordCount) &&
            (identical(other.grammarCount, grammarCount) ||
                other.grammarCount == grammarCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_questions),
    totalQuestions,
    correctCount,
    score,
    startTime,
    endTime,
    duration,
    wordCount,
    grammarCount,
  );

  /// Create a copy of TestResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TestResultImplCopyWith<_$TestResultImpl> get copyWith =>
      __$$TestResultImplCopyWithImpl<_$TestResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TestResultImplToJson(this);
  }
}

abstract class _TestResult implements TestResult {
  const factory _TestResult({
    required final List<TestQuestion> questions,
    required final int totalQuestions,
    required final int correctCount,
    required final int score,
    required final DateTime startTime,
    required final DateTime endTime,
    required final Duration duration,
    final int wordCount,
    final int grammarCount,
  }) = _$TestResultImpl;

  factory _TestResult.fromJson(Map<String, dynamic> json) =
      _$TestResultImpl.fromJson;

  @override
  List<TestQuestion> get questions;
  @override
  int get totalQuestions;
  @override
  int get correctCount;
  @override
  int get score;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  Duration get duration;
  @override
  int get wordCount;
  @override
  int get grammarCount;

  /// Create a copy of TestResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TestResultImplCopyWith<_$TestResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
