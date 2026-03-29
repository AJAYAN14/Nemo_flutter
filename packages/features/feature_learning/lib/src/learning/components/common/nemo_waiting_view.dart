import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_domain/core_domain.dart';

/// 阈值等待界面 (1:1 还原 Kotlin WaitingContent)
/// 
/// 当没有到期卡片且下一张卡片在提前复习阈值之外时显示。
class NemoWaitingView extends HookWidget {
  final DateTime until;
  final VoidCallback onContinue;

  const NemoWaitingView({
    super.key,
    required this.until,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    // 实时计算剩余秒数（使用补偿后的当前时间）
    final now = DateTime.fromMillisecondsSinceEpoch(DateTimeUtils.getCurrentCompensatedMillis());
    final remainingSeconds = useState(until.difference(now).inSeconds);

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final now = DateTime.fromMillisecondsSinceEpoch(DateTimeUtils.getCurrentCompensatedMillis());
        final diff = until.difference(now).inSeconds;
        if (diff <= 0) {
          timer.cancel();
          onContinue(); // 时间到，自动继续
        } else {
          remainingSeconds.value = diff;
        }
      });
      return timer.cancel;
    }, [until]);

    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    
    // 格式化时间文本：5分20秒 或 20秒
    final timeText = minutes > 0 ? '${minutes}分${seconds}秒' : '${seconds}秒';

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. 带有光晕效果的图标容器
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: NemoColors.brandBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.access_time_rounded,
                color: NemoColors.brandBlue,
                size: 48,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 2. 主标题
          const Text(
            '请稍候...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: NemoColors.textMain,
            ),
          ),
          const SizedBox(height: 16),

          // 3. 副标题
          const Text(
            '下一个学习内容将在',
            style: TextStyle(
              fontSize: 18, // 对应 bodyLarge
              color: NemoColors.textSub,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // 4. 实时显示的时间组件
          Text(
            timeText,
            style: const TextStyle(
              fontSize: 48, // 对应 displayMedium
              fontWeight: FontWeight.bold,
              color: NemoColors.brandBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // 5. 底部文案
          const Text(
            '后准备好',
            style: TextStyle(
              fontSize: 18,
              color: NemoColors.textSub,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // 6. 提前复习按钮 (Learn Ahead)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: NemoColors.brandBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                '立即学习 (Learn Ahead)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
