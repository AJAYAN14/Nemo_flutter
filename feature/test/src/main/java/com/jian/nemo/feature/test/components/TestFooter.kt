package com.jian.nemo.feature.test.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

/**
 * 通用测试底部按钮组件
 * 复刻旧项目 com.jian.nemo.ui.screen.test.components.TestFooter
 */
@Composable
fun TestFooter(
    onPrev: () -> Unit,
    onNext: () -> Unit,
    onSubmit: () -> Unit,
    onFinish: () -> Unit,
    canGoPrev: Boolean = true,
    canSubmit: Boolean = true,
    isAnswered: Boolean = false,
    isLastQuestion: Boolean = false,
    submitText: String = "提交",
    isAutoAdvancing: Boolean = false
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 16.dp),
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        AnimatedButton(
            text = "上一题",
            onClick = onPrev,
            modifier = Modifier.weight(1f),
            enabled = canGoPrev,
            isOutlined = true
        )

        val mainButtonText = when {
            !isAnswered -> submitText
            isLastQuestion -> "完成测试"
            else -> "下一题"
        }

        AnimatedButton(
            text = mainButtonText,
            onClick = {
                when {
                    !isAnswered -> onSubmit()
                    isLastQuestion -> onFinish()
                    else -> onNext()
                }
            },
            modifier = Modifier.weight(1f),
            enabled = canSubmit && !isAutoAdvancing
        )
    }
}
