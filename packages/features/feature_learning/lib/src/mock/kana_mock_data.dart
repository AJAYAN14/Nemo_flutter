enum KanaSection {
  seion,
  dakuon,
  yoon,
}

class KanaCellData {
  const KanaCellData({
    required this.kana,
    required this.romaji,
  });

  final String kana;
  final String romaji;
}

const kanaSectionLabels = <KanaSection, String>{
  KanaSection.seion: '清音',
  KanaSection.dakuon: '浊音',
  KanaSection.yoon: '拗音',
};

const kanaColumns = <KanaSection, int>{
  KanaSection.seion: 5,
  KanaSection.dakuon: 5,
  KanaSection.yoon: 3,
};

const kanaGridData = <KanaSection, List<KanaCellData>>{
  KanaSection.seion: [
    KanaCellData(kana: 'あ', romaji: 'a'),
    KanaCellData(kana: 'い', romaji: 'i'),
    KanaCellData(kana: 'う', romaji: 'u'),
    KanaCellData(kana: 'え', romaji: 'e'),
    KanaCellData(kana: 'お', romaji: 'o'),
    KanaCellData(kana: 'か', romaji: 'ka'),
    KanaCellData(kana: 'き', romaji: 'ki'),
    KanaCellData(kana: 'く', romaji: 'ku'),
    KanaCellData(kana: 'け', romaji: 'ke'),
    KanaCellData(kana: 'こ', romaji: 'ko'),
    KanaCellData(kana: 'さ', romaji: 'sa'),
    KanaCellData(kana: 'し', romaji: 'shi'),
    KanaCellData(kana: 'す', romaji: 'su'),
    KanaCellData(kana: 'せ', romaji: 'se'),
    KanaCellData(kana: 'そ', romaji: 'so'),
    KanaCellData(kana: 'た', romaji: 'ta'),
    KanaCellData(kana: 'ち', romaji: 'chi'),
    KanaCellData(kana: 'つ', romaji: 'tsu'),
    KanaCellData(kana: 'て', romaji: 'te'),
    KanaCellData(kana: 'と', romaji: 'to'),
    KanaCellData(kana: 'な', romaji: 'na'),
    KanaCellData(kana: 'に', romaji: 'ni'),
    KanaCellData(kana: 'ぬ', romaji: 'nu'),
    KanaCellData(kana: 'ね', romaji: 'ne'),
    KanaCellData(kana: 'の', romaji: 'no'),
  ],
  KanaSection.dakuon: [
    KanaCellData(kana: 'が', romaji: 'ga'),
    KanaCellData(kana: 'ぎ', romaji: 'gi'),
    KanaCellData(kana: 'ぐ', romaji: 'gu'),
    KanaCellData(kana: 'げ', romaji: 'ge'),
    KanaCellData(kana: 'ご', romaji: 'go'),
    KanaCellData(kana: 'ざ', romaji: 'za'),
    KanaCellData(kana: 'じ', romaji: 'ji'),
    KanaCellData(kana: 'ず', romaji: 'zu'),
    KanaCellData(kana: 'ぜ', romaji: 'ze'),
    KanaCellData(kana: 'ぞ', romaji: 'zo'),
    KanaCellData(kana: 'だ', romaji: 'da'),
    KanaCellData(kana: 'ぢ', romaji: 'ji'),
    KanaCellData(kana: 'づ', romaji: 'zu'),
    KanaCellData(kana: 'で', romaji: 'de'),
    KanaCellData(kana: 'ど', romaji: 'do'),
    KanaCellData(kana: 'ば', romaji: 'ba'),
    KanaCellData(kana: 'び', romaji: 'bi'),
    KanaCellData(kana: 'ぶ', romaji: 'bu'),
    KanaCellData(kana: 'べ', romaji: 'be'),
    KanaCellData(kana: 'ぼ', romaji: 'bo'),
  ],
  KanaSection.yoon: [
    KanaCellData(kana: 'きゃ', romaji: 'kya'),
    KanaCellData(kana: 'きゅ', romaji: 'kyu'),
    KanaCellData(kana: 'きょ', romaji: 'kyo'),
    KanaCellData(kana: 'しゃ', romaji: 'sha'),
    KanaCellData(kana: 'しゅ', romaji: 'shu'),
    KanaCellData(kana: 'しょ', romaji: 'sho'),
    KanaCellData(kana: 'ちゃ', romaji: 'cha'),
    KanaCellData(kana: 'ちゅ', romaji: 'chu'),
    KanaCellData(kana: 'ちょ', romaji: 'cho'),
    KanaCellData(kana: 'にゃ', romaji: 'nya'),
    KanaCellData(kana: 'にゅ', romaji: 'nyu'),
    KanaCellData(kana: 'にょ', romaji: 'nyo'),
    KanaCellData(kana: 'ひゃ', romaji: 'hya'),
    KanaCellData(kana: 'ひゅ', romaji: 'hyu'),
    KanaCellData(kana: 'ひょ', romaji: 'hyo'),
  ],
};
