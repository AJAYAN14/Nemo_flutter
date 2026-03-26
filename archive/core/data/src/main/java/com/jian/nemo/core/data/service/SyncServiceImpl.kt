package com.jian.nemo.core.data.service

import com.jian.nemo.core.domain.repository.SettingsRepository
import com.jian.nemo.core.domain.service.SyncManager
import com.jian.nemo.core.domain.service.SyncService
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import javax.inject.Inject
import javax.inject.Singleton

/**
 * 同步服务实现
 * 负责核心业务决策：是否开启同步、同步频率检查等。
 * 已从 Domain 层迁移至 Data 层以支持更好的 Hilt 注入。
 */
@Singleton
class SyncServiceImpl @Inject constructor(
    private val settingsRepository: SettingsRepository,
    private val syncManager: SyncManager
) : SyncService {

    private val scope = CoroutineScope(Dispatchers.IO + SupervisorJob())

    companion object {
        private const val MIN_SYNC_INTERVAL = 60 * 1000L // 1分钟
    }

    override fun onLearningCompleted() {
        scope.launch {
            val isEnabled = settingsRepository.isSyncOnLearningCompleteFlow.first()
            if (isEnabled) {
                scheduleSyncIfNeeded(checkInterval = false)
            }
        }
    }

    override fun onTestCompleted() {
        scope.launch {
            val isEnabled = settingsRepository.isSyncOnTestCompleteFlow.first()
            if (isEnabled) {
                scheduleSyncIfNeeded(checkInterval = false)
            }
        }
    }

    override fun onAppForeground() {
        // 确保周期性同步已调度
        syncManager.startPeriodicSync()

        scheduleSyncIfNeeded(checkInterval = true)
    }

    private fun scheduleSyncIfNeeded(checkInterval: Boolean) {
        scope.launch {
            // 1. 检查总开关
            val isEnabled = settingsRepository.isAutoSyncEnabledFlow.first()
            if (!isEnabled) return@launch

            // 2. 检查时间间隔
            if (checkInterval) {
                val lastSyncTime = settingsRepository.lastSyncTimeFlow.first()
                val now = System.currentTimeMillis()
                if (now - lastSyncTime < MIN_SYNC_INTERVAL) {
                    return@launch
                }
            }

            // 3. 执行物理同步
            syncManager.startSync()
        }
    }
}
