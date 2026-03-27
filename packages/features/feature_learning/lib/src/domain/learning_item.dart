import 'package:core_domain/core_domain.dart';
import 'package:core_storage/core_storage.dart';

abstract class LearningItem {
  LearningProgressData? get progress;
}

class WordItem extends LearningItem {
  WordItem(this.word, {this.progress});
  final Word word;
  @override
  final LearningProgressData? progress;

  WordItem copyWith({LearningProgressData? progress}) => WordItem(word, progress: progress ?? this.progress);
}

class GrammarItem extends LearningItem {
  GrammarItem(this.grammar, {this.progress});
  final Grammar grammar;
  @override
  final LearningProgressData? progress;

  GrammarItem copyWith({LearningProgressData? progress}) => GrammarItem(grammar, progress: progress ?? this.progress);
}
