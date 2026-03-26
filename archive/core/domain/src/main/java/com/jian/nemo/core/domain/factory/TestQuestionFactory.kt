package com.jian.nemo.core.domain.factory

import com.jian.nemo.core.domain.model.*
import javax.inject.Inject
import javax.inject.Singleton

/**
 * 测试题目构建工厂
 *
 * 负责将 Word/Grammar 实体转换为具体题型 (MultipleChoice, Typing, Sorting 等)。
 * 剥离了策略逻辑，专注于"构建"。
 */
@Singleton
class TestQuestionFactory @Inject constructor() {

    // ========== Multiple Choice ==========

    fun createMultipleChoice(
        word: Word,
        mode: TestMode,
        distractors: List<Word>,
        shuffleOptions: Boolean = true
    ): TestQuestion.MultipleChoice {
        val correctAnswer = getCorrectAnswer(word, mode)
        val wrongOptions = generateWrongOptions(word, mode, distractors, 3)
        val options = (wrongOptions + correctAnswer).toList()

        return TestQuestion.MultipleChoice(
            id = word.id,
            word = word,
            mode = mode,
            questionText = getQuestionText(word, mode),
            correctAnswer = correctAnswer,
            options = if (shuffleOptions) options.shuffled() else options,
            explanationPayload = word.toWordExplanationPayload()
        )
    }

    fun createGrammarMultipleChoice(
        grammar: Grammar,
        mode: TestMode,
        distractors: List<Grammar>,
        shuffleOptions: Boolean = true
    ): TestQuestion.MultipleChoice {
        val correctAnswer = grammar.getFirstExplanation()
        val wrongOptions = generateGrammarWrongOptions(grammar, distractors, 3)
        val options = (wrongOptions + correctAnswer).toList()

        return TestQuestion.MultipleChoice(
            id = grammar.id,
            grammar = grammar,
            mode = mode,
            questionText = grammar.grammar,
            correctAnswer = correctAnswer,
            options = if (shuffleOptions) options.shuffled() else options,
            explanationPayload = ExplanationPayload.GrammarText(correctAnswer)
        )
    }

    fun mapJsonToMultipleChoice(
        jsonQ: GrammarTestQuestion,
        mode: TestMode,
        grammarMap: Map<Int, Grammar>,
        shuffleOptions: Boolean = true
    ): TestQuestion.MultipleChoice {
        // Link to real Grammar entity if possible
        val grammarId = try { extractNumericId(jsonQ.targetGrammarId) } catch (_: Exception) { 0 }
        val grammar = grammarMap[grammarId]

        return TestQuestion.MultipleChoice(
            id = jsonQ.id.hashCode(), // Use hashCode for Int ID risk collision but ok for MVP
            word = null,
            grammar = grammar,
            mode = mode,
            questionText = jsonQ.question,
            correctAnswer = jsonQ.options[jsonQ.correctIndex],
            options = jsonQ.options,
            explanation = jsonQ.explanation,
            explanationPayload = resolveJsonGrammarExplanationPayload(jsonQ.explanation, grammar)
        ).let { if (shuffleOptions) it.copy(options = it.options.shuffled()) else it }
    }

    // ========== Typing ==========

    fun createTyping(word: Word): TestQuestion.Typing {
        // 随机选择题型（1-6）
        val questionTypes = listOf(1, 2, 3, 4, 5, 6)
        val questionType = questionTypes.random()

        val (questionText, correctAnswer) = when (questionType) {
            1 -> word.chinese to word.hiragana
            2 -> word.chinese to word.japanese
            3 -> word.hiragana to word.japanese
            4 -> word.japanese to word.hiragana
            5 -> word.hiragana to word.chinese
            6 -> word.japanese to word.chinese
            else -> word.chinese to word.hiragana
        }

        return TestQuestion.Typing(
            id = word.id,
            word = word,
            questionText = questionText,
            correctAnswer = correctAnswer,
            questionType = questionType
        )
    }

    // ========== Sorting ==========

    fun createSorting(word: Word, shuffleOptions: Boolean = true): TestQuestion.Sorting {
        val chars = word.hiragana.map { SortableChar(it) }
        val options = if (shuffleOptions) chars.shuffled() else chars

        return TestQuestion.Sorting(
            id = word.id,
            word = word,
            options = options
        )
    }



    // ========== Helpers ==========

    private fun getQuestionText(word: Word, mode: TestMode): String {
        return when (mode) {
            TestMode.JP_TO_CN -> word.japanese
            TestMode.CN_TO_JP -> word.chinese
            TestMode.KANA -> word.japanese
            TestMode.EXAMPLE -> word.chinese
        }
    }

    private fun getCorrectAnswer(word: Word, mode: TestMode): String {
        return when (mode) {
            TestMode.JP_TO_CN -> word.chinese
            TestMode.CN_TO_JP -> word.japanese
            TestMode.KANA -> word.hiragana
            TestMode.EXAMPLE -> word.japanese
        }
    }

    private fun generateWrongOptions(
        currentWord: Word,
        mode: TestMode,
        allWords: List<Word>,
        count: Int
    ): List<String> {
        val correctAnswer = getCorrectAnswer(currentWord, mode)
        val candidates = allWords
            .asSequence() // Use sequence for laziness
            .filter { it.id != currentWord.id }
            .map { getCorrectAnswer(it, mode) }
            .filter { it != correctAnswer }
            .distinct()

        return if (allWords.size > 100) {
             // If pool is large, don't iterate all. Just take randoms.
             // But existing logic filtered all. Let's keep it robust but maybe optimize later.
             // For now, simple list processing to match existing is safer.
             candidates.toList().shuffled().take(count)
        } else {
             val list = candidates.toList()
             if (list.size <= count) list else list.shuffled().take(count)
        }
    }

    private fun generateGrammarWrongOptions(
        currentGrammar: Grammar,
        allGrammars: List<Grammar>,
        count: Int
    ): List<String> {
        val correctAnswer = currentGrammar.getFirstExplanation()
        val candidates = allGrammars
            .filter { it.id != currentGrammar.id }
            .map { it.getFirstExplanation() }
            .filter { it != correctAnswer }
            .distinct()

        return if (candidates.size <= count) candidates else candidates.shuffled().take(count)
    }

    private fun extractNumericId(id: String): Int {
        return try {
            val parts = id.split("_")
            val levelNum = parts[0].substring(1).toInt()
            val num = parts[1].toInt()
            levelNum * 1000 + num
        } catch (_: Exception) {
            0
        }
    }

    private fun resolveJsonGrammarExplanationPayload(
        jsonExplanation: String?,
        grammar: Grammar?
    ): ExplanationPayload? {
        val text = jsonExplanation?.takeIf { it.isNotBlank() }
            ?: grammar?.getFirstExplanation()?.takeIf { it.isNotBlank() }
        return text?.let { ExplanationPayload.GrammarText(it) }
    }
}
