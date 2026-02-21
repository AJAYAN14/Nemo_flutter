package com.jian.nemo.feature.learning.presentation.home

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Book
import androidx.compose.material.icons.rounded.Create
import androidx.compose.material.icons.rounded.EmojiEvents
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.jian.nemo.core.designsystem.theme.NemoPrimary
import com.jian.nemo.feature.learning.presentation.LearningMode
import com.jian.nemo.feature.learning.presentation.components.sheets.LevelSelectionBottomSheet
import com.jian.nemo.feature.learning.presentation.home.components.*
import com.jian.nemo.feature.learning.R

/**
 * HomeScreen (V2.2 Solid Premium UI)
 *
 * 移除所有渐变，使用纯色高级排版。
 */
@Composable
fun HomeScreen(
    onNavigateToLearning: (String, LearningMode) -> Unit,
    onNavigateToWordList: () -> Unit,
    onNavigateToGrammarList: () -> Unit,
    onNavigateToHeatmap: () -> Unit, // Added
    viewModel: HomeViewModel = hiltViewModel()
) {
    val uiState by viewModel.uiState.collectAsState()
    val backgroundColor = MaterialTheme.colorScheme.background

    // Level Selection Bottom Sheet
    if (uiState.showLevelSheet) {
        LevelSelectionBottomSheet(
            show = true,
            title = if (uiState.learningMode == LearningMode.Word)
                stringResource(R.string.title_select_word_level)
            else
                stringResource(R.string.title_select_grammar_level),
            levels = uiState.levels,
            selectedLevel = uiState.selectedLevel,
            onDismiss = { viewModel.toggleLevelSheet(false) },
            onLevelSelected = {
                viewModel.selectLevel(it)
                viewModel.toggleLevelSheet(false)
            }
        )
    }

    // Edge-to-Edge Calculation
    val density = LocalDensity.current
    val statusBarHeight = with(density) { WindowInsets.statusBars.getTop(density).toDp() }
    val navigationBarHeight = with(density) { WindowInsets.navigationBars.getBottom(density).toDp() }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backgroundColor)
    ) {
        LazyColumn(
            modifier = Modifier.fillMaxSize(),
            contentPadding = PaddingValues(
                start = 16.dp,
                end = 16.dp,
                top = statusBarHeight + 16.dp,
                bottom = navigationBarHeight + 104.dp
            ),
            verticalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            // 1. Header (Solid)
            item {
                HomeUnifiedHeader(
                    title = "今日学习",
                    bgText = "NEMO"
                )
            }

            // 2. Goal Card (V3.2 Solid Premium)
            item {
                HomeGoalCard(
                    currentProgress = uiState.currentProgress,
                    dailyGoal = uiState.dailyGoal,
                    progressFraction = uiState.progressFraction,
                    itemsDue = uiState.itemsDue,
                    learningMode = uiState.learningMode,
                    selectedLevel = uiState.selectedLevel,
                    onSetMode = { viewModel.setLearningMode(it) },
                    onToggleLevelSheet = { viewModel.toggleLevelSheet(true) },
                    onNavigateToLearning = {
                        onNavigateToLearning(uiState.selectedLevel, uiState.learningMode)
                    },
                    hasCurrentModeSession = uiState.hasCurrentModeSession,
                    modifier = Modifier.padding(vertical = 12.dp)
                )
            }

            // 3. Resources Section
            item {
                HomeSectionTitle("学习资源")
            }

            item {
                PremiumCard {
                    HomeSquircleListItem(
                        icon = Icons.Rounded.Book,
                        color = NemoPrimary,
                        title = stringResource(R.string.menu_word_book_title),
                        subtitle = stringResource(R.string.menu_word_book_subtitle),
                        onClick = onNavigateToWordList,
                        showDivider = true
                    )
                    HomeSquircleListItem(
                        icon = Icons.Rounded.EmojiEvents,
                        color = NemoPrimary, // Or any distinct color
                        title = "学习热力图",
                        subtitle = "查看学习成就",
                        onClick = onNavigateToHeatmap,
                        showDivider = true
                    )
                    HomeSquircleListItem(
                        icon = Icons.Rounded.Create,
                        color = MaterialTheme.colorScheme.tertiary,
                        title = stringResource(R.string.menu_grammar_book_title),
                        subtitle = stringResource(R.string.menu_grammar_book_subtitle),
                        onClick = onNavigateToGrammarList,
                        showDivider = false
                    )
                }
            }
        }

        // 强制推送通知弹窗 (逻辑已下沉至 ViewModel)
        ForcedNotificationPopup(
            notification = uiState.activeNotification,
            onDismiss = { viewModel.dismissNotification(it) },
            canDismissByBackdrop = false
        )
    }
}
