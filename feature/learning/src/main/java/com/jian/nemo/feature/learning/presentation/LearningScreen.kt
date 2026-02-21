package com.jian.nemo.feature.learning.presentation

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.Spacer
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.Undo
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.luminance
import androidx.compose.ui.platform.LocalViewConfiguration
import androidx.compose.ui.platform.ViewConfiguration
import androidx.compose.foundation.systemGestureExclusion
import androidx.compose.ui.unit.dp
import androidx.compose.animation.*
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.hilt.navigation.compose.hiltViewModel
import com.jian.nemo.feature.learning.presentation.components.common.LearningFinishedContent
import com.jian.nemo.feature.learning.presentation.components.common.DailyGoalMetContent
import com.jian.nemo.feature.learning.presentation.components.common.LearnHeader
import com.jian.nemo.feature.learning.presentation.components.common.WaitingContent
import com.jian.nemo.feature.learning.presentation.components.sheets.LevelSelectionBottomSheet
import com.jian.nemo.core.designsystem.theme.NemoSurfaceCard
import com.jian.nemo.core.designsystem.theme.NemoSurfaceCardDark
import com.jian.nemo.core.designsystem.theme.NemoSurfaceBackground
import com.jian.nemo.core.designsystem.theme.NemoSurfaceBackgroundDark
import com.jian.nemo.core.ui.component.common.NemoSnackbar
import com.jian.nemo.core.ui.component.common.NemoSnackbarType
import com.jian.nemo.feature.learning.presentation.components.dialogs.TypingPracticeDialog
import com.jian.nemo.feature.learning.presentation.components.cards.SRSLearningCard
import com.jian.nemo.feature.learning.presentation.components.cards.SRSGrammarCard
import com.jian.nemo.feature.learning.presentation.components.srs.SRSActionArea

@Composable

fun LearningScreen(
    level: String,
    viewModel: LearningViewModel = hiltViewModel(),
    onNavigateBack: () -> Unit,
    initialMode: LearningMode = LearningMode.Word
) {
    val uiState by viewModel.uiState.collectAsState()

    LaunchedEffect(key1 = level, key2 = initialMode) {
        viewModel.onEvent(LearningEvent.StartLearning(level, initialMode))
    }

    val isDarkTheme = MaterialTheme.colorScheme.background.luminance() < 0.5
    val backgroundColor = if (isDarkTheme) NemoSurfaceBackgroundDark else NemoSurfaceBackground
    val cardColor = if (isDarkTheme) NemoSurfaceCardDark else NemoSurfaceCard

    // 状态
    var showWordLevelSheet by rememberSaveable { mutableStateOf(false) }
    var showGrammarLevelSheet by rememberSaveable { mutableStateOf(false) }

    // Levels
    val levels = listOf("N5", "N4", "N3", "N2", "N1")

    // Bottom Sheets
    LevelSelectionBottomSheet(
        show = showWordLevelSheet,
        title = "选择单词等级",
        levels = levels,
        selectedLevel = uiState.selectedLevel,
        onDismiss = { showWordLevelSheet = false },
        onLevelSelected = { newLevel ->
            viewModel.onEvent(LearningEvent.ChangeLevel(newLevel))
            showWordLevelSheet = false
        }
    )

    LevelSelectionBottomSheet(
        show = showGrammarLevelSheet,
        title = "选择语法等级",
        levels = levels,
        selectedLevel = uiState.selectedLevel,
        onDismiss = { showGrammarLevelSheet = false },
        onLevelSelected = { newLevel ->
             viewModel.onEvent(LearningEvent.ChangeLevel(newLevel))
             showGrammarLevelSheet = false
        }
    )

    Scaffold(
        containerColor = backgroundColor
    ) { padding ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
        ) {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(horizontal = 16.dp)
            ) {
                // Header
                LearnHeader(
                    learningMode = uiState.learningMode,
                    completedCount = uiState.completedToday,
                    dailyGoal = uiState.dailyGoal,
                    currentIndex = if (uiState.learningMode == LearningMode.Word)
                        uiState.currentIndex
                    else
                        uiState.currentGrammarIndex,
                    totalCount = if (uiState.learningMode == LearningMode.Word)
                        uiState.wordList.size
                    else
                        uiState.grammarList.size,
                    isNavigating = uiState.isNavigating,
                    isAnswerShown = uiState.isAnswerShown,
                    onClose = onNavigateBack,
                    onPrev = { viewModel.onEvent(LearningEvent.NavigatePrev) },
                    onNext = { viewModel.onEvent(LearningEvent.NavigateNext) },
                    onSuspend = { viewModel.onEvent(LearningEvent.SuspendCurrent) },
                    onBury = { viewModel.onEvent(LearningEvent.BuryCurrent) },
                    isAutoAudioEnabled = uiState.isAutoAudioEnabled,
                    onToggleAutoAudio = if (uiState.learningMode == LearningMode.Word) {
                        { viewModel.onEvent(LearningEvent.ToggleAutoPlayAudio(it)) }
                    } else null
                )

                // Content
                Box(modifier = Modifier.weight(1f)) {
                    when (uiState.status) {
                        LearningStatus.Loading -> {
                            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                                CircularProgressIndicator()
                            }
                        }
                        LearningStatus.Waiting -> {
                            WaitingContent(
                                until = uiState.waitingUntil,
                                onContinue = { viewModel.onEvent(LearningEvent.ResumeFromWaiting) }
                            )
                        }
                        else -> {
                            LearningContent(
                                uiState = uiState,
                                cardColor = cardColor,
                                onEvent = viewModel::onEvent
                            )
                        }
                    }
                }
            }

            // 顶部撤销 Snackbar
            NemoSnackbar(
                visible = uiState.canUndo,
                message = "点击撤销上一次评分",
                actionText = "撤销",
                icon = Icons.AutoMirrored.Filled.Undo,
                type = NemoSnackbarType.INFO,
                autoDismissMs = 5000L,
                onDismiss = { viewModel.onEvent(LearningEvent.DismissUndo) },
                onClick = { viewModel.onEvent(LearningEvent.Undo) },
                modifier = Modifier.align(Alignment.TopCenter)
            )
        }
    }
}


@Composable
fun LearningContent(
    uiState: LearningUiState,
    cardColor: Color,
    onEvent: (LearningEvent) -> Unit
) {
    if (uiState.learningMode == LearningMode.Word) {
        WordLearningContent(
            uiState = uiState,
            cardColor = cardColor,
            onEvent = onEvent
        )
    } else {
        GrammarLearningContent(
            uiState = uiState,
            cardColor = cardColor,
            onEvent = onEvent
        )
    }
}

@Composable
fun WordLearningContent(
    uiState: LearningUiState,
    cardColor: Color,
    onEvent: (LearningEvent) -> Unit
) {
    // 跟打练习对话框状态
    var showTypingDialog by remember { mutableStateOf(false) }

    // 跟打练习对话框
    if (showTypingDialog && uiState.currentWord != null) {
        TypingPracticeDialog(
            word = uiState.currentWord,
            onDismiss = { showTypingDialog = false }
        )
    }

    Column(modifier = Modifier.fillMaxSize()) {
        // SubHeader and Progress Bar are now moved to LearnHeader common component for pixel-perfect match with HTML top bar.

        Spacer(modifier = Modifier.height(16.dp)) // Add some spacing from header

        if (uiState.completedToday >= uiState.dailyGoal) {
            DailyGoalMetContent()
        } else if (uiState.currentWord != null) {
            Box(modifier = Modifier.weight(1f)) {
                 // Card Content
                 Box(
                    modifier = Modifier
                        .fillMaxSize(),
                    contentAlignment = Alignment.TopCenter
                 ) {
                     // 使用 HorizontalPager 实现手势滑动切换
                     val pagerState = rememberPagerState(
                         initialPage = uiState.currentIndex,
                         pageCount = { uiState.wordList.size }
                     )

                     // 最佳实践：优化手势冲突
                     // 1. 排除系统手势边缘 (System Gesture Exclusion)
                     // 2. 自定义 ViewConfiguration 指令
                     val viewConfiguration = LocalViewConfiguration.current
                     val customViewConfiguration = remember {
                         object : ViewConfiguration by viewConfiguration {
                             override val touchSlop: Float
                                 get() = viewConfiguration.touchSlop * 0.8f // 提高灵敏度
                         }
                     }

                     // 标志位：是否正在由 ViewModel 驱动的滚动
                     var isViewModelDriven by remember { mutableStateOf(false) }

                     // 同步 ViewModel 状态到 Pager（ViewModel 驱动）
                     LaunchedEffect(uiState.currentIndex) {
                         if (pagerState.currentPage != uiState.currentIndex) {
                             isViewModelDriven = true
                             pagerState.animateScrollToPage(uiState.currentIndex)
                             isViewModelDriven = false
                         }
                     }

                     // 同步 Pager 状态到 ViewModel（仅手势驱动时）
                     LaunchedEffect(pagerState.currentPage, pagerState.isScrollInProgress) {
                         if (!isViewModelDriven && !pagerState.isScrollInProgress && pagerState.currentPage != uiState.currentIndex) {
                             onEvent(LearningEvent.GoToIndex(pagerState.currentPage))
                         }
                     }

                     androidx.compose.runtime.CompositionLocalProvider(
                         LocalViewConfiguration provides customViewConfiguration
                     ) {
                         HorizontalPager(
                             state = pagerState,
                             modifier = Modifier
                                 .fillMaxSize()
                                 .systemGestureExclusion(), // 排除系统返回手势
                             beyondViewportPageCount = 1,
                             userScrollEnabled = !uiState.isAnswerShown
                         ) { page ->
                             // 使用 AnimatedContent 实现评分后的过渡动画
                             // 当 page 索引不变（例如一直是 0），但内容（wordList）发生改变时触发
                             val word = uiState.wordList.getOrNull(page)

                             AnimatedContent(
                                targetState = word,
                                transitionSpec = {
                                    if (uiState.slideDirection == SlideDirection.FORWARD) {
                                        (slideInHorizontally { width -> width } + fadeIn()).togetherWith(
                                            slideOutHorizontally { width -> -width } + fadeOut())
                                    } else {
                                        (slideInHorizontally { width -> -width } + fadeIn()).togetherWith(
                                            slideOutHorizontally { width -> width } + fadeOut())
                                    }.using(
                                        SizeTransform(clip = false)
                                    )
                                },
                                label = "WordCardTransition"
                             ) { targetWord ->
                                 if (targetWord != null) {
                                     SRSLearningCard(
                                          word = targetWord,
                                          isAnswerShown = uiState.isAnswerShown && page == uiState.currentIndex,
                                          modifier = Modifier.fillMaxSize(),
                                          onPracticeClick = {
                                              showTypingDialog = true
                                          },
                                          onSpeakWord = { onEvent(LearningEvent.SpeakWord(targetWord.hiragana)) },
                                          onSpeakExample = { japanese, chinese, id -> onEvent(LearningEvent.SpeakExample(japanese, chinese, id)) },
                                          playingAudioId = uiState.playingAudioId
                                      )
                                 }
                             }
                         }
                     }
                 }

                 // SRS Action Area (Bottom)
                 SRSActionArea(
                     isAnswerShown = uiState.isAnswerShown,
                     ratingIntervals = uiState.ratingIntervals,
                     onShowAnswer = { onEvent(LearningEvent.ShowAnswer) },
                     onRate = { quality -> onEvent(LearningEvent.RateWord(quality)) },
                     modifier = Modifier.align(Alignment.BottomCenter)
                 )
            }
        } else {
            LearningFinishedContent(
                title = "暂无单词任务",
                subtitle = "该级别目前没有需要学习或复习的单词"
            )
        }
    }
}

@Composable
fun GrammarLearningContent(
    uiState: LearningUiState,
    cardColor: Color,
    onEvent: (LearningEvent) -> Unit
) {
    Column(modifier = Modifier.fillMaxSize()) {
        Spacer(modifier = Modifier.height(16.dp)) // Add some spacing from header

        if (uiState.completedToday >= uiState.dailyGoal) {
            DailyGoalMetContent()
        } else if (uiState.currentGrammar != null) {
            Box(modifier = Modifier.weight(1f)) {
                 // Card Content
                 Box(
                    modifier = Modifier
                        .fillMaxSize(),
                    contentAlignment = Alignment.TopCenter
                 ) {
                     // 使用 HorizontalPager 实现手势滑动切换
                     val pagerState = rememberPagerState(
                         initialPage = uiState.currentGrammarIndex,
                         pageCount = { uiState.grammarList.size }
                     )

                     // 最佳实践：优化手势冲突
                     val viewConfiguration = LocalViewConfiguration.current
                     val customViewConfiguration = remember {
                         object : ViewConfiguration by viewConfiguration {
                             override val touchSlop: Float
                                 get() = viewConfiguration.touchSlop * 0.8f // 提高灵敏度
                         }
                     }

                     // 标志位：是否正在由 ViewModel 驱动的滚动
                     var isViewModelDriven by remember { mutableStateOf(false) }

                     // 同步 ViewModel 状态到 Pager（ViewModel 驱动）
                     LaunchedEffect(uiState.currentGrammarIndex) {
                         if (pagerState.currentPage != uiState.currentGrammarIndex) {
                             isViewModelDriven = true
                             pagerState.animateScrollToPage(uiState.currentGrammarIndex)
                             isViewModelDriven = false
                         }
                     }

                     // 同步 Pager 状态到 ViewModel（仅手势驱动时）
                     LaunchedEffect(pagerState.currentPage, pagerState.isScrollInProgress) {
                         if (!isViewModelDriven && !pagerState.isScrollInProgress && pagerState.currentPage != uiState.currentGrammarIndex) {
                             onEvent(LearningEvent.GoToIndex(pagerState.currentPage))
                         }
                     }

                     androidx.compose.runtime.CompositionLocalProvider(
                         LocalViewConfiguration provides customViewConfiguration
                     ) {
                         HorizontalPager(
                             state = pagerState,
                             modifier = Modifier
                                 .fillMaxSize()
                                 .systemGestureExclusion(),
                             beyondViewportPageCount = 1,
                             userScrollEnabled = !uiState.isAnswerShown
                         ) { page ->
                         val grammar = uiState.grammarList.getOrNull(page)

                         AnimatedContent(
                            targetState = grammar,
                            transitionSpec = {
                                if (uiState.slideDirection == SlideDirection.FORWARD) {
                                    (slideInHorizontally { width -> width } + fadeIn()).togetherWith(
                                        slideOutHorizontally { width -> -width } + fadeOut())
                                } else {
                                    (slideInHorizontally { width -> -width } + fadeIn()).togetherWith(
                                        slideOutHorizontally { width -> width } + fadeOut())
                                }.using(
                                    SizeTransform(clip = false)
                                )
                            },
                            label = "GrammarCardTransition"
                         ) { targetGrammar ->
                             if (targetGrammar != null) {
                                  SRSGrammarCard(
                                      grammar = targetGrammar,
                                      isAnswerShown = uiState.isAnswerShown && page == uiState.currentGrammarIndex,
                                      modifier = Modifier.fillMaxSize(),
                                      onSpeakExample = { japanese, chinese, id -> onEvent(LearningEvent.SpeakExample(japanese, chinese, id)) },
                                      playingAudioId = uiState.playingAudioId
                                  )
                             }
                         }
                     }
                 }
            }
                 // SRS Action Area (Bottom)
                 SRSActionArea(
                     isAnswerShown = uiState.isAnswerShown,
                     ratingIntervals = uiState.ratingIntervals,
                     onShowAnswer = { onEvent(LearningEvent.ShowAnswer) },
                     onRate = { quality -> onEvent(LearningEvent.RateGrammar(quality)) },
                     modifier = Modifier.align(Alignment.BottomCenter)
                 )
            }
        } else {
            LearningFinishedContent(
                title = "暂无语法任务",
                subtitle = "该级别目前没有需要学习或复习的语法"
            )
        }
    }
}
