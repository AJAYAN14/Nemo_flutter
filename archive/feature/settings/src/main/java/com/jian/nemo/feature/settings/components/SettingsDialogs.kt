package com.jian.nemo.feature.settings.components

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.platform.testTag
import com.jian.nemo.feature.settings.ConflictResolutionOption

/**
 * 冲突解决对话框 (V2: Pro Max Style)
 */
@Composable
fun ConflictResolutionDialog(
    conflictCount: Int,
    onDismiss: () -> Unit,
    onResolve: (ConflictResolutionOption) -> Unit,
    useDarkTheme: Boolean = isSystemInDarkTheme()
) {
    // UI/UX Pro Max Colors & Styles (Blue Theme for Process/Sync)
    val primaryColor = if (useDarkTheme) Color(0xFF0A84FF) else Color(0xFF007AFF)
    val containerColor = if (useDarkTheme) Color(0xFF1C1C1E) else Color(0xFFFFFFFF)
    val titleColor = if (useDarkTheme) Color.White else Color.Black
    val bodyColor = if (useDarkTheme) Color(0xFF8E8E93) else Color(0xFF6E6E73)
    val errorActionColor = if (useDarkTheme) Color(0xFFFF453A) else Color(0xFFFF3B30)

    androidx.compose.ui.window.Dialog(onDismissRequest = onDismiss) {
        Surface(
            shape = RoundedCornerShape(26.dp),
            color = containerColor,
            tonalElevation = 0.dp,
            shadowElevation = 16.dp,
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 6.dp)
        ) {
            Column(
                modifier = Modifier.padding(32.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                // 1. Header Icon
                Box(
                    contentAlignment = Alignment.Center,
                    modifier = Modifier
                        .size(64.dp)
                        .background(
                            color = primaryColor.copy(alpha = 0.1f),
                            shape = CircleShape
                        )
                ) {
                    Icon(
                        imageVector = Icons.Rounded.CloudSync,
                        contentDescription = null,
                        modifier = Modifier.size(32.dp),
                        tint = primaryColor
                    )
                }

                Spacer(modifier = Modifier.height(20.dp))

                // 2. Title
                Text(
                    text = "解决同步冲突",
                    style = MaterialTheme.typography.titleLarge.copy(
                        fontWeight = FontWeight.Bold,
                        letterSpacing = 0.5.sp
                    ),
                    textAlign = TextAlign.Center,
                    color = titleColor
                )

                Spacer(modifier = Modifier.height(12.dp))

                // 3. Content
                Text(
                    text = "检测到 $conflictCount 个数据冲突。请选择您的解决方案：",
                    style = MaterialTheme.typography.bodyMedium.copy(
                        lineHeight = 22.sp
                    ),
                    textAlign = TextAlign.Center,
                    color = bodyColor
                )

                Spacer(modifier = Modifier.height(24.dp))

                // Options explanation Card
                Surface(
                    color = if (useDarkTheme) Color(0xFF2C2C2E) else Color(0xFFF2F2F7),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Text(
                            text = "• 保留云端：使用云端数据覆盖本地。",
                            style = MaterialTheme.typography.bodySmall,
                            color = bodyColor
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "• 保留本地：强制上传本地数据覆盖云端。",
                            style = MaterialTheme.typography.bodySmall,
                            color = bodyColor
                        )
                    }
                }

                Spacer(modifier = Modifier.height(32.dp))

                // 4. Actions
                Button(
                    onClick = { onResolve(ConflictResolutionOption.FORCE_CLOUD) },
                    shape = CircleShape,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(52.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = primaryColor,
                        contentColor = Color.White
                    ),
                    elevation = ButtonDefaults.buttonElevation(defaultElevation = 0.dp)
                ) {
                    Text("保留云端 (推荐)", fontWeight = FontWeight.Bold)
                }

                Spacer(modifier = Modifier.height(12.dp))

                TextButton(
                    onClick = { onResolve(ConflictResolutionOption.FORCE_LOCAL) },
                    shape = CircleShape,
                    modifier = Modifier.fillMaxWidth().height(48.dp),
                    colors = ButtonDefaults.textButtonColors(contentColor = errorActionColor)
                ) {
                    Text("保留本地并覆盖云端", fontWeight = FontWeight.SemiBold)
                }

                Spacer(modifier = Modifier.height(8.dp))

                TextButton(
                    onClick = onDismiss,
                    shape = CircleShape,
                    modifier = Modifier.fillMaxWidth().height(48.dp)
                ) {
                    Text("取消", color = bodyColor, fontWeight = FontWeight.Medium)
                }
            }
        }
    }
}

/**
 * 重置确认对话框 (V2: Pro Max Style)
 */
@Composable
fun ConfirmResetDialog(
    isResetting: Boolean = false,
    errorMessage: String? = null,
    isLoggedIn: Boolean = false,
    onDismiss: () -> Unit,
    onConfirm: (Boolean) -> Unit,
    useDarkTheme: Boolean = isSystemInDarkTheme()
) {
    // UI/UX Pro Max Colors & Styles (Red Theme for Danger)
    val primaryColor = if (useDarkTheme) Color(0xFFFF453A) else Color(0xFFFF3B30)
    val containerColor = if (useDarkTheme) Color(0xFF1C1C1E) else Color(0xFFFFFFFF)
    val titleColor = if (useDarkTheme) Color.White else Color.Black
    val bodyColor = if (useDarkTheme) Color(0xFF8E8E93) else Color(0xFF6E6E73)

    var includeCloud by remember { mutableStateOf(false) }

    androidx.compose.ui.window.Dialog(
        onDismissRequest = { if (!isResetting) onDismiss() }
    ) {
        Surface(
            shape = RoundedCornerShape(26.dp),
            color = containerColor,
            tonalElevation = 0.dp,
            shadowElevation = 16.dp,
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 6.dp)
        ) {
            Column(
                modifier = Modifier.padding(32.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                // 1. Header Icon
                Box(
                    contentAlignment = Alignment.Center,
                    modifier = Modifier
                        .size(64.dp)
                        .background(
                            color = primaryColor.copy(alpha = 0.1f),
                            shape = CircleShape
                        )
                ) {
                    Icon(
                        imageVector = Icons.Rounded.DeleteForever,
                        contentDescription = null,
                        modifier = Modifier.size(32.dp),
                        tint = primaryColor
                    )
                }

                Spacer(modifier = Modifier.height(20.dp))

                // 2. Title
                Text(
                    text = "确认重置",
                    style = MaterialTheme.typography.titleLarge.copy(
                        fontWeight = FontWeight.Bold,
                        letterSpacing = 0.5.sp
                    ),
                    textAlign = TextAlign.Center,
                    color = titleColor
                )

                Spacer(modifier = Modifier.height(12.dp))

                // 3. Content
                Text(
                    text = "您确定要重置所有学习进度吗？此操作将永久删除本地所有进度数据，且无法撤销。",
                    style = MaterialTheme.typography.bodyMedium.copy(
                        lineHeight = 22.sp
                    ),
                    textAlign = TextAlign.Center,
                    color = bodyColor
                )

                if (isLoggedIn) {
                    Spacer(modifier = Modifier.height(16.dp))
                    Surface(
                         color = if (useDarkTheme) Color(0xFF2C2C2E) else Color(0xFFF2F2F7),
                         shape = RoundedCornerShape(12.dp),
                         modifier = Modifier.fillMaxWidth().clickable { if (!isResetting) includeCloud = !includeCloud }
                    ) {
                        Row(
                            modifier = Modifier.padding(12.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Checkbox(
                                checked = includeCloud,
                                onCheckedChange = { if (!isResetting) includeCloud = it },
                                colors = CheckboxDefaults.colors(
                                    checkedColor = primaryColor,
                                    uncheckedColor = bodyColor
                                )
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                             Text(
                                text = "同时删除云端同步数据",
                                style = MaterialTheme.typography.bodyMedium,
                                color = titleColor
                            )
                        }
                    }
                }

                if (isResetting) {
                    Spacer(modifier = Modifier.height(24.dp))
                    CircularProgressIndicator(
                        modifier = Modifier.size(24.dp),
                        color = primaryColor,
                        strokeWidth = 3.dp
                    )
                }

                if (errorMessage != null) {
                    Spacer(modifier = Modifier.height(16.dp))
                    Text(
                        text = errorMessage,
                        color = primaryColor,
                        style = MaterialTheme.typography.bodySmall,
                        textAlign = TextAlign.Center
                    )
                }

                Spacer(modifier = Modifier.height(32.dp))

                // 4. Actions
                Button(
                    onClick = { onConfirm(includeCloud) },
                    enabled = !isResetting,
                    shape = CircleShape,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(52.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = primaryColor,
                        contentColor = Color.White
                    ),
                    elevation = ButtonDefaults.buttonElevation(defaultElevation = 0.dp)
                ) {
                    Text(if (isResetting) "正在重置..." else "确认重置", fontWeight = FontWeight.Bold)
                }

                Spacer(modifier = Modifier.height(12.dp))

                TextButton(
                    onClick = onDismiss,
                    enabled = !isResetting,
                    shape = CircleShape,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(48.dp)
                ) {
                    Text("取消", color = bodyColor, fontWeight = FontWeight.Medium)
                }
            }
        }
    }
}

/**
 * 高级学习设置 BottomSheet (V2: Premium Squircle Style)
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AdvancedLearningSettingsBottomSheet(
    learningSteps: String,
    relearningSteps: String,
    learnAheadLimit: Int,
    leechThreshold: Int,
    leechAction: String,
    onDismiss: () -> Unit,
    onSave: (String, String, Int, Int, String) -> Unit
) {
    var stepsInput by remember { mutableStateOf(learningSteps) }
    var relearningStepsInput by remember { mutableStateOf(relearningSteps) }
    var limitInput by remember { mutableFloatStateOf(learnAheadLimit.toFloat()) }
    var leechThresholdInput by remember { mutableIntStateOf(leechThreshold.coerceIn(1, 12)) }
    var leechActionInput by remember {
        mutableStateOf(if (leechAction == "bury_today") "bury_today" else "skip")
    }
    val accentColor = Color(0xFFAF52DE) // NemoPurple

    ModalBottomSheet(
        onDismissRequest = onDismiss,
        containerColor = MaterialTheme.colorScheme.surface,
        dragHandle = { BottomSheetDefaults.DragHandle() }
    ) {
        Column(
            modifier = Modifier
                .padding(bottom = 32.dp)
                .verticalScroll(rememberScrollState())
        ) {
            // Header
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 24.dp, vertical = 16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .size(40.dp)
                        .background(accentColor.copy(alpha = 0.15f), RoundedCornerShape(12.dp)),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.Rounded.Settings,
                        contentDescription = null,
                        tint = accentColor,
                        modifier = Modifier.size(20.dp)
                    )
                }
                Spacer(modifier = Modifier.width(16.dp))
                Column {
                    Text(
                        text = "记忆算法配置",
                        style = MaterialTheme.typography.titleLarge.copy(fontWeight = FontWeight.Bold),
                        color = MaterialTheme.colorScheme.onSurface
                    )
                    Spacer(modifier = Modifier.height(2.dp))
                    Text(
                        text = "调整间隔重复 (SRS) 核心参数",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }

            HorizontalDivider(
                color = MaterialTheme.colorScheme.outlineVariant.copy(alpha = 0.2f),
                modifier = Modifier.padding(bottom = 24.dp)
            )

            Column(modifier = Modifier.padding(horizontal = 24.dp)) {

                // Warning / Info Card
                Surface(
                    color = MaterialTheme.colorScheme.secondaryContainer.copy(alpha = 0.4f),
                    shape = RoundedCornerShape(16.dp),
                    modifier = Modifier.fillMaxWidth().padding(bottom = 24.dp)
                ) {
                    Row(
                        modifier = Modifier.padding(16.dp),
                        verticalAlignment = Alignment.Top
                    ) {
                        Icon(
                            imageVector = Icons.Rounded.Info,
                            contentDescription = null,
                            tint = MaterialTheme.colorScheme.onSecondaryContainer,
                            modifier = Modifier.size(20.dp).padding(top = 2.dp)
                        )
                        Spacer(modifier = Modifier.width(12.dp))
                        Column {
                            Text(
                                text = "参数说明",
                                style = MaterialTheme.typography.labelLarge.copy(fontWeight = FontWeight.Bold),
                                color = MaterialTheme.colorScheme.onSecondaryContainer
                            )
                            Spacer(modifier = Modifier.height(4.dp))
                            Text(
                                text = "此配置将改变新卡片的学习流程。错误的设置可能导致不得不频繁进行无效复习。",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSecondaryContainer.copy(alpha = 0.8f)
                            )
                        }
                    }
                }

                // 1. Learning Steps
                Text(
                    text = "学习阶段 (Steps)",
                    style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.SemiBold),
                    color = MaterialTheme.colorScheme.onSurface
                )
                Spacer(modifier = Modifier.height(8.dp))

                OutlinedTextField(
                    value = stepsInput,
                    onValueChange = { stepsInput = it },
                    placeholder = { Text("1 10") },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(16.dp),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = accentColor,
                        unfocusedBorderColor = MaterialTheme.colorScheme.outlineVariant,
                    )
                )
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = "使用空格分隔的分钟数。默认为 '1 10'。\n表示：新卡片 -> 1分钟后复习 -> 10分钟后复习 -> 毕业。",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    lineHeight = 16.sp
                )

                Spacer(modifier = Modifier.height(24.dp))

                // 2. Relearning Steps
                Text(
                    text = "重学阶段 (Relearning Steps)",
                    style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.SemiBold),
                    color = MaterialTheme.colorScheme.onSurface
                )
                Spacer(modifier = Modifier.height(8.dp))

                OutlinedTextField(
                    value = relearningStepsInput,
                    onValueChange = { relearningStepsInput = it },
                    placeholder = { Text("1 10") },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(16.dp),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = accentColor,
                        unfocusedBorderColor = MaterialTheme.colorScheme.outlineVariant,
                    )
                )
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = "忘记已学会的卡片时的复习步骤。默认为 '1 10'。\n表示：忘记卡片 -> 1分钟后复习 -> 10分钟后复习 -> 重新回到复习队列。",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    lineHeight = 16.sp
                )

                Spacer(modifier = Modifier.height(32.dp))

                // 2. Learn Ahead Limit
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "提前复习阈值",
                        style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.SemiBold),
                        color = MaterialTheme.colorScheme.onSurface
                    )

                    Surface(
                        color = accentColor.copy(alpha = 0.1f),
                        shape = RoundedCornerShape(8.dp)
                    ) {
                        Text(
                            text = "${limitInput.toInt()} 分钟",
                            style = MaterialTheme.typography.labelLarge.copy(fontWeight = FontWeight.Bold),
                            color = accentColor,
                            modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp)
                        )
                    }
                }

                Slider(
                    value = limitInput,
                    onValueChange = { limitInput = it },
                    valueRange = 0f..60f,
                    steps = 59,
                    modifier = Modifier.fillMaxWidth(),
                    colors = SliderDefaults.colors(
                        thumbColor = accentColor,
                        activeTrackColor = accentColor,
                        inactiveTrackColor = accentColor.copy(alpha = 0.2f)
                    )
                )
                Text(
                    text = "当卡片剩余冷却时间小于此值时，允许立即复习，无需等待。",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )

                Spacer(modifier = Modifier.height(32.dp))

                // 3. Leech Threshold
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "Leech 阈值（累计失败）",
                        style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.SemiBold),
                        color = MaterialTheme.colorScheme.onSurface
                    )

                    Surface(
                        color = accentColor.copy(alpha = 0.1f),
                        shape = RoundedCornerShape(8.dp)
                    ) {
                        Text(
                            text = "$leechThresholdInput 次",
                            style = MaterialTheme.typography.labelLarge.copy(fontWeight = FontWeight.Bold),
                            color = accentColor,
                            modifier = Modifier
                                .padding(horizontal = 12.dp, vertical = 6.dp)
                                .testTag("leech_threshold_value")
                        )
                    }
                }

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    OutlinedButton(
                        onClick = { leechThresholdInput = (leechThresholdInput - 1).coerceAtLeast(1) },
                        modifier = Modifier
                            .weight(1f)
                            .testTag("leech_threshold_minus")
                    ) {
                        Text("-1")
                    }

                    OutlinedButton(
                        onClick = { leechThresholdInput = (leechThresholdInput + 1).coerceAtMost(12) },
                        modifier = Modifier
                            .weight(1f)
                            .testTag("leech_threshold_plus")
                    ) {
                        Text("+1")
                    }
                }

                Text(
                    text = "达到阈值后执行下方行为。默认 5 次。",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )

                Spacer(modifier = Modifier.height(24.dp))

                // 4. Leech Action
                Text(
                    text = "Leech 处理方式",
                    style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.SemiBold),
                    color = MaterialTheme.colorScheme.onSurface
                )

                Surface(
                    color = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.35f),
                    shape = RoundedCornerShape(14.dp),
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(top = 8.dp)
                        .testTag("leech_action_skip_row")
                        .clickable { leechActionInput = "skip" }
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 12.dp, vertical = 10.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        RadioButton(
                            selected = leechActionInput == "skip",
                            onClick = { leechActionInput = "skip" }
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Column {
                            Text("暂停卡片（skip）", fontWeight = FontWeight.SemiBold)
                            Text(
                                "命中后不再进入常规复习队列",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                    }
                }

                Surface(
                    color = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.35f),
                    shape = RoundedCornerShape(14.dp),
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(top = 10.dp)
                        .testTag("leech_action_bury_row")
                        .clickable { leechActionInput = "bury_today" }
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 12.dp, vertical = 10.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        RadioButton(
                            selected = leechActionInput == "bury_today",
                            onClick = { leechActionInput = "bury_today" }
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Column {
                            Text("仅埋到明天（bury_today）", fontWeight = FontWeight.SemiBold)
                            Text(
                                "今天不再出现，明天自动回队列",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                    }
                }

                Spacer(modifier = Modifier.height(48.dp))

                // Save Button
                Button(
                    onClick = {
                        if (stepsInput.isNotBlank() && relearningStepsInput.isNotBlank()) {
                             onSave(
                                 stepsInput,
                                 relearningStepsInput,
                                 limitInput.toInt(),
                                 leechThresholdInput,
                                 leechActionInput
                             )
                        }
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(56.dp)
                        .testTag("advanced_learning_save_button"),
                    shape = RoundedCornerShape(16.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = accentColor
                    ),
                    elevation = ButtonDefaults.buttonElevation(defaultElevation = 4.dp)
                ) {
                    Text(
                        text = "保存配置",
                        style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold)
                    )
                }
            }
        }
    }
}
