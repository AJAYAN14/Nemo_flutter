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
  tables: [Words, WordExamples, Grammars, GrammarUsages, GrammarExamples, LearningProgress],
  daos: [WordDao, GrammarDao, LearningDao],
)
class NemoDatabase extends _$NemoDatabase {
  NemoDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 4) {
        // Ensure learning_progress table exists
        await m.createTable(learningProgress);
        
        // Ensure clean state for other tables if from old version
        if (from < 3) {
          await m.drop(grammarExamples);
          await m.drop(grammarUsages);
          await m.drop(grammars);
          await m.drop(wordExamples);
          await m.drop(words);
          await m.createAll();
        }
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
    return NativeDatabase.createInBackground(file);
  });
}

@DriftAccessor(tables: [Words, WordExamples])
class WordDao extends DatabaseAccessor<NemoDatabase> with _$WordDaoMixin {
  WordDao(super.db);

  Stream<List<WordEntry>> watchAllWords() => select(words).watch();
  
  Future<List<WordEntry>> getAllWords() => select(words).get();
  
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

  Future<int> updateProgress(LearningProgressCompanion companion) {
    return into(learningProgress).insertOnConflictUpdate(companion);
  }

  Future<List<LearningProgressData>> getAllProgress() => select(learningProgress).get();

  Future<List<LearningProgressData>> getDueItems(int now) {
    return (select(learningProgress)..where((t) => t.dueTime.isSmallerOrEqualValue(BigInt.from(now)))).get();
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
