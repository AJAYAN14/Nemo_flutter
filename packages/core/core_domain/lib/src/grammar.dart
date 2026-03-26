import 'package:freezed_annotation/freezed_annotation.dart';

part 'grammar.freezed.dart';
part 'grammar.g.dart';

@freezed
class Grammar with _$Grammar {
  const factory Grammar({
    required int id,
    required String grammar,
    required String grammarLevel,
    @Default(false) bool isDelisted,
    required List<GrammarUsage> usages,
    
    // SRS fields
    @Default(0) int repetitionCount,
    @Default(0) int interval,
    @Default(0.0) double stability,
    @Default(0.0) double difficulty,
    @Default(0) int nextReviewDate,
    int? lastReviewedDate,
    int? firstLearnedDate,
    
    @Default(false) bool isFavorite,
    @Default(false) bool isSkipped,
    @Default(0) int buriedUntilDay,
    required int lastModifiedTime,
  }) = _Grammar;

  factory Grammar.fromJson(Map<String, dynamic> json) => _$GrammarFromJson(json);
}

@freezed
class GrammarUsage with _$GrammarUsage {
  const factory GrammarUsage({
    String? subtype,
    required String connection,
    required String explanation,
    String? notes,
    required List<GrammarExample> examples,
  }) = _GrammarUsage;

  factory GrammarUsage.fromJson(Map<String, dynamic> json) => _$GrammarUsageFromJson(json);
}

@freezed
class GrammarExample with _$GrammarExample {
  const factory GrammarExample({
    required String sentence,
    required String translation,
    String? source,
    @Default(false) bool isDialog,
  }) = _GrammarExample;

  factory GrammarExample.fromJson(Map<String, dynamic> json) => _$GrammarExampleFromJson(json);
}
