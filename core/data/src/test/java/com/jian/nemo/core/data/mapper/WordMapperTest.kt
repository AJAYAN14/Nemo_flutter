package com.jian.nemo.core.data.mapper

import com.jian.nemo.core.data.local.entity.WordEntity
import com.jian.nemo.core.data.mapper.WordMapper.toDomainModel
import com.jian.nemo.core.data.mapper.WordMapper.toDomainModels
import com.jian.nemo.core.data.mapper.WordMapper.toEntity
import org.junit.Assert.*
import org.junit.Test

/**
 * WordMapper单元测试
 *
 * 验证Entity ↔ Domain Model双向转换
 */
class WordMapperTest {

    @Test
    fun `entity to domain model conversion is correct`() {
        // Given: 创建测试WordEntity
        val entity = WordEntity(
            id = 1,
            japanese = "単語",
            hiragana = "たんご",
            chinese = "单词",
            level = "n5",
            tone = "0",
            pos = "名",
            example1 = "例文1",
            gloss1 = "释义1",
            example2 = "例文2",
            gloss2 = "释义2",
            example3 = "例文3",
            gloss3 = "释义3",
            repetitionCount = 5,
            easinessFactor = 2.6f,
            interval = 10,
            nextReviewDate = 12345L,
            lastReviewedDate = 12300L,
            firstLearnedDate = 12000L,
            isFavorite = true,
            isSkipped = false,
            lastModifiedTime = 99999L
        )

        // When: 转换为Domain Model
        val domain = entity.toDomainModel()

        // Then: 验证所有字段都正确映射
        assertEquals(entity.id, domain.id)
        assertEquals(entity.japanese, domain.japanese)
        assertEquals(entity.hiragana, domain.hiragana)
        assertEquals(entity.chinese, domain.chinese)
        assertEquals(entity.level, domain.level)
        assertEquals(entity.tone, domain.tone)
        assertEquals(entity.pos, domain.pos)

        // 验证example字段映射
        assertEquals(entity.example1, domain.example1)
        assertEquals(entity.gloss1, domain.gloss1)
        assertEquals(entity.example2, domain.example2)
        assertEquals(entity.gloss2, domain.gloss2)
        assertEquals(entity.example3, domain.example3)
        assertEquals(entity.gloss3, domain.gloss3)

        // 验证SRS字段
        assertEquals(entity.repetitionCount, domain.repetitionCount)
        assertEquals(entity.easinessFactor, domain.easinessFactor, 0.001f)
        assertEquals(entity.interval, domain.interval)
        assertEquals(entity.nextReviewDate, domain.nextReviewDate)
        assertEquals(entity.lastReviewedDate, domain.lastReviewedDate)
        assertEquals(entity.firstLearnedDate, domain.firstLearnedDate)

        // 验证用户交互字段
        assertEquals(entity.isFavorite, domain.isFavorite)
        assertEquals(entity.isSkipped, domain.isSkipped)
        assertEquals(entity.lastModifiedTime, domain.lastModifiedTime)
    }

    @Test
    fun `domain model to entity conversion is correct`() {
        // Given: 创建测试Word (Domain Model)
        val domain = com.jian.nemo.core.domain.model.Word(
            id = 2,
            japanese = "文法",
            hiragana = "ぶんぽう",
            chinese = "语法",
            level = "n4",
            tone = "1",
            pos = "名",
            example1 = "例句1",
            gloss1 = "解释1",
            example2 = "例句2",
            gloss2 = "解释2",
            example3 = "例句3",
            gloss3 = "解释3",
            repetitionCount = 3,
            easinessFactor = 2.5f,
            interval = 5,
            nextReviewDate = 54321L,
            lastReviewedDate = 54000L,
            firstLearnedDate = 53000L,
            isFavorite = false,
            isSkipped = true,
            lastModifiedTime = 88888L
        )

        // When: 转换为Entity
        val entity = domain.toEntity()

        // Then: 验证所有字段都正确映射
        assertEquals(domain.id, entity.id)
        assertEquals(domain.japanese, entity.japanese)
        assertEquals(domain.hiragana, entity.hiragana)
        assertEquals(domain.chinese, entity.chinese)
        assertEquals(domain.level, entity.level)
        assertEquals(domain.tone, entity.tone)
        assertEquals(domain.pos, entity.pos)

        // 验证example字段映射
        assertEquals(domain.example1, entity.example1)
        assertEquals(domain.gloss1, entity.gloss1)
        assertEquals(domain.example2, entity.example2)
        assertEquals(domain.gloss2, entity.gloss2)
        assertEquals(domain.example3, entity.example3)
        assertEquals(domain.gloss3, entity.gloss3)

        // 验证SRS字段
        assertEquals(domain.repetitionCount, entity.repetitionCount)
        assertEquals(domain.easinessFactor, entity.easinessFactor, 0.001f)
        assertEquals(domain.interval, entity.interval)
        assertEquals(domain.nextReviewDate, entity.nextReviewDate)
        assertEquals(domain.lastReviewedDate, entity.lastReviewedDate)
        assertEquals(domain.firstLearnedDate, entity.firstLearnedDate)

        // 验证用户交互字段
        assertEquals(domain.isFavorite, entity.isFavorite)
        assertEquals(domain.isSkipped, entity.isSkipped)
        assertEquals(domain.lastModifiedTime, entity.lastModifiedTime)
    }

    @Test
    fun `round trip conversion preserves all data`() {
        // Given: 原始Entity
        val originalEntity = WordEntity(
            id = 100,
            japanese = "テスト",
            hiragana = "てすと",
            chinese = "测试",
            level = "n5",
            tone = null,
            pos = "名*自動3",
            example1 = null,
            gloss1 = null,
            example2 = null,
            gloss2 = null,
            example3 = null,
            gloss3 = null,
            repetitionCount = 0,
            easinessFactor = 2.5f,
            interval = 0,
            nextReviewDate = 0,
            lastReviewedDate = null,
            firstLearnedDate = null,
            isFavorite = false,
            isSkipped = false,
            lastModifiedTime = 123456L
        )

        // When: Entity -> Domain -> Entity
        val roundTrippedEntity = originalEntity.toDomainModel().toEntity()

        // Then: 所有字段保持一致
        assertEquals(originalEntity, roundTrippedEntity)
    }

    @Test
    fun `batch conversion works correctly`() {
        // Given: 多个Entity
        val entities = listOf(
            createTestEntity(id = 1),
            createTestEntity(id = 2),
            createTestEntity(id = 3)
        )

        // When: 批量转换
        val domainModels = entities.toDomainModels()

        // Then: 数量和ID一致
        assertEquals(3, domainModels.size)
        assertEquals(1, domainModels[0].id)
        assertEquals(2, domainModels[1].id)
        assertEquals(3, domainModels[2].id)
    }

    private fun createTestEntity(id: Int) = WordEntity(
        id = id,
        japanese = "テスト$id",
        hiragana = "てすと$id",
        chinese = "测试$id",
        level = "n5"
    )
}
