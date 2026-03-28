import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/nemo_database.dart';

part 'asset_data_importer.g.dart';

@riverpod
class AssetDataImporter extends _$AssetDataImporter {
  @override
  FutureOr<void> build() async {
    // Check if we need to import
    final db = ref.read(nemoDatabaseProvider);
    final count = await (db.select(db.words)..limit(1)).get();
    if (count.isEmpty) {
      debugPrint('[AssetDataImporter] Database is empty. Starting initial import...');
      await importAllData();
    } else {
      debugPrint('[AssetDataImporter] Database already populated with ${count.length} words (sample check).');
    }
  }

  Future<void> importAllData() async {
    final db = ref.read(nemoDatabaseProvider);
    
    try {
      // 1. Import Words
      for (var i = 1; i <= 5; i++) {
        debugPrint('[AssetDataImporter] Importing Words N$i...');
        final path = 'assets/data/words/N$i.json';
        final jsonString = await rootBundle.loadString(path);
        // Parse large JSON in background isolate to avoid blocking UI thread
        final List<dynamic> jsonList = await compute(_parseJsonList, jsonString);
        
        await db.batch((batch) {
          for (var item in jsonList) {
            final wordId = item['id'].toString();
            batch.insert(db.words, WordsCompanion.insert(
              id: wordId,
              japanese: item['expression'] ?? '',
              hiragana: item['kana'] ?? '',
              chinese: item['meaning'] ?? '',
              level: item['level'] ?? 'N$i',
              pos: Value(item['pos'] as String?),
            ));
            
            final examples = item['examples'] as List?;
            if (examples != null) {
              for (var ex in examples) {
                batch.insert(db.wordExamples, WordExamplesCompanion.insert(
                  wordId: wordId,
                  japanese: ex['ja'] ?? '',
                  chinese: ex['zh'] ?? '',
                  audioId: Value(ex['audioId'] as String?),
                ));
              }
            }
          }
        });
        debugPrint('[AssetDataImporter] Words N$i import complete.');
      }

      // 2. Import Grammar
      for (var i = 1; i <= 5; i++) {
        debugPrint('[AssetDataImporter] Importing Grammar N$i...');
        final path = 'assets/data/grammar/N$i.json';
        final jsonString = await rootBundle.loadString(path);
        // Parse large JSON in background isolate to avoid blocking UI thread
        final List<dynamic> jsonList = await compute(_parseJsonList, jsonString);
        
        await db.transaction(() async {
          for (var item in jsonList) {
            final grammarId = item['id'].toString();
            final usages = item['usages'] as List?;
            String? firstMeaning;
            if (usages != null && usages.isNotEmpty) {
              firstMeaning = usages[0]['explanation'] as String?;
            }

            await db.into(db.grammars).insert(GrammarsCompanion.insert(
              id: grammarId,
              grammar: item['title'] ?? '',
              grammarLevel: item['level'] ?? 'N$i',
              meaning: Value(firstMeaning),
            ));

            if (usages != null) {
              for (var usage in usages) {
                final usageId = await db.into(db.grammarUsages).insert(GrammarUsagesCompanion.insert(
                  grammarId: grammarId,
                  connection: usage['connection'] ?? '',
                  explanation: usage['explanation'] ?? '',
                  notes: Value(usage['notes'] as String?),
                ));

                final examples = usage['examples'] as List?;
                if (examples != null) {
                  for (var ex in examples) {
                    await db.into(db.grammarExamples).insert(GrammarExamplesCompanion.insert(
                      usageId: usageId,
                      sentence: ex['japanese'] ?? '',
                      translation: ex['chinese'] ?? '',
                      isDialog: Value(ex['isDialog'] == true),
                    ));
                  }
                }
              }
            }
          }
        });
        debugPrint('[AssetDataImporter] Grammar N$i import complete.');
      }
      debugPrint('[AssetDataImporter] SUCCESS: Full data import completed.');
    } catch (e, stack) {
      debugPrint('[AssetDataImporter] ERROR during import: $e');
      debugPrint(stack.toString());
      rethrow; // Propagation is key for UI to show error state
    }
  }
}

// Top-level parse function so it can run inside a compute isolate.
List<dynamic> _parseJsonList(String jsonString) {
  return json.decode(jsonString) as List<dynamic>;
}
