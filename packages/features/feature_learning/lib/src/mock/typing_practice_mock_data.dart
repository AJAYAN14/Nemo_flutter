class TypingPracticePrompt {
  const TypingPracticePrompt({
    required this.japanese,
    required this.hiragana,
  });

  final String japanese;
  final String hiragana;
}

const typingPracticeMockPrompt = TypingPracticePrompt(
  japanese: '継続',
  hiragana: 'けいぞく',
);
