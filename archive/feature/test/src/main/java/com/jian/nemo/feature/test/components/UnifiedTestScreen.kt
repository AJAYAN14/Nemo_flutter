package com.jian.nemo.feature.test.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

/**
 * 统一测试界面框架
 * 完全复刻旧项目 com.jian.nemo.ui.screen.test.components.UnifiedTestScreen
 *
 * 依据：E:\AndroidProjects\Nemo\_reference\old-nemo\app\src\main\java\com\jian\nemo\ui\screen\test\components\UnifiedTestScreen.kt (L45-94)
 */
@Composable
fun UnifiedTestScreen(
    headerContent: @Composable () -> Unit,
    progressContent: @Composable () -> Unit,
    testContent: @Composable () -> Unit,
    footerContent: @Composable () -> Unit,
    modifier: Modifier = Modifier
) {
    Box(
        modifier = modifier
            .fillMaxSize()
            .background(
                brush = androidx.compose.ui.graphics.Brush.verticalGradient(
                    colors = listOf(
                        MaterialTheme.colorScheme.primary.copy(alpha = 0.05f),
                        MaterialTheme.colorScheme.background
                    )
                )
            )
            .windowInsetsPadding(WindowInsets.statusBars)
    ) {
        // 可滚动内容区域
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp)
                .padding(bottom = 120.dp) // 为底部按钮留出空间
        ) {
            headerContent()
            Spacer(modifier = Modifier.height(16.dp))
            progressContent()
            Spacer(modifier = Modifier.height(16.dp))
            testContent()
        }

        // 固定底部按钮区域
        Box(
            modifier = Modifier
                .align(Alignment.BottomCenter)
                .fillMaxWidth()
                .background(MaterialTheme.colorScheme.background)
                .padding(horizontal = 16.dp)
                .padding(bottom = 16.dp)
        ) {
            footerContent()
        }
    }
}
