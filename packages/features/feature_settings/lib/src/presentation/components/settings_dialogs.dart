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
                  color: primaryColor.withValues(alpha: 0.1),
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
                  color: primaryColor.withValues(alpha: 0.1),
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



OutlinedBorder roundedCornerShape(double radius) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
