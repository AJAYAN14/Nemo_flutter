package com.jian.nemo.feature.test.presentation.dashboard

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.rounded.ArrowForwardIos
import androidx.compose.material.icons.automirrored.rounded.Assignment
import androidx.compose.material.icons.rounded.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.luminance
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.jian.nemo.core.ui.component.SlidingDotIndicator
import com.jian.nemo.core.designsystem.theme.*
import kotlin.math.roundToInt

/**
 * 测试选择主界面 (V3 Grid & Dashboard Style)
 *
 * 采用 Grid 布局和 Banner 样式，打破列表的单调感，提升视觉丰富度。
 */
@OptIn(ExperimentalFoundationApi::class)
@Composable
fun TestDashboardScreen(
    viewModel: TestDashboardViewModel = hiltViewModel(),
    onNavigateBack: () -> Unit = {},
    onNavigateToTestSettings: (String?) -> Unit = {},
    onNavigateToMistakes: () -> Unit = {},
    onNavigateToFavorites: () -> Unit = {},
    onNavigateToGrammarTest: () -> Unit = {}
) {
    val uiState by viewModel.uiState.collectAsState()

    val backgroundColor = MaterialTheme.colorScheme.background

    // Edge-to-Edge
    val density = LocalDensity.current
    val statusBarHeight = with(density) { WindowInsets.statusBars.getTop(density).toDp() }
    val navigationBarHeight = with(density) { WindowInsets.navigationBars.getBottom(density).toDp() }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backgroundColor)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(
                    start = 16.dp,
                    end = 16.dp,
                    top = statusBarHeight + 16.dp,
                    bottom = navigationBarHeight + 100.dp
                )
        ) {
            // 大标题
            ImmersiveTestHeader(title = "测试")

            // 统计卡片 (Pager)
            // 统计卡片 (Pager)
            StatsPager(
                uiState = uiState
            )

            Spacer(modifier = Modifier.height(24.dp))

            // 复习与回顾 (2 Column Row)
            SectionTitle("复习与回顾")
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                DashboardTile(
                    modifier = Modifier.weight(1f),
                    title = "我的错题",
                    subtitle = "${uiState.wrongWordsCount} 个",
                    icon = Icons.Rounded.Cancel,
                    color = NemoDanger,
                    onClick = onNavigateToMistakes
                )
                DashboardTile(
                    modifier = Modifier.weight(1f),
                    title = "我的收藏",
                    subtitle = "${uiState.favoriteWordsCount} 个",
                    icon = Icons.Rounded.Star,
                    color = NemoOrange,
                    onClick = onNavigateToFavorites
                )
            }

            Spacer(modifier = Modifier.height(24.dp))

            // 基础练习 (2x2 Grid)
            SectionTitle("基础练习")
            Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    DashboardTile(
                        modifier = Modifier.weight(1f),
                        title = "选择题",
                        subtitle = "快速认知",
                        icon = Icons.AutoMirrored.Rounded.Assignment,
                        color = NemoSecondary,
                        onClick = { onNavigateToTestSettings("multiple_choice") }
                    )
                    DashboardTile(
                        modifier = Modifier.weight(1f),
                        title = "手打题",
                        subtitle = "拼写强化",
                        icon = Icons.Rounded.TextFields,
                        color = NemoIndigo,
                        onClick = { onNavigateToTestSettings("typing") }
                    )
                }
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    DashboardTile(
                        modifier = Modifier.weight(1f),
                        title = "卡片题",
                        subtitle = "翻牌记忆",
                        icon = Icons.Rounded.ViewModule,
                        color = NemoTeal,
                        onClick = { onNavigateToTestSettings("card_matching") }
                    )
                    DashboardTile(
                        modifier = Modifier.weight(1f),
                        title = "排序题",
                        subtitle = "逻辑构建",
                        icon = Icons.Rounded.Extension,
                        color = NemoPurple,
                        onClick = { onNavigateToTestSettings("sorting") }
                    )
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // 综合挑战 (Hero Banner)
            SectionTitle("挑战自我")
            DashboardBanner(
                title = "综合测试",
                subtitle = "随机组合所有题型进行全面检测",
                icon = Icons.Rounded.AllInclusive,
                gradientColors = listOf(NemoPrimary, NemoPrimary.copy(alpha = 0.8f)),
                onClick = { onNavigateToTestSettings("comprehensive") }
            )

            Spacer(modifier = Modifier.height(24.dp))
        }
    }
}

/**
 * 统计数据轮播页
 */
@OptIn(ExperimentalFoundationApi::class)
@Composable
private fun StatsPager(
    uiState: TestDashboardUiState
) {
    val pageCount = 10000
    val pagerState = rememberPagerState(
        initialPage = pageCount / 2,
        pageCount = { pageCount }
    )

    // Determine current page theme
    val currentPageIndex = pagerState.currentPage % 2
    val isClayTheme = currentPageIndex == 0

    // Select the theme object based on page
    val currentTheme = if (isClayTheme) ClayTheme else RoseTheme

    // 移除背景色修改，保持默认卡片样式 (CardBg is white in definition, effectively default)
    PremiumCard {
        Column {
            // Header
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 16.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = if (isClayTheme) "今日概览" else "总体统计",
                    style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold),
                    color = currentTheme.TitleText
                )

                Icon(
                    imageVector = if (isClayTheme) Icons.Rounded.Today else Icons.Rounded.Insights,
                    contentDescription = null,
                    tint = currentTheme.Primary,
                    modifier = Modifier
                        .size(32.dp)
                        .background(currentTheme.IconBg, CircleShape) // 使用 IconBg
                        .padding(6.dp)
                )
            }

            // Pager
            HorizontalPager(
                state = pagerState,
                modifier = Modifier.fillMaxWidth()
            ) { page ->
                val actualPage = page % 2

                Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                    when (actualPage) {
                        0 -> Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            VisualStatItem(
                                value = uiState.todayTestCount.toString(),
                                label = "今日已测",
                                color = ClayTheme.Primary, // Color 1: Primary
                                modifier = Modifier.weight(1f)
                            )
                            VisualStatItem(
                                value = "${(uiState.todayAccuracy * 100).roundToInt()}%",
                                label = "正确率",
                                color = ClayTheme.Secondary, // Color 2: Secondary
                                modifier = Modifier.weight(1f)
                            )
                            VisualStatItem(
                                value = "${uiState.consecutiveTestDays} 天",
                                label = "连签",
                                color = ClayTheme.Tertiary, // Color 3: Tertiary
                                modifier = Modifier.weight(1f)
                            )
                        }
                        1 -> Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            VisualStatItem(
                                value = uiState.totalTestCount.toString(),
                                label = "累计测试",
                                color = RoseTheme.Primary, // Color 4: Primary
                                modifier = Modifier.weight(1f)
                            )
                            VisualStatItem(
                                value = "${(uiState.overallAccuracy * 100).roundToInt()}%",
                                label = "总正确率",
                                color = RoseTheme.Secondary, // Color 5: Secondary
                                modifier = Modifier.weight(1f)
                            )
                            VisualStatItem(
                                value = "${uiState.maxTestStreak} 天",
                                label = "最高连签",
                                color = RoseTheme.Tertiary, // Color 6: Tertiary
                                modifier = Modifier.weight(1f)
                            )
                        }
                    }
                }
            }

            // 底部指示器
            SlidingDotIndicator(
                pagerState = pagerState,
                pageCount = 2,
                activeColor = currentTheme.Accent, // User specified Accent for active state
                inactiveColor = currentTheme.IconBg, // Use soft IconBg for inactive
                modifier = Modifier
                    .align(Alignment.CenterHorizontally)
                    .padding(top = 16.dp)
            )
        }
    }
}

/**
 * 仪表盘小方块 Tile 组件
 */
@Composable
private fun DashboardTile(
    modifier: Modifier = Modifier,
    title: String,
    subtitle: String,
    icon: ImageVector,
    color: Color,
    onClick: () -> Unit
) {
    Card(
        modifier = modifier
            .clickable(onClick = onClick),
        shape = RoundedCornerShape(20.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.dp), // 去除阴影
    ) {
        Row(
            modifier = Modifier
                .fillMaxSize()
                .padding(15.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Start
        ) {
            // Icon Box
            Box(
                modifier = Modifier
                    .size(42.dp)
                    .clip(RoundedCornerShape(12.dp))
                    .background(color.copy(alpha = 0.15f)),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = icon,
                    contentDescription = null,
                    tint = color,
                    modifier = Modifier.size(24.dp)
                )
            }

            Spacer(modifier = Modifier.width(12.dp))

            // Text Content
            Column(
                verticalArrangement = Arrangement.Center
            ) {
                Text(
                    text = title,
                    style = MaterialTheme.typography.titleMedium.copy(
                        fontWeight = FontWeight.Bold
                    ),
                    color = MaterialTheme.colorScheme.onSurface,
                    maxLines = 1
                )
                Spacer(modifier = Modifier.height(2.dp))
                Text(
                    text = subtitle,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    lineHeight = 14.sp,
                    maxLines = 1,
                )
            }
        }
    }
}

/**
 * 综合挑战 Banner 组件
 */
@Composable
private fun DashboardBanner(
    title: String,
    subtitle: String,
    icon: ImageVector,
    gradientColors: List<Color>,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .height(120.dp) // 固定高度 120dp
            .clickable(onClick = onClick),
        shape = RoundedCornerShape(24.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        // border removed as requested
        elevation = CardDefaults.cardElevation(defaultElevation = 0.dp),
    ) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 20.dp), // 调整 Padding 策略
            contentAlignment = Alignment.CenterStart // 内容垂直居中，水平靠左
        ) {
            // 背景装饰 (淡色大图标) - 移回右侧，微调位置避免裁切
            Icon(
                imageVector = icon,
                contentDescription = null,
                tint = gradientColors.first().copy(alpha = 0.08f),
                modifier = Modifier
                    .size(80.dp) // 稍微调小一点适应 120dp 高度
                    .align(Alignment.CenterEnd)
                    .offset(x = 10.dp) // 稍微向右偏移一点，制造溢出感但不被过度裁切
            )

            Column(modifier = Modifier.fillMaxWidth()) {
                Text(
                    text = title,
                    style = MaterialTheme.typography.titleLarge.copy(fontWeight = FontWeight.Bold),
                    color = MaterialTheme.colorScheme.primary
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = subtitle,
                    style = MaterialTheme.typography.bodyMedium.copy(fontWeight = FontWeight.Medium),
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}

@Composable
private fun PremiumCard(
    modifier: Modifier = Modifier,
    content: @Composable ColumnScope.() -> Unit
) {
    val isDark = MaterialTheme.colorScheme.background.luminance() < 0.5f
    val containerColor = if (isDark) MaterialTheme.colorScheme.surfaceContainer else Color.White
    val borderColor = if (isDark) MaterialTheme.colorScheme.outlineVariant.copy(alpha = 0.1f) else MaterialTheme.colorScheme.outlineVariant.copy(alpha = 0.2f)
    val shadowElevation = if (isDark) 2.dp else 10.dp
    val shadowColor = if (isDark) Color.Black.copy(alpha = 0.4f) else Color.Black.copy(alpha = 0.03f)

    Surface(
        shape = RoundedCornerShape(26.dp),
        color = containerColor,
        border = androidx.compose.foundation.BorderStroke(0.5.dp, borderColor),
        modifier = modifier
            .fillMaxWidth()
            .shadow(
                elevation = shadowElevation,
                shape = RoundedCornerShape(26.dp),
                spotColor = shadowColor,
                ambientColor = shadowColor
            )
    ) {
        Column(
            modifier = Modifier.padding(20.dp),
            content = content
        )
    }
}
