import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TestScopeNotifier extends Notifier<String> {
  @override
  String build() => 'n5';
  void set(String val) => state = val;
}
final testScopeProvider = NotifierProvider<TestScopeNotifier, String>(TestScopeNotifier.new);

class EnableTimerNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void set(bool val) => state = val;
}
final enableTimerProvider = NotifierProvider<EnableTimerNotifier, bool>(EnableTimerNotifier.new);

class AutoNextNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void set(bool val) => state = val;
}
final autoNextProvider = NotifierProvider<AutoNextNotifier, bool>(AutoNextNotifier.new);

void showTestSettingsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => const _TestSettingsSheet(),
  );
}

class _TestSettingsSheet extends HookConsumerWidget {
  const _TestSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scope = ref.watch(testScopeProvider);
    final enableTimer = ref.watch(enableTimerProvider);
    final autoNext = ref.watch(autoNextProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '测试设置',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: NemoColors.textMain,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '测试范围',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: NemoColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildScopeChip(ref, 'N5', 'n5', scope),
                _buildScopeChip(ref, 'N4', 'n4', scope),
                _buildScopeChip(ref, 'N3', 'n3', scope),
                _buildScopeChip(ref, 'N2', 'n2', scope),
                _buildScopeChip(ref, 'N1', 'n1', scope),
                _buildScopeChip(ref, '我的错题', 'mistakes', scope),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              '答题选项',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: NemoColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: NemoColors.borderLight),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildSwitchRow(
                    context: context,
                    title: '开启倒计时',
                    subtitle: '每道题限时 10 秒',
                    icon: CupertinoIcons.timer,
                    value: enableTimer,
                    onChanged: (v) => ref.read(enableTimerProvider.notifier).set(v),
                  ),
                  const Divider(height: 1, color: NemoColors.borderLight),
                  _buildSwitchRow(
                    context: context,
                    title: '答对自动下一题',
                    subtitle: '无缝切换，提升效率',
                    icon: CupertinoIcons.forward,
                    value: autoNext,
                    onChanged: (v) => ref.read(autoNextProvider.notifier).set(v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: NemoColors.textMain,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('保存并关闭', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScopeChip(WidgetRef ref, String label, String id, String current) {
    final isSelected = id == current;
    return GestureDetector(
      onTap: () => ref.read(testScopeProvider.notifier).set(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? NemoColors.brandBlue.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isSelected ? NemoColors.brandBlue : NemoColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? NemoColors.brandBlue : NemoColors.textSub,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: NemoColors.textMain, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: NemoColors.textMain,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: NemoColors.textSub,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: NemoColors.brandBlue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
