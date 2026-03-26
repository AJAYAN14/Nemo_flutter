class KanaCell {
  final String hiragana;
  final String? katakana;
  final String romaji;

  const KanaCell({
    required this.hiragana,
    this.katakana,
    required this.romaji,
  });

  String getKana(bool isKatakana) => (isKatakana ? katakana : hiragana) ?? hiragana;

  String getSpeakText(bool isKatakana) {
    final text = getKana(isKatakana);
    switch (text) {
      case "っ+k":
      case "ッ+k":
        return isKatakana ? "ガッコウ" : "がっこう";
      case "っ+s":
      case "ッ+s":
        return isKatakana ? "カッサ" : "かっさ";
      case "っ+t":
      case "ッ+t":
        return isKatakana ? "キッテ" : "きって";
      case "っ+p":
      case "ッ+p":
        return isKatakana ? "カップ" : "かっぷ";
      default:
        return text;
    }
  }
}

const List<KanaCell?> seionData = [
  KanaCell(hiragana: "あ", katakana: "ア", romaji: "a"),
  KanaCell(hiragana: "い", katakana: "イ", romaji: "i"),
  KanaCell(hiragana: "う", katakana: "ウ", romaji: "u"),
  KanaCell(hiragana: "え", katakana: "エ", romaji: "e"),
  KanaCell(hiragana: "お", katakana: "オ", romaji: "o"),
  KanaCell(hiragana: "か", katakana: "カ", romaji: "ka"),
  KanaCell(hiragana: "き", katakana: "キ", romaji: "ki"),
  KanaCell(hiragana: "く", katakana: "ク", romaji: "ku"),
  KanaCell(hiragana: "け", katakana: "ケ", romaji: "ke"),
  KanaCell(hiragana: "こ", katakana: "コ", romaji: "ko"),
  KanaCell(hiragana: "さ", katakana: "サ", romaji: "sa"),
  KanaCell(hiragana: "し", katakana: "シ", romaji: "shi"),
  KanaCell(hiragana: "す", katakana: "ス", romaji: "su"),
  KanaCell(hiragana: "せ", katakana: "セ", romaji: "se"),
  KanaCell(hiragana: "そ", katakana: "ソ", romaji: "so"),
  KanaCell(hiragana: "た", katakana: "タ", romaji: "ta"),
  KanaCell(hiragana: "ち", katakana: "チ", romaji: "chi"),
  KanaCell(hiragana: "つ", katakana: "ツ", romaji: "tsu"),
  KanaCell(hiragana: "て", katakana: "テ", romaji: "te"),
  KanaCell(hiragana: "と", katakana: "ト", romaji: "to"),
  KanaCell(hiragana: "な", katakana: "ナ", romaji: "na"),
  KanaCell(hiragana: "に", katakana: "ニ", romaji: "ni"),
  KanaCell(hiragana: "ぬ", katakana: "ヌ", romaji: "nu"),
  KanaCell(hiragana: "ね", katakana: "ネ", romaji: "ne"),
  KanaCell(hiragana: "の", katakana: "ノ", romaji: "no"),
  KanaCell(hiragana: "は", katakana: "ハ", romaji: "ha"),
  KanaCell(hiragana: "ひ", katakana: "ヒ", romaji: "hi"),
  KanaCell(hiragana: "ふ", katakana: "フ", romaji: "fu"),
  KanaCell(hiragana: "へ", katakana: "ヘ", romaji: "he"),
  KanaCell(hiragana: "ほ", katakana: "ホ", romaji: "ho"),
  KanaCell(hiragana: "ま", katakana: "マ", romaji: "ma"),
  KanaCell(hiragana: "み", katakana: "ミ", romaji: "mi"),
  KanaCell(hiragana: "む", katakana: "ム", romaji: "mu"),
  KanaCell(hiragana: "め", katakana: "メ", romaji: "me"),
  KanaCell(hiragana: "も", katakana: "モ", romaji: "mo"),
  KanaCell(hiragana: "や", katakana: "ヤ", romaji: "ya"),
  null,
  KanaCell(hiragana: "ゆ", katakana: "ユ", romaji: "yu"),
  null,
  KanaCell(hiragana: "よ", katakana: "ヨ", romaji: "yo"),
  KanaCell(hiragana: "ら", katakana: "ラ", romaji: "ra"),
  KanaCell(hiragana: "り", katakana: "リ", romaji: "ri"),
  KanaCell(hiragana: "る", katakana: "ル", romaji: "ru"),
  KanaCell(hiragana: "れ", katakana: "レ", romaji: "re"),
  KanaCell(hiragana: "ろ", katakana: "ロ", romaji: "ro"),
  KanaCell(hiragana: "わ", katakana: "ワ", romaji: "wa"),
  null,
  null,
  null,
  KanaCell(hiragana: "を", katakana: "ヲ", romaji: "wo"),
  KanaCell(hiragana: "ん", katakana: "ン", romaji: "n"),
  null,
  null,
  null,
  null,
];

const List<KanaCell> dakuonData = [
  KanaCell(hiragana: "が", katakana: "ガ", romaji: "ga"),
  KanaCell(hiragana: "ぎ", katakana: "ギ", romaji: "gi"),
  KanaCell(hiragana: "ぐ", katakana: "グ", romaji: "gu"),
  KanaCell(hiragana: "げ", katakana: "ゲ", romaji: "ge"),
  KanaCell(hiragana: "ご", katakana: "ゴ", romaji: "go"),
  KanaCell(hiragana: "ざ", katakana: "ザ", romaji: "za"),
  KanaCell(hiragana: "じ", katakana: "ジ", romaji: "ji"),
  KanaCell(hiragana: "ず", katakana: "ズ", romaji: "zu"),
  KanaCell(hiragana: "ぜ", katakana: "ゼ", romaji: "ze"),
  KanaCell(hiragana: "ぞ", katakana: "ゾ", romaji: "zo"),
  KanaCell(hiragana: "だ", katakana: "ダ", romaji: "da"),
  KanaCell(hiragana: "ぢ", katakana: "ヂ", romaji: "ji"),
  KanaCell(hiragana: "づ", katakana: "ヅ", romaji: "zu"),
  KanaCell(hiragana: "で", katakana: "デ", romaji: "de"),
  KanaCell(hiragana: "ど", katakana: "ド", romaji: "do"),
  KanaCell(hiragana: "ば", katakana: "バ", romaji: "ba"),
  KanaCell(hiragana: "び", katakana: "ビ", romaji: "bi"),
  KanaCell(hiragana: "ぶ", katakana: "ブ", romaji: "bu"),
  KanaCell(hiragana: "べ", katakana: "ベ", romaji: "be"),
  KanaCell(hiragana: "ぼ", katakana: "ボ", romaji: "bo"),
  KanaCell(hiragana: "ぱ", katakana: "パ", romaji: "pa"),
  KanaCell(hiragana: "ぴ", katakana: "ピ", romaji: "pi"),
  KanaCell(hiragana: "ぷ", katakana: "プ", romaji: "pu"),
  KanaCell(hiragana: "ぺ", katakana: "ペ", romaji: "pe"),
  KanaCell(hiragana: "ぽ", katakana: "ポ", romaji: "po"),
];

const List<KanaCell> yoonData = [
  KanaCell(hiragana: "きゃ", katakana: "キャ", romaji: "kya"),
  KanaCell(hiragana: "きゅ", katakana: "キュ", romaji: "kyu"),
  KanaCell(hiragana: "きょ", katakana: "キョ", romaji: "kyo"),
  KanaCell(hiragana: "ぎゃ", katakana: "ギャ", romaji: "gya"),
  KanaCell(hiragana: "ぎゅ", katakana: "ギュ", romaji: "gyu"),
  KanaCell(hiragana: "ぎょ", katakana: "ギョ", romaji: "gyo"),
  KanaCell(hiragana: "しゃ", katakana: "シャ", romaji: "sha"),
  KanaCell(hiragana: "しゅ", katakana: "シュ", romaji: "shu"),
  KanaCell(hiragana: "しょ", katakana: "ショ", romaji: "sho"),
  KanaCell(hiragana: "じゃ", katakana: "ジャ", romaji: "ja"),
  KanaCell(hiragana: "じゅ", katakana: "ジュ", romaji: "ju"),
  KanaCell(hiragana: "じょ", katakana: "ジョ", romaji: "jo"),
  KanaCell(hiragana: "ちゃ", katakana: "チャ", romaji: "cha"),
  KanaCell(hiragana: "ちゅ", katakana: "チュ", romaji: "chu"),
  KanaCell(hiragana: "ちょ", katakana: "チョ", romaji: "cho"),
  KanaCell(hiragana: "にゃ", katakana: "ニャ", romaji: "nya"),
  KanaCell(hiragana: "にゅ", katakana: "ニュ", romaji: "nyu"),
  KanaCell(hiragana: "にょ", katakana: "ニョ", romaji: "nyo"),
  KanaCell(hiragana: "ひゃ", katakana: "ヒャ", romaji: "hya"),
  KanaCell(hiragana: "ひゅ", katakana: "ヒュ", romaji: "hyu"),
  KanaCell(hiragana: "ひょ", katakana: "ヒョ", romaji: "hyo"),
  KanaCell(hiragana: "びゃ", katakana: "ビャ", romaji: "bya"),
  KanaCell(hiragana: "びゅ", katakana: "ビュ", romaji: "byu"),
  KanaCell(hiragana: "びょ", katakana: "ビョ", romaji: "byo"),
  KanaCell(hiragana: "ぴゃ", katakana: "ピャ", romaji: "pya"),
  KanaCell(hiragana: "ぴゅ", katakana: "ピュ", romaji: "pyu"),
  KanaCell(hiragana: "ぴょ", katakana: "ピョ", romaji: "pyo"),
  KanaCell(hiragana: "みゃ", katakana: "ミャ", romaji: "mya"),
  KanaCell(hiragana: "みゅ", katakana: "ミュ", romaji: "myu"),
  KanaCell(hiragana: "みょ", katakana: "ミョ", romaji: "myo"),
  KanaCell(hiragana: "りゃ", katakana: "リャ", romaji: "rya"),
  KanaCell(hiragana: "りゅ", katakana: "リュ", romaji: "ryu"),
  KanaCell(hiragana: "りょ", katakana: "リョ", romaji: "ryo"),
];

const List<KanaCell> sokuonData = [
  KanaCell(hiragana: "っ+k", katakana: "ッ+k", romaji: "kk"),
  KanaCell(hiragana: "っ+s", katakana: "ッ+s", romaji: "ss"),
  KanaCell(hiragana: "っ+t", katakana: "ッ+t", romaji: "tt"),
  KanaCell(hiragana: "っ+p", katakana: "ッ+p", romaji: "pp"),
];

const List<KanaCell?> chouonData = [
  KanaCell(hiragana: "ああ", katakana: "アー", romaji: "aa"),
  KanaCell(hiragana: "いい", katakana: "イー", romaji: "ii"),
  KanaCell(hiragana: "うう", katakana: "ウー", romaji: "uu"),
  KanaCell(hiragana: "ええ", katakana: "エー", romaji: "ee"),
  KanaCell(hiragana: "おお", katakana: "オー", romaji: "oo"),
  null,
  null,
  null,
  KanaCell(hiragana: "えい", romaji: "ei"),
  KanaCell(hiragana: "おう", romaji: "ou"),
];
