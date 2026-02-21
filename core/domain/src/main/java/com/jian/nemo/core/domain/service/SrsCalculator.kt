package com.jian.nemo.core.domain.service

import com.jian.nemo.core.common.util.DateTimeUtils
import com.jian.nemo.core.domain.model.SrsItem
import com.jian.nemo.core.domain.model.SrsUpdateResult

/**
 * SRS (Spaced Repetition System) 算法计算器接口
 *
 * 设计为接口以便:
 * 1. 单元测试可以 mock
 * 2. 未来可以替换不同的 SRS 算法实现（如 SM-15, Anki算法等）
 *
 * 参考：实施计划 05-SRS算法实现.md 第160-196行
 */
interface SrsCalculator {
    /**
     * 计算 SRS 更新结果
     *
     * 核心算法，根据当前状态和回答质量计算新的复习参数
     *
     * @param item 当前 SRS 项目状态（Word 或 Grammar）
     * @param quality 回答质量 (0-5)
     *   - 0: 完全不记得
     *   - 1: 几乎不记得
     *   - 2: 记得一点，但需要提示
     *   - 3: 记得，需要一些努力 ← 及格线
     *   - 4: 记得，毫不费力
     *   - 5: 完美记忆
     * @param today 今天的 Epoch Day（用于计算延迟，默认使用当前日期）
     * @return SRS 更新后的状态（包含新的 repetitionCount, easinessFactor, interval 等）
     * @throws IllegalArgumentException 如果 quality 不在 0-5 范围内
     *
     * 使用示例:
     * ```kotlin
     * val updatedResult = srsCalculator.calculate(
     *     item = word,  // Word implements SrsItem
     *     quality = 4   // 毫不费力地记得
     * )
     * val updatedWord = word.copy(
     *     repetitionCount = updatedResult.repetitionCount,
     *     easinessFactor = updatedResult.easinessFactor,
     *     // ... 其他字段
     * )
     * ```
     */
    fun calculate(
        item: SrsItem,
        quality: Int,
        today: Long = DateTimeUtils.getCurrentEpochDay()
    ): SrsUpdateResult
}
