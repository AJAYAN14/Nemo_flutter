import 'package:drift/drift.dart';

@DataClassName('WordEntry')
class Words extends Table {
  TextColumn get id => text()(); // Original ID from JSON
  TextColumn get japanese => text()();
  TextColumn get hiragana => text()();
  TextColumn get chinese => text()();
  TextColumn get level => text()();
  TextColumn get pos => text().nullable()();
  TextColumn get furiganaDataJson => text().nullable()(); // JSON string of List<FuriganaBlock>
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column>? get primaryKey => {id};
}

@DataClassName('WordExampleData')
class WordExamples extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get wordId => text().references(Words, #id, onDelete: KeyAction.cascade)();
  TextColumn get japanese => text()();
  TextColumn get chinese => text()();
  TextColumn get audioId => text().nullable()();
}

@DataClassName('GrammarEntry')
class Grammars extends Table {
  TextColumn get id => text()();
  TextColumn get grammar => text()();
  TextColumn get grammarLevel => text()();
  TextColumn get meaning => text().nullable()();
  BoolColumn get isDelisted => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column>? get primaryKey => {id};
}

@DataClassName('GrammarUsageData')
class GrammarUsages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get grammarId => text().references(Grammars, #id, onDelete: KeyAction.cascade)();
  TextColumn get subtype => text().nullable()();
  TextColumn get connection => text()();
  TextColumn get explanation => text()();
  TextColumn get notes => text().nullable()();
}

@DataClassName('GrammarExampleData')
class GrammarExamples extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get usageId => integer().references(GrammarUsages, #id, onDelete: KeyAction.cascade)();
  TextColumn get sentence => text()();
  TextColumn get translation => text()();
  TextColumn get source => text().nullable()();
  BoolColumn get isDialog => boolean().withDefault(const Constant(false))();
}

@DataClassName('LearningProgressData')
class LearningProgress extends Table {
  TextColumn get id => text()(); // "word_w1" or "grammar_g1"
  TextColumn get itemType => text()(); // 'word' or 'grammar'
  
  Int64Column get dueTime => int64().withDefault(Constant(BigInt.zero))();
  IntColumn get interval => integer().withDefault(const Constant(0))();
  RealColumn get difficulty => real().withDefault(const Constant(0.0))();
  RealColumn get stability => real().withDefault(const Constant(0.0))();
  IntColumn get repetitionCount => integer().withDefault(const Constant(0))();
  Int64Column get lastReviewed => int64().nullable()();
  Int64Column get firstLearned => int64().nullable()();
  IntColumn get step => integer().withDefault(const Constant(0))();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  BoolColumn get isSuspended => boolean().withDefault(const Constant(false))();
  BoolColumn get isSkipped => boolean().withDefault(const Constant(false))();

  @override
  Set<Column>? get primaryKey => {id};
}
