import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:core_domain/core_domain.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'tables.dart';

part 'nemo_database.g.dart';

@DriftDatabase(
  tables: [Words, WordExamples, Grammars, GrammarUsages, GrammarExamples, LearningProgress],
  daos: [WordDao, GrammarDao, LearningDao],
)
class NemoDatabase extends _$NemoDatabase {
  NemoDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 4) {
        // Ensure learning_progress table exists
        await m.createTable(learningProgress);
      }
      if (from < 5) {
        // Add firstLearned column to learning_progress
        try {
          await m.addColumn(learningProgress, learningProgress.firstLearned);
        } catch (e) {
          // In case it already exists from a failed migration
        }
      }
      if (from < 6) {
        await m.addColumn(learningProgress, learningProgress.isSuspended);
      }
      if (from < 7) {
        await m.addColumn(learningProgress, learningProgress.lapses);
        await m.addColumn(learningProgress, learningProgress.isSkipped);
      }
      
      // Ensure clean state for other tables if from old version
      if (from < 3) {
        await m.drop(grammarExamples);
        await m.drop(grammarUsages);
        await m.drop(grammars);
        await m.drop(wordExamples);
        await m.drop(words);
        await m.createAll();
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

class WordWithExamples {
  final WordEntry word;
  final List<WordExampleData> examples;
  WordWithExamples(this.word, this.examples);
}

class GrammarUsageWithExamples {
  final GrammarUsageData usage;
  final List<GrammarExampleData> examples;
  GrammarUsageWithExamples(this.usage, this.examples);
}

class GrammarWithDetails {
  final GrammarEntry grammar;
  final List<GrammarUsageWithExamples> usages;
  GrammarWithDetails(this.grammar, this.usages);

  Grammar toDomain() {
    return Grammar(
      id: grammar.id,
      grammar: grammar.grammar,
      grammarLevel: grammar.grammarLevel,
      isDelisted: grammar.isDelisted,
      usages: usages.map((u) => u.toDomain()).toList(),
      // Provide defaults for missing Database columns
      repetitionCount: 0,
      interval: 0,
      stability: 0.0,
      difficulty: 0.0,
      nextReviewDate: 0,
      lastReviewedDate: null,
      firstLearnedDate: null,
      isFavorite: grammar.isFavorite,
      isSkipped: false,
      buriedUntilDay: 0,
      lastModifiedTime: 0,
    );
  }
}

extension UsageMapper on GrammarUsageWithExamples {
  GrammarUsage toDomain() {
    return GrammarUsage(
      subtype: usage.subtype,
      connection: usage.connection,
      explanation: usage.explanation,
      notes: usage.notes,
      examples: examples.map((e) => e.toDomain()).toList(),
    );
  }
}

extension ExampleMapper on GrammarExampleData {
  GrammarExample toDomain() {
    return GrammarExample(
      sentence: sentence,
      translation: translation,
      source: source,
      isDialog: isDialog,
    );
  }
}

extension WordMapper on WordWithExamples {
  Word toDomain() {
    return Word(
      id: word.id,
      japanese: word.japanese,
      hiragana: word.hiragana,
      chinese: word.chinese,
      level: word.level,
      pos: word.pos,
      examples: examples.map((e) => e.toDomain()).toList(),
      isFavorite: word.isFavorite,
    );
  }
}

extension WordExampleMapper on WordExampleData {
  WordExample toDomain() {
    return WordExample(
      japanese: japanese,
      chinese: chinese,
      audioId: audioId,
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'nemo.sqlite'));
    // If the app bundle contains a prebuilt database asset, copy it to
    // the application documents directory on first run to avoid expensive
    // runtime JSON imports.
    try {
      // Check asset manifest first to avoid throwing if asset missing
      final manifest = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifest);
      if (manifestMap.containsKey('assets/data/nemo.sqlite')) {
        if (!await file.exists()) {
          final data = await rootBundle.load('assets/data/nemo.sqlite');
          final bytes = data.buffer.asUint8List();
          await file.writeAsBytes(bytes, flush: true);
          debugPrint('[NemoDatabase] Copied prebuilt DB to ${file.path}');
        }
      } else {
        debugPrint('[NemoDatabase] No prebuilt DB asset found in AssetManifest.');
      }
    } catch (e) {
      debugPrint('[NemoDatabase] Prebuilt DB copy skipped: $e');
    }

    return NativeDatabase.createInBackground(file);
  });
}

@DriftAccessor(tables: [Words, WordExamples])
class WordDao extends DatabaseAccessor<NemoDatabase> with _$WordDaoMixin {
  WordDao(super.db);

  Stream<List<WordEntry>> watchAllWords() => select(words).watch();
  
  Future<List<WordEntry>> getAllWords() => select(words).get();
  
  Future<List<WordEntry>> getWordsByLevel(String level) {
    return (select(words)..where((t) => t.level.equals(level))).get();
  }
  
  Stream<List<WordEntry>> watchWordsByCategory(String category) {
    return _queryWordsByCategory(category).watch();
  }

  Future<List<WordEntry>> getWordsByCategory(String category) {
    return _queryWordsByCategory(category).get();
  }

  Selectable<WordEntry> _queryWordsByCategory(String category) {
    switch (category) {
      case 'verb':
        return select(words)..where((t) => t.pos.like('他動%') | t.pos.like('自動%') | t.pos.like('自他動%'));
      case 'noun':
        return select(words)..where((t) => t.pos.like('名%') | t.pos.like('代%'));
      case 'adj':
        return select(words)..where((t) => t.pos.like('イ形%') | t.pos.like('ナ形%'));
      case 'adv':
        return select(words)..where((t) => t.pos.like('副%'));
      case 'particle':
        return select(words)..where((t) => t.pos.like('助%'));
      case 'conj':
        return select(words)..where((t) => t.pos.like('接%') & t.pos.like('接尾%').not() & t.pos.like('接頭%').not());
      case 'rentai':
        return select(words)..where((t) => t.pos.equals('連体'));
      case 'prefix':
        return select(words)..where((t) => t.pos.like('接頭%'));
      case 'suffix':
        return select(words)..where((t) => t.pos.like('接尾%'));
      case 'exclam':
        return select(words)..where((t) => t.pos.like('嘆%'));
      case 'expression':
        return select(words)..where((t) => t.pos.like('連語%'));
      case 'kata':
        // For 'kata', we might need to fetch all and filter in Dart if complex, 
        // but let's try a simple heuristic or just return empty for now if not easily queryable.
        // The old project does a complex filter in memory.
        return select(words); 
      default:
        return select(words)..where((t) => t.pos.equals(category));
    }
  }

  Future<WordWithExamples?> getWordWithExamples(String id) async {
    final word = await (select(words)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (word == null) return null;
    final examplesList = await (select(wordExamples)..where((t) => t.wordId.equals(id))).get();
    return WordWithExamples(word, examplesList);
  }

  Future<void> updateFavorite(String id, bool isFavorite) {
    return (update(words)..where((t) => t.id.equals(id))).write(WordsCompanion(isFavorite: Value(isFavorite)));
  }
}

@DriftAccessor(tables: [Grammars, GrammarUsages, GrammarExamples])
class GrammarDao extends DatabaseAccessor<NemoDatabase> with _$GrammarDaoMixin {
  GrammarDao(super.db);

  Stream<List<GrammarEntry>> watchAllGrammars() => select(grammars).watch();

  Stream<List<GrammarWithDetails>> watchAllGrammarsWithDetails() {
    final grammarStream = select(grammars).watch();
    
    return grammarStream.asyncMap((list) async {
      final List<GrammarWithDetails> results = [];
      for (var grammar in list) {
        final usages = await (select(grammarUsages)..where((t) => t.grammarId.equals(grammar.id))).get();
        final List<GrammarUsageWithExamples> usageWithExamples = [];
        for (var usage in usages) {
          final examples = await (select(grammarExamples)..where((t) => t.usageId.equals(usage.id))).get();
          usageWithExamples.add(GrammarUsageWithExamples(usage, examples));
        }
        results.add(GrammarWithDetails(grammar, usageWithExamples));
      }
      return results;
    });
  }

  Future<List<GrammarEntry>> getAllGrammars() => select(grammars).get();

  Future<List<GrammarEntry>> getGrammarsByLevel(String level) {
    return (select(grammars)..where((t) => t.grammarLevel.equals(level))).get();
  }

  Future<GrammarWithDetails?> getGrammarWithDetails(String id) async {
    final grammar = await (select(grammars)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (grammar == null) return null;
    final usagesList = await (select(grammarUsages)..where((t) => t.grammarId.equals(id))).get();
    final List<GrammarUsageWithExamples> usageWithExamples = [];
    
    for (var usage in usagesList) {
      final examplesList = await (select(grammarExamples)..where((t) => t.usageId.equals(usage.id))).get();
      usageWithExamples.add(GrammarUsageWithExamples(usage, examplesList));
    }
    
    return GrammarWithDetails(grammar, usageWithExamples);
  }
}

@DriftAccessor(tables: [LearningProgress])
class LearningDao extends DatabaseAccessor<NemoDatabase> with _$LearningDaoMixin {
  LearningDao(super.db);

  Future<LearningProgressData?> getProgress(String id) {
    return (select(learningProgress)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<LearningProgressData> updateProgress(LearningProgressCompanion companion) async {
    await into(learningProgress).insertOnConflictUpdate(companion);
    return (select(learningProgress)..where((t) => t.id.equals(companion.id.value))).getSingle();
  }

  Future<List<LearningProgressData>> getAllProgress() => select(learningProgress).get();

  Future<List<LearningProgressData>> getDueItems(int now, {String? itemType}) {
    final query = select(learningProgress)
      ..where((t) => t.dueTime.isSmallerOrEqualValue(BigInt.from(now)))
      ..where((t) => t.isSuspended.equals(false))
      ..where((t) => t.isSkipped.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.dueTime, mode: OrderingMode.asc)]);
    
    if (itemType != null) {
      query.where((t) => t.itemType.equals(itemType));
    }
    
    return query.get();
  }

  Future<List<LearningProgressData>> getUpcomingItems(int now, int withinMillis, {String? itemType}) {
    final query = select(learningProgress)
      ..where((t) => t.dueTime.isBiggerThanValue(BigInt.from(now)))
      ..where((t) => t.dueTime.isSmallerOrEqualValue(BigInt.from(now + withinMillis)))
      ..where((t) => t.isSuspended.equals(false))
      ..where((t) => t.isSkipped.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.dueTime, mode: OrderingMode.asc)]);
    
    if (itemType != null) {
      query.where((t) => t.itemType.equals(itemType));
    }
    
    return query.get();
  }

  Future<void> setSuspended(String id, bool isSuspended) {
    return (update(learningProgress)..where((t) => t.id.equals(id)))
        .write(LearningProgressCompanion(isSuspended: Value(isSuspended)));
  }

  Future<void> updateDueTime(String id, int dueTime) {
    return (update(learningProgress)..where((t) => t.id.equals(id)))
        .write(LearningProgressCompanion(dueTime: Value(BigInt.from(dueTime))));
  }

  Future<int> getNewItemsCount(String itemType, int startMillis, int endMillis) async {
    final query = select(learningProgress)
      ..where((t) => t.itemType.equals(itemType))
      ..where((t) => t.firstLearned.isBetweenValues(BigInt.from(startMillis), BigInt.from(endMillis)));
    
    final result = await query.get();
    return result.length;
  }

  Future<int> getReviewedItemsCount(String itemType, int startMillis, int endMillis) async {
    final query = select(learningProgress)
      ..where((t) => t.itemType.equals(itemType))
      ..where((t) => t.lastReviewed.isBetweenValues(BigInt.from(startMillis), BigInt.from(endMillis)));
    
    final result = await query.get();
    return result.length;
  }

  Future<int> getDueItemsCount(String itemType, int now) async {
    final query = select(learningProgress)
      ..where((t) => t.itemType.equals(itemType))
      ..where((t) => t.dueTime.isSmallerOrEqualValue(BigInt.from(now)));
    
    final result = await query.get();
    return result.length;
  }
}

@riverpod
NemoDatabase nemoDatabase(NemoDatabaseRef ref) {
  final db = NemoDatabase();
  ref.onDispose(() => db.close());
  return db;
}

@riverpod
WordDao wordDao(WordDaoRef ref) => ref.watch(nemoDatabaseProvider).wordDao;

@riverpod
GrammarDao grammarDao(GrammarDaoRef ref) => ref.watch(nemoDatabaseProvider).grammarDao;

@riverpod
LearningDao learningDao(LearningDaoRef ref) => ref.watch(nemoDatabaseProvider).learningDao;

@riverpod
Stream<List<WordEntry>> allWords(AllWordsRef ref) {
  return ref.watch(wordDaoProvider).watchAllWords();
}

@riverpod
Stream<List<GrammarEntry>> allGrammars(AllGrammarsRef ref) {
  return ref.watch(grammarDaoProvider).watchAllGrammars();
}

@riverpod
Stream<List<Grammar>> allGrammarsWithDetails(AllGrammarsWithDetailsRef ref) {
  return ref.watch(grammarDaoProvider).watchAllGrammarsWithDetails().map(
    (list) => list.map((g) => g.toDomain()).toList(),
  );
}

@riverpod
Stream<List<WordEntry>> wordsByCategory(WordsByCategoryRef ref, String category) {
  return ref.watch(wordDaoProvider).watchWordsByCategory(category);
}

@riverpod
Future<WordWithExamples?> wordWithExamples(WordWithExamplesRef ref, String id) {
  return ref.watch(wordDaoProvider).getWordWithExamples(id);
}
