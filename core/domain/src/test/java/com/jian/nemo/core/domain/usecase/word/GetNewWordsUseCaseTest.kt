package com.jian.nemo.core.domain.usecase.word

import app.cash.turbine.test
import com.jian.nemo.core.common.Result
import com.jian.nemo.core.domain.model.Word
import com.jian.nemo.core.domain.repository.WordRepository
import io.mockk.every
import io.mockk.mockk
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.test.runTest
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test

/**
 * 单元测试: GetNewWordsUseCase
 *
 * 验证获取新单词的业务逻辑
 */
class GetNewWordsUseCaseTest {

    private lateinit var wordRepository: WordRepository
    private lateinit var useCase: GetNewWordsUseCase

    @Before
    fun setup() {
        wordRepository = mockk()
        useCase = GetNewWordsUseCase(wordRepository)
    }

    @Test
    fun `invoke should return Loading then Success with words`() = runTest {
        // Given
        val testWords = listOf(
            createTestWord(id = 1, japanese = "単語1"),
            createTestWord(id = 2, japanese = "単語2")
        )
        every { wordRepository.getNewWords("n5") } returns flowOf(testWords)

        // When & Then
        useCase("n5").test {
            // First emission: Loading
            val loadingResult = awaitItem()
            assertTrue(loadingResult is Result.Loading)

            // Second emission: Success
            val successResult = awaitItem()
            assertTrue(successResult is Result.Success)
            assertEquals(testWords, successResult.getOrNull())

            awaitComplete()
        }
    }

    @Test
    fun `invoke should return Error when repository throws exception`() = runTest {
        // Given
        val exception = RuntimeException("Database error")
        every { wordRepository.getNewWords("n5") } returns kotlinx.coroutines.flow.flow {
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
    fun `invoke should return empty list when no new words available`() = runTest {
        // Given
        every { wordRepository.getNewWords("n1") } returns flowOf(emptyList())

        // When & Then
        useCase("n1").test {
            awaitItem() // Loading

            val successResult = awaitItem()
            assertTrue(successResult is Result.Success)
            assertTrue(successResult.getOrNull()?.isEmpty() == true)

            awaitComplete()
        }
    }

    private fun createTestWord(
        id: Int = 1,
        japanese: String = "テスト",
        hiragana: String = "てすと",
        chinese: String = "测试",
        level: String = "n5",
        repetitionCount: Int = 0
    ) = Word(
        id = id,
        japanese = japanese,
        hiragana = hiragana,
        chinese = chinese,
        level = level,
        tone = null,
        pos = null,
        example1 = null,
        gloss1 = null,
        example2 = null,
        gloss2 = null,
        example3 = null,
        gloss3 = null,
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
