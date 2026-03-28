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
    try {
      final count = await (db.select(db.words)..limit(1)).get();
      if (count.isEmpty) {
        debugPrint('[AssetDataImporter] Database is empty. Starting initial import...');
        await importAllData();
      } else {
        debugPrint('[AssetDataImporter] Database already populated.');
      }
    } catch (e, stack) {
      debugPrint('[AssetDataImporter] build() CRITICAL ERROR: $e');
      debugPrint(stack.toString());
      rethrow;
    }
  }

  Future<void> importAllData() async {
    final db = ref.read(nemoDatabaseProvider);
    
    try {
      // 1. Import Words
      for (var i = 1; i <= 5; i++) {
        debugPrint('[AssetDataImporter] Importing Words N$i...');
        final path = 'assets/data/words/N$i.json';
        final String jsonString;
        try {
          jsonString = await rootBundle.loadString(path);
        } catch (e) {
          debugPrint('[AssetDataImporter] FATAL: Could not load word file at $path: $e');
          rethrow;
        }

        final List<dynamic> jsonList = json.decode(jsonString);
        
        await db.batch((batch) {
          for (var item in jsonList) {
            final wordId = item['id']?.toString() ?? 'unknown_word_N${i}_${jsonList.indexOf(item)}';
            try {
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
            } catch (e) {
              debugPrint('[AssetDataImporter] Error processing word item $wordId in N$i: $e');
            }
          }
        });
        debugPrint('[AssetDataImporter] Words N$i import complete.');
      }

      // 2. Import Grammar
      for (var i = 1; i <= 5; i++) {
        debugPrint('[AssetDataImporter] Importing Grammar N$i...');
        final path = 'assets/data/grammar/N$i.json';
        final String jsonString;
        try {
          jsonString = await rootBundle.loadString(path);
        } catch (e) {
          debugPrint('[AssetDataImporter] FATAL: Could not load grammar file at $path: $e');
          rethrow;
        }

        final List<dynamic> jsonList = json.decode(jsonString);
        
        await db.transaction(() async {
          for (var item in jsonList) {
            final grammarId = item['id']?.toString() ?? 'unknown_N${i}_${jsonList.indexOf(item)}';
            try {
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
                    subtype: Value(usage['subtype'] as String?),
                    connection: usage['connection'] ?? '',
                    explanation: usage['explanation'] ?? '',
                    notes: Value(usage['notes'] as String?),
                  ));

                  final examples = usage['examples'] as List?;
                  if (examples != null) {
                    for (var ex in examples) {
                      await db.into(db.grammarExamples).insert(GrammarExamplesCompanion.insert(
                        usageId: usageId,
                        sentence: ex['sentence'] ?? ex['japanese'] ?? '',
                        translation: ex['translation'] ?? ex['chinese'] ?? '',
                        source: Value(ex['source'] as String?),
                        isDialog: Value(ex['isDialog'] == true),
                      ));
                    }
                  }
                }
              }
            } catch (e) {
              debugPrint('[AssetDataImporter] Error importing grammar item $grammarId in N$i: $e');
              rethrow;
            }
          }
        });
        debugPrint('[AssetDataImporter] Grammar N$i import complete.');
      }
      debugPrint('[AssetDataImporter] SUCCESS: Full data import completed.');
    } catch (e, stack) {
      debugPrint('[AssetDataImporter] CRITICAL ERROR during import: $e');
      debugPrint('Stack trace: $stack');
      rethrow; 
    }
  }
}
