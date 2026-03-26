import 'package:core_domain/core_domain.dart';

// We'll use a Union-like class for the UI and mock data
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

const mockLearningItems = <LearningItem>[
  WordItem(
    Word(
      id: 'w_1',
      japanese: '継続',
      hiragana: 'けいぞく',
      chinese: '持续，坚持',
      level: 'N2',
      pos: '名・スル',
      examples: [
        WordExample(japanese: '継続は力なり。', chinese: '坚持就是力量。'),
      ],
    ),
  ),
  GrammarItem(
    Grammar(
      id: 1,
      grammar: '〜とともに',
      grammarLevel: 'N2',
      lastModifiedTime: 0,
      usages: [
        GrammarUsage(
          subtype: '用法一',
          connection: '动词辞书形 / 名词 + とともに',
          explanation: '表示两个事项随之进行，或者表示“……的同时”。',
          notes: '常用于正式书面语。',
          examples: [
            GrammarExample(sentence: '日本语の上达とともに、日本文化への理解も深まった。', translation: '随着日语的进步，对日本文化的理解也加深了。'),
          ],
        ),
      ],
    ),
  ),
  WordItem(
    Word(
      id: 'w_2',
      japanese: '挑戦',
      hiragana: 'ちょうせん',
      chinese: '挑战',
      level: 'N2',
      pos: '名・スル',
      examples: [
        WordExample(japanese: '新しいことに挑戦する。', chinese: '挑战新事物。'),
      ],
    ),
  ),
];
