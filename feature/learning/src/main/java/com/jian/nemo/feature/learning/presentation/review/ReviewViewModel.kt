package com.jian.nemo.feature.learning.presentation.review

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.jian.nemo.core.common.Result
import com.jian.nemo.core.common.util.DateTimeUtils
import com.jian.nemo.core.domain.service.SrsCalculator
import com.jian.nemo.core.domain.usecase.grammar.GetDueGrammarsUseCase
import com.jian.nemo.core.domain.usecase.review.ProcessReviewResultUseCase
import com.jian.nemo.core.domain.usecase.word.GetDueWordsUseCase
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

    // UI Helpers
    val ratingIntervals: Map<Int, String> = emptyMap()
)

@HiltViewModel
class ReviewViewModel @Inject constructor(
    private val getDueWordsUseCase: GetDueWordsUseCase,
    private val getDueGrammarsUseCase: GetDueGrammarsUseCase,
    private val processReviewResultUseCase: ProcessReviewResultUseCase,
    private val srsCalculator: SrsCalculator,
    private val settingsRepository: com.jian.nemo.core.domain.repository.SettingsRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(ReviewUiState())
    val uiState: StateFlow<ReviewUiState> = _uiState.asStateFlow()

    init {
        loadData()
    }

    private fun loadData() {
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true) }

            try {
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

                // Sort? For now, words then grammars.

                if (combinedList.isNotEmpty()) {
                    val firstItem = combinedList[0]
                    _uiState.update {
                        it.copy(
                            isLoading = false,
                            reviewItems = combinedList,
                            currentIndex = 0,
                            currentItem = firstItem,
                            isSessionCompleted = false,
                            ratingIntervals = calculateIntervals(firstItem)
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
                // Handle error properly in real app
                e.printStackTrace()
                _uiState.update { it.copy(isLoading = false, isSessionCompleted = true) }
            }
        }
    }

    fun showAnswer() {
        _uiState.update { it.copy(isAnswerShown = true) }
    }

    fun rateItem(quality: Int) {
        viewModelScope.launch {
            val currentState = _uiState.value
            val currentItem = currentState.currentItem ?: return@launch

            // 1. Process Review Result (Async update DB)
            when (currentItem) {
                is ReviewPreviewItem.WordItem -> {
                    processReviewResultUseCase.processWord(currentItem.word, quality)
                }
                is ReviewPreviewItem.GrammarItem -> {
                    processReviewResultUseCase.processGrammar(currentItem.grammar, quality)
                }
            }

            // 2. Move to Next
            moveToNext()
        }
    }

    private fun moveToNext() {
        val currentState = _uiState.value
        val nextIndex = currentState.currentIndex + 1

        if (nextIndex >= currentState.reviewItems.size) {
            _uiState.update { it.copy(isSessionCompleted = true) }
        } else {
            val nextItem = currentState.reviewItems[nextIndex]
            _uiState.update {
                it.copy(
                    currentIndex = nextIndex,
                    currentItem = nextItem,
                    isAnswerShown = false,
                    ratingIntervals = calculateIntervals(nextItem)
                )
            }
        }
    }

    private fun calculateIntervals(item: ReviewPreviewItem): Map<Int, String> {
        val intervals = mutableMapOf<Int, String>()

        viewModelScope.launch {
            val resetHour = settingsRepository.learningDayResetHourFlow.first()
            val today = DateTimeUtils.getLearningDay(resetHour)

            // Calculate interval for each quality rating (0-5)
            for (q in 0..5) {
                val result = when (item) {
                    is ReviewPreviewItem.WordItem -> srsCalculator.calculate(item.word, q, today)
                    is ReviewPreviewItem.GrammarItem -> srsCalculator.calculate(item.grammar, q, today)
                }

                intervals[q] = formatInterval(result.interval)
            }

            _uiState.update { it.copy(ratingIntervals = intervals.toMap()) }
        }

        return emptyMap() // Initial empty, will be updated by launch
    }

    private fun formatInterval(days: Int): String {
        return when {
            days == 0 -> "<1m" // Or "Today" / "Now"
            days == 1 -> "1d"
            days > 365 -> "${days / 365}y"
            days > 30 -> "${days / 30}m"
            else -> "${days}d"
        }
    }
}
