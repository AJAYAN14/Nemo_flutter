package com.jian.nemo.feature.test.presentation

// Imports (Ensure all necessary imports are present)
import android.annotation.SuppressLint
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.content.Context
import androidx.compose.animation.*
import androidx.compose.animation.core.tween
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Cancel
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.jian.nemo.core.domain.model.SortableChar
import com.jian.nemo.core.domain.model.TestQuestion
import com.jian.nemo.feature.test.TestViewModel

// ... (SortingScreen composable remains largely the same aside from passed modifiers if any, skipping to internal components)

/**
 * 排序题界面
 */
@OptIn(ExperimentalLayoutApi::class, ExperimentalAnimationApi::class)
@Composable
fun SortingScreen(
    viewModel: TestViewModel
) {
    val uiState by viewModel.uiState.collectAsState()
    val questions = uiState.questions

    AnimatedContent(
        targetState = uiState.currentIndex,
        transitionSpec = {
            if (targetState > initialState) {
                slideInHorizontally(animationSpec = tween(300)) { width -> width } togetherWith
                        slideOutHorizontally(animationSpec = tween(300)) { width -> -width }
            } else {
                slideInHorizontally(animationSpec = tween(300)) { width -> -width } togetherWith
                        slideOutHorizontally(animationSpec = tween(300)) { width -> width }
            }
        },
        label = "sorting_question_transition"
    ) { targetIndex ->
        val currentQuestion = questions.getOrNull(targetIndex) as? TestQuestion.Sorting ?: return@AnimatedContent

        com.jian.nemo.feature.test.components.UnifiedTestScreen(
            headerContent = {
                com.jian.nemo.feature.test.components.TestHeader(
                    onBack = { viewModel.confirmExitTest() },
                    timeLimitSeconds = uiState.timeLimitSeconds,
                    timeRemainingSeconds = uiState.timeRemainingSeconds,
                    word = currentQuestion.word,
                    onToggleFavorite = { wordId, isFavorite -> viewModel.toggleFavorite(wordId, isFavorite) }
                )
            },
            progressContent = {
                com.jian.nemo.feature.test.components.SimpleProgressIndicator(
                    current = uiState.questions.count { it.isAnswered },
                    total = uiState.questions.size
                )
            },
            testContent = {
                Column(
                    modifier = Modifier.fillMaxWidth().padding(horizontal = 24.dp), // Added padding
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    val isGrammarQuestion = currentQuestion.word.level.startsWith("Grammar:")

                    // Enhanced Typography
                    Text(
                        text = currentQuestion.word.chinese,
                        style = MaterialTheme.typography.displaySmall.copy(
                             fontWeight = FontWeight.Bold,
                             lineHeight = 40.sp
                        ),
                        textAlign = androidx.compose.ui.text.style.TextAlign.Center,
                         modifier = Modifier.padding(top = 16.dp)
                    )
                    Text(
                        text = if (isGrammarQuestion) {
                            "选择字符，按正确顺序排列"
                        } else {
                            "选择假名，按正确顺序排列"
                        },
                        style = MaterialTheme.typography.titleMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier.padding(top = 12.dp, bottom = 32.dp)
                    )

                    AnswerContainer(
                        question = currentQuestion,
                        userAnswer = uiState.userAnswerChars,
                        onDeselect = { char -> viewModel.deselectSortableChar(char) }
                    )

                    Spacer(modifier = Modifier.height(32.dp))

                    SortingFeedback(question = currentQuestion)

                    Spacer(modifier = Modifier.height(16.dp))

                    OptionsContainer(
                        options = currentQuestion.options,
                        onSelect = { char -> viewModel.selectSortableChar(char) }
                    )
                }
            },
            footerContent = {
                com.jian.nemo.feature.test.components.TestFooter(
                    onPrev = { viewModel.previousQuestion() },
                    onNext = { viewModel.nextQuestion() },
                    onSubmit = { viewModel.submitAnswer() },
                    onFinish = { viewModel.finishTest() },
                    canGoPrev = uiState.currentIndex > 0,
                    canSubmit = uiState.userAnswerChars.isNotEmpty(),
                    isAnswered = currentQuestion.isAnswered,
                    isLastQuestion = uiState.currentIndex == uiState.questions.size - 1,
                    submitText = "检查",
                    isAutoAdvancing = uiState.isAutoAdvancing
                )
            }
        )
    }
}

/**
 * 答案容器
 * Refactored to Flat UI
 */
@OptIn(ExperimentalLayoutApi::class)
@Composable
private fun AnswerContainer(
    question: TestQuestion.Sorting,
    userAnswer: List<SortableChar>,
    onDeselect: (SortableChar) -> Unit
) {
    val borderColor by animateColorAsState(
        targetValue = when {
            !question.isAnswered && userAnswer.isNotEmpty() -> MaterialTheme.colorScheme.primary
            question.isCorrect -> MaterialTheme.colorScheme.secondary // Greenish
            !question.isCorrect && question.isAnswered -> MaterialTheme.colorScheme.error
            else -> MaterialTheme.colorScheme.outlineVariant
        },
        label = "answerBorderColor"
    )

    FlowRow(
        modifier = Modifier
            .fillMaxWidth()
            .defaultMinSize(minHeight = 80.dp) // Taller min height
            .clip(RoundedCornerShape(16.dp)) // 16dp
            .border(
                width = if (userAnswer.isNotEmpty()) 2.dp else 1.dp,
                color = borderColor,
                shape = RoundedCornerShape(16.dp)
            )
            .background(MaterialTheme.colorScheme.surface) // Clean surface
            .padding(16.dp), // More padding
        horizontalArrangement = Arrangement.spacedBy(8.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        if (userAnswer.isEmpty()) {
            Box(modifier = Modifier.fillMaxWidth().height(48.dp), contentAlignment = Alignment.Center) {
                Text(
                    text = "在此处构建答案",
                    color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.5f),
                    style = MaterialTheme.typography.bodyLarge
                )
            }
        } else {
            userAnswer.forEach { char ->
                SortableChip(char = char, isSelected = true, onClick = { onDeselect(char) })
            }
        }
    }
}

/**
 * 选项容器
 */
@OptIn(ExperimentalLayoutApi::class)
@Composable
private fun OptionsContainer(
    options: List<SortableChar>,
    onSelect: (SortableChar) -> Unit
) {
    FlowRow(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(12.dp, Alignment.CenterHorizontally),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        options.forEach { char ->
            AnimatedVisibility(
                visible = !char.isSelected,
                enter = fadeIn() + scaleIn(initialScale = 0.8f),
                exit = scaleOut(targetScale = 0.0f) + fadeOut()
            ) {
                SortableChip(char = char, isSelected = false, onClick = { onSelect(char) })
            }
        }
    }
}

/**
 * 可排序字符卡片
 * Refactored to Flat UI
 */
@Composable
private fun SortableChip(
    char: SortableChar,
    isSelected: Boolean, // True = Used (in Answer Box), False = Available (in Options)
    onClick: () -> Unit
) {
    // Logic:
    // If in Options (isSelected=false): Surface + Border.
    // If in Answer (isSelected=true): Primary highlight or just Surface depending on design.
    // NOTE: The param `isSelected` here actually comes from the caller context.
    // In `AnswerContainer`, we pass isSelected=true. In `OptionsContainer`, we pass isSelected=false.

    val backgroundColor = if (isSelected)
        MaterialTheme.colorScheme.primaryContainer
    else
        MaterialTheme.colorScheme.surface

    val textColor = if (isSelected)
        MaterialTheme.colorScheme.onPrimaryContainer
    else
        MaterialTheme.colorScheme.onSurface

    val borderColor = if (isSelected)
        MaterialTheme.colorScheme.primary
    else
        MaterialTheme.colorScheme.outlineVariant

    val hapticFeedback = LocalHapticFeedback.current

    Surface(
        modifier = Modifier
            .clickable {
                hapticFeedback.performHapticFeedback(HapticFeedbackType.TextHandleMove)
                onClick()
            },
        shape = RoundedCornerShape(16.dp), // 16dp
        color = backgroundColor,
        border = BorderStroke(1.dp, borderColor),
        tonalElevation = 0.dp,
        shadowElevation = 0.dp
    ) {
        Text(
            text = char.char.toString(),
            modifier = Modifier.padding(horizontal = 20.dp, vertical = 12.dp),
            color = textColor,
            style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold)
        )
    }
}

/**
 * 排序题反馈
 * Refactored to OutlinedCard style
 */
@Composable
private fun SortingFeedback(question: TestQuestion.Sorting) {
    val context = LocalContext.current

    // 错误时触发震动
    LaunchedEffect(question.isAnswered, question.isCorrect) {
        if (question.isAnswered && !question.isCorrect) {
            // Suppress Permission Check: Manifest declared in app module
            @SuppressLint("MissingPermission")
            fun vibrateDevice() {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    val vibratorManager = context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
                    val vibrator = vibratorManager.defaultVibrator
                    vibrator.vibrate(VibrationEffect.createOneShot(80, VibrationEffect.DEFAULT_AMPLITUDE))
                } else {
                    @Suppress("DEPRECATION")
                    val vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        vibrator.vibrate(VibrationEffect.createOneShot(80, VibrationEffect.DEFAULT_AMPLITUDE))
                    } else {
                        @Suppress("DEPRECATION")
                        vibrator.vibrate(80)
                    }
                }
            }
            vibrateDevice()
        }
    }

    AnimatedVisibility(
        visible = question.isAnswered,
        enter = slideInVertically(initialOffsetY = { it / 2 }) + fadeIn(),
        exit = slideOutVertically(targetOffsetY = { it / 2 }) + fadeOut()
    ) {
         OutlinedCard(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.outlinedCardColors(
                containerColor = if (question.isCorrect)
                    MaterialTheme.colorScheme.secondaryContainer.copy(alpha = 0.1f)
                else
                    MaterialTheme.colorScheme.errorContainer.copy(alpha = 0.1f)
            ),
            border = BorderStroke(
                1.dp,
                if (question.isCorrect) MaterialTheme.colorScheme.secondary else MaterialTheme.colorScheme.error
            ),
            shape = RoundedCornerShape(16.dp)
        ) {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp)
            ) {
                if (question.isCorrect) {
                    Icon(
                        imageVector = Icons.Filled.CheckCircle,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.secondary,
                        modifier = Modifier.size(32.dp).padding(bottom = 8.dp)
                    )
                    Text(
                        text = "回答正确！",
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.secondary,
                        style = MaterialTheme.typography.titleMedium
                    )
                } else {
                    Icon(
                        imageVector = Icons.Filled.Cancel,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.error,
                        modifier = Modifier.size(32.dp).padding(bottom = 8.dp)
                    )
                    Text(
                        text = "回答错误",
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.error,
                        style = MaterialTheme.typography.titleMedium
                    )

                    Spacer(modifier = Modifier.height(8.dp))

                     Text(
                        text = "正确答案",
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    Text(
                        text = question.word.hiragana,
                        color = MaterialTheme.colorScheme.onSurface,
                        style = MaterialTheme.typography.headlineSmall.copy(fontWeight = FontWeight.Bold),
                        modifier = Modifier.padding(top = 2.dp)
                    )
                }
            }
        }
    }
}
