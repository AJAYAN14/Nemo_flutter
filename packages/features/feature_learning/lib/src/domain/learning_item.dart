import 'package:core_domain/core_domain.dart';
import 'package:core_storage/core_storage.dart';
import 'card_badge.dart';

abstract class LearningItem {
  String get id;
  LearningProgressData? get progress;

  CardBadge get badge {
    final prog = progress;
    if (prog == null) return CardBadge.fresh;
    
    // 如果从来没学过（重复次数为0且不在学习步进中）
    if (prog.repetitionCount == 0 && prog.step == 0) {
      return CardBadge.fresh;
    }
    
    // 如果间隔为0，通常意味着在学习/复习失败后的重新学习阶段
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
  final LearningProgressData? progress;

  WordItem copyWith({LearningProgressData? progress}) => WordItem(word, progress: progress ?? this.progress);
}

class GrammarItem extends LearningItem {
  GrammarItem(this.grammar, {this.progress});
  final Grammar grammar;
  @override
  String get id => 'grammar_${grammar.id}';

  @override
  final LearningProgressData? progress;

  GrammarItem copyWith({LearningProgressData? progress}) => GrammarItem(grammar, progress: progress ?? this.progress);
}
