import 'package:flutter/material.dart';

class ConflictResolutionDialog extends StatelessWidget {
  const ConflictResolutionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0E68FF); // NemoPrimary
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final bodyColor = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6E6E73);

    return Dialog(
       backgroundColor: Colors.transparent,
       insetPadding: const EdgeInsets.symmetric(horizontal: 20),
       child: Container(
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(26),
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_sync_rounded, color: primaryColor, size: 32),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                '解决同步冲突',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Content
              Text(
                '检测到数据冲突。请选择您的解决方案：',
                style: TextStyle(color: bodyColor, fontSize: 15, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Explanation Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• 保留云端：使用云端数据覆盖本地。', style: TextStyle(fontSize: 12, color: bodyColor)),
                    const SizedBox(height: 8),
                    Text('• 保留本地：强制上传本地数据覆盖云端。', style: TextStyle(fontSize: 12, color: bodyColor)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Actions
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: const Text('保留云端 (推荐)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(foregroundColor: const Color(0xFFFF3B30)),
                child: const Text('保留本地并覆盖云端', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('取消', style: TextStyle(color: bodyColor, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
       ),
    );
  }
}

class ConfirmResetDialog extends StatefulWidget {
  const ConfirmResetDialog({super.key});

  @override
  State<ConfirmResetDialog> createState() => _ConfirmResetDialogState();
}

class _ConfirmResetDialogState extends State<ConfirmResetDialog> {
  bool includeCloud = false;
  bool isResetting = false;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFF3B30); // NemoDanger
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final bodyColor = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6E6E73);

    return Dialog(
       backgroundColor: Colors.transparent,
       insetPadding: const EdgeInsets.symmetric(horizontal: 20),
       child: Container(
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(26),
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_forever_rounded, color: primaryColor, size: 32),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                '确认重置',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Content
              Text(
                '您确定要重置所有学习进度吗？此操作将永久删除本地所有进度数据，且无法撤销。',
                style: TextStyle(color: bodyColor, fontSize: 15, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Cloud Checkbox Card
              InkWell(
                onTap: () => setState(() => includeCloud = !includeCloud),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: includeCloud,
                        onChanged: (val) => setState(() => includeCloud = val ?? false),
                        activeColor: primaryColor,
                      ),
                      const SizedBox(width: 8),
                      const Text('同时删除云端同步数据', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
              if (isResetting) ...[
                const SizedBox(height: 24),
                const CircularProgressIndicator(color: primaryColor, strokeWidth: 3),
              ],
              const SizedBox(height: 32),
              // Actions
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isResetting ? null : () {
                    setState(() => isResetting = true);
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) Navigator.pop(context);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: Text(isResetting ? '正在重置...' : '确认重置', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: isResetting ? null : () => Navigator.pop(context),
                child: Text('取消', style: TextStyle(color: bodyColor, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
       ),
    );
  }
}

class AdvancedLearningSettingsBottomSheet extends StatefulWidget {
  const AdvancedLearningSettingsBottomSheet({super.key});

  @override
  State<AdvancedLearningSettingsBottomSheet> createState() => _AdvancedLearningSettingsBottomSheetState();
}

class _AdvancedLearningSettingsBottomSheetState extends State<AdvancedLearningSettingsBottomSheet> {
  late TextEditingController _stepsController;
  late TextEditingController _relearnStepsController;
  double _learnAheadLimit = 20.0;
  int _leechThreshold = 5;
  String _leechAction = 'skip';

  @override
  void initState() {
    super.initState();
    _stepsController = TextEditingController(text: '1 10');
    _relearnStepsController = TextEditingController(text: '1 10');
  }

  @override
  void dispose() {
    _stepsController.dispose();
    _relearnStepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFAF52DE); // NemoPurple
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 32, height: 4,
            decoration: BoxDecoration(color: theme.colorScheme.outlineVariant, borderRadius: BorderRadius.circular(2),),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: accentColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.settings_suggest_rounded, color: accentColor, size: 20),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('记忆算法配置', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('调整间隔重复 (SRS) 核心参数', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: theme.colorScheme.outlineVariant.withOpacity(0.2)),
          
          Flexible(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              shrinkWrap: true,
              children: [
                // Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_rounded, color: theme.colorScheme.onSecondaryContainer, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('参数说明', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSecondaryContainer)),
                            const SizedBox(height: 4),
                            Text(
                              '此配置将改变新卡片的学习流程。错误的设置可能导致不得不频繁进行无效复习。',
                              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSecondaryContainer.withOpacity(0.8)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Learning Steps
                _buildFieldTitle('学习阶段 (Steps)'),
                const SizedBox(height: 8),
                TextField(
                  controller: _stepsController,
                  decoration: _inputDecoration('1 10', accentColor),
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 8),
                _buildHelperText('使用空格分隔的分钟数。默认为 \'1 10\'。\n表示：新卡片 -> 1分钟后复习 -> 10分钟后复习 -> 毕业。'),
                
                const SizedBox(height: 24),
                
                // Relearning Steps
                _buildFieldTitle('重学阶段 (Relearning Steps)'),
                const SizedBox(height: 8),
                TextField(
                  controller: _relearnStepsController,
                  decoration: _inputDecoration('1 10', accentColor),
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 8),
                _buildHelperText('忘记已学会的卡片时的复习步骤。默认为 \'1 10\'。\n表示：忘记卡片 -> 1分钟后复习 -> 10分钟后复习 -> 重新回到复习队列。'),

                const SizedBox(height: 32),
                
                // Learn Ahead Limit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFieldTitle('提前复习阈值'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('${_learnAheadLimit.toInt()} 分钟', style: const TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
                Slider(
                  value: _learnAheadLimit,
                  onChanged: (v) => setState(() => _learnAheadLimit = v),
                  min: 0, max: 60, divisions: 60,
                  activeColor: accentColor,
                  inactiveColor: accentColor.withOpacity(0.2),
                ),
                _buildHelperText('当卡片剩余冷却时间小于此值时，允许立即复习，无需等待。'),

                const SizedBox(height: 32),
                
                // Leech Threshold
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFieldTitle('Leech 阈值（累计失败）'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('$_leechThreshold 次', style: const TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: OutlinedButton(onPressed: () => setState(() => _leechThreshold = (_leechThreshold - 1).clamp(1, 12)), child: const Text('-1'))),
                    const SizedBox(width: 12),
                    Expanded(child: OutlinedButton(onPressed: () => setState(() => _leechThreshold = (_leechThreshold + 1).clamp(1, 12)), child: const Text('+1'))),
                  ],
                ),
                _buildHelperText('达到阈值后执行下方行为。默认 5 次。'),

                const SizedBox(height: 32),
                
                // Leech Action
                _buildFieldTitle('Leech 处理方式'),
                const SizedBox(height: 8),
                _buildActionCard('暂停卡片（skip）', '命中后不再进入常规复习队列', 'skip', accentColor),
                const SizedBox(height: 10),
                _buildActionCard('仅埋到明天（bury_today）', '今天不再出现，明天自动回队列', 'bury_today', accentColor),

                const SizedBox(height: 48),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedCornerShape(16),
                      elevation: 4,
                    ),
                    child: const Text('保存配置', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildActionCard(String title, String subtitle, String value, Color color) {
    final isSelected = _leechAction == value;
    return InkWell(
      onTap: () => setState(() => _leechAction = value),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.35),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? color : Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _leechAction,
              activeColor: color,
              onChanged: (v) => setState(() => _leechAction = v!),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

RoundedCornerShape(double radius) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
