enum LearningMode {
  words,
  grammar,
}

class HomeMockStats {
  const HomeMockStats({
    required this.learned,
    required this.goal,
    required this.reviewed,
    required this.reviewDue,
    required this.accuracy,
    required this.levelLabel,
    required this.highlightColor,
  });

  final int learned;
  final int goal;
  final int reviewed;
  final int reviewDue;
  final int accuracy;
  final String levelLabel;
  final int highlightColor;
}

const homeMockStats = <LearningMode, HomeMockStats>{
  LearningMode.words: HomeMockStats(
    learned: 48,
    goal: 60,
    reviewed: 42,
    reviewDue: 18,
    accuracy: 89,
    levelLabel: 'N2',
    highlightColor: 0xFFF97316,
  ),
  LearningMode.grammar: HomeMockStats(
    learned: 24,
    goal: 30,
    reviewed: 27,
    reviewDue: 10,
    accuracy: 84,
    levelLabel: 'N3',
    highlightColor: 0xFF059669,
  ),
};
