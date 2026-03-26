package com.jian.nemo.core.domain.usecase.statistics

import com.jian.nemo.core.common.util.DateTimeUtils
import com.jian.nemo.core.domain.model.LearningStats
import com.jian.nemo.core.domain.repository.GrammarRepository
import com.jian.nemo.core.domain.repository.SettingsRepository
import com.jian.nemo.core.domain.repository.StudyRecordRepository
import com.jian.nemo.core.domain.repository.WordRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.flow
import java.time.temporal.WeekFields
import java.util.Locale
import javax.inject.Inject

import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.map

/**
 * 获取学习统计数据 Use Case
 *
 * 汇总各种学习数据用于统计界面展示
 */
class GetLearningStatsUseCase @Inject constructor(
    private val studyRecordRepository: StudyRecordRepository,
    private val wordRepository: WordRepository,
    private val grammarRepository: GrammarRepository,
    private val settingsRepository: SettingsRepository
) {
    @OptIn(ExperimentalCoroutinesApi::class)
    operator fun invoke(): Flow<LearningStats> {
        return settingsRepository.learningDayResetHourFlow.flatMapLatest { resetHour ->
            val today = DateTimeUtils.getLearningDay(resetHour)

            // 1. 组合 Settings 相关 Flow
            val settingsFlow = combine(
                settingsRepository.dailyGoalFlow,
                settingsRepository.grammarDailyGoalFlow
            ) { wordGoal, grammarGoal ->
                SettingsData(wordGoal, grammarGoal)
            }

            // 1.1 学习活跃天统计（以 study_records 为准，避免 DataStore 漂移）
            val activityFlow = combine(
                studyRecordRepository.getAllRecords(),
                studyRecordRepository.getTotalStudyDays()
            ) { records, totalDays ->
                val dateSet = records.map { it.date }.toSet()
                val streak = calculateCurrentStreak(dateSet, today)
                LearningActivityData(streak, totalDays)
            }

            // 2. 本周学习天数 Flow (逻辑移植自 MainViewModel)
            val weekStudyDaysFlow = flow {
                // 基于逻辑学习日 (EpochDay) 反推 LocalDate，确保周统计同步
                val logicalLocalDate = java.time.LocalDate.ofEpochDay(today)
                val field = WeekFields.of(Locale.CHINA).dayOfWeek()
                val startOfWeek = logicalLocalDate.with(field, 1)
                val startEpochDay = startOfWeek.toEpochDay()
                val endEpochDay = today // 使用物理+补偿计算出的逻辑今天

                studyRecordRepository.getRecordsBetween(startEpochDay, endEpochDay)
                    .collect { records ->
                        emit(records.distinctBy { it.date }.size)
                    }
            }

            // 3. 组合核心计数 Flow
            val dueCountsFlow = combine(
                wordRepository.getDueWordsCount(today),
                grammarRepository.getDueGrammarsCount(today),
                wordRepository.getTodayLearnedWords(today).map { it.size },
                grammarRepository.getTodayLearnedGrammars(today).map { it.size }
            ) { dueWords, dueGrammars, learnedWords, learnedGrammars ->
                DueCountsData(dueWords, dueGrammars, learnedWords, learnedGrammars)
            }

            // 已掌握数量 (repetitionCount > 0 且未跳过) & 总数
            val totalAndMasteredFlow = combine(
                wordRepository.getAllLearnedWords().map { it.size },
                grammarRepository.getAllLearnedGrammars().map { it.size },
                wordRepository.getAllWordsByLevel("N1"),
                wordRepository.getAllWordsByLevel("N2"),
                wordRepository.getAllWordsByLevel("N3"),
                wordRepository.getAllWordsByLevel("N4"),
                wordRepository.getAllWordsByLevel("N5"),
                grammarRepository.getAllGrammars()
            ) { args ->
                val masteredWords = args[0] as Int
                val masteredGrammars = args[1] as Int
                val n1 = args[2] as List<*>
                val n2 = args[3] as List<*>
                val n3 = args[4] as List<*>
                val n4 = args[5] as List<*>
                val n5 = args[6] as List<*>
                val allGrammars = args[7] as List<*>

                val totalWords = n1.size + n2.size + n3.size + n4.size + n5.size
                MasteredAndTotalData(masteredWords, masteredGrammars, totalWords, allGrammars.size)
            }

            // 3. 最终组合
            combine(
                studyRecordRepository.getTodayRecord(),
                dueCountsFlow,
                totalAndMasteredFlow,
                settingsFlow,
                activityFlow,
                weekStudyDaysFlow
            ) { args ->
                val todayRecord = args[0] as com.jian.nemo.core.domain.model.StudyRecord?
                val dueCounts = args[1] as DueCountsData
                val totalMastered = args[2] as MasteredAndTotalData
                val settings = args[3] as SettingsData
                val activity = args[4] as LearningActivityData
                val weekDays = args[5] as Int

                val learnedWordsToday = todayRecord?.learnedWords ?: dueCounts.todayLearnedWords
                val learnedGrammarsToday = todayRecord?.learnedGrammars ?: dueCounts.todayLearnedGrammars

                LearningStats(
                    dailyStreak = activity.dailyStreak,
                    totalStudyDays = activity.totalStudyDays,
                    todayLearnedWords = learnedWordsToday,
                    todayLearnedGrammars = learnedGrammarsToday,
                    todayReviewedWords = todayRecord?.reviewedWords ?: 0,
                    todayReviewedGrammars = todayRecord?.reviewedGrammars ?: 0,
                    masteredWords = totalMastered.masteredWords,
                    masteredGrammars = totalMastered.masteredGrammars,
                    dueWords = dueCounts.dueWords,
                    dueGrammars = dueCounts.dueGrammars,
                    wordDailyGoal = settings.wordDailyGoal,
                    grammarDailyGoal = settings.grammarDailyGoal,
                    totalWords = totalMastered.totalWords,
                    totalGrammars = totalMastered.totalGrammars,
                    weekStudyDays = weekDays
                )
            }
        }
    }

    private data class SettingsData(
        val wordDailyGoal: Int,
        val grammarDailyGoal: Int
    )

    private data class LearningActivityData(
        val dailyStreak: Int,
        val totalStudyDays: Int
    )

    private data class DueCountsData(
        val dueWords: Int,
        val dueGrammars: Int,
        val todayLearnedWords: Int,
        val todayLearnedGrammars: Int
    )

    private data class MasteredAndTotalData(
        val masteredWords: Int,
        val masteredGrammars: Int,
        val totalWords: Int,
        val totalGrammars: Int
    )

    private fun calculateCurrentStreak(dates: Set<Long>, today: Long): Int {
        if (dates.isEmpty()) return 0

        // 与旧行为保持一致：若今天还未学习但昨天学了，连续天数仍维持到昨天。
        var cursor = when {
            dates.contains(today) -> today
            dates.contains(today - 1) -> today - 1
            else -> return 0
        }

        var streak = 0
        while (dates.contains(cursor)) {
            streak++
            cursor--
        }
        return streak
    }
}
