import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:core_prefs/core_prefs.dart';
import 'components/settings_components.dart';

class SrsSettingsScreen extends HookConsumerWidget {
  const SrsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const accentColor = Color(0xFFAF52DE); // NemoPurple

    final learnAheadLimit = ref.watch(learnAheadLimitProvider).toDouble();
    final leechThreshold = ref.watch(leechThresholdProvider);
    final leechAction = ref.watch(leechActionProvider);
    final learningSteps = ref.watch(learningStepsProvider);
    final relearningSteps = ref.watch(relearningStepsProvider);

    final stepsController = useTextEditingController(text: learningSteps);
    final relearnStepsController = useTextEditingController(text: relearningSteps);

    useEffect(() {
      stepsController.text = learningSteps;
      return null;
    }, [learningSteps]);

    useEffect(() {
      relearnStepsController.text = relearningSteps;
      return null;
    }, [relearningSteps]);

    return Scaffold(
      backgroundColor: NemoColors.bgBase,
      appBar: AppBar(
        title: const Text('记忆算法配置', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const _AlgorithmInfoCard(),

          const SizedBox(height: 24),

          const SettingsSectionTitle('阶段配置'),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldTitle('学习阶段 (Steps)'),
                const SizedBox(height: 8),
                TextField(
                  controller: stepsController,
                  decoration: _inputDecoration('1 10', accentColor),
                  style: const TextStyle(fontSize: 15),
                  onSubmitted: (val) {
                    ref.read(learningStepsProvider.notifier).set(val.trim());
                  },
                ),
                const SizedBox(height: 8),
                _buildHelperText('使用空格分隔的分钟数。默认为 \'1 10\'。\n表示：新卡片 -> 1分钟后复习 -> 10分钟后复习 -> 毕业。'),
                
                const SizedBox(height: 24),
                
                _buildFieldTitle('重学阶段 (Relearning Steps)'),
                const SizedBox(height: 8),
                TextField(
                  controller: relearnStepsController,
                  decoration: _inputDecoration('1 10', accentColor),
                  style: const TextStyle(fontSize: 15),
                  onSubmitted: (val) {
                    ref.read(relearningStepsProvider.notifier).set(val.trim());
                  },
                ),
                const SizedBox(height: 8),
                _buildHelperText('忘记已学会的卡片时的复习步骤。默认为 \'1 10\'。'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const SettingsSectionTitle('复习阈值'),
          PremiumCard(
            padding: EdgeInsets.zero,
            child: PremiumSliderSettingItem(
              icon: Icons.timer_outlined,
              iconColor: accentColor,
              title: '提前复习阈值',
              value: learnAheadLimit,
              valueDisplay: '${learnAheadLimit.toInt()} 分钟',
              onChanged: (v) => ref.read(learnAheadLimitProvider.notifier).set(v.toInt()),
              min: 0,
              max: 60,
              divisions: 60,
              accentColor: accentColor,
            ),
          ),

          const SizedBox(height: 24),

          const SettingsSectionTitle('Leech 策略 (难点处理)'),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFieldTitle('Leech 阈值（累计失败）'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('$leechThreshold 次', style: const TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ref.read(leechThresholdProvider.notifier).set((leechThreshold - 1).clamp(1, 12));
                        },
                        child: const Text('-1'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ref.read(leechThresholdProvider.notifier).set((leechThreshold + 1).clamp(1, 12));
                        },
                        child: const Text('+1'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildFieldTitle('达到阈值后的处理方式'),
                const SizedBox(height: 12),
                PremiumRadioSettingItem(
                  title: '暂停卡片（skip）',
                  subtitle: '命中后不再进入常规复习队列',
                  value: 'skip',
                  groupValue: leechAction,
                  accentColor: accentColor,
                  onSelected: (v) => ref.read(leechActionProvider.notifier).set(v),
                ),
                const SizedBox(height: 10),
                PremiumRadioSettingItem(
                  title: '仅埋到明天（bury_today）',
                  subtitle: '今天不再出现，明天自动回队列',
                  value: 'bury_today',
                  groupValue: leechAction,
                  accentColor: accentColor,
                  onSelected: (v) => ref.read(leechActionProvider.notifier).set(v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildFieldTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600));
  }

  Widget _buildHelperText(String text) {
    return Text(text, style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.4));
  }

  InputDecoration _inputDecoration(String hint, Color focusColor) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.grey)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: focusColor, width: 2)),
    );
  }
}

class _AlgorithmInfoCard extends StatelessWidget {
  const _AlgorithmInfoCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.info_rounded, color: theme.colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('参数说明', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSecondaryContainer, fontSize: 16)),
                const SizedBox(height: 6),
                Text(
                  '此配置将改变新卡片的学习流程。错误的设置可能导致不得不频繁进行无效复习，建议仅在了解间隔重复原理后修改。',
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.7), height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
