import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'word_detail_notifier.dart';

class WordDetailScreen extends HookConsumerWidget {
  const WordDetailScreen({super.key, required this.wordId});

  final String wordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wordDetailProvider(wordId));
    final notifier = ref.read(wordDetailProvider(wordId).notifier);

    if (state.isLoading || state.currentWord == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final contextIds = state.contextIds;
    final initialIndex = contextIds.indexOf(wordId);
    final pageController = usePageController(initialPage: initialIndex >= 0 ? initialIndex : 0);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: PageView.builder(
        controller: pageController,
        itemCount: contextIds.length,
        itemBuilder: (context, index) {
          final currentId = contextIds[index];
          // We can use another provider or just fetch from notifier if it's sync mock logic
          final word = (currentId == wordId) ? state.currentWord : notifier.getWordById(currentId);
          
          if (word == null) return const Center(child: CircularProgressIndicator());
          
          return _WordDetailContent(
            word: word,
            playingAudioId: state.playingAudioId,
            onPlayAudio: notifier.playAudio,
            onBack: () => Navigator.of(context).pop(),
          );
        },
      ),
    );
  }
}

class _WordDetailContent extends StatelessWidget {
  const _WordDetailContent({
    required this.word,
    required this.playingAudioId,
    required this.onPlayAudio,
    required this.onBack,
  });

  final Word word;
  final String? playingAudioId;
  final Function(String, String) onPlayAudio;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      child: Column(
        children: [
          // === 1. Immersive Hero Section ===
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 56,
                  bottom: 32,
                  left: 24,
                  right: 24,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                      Theme.of(context).colorScheme.background,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Kanji
                    Text(
                      word.japanese,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(height: 8),
                    // Hiragana
                    Text(
                      word.hiragana,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                          ),
                    ),
                    const SizedBox(height: 24),
                    // Speaker Button
                    NemoSpeakerButton(
                      isPlaying: playingAudioId == 'word_${word.id}',
                      size: 56,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      tint: Theme.of(context).colorScheme.onPrimaryContainer,
                      onClick: () => onPlayAudio(word.japanese, 'word_${word.id}'),
                    ),
                  ],
                ),
              ),
              // Back Button Overlay
              Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: onBack,
                ),
              ),
            ],
          ),

          // === 2. Meaning & Tags ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '中文释义',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        word.chinese,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      // Tags Row
                      Row(
                        children: [
                          _DetailTag(
                            text: word.level,
                            backgroundColor: NemoColors.brandBlue,
                            textColor: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          if (word.pos != null)
                            _DetailTag(
                              text: word.pos!,
                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                              textColor: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // === 3. Example Sentences ===
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 12),
                  child: Text(
                    '例句',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                if (word.examples.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      '暂无例句',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  )
                else
                  ...word.examples.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final example = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ExampleCard(
                        index: index,
                        example: example,
                        isPlaying: playingAudioId == 'example_${word.id}_$index',
                        onPlay: () => onPlayAudio(example.japanese, 'example_${word.id}_$index'),
                      ),
                    );
                  }),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Removed _HeroSpeakerButton since we use NemoSpeakerButton

class _DetailTag extends StatelessWidget {
  const _DetailTag({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.index,
    required this.example,
    required this.isPlaying,
    required this.onPlay,
  });

  final int index;
  final WordExample example;
  final bool isPlaying;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Index Number
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '$index.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NemoFuriganaText(
                  text: example.japanese,
                  baseTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 17,
                        height: 1.5,
                      ),
                  furiganaTextColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  furiganaTextSize: 10,
                ),
                const SizedBox(height: 8),
                Text(
                  example.chinese,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Speaker Button
          NemoSpeakerButton(
            isPlaying: isPlaying,
            size: 44,
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            onClick: onPlay,
          ),
        ],
      ),
    );
  }
}

// Removed _ExampleSpeakerButton
