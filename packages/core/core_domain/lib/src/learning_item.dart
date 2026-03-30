import 'package:freezed_annotation/freezed_annotation.dart';
import 'word.dart';
import 'grammar.dart';

part 'learning_item.freezed.dart';
part 'learning_item.g.dart';

@freezed
class StudyProgress with _$StudyProgress {
  const factory StudyProgress({
    required String id,
    required String itemType,
    @Default(0) int repetitionCount,
    @Default(0) int interval,
    @Default(0.0) double easeFactor,
    @Default(0) int dueTime,
    int? lastReviewed,
    int? firstLearned,
    @Default(0) int step,
    @Default(false) bool isSuspended,
    @Default(0) int lapses,
    @Default(false) bool isSkipped,
    @Default(0) int buriedUntilDay,
    @Default(0) int lastModifiedTime,
  }) = _StudyProgress;

  factory StudyProgress.fromJson(Map<String, dynamic> json) =>
      _$StudyProgressFromJson(json);
}

extension StudyProgressX on StudyProgress {
  // We use dynamic/any here to avoid circular dependency on core_storage
  // The caller will cast it to LearningProgressCompanion
  dynamic toCompanion() {
    return {
      'id': id,
      'itemType': itemType,
      'repetitionCount': repetitionCount,
      'interval': interval,
      'difficulty': easeFactor,
      'dueTime': dueTime,
      'lastReviewed': lastReviewed,
      'firstLearned': firstLearned,
      'step': step,
      'isSuspended': isSuspended,
      'lapses': lapses,
      'isSkipped': isSkipped,
      'buriedUntilDay': buriedUntilDay,
    };
  }
}

enum CardBadge { fresh, review, relearn }

abstract class LearningItem {
  String get id;
  StudyProgress? get progress;

  CardBadge get badge {
    final prog = progress;
    if (prog == null) return CardBadge.fresh;

    if (prog.repetitionCount == 0 && prog.step == 0) {
      return CardBadge.fresh;
    }

    if (prog.interval == 0) {
      return CardBadge.relearn;
    }

    return CardBadge.review;
  }
}

class WordItem extends LearningItem {
  WordItem(this.word, {this.progress});
  final Word word;
  @override
  String get id => 'word_${word.id}';

  @override
  final StudyProgress? progress;

  WordItem copyWith({StudyProgress? progress}) =>
      WordItem(word, progress: progress ?? this.progress);
}

class GrammarItem extends LearningItem {
  GrammarItem(this.grammar, {this.progress});
  final Grammar grammar;
  @override
  String get id => 'grammar_${grammar.id}';

  @override
  final StudyProgress? progress;

  GrammarItem copyWith({StudyProgress? progress}) =>
      GrammarItem(grammar, progress: progress ?? this.progress);
}
