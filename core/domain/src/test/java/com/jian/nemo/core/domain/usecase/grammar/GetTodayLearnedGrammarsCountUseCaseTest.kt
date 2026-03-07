package com.jian.nemo.core.domain.usecase.grammar

import app.cash.turbine.test
import com.jian.nemo.core.common.Result
import com.jian.nemo.core.common.util.DateTimeUtils
import com.jian.nemo.core.domain.repository.GrammarRepository
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkObject
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.test.runTest
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test

/**
 * 单元测试: GetTodayLearnedGrammarsCountUseCase
 *
 * 验证获取今日学习语法数量的业务逻辑
 */
class GetTodayLearnedGrammarsCountUseCaseTest {

    private lateinit var grammarRepository: GrammarRepository
    private lateinit var useCase: GetTodayLearnedGrammarsCountUseCase

    @Before
    fun setup() {
        grammarRepository = mockk()
        useCase = GetTodayLearnedGrammarsCountUseCase(grammarRepository)

        // Mock DateTimeUtils
        mockkObject(DateTimeUtils)
        every { DateTimeUtils.getCurrentEpochDay() } returns 100L
    }

    @Test
    fun `invoke should return count of grammars learned today`() = runTest {
        // Given: 今天学习了5个语法
        val learnedGrammars = listOf(
            createTestGrammar(1),
            createTestGrammar(2),
            createTestGrammar(3),
            createTestGrammar(4),
            createTestGrammar(5)
        )
        every { grammarRepository.getTodayLearnedGrammars(100L) } returns flowOf(learnedGrammars)

        //When & Then
        useCase().test {
            awaitItem() // Loading

            val successResult = awaitItem()
            assertTrue(successResult is Result.Success)
            assertEquals(5, successResult.getOrNull())

            awaitComplete()
        }
    }

    @Test
    fun `invoke should return zero when no grammars learned today`() = runTest {
        // Given
        every { grammarRepository.getTodayLearnedGrammars(100L) } returns flowOf(emptyList())

        // When & Then
        useCase().test {
            awaitItem() // Loading

            val successResult = awaitItem()
            assertTrue(successResult is Result.Success)
            assertEquals(0, successResult.getOrNull())

            awaitComplete()
        }
    }

    @Test
    fun `invoke should handle repository errors`() = runTest {
        // Given
        val exception = RuntimeException("Database error")
        every { grammarRepository.getTodayLearnedGrammars(100L) } returns kotlinx.coroutines.flow.flow {
            throw exception
        }

        // When & Then
        useCase().test {
            awaitItem() // Loading

            val result = awaitItem()
            assertTrue(result is Result.Error)
            assertEquals(exception, result.exceptionOrNull())

            awaitComplete()
        }
    }

    private fun createTestGrammar(id: Int) = com.jian.nemo.core.domain.model.Grammar(
        id = id,
        grammar = "～について$id",
        explanation = "关于～",
        grammarLevel = "n5",
        conjunction1 = null,
        conjunction2 = null,
        conjunction3 = null,
        conjunction4 = null,
        attention = null,
        example1 = null,
        translation1 = null,
        example2 = null,
        translation2 = null,
        example3 = null,
        translation3 = null,
        repetitionCount = 1,
        stability = 2.5f,
        difficulty = 5.0f,
        interval = 1,
        nextReviewDate = 101L,
        lastReviewedDate = 100L,
        firstLearnedDate = 100L,
        isFavorite = false,
        isSkipped = false,
        lastModifiedTime = System.currentTimeMillis()
    )
}

