package com.jian.nemo.core.data.repository

import com.jian.nemo.core.data.local.dao.ReviewLogDao
import com.jian.nemo.core.data.local.entity.toEntity
import com.jian.nemo.core.domain.model.ReviewLog
import com.jian.nemo.core.domain.repository.ReviewLogRepository
import javax.inject.Inject

class ReviewLogRepositoryImpl @Inject constructor(
    private val reviewLogDao: ReviewLogDao
) : ReviewLogRepository {

    override suspend fun insertLog(log: ReviewLog) {
        reviewLogDao.insertLog(log.toEntity())
    }
}
