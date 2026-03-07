package com.jian.nemo.feature.learning.presentation.review

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.jian.nemo.core.common.Result
import com.jian.nemo.core.common.util.DateTimeUtils
import com.jian.nemo.core.domain.model.Grammar
import com.jian.nemo.core.domain.model.Word
import com.jian.nemo.core.domain.repository.SettingsRepository
import com.jian.nemo.core.domain.repository.StudyRecordRepository
import com.jian.nemo.core.domain.service.SrsCalculator
import com.jian.nemo.core.domain.usecase.grammar.GetDueGrammarsUseCase
import com.jian.nemo.core.domain.usecase.grammar.UpdateGrammarUseCase
import com.jian.nemo.core.domain.usecase.review.ProcessReviewResultUseCase
import com.jian.nemo.core.domain.usecase.word.GetDueWordsUseCase
import com.jian.nemo.core.domain.usecase.word.UpdateWordUseCase
import com.jian.nemo.feature.learning.domain.LearningScheduler
import com.jian.nemo.feature.learning.domain.ScheduleResult
import com.jian.nemo.feature.learning.domain.SrsIntervalPreview
import com.jian.nemo.feature.learning.presentation.LearningItem
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * Review UI State
 */
data class ReviewUiState(
    val isLoading: Boolean = false,
    val reviewItems: List<ReviewPreviewItem> = emptyList(),
    val currentIndex: Int = 0,
    val currentItem: ReviewPreviewItem? = null,
    val isAnswerShown: Boolean = false,
    val isSessionCompleted: Boolean = false,
    val isProcessing: Boolean = false,
    val totalCompleted: Int = 0,
    val error: String? = null,

    // UI Helpers
    val ratingIntervals: Map<Int, String> = emptyMap()
)

@HiltViewModel
class ReviewViewModel @Inject constructor(
    private val getDueWordsUseCase: GetDueWordsUseCase,
    private val getDueGrammarsUseCase: GetDueGrammarsUseCase,
    private val processReviewResultUseCase: ProcessReviewResultUseCase,
    private val srsCalculator: SrsCalculator,
    private val settingsRepository: SettingsRepository,
    private val learningScheduler: LearningScheduler,
    private val srsIntervalPreview: SrsIntervalPreview,
    private val updateWordUseCase: UpdateWordUseCase,
    private val updateGrammarUseCase: UpdateGrammarUseCase,
    private val studyRecordRepository: StudyRecordRepository
) : ViewModel() {

    companion object {
        private const val LEECH_THRESHOLD = 5
    }

    private val _uiState = MutableStateFlow(ReviewUiState())
    val uiState: StateFlow<ReviewUiState> = _uiState.asStateFlow()

    // ========== Relearning 内部状态 ==========

    /** 重学步进追踪 (ItemId -> StepIndex) */
    private val _relearningSteps = mutableMapOf<Int, Int>()

    /** 重学到期时间 (ItemId -> DueTime Epoch Millis) */
    private val _relearningDueTimes = mutableMapOf<Int, Long>()

    /** 会话内失败次数追踪 (ItemId -> Count) */
    private val _lapseCounts = mutableMapOf<Int, Int>()

    /** 重学步进配置 (分钟列表) */
    private var _relearningStepsConfig: List<Int> = listOf(1, 10)

    /** 会话锁定的学习日 */
    private var _sessionLockedDay: Long? = null
    private var _resetHour: Int = 4

    init {
        loadData()
    }

    // ========== 数据加载 ==========

    private fun loadData() {
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true) }

            try {
                // 0. 加载配置
                _resetHour = settingsRepository.learningDayResetHourFlow.first()
                _sessionLockedDay = DateTimeUtils.getLearningDay(_resetHour)

                val relearningStepsStr = settingsRepository.relearningStepsFlow.first()
                _relearningStepsConfig = parseSteps(relearningStepsStr)

                // 1. Get Due Words
                val dueWordsResult = getDueWordsUseCase().first { it !is Result.Loading }
                val dueWords = if (dueWordsResult is Result.Success) dueWordsResult.data else emptyList()

                // 2. Get Due Grammars
                val dueGrammarsResult = getDueGrammarsUseCase().first { it !is Result.Loading }
                val dueGrammars = if (dueGrammarsResult is Result.Success) dueGrammarsResult.data else emptyList()

                // 3. Combine
                val combinedList = mutableListOf<ReviewPreviewItem>()
                combinedList.addAll(dueWords.map { ReviewPreviewItem.WordItem(it) })
                combinedList.addAll(dueGrammars.map { ReviewPreviewItem.GrammarItem(it) })

                if (combinedList.isNotEmpty()) {
                    val firstItem = combinedList[0]
                    _uiState.update {
                        it.copy(
                            isLoading = false,
                            reviewItems = combinedList,
                            currentIndex = 0,
                            currentItem = firstItem,
                            isSessionCompleted = false,
                            ratingIntervals = calculateIntervalsSync(firstItem)
                        )
                    }
                } else {
                    _uiState.update {
                        it.copy(
                            isLoading = false,
                            reviewItems = emptyList(),
                            isSessionCompleted = true
                        )
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
                _uiState.update {
                    it.copy(isLoading = false, error = "加载失败: ${e.message}")
                }
            }
        }
    }

    // ========== UI 交互 ==========

    fun showAnswer() {
        _uiState.update { it.copy(isAnswerShown = true) }
    }

    // ========== 核心方法：评分 ==========

    /**
     * 评分 (对齐 Anki Relearning Steps)
     *
     * - quality < 3: Again → Lapse Penalty + 进入/重新进入 Relearning Steps
     * - quality 3-4 (重学中): Hard/Good → Step 流转
     * - quality 3-4 (正常复习): Hard/Good → 直接 SRS 更新
     * - quality 5: Easy → 直接毕业/SRS 更新
     */
    fun rateItem(quality: Int) {
        if (_uiState.value.isProcessing) return

        viewModelScope.launch {
            _uiState.update { it.copy(isProcessing = true) }

            try {
                val currentItem = _uiState.value.currentItem ?: run {
                    _uiState.update { it.copy(isProcessing = false) }
                    return@launch
                }

                val itemId = currentItem.itemId
                val isRelearning = _relearningSteps.containsKey(itemId)

                when {
                    // Easy (5): 无论状态，直接毕业/SRS更新
                    quality == 5 -> {
                        _relearningSteps.remove(itemId)
                        _relearningDueTimes.remove(itemId)
                        processDirectSrs(currentItem, quality)
                    }

                    // Again (< 3): 失败 → 进入/重新进入 Relearning
                    quality < 3 -> {
                        handleFailure(currentItem, quality)
                    }

                    // Hard/Good (3-4)
                    else -> {
                        if (isRelearning) {
                            // 在重学中 → 用 LearningScheduler 处理 Step 流转
                            handleRelearningPass(currentItem, quality)
                        } else {
                            // 正常复习 → 直接 SRS 更新 + 移出
                            processDirectSrs(currentItem, quality)
                        }
                    }
                }
            } catch (e: Exception) {
                println("❌ 复习评分异常: ${e.message}")
                _uiState.update {
                    it.copy(isProcessing = false, error = "评分异常: ${e.message}")
                }
            }
        }
    }

    // ========== 失败处理 (Again) ==========

    /**
     * 处理失败 (Again)
     *
     * 1. Lapse Penalty → 更新 DB 中的 interval/stability (FSRS 惩罚)
     * 2. 用 LearningScheduler 调度 → Requeue 或 Leech
     */
    private suspend fun handleFailure(item: ReviewPreviewItem, quality: Int) {
        val itemId = item.itemId

        // 1. Lapse Penalty (更新 DB 中的 interval/stability)
        applyLapsePenalty(item, quality)

        // 2. 计数
        val lapseCount = _lapseCounts.getOrDefault(itemId, 0) + 1
        _lapseCounts[itemId] = lapseCount

        // 3. 用 LearningScheduler 调度
        val learningItem = item.toLearningItem(
            step = _relearningSteps[itemId] ?: 0,
            dueTime = _relearningDueTimes[itemId] ?: 0L
        )
        val result = learningScheduler.scheduleFailure(
            item = learningItem,
            currentLapseCount = lapseCount,
            stepConfig = _relearningStepsConfig
        )

        // 4. 处理调度结果
        handleScheduleResult(result)
    }

    // ========== 重学中通过 (Hard/Good) ==========

    /**
     * 处理重学中的通过 (Hard/Good)
     */
    private suspend fun handleRelearningPass(item: ReviewPreviewItem, quality: Int) {
        val itemId = item.itemId
        val currentStep = _relearningSteps[itemId] ?: 0

        val learningItem = item.toLearningItem(
            step = currentStep,
            dueTime = _relearningDueTimes[itemId] ?: 0L
        )
        val result = learningScheduler.schedulePass(
            item = learningItem,
            quality = quality,
            currentStep = currentStep,
            stepConfig = _relearningStepsConfig
        )

        handleScheduleResult(result)
    }

    // ========== 调度结果处理 ==========

    /**
     * 处理 LearningScheduler 的调度结果
     */
    private suspend fun handleScheduleResult(result: ScheduleResult) {
        when (result) {
            is ScheduleResult.Leech -> {
                println("🩸 复习钉子户 (Leech): ${result.item.displayName} (Lapses: ${result.totalLapses})")
                _relearningSteps.remove(result.item.id)
                _relearningDueTimes.remove(result.item.id)
                handleLeech(result.item)
            }

            is ScheduleResult.Graduate -> {
                println("🎓 重学毕业: ${result.item.displayName}")
                _relearningSteps.remove(result.item.id)
                _relearningDueTimes.remove(result.item.id)
                processRelearningGraduation(result.item)
            }

            is ScheduleResult.Requeue -> {
                val item = result.updatedItem
                _relearningSteps[item.id] = result.nextStepIndex
                _relearningDueTimes[item.id] = result.dueTime

                if (result.isLapse) {
                    println("❌ 复习失败 (Again): ${item.displayName}, Step ${result.nextStepIndex}, Due in ${(result.dueTime - System.currentTimeMillis()) / 1000}s")
                } else {
                    println("🔄 复习重学进阶: ${item.displayName}, Step ${result.nextStepIndex}")
                }

                // 重入队到末尾并前进
                reQueueToEnd()
            }
        }
    }

    // ========== SRS 更新 ==========

    /**
     * 直接 SRS 更新 (正常复习通过 / Easy 直接毕业)
     *
     * 使用 ProcessReviewResultUseCase 完成完整的 SRS + 统计 + 日志
     */
    private suspend fun processDirectSrs(item: ReviewPreviewItem, quality: Int) {
        when (item) {
            is ReviewPreviewItem.WordItem -> {
                processReviewResultUseCase.processWord(item.word, quality)
            }
            is ReviewPreviewItem.GrammarItem -> {
                processReviewResultUseCase.processGrammar(item.grammar, quality)
            }
        }

        println("📝 复习SRS更新: ${item.displayName}, quality=$quality")

        _uiState.update {
            it.copy(totalCompleted = it.totalCompleted + 1)
        }

        removeCurrentAndMoveNext()
    }

    /**
     * 应用失败惩罚 (Lapse Penalty)
     *
     * 当用户点 Again 时，立即通过 FSRS 计算惩罚后的 interval/stability 并更新 DB。
     * 重学毕业时基于这个惩罚后的值调度。
     */
    private suspend fun applyLapsePenalty(item: ReviewPreviewItem, quality: Int) {
        val today = _sessionLockedDay ?: DateTimeUtils.getLearningDay(_resetHour)

        when (item) {
            is ReviewPreviewItem.WordItem -> {
                val srsResult = srsCalculator.calculate(item.word, quality, today)
                val updatedWord = item.word.copy(
                    interval = srsResult.interval,
                    repetitionCount = srsResult.repetitionCount,
                    stability = srsResult.stability,
                    difficulty = srsResult.difficulty,
                    nextReviewDate = srsResult.nextReviewDate,
                    lastReviewedDate = srsResult.lastReviewedDate,
                    firstLearnedDate = srsResult.firstLearnedDate,
                    lastModifiedTime = DateTimeUtils.getCurrentCompensatedMillis()
                )
                updateWordUseCase(updatedWord)
            }
            is ReviewPreviewItem.GrammarItem -> {
                val srsResult = srsCalculator.calculate(item.grammar, quality, today)
                val updatedGrammar = item.grammar.copy(
                    interval = srsResult.interval,
                    repetitionCount = srsResult.repetitionCount,
                    stability = srsResult.stability,
                    difficulty = srsResult.difficulty,
                    nextReviewDate = srsResult.nextReviewDate,
                    lastReviewedDate = srsResult.lastReviewedDate,
                    firstLearnedDate = srsResult.firstLearnedDate,
                    lastModifiedTime = DateTimeUtils.getCurrentCompensatedMillis()
                )
                updateGrammarUseCase(updatedGrammar)
            }
        }

        println("⚡ Lapse Penalty 已应用: ${item.displayName}")
    }

    /**
     * 重学毕业 (Relearning Graduation)
     *
     * 此时卡片的 interval 已在 Lapse 时被 FSRS 惩罚过。
     * 毕业时只需将其移回复习队列，设定 nextReviewDate = today + penalized_interval。
     */
    private suspend fun processRelearningGraduation(learningItem: LearningItem) {
        val today = _sessionLockedDay ?: DateTimeUtils.getLearningDay(_resetHour)

        when (learningItem) {
            is LearningItem.WordItem -> {
                val word = learningItem.word
                val interval = word.interval.coerceAtLeast(1)
                val updatedWord = word.copy(
                    interval = interval,
                    repetitionCount = word.repetitionCount + 1,
                    lastReviewedDate = today,
                    nextReviewDate = today + interval,
                    lastModifiedTime = DateTimeUtils.getCurrentCompensatedMillis()
                )
                updateWordUseCase(updatedWord)
                studyRecordRepository.incrementReviewedWords(1)
            }
            is LearningItem.GrammarItem -> {
                val grammar = learningItem.grammar
                val interval = grammar.interval.coerceAtLeast(1)
                val updatedGrammar = grammar.copy(
                    interval = interval,
                    repetitionCount = grammar.repetitionCount + 1,
                    lastReviewedDate = today,
                    nextReviewDate = today + interval,
                    lastModifiedTime = DateTimeUtils.getCurrentCompensatedMillis()
                )
                updateGrammarUseCase(updatedGrammar)
                studyRecordRepository.incrementReviewedGrammars(1)
            }
        }

        println("🎓 重学毕业完成: ${learningItem.displayName}")

        _uiState.update {
            it.copy(totalCompleted = it.totalCompleted + 1)
        }

        removeCurrentAndMoveNext()
    }

    /**
     * 处理钉子户 (Leech)
     *
     * 连续失败 LEECH_THRESHOLD 次后暂停该卡片
     */
    private suspend fun handleLeech(learningItem: LearningItem) {
        // 暂停卡片 (标记 isSkipped = true)
        when (learningItem) {
            is LearningItem.WordItem -> {
                val updatedWord = learningItem.word.copy(
                    isSkipped = true,
                    lastModifiedTime = DateTimeUtils.getCurrentCompensatedMillis()
                )
                updateWordUseCase(updatedWord)
            }
            is LearningItem.GrammarItem -> {
                val updatedGrammar = learningItem.grammar.copy(
                    isSkipped = true,
                    lastModifiedTime = DateTimeUtils.getCurrentCompensatedMillis()
                )
                updateGrammarUseCase(updatedGrammar)
            }
        }

        _uiState.update {
            it.copy(error = "已暂停钉子户: ${learningItem.displayName}")
        }

        removeCurrentAndMoveNext()
    }

    // ========== 队列操作 ==========

    /**
     * 重入队到末尾并前进
     *
     * 将当前项移除，追加到列表末尾，然后选择下一项。
     */
    private fun reQueueToEnd() {
        val state = _uiState.value
        val currentIndex = state.currentIndex
        val currentItem = state.currentItem ?: return

        val newList = state.reviewItems.toMutableList()
        if (currentIndex in newList.indices) {
            newList.removeAt(currentIndex)
        }
        // 追加到末尾
        newList.add(currentItem)

        selectNext(newList, currentIndex)
    }

    /**
     * 移除当前项并移到下一个 (毕业/直接通过时使用)
     */
    private fun removeCurrentAndMoveNext() {
        val state = _uiState.value
        val currentIndex = state.currentIndex

        val newList = state.reviewItems.toMutableList()
        if (currentIndex in newList.indices) {
            newList.removeAt(currentIndex)
        }

        if (newList.isEmpty()) {
            _uiState.update {
                it.copy(
                    isProcessing = false,
                    isSessionCompleted = true,
                    reviewItems = emptyList()
                )
            }
            return
        }

        val adjustedIndex = currentIndex.coerceIn(0, newList.size - 1)
        selectNext(newList, adjustedIndex)
    }

    /**
     * 选择下一项并更新 UI
     */
    private fun selectNext(newList: List<ReviewPreviewItem>, preferredIndex: Int) {
        if (newList.isEmpty()) {
            _uiState.update {
                it.copy(
                    isProcessing = false,
                    isSessionCompleted = true,
                    reviewItems = emptyList()
                )
            }
            return
        }

        val adjustedIndex = preferredIndex.coerceIn(0, newList.size - 1)
        val nextItem = newList[adjustedIndex]

        _uiState.update {
            it.copy(
                isProcessing = false,
                reviewItems = newList,
                currentIndex = adjustedIndex,
                currentItem = nextItem,
                isAnswerShown = false,
                ratingIntervals = calculateIntervalsSync(nextItem)
            )
        }
    }

    // ========== 间隔预览 ==========

    /**
     * 同步计算间隔预览 (修复原版异步返回空 Map 的 Bug)
     *
     * 复用 SrsIntervalPreview，正确显示重学中卡片的步进时间
     */
    private fun calculateIntervalsSync(item: ReviewPreviewItem): Map<Int, String> {
        val today = _sessionLockedDay ?: DateTimeUtils.getLearningDay(_resetHour)
        val itemId = item.itemId

        return when (item) {
            is ReviewPreviewItem.WordItem -> srsIntervalPreview.calculate(
                item = item.word,
                itemId = itemId,
                steps = _relearningSteps,
                learningStepsConfig = listOf(1, 10), // 复习模块不使用新词学习步骤
                relearningStepsConfig = _relearningStepsConfig,
                today = today
            )
            is ReviewPreviewItem.GrammarItem -> srsIntervalPreview.calculate(
                item = item.grammar,
                itemId = itemId,
                steps = _relearningSteps,
                learningStepsConfig = listOf(1, 10),
                relearningStepsConfig = _relearningStepsConfig,
                today = today
            )
        }
    }

    // ========== 工具方法 ==========

    private fun parseSteps(stepsStr: String): List<Int> {
        return stepsStr.split(" ", ",")
            .mapNotNull { it.trim().toIntOrNull() }
            .ifEmpty { listOf(1, 10) }
    }
}

// ========== ReviewPreviewItem 辅助扩展 ==========

/** 获取项目 ID */
val ReviewPreviewItem.itemId: Int
    get() = when (this) {
        is ReviewPreviewItem.WordItem -> word.id
        is ReviewPreviewItem.GrammarItem -> grammar.id
    }

/** 获取显示名称 */
val ReviewPreviewItem.displayName: String
    get() = when (this) {
        is ReviewPreviewItem.WordItem -> word.japanese
        is ReviewPreviewItem.GrammarItem -> grammar.grammar
    }

/** 转换为 LearningItem (供 LearningScheduler 使用) */
fun ReviewPreviewItem.toLearningItem(step: Int = 0, dueTime: Long = 0L): LearningItem {
    return when (this) {
        is ReviewPreviewItem.WordItem -> LearningItem.WordItem(word, step, dueTime)
        is ReviewPreviewItem.GrammarItem -> LearningItem.GrammarItem(grammar, step, dueTime)
    }
}
