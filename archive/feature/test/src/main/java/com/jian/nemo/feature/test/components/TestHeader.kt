package com.jian.nemo.feature.test.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.FavoriteBorder
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.jian.nemo.core.domain.model.Word
import com.jian.nemo.feature.test.presentation.theme.TestDanger

/**
 * 测试头部组件（包含返回按钮、倒计时和收藏按钮）
 * 复刻旧项目 com.jian.nemo.ui.screen.test.components.TestHeader
 */
import com.jian.nemo.core.domain.model.Grammar

@Composable
fun TestHeader(
    onBack: () -> Unit,
    timeLimitSeconds: Int,
    timeRemainingSeconds: Int,
    word: Word?,
    grammar: Grammar? = null,
    onToggleFavorite: (Int, Boolean) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 12.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        // 返回按钮
        IconButton(
            onClick = onBack,
            modifier = Modifier.size(40.dp)
        ) {
            Icon(
                Icons.AutoMirrored.Filled.ArrowBack,
                contentDescription = "返回菜单",
                tint = MaterialTheme.colorScheme.onBackground,
                modifier = Modifier.size(22.dp)
            )
        }

        // 添加倒计时显示
        if (timeLimitSeconds > 0) {
            val minutes = timeRemainingSeconds / 60
            val seconds = timeRemainingSeconds % 60
            val isRunningOut = timeRemainingSeconds < 60
            Text(
                text = "%02d:%02d".format(minutes, seconds),
                color = if (isRunningOut) TestDanger else MaterialTheme.colorScheme.onBackground,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(horizontal = 8.dp),
                fontFamily = FontFamily.Monospace
            )
        }

        // 收藏按钮
        // 只有当有单词信息时才显示收藏按钮（例如非打字题或已加载）
        // 收藏按钮
        // 只有当有单词或语法信息时才显示收藏按钮
        val isFavorite = word?.isFavorite == true || grammar?.isFavorite == true
        val itemId = word?.id ?: grammar?.id ?: 0

        if (itemId != 0) {
            IconButton(
                onClick = { onToggleFavorite(itemId, !isFavorite) },
                modifier = Modifier.size(40.dp)
            ) {
                Icon(
                    imageVector = if (isFavorite) Icons.Default.Favorite else Icons.Default.FavoriteBorder,
                    contentDescription = "收藏",
                    tint = if (isFavorite) TestDanger else MaterialTheme.colorScheme.onBackground,
                    modifier = Modifier.size(24.dp)
                )
            }
        }
    }

    // 添加底部边框
    HorizontalDivider(color = MaterialTheme.colorScheme.surfaceVariant, thickness = 1.dp)
}
