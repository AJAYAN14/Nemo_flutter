package com.jian.nemo.core.ui.component.splash

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.jian.nemo.core.designsystem.theme.NemoPrimary
import com.jian.nemo.core.designsystem.R
import kotlinx.coroutines.delay

/**
 * 应用启动屏
 * 移动自 :app 模块以支持跨模块共享
 */
@Composable
fun SplashScreen(
    isAuthReady: Boolean = true, // 默认 true 保持兼容，但在 NavHost 中应传入实际状态
    onTimeout: () -> Unit
) {
    var startAnimation by remember { mutableStateOf(false) }
    var animationFinished by remember { mutableStateOf(false) }

    // 动画状态
    val scale by animateFloatAsState(
        targetValue = if (startAnimation) 1f else 0.8f,
        animationSpec = tween(
            durationMillis = 1500,
            easing = {
                // 使用和 CSS 中 cubic-bezier(0.2, 0.8, 0.2, 1) 类似的效果
                val t = it - 1.0f
                t * t * t * t * t + 1.0f
            }
        ),
        label = "logoScale"
    )

    val alpha by animateFloatAsState(
        targetValue = if (startAnimation) 1f else 0f,
        animationSpec = tween(durationMillis = 1200),
        label = "contentAlpha"
    )

    // 启动动画
    LaunchedEffect(key1 = true) {
        startAnimation = true
        delay(2500) // 等待动画播放完成
        animationFinished = true
    }

    // 监听条件：动画完成 且 认证状态已检查
    LaunchedEffect(animationFinished, isAuthReady) {
        if (animationFinished && isAuthReady) {
            onTimeout()
        }
    }

    // 界面布局 - 使用主题色纯色背景
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(NemoPrimary),  // 主题蓝色纯色背景
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            // Logo
            // Note: R.drawable.ic_nemo_logo_n_only should be in core:designsystem
            Image(
                painter = painterResource(id = R.drawable.ic_nemo_logo_n_only),
                contentDescription = "Nemo Logo",
                modifier = Modifier
                    .size(260.dp)
                    .scale(scale)
                    .alpha(alpha)
            )

            Spacer(modifier = Modifier.height(24.dp))

            // App 名称
            Text(
                text = "Nemo",
                fontSize = 42.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White,  // 白色文字在蓝色背景上更清晰
                modifier = Modifier.alpha(alpha)
            )

            Spacer(modifier = Modifier.height(8.dp))

            // 标语
            Text(
                text = "解锁日语新视界",
                fontSize = 16.sp,
                fontWeight = FontWeight.Medium,
                color = Color.White.copy(alpha = 0.9f),  // 半透明白色，增强可读性
                letterSpacing = 1.sp,
                modifier = Modifier.alpha(alpha)
            )
        }
    }
}
