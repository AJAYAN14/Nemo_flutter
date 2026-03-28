# 学习模块逐页人工核对清单

用途：为每个屏（Kotlin Compose 与 Flutter 对应屏）提供统一的人工核对条目，便于记录像素/文案/动画/可访问性差异。

使用说明：
- 打开本文件，逐屏填写 `Reviewer`、`Date`、截图路径与每项核对结果（Pass/Fail/Notes）。
- Kotlin 参考图请放入 `tools/ui_review/kotlin_baseline/`，Flutter 截图放入 `tools/ui_review/flutter_shots/`。
- 若为动画，请记录关键帧文件名与时间点；若为文案差异，请记录 Kotlin 原文与 Flutter 文案。

模板字段（每屏）说明：
- `Kotlin`：Kotlin 屏源码路径（参考）。
- `Flutter`：Flutter 屏源码路径（参考）。
- `Kotlin screenshot` / `Flutter screenshot`：文件名（相对路径）。
- `Reviewer` / `Date`：填写人员与日期。
- `Checks`：按项记录 Pass/Fail，并在 `Notes` 写明差异及严重性（Major/Minor/Info）。

--

## review_screen

- Kotlin: old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/review/ReviewScreen.kt
- Flutter: packages/features/feature_learning/lib/src/srs_review/srs_review_screen.dart
- Kotlin screenshot: 
- Flutter screenshot: 
- Reviewer: 
- Date: 

Checks:

- [ ] Pixel & Layout: 间距、外边距、卡片宽高、PageView 对齐 — Pass/Fail — Notes:
- [ ] Typography: 标题/副标题/正文 字号与粗细 — Pass/Fail — Notes:
- [ ] Colors & Iconography: 主题色、图标尺寸与位置 — Pass/Fail — Notes:
- [ ] Copy & Labels: 页面标题、按钮文案、统计文本（需列出原文与当前） — Pass/Fail — Notes:
- [ ] Accessibility: semanticsLabel、hint、可聚焦次序 — Pass/Fail — Notes:
- [ ] Animations / Transitions: 翻页动画、评分按钮动效（记录时长/缓动） — Pass/Fail — Notes:
- [ ] Gestures / Controls: 滑动/点击/长按 行为与响应阈值 — Pass/Fail — Notes:
- [ ] Dynamic Content: 数字/计数/占位符/空态 表现 — Pass/Fail — Notes:
- [ ] Navigation & Actions: 返回、开始复习、跳转行为是否一致 — Pass/Fail — Notes:
- [ ] Overall Verdict: Pass / Fail — Severity: Major/Minor/Info — Notes:

--

## review_session_screen

- Kotlin: old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/review/ReviewSessionScreen.kt
- Flutter: packages/features/feature_learning/lib/src/srs_study/srs_study_screen.dart
- Kotlin screenshot: 
- Flutter screenshot: 
- Reviewer: 
- Date: 

Checks:

- [ ] Pixel & Layout — Pass/Fail — Notes:
- [ ] Typography — Pass/Fail — Notes:
- [ ] Colors & Iconography — Pass/Fail — Notes:
- [ ] Copy & Labels — Pass/Fail — Notes:
- [ ] Accessibility — Pass/Fail — Notes:
- [ ] Animations / Transitions — Pass/Fail — Notes:
- [ ] Gestures / Controls — Pass/Fail — Notes:
- [ ] Dynamic Content — Pass/Fail — Notes:
- [ ] Navigation & Actions — Pass/Fail — Notes:
- [ ] Overall Verdict — Pass/Fail — Severity — Notes:

--

## session_prep

- Kotlin: old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/review/SessionPrepScreen.kt
- Flutter: packages/features/feature_learning/lib/src/session/session_prep_screen.dart
- Kotlin screenshot: 
- Flutter screenshot: 
- Reviewer: 
- Date: 

Checks:

- [ ] Pixel & Layout — Pass/Fail — Notes:
- [ ] Typography — Pass/Fail — Notes:
- [ ] Colors & Iconography — Pass/Fail — Notes:
- [ ] Copy & Labels — Pass/Fail — Notes:
- [ ] Accessibility — Pass/Fail — Notes:
- [ ] Animations / Transitions — Pass/Fail — Notes:
- [ ] Gestures / Controls — Pass/Fail — Notes:
- [ ] Dynamic Content — Pass/Fail — Notes:
- [ ] Navigation & Actions — Pass/Fail — Notes:
- [ ] Overall Verdict — Pass/Fail — Severity — Notes:

--

## learning_screen

- Kotlin: old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/LearningScreen.kt
- Flutter: packages/features/feature_learning/lib/src/learning/learning_screen.dart
- Kotlin screenshot: 
- Flutter screenshot: 
- Reviewer: 
- Date: 

Checks:

- [ ] Pixel & Layout — Pass/Fail — Notes:
- [ ] Typography — Pass/Fail — Notes:
- [ ] Colors & Iconography — Pass/Fail — Notes:
- [ ] Copy & Labels — Pass/Fail — Notes:
- [ ] Accessibility — Pass/Fail — Notes:
- [ ] Animations / Transitions — Pass/Fail — Notes:
- [ ] Gestures / Controls — Pass/Fail — Notes:
- [ ] Dynamic Content — Pass/Fail — Notes:
- [ ] Navigation & Actions — Pass/Fail — Notes:
- [ ] Overall Verdict — Pass/Fail — Severity — Notes:

--

## home_screen

- Kotlin: old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/home/HomeScreen.kt
- Flutter: packages/features/feature_learning/lib/src/presentation/home_screen.dart
- Kotlin screenshot: 
- Flutter screenshot: 
- Reviewer: 
- Date: 

Checks:

- [ ] Pixel & Layout — Pass/Fail — Notes:
- [ ] Typography — Pass/Fail — Notes:
- [ ] Colors & Iconography — Pass/Fail — Notes:
- [ ] Copy & Labels — Pass/Fail — Notes:
- [ ] Accessibility — Pass/Fail — Notes:
- [ ] Animations / Transitions — Pass/Fail — Notes:
- [ ] Gestures / Controls — Pass/Fail — Notes:
- [ ] Dynamic Content — Pass/Fail — Notes:
- [ ] Navigation & Actions — Pass/Fail — Notes:
- [ ] Overall Verdict — Pass/Fail — Severity — Notes:

--

## kana_chart

- Kotlin: old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/kana/KanaChartScreen.kt
- Flutter: packages/features/feature_learning/lib/src/kana/kana_chart_screen.dart
- Kotlin screenshot: 
- Flutter screenshot: 
- Reviewer: 
- Date: 

Checks:

- [ ] Grid alignment & spacing — Pass/Fail — Notes:
- [ ] Typography & stroke — Pass/Fail — Notes:
- [ ] Colors & Iconography — Pass/Fail — Notes:
- [ ] Copy & Labels — Pass/Fail — Notes:
- [ ] Accessibility — Pass/Fail — Notes:
- [ ] Animations / Transitions — Pass/Fail — Notes:
- [ ] Gestures / Controls — Pass/Fail — Notes:
- [ ] Dynamic Content — Pass/Fail — Notes:
- [ ] Overall Verdict — Pass/Fail — Severity — Notes:

--

## srs_action_area

- Kotlin: old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/components/srs/SRSActionArea.kt
- Flutter: packages/features/feature_learning/lib/src/learning/components/srs_action_area.dart
- Kotlin screenshot: 
- Flutter screenshot: 
- Reviewer: 
- Date: 

Checks:

- [ ] Button layout & spacing — Pass/Fail — Notes:
- [ ] Touch targets — Pass/Fail — Notes:
- [ ] Copy & Labels — Pass/Fail — Notes:
- [ ] Accessibility — Pass/Fail — Notes:
- [ ] Animations / Transitions — Pass/Fail — Notes:
- [ ] Overall Verdict — Pass/Fail — Severity — Notes:

--

## srs_rating_button

- Kotlin: old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/components/srs/SRSRatingButton.kt
- Flutter: packages/features/feature_learning/lib/src/learning/components/srs_rating_button.dart
- Kotlin screenshot: 
- Flutter screenshot: 
- Reviewer: 
- Date: 

Checks:

- [ ] Shape & size — Pass/Fail — Notes:
- [ ] Press animation & selected state — Pass/Fail — Notes:
- [ ] Accessibility label & semantics — Pass/Fail — Notes:
- [ ] Overall Verdict — Pass/Fail — Severity — Notes:
