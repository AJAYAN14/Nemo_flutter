package com.jian.nemo.core.domain.algorithm

import com.jian.nemo.core.domain.model.SrsItem
import com.jian.nemo.core.domain.model.SrsUpdateResult
import com.jian.nemo.core.domain.service.SrsCalculator
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt
import kotlin.random.Random

/**
 * 包含以下改进:
 * 1. **延迟惩罚/奖励系统** - 根据延迟天数和质量调整间隔
 * 2. **优化的初始间隔序列** - 1→3→7
 * 3. **渐进式错误处理** - 答错渐进式降级
 * 4. **Fuzzing & Max Interval** - 随机模糊防止尖峰，最大间隔限制
 */
@Singleton
class SrsCalculatorImpl @Inject constructor() : SrsCalculator {

    override fun calculate(
        item: SrsItem,
        quality: Int,
        today: Long
    ): SrsUpdateResult {
        require(quality in 0..5) {
            "Quality must be between 0 and 5, got $quality"
        }

        var newRepetitionCount = item.repetitionCount
        var newEasinessFactor = item.easinessFactor
        var newInterval = item.interval

        // 计算延迟天数
        val delayDays = if (item.nextReviewDate > 0 && item.nextReviewDate < today) {
            (today - item.nextReviewDate).toInt()
        } else {
            0
        }

        // 处理答题结果
        if (quality < 3) {
            // 答错处理
            if (item.repetitionCount > 0) {
                // 已学习过，渐进式降低
                newEasinessFactor = max(MIN_EASINESS_FACTOR, newEasinessFactor - 0.20f) // 稍微加大惩罚
                newInterval = max(1, (item.interval * 0.45f).roundToInt()) // 稍微加强 Backtracking
                newRepetitionCount = max(0, item.repetitionCount - 1)
            } else {
                // 首次学习就答错，完全重置
                newRepetitionCount = 0
                newInterval = 0
            }
        } else {
            // 答对：更新间隔和易度系数

            // 1. 计算新的易度系数 (EF)
            // Anki 标准: Again: -0.20, Hard: -0.15, Good: 0, Easy: +0.15
            val efChange = when (quality) {
                3 -> -0.15f
                4 -> 0.00f
                5 -> 0.15f
                else -> 0.00f
            }
            newEasinessFactor = max(MIN_EASINESS_FACTOR, newEasinessFactor + efChange)
            newRepetitionCount += 1

            // 2. 计算基础下一次间隔 (rawNextInterval)
            val rawNextInterval = if (newRepetitionCount == 1) {
                // 毕业逻辑 (从学习阶段进入复习阶段)
                if (quality == 5) EASY_INTERVAL else GRADUATING_INTERVAL
            } else {
                // 复习逻辑
                var intervalBase = item.interval.toFloat()

                // 处理延期奖励 (Delay Reward)
                // 如果复习晚了，Anki 会基于实际间隔计算（但点 Hard 除外）
                if (delayDays > 0 && quality > 3) {
                    val cappedDelay = min(delayDays, item.interval)
                    intervalBase += cappedDelay * 0.5f
                }

                val nextIvl = when (quality) {
                    3 -> intervalBase * HARD_INTERVAL_MULTIPLIER
                    4 -> intervalBase * newEasinessFactor
                    5 -> intervalBase * newEasinessFactor * EASY_BONUS
                    else -> intervalBase * newEasinessFactor
                }
                nextIvl.roundToInt()
            }

            // 3. 引入 Fuzzing (随机模糊)，防止复习尖峰
            val fuzzValues = Random.nextDouble(0.95, 1.05)
            var fuzzedInterval = (rawNextInterval * fuzzValues).roundToInt()

            // 4. 边界检查
            if (fuzzedInterval < 1) fuzzedInterval = 1
            // 确保间隔至少比上一次大 (复习次数 > 2 且评分 >= 4)
            if (newRepetitionCount > 2 && quality >= 4 && fuzzedInterval <= item.interval) {
                fuzzedInterval = item.interval + 1
            }

            // 5. 最大间隔限制
            if (fuzzedInterval > MAX_INTERVAL) {
                fuzzedInterval = MAX_INTERVAL
            }

            newInterval = fuzzedInterval
        }

        // 计算日期
        val nextReviewDate = if (newRepetitionCount == 0) 0L else today + newInterval
        val firstLearnedDate = when {
            newRepetitionCount == 0 -> null
            item.repetitionCount == 0 && newRepetitionCount > 0 -> today
            else -> item.firstLearnedDate
        }
        val lastReviewedDate = if (newRepetitionCount > 0) today else null

        return SrsUpdateResult(
            repetitionCount = newRepetitionCount,
            easinessFactor = newEasinessFactor,
            interval = newInterval,
            nextReviewDate = nextReviewDate,
            lastReviewedDate = lastReviewedDate,
            firstLearnedDate = firstLearnedDate
        )
    }

    companion object {
        private const val MIN_EASINESS_FACTOR = 1.3f
        private const val MAX_INTERVAL = 3650 // 10年上限

        private const val GRADUATING_INTERVAL = 1
        private const val EASY_INTERVAL = 4
        private const val HARD_INTERVAL_MULTIPLIER = 1.2f
        private const val EASY_BONUS = 1.3f
    }
}
