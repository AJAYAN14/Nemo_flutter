import '../grammar.dart';

/// 语法搜索工具类
/// 
/// 用于处理带注音的文本（格式：汉字[假名]），支持：
/// 1. 提取纯文本（去掉[]及其内容）
/// 2. 提取全假名文本（将汉字替换为[]中的假名）
class GrammarSearchUtils {
  /// 匹配汉字的正则表达式（包含扩展区和々）
  static final RegExp _rubiPattern = RegExp(r'([\u4E00-\u9FFF\u3400-\u4DBF々]+)\[([^\]]+)\]');

  /// 罗马字转假名映射表 (Basic mapping for Fuzzy Search)
  static const Map<String, String> _romajiMap = {
    'ky': 'きょ', 'sh': 'し', 'ch': 'ち', 'ts': 'つ', 'ny': 'にょ',
    'hy': 'ひょ', 'my': 'みょ', 'ry': 'りょ', 'gy': 'ぎょ', 'by': 'びょ',
    'py': 'ぴょ', 'ja': 'じゃ', 'ju': 'じゅ', 'jo': 'じょ', 'ba': 'ば',
    'bi': 'び', 'bu': 'ぶ', 'be': 'べ', 'bo': 'ぼ', 'pa': 'ぱ',
    'pi': 'ぴ', 'pu': 'ぷ', 'pe': 'ぺ', 'po': 'ぽ', 'ga': '将',
    'gi': 'ぎ', 'gu': 'ぐ', 'ge': 'げ', 'go': 'ご', 'za': 'ざ',
    'zi': 'じ', 'zu': 'ず', 'ze': 'ぜ', 'zo': 'ぞ', 'da': 'だ',
    'di': 'ぢ', 'du': 'づ', 'de': 'で', 'do': 'ど', 'sa': 'さ',
    'si': 'し', 'su': 'す', 'se': 'せ', 'so': 'そ', 'ta': 'た',
    'ti': 'ち', 'tu': 'つ', 'te': 'て', 'to': 'と', 'na': 'な',
    'ni': 'に', 'nu': 'ぬ', 'ne': 'ね', 'no': 'の', 'ha': 'は',
    'hi': 'ひ', 'fu': 'ふ', 'he': 'へ', 'ho': 'ほ', 'ma': 'ま',
    'mi': 'み', 'mu': 'む', 'me': 'め', 'mo': 'も', 'ya': 'や',
    'yu': 'ゆ', 'yo': 'よ', 'ra': 'ら', 'ri': 'り', 'ru': 'る',
    're': 'れ', 'ro': 'ろ', 'wa': 'わ', 'wo': 'を', 'nn': 'ん',
    'ka': 'か', 'ki': 'き', 'ku': 'く', 'ke': 'け', 'ko': 'こ',
    'a': 'あ', 'i': 'い', 'u': 'う', 'e': 'え', 'o': 'お',
  };

  /// 简单的罗马字转假名 (Used for Fuzzy Search)
  static String _toKana(String romaji) {
    String result = romaji.toLowerCase();
    // Sort keys by length (descending) to match long patterns first (e.g. 'ky' before 'k')
    final sortedKeys = _romajiMap.keys.toList()..sort((a, b) => b.length.compareTo(a.length));
    
    for (final key in sortedKeys) {
      result = result.replaceAll(key, _romajiMap[key]!);
    }
    return result;
  }

  /// 去除注音，保留原始汉字/文本
  /// 例如："去[きょ]年[ねん]" -> "去年"
  static String cleanRubi(String text) {
    return text.replaceAllMapped(_rubiPattern, (match) => match.group(1)!);
  }

  /// 提取注音，将汉字替换为对应的假名
  /// 例如："去[きょ]年[ねん]" -> "きょねん"
  static String extractKana(String text) {
    return text.replaceAllMapped(_rubiPattern, (match) => match.group(2)!);
  }

  /// 增强匹配逻辑
  static bool isMatch(String text, String query) {
    if (query.isEmpty) return true;
    
    final lowerQuery = query.toLowerCase();
    
    // 1. 检查纯化后的文本（最常用，如搜索 "去年"）
    if (cleanRubi(text).toLowerCase().contains(lowerQuery)) return true;
    
    // 2. 检查提取假名后的文本（搜索 "きょねん"）
    final kanaText = extractKana(text).toLowerCase();
    if (kanaText.contains(lowerQuery)) return true;
    
    // 3. 罗马字扩展匹配 (Fuzzy Romaji Match)
    final romajiAsKana = _toKana(lowerQuery);
    if (romajiAsKana != lowerQuery) {
       if (kanaText.contains(romajiAsKana)) return true;
       if (cleanRubi(text).toLowerCase().contains(romajiAsKana)) return true;
    }
    
    // 4. 检查原始文本
    if (text.toLowerCase().contains(lowerQuery)) return true;
    
    return false;
  }

  /// 深度匹配逻辑（匹配语法标题、含义、接续、笔记及所有例句）
  static bool isMatchDetailed(Grammar grammar, String query) {
    if (query.isEmpty) return true;
    final lowerQuery = query.toLowerCase();

    // 1. 匹配语法标题
    if (isMatch(grammar.grammar, query)) return true;

    // 2. 匹配用法详情 (解释、接续、笔记) 和 例句
    for (var usage in grammar.usages) {
      if (isMatch(usage.explanation, query)) return true;
      if (isMatch(usage.connection, query)) return true;
      if (usage.notes?.toLowerCase().contains(lowerQuery) ?? false) return true;

      // 3. 匹配例句 (文本、翻译)
      for (var example in usage.examples) {
        if (isMatch(example.sentence, query)) return true;
        if (example.translation.toLowerCase().contains(lowerQuery)) return true;
      }
    }

    return false;
  }
}
