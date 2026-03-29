import 'dart:io';
import 'package:core_domain/core_domain.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'tables.dart';

part 'nemo_database.g.dart';

@DriftDatabase(
  tables: [Words, WordExamples, Grammars, GrammarUsages, GrammarExamples, LearningProgress, StudyRecords],
  daos: [WordDao, GrammarDao, LearningDao, StudyRecordDao],
)
class NemoDatabase extends _$NemoDatabase {
  NemoDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 8;

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
      if (from < 8) {
        await m.createTable(studyRecords);
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
    return NativeDatabase(file);
  });
}

@DriftAccessor(tables: [Words, WordExamples, LearningProgress])
class WordDao extends DatabaseAccessor<NemoDatabase> with _$WordDaoMixin {
  WordDao(super.db);

  Stream<List<WordEntry>> watchAllWords() => select(words).watch();
  
  Future<List<WordEntry>> getAllWords() => select(words).get();
  
  Future<List<WordEntry>> getWordsByLevel(String level) {
    return (select(words)
          ..where((t) => t.level.equals(level))
          ..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .get();
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

  // 1:1 Restoration: Fetch new words using SQL join and proper filters
  Future<List<WordEntry>> getNewWords(String level, {bool isRandom = false}) {
    final query = select(words).join([
      leftOuterJoin(
        learningProgress,
        learningProgress.id.equalsExp(
          Constant('word_') + words.id,
        ),
      ),
    ])
      ..where(words.level.equals(level))
      ..where(
        learningProgress.repetitionCount.isNull() |
        learningProgress.repetitionCount.equals(0),
      )
      ..where(
        learningProgress.isSkipped.isNull() |
        learningProgress.isSkipped.equals(false),
      )
      ..where(
        learningProgress.isSuspended.isNull() |
        learningProgress.isSuspended.equals(false),
      )
      ..where(
        learningProgress.dueTime.isNull() |
        learningProgress.dueTime.isSmallerOrEqualValue(
          BigInt.from(DateTimeUtils.getCurrentCompensatedMillis()),
        ),
      );

    if (isRandom) {
      query.orderBy([OrderingTerm.random()]);
    } else {
      query.orderBy([OrderingTerm(expression: words.id, mode: OrderingMode.asc)]);
    }

    return query.map((row) => row.readTable(words)).get();
  }
}

@DriftAccessor(tables: [Grammars, GrammarUsages, GrammarExamples, LearningProgress])
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
    return (select(grammars)
          ..where((t) => t.grammarLevel.equals(level))
          ..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .get();
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

  // 1:1 Restoration: Fetch new grammars using SQL join and proper filters
  Future<List<GrammarEntry>> getNewGrammars(String level, {bool isRandom = false}) {
    final query = select(grammars).join([
      leftOuterJoin(
        learningProgress,
        learningProgress.id.equalsExp(
          Constant('grammar_') + grammars.id,
        ),
      ),
    ])
      ..where(grammars.grammarLevel.equals(level))
      ..where(
        learningProgress.repetitionCount.isNull() |
        learningProgress.repetitionCount.equals(0),
      )
      ..where(
        learningProgress.isSkipped.isNull() |
        learningProgress.isSkipped.equals(false),
      )
      ..where(
        learningProgress.isSuspended.isNull() |
        learningProgress.isSuspended.equals(false),
      )
      ..where(
        learningProgress.dueTime.isNull() |
        learningProgress.dueTime.isSmallerOrEqualValue(
          BigInt.from(DateTimeUtils.getCurrentCompensatedMillis()),
        ),
      );

    if (isRandom) {
      query.orderBy([OrderingTerm.random()]);
    } else {
      query.orderBy([OrderingTerm(expression: grammars.id, mode: OrderingMode.asc)]);
    }

    return query.map((row) => row.readTable(grammars)).get();
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

  Stream<List<LearningProgressData>> watchAllProgress() => select(learningProgress).watch();

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

  Stream<int> watchNewItemsCount(String itemType, int startMillis, int endMillis) {
    final query = select(learningProgress)
      ..where((t) => t.itemType.equals(itemType))
      ..where((t) => t.firstLearned.isBetweenValues(BigInt.from(startMillis), BigInt.from(endMillis)));
    return query.watch().map((list) => list.length);
  }

  Stream<int> watchReviewedItemsCount(String itemType, int startMillis, int endMillis) {
    final query = select(learningProgress)
      ..where((t) => t.itemType.equals(itemType))
      ..where((t) => t.lastReviewed.isBetweenValues(BigInt.from(startMillis), BigInt.from(endMillis)));
    return query.watch().map((list) => list.length);
  }

  Stream<int> watchDueItemsCount(String itemType, int now) {
    final query = select(learningProgress)
      ..where((t) => t.itemType.equals(itemType))
      ..where((t) => t.dueTime.isSmallerOrEqualValue(BigInt.from(now)));
    return query.watch().map((list) => list.length);
  }

  Future<List<LearningProgressData>> getSkippedItems({String? itemType}) {
    final query = select(learningProgress)
      ..where((t) => t.isSkipped.equals(true))
      ..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)]);
    
    if (itemType != null) {
      query.where((t) => t.itemType.equals(itemType));
    }
    
    return query.get();
  }

  Future<void> setSkipped(String id, bool isSkipped) {
    return (update(learningProgress)..where((t) => t.id.equals(id)))
        .write(LearningProgressCompanion(isSkipped: Value(isSkipped)));
  }

  Future<List<LearningProgressData>> getNewItems(String itemType, int startMillis, int endMillis) {
    return (select(learningProgress)
          ..where((t) => t.itemType.equals(itemType))
          ..where((t) => t.firstLearned.isBetweenValues(BigInt.from(startMillis), BigInt.from(endMillis))))
        .get();
  }

  Future<List<LearningProgressData>> getReviewedItems(String itemType, int startMillis, int endMillis) {
    return (select(learningProgress)
          ..where((t) => t.itemType.equals(itemType))
          ..where((t) => t.lastReviewed.isBetweenValues(BigInt.from(startMillis), BigInt.from(endMillis))))
        .get();
  }
}

@DriftAccessor(tables: [StudyRecords])
class StudyRecordDao extends DatabaseAccessor<NemoDatabase> with _$StudyRecordDaoMixin {
  StudyRecordDao(super.db);

  Stream<StudyRecordEntry?> watchRecordByDate(int date) {
    return (select(studyRecords)..where((t) => t.date.equals(date))).watchSingleOrNull();
  }

  Future<StudyRecordEntry?> getRecordByDate(int date) {
    return (select(studyRecords)..where((t) => t.date.equals(date))).getSingleOrNull();
  }

  Stream<List<StudyRecordEntry>> watchAllRecords() {
    return (select(studyRecords)..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])).watch();
  }

  Stream<List<StudyRecordEntry>> watchRecordsInRange(int start, int end) {
    return (select(studyRecords)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)]))
        .watch();
  }

  Future<void> upsertRecord(StudyRecordsCompanion companion) {
    return into(studyRecords).insertOnConflictUpdate(companion);
  }

  Future<void> _ensureRecordExists(int date) async {
    final existing = await getRecordByDate(date);
    if (existing == null) {
      await into(studyRecords).insert(StudyRecordsCompanion.insert(
        date: Value(date),
        timestamp: BigInt.from(DateTimeUtils.getCurrentCompensatedMillis()),
      ));
    }
  }

  Future<void> incrementLearnedWords(int date, int count) async {
    await _ensureRecordExists(date);
    await customUpdate(
      'UPDATE study_records SET learned_words = learned_words + ? WHERE date = ?',
      variables: [Variable<int>(count), Variable<int>(date)],
      updates: {studyRecords},
    );
  }

  Future<void> incrementLearnedGrammars(int date, int count) async {
    await _ensureRecordExists(date);
    await customUpdate(
      'UPDATE study_records SET learned_grammars = learned_grammars + ? WHERE date = ?',
      variables: [Variable<int>(count), Variable<int>(date)],
      updates: {studyRecords},
    );
  }

  Future<void> incrementReviewedWords(int date, int count) async {
    await _ensureRecordExists(date);
    await customUpdate(
      'UPDATE study_records SET reviewed_words = reviewed_words + ? WHERE date = ?',
      variables: [Variable<int>(count), Variable<int>(date)],
      updates: {studyRecords},
    );
  }

  Future<void> incrementReviewedGrammars(int date, int count) async {
    await _ensureRecordExists(date);
    await customUpdate(
      'UPDATE study_records SET reviewed_grammars = reviewed_grammars + ? WHERE date = ?',
      variables: [Variable<int>(count), Variable<int>(date)],
      updates: {studyRecords},
    );
  }

  Future<void> incrementSkippedWords(int date, int count) async {
    await _ensureRecordExists(date);
    await customUpdate(
      'UPDATE study_records SET skipped_words = skipped_words + ? WHERE date = ?',
      variables: [Variable<int>(count), Variable<int>(date)],
      updates: {studyRecords},
    );
  }

  Future<void> incrementSkippedGrammars(int date, int count) async {
    await _ensureRecordExists(date);
    await customUpdate(
      'UPDATE study_records SET skipped_grammars = skipped_grammars + ? WHERE date = ?',
      variables: [Variable<int>(count), Variable<int>(date)],
      updates: {studyRecords},
    );
  }

  Future<void> incrementTestCount(int date, int count) async {
    await _ensureRecordExists(date);
    await customUpdate(
      'UPDATE study_records SET test_count = test_count + ? WHERE date = ?',
      variables: [Variable<int>(count), Variable<int>(date)],
      updates: {studyRecords},
    );
  }
}

extension StudyRecordMapper on StudyRecordEntry {
  StudyRecord toDomain() {
    return StudyRecord(
      date: date,
      learnedWords: learnedWords,
      learnedGrammars: learnedGrammars,
      reviewedWords: reviewedWords,
      reviewedGrammars: reviewedGrammars,
      skippedWords: skippedWords,
      skippedGrammars: skippedGrammars,
      testCount: testCount,
      timestamp: timestamp.toInt(),
    );
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
