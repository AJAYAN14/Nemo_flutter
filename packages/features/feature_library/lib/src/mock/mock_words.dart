class WordMockData {
  const WordMockData({
    required this.id,
    required this.kanji,
    required this.hiragana,
    required this.meaning,
    required this.type,
    required this.level,
    required this.furiganaData,
    required this.examples,
    this.isFavorite = false,
  });

  final String id;
  final String kanji;
  final String hiragana;
  final String meaning;
  final String type;
  final String level;
  final List<FuriganaMockBlock> furiganaData;
  final List<WordExampleMockData> examples;
  final bool isFavorite;
}

class FuriganaMockBlock {
  const FuriganaMockBlock(this.text, this.furigana);
  final String text; // kanji or kana
  final String? furigana; // only kanji has furigana
}

class WordExampleMockData {
  const WordExampleMockData({
    required this.japanese,
    required this.chinese,
  });
  final String japanese;
  final String chinese;
}

const mockWords = [
  WordMockData(
    id: "N5_0003",
    kanji: "会う",
    hiragana: "あう",
    meaning: "见面，会见；偶遇，碰见",
    level: "N5",
    type: "自動1",
    isFavorite: false,
    furiganaData: [
      FuriganaMockBlock("会", "あ"),
      FuriganaMockBlock("う", ""),
    ],
    examples: [
      WordExampleMockData(
        japanese: "先[せん]生[せい]に会[あ]う。",
        chinese: "见老师。",
      ),
      WordExampleMockData(
        japanese: "銀[ぎん]行[こう]で友[とも]達[だち]に会[あ]った。",
        chinese: "在银行偶遇朋友。",
      ),
      WordExampleMockData(
        japanese: "駅[えき]で母[はは]に会[あ]う。",
        chinese: "在车站见到妈妈。",
      ),
    ],
  ),
  WordMockData(
    id: 'w_002',
    kanji: '習慣',
    hiragana: 'しゅうかん',
    meaning: '习惯，习俗',
    type: '名词',
    level: 'N2',
    furiganaData: [
      FuriganaMockBlock('習', 'しゅう'),
      FuriganaMockBlock('慣', 'かん'),
    ],
    examples: [
      WordExampleMockData(
        japanese: '早起きの習慣をつける。',
        chinese: '养成早起的习惯。',
      ),
      WordExampleMockData(
        japanese: '日本の習慣について学ぶ。',
        chinese: '学习关于日本的习俗。',
      ),
    ],
    isFavorite: true,
  ),
  WordMockData(
    id: 'w_003',
    kanji: '美しい',
    hiragana: 'うつくしい',
    meaning: '美丽的，优美的',
    type: 'い形容词',
    level: 'N4',
    furiganaData: [
      FuriganaMockBlock('美', 'うつく'),
      FuriganaMockBlock('しい', null),
    ],
    examples: [
      WordExampleMockData(
        japanese: '美しい景色を見ながら歩く。',
        chinese: '一边看着美丽的景色一边散步。',
      ),
    ],
    isFavorite: false,
  ),
  WordMockData(
    id: 'w_004',
    kanji: '打ち合わせ',
    hiragana: 'うちあわせ',
    meaning: '商量，碰头会，预先商谈',
    type: '名词',
    level: 'N2',
    furiganaData: [
      FuriganaMockBlock('打', 'う'),
      FuriganaMockBlock('ち', null),
      FuriganaMockBlock('合', 'あ'),
      FuriganaMockBlock('わせ', null),
    ],
    examples: [
      WordExampleMockData(
        japanese: '明日の会議の打ち合わせをする。',
        chinese: '为明天的会议进行事前商量。',
      ),
    ],
    isFavorite: false,
  ),
];
