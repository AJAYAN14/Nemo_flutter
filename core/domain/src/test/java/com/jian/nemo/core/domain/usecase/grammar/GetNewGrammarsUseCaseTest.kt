package com.jian.nemo.core.domain.usecase.grammar

import app.cash.turbine.test
import com.jian.nemo.core.common.Result
import com.jian.nemo.core.domain.model.Grammar
import com.jian.nemo.core.domain.repository.GrammarRepository
import io.mockk.every
import io.mockk.mockk
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.test.runTest
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test

/**
 * 单元测试: GetNewGrammarsUseCase
 *
 * 验证获取新语法的业务逻辑
 */
class GetNewGrammarsUseCaseTest {

    private lateinit var grammarRepository: GrammarRepository
    private lateinit var useCase: GetNewGrammarsUseCase

    @Before
    fun setup() {
        grammarRepository = mockk()
        useCase = GetNewGrammarsUseCase(grammarRepository)
    }

    @Test
    fun `invoke should return Loading then Success with grammars`() = runTest {
        // Given
        val testGrammars = listOf(
            createTestGrammar(id = 1, grammar = "～について"),
            createTestGrammar(id = 2, grammar = "～によると")
        )
        every { grammarRepository.getNewGrammars("n5") } returns flowOf(testGrammars)

        // When & Then
        useCase("n5").test {
            // First emission: Loading
            val loadingResult = awaitItem()
            assertTrue(loadingResult is Result.Loading)

            // Second emission: Success
            val successResult = awaitItem()
            assertTrue(successResult is Result.Success)
            assertEquals(testGrammars, successResult.getOrNull())

            awaitComplete()
        }
    }

    @Test
    fun `invoke should return Error when repository throws exception`() = runTest {
        // Given
        val exception = RuntimeException("Database error")
        every { grammarRepository.getNewGrammars("n5") } returns kotlinx.coroutines.flow.flow {
            throw exception
        }

        // When & Then
        useCase("n5").test {
            awaitItem() // Loading

            val result = awaitItem()
            assertTrue(result is Result.Error)
            assertEquals(exception, result.exceptionOrNull())

            awaitComplete()
        }
    }

    @Test
    fun `invoke should return empty list when no new grammars available`() = runTest {
        // Given
        every { grammarRepository.getNewGrammars("n1") } returns flowOf(emptyList())

        // When & Then
        useCase("n1").test {
            awaitItem() // Loading

            val successResult = awaitItem()
            assertTrue(successResult is Result.Success)
            assertTrue(successResult.getOrNull()?.isEmpty() == true)

            awaitComplete()
        }
    }

    private fun createTestGrammar(
        id: Int = 1,
        grammar: String = "～について",
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
        nextReviewDate = 0,
        lastReviewedDate = null,
        firstLearnedDate = null,
        isFavorite = false,
        isSkipped = false,
        lastModifiedTime = System.currentTimeMillis()
    )
}
