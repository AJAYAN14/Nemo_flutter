package com.jian.nemo.core.domain.usecase.statistics

import com.jian.nemo.core.common.util.DateTimeUtils
import com.jian.nemo.core.domain.model.ReviewForecast
import com.jian.nemo.core.domain.repository.GrammarRepository
import com.jian.nemo.core.domain.repository.SettingsRepository
import com.jian.nemo.core.domain.repository.WordRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.flatMapLatest
import javax.inject.Inject

/**
 * 获取复习预测 Use Case
 *
 * 获取未来7天的复习预测数据 (单词 + 语法)
 */
class GetReviewForecastUseCase @Inject constructor(
    private val wordRepository: WordRepository,
    private val grammarRepository: GrammarRepository,
    private val settingsRepository: SettingsRepository
) {
    @OptIn(kotlinx.coroutines.ExperimentalCoroutinesApi::class)
    operator fun invoke(): Flow<List<ReviewForecast>> {
        return settingsRepository.learningDayResetHourFlow.flatMapLatest { resetHour ->
            val today = DateTimeUtils.getLearningDay(resetHour)
            val endDate = today + 6 // 从今天起共7天

            val wordForecastFlow = wordRepository.getReviewForecast(today, endDate)
            val grammarForecastFlow = grammarRepository.getReviewForecast(today, endDate)

            combine(wordForecastFlow, grammarForecastFlow) { wordForecast, grammarForecast ->
                val combinedMap = mutableMapOf<Long, Int>()

                wordForecast.forEach { forecast ->
                    combinedMap[forecast.date] = combinedMap.getOrDefault(forecast.date, 0) + forecast.count
                }
                grammarForecast.forEach { forecast ->
                    combinedMap[forecast.date] = combinedMap.getOrDefault(forecast.date, 0) + forecast.count
                }

                combinedMap.map { (date, count) -> ReviewForecast(date, count) }.sortedBy { it.date }
            }
        }
    }
}
