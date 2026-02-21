package com.jian.nemo.feature.statistics.presentation.dashboard

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.rounded.ArrowForwardIos
import androidx.compose.material.icons.automirrored.rounded.TrendingUp
import androidx.compose.material.icons.rounded.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.luminance
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.jian.nemo.core.ui.component.SlidingDotIndicator
import com.jian.nemo.core.designsystem.theme.NemoPrimary
import com.jian.nemo.core.designsystem.theme.NemoSecondary
import com.jian.nemo.core.designsystem.theme.NemoDanger
import com.jian.nemo.core.designsystem.theme.OceanTheme
import com.jian.nemo.core.designsystem.theme.ForestTheme
import com.jian.nemo.core.designsystem.theme.LavenderTheme
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.text.buildAnnotatedString

// 定义常量
private const val ANIMATION_DURATION = 200
private const val PRESS_SCALE = 0.97f

/**
 * 沉浸式头部 (V2: Clean & Minimal)
 * 去除背景干扰，强调信息本身
 */
@Composable
fun ImmersiveDashboardHeader(
    title: String,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier
            .fillMaxWidth()
            .padding(bottom = 20.dp, top = 8.dp)
    ) {
        // 主标题 (Bold & Clean)
        // 强制使用中文标题，虽然参数传进来了，但这里可以不做处理，依赖外部传入中文 "进度"
        Text(
            text = title,
            style = MaterialTheme.typography.displaySmall.copy(
                fontWeight = FontWeight.Black,
                letterSpacing = (-1).sp
            ),
            color = MaterialTheme.colorScheme.onBackground
        )
    }
}

/**
 * 学习摘要卡片 (V2: Premium Card - Clean Surface)
 */
@OptIn(ExperimentalFoundationApi::class)
@Composable
fun LearningSummaryCard(
    progress: Float,
    masteredCount: Int,
    totalWords: Int,
    todayLearned: Int,
    dailyGoal: Int,
    unmasteredCount: Int,
    studyStreak: Int,
    dueCount: Int,
    totalStudyDays: Int,
    weekStudyDays: Int,
    cardColor: Color // Unused in V2, we use PremiumCard defaults
) {
    val pageCount = 10000
    val pagerState = rememberPagerState(
        initialPage = pageCount / 2,
        pageCount = { pageCount }
    )

    // Determine current page theme (New Themes: Ocean, Forest, Lavender)
    val actualPage = pagerState.currentPage % 3
    val currentTheme = when (actualPage) {
        0 -> OceanTheme
        1 -> ForestTheme
        else -> LavenderTheme
    }

    val todayProgress = when {
        dailyGoal <= 0 -> 0
        todayLearned >= dailyGoal -> 100
        else -> ((todayLearned.toFloat() / dailyGoal) * 100).toInt()
    }

    PremiumCard {
        Column(modifier = Modifier.padding(16.dp)) {
            val titles = listOf("日间概览", "学习轨迹", "成长总览")
            val currentTitle = titles[actualPage]


            // Header Row (Consistent with StatsPager)
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 16.dp), // Match StatsPager padding
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = currentTitle,
                    style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold),
                    color = currentTheme.TitleText
                )

                // Subtle Icon
                 Icon(
                    imageVector = when(actualPage) {
                        0 -> Icons.Rounded.Today
                        1 -> Icons.Rounded.Timeline
                        else -> Icons.AutoMirrored.Rounded.TrendingUp
                    },
                    contentDescription = null,
                    tint = currentTheme.Primary,
                    modifier = Modifier
                        .size(32.dp)
                        .background(currentTheme.IconBg, CircleShape)
                        .padding(6.dp)
                )
            }

            // Pager Content
            HorizontalPager(
                state = pagerState,
                modifier = Modifier.fillMaxWidth()
            ) { page ->
                val pageIndex = page % 3
                Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                    when (pageIndex) {
                        0 -> Page1_DailyOverview(
                            todayLearned = todayLearned,
                            dueCount = dueCount,
                            todayProgress = todayProgress
                        )
                        1 -> Page2_LearningTrack(
                            masteredCount = masteredCount,
                            unmasteredCount = unmasteredCount,
                            studyStreak = studyStreak
                        )
                        2 -> Page3_GrowthOverview(
                            totalProgress = progress,
                            totalStudyDays = totalStudyDays,
                            weekStudyDays = weekStudyDays
                        )
                    }
                }
            }

            // 底部指示器
            SlidingDotIndicator(
                pagerState = pagerState,
                pageCount = 3,
                activeColor = currentTheme.Accent,
                inactiveColor = currentTheme.IconBg,
                modifier = Modifier
                    .align(Alignment.CenterHorizontally)
                    .padding(top = 16.dp) // Match StatsPager padding
            )
        }
    }
}

/**
 * 第1页：日间概览 (数字版) - Uses OceanTheme explicitly
 */
@Composable
private fun Page1_DailyOverview(
    todayLearned: Int,
    dueCount: Int,
    todayProgress: Int
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        VisualStatItem(
            value = todayLearned.toString(),
            label = "今日已学",
            color = OceanTheme.Primary,
            modifier = Modifier.weight(1f)
        )
        VisualStatItem(
            value = dueCount.toString(),
            label = "待复习",
            color = OceanTheme.Secondary,
            modifier = Modifier.weight(1f)
        )
        VisualStatItem(
            value = "${todayProgress}%",
            label = "今日目标",
            color = OceanTheme.Tertiary,
            modifier = Modifier.weight(1f)
        )
    }
}

/**
 * Page 2: 学习轨迹 - Uses ForestTheme explicitly
 */
@Composable
private fun Page2_LearningTrack(
    masteredCount: Int,
    unmasteredCount: Int,
    studyStreak: Int
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        VisualStatItem(
            value = masteredCount.toString(),
            label = "总掌握",
            color = ForestTheme.Primary,
            modifier = Modifier.weight(1f)
        )
         VisualStatItem(
            value = unmasteredCount.toString(),
            label = "待学习",
            color = ForestTheme.Secondary,
            modifier = Modifier.weight(1f)
        )
         VisualStatItem(
            value = "$studyStreak 天",
            label = "连续学习",
            color = ForestTheme.Tertiary,
            modifier = Modifier.weight(1f)
        )
    }
}

/**
 * Page 3: 成长总览 - Uses LavenderTheme explicitly
 */
@Composable
private fun Page3_GrowthOverview(
    totalProgress: Float,
    totalStudyDays: Int,
    weekStudyDays: Int
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
         VisualStatItem(
             // Show only integer % for clean look
            value = "${(totalProgress * 100).toInt()}%",
            label = "总进度",
            color = LavenderTheme.Primary,
            modifier = Modifier.weight(1f)
         )
         VisualStatItem(
            value = "$totalStudyDays 天",
            label = "累计学习",
            color = LavenderTheme.Secondary,
            modifier = Modifier.weight(1f)
        )
         VisualStatItem(
            value = "$weekStudyDays 天",
            label = "本周学习",
            color = LavenderTheme.Tertiary,
            modifier = Modifier.weight(1f)
        )
    }
}

/**
 * 视觉化统计项 (Bold Numeric)
 */
@Composable
private fun VisualStatItem(
    value: String,
    label: String,
    color: Color,
    modifier: Modifier = Modifier
) {
    // 简单的数字/单位分离逻辑
    val numberPart = value.filter { it.isDigit() || it == '.' }
    val unitPart = value.filterNot { it.isDigit() || it == '.' }

    Column(
        modifier = modifier,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // 使用 AnnotatedString 分离样式
        val text = buildAnnotatedString {
            withStyle(
                style = androidx.compose.ui.text.SpanStyle(
                    fontSize = 32.sp, // 大字号
                    fontWeight = FontWeight.Black, // 最粗体
                    color = color
                )
            ) {
                append(numberPart)
            }
            if (unitPart.isNotEmpty()) {
                withStyle(
                    style = androidx.compose.ui.text.SpanStyle(
                        fontSize = 14.sp, // 小字号单位
                        fontWeight = FontWeight.Bold,
                        color = color.copy(alpha = 0.8f) // 稍微浅一点
                    )
                ) {
                    append(" $unitPart".trim()) // 稍微加个空格如果需要
                }
            }
        }

        Text(
            text = text,
            lineHeight = 32.sp
        )
        Text(
            text = label,
            style = MaterialTheme.typography.labelMedium.copy( // 调大回 labelMedium
                fontWeight = FontWeight.Bold,
                letterSpacing = 0.5.sp // 稍微减小一点字间距以平衡
            ),
            color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.6f),
            modifier = Modifier.padding(top = 4.dp)
        )
    }
}

/**
 * Premium Card (V2: Clean White/Dark + Soft Shadow)
 */
@Composable
fun PremiumCard(
    onClick: (() -> Unit)? = null,
    modifier: Modifier = Modifier,
    content: @Composable ColumnScope.() -> Unit
) {
    val interactionSource = remember { MutableInteractionSource() }

    // Scale Animation if clickable
    val scale by if(onClick != null) {
        val isPressed by interactionSource.collectIsPressedAsState()
         animateFloatAsState(
            targetValue = if (isPressed) PRESS_SCALE else 1f,
            label = "cardScale",
            animationSpec = tween(ANIMATION_DURATION)
        )
    } else {
        remember { mutableFloatStateOf(1f) }
    }

    val isDark = MaterialTheme.colorScheme.background.luminance() < 0.5f
    // Light mode: Pure white + strong soft shadow. Dark mode: Surface Container + light shadow.
    val containerColor = if (isDark) MaterialTheme.colorScheme.surfaceContainer else Color.White
    val shadowElevation = if (isDark) 4.dp else 12.dp
    val shadowColor = if (isDark) Color.Black.copy(alpha = 0.3f) else Color.Black.copy(alpha = 0.05f) // Very soft ambient shadow

    Surface(
        onClick = onClick ?: {},
        enabled = onClick != null,
        shape = RoundedCornerShape(24.dp),
        color = containerColor,
        modifier = modifier
            .fillMaxWidth()
            .graphicsLayer {
                scaleX = scale
                scaleY = scale
            }
            .shadow(
                elevation = shadowElevation,
                shape = RoundedCornerShape(24.dp),
                spotColor = shadowColor,
                ambientColor = shadowColor
            ),
        interactionSource = interactionSource,
        content = { Column(content = content) }
    )
}

/**
 * 复习与训练 Box
 */
@Composable
fun ReviewSection(
    isDarkTheme: Boolean,
    cardColor: Color,
    onDueReviewClick: () -> Unit,
    onCategoryPracticeClick: () -> Unit
) {
    Column(modifier = Modifier.fillMaxWidth()) {
        SectionTitle("复习与训练")

        PremiumCard {
            Column(modifier = Modifier.padding(8.dp)) {
                SquircleListItem(
                    icon = Icons.Rounded.Schedule,
                    color = NemoPrimary,
                    title = "今日到期复习",
                    subtitle = "核心复习任务",
                    onClick = onDueReviewClick,
                    showDivider = true
                )
                SquircleListItem(
                    icon = Icons.Rounded.SportsEsports,
                    color = NemoSecondary,
                    title = "专项训练",
                    subtitle = "针对性强化练习",
                    onClick = onCategoryPracticeClick,
                    showDivider = false
                )
            }
        }
    }
}

/**
 * 数据与资料 Box
 */
@Composable
fun DataAndResourcesSection(
    isDarkTheme: Boolean,
    cardColor: Color,
    onStatisticsClick: () -> Unit,
    onLearningCalendarClick: () -> Unit,
    onHistoricalStatisticsClick: () -> Unit,
    onWordListClick: () -> Unit,
    onGrammarListClick: () -> Unit,
    onCategoryClassificationClick: () -> Unit,
    onLeechManagementClick: () -> Unit
) {
     Column(modifier = Modifier.fillMaxWidth()) {
        SectionTitle("数据与资料")

        PremiumCard {
             Column(modifier = Modifier.padding(8.dp)) {
                SquircleListItem(
                    icon = Icons.Rounded.BubbleChart,
                    color = NemoPrimary,
                    title = "学习日历",
                    subtitle = "查看学习计划与记录",
                    onClick = onLearningCalendarClick
                )
                 SquircleListItem(
                    icon = Icons.Rounded.QueryStats,
                    color = NemoDanger,
                    title = "今日统计",
                    subtitle = "详细学习统计",
                    onClick = onStatisticsClick
                )
                SquircleListItem(
                    icon = Icons.Rounded.Insights,
                    color = Color(0xFFAF52DE), // Purple
                    title = "历史统计",
                    subtitle = "长周期学习报告",
                    onClick = onHistoricalStatisticsClick
                )
                 SquircleListItem(
                    icon = Icons.Rounded.SortByAlpha,
                    color = NemoSecondary,
                    title = "单词列表",
                    subtitle = "词汇库管理",
                    onClick = onWordListClick
                )
                 SquircleListItem(
                    icon = Icons.Rounded.Dataset,
                    color = NemoPrimary,
                    title = "专项词汇",
                    subtitle = "按分类查看词汇",
                    onClick = onCategoryClassificationClick
                )
                SquircleListItem(
                    icon = Icons.Rounded.Book,
                    color = NemoPrimary,
                    title = "语法列表",
                    subtitle = "语法知识库",
                    onClick = onGrammarListClick
                )
                SquircleListItem(
                    icon = Icons.Rounded.AutoFixHigh,
                    color = NemoDanger,
                    title = "复学清单",
                    subtitle = "难点项召回与复习",
                    onClick = onLeechManagementClick,
                    showDivider = false
                )
             }
        }
     }
}

@Composable
fun SectionTitle(text: String) {
    Text(
        text = text,
        style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold),
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        modifier = Modifier.padding(horizontal = 12.dp, vertical = 12.dp)
    )
}

/**
 * ListItem with "Squircle" Icon (Apple Settings Style)
 */
@Composable
fun SquircleListItem(
    icon: ImageVector,
    color: Color,
    title: String,
    subtitle: String,
    onClick: () -> Unit,
    showDivider: Boolean = true
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(horizontal = 16.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Squircle Icon
        Box(
            modifier = Modifier
                .size(42.dp)
                .background(color.copy(alpha = 0.15f), RoundedCornerShape(12.dp)), // Squircle approx
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = icon,
                contentDescription = null,
                tint = color,
                modifier = Modifier.size(22.dp)
            )
        }

        Spacer(modifier = Modifier.width(16.dp))

        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = title,
                style = MaterialTheme.typography.bodyLarge.copy(fontWeight = FontWeight.SemiBold),
                color = MaterialTheme.colorScheme.onSurface
            )
            Text(
                text = subtitle,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }

        Icon(
            imageVector = Icons.AutoMirrored.Rounded.ArrowForwardIos,
            contentDescription = null,
            tint = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.4f),
            modifier = Modifier.size(14.dp)
        )
    }

    if (showDivider) {
        HorizontalDivider(
            modifier = Modifier.padding(start = 74.dp), // Align with text start
            color = MaterialTheme.colorScheme.outlineVariant.copy(alpha = 0.2f),
            thickness = 0.5.dp
        )
    }
}
