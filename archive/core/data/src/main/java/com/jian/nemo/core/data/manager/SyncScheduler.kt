package com.jian.nemo.core.data.manager

import android.content.Context
import android.util.Log
import androidx.work.*
import com.jian.nemo.core.data.worker.AutoSyncWorker
import com.jian.nemo.core.domain.service.SyncManager
import dagger.hilt.android.qualifiers.ApplicationContext
import java.util.concurrent.TimeUnit
import javax.inject.Inject
import javax.inject.Singleton

/**
 * 同步调度器
 * 负责与 WorkManager 交互，执行后台同步任务。
 */
@Singleton
class SyncScheduler @Inject constructor(
    @ApplicationContext private val context: Context
) : SyncManager {

    companion object {
        private const val TAG = "SyncScheduler"
    }

    override fun startSync() {
        Log.d(TAG, "手动触发单次后台同步...")
        val constraints = Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED)
            .build()

        val syncRequest = OneTimeWorkRequestBuilder<AutoSyncWorker>()
            .setConstraints(constraints)
            .addTag(AutoSyncWorker.WORK_NAME)
            .build()

        WorkManager.getInstance(context).enqueueUniqueWork(
            "one_time_sync_${System.currentTimeMillis()}",
            ExistingWorkPolicy.REPLACE,
            syncRequest
        )
    }

    override fun startPeriodicSync() {
        Log.d(TAG, "启动周期性后台同步调度 (15分钟/次)...")
        val constraints = Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED)
            .build()

        val periodicRequest = PeriodicWorkRequestBuilder<AutoSyncWorker>(
            15, TimeUnit.MINUTES
        )
            .setConstraints(constraints)
            .addTag(AutoSyncWorker.WORK_NAME)
            .build()

        WorkManager.getInstance(context).enqueueUniquePeriodicWork(
            AutoSyncWorker.WORK_NAME,
            ExistingPeriodicWorkPolicy.KEEP,
            periodicRequest
        )
    }
}
