# **Nemo App \- Flutter 重构 UI 与导航开发蓝图**

**核心策略：先 UI，后逻辑 (UI-First & Mock-Driven)**

**架构基础：基于 Melos 的 Monorepo 多包管理架构**

本文档列出了 Nemo 从 Android 迁移至 Flutter 过程中，**所有界面与关键弹窗组件的开发优先级与原 Android 参考文件路径**。在当前阶段，所有界面的数据均采用**硬编码（Hardcode）或 Mock 数据**，不接入任何真实的本地数据库（SQLite）或网络请求（Supabase）。唯一的目标是：**参考原生 .kt 文件的 UI 布局逻辑，完美复刻视觉、打磨动画交互、跑通全局路由。**

> 当前实际目录说明：旧 Android 项目已位于 `old_nemo/Nemo/`，下文所有 Android 参考路径均**相对于**该目录。

## **🏗 工程目录结构约定**

在 Flutter 根目录下，采用以下多包架构（Melos）：

* apps/nemo\_app/：主壳工程（负责组装、依赖注入、全局路由 go\_router 配置）  
* packages/core/：核心库（core\_designsystem, core\_ui, core\_domain 等）  
* packages/features/：按业务划分的功能模块（与原 Android 架构对齐）

## **🟥 阶段一：全局骨架与身份认证 (优先级：P0 \- 极高)**

**目标**：搭建 App 的进入流程，实现底部导航栏框架，让应用“跑起来”。

| 原 Android 界面 / 功能 | 原 Android (.kt) 参考路径（相对 old_nemo/Nemo/） | UI 开发要点 (Mock 阶段) |
| :---- | :---- | :---- |
| **启动页 (Splash)** | old_nemo/Nemo/core/ui/src/main/java/com/jian/nemo/core/ui/component/splash/SplashScreen.kt | 居中动画 Logo，使用 Future.delayed 2秒后跳转登录或主页。 |
| **登录页 (Login)** | old_nemo/Nemo/feature/user/src/main/java/com/jian/nemo/feature/user/LoginScreen.kt | 静态的账号/密码输入框，点击“登录”直接通过路由跳转主壳。 |
| **主导航壳 (Main Shell)** | old_nemo/Nemo/app/src/main/java/com/jian/nemo/navigation/NemoNavHost.kt old_nemo/Nemo/core/ui/src/main/java/com/jian/nemo/core/ui/component/NemoBottomBar.kt | 使用 go\_router 的 StatefulShellRoute，复刻 NemoBottomBar 样式及切换逻辑 (Home, Library, Test, Profile)。 |

## **🟧 阶段二：学习主流程心流 (优先级：P1 \- 高)**

**目标**：跑通 Nemo 最核心的 SRS（间隔重复）学习与复习交互，参考原生的 Compose 动画，重度打磨卡片翻转、手势滑动等。

| 原 Android 界面 / 功能 | 原 Android (.kt) 参考路径（相对 old_nemo/Nemo/） | UI 开发要点 (Mock 阶段) |
| :---- | :---- | :---- |
| **学习主页 (Home)** | old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/home/HomeScreen.kt | 写死环形进度图（如 80%），展示今日复习/新学数量的静态卡片。 |
| **假名表 (Kana Chart)** | old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/kana/KanaChartScreen.kt | Tab 切换（清音/浊音/拗音），GridView 渲染写死的五十音数组，展示发音按钮 UI。 |
| **学习准备 (Session Prep)** | old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/review/SessionPrepScreen.kt | 显示即将学习的假数据列表，底部悬浮“Start”大按钮。 |
| **复习会话容器 (Review Session)** | old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/review/ReviewSessionScreen.kt | 作为复习阶段的流程容器页，串联 Session Prep 与 Review，先用静态步骤状态驱动。 |
| **打字练习弹窗 (Typing Practice)** | old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/components/dialogs/TypingPracticeDialog.kt | 弹出式输入框验证静态 UI，处理键盘弹出焦点。 |
| **卡片学习 (Learning)** | old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/LearningScreen.kt *依赖动画参考*：old_nemo/Nemo/core/ui/src/main/java/com/jian/nemo/core/ui/component/animation/AnimatedWordBackground.kt | **核心动画**：参考原生背景动效，实现滑动切换卡片，点击卡片翻转。 |
| **打分复习 (Review Screen)** | old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/review/ReviewScreen.kt | 卡片底部显示 4 个静态打分按钮（Forgot/Hard/Good/Easy），点击后通过动画切换下一张。 |
| **分类卡片学习 (Category Card Learning)** | old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/category/CategoryCardLearningScreen.kt | 针对分类卡片的学习流 UI，先用静态分类数据验证切页与过渡动效。 |
| **评分说明页 (Rating Guide)** | old_nemo/Nemo/feature/learning/src/main/java/com/jian/nemo/feature/learning/presentation/components/guide/RatingGuideScreen.kt | 对 4 档评分含义做静态说明卡片，作为新手引导页独立路由。 |

## **🟨 阶段三：词库与语法书 (优先级：P1 \- 高)**

**目标**：建立数据展示库，实现各种维度的列表渲染和折叠动画，跑通到详情页的深度路由。

| 原 Android 界面 / 功能 | 原 Android (.kt) 参考路径（相对 old_nemo/Nemo/） | UI 开发要点 (Mock 阶段) |
| :---- | :---- | :---- |
| **词库主页 (Library)** | old_nemo/Nemo/feature/library/src/main/java/com/jian/nemo/feature/library/presentation/LibraryScreen.kt | N1-N5 级别卡片，写死学习进度条。 |
| **分类导航 (Category)** | old_nemo/Nemo/feature/library/src/main/java/com/jian/nemo/feature/library/presentation/category/CategoryClassificationScreen.kt | 按词性、词书展示分类入口的静态列表。 |
| **分类词汇列表 (Category Words)** | old_nemo/Nemo/feature/library/src/main/java/com/jian/nemo/feature/library/presentation/category/CategoryWordsScreen.kt | 从分类入口进入的词汇子列表页，使用静态分组数据与吸顶标题。 |
| **词性词汇列表 (POS Words)** | old_nemo/Nemo/feature/library/src/main/java/com/jian/nemo/feature/library/presentation/category/PosWordsScreen.kt | 按词性过滤后的词汇清单页，先实现筛选标签与列表态切换。 |
| **词性总览 (Part of Speech)** | old_nemo/Nemo/feature/library/src/main/java/com/jian/nemo/feature/library/presentation/partofspeech/PartOfSpeechScreen.kt | 词性入口总览页，强调卡片式导航与点击反馈动效。 |
| **通用可展开列表组件 (Generic Expandable List)** | old_nemo/Nemo/core/ui/src/main/java/com/jian/nemo/core/ui/component/list/GenericExpandableListScreen.kt | 作为语法列表等页面的可复用展开/收起模板，先抽象为 Flutter 公共组件。 |
| **语法列表 (Grammar List)** | old_nemo/Nemo/feature/library/src/main/java/com/jian/nemo/feature/library/presentation/list/GrammarListScreen.kt | 参考原版，实现带有 Expandable 展开/收起动画的静态列表。 |
| **单词列表 (Word List)** | old_nemo/Nemo/feature/library/src/main/java/com/jian/nemo/feature/library/presentation/list/WordListScreen.kt | 长列表 UI，实现侧滑显示操作菜单（如收藏）的视觉反馈。 |
| **单词详情 (Word Detail)** | old_nemo/Nemo/feature/library/src/main/java/com/jian/nemo/feature/library/presentation/detail/WordDetailScreen.kt *依赖组件*：old_nemo/Nemo/core/ui/src/main/java/com/jian/nemo/core/ui/component/text/FuriganaText.kt | **重难点**：在 Flutter 中用 CustomPaint 或 Widget 组合还原 FuriganaText（汉字上方的注音文本），展示写死的例句和释义。 |
| **语法详情 (Grammar Detail)** | old_nemo/Nemo/feature/library/src/main/java/com/jian/nemo/feature/library/presentation/detail/GrammarDetailScreen.kt | 语法接续、多条例句的静态卡片堆叠布局。 |

## **🟩 阶段四：游戏化测试模块 (优先级：P2 \- 中)**

**目标**：将所有互动题型复刻至 Flutter，专注手势与视图状态（由于没有真实逻辑，选项正确与否均可写死）。

| 原 Android 界面 / 功能 | 原 Android (.kt) 参考路径（相对 old_nemo/Nemo/） | UI 开发要点 (Mock 阶段) |
| :---- | :---- | :---- |
| **测试面板 (Test Dashboard)** | old_nemo/Nemo/feature/test/src/main/java/com/jian/nemo/feature/test/presentation/dashboard/TestDashboardScreen.kt | 题型选择网格卡片，题目数量 Slider 静态组件。 |
| **测试入口页 (Test Home)** | old_nemo/Nemo/feature/test/src/main/java/com/jian/nemo/feature/test/TestScreen.kt | 作为测试模块总入口，承接 Dashboard 与历史结果入口按钮。 |
| **测试设置 (Test Settings)** | old_nemo/Nemo/feature/test/src/main/java/com/jian/nemo/feature/test/presentation/settings/TestSettingsScreen.kt | 底部弹窗（BottomSheet）包含各种测试参数的单选、多选列表。 |
| **统一测试容器 (Unified Test)** | old_nemo/Nemo/feature/test/src/main/java/com/jian/nemo/feature/test/components/UnifiedTestScreen.kt | 顶部的静态进度条（如: 5/20），以及底部承载子题型的内容区域。 |
| ↳ 选择题 (Multiple Choice) | old_nemo/Nemo/feature/test/src/main/java/com/jian/nemo/feature/test/components/MultipleChoiceTestContent.kt | 4 个静态选项按钮，点击模拟变色（如正确显绿，错误显红）。 |
| ↳ 选择题页面壳 (Multiple Choice Screen) | old_nemo/Nemo/feature/test/src/main/java/com/jian/nemo/feature/test/presentation/MultipleChoiceScreen.kt | 用页面壳承载选择题组件，补齐从容器到题型页的路由层。 |
| ↳ 拼写题 (Typing) | old_nemo/Nemo/feature/test/src/main/java/com/jian/nemo/feature/test/components/TypingTestContent.kt | 文本输入框、占位符以及提交按钮的校验态 UI。 |
| ↳ 拼写题页面壳 (Typing Screen) | old_nemo/Nemo/feature/test/src/main/java/com/jian/nemo/feature/test/presentation/TypingScreen.kt | 补齐拼写题独立页面外壳，统一返回、进度和提交按钮样式。 |
| ↳ 排序题 (Sorting) | old_nemo/Nemo/feature/test/src/main/java/com/jian/nemo/feature/test/presentation/SortingScreen.kt | **核心交互**：在 Flutter 中通过 ReorderableListView 还原拖拽排序手势。 |
| ↳ 连连看 (Card Matching) | old_nemo/Nemo/feature/test/src/main/java/com/jian/nemo/feature/test/presentation/cardmatching/CardMatchingScreen.kt | **核心交互**：静态 3x4 网格卡片，实现点击选中、错误震动及正确消除的动画视觉。 |
| **测试结果 (Test Result)** | old_nemo/Nemo/feature/test/src/main/java/com/jian/nemo/feature/test/TestResultScreen.kt | 炫酷圆环进度图展示分数（例如 85%），下方是写死的错题详情列表。 |

## **🟦 阶段五：数据统计与错题集 (优先级：P2 \- 中)**

**目标**：通过图表和列表直观展示学习数据，在 Flutter 中通过假数据实现精美图表。

| 原 Android 界面 / 功能 | 原 Android (.kt) 参考路径（相对 old_nemo/Nemo/） | UI 开发要点 (Mock 阶段) |
| :---- | :---- | :---- |
| **统计主页 (Statistics)** | old_nemo/Nemo/feature/statistics/src/main/java/com/jian/nemo/feature/statistics/StatisticsScreen.kt | 各类数据看板（如已学单词总数、正确率）的大数字卡片汇总。 |
| **进度仪表盘 (Progress Dashboard)** | old_nemo/Nemo/feature/statistics/src/main/java/com/jian/nemo/feature/statistics/presentation/dashboard/ProgressDashboardScreen.kt | 聚合学习进度、连续打卡、阶段完成度等关键数据卡片。 |
| **通用统计容器 (Generic Statistics)** | old_nemo/Nemo/feature/statistics/src/main/java/com/jian/nemo/feature/statistics/components/GenericStatisticsScreen.kt | 提炼可复用的图表+列表统计模板，先以静态图表配置驱动。 |
| **热力图 (Activity Heatmap)** | old_nemo/Nemo/feature/statistics/src/main/java/com/jian/nemo/feature/statistics/ActivityHeatmapScreen.kt | GitHub 风格的学习打卡绿色方格阵列（可在 Flutter 中用 GridView 搭配写死数据实现）。 |
| **历史数据 (Historical)** | old_nemo/Nemo/feature/statistics/src/main/java/com/jian/nemo/feature/statistics/HistoricalStatisticsScreen.kt | 静态折线图/柱状图（引入 fl\_chart 或自定义画板呈现）。 |
| **日历视图 (Calendar)** | old_nemo/Nemo/feature/statistics/src/main/java/com/jian/nemo/feature/statistics/calendar/LearningCalendarScreen.kt | 月历组件视图，为特定假日期加上红色/绿色标记圆点。 |
| **顽固词管理 (Leech)** | old_nemo/Nemo/feature/statistics/src/main/java/com/jian/nemo/feature/statistics/presentation/dashboard/LeechManagementScreen.kt | 顽固词汇/语法的静态列表及移除按钮。 |
| **收藏集 (Favorites)** | old_nemo/Nemo/feature/collection/src/main/java/com/jian/nemo/feature/collection/favorites/FavoritesScreen.kt | 词汇、语法、题目的 Tab 栏，带有滑动删除 (Dismissible) 效果的列表项。 |
| **收藏词汇子页 (Favorite Words)** | old_nemo/Nemo/feature/collection/src/main/java/com/jian/nemo/feature/collection/favorites/FavoriteWordsScreen.kt | 收藏词汇独立列表页，支持滑动删除与批量编辑的静态入口。 |
| **收藏语法子页 (Favorite Grammars)** | old_nemo/Nemo/feature/collection/src/main/java/com/jian/nemo/feature/collection/favorites/FavoriteGrammarsScreen.kt | 收藏语法独立列表页，复用收藏列表但强化标签与分组样式。 |
| **收藏题目子页 (Favorite Questions)** | old_nemo/Nemo/feature/collection/src/main/java/com/jian/nemo/feature/collection/favorites/FavoriteQuestionsScreen.kt | 收藏题目独立列表页，突出题型标识和最近练习时间信息。 |
| **错题本 (Mistakes)** | old_nemo/Nemo/feature/collection/src/main/java/com/jian/nemo/feature/collection/mistakes/MistakesScreen.kt | 类似收藏集的结构，增加答错次数角标。 |
| **错词子页 (Wrong Words)** | old_nemo/Nemo/feature/collection/src/main/java/com/jian/nemo/feature/collection/mistakes/WrongWordsScreen.kt | 错词列表子页，按错误次数和最近错误时间做静态排序样式。 |
| **错语法子页 (Wrong Grammars)** | old_nemo/Nemo/feature/collection/src/main/java/com/jian/nemo/feature/collection/mistakes/WrongGrammarsScreen.kt | 错语法列表子页，强化语法点标签、错因标注与跳转入口。 |

## **🟪 阶段六：用户、设置与边缘组件 (优先级：P3 \- 低)**

**目标**：完善 App 的边缘功能，提供完整的页面闭环。

| 原 Android 界面 / 功能 | 原 Android (.kt) 参考路径（相对 old_nemo/Nemo/） | UI 开发要点 (Mock 阶段) |
| :---- | :---- | :---- |
| **个人主页 (Profile)** | old_nemo/Nemo/feature/user/src/main/java/com/jian/nemo/feature/user/ProfileScreen.kt | 圆形头像组件、静态用户名、总体学习天数汇总区。 |
| **账号管理 (Account Mgt)** | old_nemo/Nemo/feature/user/src/main/java/com/jian/nemo/feature/user/AccountManagementScreen.kt | 更改密码、登出、注销账号的警告弹窗与列表。 |
| **设置页 (Settings)** | old_nemo/Nemo/feature/settings/src/main/java/com/jian/nemo/feature/settings/SettingsScreen.kt | 各类功能的 Switch 列表项（夜间模式、每日提醒等）。 |
| **TTS 音频设置 (TTS)** | old_nemo/Nemo/feature/settings/src/main/java/com/jian/nemo/feature/settings/TtsSettingsScreen.kt | 音量及语速的 Slider 滑块控件，点击试听静态按钮。 |
| **头像编辑弹窗 (Avatar Edit Dialog)** | old_nemo/Nemo/core/ui/src/main/java/com/jian/nemo/core/ui/component/avatar/AvatarEditDialog.kt | 头像裁剪/替换相关弹窗流程，先实现视觉状态与确认交互。 |
| **预设头像选择弹窗 (Preset Avatar Selector)** | old_nemo/Nemo/core/ui/src/main/java/com/jian/nemo/core/ui/component/avatar/PresetAvatarSelectorDialog.kt | 网格化头像选择器，支持选中高亮与确认按钮静态态。 |
| **Google TTS 安装弹窗 (Google TTS Install)** | old_nemo/Nemo/core/ui/src/main/java/com/jian/nemo/core/ui/component/dialog/GoogleTtsInstallDialog.kt | 引导安装 TTS 引擎的提示弹窗，补齐设置链路中的异常分支。 |
| **应用更新弹窗 (Update Dialog)** | old_nemo/Nemo/core/ui/src/main/java/com/jian/nemo/core/ui/component/update/UpdateDialog.kt | 强更/非强更两种静态样式，含版本说明和跳转按钮布局。 |

## **🛠 落地建议**

1. **利用 Vibe Coding 精准还原：**  
   因为我们在上面的表格中列出了精准的 .kt 文件相对路径，当你需要生成 Flutter 页面时，可以直接让 AI 阅读原 Android 的 UI 文件（比如让 AI 读 old_nemo/Nemo/core/ui/src/main/java/com/jian/nemo/old_nemo/Nemo/core/ui/component/card/CommonWordCard.kt），分析它的 Modifier、阴影、圆角和排版逻辑，并 1:1 转换为 Flutter 的 Container, BoxDecoration, Padding。  
2. **纯 Mock 数据驱动：**  
   在页面文件顶部直接定义 final mockData \= ...;。保持你的 Provider/State 层绝对干净。  
3. **优先复刻核心依赖组件：**  
   特别留意原 core/ui/src/main/java/com/jian/nemo/core/ui/component/ 下的共用组件（如按钮、App Bar、Header）。这部分用 Flutter 写成纯 UI 组件库（放入 packages/core/core\_designsystem）是最高效的。
