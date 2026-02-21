package com.jian.nemo.core.ui.component

import androidx.compose.animation.*
import androidx.compose.animation.core.*
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.rounded.MenuBook
import androidx.compose.material.icons.rounded.AccountCircle
import androidx.compose.material.icons.rounded.BarChart
import androidx.compose.material.icons.rounded.Interests
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.luminance
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.unit.dp

// 定义颜色常量
private val LearningCardBackgroundDark = Color(0xFF2c2c2c)

/**
 * Nemo应用底部导航栏
 *
 * 包含4个主要Tab：学习、进度、测试、个人
 * 移动自 :app 模块以支持跨模块共享
 */
@Composable
fun NemoBottomBar(
    currentRoute: String?,
    onNavigate: (String) -> Unit,
    modifier: Modifier = Modifier,
    visible: Boolean = true
) {
    // 根据主题判断深色/浅色模式
    val isDarkTheme = MaterialTheme.colorScheme.surface.luminance() < 0.5
    val navigationBarColor = if (isDarkTheme) LearningCardBackgroundDark else Color.White
    val unselectedColor = Color.Gray

    AnimatedVisibility(
        visible = visible,
        enter = slideInVertically { it } + fadeIn(animationSpec = tween(durationMillis = 300)),
        exit = slideOutVertically { it } + fadeOut(animationSpec = tween(durationMillis = 300))
    ) {
        NavigationBar(
            containerColor = navigationBarColor,
            tonalElevation = 0.dp,
            modifier = modifier
                .height(80.dp) // 固定高度，避免 NavigationBarItem 重组时触发测量波动
                .clip(RoundedCornerShape(topStart = 16.dp, topEnd = 16.dp))
        ) {
            BottomNavItem.entries.forEach { item ->
                val isSelected = currentRoute == item.route

                NavigationBarItem(
                    icon = {
                        Icon(
                            imageVector = item.icon,
                            contentDescription = item.title,
                            modifier = Modifier.size(24.dp)
                        )
                    },
                    label = { Text(item.title) },
                    selected = isSelected,
                    onClick = { onNavigate(item.route) },
                    colors = NavigationBarItemDefaults.colors(
                        selectedIconColor = MaterialTheme.colorScheme.primary,
                        selectedTextColor = MaterialTheme.colorScheme.primary,
                        unselectedIconColor = unselectedColor,
                        unselectedTextColor = unselectedColor,
                        indicatorColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.12f) // MD3浅色背景指示器
                    )
                )
            }
        }
    }
}

/**
 * 底部导航栏Tab项
 */
enum class BottomNavItem(
    val route: String,
    val title: String,
    val icon: ImageVector
) {
    LEARNING(
        route = "learning",
        title = "学习",
        icon = Icons.AutoMirrored.Rounded.MenuBook
    ),
    PROGRESS(
        route = "progress",
        title = "进度",
        icon = Icons.Rounded.BarChart
    ),
    TEST(
        route = "test",
        title = "测试",
        icon = Icons.Rounded.Interests
    ),
    SETTINGS(
        route = "settings",
        title = "个人",
        icon = Icons.Rounded.AccountCircle
    )
}
