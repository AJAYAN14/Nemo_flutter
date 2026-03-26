// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Word _$WordFromJson(Map<String, dynamic> json) {
  return _Word.fromJson(json);
}

/// @nodoc
mixin _$Word {
  String get id => throw _privateConstructorUsedError;
  String get japanese => throw _privateConstructorUsedError;
  String get hiragana => throw _privateConstructorUsedError;
  String get chinese => throw _privateConstructorUsedError;
  String get level => throw _privateConstructorUsedError;
  String? get pos => throw _privateConstructorUsedError;
  List<WordExample> get examples => throw _privateConstructorUsedError;
  List<FuriganaBlock> get furiganaData => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;

  /// Serializes this Word to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Word
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WordCopyWith<Word> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordCopyWith<$Res> {
  factory $WordCopyWith(Word value, $Res Function(Word) then) =
      _$WordCopyWithImpl<$Res, Word>;
  @useResult
  $Res call({
    String id,
    String japanese,
    String hiragana,
    String chinese,
    String level,
    String? pos,
    List<WordExample> examples,
    List<FuriganaBlock> furiganaData,
    bool isFavorite,
  });
}

/// @nodoc
class _$WordCopyWithImpl<$Res, $Val extends Word>
    implements $WordCopyWith<$Res> {
  _$WordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Word
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? japanese = null,
    Object? hiragana = null,
    Object? chinese = null,
    Object? level = null,
    Object? pos = freezed,
    Object? examples = null,
    Object? furiganaData = null,
    Object? isFavorite = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            japanese: null == japanese
                ? _value.japanese
                : japanese // ignore: cast_nullable_to_non_nullable
                      as String,
            hiragana: null == hiragana
                ? _value.hiragana
                : hiragana // ignore: cast_nullable_to_non_nullable
                      as String,
            chinese: null == chinese
                ? _value.chinese
                : chinese // ignore: cast_nullable_to_non_nullable
                      as String,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as String,
            pos: freezed == pos
                ? _value.pos
                : pos // ignore: cast_nullable_to_non_nullable
                      as String?,
            examples: null == examples
                ? _value.examples
                : examples // ignore: cast_nullable_to_non_nullable
                      as List<WordExample>,
            furiganaData: null == furiganaData
                ? _value.furiganaData
                : furiganaData // ignore: cast_nullable_to_non_nullable
                      as List<FuriganaBlock>,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WordImplCopyWith<$Res> implements $WordCopyWith<$Res> {
  factory _$$WordImplCopyWith(
    _$WordImpl value,
    $Res Function(_$WordImpl) then,
  ) = __$$WordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String japanese,
    String hiragana,
    String chinese,
    String level,
    String? pos,
    List<WordExample> examples,
    List<FuriganaBlock> furiganaData,
    bool isFavorite,
  });
}

/// @nodoc
class __$$WordImplCopyWithImpl<$Res>
    extends _$WordCopyWithImpl<$Res, _$WordImpl>
    implements _$$WordImplCopyWith<$Res> {
  __$$WordImplCopyWithImpl(_$WordImpl _value, $Res Function(_$WordImpl) _then)
    : super(_value, _then);

  /// Create a copy of Word
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? japanese = null,
    Object? hiragana = null,
    Object? chinese = null,
    Object? level = null,
    Object? pos = freezed,
    Object? examples = null,
    Object? furiganaData = null,
    Object? isFavorite = null,
  }) {
    return _then(
      _$WordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        japanese: null == japanese
            ? _value.japanese
            : japanese // ignore: cast_nullable_to_non_nullable
                  as String,
        hiragana: null == hiragana
            ? _value.hiragana
            : hiragana // ignore: cast_nullable_to_non_nullable
                  as String,
        chinese: null == chinese
            ? _value.chinese
            : chinese // ignore: cast_nullable_to_non_nullable
                  as String,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as String,
        pos: freezed == pos
            ? _value.pos
            : pos // ignore: cast_nullable_to_non_nullable
                  as String?,
        examples: null == examples
            ? _value._examples
            : examples // ignore: cast_nullable_to_non_nullable
                  as List<WordExample>,
        furiganaData: null == furiganaData
            ? _value._furiganaData
            : furiganaData // ignore: cast_nullable_to_non_nullable
                  as List<FuriganaBlock>,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WordImpl implements _Word {
  const _$WordImpl({
    required this.id,
    required this.japanese,
    required this.hiragana,
    required this.chinese,
    required this.level,
    this.pos,
    final List<WordExample> examples = const [],
    final List<FuriganaBlock> furiganaData = const [],
    this.isFavorite = false,
  }) : _examples = examples,
       _furiganaData = furiganaData;

  factory _$WordImpl.fromJson(Map<String, dynamic> json) =>
      _$$WordImplFromJson(json);

  @override
  final String id;
  @override
  final String japanese;
  @override
  final String hiragana;
  @override
  final String chinese;
  @override
  final String level;
  @override
  final String? pos;
  final List<WordExample> _examples;
  @override
  @JsonKey()
  List<WordExample> get examples {
    if (_examples is EqualUnmodifiableListView) return _examples;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_examples);
  }

  final List<FuriganaBlock> _furiganaData;
  @override
  @JsonKey()
  List<FuriganaBlock> get furiganaData {
    if (_furiganaData is EqualUnmodifiableListView) return _furiganaData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_furiganaData);
  }

  @override
  @JsonKey()
  final bool isFavorite;

  @override
  String toString() {
    return 'Word(id: $id, japanese: $japanese, hiragana: $hiragana, chinese: $chinese, level: $level, pos: $pos, examples: $examples, furiganaData: $furiganaData, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.japanese, japanese) ||
                other.japanese == japanese) &&
            (identical(other.hiragana, hiragana) ||
                other.hiragana == hiragana) &&
            (identical(other.chinese, chinese) || other.chinese == chinese) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.pos, pos) || other.pos == pos) &&
            const DeepCollectionEquality().equals(other._examples, _examples) &&
            const DeepCollectionEquality().equals(
              other._furiganaData,
              _furiganaData,
            ) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    japanese,
    hiragana,
    chinese,
    level,
    pos,
    const DeepCollectionEquality().hash(_examples),
    const DeepCollectionEquality().hash(_furiganaData),
    isFavorite,
  );

  /// Create a copy of Word
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WordImplCopyWith<_$WordImpl> get copyWith =>
      __$$WordImplCopyWithImpl<_$WordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WordImplToJson(this);
  }
}

abstract class _Word implements Word {
  const factory _Word({
    required final String id,
    required final String japanese,
    required final String hiragana,
    required final String chinese,
    required final String level,
    final String? pos,
    final List<WordExample> examples,
    final List<FuriganaBlock> furiganaData,
    final bool isFavorite,
  }) = _$WordImpl;

  factory _Word.fromJson(Map<String, dynamic> json) = _$WordImpl.fromJson;

  @override
  String get id;
  @override
  String get japanese;
  @override
  String get hiragana;
  @override
  String get chinese;
  @override
  String get level;
  @override
  String? get pos;
  @override
  List<WordExample> get examples;
  @override
  List<FuriganaBlock> get furiganaData;
  @override
  bool get isFavorite;

  /// Create a copy of Word
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WordImplCopyWith<_$WordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WordExample _$WordExampleFromJson(Map<String, dynamic> json) {
  return _WordExample.fromJson(json);
}

/// @nodoc
mixin _$WordExample {
  String get japanese => throw _privateConstructorUsedError;
  String get chinese => throw _privateConstructorUsedError;
  String? get audioId => throw _privateConstructorUsedError;

  /// Serializes this WordExample to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WordExample
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WordExampleCopyWith<WordExample> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordExampleCopyWith<$Res> {
  factory $WordExampleCopyWith(
    WordExample value,
    $Res Function(WordExample) then,
  ) = _$WordExampleCopyWithImpl<$Res, WordExample>;
  @useResult
  $Res call({String japanese, String chinese, String? audioId});
}

/// @nodoc
class _$WordExampleCopyWithImpl<$Res, $Val extends WordExample>
    implements $WordExampleCopyWith<$Res> {
  _$WordExampleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WordExample
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? japanese = null,
    Object? chinese = null,
    Object? audioId = freezed,
  }) {
    return _then(
      _value.copyWith(
            japanese: null == japanese
                ? _value.japanese
                : japanese // ignore: cast_nullable_to_non_nullable
                      as String,
            chinese: null == chinese
                ? _value.chinese
                : chinese // ignore: cast_nullable_to_non_nullable
                      as String,
            audioId: freezed == audioId
                ? _value.audioId
                : audioId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WordExampleImplCopyWith<$Res>
    implements $WordExampleCopyWith<$Res> {
  factory _$$WordExampleImplCopyWith(
    _$WordExampleImpl value,
    $Res Function(_$WordExampleImpl) then,
  ) = __$$WordExampleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String japanese, String chinese, String? audioId});
}

/// @nodoc
class __$$WordExampleImplCopyWithImpl<$Res>
    extends _$WordExampleCopyWithImpl<$Res, _$WordExampleImpl>
    implements _$$WordExampleImplCopyWith<$Res> {
  __$$WordExampleImplCopyWithImpl(
    _$WordExampleImpl _value,
    $Res Function(_$WordExampleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WordExample
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? japanese = null,
    Object? chinese = null,
    Object? audioId = freezed,
  }) {
    return _then(
      _$WordExampleImpl(
        japanese: null == japanese
            ? _value.japanese
            : japanese // ignore: cast_nullable_to_non_nullable
                  as String,
        chinese: null == chinese
            ? _value.chinese
            : chinese // ignore: cast_nullable_to_non_nullable
                  as String,
        audioId: freezed == audioId
            ? _value.audioId
            : audioId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WordExampleImpl implements _WordExample {
  const _$WordExampleImpl({
    required this.japanese,
    required this.chinese,
    this.audioId,
  });

  factory _$WordExampleImpl.fromJson(Map<String, dynamic> json) =>
      _$$WordExampleImplFromJson(json);

  @override
  final String japanese;
  @override
  final String chinese;
  @override
  final String? audioId;

  @override
  String toString() {
    return 'WordExample(japanese: $japanese, chinese: $chinese, audioId: $audioId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordExampleImpl &&
            (identical(other.japanese, japanese) ||
                other.japanese == japanese) &&
            (identical(other.chinese, chinese) || other.chinese == chinese) &&
            (identical(other.audioId, audioId) || other.audioId == audioId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, japanese, chinese, audioId);

  /// Create a copy of WordExample
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WordExampleImplCopyWith<_$WordExampleImpl> get copyWith =>
      __$$WordExampleImplCopyWithImpl<_$WordExampleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WordExampleImplToJson(this);
  }
}

abstract class _WordExample implements WordExample {
  const factory _WordExample({
    required final String japanese,
    required final String chinese,
    final String? audioId,
  }) = _$WordExampleImpl;

  factory _WordExample.fromJson(Map<String, dynamic> json) =
      _$WordExampleImpl.fromJson;

  @override
  String get japanese;
  @override
  String get chinese;
  @override
  String? get audioId;

  /// Create a copy of WordExample
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WordExampleImplCopyWith<_$WordExampleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FuriganaBlock _$FuriganaBlockFromJson(Map<String, dynamic> json) {
  return _FuriganaBlock.fromJson(json);
}

/// @nodoc
mixin _$FuriganaBlock {
  String get text => throw _privateConstructorUsedError;
  String? get furigana => throw _privateConstructorUsedError;

  /// Serializes this FuriganaBlock to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FuriganaBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FuriganaBlockCopyWith<FuriganaBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FuriganaBlockCopyWith<$Res> {
  factory $FuriganaBlockCopyWith(
    FuriganaBlock value,
    $Res Function(FuriganaBlock) then,
  ) = _$FuriganaBlockCopyWithImpl<$Res, FuriganaBlock>;
  @useResult
  $Res call({String text, String? furigana});
}

/// @nodoc
class _$FuriganaBlockCopyWithImpl<$Res, $Val extends FuriganaBlock>
    implements $FuriganaBlockCopyWith<$Res> {
  _$FuriganaBlockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FuriganaBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? furigana = freezed}) {
    return _then(
      _value.copyWith(
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            furigana: freezed == furigana
                ? _value.furigana
                : furigana // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FuriganaBlockImplCopyWith<$Res>
    implements $FuriganaBlockCopyWith<$Res> {
  factory _$$FuriganaBlockImplCopyWith(
    _$FuriganaBlockImpl value,
    $Res Function(_$FuriganaBlockImpl) then,
  ) = __$$FuriganaBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, String? furigana});
}

/// @nodoc
class __$$FuriganaBlockImplCopyWithImpl<$Res>
    extends _$FuriganaBlockCopyWithImpl<$Res, _$FuriganaBlockImpl>
    implements _$$FuriganaBlockImplCopyWith<$Res> {
  __$$FuriganaBlockImplCopyWithImpl(
    _$FuriganaBlockImpl _value,
    $Res Function(_$FuriganaBlockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FuriganaBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? furigana = freezed}) {
    return _then(
      _$FuriganaBlockImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        furigana: freezed == furigana
            ? _value.furigana
            : furigana // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FuriganaBlockImpl implements _FuriganaBlock {
  const _$FuriganaBlockImpl({required this.text, this.furigana});

  factory _$FuriganaBlockImpl.fromJson(Map<String, dynamic> json) =>
      _$$FuriganaBlockImplFromJson(json);

  @override
  final String text;
  @override
  final String? furigana;

  @override
  String toString() {
    return 'FuriganaBlock(text: $text, furigana: $furigana)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FuriganaBlockImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.furigana, furigana) ||
                other.furigana == furigana));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, furigana);

  /// Create a copy of FuriganaBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FuriganaBlockImplCopyWith<_$FuriganaBlockImpl> get copyWith =>
      __$$FuriganaBlockImplCopyWithImpl<_$FuriganaBlockImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FuriganaBlockImplToJson(this);
  }
}

abstract class _FuriganaBlock implements FuriganaBlock {
  const factory _FuriganaBlock({
    required final String text,
    final String? furigana,
  }) = _$FuriganaBlockImpl;

  factory _FuriganaBlock.fromJson(Map<String, dynamic> json) =
      _$FuriganaBlockImpl.fromJson;

  @override
  String get text;
  @override
  String? get furigana;

  /// Create a copy of FuriganaBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FuriganaBlockImplCopyWith<_$FuriganaBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
