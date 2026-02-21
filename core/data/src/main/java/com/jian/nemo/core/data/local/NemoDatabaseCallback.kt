package com.jian.nemo.core.data.local

import android.content.Context
import android.util.Log
import androidx.room.RoomDatabase
import androidx.sqlite.db.SupportSQLiteDatabase
import com.jian.nemo.core.data.util.DataImporter
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import kotlinx.serialization.json.Json
import com.jian.nemo.core.common.di.ApplicationScope
import javax.inject.Inject
import javax.inject.Provider
import javax.inject.Singleton

/**
 * 数据库创建回调
 * 首次创建数据库时自动导入数据
 */
@Singleton
class NemoDatabaseCallback @Inject constructor(
    @ApplicationContext private val context: Context,
    private val json: Json,
    @ApplicationScope private val applicationScope: CoroutineScope,
    // 使用 Provider 避免循环依赖
    private val database: Provider<NemoDatabase>
) : RoomDatabase.Callback() {

    companion object {
        private const val TAG = "NemoDatabaseCallback"
    }

    override fun onCreate(db: SupportSQLiteDatabase) {
        super.onCreate(db)
        Log.e(TAG, "!!! 🟢 onCreate triggered")
        Log.d(TAG, "🗄️ 数据库首次创建 (初始化由 onOpen 接管)")
    }

    override fun onOpen(db: SupportSQLiteDatabase) {
        super.onOpen(db)
        Log.e(TAG, "!!! 🔵 onOpen triggered")

        // 使用 raw query 检查，避免此时获取 RoomDatabase 实例可能导致的问题
        try {
            // 1. 检查单词表
            var wordCount = 0
            db.query("SELECT count(*) FROM words").use { cursor ->
                if (cursor.moveToFirst()) {
                    wordCount = cursor.getInt(0)
                }
            }
            Log.e(TAG, "!!! 📊 Current word count: $wordCount")

            // 2. 检查语法表
            var grammarCount = 0
            var grammarLevelCount = 0
            db.query("SELECT count(*) FROM grammars").use { cursor ->
                if (cursor.moveToFirst()) {
                    grammarCount = cursor.getInt(0)
                }
            }
            db.query("SELECT count(DISTINCT grammar_level) FROM grammars").use { cursor ->
                if (cursor.moveToFirst()) {
                    grammarLevelCount = cursor.getInt(0)
                }
            }
            Log.e(TAG, "!!! 📊 Current grammar count: $grammarCount, levels: $grammarLevelCount")

            // 3. 数据同步触发
            // 由于采用了 Smart Sync (Diff) 策略，我们不再需要复杂的条件判断。
            // 每次启动都尝试同步是一个简便的策略，因为 DataImporter 会处理差异。
            // (生产环境建议配合版本号 check，但在开发阶段总是 sync 有助于快速预览 JSON 变更)
            val needImportWords = true 
            
            // 语法表同样逻辑，或者保持原状。暂时保持原状
            var needImportGrammars = false
            if (grammarCount == 0 || grammarLevelCount < 5) {
                Log.e(TAG, "!!! ⚠️ Grammar data incomplete (count=$grammarCount, levels=$grammarLevelCount), triggering import...")
                needImportGrammars = true
            }

            // 总是启动协程进行检查/同步
            Log.i(TAG, "!!! 🚀 Starting release sync coroutine...")
            applicationScope.launch {
                try {
                    importData(
                        // needResetWords 参数已在 importData 内部被忽略，这里传 false 即可
                        needResetWords = false, 
                        // 总是尝试同步单词
                        importWords = true,
                        // 语法按需导入 (或者也改为 true 如果想同步语法)
                        importGrammars = needImportGrammars
                    )
                } catch (e: Exception) {
                    Log.e(TAG, "❌ 数据同步失败: ${e.message}", e)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "❌ onOpen check failed: ${e.message}", e)
        }
    }

    private suspend fun importData(
        needResetWords: Boolean = false,
        importWords: Boolean = true,
        importGrammars: Boolean = true
    ) {
        Log.i(TAG, "!!! 📥 inside importData(reset=$needResetWords, words=$importWords, grammars=$importGrammars)")
        val nemoDatabase = database.get()
        val importer = DataImporter(context, json)

        // 单词同步
        // 现在的 importWords 是智能同步 (Smart Sync)
        // 即使 needResetWords 为 true (意味着发现异常)，我们也可以直接跑 Sync，
        // 但如果数据库中有大量重复数据导致 Unique Index 无法建立，在迁移阶段就会崩。
        // 假设已经通过 Destructive Migration 重建了，或者数据是干净的。
        if (importWords) {
            Log.i(TAG, "!!! 📖 Syncing words (Smart Sync)...")
            importer.importWords(nemoDatabase.wordDao())
        }

        if (importGrammars) {
            Log.e(TAG, "!!! 📖 Importing grammars...")
            // 导入语法
            importer.importGrammars(
                grammarDao = nemoDatabase.grammarDao(),
                grammarUsageDao = nemoDatabase.grammarUsageDao(),
                grammarExampleDao = nemoDatabase.grammarExampleDao()
            )
        }

        Log.e(TAG, "!!! 🎉 Data import/fix finished!")
    }

    private suspend fun checkAndImportMissingData() {
        // Deprecated
    }
}

