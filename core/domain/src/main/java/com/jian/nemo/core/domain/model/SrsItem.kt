package com.jian.nemo.core.domain.model

/**
 * SRS (Spaced Repetition System) 项目接口
 *
 * Word 和 Grammar 实体都实现这个接口，抽象出SRS算法所需的字段
 * 这样SRS算法可以同时处理单词和语法，避免代码重复
 *
 * 参考：
 * - 旧项目 SrsAlgorithm.kt 对 Word 和 Grammar 的处理逻辑完全相同
 * - 实施计划 05-SRS算法实现.md 第123-152行
 */
interface SrsItem {
    /**
     * 复习次数（已成功复习的次数）
     * - 0: 未学习
     * - 1+: 已复习次数
     */
    val repetitionCount: Int

    /**
     * 易度系数（Easiness Factor）
     * - 默认值: 2.5
     * - 最小值: 1.3
     * - 根据回答质量动态调整
     */
    val easinessFactor: Float

    /**
     * 下次复习间隔（天数）
     * - 首次: 1天
     * - 第2次: 3天
     * - 第3次: 7天
     * - 之后: 基于易度系数计算
     */
    val interval: Int

    /**
     * 下次复习日期（Epoch Day）
     * - 0: 未学习或需要立即复习
     * - 其他: 具体的复习日期
     */
    val nextReviewDate: Long

    /**
     * 最后复习日期（Epoch Day）
     * - null: 从未复习过
     * - 其他: 最后一次复习的日期
     */
    val lastReviewedDate: Long?

    /**
     * 首次学习日期（Epoch Day）
     * - null: 从未学习过
     * - 其他: 第一次学习的日期
     */
    val firstLearnedDate: Long?
}

/**
 * SRS 更新结果
 *
 * 算法计算后返回的新状态，不可变对象
 *
 * 参考：实施计划 05-SRS算法实现.md 第145-152行
 */
data class SrsUpdateResult(
    val repetitionCount: Int,
    val easinessFactor: Float,
    val interval: Int,
    val nextReviewDate: Long,
    val lastReviewedDate: Long?,
    val firstLearnedDate: Long?
)
