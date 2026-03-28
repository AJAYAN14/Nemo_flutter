import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_domain/core_domain.dart';
import 'components/test_settings_components.dart';
import 'components/test_settings_bottom_sheet.dart';
import 'components/test_settings_dialogs.dart';
import '../routes/test_routes.dart';
import 'test_settings_provider.dart';
import 'test_notifier.dart';

class TestSettingsScreen extends HookConsumerWidget {
  final String? testModeId;

  const TestSettingsScreen({
    super.key,
    this.testModeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(testSettingsProvider);
    final config = state.config;
    final notifier = ref.read(testSettingsProvider.notifier);

    // Initial restriction enforcement
    useEffect(() {
      Future.microtask(() => notifier.initMode(testModeId));
      return null;
    }, [testModeId]);

    // Snackbar listeners for errors and messages
    ref.listen(testSettingsProvider.select((s) => s.error), (previous, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next)));
        notifier.clearError();
      }
    });

    ref.listen(testSettingsProvider.select((s) => s.messages), (previous, next) {
      if (next.isNotEmpty) {
        for (final msg in next) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg.message),
              action: msg.actionLabel != null ? SnackBarAction(label: msg.actionLabel!, onPressed: msg.onAction ?? () {}) : null,
            ),
          );
          notifier.dismissMessage(msg.id);
        }
      }
    });

    final pageTitle = useMemoized(() => _getPageTitle(testModeId), [testModeId]);

    // Dialog state
    final showCustomQuestionCountDialog = useState(false);
    final showCustomTimeLimitDialog = useState(false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(pageTitle, style: const TextStyle(fontWeight: FontWeight.w900)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const SectionTitle("基础设置"),
                _BasicSettingsSection(
                  state: state, 
                  testModeId: testModeId, 
                  showCustomQuestionCountDialog: showCustomQuestionCountDialog, 
                  showCustomTimeLimitDialog: showCustomTimeLimitDialog
                ),

                const SizedBox(height: 24),
                const SectionTitle("答题设置"),
                _QuizSettingsSection(state: state),
                
                const SizedBox(height: 140),
              ],
            ),
          ),
          
          _StartTestButton(state: state, testModeId: testModeId),

          // Dialogs
          CustomQuestionCountDialog(
            show: showCustomQuestionCountDialog.value,
            initialValue: config.questionCount,
            onDismiss: () => showCustomQuestionCountDialog.value = false,
            onConfirm: (count) {
              notifier.update(config.copyWith(questionCount: count));
            },
          ),
          CustomTimeLimitDialog(
            show: showCustomTimeLimitDialog.value,
            initialValue: config.timeLimitMinutes,
            onDismiss: () => showCustomTimeLimitDialog.value = false,
            onConfirm: (minutes) {
              notifier.update(config.copyWith(timeLimitMinutes: minutes));
            },
          ),
        ],
      ),
    );
  }
}

class _BasicSettingsSection extends ConsumerWidget {
  final TestSettingsUiState state;
  final String? testModeId;
  final ValueNotifier<bool> showCustomQuestionCountDialog;
  final ValueNotifier<bool> showCustomTimeLimitDialog;

  const _BasicSettingsSection({
    required this.state,
    this.testModeId,
    required this.showCustomQuestionCountDialog,
    required this.showCustomTimeLimitDialog,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = state.config;
    return PremiumGroupCard(
      children: [
        PremiumSettingRow(
          label: "题目数量",
          value: "${config.questionCount} 题",
          onClick: () => _showBottomSheet(context, "question_count", testModeId, showCustomQuestionCountDialog, showCustomTimeLimitDialog),
        ),
        _DataOverviewRow(state: state, testModeId: testModeId),
        PremiumSettingRow(
          label: "时间限制",
          value: config.timeLimitMinutes == 0 ? "无限制" : "${config.timeLimitMinutes} 分钟",
          onClick: () => _showBottomSheet(context, "time_limit", testModeId, showCustomQuestionCountDialog, showCustomTimeLimitDialog),
        ),
        PremiumSettingRow(
          label: "题目来源",
          value: config.questionSource.label,
          onClick: () => _showBottomSheet(context, "question_source", testModeId, showCustomQuestionCountDialog, showCustomTimeLimitDialog),
        ),
        PremiumSettingRow(
          label: "错题移除",
          value: _getWrongAnswerRemovalLabel(config.wrongAnswerRemovalThreshold),
          onClick: () => _showBottomSheet(context, "wrong_answer_removal", testModeId, showCustomQuestionCountDialog, showCustomTimeLimitDialog),
        ),
        if (testModeId == 'multiple_choice' || testModeId == 'comprehensive')
          PremiumSettingRow(
            label: "测试内容",
            value: config.testContentType.label,
            onClick: () => _showBottomSheet(context, "content_type", testModeId, showCustomQuestionCountDialog, showCustomTimeLimitDialog),
          ),
        if (testModeId == 'comprehensive')
          PremiumSettingRow(
            label: "题型分布",
            value: _getComprehensiveSummary(config.comprehensiveQuestionCounts),
            onClick: () => _showBottomSheet(context, "question_distribution", testModeId, showCustomQuestionCountDialog, showCustomTimeLimitDialog),
          ),

        // 8. 等级选择 (Merged)
        if (testModeId == 'typing' || testModeId == 'card_matching' || testModeId == 'sorting' || config.testContentType != TestContentType.mixed)
          PremiumSettingRow(
            label: _getLevelLabel(testModeId, config.testContentType),
            value: _formatLevels(config.testContentType == TestContentType.grammar ? config.selectedGrammarLevels : config.selectedWordLevels),
            onClick: () => _showBottomSheet(context, config.testContentType == TestContentType.grammar ? "grammar_levels" : "word_levels", testModeId, showCustomQuestionCountDialog, showCustomTimeLimitDialog),
          )
        else ...[
          PremiumSettingRow(
            label: "单词等级",
            value: _formatLevels(config.selectedWordLevels),
            onClick: () => _showBottomSheet(context, "word_levels", testModeId, showCustomQuestionCountDialog, showCustomTimeLimitDialog),
          ),
          PremiumSettingRow(
            label: "语法等级",
            value: _formatLevels(config.selectedGrammarLevels),
            onClick: () => _showBottomSheet(context, "grammar_levels", testModeId, showCustomQuestionCountDialog, showCustomTimeLimitDialog),
          ),
        ],
      ],
    );
  }
}


class _QuizSettingsSection extends ConsumerWidget {
  final TestSettingsUiState state;

  const _QuizSettingsSection({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = state.config;
    final notifier = ref.read(testSettingsProvider.notifier);
    
    return PremiumGroupCard(
      children: [
        PremiumSwitchRow(
          label: "题目乱序",
          checked: config.shuffleQuestions,
          onCheckedChange: (val) => notifier.update(config.copyWith(shuffleQuestions: val)),
        ),
        PremiumSwitchRow(
          label: "选项乱序",
          checked: config.shuffleOptions,
          onCheckedChange: (val) => notifier.update(config.copyWith(shuffleOptions: val)),
        ),
        PremiumSwitchRow(
          label: "自动跳转",
          checked: config.autoAdvance,
          onCheckedChange: (val) => notifier.update(config.copyWith(autoAdvance: val)),
        ),
        PremiumSwitchRow(
          label: "错题优先",
          checked: config.prioritizeWrong,
          onCheckedChange: (val) => notifier.update(config.copyWith(prioritizeWrong: val, prioritizeNew: val ? false : config.prioritizeNew)),
        ),
        PremiumSwitchRow(
          label: "未做题优先",
          checked: config.prioritizeNew,
          onCheckedChange: (val) => notifier.update(config.copyWith(prioritizeNew: val, prioritizeWrong: val ? false : config.prioritizeWrong)),
        ),
      ],
    );
  }
}

class _DataOverviewRow extends StatelessWidget {
  final TestSettingsUiState state;
  final String? testModeId;
  const _DataOverviewRow({required this.state, this.testModeId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = state.config;
    
    final effectiveType = (testModeId == 'typing' || testModeId == 'card_matching') ? TestContentType.words : config.testContentType;
    
    final (wordCount, grammarCount) = state.availableDataCount ?? (0, 0);
    
    String dataCountText = "";
    bool isInsufficient = false;

    switch (effectiveType) {
      case TestContentType.words:
        dataCountText = "可用: ${wordCount >= 1000 ? "1000+" : "$wordCount"} 词";
        isInsufficient = wordCount < config.questionCount;
        break;
      case TestContentType.grammar:
        dataCountText = "可用: ${grammarCount >= 1000 ? "1000+" : "$grammarCount"} 语法";
        isInsufficient = grammarCount < config.questionCount;
        break;
      case TestContentType.mixed:
        dataCountText = "可用: ${wordCount >= 1000 ? "1000+" : "$wordCount"} 词 / ${grammarCount >= 1000 ? "1000+" : "$grammarCount"} 语法";
        isInsufficient = (wordCount + grammarCount) < config.questionCount;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "数据概况",
            style: theme.textTheme.bodyLarge,
          ),
          Text(
            state.isLoadingDataCount ? "查询中..." : (isInsufficient ? "$dataCountText (不足)" : dataCountText),
            style: theme.textTheme.bodyMedium?.copyWith(
                  color: (!state.isLoadingDataCount && isInsufficient) ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _SettingsBottomSheetContent extends ConsumerWidget {
  final String settingType;
  final String? testModeId;
  final VoidCallback onShowCountDialog;
  final VoidCallback onShowTimeDialog;

  const _SettingsBottomSheetContent({
    required this.settingType, 
    this.testModeId, 
    required this.onShowCountDialog,
    required this.onShowTimeDialog,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(testSettingsProvider);
    final config = state.config;
    final notifier = ref.read(testSettingsProvider.notifier);

    String title = "";
    Widget content = const SizedBox();

    switch (settingType) {
      case "question_count":
        title = "选择题目数量";
        content = Column(
          children: [
            _buildChipGrid([10, 15, 20, 25, 30, 40], (val) => "$val 题", config.questionCount, (val) {
              notifier.update(config.copyWith(questionCount: val));
              Navigator.pop(context);
            }),
            const SizedBox(height: 12),
            PremiumCustomChip(onClick: () {
              Navigator.pop(context);
              onShowCountDialog();
            }),
          ],
        );
        break;
      case "time_limit":
        title = "选择时间限制";
        content = Column(
          children: [
            _buildChipGrid([0, 5, 10, 15, 30], (val) => val == 0 ? "无限制" : "$val 分钟", config.timeLimitMinutes, (val) {
              notifier.update(config.copyWith(timeLimitMinutes: val));
              Navigator.pop(context);
            }),
            const SizedBox(height: 12),
            PremiumCustomChip(onClick: () {
              Navigator.pop(context);
              onShowTimeDialog();
            }),
          ],
        );
        break;
      case "question_source":
        title = "选择题目来源";
        content = Column(
          children: QuestionSource.values.map((val) {
            String label = val.label;
            if (val == QuestionSource.today) {
              label = "今日学习的内容 (${state.todayLearnedCount}词 / ${state.todayLearnedGrammarCount}语法)";
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PremiumSelectorChip(
                text: label,
                selected: val == config.questionSource,
                onPressed: () {
                  notifier.update(config.copyWith(questionSource: val));
                  Navigator.pop(context);
                },
              ),
            );
          }).toList(),
        );
        break;
      case "wrong_answer_removal":
        title = "答对几次后从错题中移除";
        content = _buildChipGrid([0, 3, 5, 7, 10], (val) => val == 0 ? "不移除" : "${val}次", config.wrongAnswerRemovalThreshold, (val) {
          notifier.update(config.copyWith(wrongAnswerRemovalThreshold: val));
          Navigator.pop(context);
        });
        break;
      case "content_type":
        title = "选择测试内容类型";
        final sources = _getContentTypeOptions(testModeId);
        content = Column(
          children: sources.map((val) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PremiumSelectorChip(
              text: val.label,
              selected: val == config.testContentType,
              onPressed: () {
                notifier.update(config.copyWith(testContentType: val));
                Navigator.pop(context);
              },
            ),
          )).toList(),
        );
        break;
      case "question_distribution":
        title = "题型分布";
        final counts = config.comprehensiveQuestionCounts;
        final total = counts.values.fold<int>(0, (a, b) => a + b);
        content = Column(
          children: [
             Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "总计: $total 题",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _DistributionCounterRow(
              label: "选择题",
              count: counts['multiple_choice'] ?? 0,
              onChanged: (val) {
                final newCounts = Map<String, int>.from(counts)..['multiple_choice'] = val;
                notifier.update(config.copyWith(
                  comprehensiveQuestionCounts: newCounts,
                  questionCount: newCounts.values.fold<int>(0, (a, b) => a + b),
                ));
              },
            ),
            _DistributionCounterRow(
              label: "手打题",
              count: counts['typing'] ?? 0,
              onChanged: (val) {
                final newCounts = Map<String, int>.from(counts)..['typing'] = val;
                notifier.update(config.copyWith(
                  comprehensiveQuestionCounts: newCounts,
                  questionCount: newCounts.values.fold<int>(0, (a, b) => a + b),
                ));
              },
            ),
            _DistributionCounterRow(
              label: "卡片题",
              count: counts['card_matching'] ?? 0,
              onChanged: (val) {
                final newCounts = Map<String, int>.from(counts)..['card_matching'] = val;
                notifier.update(config.copyWith(
                  comprehensiveQuestionCounts: newCounts,
                  questionCount: newCounts.values.fold<int>(0, (a, b) => a + b),
                ));
              },
            ),
            _DistributionCounterRow(
              label: "排序题",
              count: counts['sorting'] ?? 0,
              onChanged: (val) {
                final newCounts = Map<String, int>.from(counts)..['sorting'] = val;
                notifier.update(config.copyWith(
                  comprehensiveQuestionCounts: newCounts,
                  questionCount: newCounts.values.fold<int>(0, (a, b) => a + b),
                ));
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: NemoColors.brandBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("确定", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
        break;
      case "word_levels":
      case "grammar_levels":
        final isGrammar = settingType == "grammar_levels";
        title = isGrammar ? "选择语法等级" : "选择单词等级";
        final selected = isGrammar ? config.selectedGrammarLevels : config.selectedWordLevels;
        content = Column(
          children: [
             GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                PremiumLevelChip(
                  level: "全部等级",
                  count: isGrammar ? state.todayLearnedGrammarCount : state.todayLearnedCount, 
                  unit: isGrammar ? "语法" : "词",
                  selected: selected.length == 5,
                  onPressed: () => notifier.toggleAllLevels(isGrammar),
                ),
                ...["N5", "N4", "N3", "N2", "N1"].map((l) => PremiumLevelChip(
                  level: l,
                  count: 0, 
                  unit: isGrammar ? "语法" : "词",
                  selected: selected.contains(l),
                  onPressed: () => notifier.toggleLevel(l, isGrammar),
                  onLongPress: () => notifier.exclusiveSelectLevel(l, isGrammar),
                )),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: NemoColors.brandBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("确定", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
        break;
    }

    return TestSettingsBottomSheet(
      title: title,
      content: content,
    );
  }

  List<TestContentType> _getContentTypeOptions(String? mode) {
    if (mode == 'typing' || mode == 'card_matching' || mode == 'sorting') return [TestContentType.words];
    if (mode == 'comprehensive') return [TestContentType.words, TestContentType.mixed];
    return TestContentType.values;
  }

  Widget _buildChipGrid<T>(List<T> options, String Function(T) labeler, T current, Function(T) onSelect) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: options.map((opt) => PremiumSelectorChip(
        text: labeler(opt),
        selected: opt == current,
        onPressed: () => onSelect(opt),
      )).toList(),
    );
  }
}

class _StartTestButton extends HookConsumerWidget {
  final String? testModeId;
  final TestSettingsUiState state;

  const _StartTestButton({this.testModeId, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = state.config;
    final isGenerating = useState(false);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: NemoColors.brandBlue.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isGenerating.value ? null : () => _onStart(context, ref, isGenerating, config),
            style: ElevatedButton.styleFrom(
              backgroundColor: NemoColors.brandBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 0,
            ),
            child: isGenerating.value 
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text("准备中...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                )
              : const Text("开始测试", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Future<void> _onStart(BuildContext context, WidgetRef ref, ValueNotifier<bool> isGenerating, TestConfig config) async {
    isGenerating.value = true;
    
    await Future.delayed(const Duration(milliseconds: 800));
    
    final List<TestQuestion> mockQuestions;
    if (testModeId == 'typing') {
      mockQuestions = [
        const TestQuestion(id: "t1", type: QuestionType.typing, questionText: "挑戦", correctAnswer: "ちょうせん", japanese: "挑戦", hiragana: "ちょうせん", chinese: "挑战", typingQuestionType: 0, explanation: "「挑战」的意思，读作「ちょうせん」。"),
        const TestQuestion(id: "t2", type: QuestionType.typing, questionText: "準備", correctAnswer: "じゅんび", japanese: "準備", hiragana: "じゅんび", chinese: "准备", typingQuestionType: 0, explanation: "「准备」的意思，读作「じゅんび」。"),
      ];
    } else if (testModeId == 'card_matching') {
      mockQuestions = [
        const TestQuestion(id: 'q1', type: QuestionType.cardMatching, questionText: '配对单词与释义', correctAnswer: '', matchPairs: [CardMatchPair(id: '1', term: 'こんにちは', definition: '你好'), CardMatchPair(id: '2', term: 'ありがとう', definition: '谢谢'), CardMatchPair(id: '3', term: 'さようなら', definition: '再见'), CardMatchPair(id: '4', term: 'はい', definition: '是的')]),
      ];
    } else if (testModeId == 'sorting') {
      mockQuestions = [
        const TestQuestion(
          id: "s1",
          type: QuestionType.sorting,
          questionText: "排序题",
          correctAnswer: "ごはんをたべる",
          chinese: "吃饭",
          japanese: "ご飯を食べる",
          hiragana: "ごはんをたべる",
          sortingOptions: [
            SortableChar(char: "ご", id: "s1_1"),
            SortableChar(char: "は", id: "s1_2"),
            SortableChar(char: "ん", id: "s1_3"),
            SortableChar(char: "を", id: "s1_4"),
            SortableChar(char: "た", id: "s1_5"),
            SortableChar(char: "べ", id: "s1_6"),
            SortableChar(char: "る", id: "s1_7"),
          ],
        ),
        const TestQuestion(
          id: "s2",
          type: QuestionType.sorting,
          questionText: "排序题",
          correctAnswer: "おいしい",
          chinese: "好吃的",
          japanese: "美味しい",
          hiragana: "おいしい",
          sortingOptions: [
            SortableChar(char: "お", id: "s2_1"),
            SortableChar(char: "い", id: "s2_2"),
            SortableChar(char: "し", id: "s2_3"),
            SortableChar(char: "い", id: "s2_4"),
          ],
        ),
      ];
    } else {
      mockQuestions = [
        const TestQuestion(id: "1", type: QuestionType.multipleChoice, questionText: "「挑戦」的读取方式是？", correctAnswer: "ちょうせん", options: ["ちょうぜん", "ちょうせん", "じょうせん", "じょうぜん"], explanation: "「挑战」的意思，读作「ちょうせん」。"),
        const TestQuestion(id: "2", type: QuestionType.multipleChoice, questionText: "「準備」的读取方式是？", correctAnswer: "じゅんび", options: ["じゅんび", "しゅんび", "ぜんび", "しんび"], explanation: "「准备」的意思，读作「じゅんび」。"),
      ];
    }
    
    ref.read(testProvider.notifier).startTest(questions: mockQuestions, timeLimitMinutes: config.timeLimitMinutes);
    isGenerating.value = false;
    
    if (context.mounted) {
      switch (testModeId) {
        case 'typing':
          context.pushNamed(TestRouteNames.typingTest);
          break;
        case 'card_matching':
          context.pushNamed(TestRouteNames.cardMatchingTest);
          break;
        case 'sorting':
          context.pushNamed(TestRouteNames.sortingTest);
          break;
        default:
          context.pushNamed(TestRouteNames.multipleChoiceTest);
      }
    }
  }
}

void _showBottomSheet(BuildContext context, String settingType, String? modeId, ValueNotifier<bool> countDialog, ValueNotifier<bool> timeDialog) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _SettingsBottomSheetContent(
        settingType: settingType, 
        testModeId: modeId,
        onShowCountDialog: () => countDialog.value = true,
        onShowTimeDialog: () => timeDialog.value = true,
      );
    },
  );
}

String _getPageTitle(String? testModeId) {
  switch (testModeId) {
    case 'multiple_choice': return '选择题设置';
    case 'typing': return '手打题设置';
    case 'card_matching': return '卡片题设置';
    case 'sorting': return '排序题设置';
    case 'comprehensive': return '综合测试设置';
    default: return '测试设置';
  }
}

String _getWrongAnswerRemovalLabel(int threshold) {
  switch (threshold) {
    case 0: return '不移除';
    case 3: return '3次';
    case 5: return '5次';
    case 7: return '7次';
    case 10: return '10次';
    default: return '不移除';
  }
}

String _getLevelLabel(String? mode, TestContentType type) {
  if (mode == 'typing' || mode == 'card_matching' || mode == 'sorting') return "测试等级";
  return type == TestContentType.grammar ? "语法等级" : "单词等级";
}

String _formatLevels(List<String> selected) {
  final all = ['N5', 'N4', 'N3', 'N2', 'N1'];
  final sortedSelected = List<String>.from(selected)..sort();
  if (sortedSelected.length == all.length) return "全部等级";
  if (sortedSelected.isEmpty) return "未选择";
  return sortedSelected.join(", ");
}

String _getComprehensiveSummary(Map<String, int> counts) {
  return "选${counts['multiple_choice'] ?? 0} 打${counts['typing'] ?? 0} 卡${counts['card_matching'] ?? 0} 排${counts['sorting'] ?? 0}";
}

class _DistributionCounterRow extends StatelessWidget {
  final String label;
  final int count;
  final ValueChanged<int> onChanged;

  const _DistributionCounterRow({
    required this.label,
    required this.count,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_rounded, size: 20),
                  onPressed: count > 0 ? () => onChanged(count - 1) : null,
                  color: theme.colorScheme.primary,
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 40),
                  alignment: Alignment.center,
                  child: Text(
                    "$count",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_rounded, size: 20),
                  onPressed: () => onChanged(count + 1),
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
