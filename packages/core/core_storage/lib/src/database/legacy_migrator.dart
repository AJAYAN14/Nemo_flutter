import 'dart:io';
// removed native.dart import
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
// Import sqlite3 directly which is bundled with drift/native
import 'package:sqlite3/sqlite3.dart';

import 'nemo_database.dart';

class LegacyMigrator {
  /// Checks if the old Kotlin database "nemo_database" exists.
  /// If it does, and hasn't been migrated yet, reads its legacy SRS data
  /// and writes it into the new Drift database.
  static Future<void> performMigrationIfNeeded(NemoDatabase db) async {
    final docDir = await getApplicationDocumentsDirectory();
    final androidDataDir = docDir.parent.path;
    final legacyDbPath = p.join(androidDataDir, 'databases', 'nemo_database');
    final legacyDbFile = File(legacyDbPath);

    // If the old DB doesn't exist, this is a fresh install or already deleted.
    if (!legacyDbFile.existsSync()) return;

    // Check if migration was already done (e.g. if we have records in learning_progress)
    final progressCount = await db.customSelect('SELECT count(*) as c FROM learning_progress').getSingle();
    final count = progressCount.read<int>('c');
    if (count > 0) {
      // Already migrated or user has been using the new app.
      return;
    }

    print('[LegacyMigrator] Found legacy "nemo_database". Beginning data rescue migration...');

    Database? sqliteDb;
    try {
      sqliteDb = sqlite3.open(legacyDbPath);
      
      await _migrateTable(
        sqliteDb, 
        db, 
        tableName: 'word', 
        itemType: 'word',
        idPrefix: 'word_'
      );

      await _migrateTable(
        sqliteDb, 
        db, 
        tableName: 'grammar', 
        itemType: 'grammar',
        idPrefix: 'grammar_'
      );

      print('[LegacyMigrator] Migration completed successfully.');
      
      // Optionally rename the file so we don't ever read it again
      try {
        legacyDbFile.renameSync(p.join(androidDataDir, 'databases', 'nemo_database.migrated'));
      } catch (_) {}

    } catch (e) {
      print('[LegacyMigrator] Failure during migration: $e');
    } finally {
      sqliteDb?.dispose();
    }
  }

  static Future<void> _migrateTable(
    Database legacyDb, 
    NemoDatabase newDb, {
    required String tableName,
    required String itemType,
    required String idPrefix,
  }) async {
    // Check if table exists in the legacy DB
    final checkTable = legacyDb.select(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?", 
      [tableName]
    );
    if (checkTable.isEmpty) return;

    final result = legacyDb.select('SELECT * FROM $tableName');
    
    for (final row in result) {
      final idParam = row['id'];
      if (idParam == null) continue;
      
      final String idStr = idParam.toString();
      final String fullId = '$idPrefix$idStr';

      final int repetitionCount = (row['repetitionCount'] as num?)?.toInt() ?? 0;
      final int interval = (row['interval'] as num?)?.toInt() ?? 0;
      // Skip if completely new (never studied)
      if (repetitionCount == 0 && interval == 0) continue;

      // Extract floats
      final double stability = (row['stability'] as num?)?.toDouble() ?? 0.0;
      final double difficulty = (row['difficulty'] as num?)?.toDouble() ?? 0.0;
      
      // Extract days and convert to ms
      // Kotlin Day = 0 means not set.
      final int nextReviewDateDay = (row['nextReviewDate'] as num?)?.toInt() ?? 0;
      final int lastReviewedDateDay = (row['lastReviewedDate'] as num?)?.toInt() ?? 0;
      final int firstLearnedDateDay = (row['firstLearnedDate'] as num?)?.toInt() ?? 0;

      final BigInt dueTimeMs = nextReviewDateDay > 0 
          ? BigInt.from(nextReviewDateDay * 86400000) 
          : BigInt.zero;
          
      final BigInt? lastReviewedMs = lastReviewedDateDay > 0 
          ? BigInt.from(lastReviewedDateDay * 86400000) 
          : null;
          
      final BigInt? firstLearnedMs = firstLearnedDateDay > 0 
          ? BigInt.from(firstLearnedDateDay * 86400000) 
          : null;

      // Map isSkipped 
      final int isSkippedVal = (row['isSkipped'] as num?)?.toInt() ?? 0;
      final bool isSkipped = isSkippedVal == 1;

      // Step calculation - since it's graduated usually, we set step high
      final int step = repetitionCount > 0 ? 2 : 0; 

      await newDb.customInsert(
        '''
        INSERT OR REPLACE INTO learning_progress 
        (id, item_type, due_time, interval, difficulty, stability, repetition_count, 
         last_reviewed, first_learned, step, lapses, is_suspended, is_skipped, buried_until_day) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        variables: [
          Variable<String>(fullId),
          Variable<String>(itemType),
          Variable<BigInt>(dueTimeMs),
          Variable<int>(interval),
          Variable<double>(difficulty),
          Variable<double>(stability),
          Variable<int>(repetitionCount),
          lastReviewedMs != null ? Variable<BigInt>(lastReviewedMs) : const Variable<BigInt>(null),
          firstLearnedMs != null ? Variable<BigInt>(firstLearnedMs) : const Variable<BigInt>(null),
          Variable<int>(step),   
          const Variable<int>(0), 
          const Variable<bool>(false), 
          Variable<bool>(isSkipped), 
          const Variable<int>(0),   
        ]
      );
    }
  }
}
