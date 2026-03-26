// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_explanation_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ExplanationPayload {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String japanese, String hiragana, String meaning)
    wordSummary,
    required TResult Function(String text) text,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String japanese, String hiragana, String meaning)?
    wordSummary,
    TResult? Function(String text)? text,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String japanese, String hiragana, String meaning)?
    wordSummary,
    TResult Function(String text)? text,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WordSummary value) wordSummary,
    required TResult Function(_Text value) text,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WordSummary value)? wordSummary,
    TResult? Function(_Text value)? text,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WordSummary value)? wordSummary,
    TResult Function(_Text value)? text,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExplanationPayloadCopyWith<$Res> {
  factory $ExplanationPayloadCopyWith(
    ExplanationPayload value,
    $Res Function(ExplanationPayload) then,
  ) = _$ExplanationPayloadCopyWithImpl<$Res, ExplanationPayload>;
}

/// @nodoc
class _$ExplanationPayloadCopyWithImpl<$Res, $Val extends ExplanationPayload>
    implements $ExplanationPayloadCopyWith<$Res> {
  _$ExplanationPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExplanationPayload
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$WordSummaryImplCopyWith<$Res> {
  factory _$$WordSummaryImplCopyWith(
    _$WordSummaryImpl value,
    $Res Function(_$WordSummaryImpl) then,
  ) = __$$WordSummaryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String japanese, String hiragana, String meaning});
}

/// @nodoc
class __$$WordSummaryImplCopyWithImpl<$Res>
    extends _$ExplanationPayloadCopyWithImpl<$Res, _$WordSummaryImpl>
    implements _$$WordSummaryImplCopyWith<$Res> {
  __$$WordSummaryImplCopyWithImpl(
    _$WordSummaryImpl _value,
    $Res Function(_$WordSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExplanationPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? japanese = null,
    Object? hiragana = null,
    Object? meaning = null,
  }) {
    return _then(
      _$WordSummaryImpl(
        japanese: null == japanese
            ? _value.japanese
            : japanese // ignore: cast_nullable_to_non_nullable
                  as String,
        hiragana: null == hiragana
            ? _value.hiragana
            : hiragana // ignore: cast_nullable_to_non_nullable
                  as String,
        meaning: null == meaning
            ? _value.meaning
            : meaning // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$WordSummaryImpl implements _WordSummary {
  const _$WordSummaryImpl({
    required this.japanese,
    required this.hiragana,
    required this.meaning,
  });

  @override
  final String japanese;
  @override
  final String hiragana;
  @override
  final String meaning;

  @override
  String toString() {
    return 'ExplanationPayload.wordSummary(japanese: $japanese, hiragana: $hiragana, meaning: $meaning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordSummaryImpl &&
            (identical(other.japanese, japanese) ||
                other.japanese == japanese) &&
            (identical(other.hiragana, hiragana) ||
                other.hiragana == hiragana) &&
            (identical(other.meaning, meaning) || other.meaning == meaning));
  }

  @override
  int get hashCode => Object.hash(runtimeType, japanese, hiragana, meaning);

  /// Create a copy of ExplanationPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WordSummaryImplCopyWith<_$WordSummaryImpl> get copyWith =>
      __$$WordSummaryImplCopyWithImpl<_$WordSummaryImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String japanese, String hiragana, String meaning)
    wordSummary,
    required TResult Function(String text) text,
  }) {
    return wordSummary(japanese, hiragana, meaning);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String japanese, String hiragana, String meaning)?
    wordSummary,
    TResult? Function(String text)? text,
  }) {
    return wordSummary?.call(japanese, hiragana, meaning);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String japanese, String hiragana, String meaning)?
    wordSummary,
    TResult Function(String text)? text,
    required TResult orElse(),
  }) {
    if (wordSummary != null) {
      return wordSummary(japanese, hiragana, meaning);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WordSummary value) wordSummary,
    required TResult Function(_Text value) text,
  }) {
    return wordSummary(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WordSummary value)? wordSummary,
    TResult? Function(_Text value)? text,
  }) {
    return wordSummary?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WordSummary value)? wordSummary,
    TResult Function(_Text value)? text,
    required TResult orElse(),
  }) {
    if (wordSummary != null) {
      return wordSummary(this);
    }
    return orElse();
  }
}

abstract class _WordSummary implements ExplanationPayload {
  const factory _WordSummary({
    required final String japanese,
    required final String hiragana,
    required final String meaning,
  }) = _$WordSummaryImpl;

  String get japanese;
  String get hiragana;
  String get meaning;

  /// Create a copy of ExplanationPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WordSummaryImplCopyWith<_$WordSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TextImplCopyWith<$Res> {
  factory _$$TextImplCopyWith(
    _$TextImpl value,
    $Res Function(_$TextImpl) then,
  ) = __$$TextImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String text});
}

/// @nodoc
class __$$TextImplCopyWithImpl<$Res>
    extends _$ExplanationPayloadCopyWithImpl<$Res, _$TextImpl>
    implements _$$TextImplCopyWith<$Res> {
  __$$TextImplCopyWithImpl(_$TextImpl _value, $Res Function(_$TextImpl) _then)
    : super(_value, _then);

  /// Create a copy of ExplanationPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null}) {
    return _then(
      _$TextImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$TextImpl implements _Text {
  const _$TextImpl({required this.text});

  @override
  final String text;

  @override
  String toString() {
    return 'ExplanationPayload.text(text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TextImpl &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text);

  /// Create a copy of ExplanationPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TextImplCopyWith<_$TextImpl> get copyWith =>
      __$$TextImplCopyWithImpl<_$TextImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String japanese, String hiragana, String meaning)
    wordSummary,
    required TResult Function(String text) text,
  }) {
    return text(this.text);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String japanese, String hiragana, String meaning)?
    wordSummary,
    TResult? Function(String text)? text,
  }) {
    return text?.call(this.text);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String japanese, String hiragana, String meaning)?
    wordSummary,
    TResult Function(String text)? text,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(this.text);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WordSummary value) wordSummary,
    required TResult Function(_Text value) text,
  }) {
    return text(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WordSummary value)? wordSummary,
    TResult? Function(_Text value)? text,
  }) {
    return text?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WordSummary value)? wordSummary,
    TResult Function(_Text value)? text,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(this);
    }
    return orElse();
  }
}

abstract class _Text implements ExplanationPayload {
  const factory _Text({required final String text}) = _$TextImpl;

  String get text;

  /// Create a copy of ExplanationPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TextImplCopyWith<_$TextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
