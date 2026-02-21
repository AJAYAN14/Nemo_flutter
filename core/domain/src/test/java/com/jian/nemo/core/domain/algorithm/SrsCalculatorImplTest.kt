package com.jian.nemo.core.domain.algorithm

import com.jian.nemo.core.domain.model.SrsItem
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test

class SrsCalculatorImplTest {

    private lateinit var calculator: SrsCalculatorImpl

    @Before
    fun setup() {
        calculator = SrsCalculatorImpl()
    }

    // ========== 基础功能测试 ==========

    @Test
    fun `首次学习 质量4(Good) 应该毕业并设置间隔1天`() {
        // Given: 未学习的单词
        val item = createNewItem()

        // When: 第一次毕业，质量为4 (Good)
        val result = calculator.calculate(item, quality = 4, today = 100)

        // Then: 毕业间隔为1天
        assertEquals(1, result.repetitionCount)
        assertEquals(1, result.interval)
        assertEquals(101L, result.nextReviewDate)
    }

    @Test
    fun `首次学习 质量5(Easy) 应该毕业并设置间隔4天`() {
        // Given: 未学习的单词
        val item = createNewItem()

        // When: 第一次毕业，质量为5 (Easy)
        val result = calculator.calculate(item, quality = 5, today = 100)

        // Then: 毕业间隔为4天，EF 增加 0.15
        assertEquals(1, result.repetitionCount)
        assertEquals(4, result.interval)
        assertEquals(2.65f, result.easinessFactor)
    }

    @Test
    fun `复习阶段 使用EF计算间隔`() {
        // Given: 已毕业1次的单词，间隔1天，EF 2.5
        val item = createItemWithRepetition(1, interval = 1, easinessFactor = 2.5f)

        // When: 复习，质量4 (Good)
        val result = calculator.calculate(item, quality = 4, today = 100)

        // Then: 1 * 2.5 = 2.5 -> 3
        assertEquals(2, result.repetitionCount)
        assertTrue("Interval ${result.interval} out of range [2, 4]", result.interval in 2..4)
    }

    @Test
    fun `复习阶段 评分Hard应使用固定倍率1点2倍`() {
        // Given: 已复习3次，间隔10天，易度系数2.5
        val item = createItemWithRepetition(3, interval = 10, easinessFactor = 2.5f)

        // When: 复习评分 Hard (3)
        val result = calculator.calculate(item, quality = 3, today = 100)

        // Then:
        // 1. EF calc: Q=3 -> EF change = -0.15 -> New EF = 2.35
        // 2. Base Interval: 10 * 1.2 = 12
        // 3. Fuzzing: 12 * [0.95, 1.05] = [11.4, 12.6] -> [11, 13]

        assertEquals(4, result.repetitionCount)
        assertEquals(2.35f, result.easinessFactor)
        assertTrue("Interval ${result.interval} out of range [11, 13]", result.interval in 11..13)
    }

    // ========== 延迟奖励测试 (关键优化) ==========

    @Test
    fun `延迟且记得(Q=4) 应该给予奖励而不是惩罚`() {
        // Given: 间隔10天，但延迟了10天（总共20天没复习）
        val item = createItemWithRepetition(
            repetitionCount = 4,
            interval = 10,
            easinessFactor = 2.5f,
            nextReviewDate = 90 // Today is 100, so delay = 10
        )

        // When: 延迟复习，质量4（记得不错）
        val result = calculator.calculate(item, quality = 4, today = 100)

        // Then:
        // 1. EF calc: Q=4 -> EF change = 0 (Standard SM2: 5-4=1. 0.08+0.02=0.1. 0.1-0.1=0.) -> EF = 2.5
        // 2. Delay Reward: effectivePrevInterval = 10 + (10 * 0.5) = 15
        // 3. Base Interval: 15 * 2.5 = 37.5 -> 38
        // 4. Fuzzing: 38 * [0.95, 1.05] = [36.1, 39.9] -> [36, 40]

        // Compare with NO delay: 10 * 2.5 = 25.
        // Expect result > 25.

        assertTrue("Interval ${result.interval} should be rewarded (> 30)", result.interval > 30)
        assertTrue("Interval ${result.interval} < 42", result.interval < 42)
    }

    @Test
    fun `延迟但忘记(Q=2) 应该惩罚`() {
        // Given: 延迟10天
        val item = createItemWithRepetition(
            repetitionCount = 4,
            interval = 10,
            easinessFactor = 2.5f,
            nextReviewDate = 90
        )

        // When: 延迟复习，且忘记了
        val result = calculator.calculate(item, quality = 2, today = 100)

        // Then: Logic for Q<3
        // EF = max(1.3, 2.5 - 0.20) = 2.3
        // Interval = 10 * 0.45 = 4.5 -> 5
        // Fuzzing not applied for Q<3? Let's check code.
        // Code: if (quality < 3) ... newInterval = (item.interval * 0.45f).roundToInt()
        // No fuzzing block is inside `else` (quality >= 3).

        assertEquals(5, result.interval)
        assertEquals(3, result.repetitionCount) // 4 - 1
    }

    // ========== 最大间隔测试 ==========

    @Test
    fun `间隔不应超过最大限制`() {
        // Given: 间隔已经很大
        val item = createItemWithRepetition(
            repetitionCount = 10,
            interval = 10000,
            easinessFactor = 2.5f
        )

        // When: 再次复习
        val result = calculator.calculate(item, quality = 5, today = 100)

        // Then: Should be capped at 3650
        assertEquals(3650, result.interval)
    }

    // ========== 辅助方法 ==========

    private fun createNewItem(): TestSrsItem {
        return TestSrsItem(
            repetitionCount = 0,
            easinessFactor = 2.5f,
            interval = 0,
            nextReviewDate = 0,
            lastReviewedDate = null,
            firstLearnedDate = null
        )
    }

    private fun createItemWithRepetition(
        repetitionCount: Int,
        interval: Int = 1,
        easinessFactor: Float = 2.5f,
        nextReviewDate: Long = 100
    ): TestSrsItem {
        return TestSrsItem(
            repetitionCount = repetitionCount,
            easinessFactor = easinessFactor,
            interval = interval,
            nextReviewDate = nextReviewDate,
            lastReviewedDate = 90,
            firstLearnedDate = 80
        )
    }

    private data class TestSrsItem(
        override val repetitionCount: Int,
        override val easinessFactor: Float,
        override val interval: Int,
        override val nextReviewDate: Long,
        override val lastReviewedDate: Long?,
        override val firstLearnedDate: Long?
    ) : SrsItem
}
