package com.jian.nemo.feature.learning.presentation.components.srs

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AutoAwesome
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.luminance
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.jian.nemo.feature.learning.presentation.components.common.scaleOnPress
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.ui.Alignment
import androidx.compose.ui.draw.clip
import com.jian.nemo.core.ui.util.SoundEffectPlayer

/**
 * SRS 操作区域组件 (100% 还原 HTML Bottom Action Bar)
 *
 * @param isAnswerShown 是否已显示答案
 * @param ratingIntervals 评分对应的预估间隔文本 (Map<Int, String>)
 * @param onShowAnswer 点击显示答案
 * @param onRate 点击评分
 */
@Composable
fun SRSActionArea(
    isAnswerShown: Boolean,
    ratingIntervals: Map<Int, String>,
    onShowAnswer: () -> Unit,
    onRate: (Int) -> Unit,
    modifier: Modifier = Modifier
) {
    val context = androidx.compose.ui.platform.LocalContext.current
    // 检测深色模式
    val isDarkTheme = MaterialTheme.colorScheme.background.luminance() < 0.5

    // 评分按钮颜色定义 - 根据 MD3 规范区分浅色/深色模式
    // 浅色模式：600-700 文字色 + 50-100 容器色（高饱和度，高对比）
    // 深色模式：200-300 文字色 + 800-900 容器色（降低饱和度，避免视觉振动）

    val colorRose700 = if (isDarkTheme) Color(0xFFFDA4AF) else Color(0xFFBE123C)      // 浅色700 / 深色300
    val colorRose100 = if (isDarkTheme) Color(0xFF4C0519) else Color(0xFFFFE4E6)      // 浅色100 / 深色900

    val colorRed600 = if (isDarkTheme) Color(0xFFFCA5A5) else Color(0xFFDC2626)       // 浅色600 / 深色300
    val colorRed50 = if (isDarkTheme) Color(0xFF7F1D1D) else Color(0xFFFEF2F2)        // 浅色50 / 深色900

    val colorOrange600 = if (isDarkTheme) Color(0xFFFDBA74) else Color(0xFFEA580C)    // 浅色600 / 深色300
    val colorOrange50 = if (isDarkTheme) Color(0xFF7C2D12) else Color(0xFFFFF7ED)     // 浅色50 / 深色900

    val colorYellow600 = if (isDarkTheme) Color(0xFFFDE047) else Color(0xFFCA8A04)    // 浅色600 / 深色300
    val colorYellow50 = if (isDarkTheme) Color(0xFF713F12) else Color(0xFFFEFCE8)     // 浅色50 / 深色900

    val colorBlue600 = if (isDarkTheme) Color(0xFF93C5FD) else Color(0xFF2563EB)      // 浅色600 / 深色300
    val colorBlue50 = if (isDarkTheme) Color(0xFF1E3A8A) else Color(0xFFEFF6FF)       // 浅色50 / 深色900

    val colorEmerald600 = if (isDarkTheme) Color(0xFF6EE7B7) else Color(0xFF059669)   // 浅色600 / 深色300
    val colorEmerald50 = if (isDarkTheme) Color(0xFF064E3B) else Color(0xFFECFDF5)    // 浅色50 / 深色900


    Column(
        modifier = modifier
            .fillMaxWidth()
            .windowInsetsPadding(WindowInsets.navigationBars) // 添加底部系统导航栏安全区域
            .padding(bottom = 16.dp) // 额外的内容间距
    ) {
        AnimatedContent(
            targetState = isAnswerShown,
            transitionSpec = {
                fadeIn(animationSpec = tween(300)) togetherWith fadeOut(animationSpec = tween(300))
            },
            label = "actionAreaTransition"
        ) { showAnswer ->
            if (!showAnswer) {
                // 显示答案按钮
                // 显示答案按钮
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(56.dp)
                        .scaleOnPress(onTap = onShowAnswer)
                        .shadow(8.dp, RoundedCornerShape(16.dp), ambientColor = Color.Gray, spotColor = Color.LightGray)
                        .background(Color(0xFF111827), RoundedCornerShape(16.dp)) // gray-900
                        .clip(RoundedCornerShape(16.dp)),
                    contentAlignment = Alignment.Center
                ) {
                    Row(
                        modifier = Modifier.padding(horizontal = 24.dp), // Add horizontal padding for safety
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.AutoAwesome, // Sparkles replacement
                            contentDescription = null,
                            tint = Color(0xFFFACC15), // yellow-400
                            modifier = Modifier.padding(end = 8.dp)
                        )
                        Text(
                            text = "显示答案",
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.White
                        )
                    }
                }
            } else {
                // 评分按钮网格 (Anki Mode: 4个按钮)
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    // 1. 重来 (Again) - Quality 1
                    SRSRatingButton(
                        label = "重来",
                        time = ratingIntervals[1] ?: "-",
                        color = colorRose700,
                        containerColor = colorRose100,
                        onClick = { 
                            SoundEffectPlayer.playOtherSound(context)
                            onRate(1) 
                        },
                        modifier = Modifier.weight(1f)
                    )

                    // 2. 困难 (Hard) - Quality 3
                    SRSRatingButton(
                        label = "困难",
                        time = ratingIntervals[3] ?: "-",
                        color = colorOrange600,
                        containerColor = colorOrange50,
                        onClick = { 
                            SoundEffectPlayer.playOtherSound(context)
                            onRate(3) 
                        },
                        modifier = Modifier.weight(1f)
                    )

                    // 3. 良好 (Good) - Quality 4
                    SRSRatingButton(
                        label = "良好",
                        time = ratingIntervals[4] ?: "-",
                        color = colorBlue600,
                        containerColor = colorBlue50,
                        onClick = { 
                            SoundEffectPlayer.playGoodSound(context)
                            onRate(4) 
                        },
                        modifier = Modifier.weight(1f)
                    )

                    // 4. 简单 (Easy) - Quality 5
                    SRSRatingButton(
                        label = "简单",
                        time = ratingIntervals[5] ?: "-",
                        color = colorEmerald600,
                        containerColor = colorEmerald50,
                        onClick = { 
                            SoundEffectPlayer.playGoodSound(context)
                            onRate(5) 
                        },
                        modifier = Modifier.weight(1f)
                    )
                }
            }
        }
    }
}
