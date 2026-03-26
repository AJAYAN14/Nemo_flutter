class SessionPrepWordItem {
  const SessionPrepWordItem({
    required this.japanese,
    required this.hiragana,
    required this.meaning,
    required this.level,
    required this.example,
  });

  final String japanese;
  final String hiragana;
  final String meaning;
  final String level;
  final String example;
}

const sessionPrepMockWords = <SessionPrepWordItem>[
  SessionPrepWordItem(
    japanese: '勉強',
    hiragana: 'べんきょう',
    meaning: '学习',
    level: 'N5',
    example: '毎日日本語を勉強します。',
  ),
  SessionPrepWordItem(
    japanese: '継続',
    hiragana: 'けいぞく',
    meaning: '持续，坚持',
    level: 'N2',
    example: '継続は力なり。',
  ),
  SessionPrepWordItem(
    japanese: '挑戦',
    hiragana: 'ちょうせん',
    meaning: '挑战',
    level: 'N3',
    example: '新しいことに挑戦する。',
  ),
  SessionPrepWordItem(
    japanese: '復習',
    hiragana: 'ふくしゅう',
    meaning: '复习',
    level: 'N4',
    example: '授業の内容を復習する。',
  ),
  SessionPrepWordItem(
    japanese: '習慣',
    hiragana: 'しゅうかん',
    meaning: '习惯',
    level: 'N2',
    example: '早起きの習慣を作る。',
  ),
  SessionPrepWordItem(
    japanese: '理解',
    hiragana: 'りかい',
    meaning: '理解',
    level: 'N3',
    example: '文法の意味を理解する。',
  ),
  SessionPrepWordItem(
    japanese: '整理',
    hiragana: 'せいり',
    meaning: '整理',
    level: 'N3',
    example: 'ノートを整理する。',
  ),
  SessionPrepWordItem(
    japanese: '記録',
    hiragana: 'きろく',
    meaning: '记录',
    level: 'N4',
    example: '学習時間を記録する。',
  ),
  SessionPrepWordItem(
    japanese: '目標',
    hiragana: 'もくひょう',
    meaning: '目标',
    level: 'N5',
    example: '今月の目標を決める。',
  ),
  SessionPrepWordItem(
    japanese: '達成',
    hiragana: 'たっせい',
    meaning: '达成',
    level: 'N2',
    example: '目標を達成した。',
  ),
];
