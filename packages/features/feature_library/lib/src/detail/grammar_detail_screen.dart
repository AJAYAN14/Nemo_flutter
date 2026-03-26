import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'grammar_detail_notifier.dart';

class GrammarDetailScreen extends ConsumerStatefulWidget {
  const GrammarDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<GrammarDetailScreen> createState() => _GrammarDetailScreenState();
}

class _GrammarDetailScreenState extends ConsumerState<GrammarDetailScreen> {
  late PageController _pageController;
  List<int> _contextIds = [];
  bool _isLoadingContext = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadContext();
  }

  Future<void> _loadContext() async {
    try {
      // Ensure the initial grammar is loaded first to get its level
      final grammar = await ref.read(grammarDetailProvider(widget.id).future);
      if (grammar == null) {
        if (mounted) setState(() => _isLoadingContext = false);
        return;
      }

      final notifier = ref.read(grammarDetailProvider(widget.id).notifier);
      final ids = await notifier.getContextIds();
      
      if (mounted) {
        setState(() {
          _contextIds = ids;
          _isLoadingContext = false;
          
          // Find initial index
          final initialIndex = ids.indexOf(widget.id);
          if (initialIndex != -1) {
            _pageController = PageController(initialPage: initialIndex);
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingContext = false);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingContext) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_contextIds.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No grammars found')),
      );
    }

    return Scaffold(
      backgroundColor: NemoColors.surfaceSoft,
      body: PageView.builder(
        controller: _pageController,
        itemCount: _contextIds.length,
        itemBuilder: (context, index) {
          final id = _contextIds[index];
          return _GrammarDetailContent(id: id);
        },
      ),
    );
  }
}

class _GrammarDetailContent extends ConsumerWidget {
  const _GrammarDetailContent({required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grammarState = ref.watch(grammarDetailProvider(id));

    return grammarState.when(
      data: (grammar) {
        if (grammar == null) return const Center(child: Text('Not found'));
        return _buildScrollableContent(context, ref, grammar);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildScrollableContent(BuildContext context, WidgetRef ref, Grammar grammar) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(grammar: grammar),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: grammar.usages.asMap().entries.map((entry) {
                    return _UsageCard(
                      usage: entry.value,
                      usageIndex: entry.key,
                      grammarId: id,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        // Custom Back Button (Transparent Header Layer)
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 4,
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 22),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.grammar});
  final Grammar grammar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary.withOpacity(0.8),
            theme.colorScheme.primary.withOpacity(0.1),
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, topPadding + 64, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: NemoFuriganaText(
                  text: grammar.grammar,
                  baseTextStyle: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                  furiganaTextColor: theme.colorScheme.primary.withOpacity(0.5),
                  furiganaTextSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Consumer(builder: (context, ref, child) {
                final notifier = ref.watch(grammarDetailProvider(grammar.id).notifier);
                final isPlaying = notifier.playingId == "header_${grammar.id}";
                
                return NemoSpeakerButton(
                  isPlaying: isPlaying,
                  size: 56,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  tint: theme.colorScheme.primary,
                  onClick: () => notifier.playAudio(grammar.grammar, "header_${grammar.id}"),
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: Text(
              grammar.grammarLevel,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UsageCard extends StatelessWidget {
  const _UsageCard({
    required this.usage,
    required this.usageIndex,
    required this.grammarId,
  });

  final GrammarUsage usage;
  final int usageIndex;
  final int grammarId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumCard(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Explanation
          _SectionTitle(
            title: '意味 (意思)',
            icon: Icons.menu_book_rounded,
            color: NemoColors.brandBlue,
          ),
          const SizedBox(height: 12),
          NemoFuriganaText(
            text: usage.explanation,
            baseTextStyle: const TextStyle(
              fontSize: 17,
              height: 26 / 17, // 1.53x line height
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
            furiganaTextColor: theme.colorScheme.primary.withOpacity(0.5),
            furiganaTextSize: 10,
          ),
          
          const SizedBox(height: 24),
          
          // Connection
          _SectionTitle(
            title: '接続 (接续)',
            icon: Icons.link_rounded,
            color: NemoColors.accentOrange,
          ),
          const SizedBox(height: 12),
          _ConnectionPill(text: usage.connection),
          
          if (usage.notes != null) ...[
            const SizedBox(height: 24),
            // Notes
            _SectionTitle(
              title: '注意',
              icon: Icons.warning_amber_rounded,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            NemoFuriganaText(
              text: usage.notes!,
              baseTextStyle: TextStyle(
                fontSize: 15,
                color: const Color(0xFF334155).withOpacity(0.9),
                height: 1.5,
              ),
              furiganaTextColor: theme.colorScheme.primary.withOpacity(0.4),
              furiganaTextSize: 9,
            ),
          ],
          
          const SizedBox(height: 24),
          
          // Examples
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: usage.examples.asMap().entries.map((entry) {
                final isLast = entry.key == usage.examples.length - 1;
                return _ExampleItem(
                  example: entry.value,
                  index: entry.key,
                  usageIndex: usageIndex,
                  grammarId: grammarId,
                  showDivider: !isLast,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ConnectionPill extends StatelessWidget {
  const _ConnectionPill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
          width: 0.5,
        ),
      ),
      child: NemoFuriganaText(
        text: text,
        baseTextStyle: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
        furiganaTextSize: 9,
        furiganaTextColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
    );
  }
}

class _ExampleItem extends StatelessWidget {
  const _ExampleItem({
    required this.example,
    required this.index,
    required this.usageIndex,
    required this.grammarId,
    required this.showDivider,
  });

  final GrammarExample example;
  final int index;
  final int usageIndex;
  final int grammarId;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NemoFuriganaText(
                      text: example.sentence,
                      baseTextStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                        color: Color(0xFF334155),
                      ),
                      furiganaTextSize: 9,
                      furiganaTextColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      example.translation,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: NemoColors.textSub,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Consumer(builder: (context, ref, child) {
                final audioId = 'grammar_${grammarId}_u${usageIndex}_e$index';
                final notifier = ref.watch(grammarDetailProvider(grammarId).notifier);
                final isPlaying = notifier.playingId == audioId;

                return NemoSpeakerButton(
                  isPlaying: isPlaying,
                  size: 44,
                  onClick: () => notifier.playAudio(example.sentence, audioId),
                );
              }),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.2),
          ),
      ],
    );
  }
}
