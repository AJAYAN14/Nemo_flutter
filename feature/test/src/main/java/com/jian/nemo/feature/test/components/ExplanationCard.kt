package com.jian.nemo.feature.test.components

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.jian.nemo.core.domain.model.Word

import com.jian.nemo.core.domain.model.Grammar

/**
 * 语法/单词解析卡片
 * 展示详细的单词信息（中文、读音、例句）
 */
@Composable
fun ExplanationCard(
    word: Word? = null,
    grammar: Grammar? = null,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier.fillMaxWidth(),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f)) // 使用稍微不同的背景以便区分
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Text(
                text = "解析",
                style = MaterialTheme.typography.labelMedium,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.padding(bottom = 8.dp)
            )

            // 显示语法内容 (如果有)
            if (grammar != null) {
                // 1. 接续
                if (grammar.getAllConjunctions().isNotEmpty()) {
                    Text(
                        text = "接续",
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    Text(
                        text = grammar.getAllConjunctions().joinToString("\n"),
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurface,
                        modifier = Modifier.padding(bottom = 8.dp)
                    )
                }

                // 2. 说明 (作为"中文解释")
                Text(
                    text = grammar.getFirstExplanation(),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurface,
                    modifier = Modifier.padding(bottom = 8.dp)
                )

                // 3. 例句
                if (grammar.getAllExamples().isNotEmpty()) {
                    Text(
                        text = "例句",
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    grammar.getAllExamples().forEach { (ex, trans) ->
                        ExplanationItem(example = ex, gloss = trans)
                    }
                }

            } else if (word != null) {
                // 显示中文解释
                Text(
                    text = word.chinese,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurface,
                    modifier = Modifier.padding(bottom = 8.dp)
                )

                // 显示读音/连接方式
                if (word.hiragana.isNotEmpty()) {
                    Text(
                        text = "读音/连接：${word.hiragana}",
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurface,
                        modifier = Modifier.padding(bottom = 8.dp)
                    )
                }

                // 显示例句1
                if (!word.example1.isNullOrEmpty()) {
                    ExplanationItem(
                        example = word.example1,
                        gloss = word.gloss1
                    )
                }

                // 显示例句2
                if (!word.example2.isNullOrEmpty()) {
                    ExplanationItem(
                        example = word.example2,
                        gloss = word.gloss2
                    )
                }

                // 显示例句3
                if (!word.example3.isNullOrEmpty()) {
                    ExplanationItem(
                        example = word.example3,
                        gloss = word.gloss3
                    )
                }
            }
        }
    }
}

@Composable
private fun ExplanationItem(
    example: String?,
    gloss: String?
) {
    if (example == null) return

    Text(
        text = example,
        style = MaterialTheme.typography.bodyMedium,
        color = MaterialTheme.colorScheme.onSurface,
        modifier = Modifier.padding(bottom = 4.dp)
    )
    if (!gloss.isNullOrEmpty()) {
        Text(
            text = gloss,
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(bottom = 8.dp)
        )
    }
}
