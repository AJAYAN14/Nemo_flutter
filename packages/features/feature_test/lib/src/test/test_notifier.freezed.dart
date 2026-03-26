// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TestState {
  List<TestQuestion> get questions => throw _privateConstructorUsedError;
  int get currentIndex => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isTestActive => throw _privateConstructorUsedError;
  bool get showResult => throw _privateConstructorUsedError;
  TestResult? get testResult => throw _privateConstructorUsedError;
  int get selectedOptionIndex => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int get timeRemainingSeconds => throw _privateConstructorUsedError;
  int get timeLimitSeconds => throw _privateConstructorUsedError;
  bool get isAutoAdvancing => throw _privateConstructorUsedError;
  String get userTypingInput => throw _privateConstructorUsedError;
  DateTime? get testStartTime =>
      throw _privateConstructorUsedError; // Card Matching State
  String? get selectedCardId => throw _privateConstructorUsedError;
  List<String> get matchedCardIds => throw _privateConstructorUsedError;
  bool get isMatchError => throw _privateConstructorUsedError;
  int get matchErrorCount => throw _privateConstructorUsedError;
  List<SortableChar> get userSortableAnswer =>
      throw _privateConstructorUsedError;

  /// Create a copy of TestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TestStateCopyWith<TestState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestStateCopyWith<$Res> {
  factory $TestStateCopyWith(TestState value, $Res Function(TestState) then) =
      _$TestStateCopyWithImpl<$Res, TestState>;
  @useResult
  $Res call({
    List<TestQuestion> questions,
    int currentIndex,
    bool isLoading,
    bool isTestActive,
    bool showResult,
    TestResult? testResult,
    int selectedOptionIndex,
    String? error,
    int timeRemainingSeconds,
    int timeLimitSeconds,
    bool isAutoAdvancing,
    String userTypingInput,
    DateTime? testStartTime,
    String? selectedCardId,
    List<String> matchedCardIds,
    bool isMatchError,
    int matchErrorCount,
    List<SortableChar> userSortableAnswer,
  });

  $TestResultCopyWith<$Res>? get testResult;
}

/// @nodoc
class _$TestStateCopyWithImpl<$Res, $Val extends TestState>
    implements $TestStateCopyWith<$Res> {
  _$TestStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TestState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questions = null,
    Object? currentIndex = null,
    Object? isLoading = null,
    Object? isTestActive = null,
    Object? showResult = null,
    Object? testResult = freezed,
    Object? selectedOptionIndex = null,
    Object? error = freezed,
    Object? timeRemainingSeconds = null,
    Object? timeLimitSeconds = null,
    Object? isAutoAdvancing = null,
    Object? userTypingInput = null,
    Object? testStartTime = freezed,
    Object? selectedCardId = freezed,
    Object? matchedCardIds = null,
    Object? isMatchError = null,
    Object? matchErrorCount = null,
    Object? userSortableAnswer = null,
  }) {
    return _then(
      _value.copyWith(
            questions: null == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<TestQuestion>,
            currentIndex: null == currentIndex
                ? _value.currentIndex
                : currentIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isTestActive: null == isTestActive
                ? _value.isTestActive
                : isTestActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            showResult: null == showResult
                ? _value.showResult
                : showResult // ignore: cast_nullable_to_non_nullable
                      as bool,
            testResult: freezed == testResult
                ? _value.testResult
                : testResult // ignore: cast_nullable_to_non_nullable
                      as TestResult?,
            selectedOptionIndex: null == selectedOptionIndex
                ? _value.selectedOptionIndex
                : selectedOptionIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            timeRemainingSeconds: null == timeRemainingSeconds
                ? _value.timeRemainingSeconds
                : timeRemainingSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            timeLimitSeconds: null == timeLimitSeconds
                ? _value.timeLimitSeconds
                : timeLimitSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            isAutoAdvancing: null == isAutoAdvancing
                ? _value.isAutoAdvancing
                : isAutoAdvancing // ignore: cast_nullable_to_non_nullable
                      as bool,
            userTypingInput: null == userTypingInput
                ? _value.userTypingInput
                : userTypingInput // ignore: cast_nullable_to_non_nullable
                      as String,
            testStartTime: freezed == testStartTime
                ? _value.testStartTime
                : testStartTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            selectedCardId: freezed == selectedCardId
                ? _value.selectedCardId
                : selectedCardId // ignore: cast_nullable_to_non_nullable
                      as String?,
            matchedCardIds: null == matchedCardIds
                ? _value.matchedCardIds
                : matchedCardIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isMatchError: null == isMatchError
                ? _value.isMatchError
                : isMatchError // ignore: cast_nullable_to_non_nullable
                      as bool,
            matchErrorCount: null == matchErrorCount
                ? _value.matchErrorCount
                : matchErrorCount // ignore: cast_nullable_to_non_nullable
                      as int,
            userSortableAnswer: null == userSortableAnswer
                ? _value.userSortableAnswer
                : userSortableAnswer // ignore: cast_nullable_to_non_nullable
                      as List<SortableChar>,
          )
          as $Val,
    );
  }

  /// Create a copy of TestState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TestResultCopyWith<$Res>? get testResult {
    if (_value.testResult == null) {
      return null;
    }

    return $TestResultCopyWith<$Res>(_value.testResult!, (value) {
      return _then(_value.copyWith(testResult: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TestStateImplCopyWith<$Res>
    implements $TestStateCopyWith<$Res> {
  factory _$$TestStateImplCopyWith(
    _$TestStateImpl value,
    $Res Function(_$TestStateImpl) then,
  ) = __$$TestStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<TestQuestion> questions,
    int currentIndex,
    bool isLoading,
    bool isTestActive,
    bool showResult,
    TestResult? testResult,
    int selectedOptionIndex,
    String? error,
    int timeRemainingSeconds,
    int timeLimitSeconds,
    bool isAutoAdvancing,
    String userTypingInput,
    DateTime? testStartTime,
    String? selectedCardId,
    List<String> matchedCardIds,
    bool isMatchError,
    int matchErrorCount,
    List<SortableChar> userSortableAnswer,
  });

  @override
  $TestResultCopyWith<$Res>? get testResult;
}

/// @nodoc
class __$$TestStateImplCopyWithImpl<$Res>
    extends _$TestStateCopyWithImpl<$Res, _$TestStateImpl>
    implements _$$TestStateImplCopyWith<$Res> {
  __$$TestStateImplCopyWithImpl(
    _$TestStateImpl _value,
    $Res Function(_$TestStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TestState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questions = null,
    Object? currentIndex = null,
    Object? isLoading = null,
    Object? isTestActive = null,
    Object? showResult = null,
    Object? testResult = freezed,
    Object? selectedOptionIndex = null,
    Object? error = freezed,
    Object? timeRemainingSeconds = null,
    Object? timeLimitSeconds = null,
    Object? isAutoAdvancing = null,
    Object? userTypingInput = null,
    Object? testStartTime = freezed,
    Object? selectedCardId = freezed,
    Object? matchedCardIds = null,
    Object? isMatchError = null,
    Object? matchErrorCount = null,
    Object? userSortableAnswer = null,
  }) {
    return _then(
      _$TestStateImpl(
        questions: null == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<TestQuestion>,
        currentIndex: null == currentIndex
            ? _value.currentIndex
            : currentIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isTestActive: null == isTestActive
            ? _value.isTestActive
            : isTestActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        showResult: null == showResult
            ? _value.showResult
            : showResult // ignore: cast_nullable_to_non_nullable
                  as bool,
        testResult: freezed == testResult
            ? _value.testResult
            : testResult // ignore: cast_nullable_to_non_nullable
                  as TestResult?,
        selectedOptionIndex: null == selectedOptionIndex
            ? _value.selectedOptionIndex
            : selectedOptionIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        timeRemainingSeconds: null == timeRemainingSeconds
            ? _value.timeRemainingSeconds
            : timeRemainingSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        timeLimitSeconds: null == timeLimitSeconds
            ? _value.timeLimitSeconds
            : timeLimitSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        isAutoAdvancing: null == isAutoAdvancing
            ? _value.isAutoAdvancing
            : isAutoAdvancing // ignore: cast_nullable_to_non_nullable
                  as bool,
        userTypingInput: null == userTypingInput
            ? _value.userTypingInput
            : userTypingInput // ignore: cast_nullable_to_non_nullable
                  as String,
        testStartTime: freezed == testStartTime
            ? _value.testStartTime
            : testStartTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        selectedCardId: freezed == selectedCardId
            ? _value.selectedCardId
            : selectedCardId // ignore: cast_nullable_to_non_nullable
                  as String?,
        matchedCardIds: null == matchedCardIds
            ? _value._matchedCardIds
            : matchedCardIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isMatchError: null == isMatchError
            ? _value.isMatchError
            : isMatchError // ignore: cast_nullable_to_non_nullable
                  as bool,
        matchErrorCount: null == matchErrorCount
            ? _value.matchErrorCount
            : matchErrorCount // ignore: cast_nullable_to_non_nullable
                  as int,
        userSortableAnswer: null == userSortableAnswer
            ? _value._userSortableAnswer
            : userSortableAnswer // ignore: cast_nullable_to_non_nullable
                  as List<SortableChar>,
      ),
    );
  }
}

/// @nodoc

class _$TestStateImpl extends _TestState {
  const _$TestStateImpl({
    final List<TestQuestion> questions = const [],
    this.currentIndex = 0,
    this.isLoading = false,
    this.isTestActive = false,
    this.showResult = false,
    this.testResult,
    this.selectedOptionIndex = -1,
    this.error,
    this.timeRemainingSeconds = 0,
    this.timeLimitSeconds = 0,
    this.isAutoAdvancing = false,
    this.userTypingInput = '',
    this.testStartTime,
    this.selectedCardId,
    final List<String> matchedCardIds = const [],
    this.isMatchError = false,
    this.matchErrorCount = 0,
    final List<SortableChar> userSortableAnswer = const [],
  }) : _questions = questions,
       _matchedCardIds = matchedCardIds,
       _userSortableAnswer = userSortableAnswer,
       super._();

  final List<TestQuestion> _questions;
  @override
  @JsonKey()
  List<TestQuestion> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  @JsonKey()
  final int currentIndex;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isTestActive;
  @override
  @JsonKey()
  final bool showResult;
  @override
  final TestResult? testResult;
  @override
  @JsonKey()
  final int selectedOptionIndex;
  @override
  final String? error;
  @override
  @JsonKey()
  final int timeRemainingSeconds;
  @override
  @JsonKey()
  final int timeLimitSeconds;
  @override
  @JsonKey()
  final bool isAutoAdvancing;
  @override
  @JsonKey()
  final String userTypingInput;
  @override
  final DateTime? testStartTime;
  // Card Matching State
  @override
  final String? selectedCardId;
  final List<String> _matchedCardIds;
  @override
  @JsonKey()
  List<String> get matchedCardIds {
    if (_matchedCardIds is EqualUnmodifiableListView) return _matchedCardIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_matchedCardIds);
  }

  @override
  @JsonKey()
  final bool isMatchError;
  @override
  @JsonKey()
  final int matchErrorCount;
  final List<SortableChar> _userSortableAnswer;
  @override
  @JsonKey()
  List<SortableChar> get userSortableAnswer {
    if (_userSortableAnswer is EqualUnmodifiableListView)
      return _userSortableAnswer;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userSortableAnswer);
  }

  @override
  String toString() {
    return 'TestState(questions: $questions, currentIndex: $currentIndex, isLoading: $isLoading, isTestActive: $isTestActive, showResult: $showResult, testResult: $testResult, selectedOptionIndex: $selectedOptionIndex, error: $error, timeRemainingSeconds: $timeRemainingSeconds, timeLimitSeconds: $timeLimitSeconds, isAutoAdvancing: $isAutoAdvancing, userTypingInput: $userTypingInput, testStartTime: $testStartTime, selectedCardId: $selectedCardId, matchedCardIds: $matchedCardIds, isMatchError: $isMatchError, matchErrorCount: $matchErrorCount, userSortableAnswer: $userSortableAnswer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestStateImpl &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isTestActive, isTestActive) ||
                other.isTestActive == isTestActive) &&
            (identical(other.showResult, showResult) ||
                other.showResult == showResult) &&
            (identical(other.testResult, testResult) ||
                other.testResult == testResult) &&
            (identical(other.selectedOptionIndex, selectedOptionIndex) ||
                other.selectedOptionIndex == selectedOptionIndex) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.timeRemainingSeconds, timeRemainingSeconds) ||
                other.timeRemainingSeconds == timeRemainingSeconds) &&
            (identical(other.timeLimitSeconds, timeLimitSeconds) ||
                other.timeLimitSeconds == timeLimitSeconds) &&
            (identical(other.isAutoAdvancing, isAutoAdvancing) ||
                other.isAutoAdvancing == isAutoAdvancing) &&
            (identical(other.userTypingInput, userTypingInput) ||
                other.userTypingInput == userTypingInput) &&
            (identical(other.testStartTime, testStartTime) ||
                other.testStartTime == testStartTime) &&
            (identical(other.selectedCardId, selectedCardId) ||
                other.selectedCardId == selectedCardId) &&
            const DeepCollectionEquality().equals(
              other._matchedCardIds,
              _matchedCardIds,
            ) &&
            (identical(other.isMatchError, isMatchError) ||
                other.isMatchError == isMatchError) &&
            (identical(other.matchErrorCount, matchErrorCount) ||
                other.matchErrorCount == matchErrorCount) &&
            const DeepCollectionEquality().equals(
              other._userSortableAnswer,
              _userSortableAnswer,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_questions),
    currentIndex,
    isLoading,
    isTestActive,
    showResult,
    testResult,
    selectedOptionIndex,
    error,
    timeRemainingSeconds,
    timeLimitSeconds,
    isAutoAdvancing,
    userTypingInput,
    testStartTime,
    selectedCardId,
    const DeepCollectionEquality().hash(_matchedCardIds),
    isMatchError,
    matchErrorCount,
    const DeepCollectionEquality().hash(_userSortableAnswer),
  );

  /// Create a copy of TestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TestStateImplCopyWith<_$TestStateImpl> get copyWith =>
      __$$TestStateImplCopyWithImpl<_$TestStateImpl>(this, _$identity);
}

abstract class _TestState extends TestState {
  const factory _TestState({
    final List<TestQuestion> questions,
    final int currentIndex,
    final bool isLoading,
    final bool isTestActive,
    final bool showResult,
    final TestResult? testResult,
    final int selectedOptionIndex,
    final String? error,
    final int timeRemainingSeconds,
    final int timeLimitSeconds,
    final bool isAutoAdvancing,
    final String userTypingInput,
    final DateTime? testStartTime,
    final String? selectedCardId,
    final List<String> matchedCardIds,
    final bool isMatchError,
    final int matchErrorCount,
    final List<SortableChar> userSortableAnswer,
  }) = _$TestStateImpl;
  const _TestState._() : super._();

  @override
  List<TestQuestion> get questions;
  @override
  int get currentIndex;
  @override
  bool get isLoading;
  @override
  bool get isTestActive;
  @override
  bool get showResult;
  @override
  TestResult? get testResult;
  @override
  int get selectedOptionIndex;
  @override
  String? get error;
  @override
  int get timeRemainingSeconds;
  @override
  int get timeLimitSeconds;
  @override
  bool get isAutoAdvancing;
  @override
  String get userTypingInput;
  @override
  DateTime? get testStartTime; // Card Matching State
  @override
  String? get selectedCardId;
  @override
  List<String> get matchedCardIds;
  @override
  bool get isMatchError;
  @override
  int get matchErrorCount;
  @override
  List<SortableChar> get userSortableAnswer;

  /// Create a copy of TestState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TestStateImplCopyWith<_$TestStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
