package com.jian.nemo.core.domain.usecase.grammar

import app.cash.turbine.test
import com.jian.nemo.core.common.Result
import com.jian.nemo.core.common.util.DateTimeUtils
import com.jian.nemo.core.domain.model.Grammar
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
 * 单元测试: GetDueGrammarsUseCase
 *
 * 验证获取到期复习语法的业务逻辑
 */
class GetDueGrammarsUseCaseTest {

    private lateinit var grammarRepository: GrammarRepository
    private lateinit var useCase: GetDueGrammarsUseCase

    @Before
    fun setup() {
        grammarRepository = mockk()
        useCase = GetDueGrammarsUseCase(grammarRepository)

        // Mock DateTimeUtils
        mockkObject(DateTimeUtils)
        every { DateTimeUtils.getCurrentEpochDay() } returns 100L
    }

    @Test
    fun `invoke should return due grammars for today`() = runTest {
        // Given: 到期的语法
        val dueGrammars = listOf(
            createTestGrammar(id = 1, nextReviewDate = 99L, repetitionCount = 1),
            createTestGrammar(id = 2, nextReviewDate = 100L, repetitionCount = 2)
        )
        every { grammarRepository.getDueGrammars(100L) } returns flowOf(dueGrammars)

        // When & Then
        useCase().test {
            awaitItem() // Loading

            val successResult = awaitItem()
            assertTrue(successResult is Result.Success)
            assertEquals(2, successResult.getOrNull()?.size)

            awaitComplete()
        }
    }

    @Test
    fun `invoke should return empty list when no due grammars`() = runTest {
        // Given
        every { grammarRepository.getDueGrammars(100L) } returns flowOf(emptyList())

        // When & Then
        useCase().test {
            awaitItem() // Loading

            val successResult = awaitItem()
            assertTrue(successResult is Result.Success)
            assertTrue(successResult.getOrNull()?.isEmpty() == true)

            awaitComplete()
        }
    }

    @Test
    fun `invoke should handle repository errors`() = runTest {
        // Given
        val exception = RuntimeException("Database error")
        every { grammarRepository.getDueGrammars(100L) } returns kotlinx.coroutines.flow.flow {
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

    private fun createTestGrammar(
        id: Int = 1,
        grammar: String = "～について",
        nextReviewDate: Long = 0,
        repetitionCount: Int = 0
    ) = Grammar(
        id = id,
        grammar = grammar,
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
        nextReviewDate = nextReviewDate,
        lastReviewedDate = null,
        firstLearnedDate = if (repetitionCount > 0) 90L else null,
        isFavorite = false,
        isSkipped = false,
        lastModifiedTime = System.currentTimeMillis()
    )
}
