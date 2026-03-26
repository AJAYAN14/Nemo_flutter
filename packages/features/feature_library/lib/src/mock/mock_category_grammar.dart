class CategoryMockData {
  const CategoryMockData(this.title, this.count, this.icon);
  final String title;
  final int count;
  final String icon;
}

const mockPosCategories = [
  CategoryMockData('名词 (Noun)', 1240, '📦'),
  CategoryMockData('动词 (Verb)', 860, '🏃'),
  CategoryMockData('形容词 (Adjective)', 420, '✨'),
  CategoryMockData('副词 (Adverb)', 210, '💨'),
  CategoryMockData('连词 (Conjunction)', 85, '🔗'),
  CategoryMockData('助词 (Particle)', 120, '🧩'),
];

class GrammarExampleMockData {
  const GrammarExampleMockData({required this.japanese, required this.chinese});
  final String japanese;
  final String chinese;
}

class GrammarMockData {
  const GrammarMockData({
    required this.title,
    required this.meaning,
    required this.level,
    required this.examples,
  });
  final String title;
  final String meaning;
  final String level;
  final List<GrammarExampleMockData> examples;
}

const mockGrammars = [
  GrammarMockData(
    title: '〜てしまう / 〜ちゃう',
    meaning: '表示动作的彻底完成，或表示遗憾、后悔的心情。',
    level: 'N4',
    examples: [
      GrammarExampleMockData(japanese: 'ケーキを全部食べてしまった。', chinese: '把蛋糕全吃光了。'),
      GrammarExampleMockData(japanese: '電車に傘を忘れてきちゃった。', chinese: '把伞忘在电车上了。'),
    ],
  ),
  GrammarMockData(
    title: '〜わけではない',
    meaning: '并非...；并不是说...（部分否定）。',
    level: 'N3',
    examples: [
      GrammarExampleMockData(
        japanese: 'お金があれば幸せなわけではない。',
        chinese: '并不是有钱就一定幸福。',
      ),
      GrammarExampleMockData(
        japanese: '彼が嫌いなわけではないが、一緒に働きたくない。',
        chinese: '我也不是讨厌他，只是不想一起工作。',
      ),
    ],
  ),
  GrammarMockData(
    title: '〜ざるを得ない',
    meaning: '不得不...；只能...（多用于书面或郑重场合）。',
    level: 'N2',
    examples: [
      GrammarExampleMockData(
        japanese: '雨がひどいので、試合は中止せざるを得ない。',
        chinese: '雨太大了，比赛不得不中止。',
      ),
      GrammarExampleMockData(
        japanese: '社長の命令なら、従わざるを得ない。',
        chinese: '既然是社长的命令，也就不得不服从了。',
      ),
    ],
  ),
  GrammarMockData(
    title: '〜がてら',
    meaning: '顺便...（借着做某事的机会，顺便做另一件事）。',
    level: 'N1',
    examples: [
      GrammarExampleMockData(
        japanese: '散歩がてら、タバコを買ってきます。',
        chinese: '借着散步的机会，顺便去买包烟。',
      ),
      GrammarExampleMockData(
        japanese: 'お花見がてら、ちょっと買い物に行こう。',
        chinese: '去赏花，顺便买点东西吧。',
      ),
    ],
  ),
];
