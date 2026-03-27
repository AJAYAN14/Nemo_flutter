import 'package:core_domain/core_domain.dart';

sealed class LearningItem {
  const LearningItem();
}

class WordItem extends LearningItem {
  final Word word;
  const WordItem(this.word);
}

class GrammarItem extends LearningItem {
  final Grammar grammar;
  const GrammarItem(this.grammar);
}
