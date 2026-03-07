package com.jian.nemo.core.domain.algorithm

import com.jian.nemo.core.domain.model.SrsItem
import com.jian.nemo.core.domain.model.SrsUpdateResult
import com.jian.nemo.core.domain.service.SrsCalculator
import javax.inject.Inject
import javax.inject.Singleton

/**
 * 基于 FSRS 6 的 SRS 计算器实现
 *
 * 评分映射 (Nemo 0-5 → FSRS 1-4):
 * - quality 0-2 → Again (1)
 * - quality 3   → Hard (2)
 * - quality 4   → Good (3)
 * - quality 5   → Easy (4)
 */
@Singleton
class SrsCalculatorImpl @Inject constructor() : SrsCalculator {

    private val fsrs = FsrsAlgorithm()

    override fun calculate(
        item: SrsItem,
        quality: Int,
        today: Long
    ): SrsUpdateResult {
        require(quality in 0..5) {
            "Quality must be between 0 and 5, got $quality"
        }

        // 1. 映射评分
        val rating = mapQualityToRating(quality)

        // 2. 构建当前记忆状态
        val currentState = if (item.stability > 0f && item.repetitionCount > 0) {
            MemoryState(stability = item.stability, difficulty = item.difficulty)
        } else {
            null // 新卡
        }

        // 3. 计算经过天数
        val elapsedDays = if (item.lastReviewedDate != null && item.lastReviewedDate!! > 0) {
            (today - item.lastReviewedDate!!).toFloat().coerceAtLeast(0f)
        } else {
            0f
        }

        // 4. 执行 FSRS step
        val newState = fsrs.step(currentState, rating, elapsedDays)

        // 5. 计算新间隔
        val newInterval: Int
        val newRepetitionCount: Int

        if (quality < 3) {
            // 失败: 不增加复习次数，间隔由 FSRS stability 决定
            newRepetitionCount = item.repetitionCount // 不扣减
            newInterval = fsrs.nextIntervalDays(newState.stability)
        } else {
            // 成功
            newRepetitionCount = item.repetitionCount + 1
            newInterval = fsrs.nextIntervalDays(newState.stability)
        }

        // 6. 计算日期
        val nextReviewDate = if (newRepetitionCount == 0 && quality < 3) {
            0L // 新卡失败，不设置复习日期
        } else {
            today + newInterval
        }

        val firstLearnedDate = when {
            item.repetitionCount == 0 && quality >= 3 -> today // 新卡首次通过
            else -> item.firstLearnedDate
        }

        val lastReviewedDate = today

        return SrsUpdateResult(
            repetitionCount = newRepetitionCount,
            stability = newState.stability,
            difficulty = newState.difficulty,
            interval = newInterval,
            nextReviewDate = nextReviewDate,
            lastReviewedDate = lastReviewedDate,
            firstLearnedDate = firstLearnedDate
        )
    }

    private fun mapQualityToRating(quality: Int): FsrsRating {
        return when {
            quality < 3 -> FsrsRating.Again
            quality == 3 -> FsrsRating.Hard
            quality == 4 -> FsrsRating.Good
            else -> FsrsRating.Easy
        }
    }
}
