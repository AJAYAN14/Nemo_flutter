UI 1:1 校验工具
=================

用途：
- 帮助对比 Kotlin（Compose）与 Flutter 屏幕，生成逐页对齐清单。

工作流：
1. 运行脚本收集 Kotlin 学习模块的 presentation 屏幕并生成映射草案：
   ```
   python tools/ui_review/collect_kotlin_screens.py
   ```
2. 编辑 `tools/ui_review/screen_mapping.yaml`，为每个条目填入 Flutter 对应路径并补充备注。
3. 采集 Kotlin 端参考截图（手动或通过 adb/Gradle 任务），放到 `tools/ui_review/kotlin_baseline/`。
4. 在 Flutter 端写 golden 测试并将输出与 Kotlin 基线图片比对（`packages/features/feature_learning/test/goldens/`）。

注意：动画比对需要采集关键帧；文案/可访问性文本应逐条比对而非像素比对。
