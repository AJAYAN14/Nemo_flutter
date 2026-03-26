class LibraryMockData {
  const LibraryMockData({
    required this.level,
    required this.title,
    required this.desc,
    required this.progress,
    required this.totalWords,
    required this.learnedWords,
    required this.color,
  });

  final String level;
  final String title;
  final String desc;
  final double progress;
  final int totalWords;
  final int learnedWords;
  final int color;
}

const mockLibraryLevels = [
  LibraryMockData(
    level: 'N5',
    title: '基础词汇与语法',
    desc: '日本语能力测试 N5 核心词库',
    progress: 0.85,
    totalWords: 800,
    learnedWords: 680,
    color: 0xFF10B981, // Emerald
  ),
  LibraryMockData(
    level: 'N4',
    title: '初级进阶词汇',
    desc: '日本语能力测试 N4 必备基础',
    progress: 0.45,
    totalWords: 1200,
    learnedWords: 540,
    color: 0xFF0EA5E9, // Sky Blue
  ),
  LibraryMockData(
    level: 'N3',
    title: '中级核心词汇',
    desc: '日本语能力测试 N3 跃升词库',
    progress: 0.12,
    totalWords: 2000,
    learnedWords: 240,
    color: 0xFF8B5CF6, // Violet
  ),
  LibraryMockData(
    level: 'N2',
    title: '高级实用词汇',
    desc: '日本语能力测试 N2 核心突破',
    progress: 0.0,
    totalWords: 2500,
    learnedWords: 0,
    color: 0xFFF59E0B, // Amber
  ),
  LibraryMockData(
    level: 'N1',
    title: '终极挑战词汇',
    desc: '日本语能力测试 N1 巅峰冲刺',
    progress: 0.0,
    totalWords: 3000,
    learnedWords: 0,
    color: 0xFFEF4444, // Red
  ),
];
