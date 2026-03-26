import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'kana_data.dart';

class KanaChartScreen extends StatefulWidget {
  const KanaChartScreen({super.key});

  @override
  State<KanaChartScreen> createState() => _KanaChartScreenState();
}

class _KanaChartScreenState extends State<KanaChartScreen> with TickerProviderStateMixin {
  int _currentType = 0; // 0: Hiragana, 1: Katakana
  final ScrollController _scrollController = ScrollController();
  final ScrollController _quickNavScrollController = ScrollController();

  // GlobalKeys for scrolling to sections
  final Map<String, GlobalKey> _sectionKeys = {
    'seion': GlobalKey(),
    'dakuon': GlobalKey(),
    'yoon': GlobalKey(),
    'sokuon': GlobalKey(),
    'chouon': GlobalKey(),
  };

  String _activeSection = 'seion';
  String? _flashingSection;
  String? _playingAudioId;
  bool _isQuickNavScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onMainScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onMainScroll);
    _scrollController.dispose();
    _quickNavScrollController.dispose();
    super.dispose();
  }

  void _onMainScroll() {
    if (_isQuickNavScrolling) return;

    // Detect active section based on scroll position
    String detectedSection = _activeSection;
    double minDistance = double.infinity;

    _sectionKeys.forEach((id, key) {
      final context = key.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero).dy;
        // We look for the section closest to the top of the viewport (offset by header height)
        const threshold = 200.0;
        if (position < threshold && position > -threshold) {
          final distance = (position - 150).abs();
          if (distance < minDistance) {
            minDistance = distance;
            detectedSection = id;
          }
        }
      }
    });

    if (detectedSection != _activeSection) {
      setState(() => _activeSection = detectedSection);
    }
  }

  Future<void> _scrollToSection(String section) async {
    if (_isQuickNavScrolling) return;
    _isQuickNavScrolling = true;

    setState(() {
      _activeSection = section;
      _flashingSection = section;
    });

    final key = _sectionKeys[section];
    if (key?.currentContext != null) {
      HapticFeedback.selectionClick();

      await Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );

      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) setState(() => _flashingSection = null);
    }
    _isQuickNavScrolling = false;
  }

  void _playKana(KanaCell cell) {
    setState(() => _playingAudioId = cell.romaji + _currentType.toString());
    HapticFeedback.lightImpact();

    // Mock play duration
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _playingAudioId = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isKatakana = _currentType == 1;

    return Scaffold(
      backgroundColor: NemoColors.bgBase,
      body: Column(
        children: [
          _buildHeader(context, mediaQuery.padding.top),
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTypeToggle(),
                        const SizedBox(height: 16),
                        _buildQuickNav(),
                      ],
                    ),
                  ),
                ),
                ..._buildSection(
                  sectionId: 'seion',
                  title: '清音 (Seion)',
                  data: seionData,
                  columns: 5,
                  isKatakana: isKatakana,
                ),
                ..._buildSection(
                  sectionId: 'dakuon',
                  title: '浊音 / 半浊音 (Dakuon)',
                  subtitle: '在假名右上角添加符号改变发音',
                  data: dakuonData,
                  columns: 5,
                  isKatakana: isKatakana,
                ),
                ..._buildSection(
                  sectionId: 'yoon',
                  title: '拗音 (Yōon)',
                  subtitle: '由辅音与字母 “ゃ、ゅ、ょ” 组合而成',
                  data: yoonData,
                  columns: 3,
                  isKatakana: isKatakana,
                ),
                ..._buildSection(
                  sectionId: 'sokuon',
                  title: isKatakana ? '促音 (Katakana Sokuon)' : '促音 (Hiragana Sokuon)',
                  subtitle: '表示短促停顿的特殊发音',
                  data: sokuonData,
                  columns: 4,
                  isKatakana: isKatakana,
                ),
                ..._buildSection(
                  sectionId: 'chouon',
                  title: '长音 (Chōon)',
                  subtitle: '延长元音长度的发音',
                  data: chouonData,
                  columns: 5,
                  isKatakana: isKatakana,
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 40 + mediaQuery.padding.bottom),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double topPadding) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, topPadding + 8, 8, 8),
      color: NemoColors.bgBase,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const Text(
            '五十音图',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: NemoColors.textMain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.85), width: 1),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: _currentType == 0 ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              _buildToggleItem(0, '平假名'),
              _buildToggleItem(1, '片假名'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(int type, String label) {
    final selected = _currentType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_currentType != type) {
            setState(() => _currentType = type);
            HapticFeedback.selectionClick();
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: selected ? NemoColors.textMain : NemoColors.textSub,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickNav() {
    return SingleChildScrollView(
      controller: _quickNavScrollController,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildNavChip('seion', '清音'),
          const SizedBox(width: 8),
          _buildNavChip('dakuon', '浊音'),
          const SizedBox(width: 8),
          _buildNavChip('yoon', '拗音'),
          const SizedBox(width: 8),
          _buildNavChip('sokuon', '促音'),
          const SizedBox(width: 8),
          _buildNavChip('chouon', '长音'),
        ],
      ),
    );
  }

  Widget _buildNavChip(String section, String label) {
    final active = _activeSection == section;
    return GestureDetector(
      onTap: () => _scrollToSection(section),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFD7F1FF) : const Color(0xFFF3FAFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? NemoColors.brandBlue.withOpacity(0.32) : const Color(0xFFDCEEFF),
          ),
          boxShadow: active ? null : [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 2,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: active ? NemoColors.brandBlue : NemoColors.textMain.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSection({
    required String sectionId,
    required String title,
    String? subtitle,
    required List<KanaCell?> data,
    required int columns,
    required bool isKatakana,
  }) {
    final isFlashing = _flashingSection == sectionId;

    final List<List<KanaCell?>> rows = [];
    for (var i = 0; i < data.length; i += columns) {
      final end = (i + columns < data.length) ? i + columns : data.length;
      rows.add(data.sublist(i, end));
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        sliver: SliverToBoxAdapter(
          child: Column(
            key: _sectionKeys[sectionId],
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isFlashing ? const Color(0xFF0EA5A8).withOpacity(0.75) : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0EA5A8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: NemoColors.textMain,
                      ),
                    ),
                  ],
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: NemoColors.textSub.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Column(
                children: rows.map((row) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (var i = 0; i < columns; i++)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: i == columns - 1 ? 0 : 10,
                              ),
                              child: i < row.length
                                  ? _buildCard(row[i], isKatakana)
                                  : const SizedBox.shrink(),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildCard(KanaCell? cell, bool isKatakana) {
    if (cell == null || (isKatakana && cell.katakana == null)) {
      return const SizedBox.shrink();
    }
    final cardId = cell.romaji + _currentType.toString();
    return _KanaCard(
      cell: cell,
      isKatakana: isKatakana,
      isPlaying: _playingAudioId == cardId,
      onTap: () => _playKana(cell),
    );
  }
}

class _KanaCard extends StatefulWidget {
  const _KanaCard({
    required this.cell,
    required this.isKatakana,
    required this.isPlaying,
    required this.onTap,
  });

  final KanaCell cell;
  final bool isKatakana;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  State<_KanaCard> createState() => _KanaCardState();
}

class _KanaCardState extends State<_KanaCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInQuad),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kanaText = widget.cell.getKana(widget.isKatakana);
    final isLong = kanaText.length > 2;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: widget.isPlaying
                  ? NemoColors.brandBlue.withOpacity(0.78)
                  : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Wrap content height
              children: [
                Text(
                  kanaText,
                  style: TextStyle(
                    fontSize: isLong ? 18 : 24,
                    fontWeight: FontWeight.bold,
                    color: NemoColors.textMain,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.cell.romaji,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: NemoColors.textSub,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
