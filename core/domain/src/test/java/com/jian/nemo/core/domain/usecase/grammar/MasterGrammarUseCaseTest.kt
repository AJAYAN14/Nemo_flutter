package com.jian.nemo.core.domain.usecase.grammar

import com.jian.nemo.core.common.Result
import com.jian.nemo.core.common.util.DateTimeUtils
import com.jian.nemo.core.domain.model.Grammar
import com.jian.nemo.core.domain.model.SrsUpdateResult
import com.jian.nemo.core.domain.repository.GrammarRepository
import com.jian.nemo.core.domain.repository.StudyRecordRepository
import com.jian.nemo.core.domain.service.SrsCalculator
import io.mockk.*
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.test.runTest
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test

/**
 * 单元测试: MasterGrammarUseCase
 *
 * 验证掌握语法的复杂业务逻辑:
 * - SRS算法调用
 * - 学习记录统计
 * - 首次学习 vs 复习区分
 */
class MasterGrammarUseCaseTest {

    private lateinit var grammarRepository: GrammarRepository
    private lateinit var srsCalculator: SrsCalculator
    private lateinit var studyRecordRepository: StudyRecordRepository
    private lateinit var useCase: MasterGrammarUseCase

    @Before
    fun setup() {
        grammarRepository = mockk()
        srsCalculator = mockk()
        studyRecordRepository = mockk()
        useCase = MasterGrammarUseCase(grammarRepository, srsCalculator, studyRecordRepository)

        // Mock DateTimeUtils
        mockkObject(DateTimeUtils)
        every { DateTimeUtils.getCurrentEpochDay() } returns 100L
    }

    @Test
    fun `first time learning should increment learned grammars count`() = runTest {
        // Given: 未学习的语法 (repetitionCount = 0)
        val grammar = createTestGrammar(repetitionCount = 0)
        every { grammarRepository.getGrammarById(1) } returns flowOf(grammar)

        val srsResult = SrsUpdateResult(
            repetitionCount = 1,
            easinessFactor = 2.5f,
            interval = 1,
            nextReviewDate = 101L,
            lastReviewedDate = 100L,
            firstLearnedDate = 100L
        )
        every { srsCalculator.calculate(any(), 3, 100L) } returns srsResult

        coEvery { grammarRepository.updateGrammar(any()) } returns Result.Success(Unit)
        coEvery { studyRecordRepository.incrementLearnedGrammars() } returns Result.Success(Unit)

        // When
        val result = useCase(grammarId = 1, quality = 3)

        // Then
        assertTrue(result is Result.Success)

        // 验证: 首次学习调用incrementLearnedGrammars
        coVerify(exactly = 1) { studyRecordRepository.incrementLearnedGrammars() }
        coVerify(exactly = 0) { studyRecordRepository.incrementReviewedGrammars() }
    }

    @Test
    fun `reviewing learned grammar should increment reviewed grammars count`() = runTest {
        // Given: 已学习的语法 (repetitionCount > 0)
        val grammar = createTestGrammar(repetitionCount = 2)
        every { grammarRepository.getGrammarById(1) } returns flowOf(grammar)

        val srsResult = SrsUpdateResult(
            repetitionCount = 3,
            easinessFactor = 2.6f,
            interval = 7,
            nextReviewDate = 107L,
            lastReviewedDate = 100L,
            firstLearnedDate = 90L
        )
        every { srsCalculator.calculate(any(), 3, 100L) } returns srsResult

        coEvery { grammarRepository.updateGrammar(any()) } returns Result.Success(Unit)
        coEvery { studyRecordRepository.incrementReviewedGrammars() } returns Result.Success(Unit)

        // When
        val result = useCase(grammarId = 1, quality = 3)

        // Then
        assertTrue(result is Result.Success)

        // 验证: 复习调用incrementReviewedGrammars
        coVerify(exactly = 0) { studyRecordRepository.incrementLearnedGrammars() }
        coVerify(exactly = 1) { studyRecordRepository.incrementReviewedGrammars() }
    }

    @Test
    fun `should remove skip flag when master grammar`() = runTest {
        // Given: 跳过的语法
        val skippedGrammar = createTestGrammar(isSkipped = true, repetitionCount = 0)
        every { grammarRepository.getGrammarById(1) } returns flowOf(skippedGrammar)

        val srsResult = SrsUpdateResult(
            repetitionCount = 1,
            easinessFactor = 2.5f,
            interval = 1,
            nextReviewDate = 101L,
            lastReviewedDate = 100L,
            firstLearnedDate = 100L
        )
        every { srsCalculator.calculate(any(), 3, 100L) } returns srsResult

        val updatedGrammarSlot = slot<Grammar>()
        coEvery { grammarRepository.updateGrammar(capture(updatedGrammarSlot)) } returns Result.Success(Unit)
        coEvery { studyRecordRepository.incrementLearnedGrammars() } returns Result.Success(Unit)

        // When
        useCase(grammarId = 1, quality = 3)

        // Then: 验证isSkipped被设置为false
        assertFalse(updatedGrammarSlot.captured.isSkipped)
    }

    @Test
    fun `should return error when grammar not found`() = runTest {
        // Given: 语法不存在
        every { grammarRepository.getGrammarById(999) } returns flowOf(null)

        // When
        val result = useCase(grammarId = 999, quality = 3)

        // Then
        assertTrue(result is Result.Error)
        assertTrue(result.exceptionOrNull() is IllegalArgumentException)
    }

    @Test
    fun `should pass quality parameter to SRS calculator`() = runTest {
        // Given
        val grammar = createTestGrammar()
        every { grammarRepository.getGrammarById(1) } returns flowOf(grammar)

        val srsResult = SrsUpdateResult(
            repetitionCount = 1,
            easinessFactor = 2.7f, // higher quality
            interval = 1,
            nextReviewDate = 101L,
            lastReviewedDate = 100L,
            firstLearnedDate = 100L
        )

        val qualitySlot = slot<Int>()
        every {
            srsCalculator.calculate(any(), capture(qualitySlot), 100L)
        } returns srsResult

        coEvery { grammarRepository.updateGrammar(any()) } returns Result.Success(Unit)
        coEvery { studyRecordRepository.incrementLearnedGrammars() } returns Result.Success(Unit)

        // When: 使用quality=5(完全掌握)
        useCase(grammarId = 1, quality = 5)

        // Then: 验证传递了正确的quality
        assertEquals(5, qualitySlot.captured)
    }

    private fun createTestGrammar(
        id: Int = 1,
        repetitionCount: Int = 0,
        isSkipped: Boolean = false
    ) = Grammar(
        id = id,
        grammar = "～について",
        explanation = "关于～",
        grammarLevel = "n5",
        conjunction1 = "名詞＋について",
        conjunction2 = null,
        conjunction3 = null,
        conjunction4 = null,
        attention = null,
        example1 = "日本の文化について勉強します。",
        translation1 = "学习关于日本的文化。",
        example2 = null,
        translation2 = null,
        example3 = null,
        translation3 = null,
        repetitionCount = repetitionCount,
        easinessFactor = 2.5f,
        interval = 0,
        nextReviewDate = 0,
        lastReviewedDate = null,
        firstLearnedDate = null,
        isFavorite = false,
        isSkipped = isSkipped,
        lastModifiedTime = System.currentTimeMillis()
    )
}
