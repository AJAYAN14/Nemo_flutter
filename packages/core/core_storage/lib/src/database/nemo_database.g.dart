// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nemo_database.dart';

// ignore_for_file: type=lint
class $WordsTable extends Words with TableInfo<$WordsTable, WordEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _japaneseMeta = const VerificationMeta(
    'japanese',
  );
  @override
  late final GeneratedColumn<String> japanese = GeneratedColumn<String>(
    'japanese',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hiraganaMeta = const VerificationMeta(
    'hiragana',
  );
  @override
  late final GeneratedColumn<String> hiragana = GeneratedColumn<String>(
    'hiragana',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chineseMeta = const VerificationMeta(
    'chinese',
  );
  @override
  late final GeneratedColumn<String> chinese = GeneratedColumn<String>(
    'chinese',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posMeta = const VerificationMeta('pos');
  @override
  late final GeneratedColumn<String> pos = GeneratedColumn<String>(
    'pos',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _furiganaDataJsonMeta = const VerificationMeta(
    'furiganaDataJson',
  );
  @override
  late final GeneratedColumn<String> furiganaDataJson = GeneratedColumn<String>(
    'furigana_data_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    japanese,
    hiragana,
    chinese,
    level,
    pos,
    furiganaDataJson,
    isFavorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('japanese')) {
      context.handle(
        _japaneseMeta,
        japanese.isAcceptableOrUnknown(data['japanese']!, _japaneseMeta),
      );
    } else if (isInserting) {
      context.missing(_japaneseMeta);
    }
    if (data.containsKey('hiragana')) {
      context.handle(
        _hiraganaMeta,
        hiragana.isAcceptableOrUnknown(data['hiragana']!, _hiraganaMeta),
      );
    } else if (isInserting) {
      context.missing(_hiraganaMeta);
    }
    if (data.containsKey('chinese')) {
      context.handle(
        _chineseMeta,
        chinese.isAcceptableOrUnknown(data['chinese']!, _chineseMeta),
      );
    } else if (isInserting) {
      context.missing(_chineseMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('pos')) {
      context.handle(
        _posMeta,
        pos.isAcceptableOrUnknown(data['pos']!, _posMeta),
      );
    }
    if (data.containsKey('furigana_data_json')) {
      context.handle(
        _furiganaDataJsonMeta,
        furiganaDataJson.isAcceptableOrUnknown(
          data['furigana_data_json']!,
          _furiganaDataJsonMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WordEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      japanese: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}japanese'],
      )!,
      hiragana: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hiragana'],
      )!,
      chinese: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chinese'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      pos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos'],
      ),
      furiganaDataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}furigana_data_json'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }
}

class WordEntry extends DataClass implements Insertable<WordEntry> {
  final String id;
  final String japanese;
  final String hiragana;
  final String chinese;
  final String level;
  final String? pos;
  final String? furiganaDataJson;
  final bool isFavorite;
  const WordEntry({
    required this.id,
    required this.japanese,
    required this.hiragana,
    required this.chinese,
    required this.level,
    this.pos,
    this.furiganaDataJson,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['japanese'] = Variable<String>(japanese);
    map['hiragana'] = Variable<String>(hiragana);
    map['chinese'] = Variable<String>(chinese);
    map['level'] = Variable<String>(level);
    if (!nullToAbsent || pos != null) {
      map['pos'] = Variable<String>(pos);
    }
    if (!nullToAbsent || furiganaDataJson != null) {
      map['furigana_data_json'] = Variable<String>(furiganaDataJson);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      japanese: Value(japanese),
      hiragana: Value(hiragana),
      chinese: Value(chinese),
      level: Value(level),
      pos: pos == null && nullToAbsent ? const Value.absent() : Value(pos),
      furiganaDataJson: furiganaDataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(furiganaDataJson),
      isFavorite: Value(isFavorite),
    );
  }

  factory WordEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordEntry(
      id: serializer.fromJson<String>(json['id']),
      japanese: serializer.fromJson<String>(json['japanese']),
      hiragana: serializer.fromJson<String>(json['hiragana']),
      chinese: serializer.fromJson<String>(json['chinese']),
      level: serializer.fromJson<String>(json['level']),
      pos: serializer.fromJson<String?>(json['pos']),
      furiganaDataJson: serializer.fromJson<String?>(json['furiganaDataJson']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'japanese': serializer.toJson<String>(japanese),
      'hiragana': serializer.toJson<String>(hiragana),
      'chinese': serializer.toJson<String>(chinese),
      'level': serializer.toJson<String>(level),
      'pos': serializer.toJson<String?>(pos),
      'furiganaDataJson': serializer.toJson<String?>(furiganaDataJson),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  WordEntry copyWith({
    String? id,
    String? japanese,
    String? hiragana,
    String? chinese,
    String? level,
    Value<String?> pos = const Value.absent(),
    Value<String?> furiganaDataJson = const Value.absent(),
    bool? isFavorite,
  }) => WordEntry(
    id: id ?? this.id,
    japanese: japanese ?? this.japanese,
    hiragana: hiragana ?? this.hiragana,
    chinese: chinese ?? this.chinese,
    level: level ?? this.level,
    pos: pos.present ? pos.value : this.pos,
    furiganaDataJson: furiganaDataJson.present
        ? furiganaDataJson.value
        : this.furiganaDataJson,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  WordEntry copyWithCompanion(WordsCompanion data) {
    return WordEntry(
      id: data.id.present ? data.id.value : this.id,
      japanese: data.japanese.present ? data.japanese.value : this.japanese,
      hiragana: data.hiragana.present ? data.hiragana.value : this.hiragana,
      chinese: data.chinese.present ? data.chinese.value : this.chinese,
      level: data.level.present ? data.level.value : this.level,
      pos: data.pos.present ? data.pos.value : this.pos,
      furiganaDataJson: data.furiganaDataJson.present
          ? data.furiganaDataJson.value
          : this.furiganaDataJson,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordEntry(')
          ..write('id: $id, ')
          ..write('japanese: $japanese, ')
          ..write('hiragana: $hiragana, ')
          ..write('chinese: $chinese, ')
          ..write('level: $level, ')
          ..write('pos: $pos, ')
          ..write('furiganaDataJson: $furiganaDataJson, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    japanese,
    hiragana,
    chinese,
    level,
    pos,
    furiganaDataJson,
    isFavorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordEntry &&
          other.id == this.id &&
          other.japanese == this.japanese &&
          other.hiragana == this.hiragana &&
          other.chinese == this.chinese &&
          other.level == this.level &&
          other.pos == this.pos &&
          other.furiganaDataJson == this.furiganaDataJson &&
          other.isFavorite == this.isFavorite);
}

class WordsCompanion extends UpdateCompanion<WordEntry> {
  final Value<String> id;
  final Value<String> japanese;
  final Value<String> hiragana;
  final Value<String> chinese;
  final Value<String> level;
  final Value<String?> pos;
  final Value<String?> furiganaDataJson;
  final Value<bool> isFavorite;
  final Value<int> rowid;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.japanese = const Value.absent(),
    this.hiragana = const Value.absent(),
    this.chinese = const Value.absent(),
    this.level = const Value.absent(),
    this.pos = const Value.absent(),
    this.furiganaDataJson = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordsCompanion.insert({
    required String id,
    required String japanese,
    required String hiragana,
    required String chinese,
    required String level,
    this.pos = const Value.absent(),
    this.furiganaDataJson = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       japanese = Value(japanese),
       hiragana = Value(hiragana),
       chinese = Value(chinese),
       level = Value(level);
  static Insertable<WordEntry> custom({
    Expression<String>? id,
    Expression<String>? japanese,
    Expression<String>? hiragana,
    Expression<String>? chinese,
    Expression<String>? level,
    Expression<String>? pos,
    Expression<String>? furiganaDataJson,
    Expression<bool>? isFavorite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (japanese != null) 'japanese': japanese,
      if (hiragana != null) 'hiragana': hiragana,
      if (chinese != null) 'chinese': chinese,
      if (level != null) 'level': level,
      if (pos != null) 'pos': pos,
      if (furiganaDataJson != null) 'furigana_data_json': furiganaDataJson,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordsCompanion copyWith({
    Value<String>? id,
    Value<String>? japanese,
    Value<String>? hiragana,
    Value<String>? chinese,
    Value<String>? level,
    Value<String?>? pos,
    Value<String?>? furiganaDataJson,
    Value<bool>? isFavorite,
    Value<int>? rowid,
  }) {
    return WordsCompanion(
      id: id ?? this.id,
      japanese: japanese ?? this.japanese,
      hiragana: hiragana ?? this.hiragana,
      chinese: chinese ?? this.chinese,
      level: level ?? this.level,
      pos: pos ?? this.pos,
      furiganaDataJson: furiganaDataJson ?? this.furiganaDataJson,
      isFavorite: isFavorite ?? this.isFavorite,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (japanese.present) {
      map['japanese'] = Variable<String>(japanese.value);
    }
    if (hiragana.present) {
      map['hiragana'] = Variable<String>(hiragana.value);
    }
    if (chinese.present) {
      map['chinese'] = Variable<String>(chinese.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (pos.present) {
      map['pos'] = Variable<String>(pos.value);
    }
    if (furiganaDataJson.present) {
      map['furigana_data_json'] = Variable<String>(furiganaDataJson.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('japanese: $japanese, ')
          ..write('hiragana: $hiragana, ')
          ..write('chinese: $chinese, ')
          ..write('level: $level, ')
          ..write('pos: $pos, ')
          ..write('furiganaDataJson: $furiganaDataJson, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WordExamplesTable extends WordExamples
    with TableInfo<$WordExamplesTable, WordExampleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordExamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _japaneseMeta = const VerificationMeta(
    'japanese',
  );
  @override
  late final GeneratedColumn<String> japanese = GeneratedColumn<String>(
    'japanese',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chineseMeta = const VerificationMeta(
    'chinese',
  );
  @override
  late final GeneratedColumn<String> chinese = GeneratedColumn<String>(
    'chinese',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioIdMeta = const VerificationMeta(
    'audioId',
  );
  @override
  late final GeneratedColumn<String> audioId = GeneratedColumn<String>(
    'audio_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wordId,
    japanese,
    chinese,
    audioId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'word_examples';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordExampleData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('japanese')) {
      context.handle(
        _japaneseMeta,
        japanese.isAcceptableOrUnknown(data['japanese']!, _japaneseMeta),
      );
    } else if (isInserting) {
      context.missing(_japaneseMeta);
    }
    if (data.containsKey('chinese')) {
      context.handle(
        _chineseMeta,
        chinese.isAcceptableOrUnknown(data['chinese']!, _chineseMeta),
      );
    } else if (isInserting) {
      context.missing(_chineseMeta);
    }
    if (data.containsKey('audio_id')) {
      context.handle(
        _audioIdMeta,
        audioId.isAcceptableOrUnknown(data['audio_id']!, _audioIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WordExampleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordExampleData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      japanese: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}japanese'],
      )!,
      chinese: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chinese'],
      )!,
      audioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_id'],
      ),
    );
  }

  @override
  $WordExamplesTable createAlias(String alias) {
    return $WordExamplesTable(attachedDatabase, alias);
  }
}

class WordExampleData extends DataClass implements Insertable<WordExampleData> {
  final int id;
  final String wordId;
  final String japanese;
  final String chinese;
  final String? audioId;
  const WordExampleData({
    required this.id,
    required this.wordId,
    required this.japanese,
    required this.chinese,
    this.audioId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word_id'] = Variable<String>(wordId);
    map['japanese'] = Variable<String>(japanese);
    map['chinese'] = Variable<String>(chinese);
    if (!nullToAbsent || audioId != null) {
      map['audio_id'] = Variable<String>(audioId);
    }
    return map;
  }

  WordExamplesCompanion toCompanion(bool nullToAbsent) {
    return WordExamplesCompanion(
      id: Value(id),
      wordId: Value(wordId),
      japanese: Value(japanese),
      chinese: Value(chinese),
      audioId: audioId == null && nullToAbsent
          ? const Value.absent()
          : Value(audioId),
    );
  }

  factory WordExampleData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordExampleData(
      id: serializer.fromJson<int>(json['id']),
      wordId: serializer.fromJson<String>(json['wordId']),
      japanese: serializer.fromJson<String>(json['japanese']),
      chinese: serializer.fromJson<String>(json['chinese']),
      audioId: serializer.fromJson<String?>(json['audioId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wordId': serializer.toJson<String>(wordId),
      'japanese': serializer.toJson<String>(japanese),
      'chinese': serializer.toJson<String>(chinese),
      'audioId': serializer.toJson<String?>(audioId),
    };
  }

  WordExampleData copyWith({
    int? id,
    String? wordId,
    String? japanese,
    String? chinese,
    Value<String?> audioId = const Value.absent(),
  }) => WordExampleData(
    id: id ?? this.id,
    wordId: wordId ?? this.wordId,
    japanese: japanese ?? this.japanese,
    chinese: chinese ?? this.chinese,
    audioId: audioId.present ? audioId.value : this.audioId,
  );
  WordExampleData copyWithCompanion(WordExamplesCompanion data) {
    return WordExampleData(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      japanese: data.japanese.present ? data.japanese.value : this.japanese,
      chinese: data.chinese.present ? data.chinese.value : this.chinese,
      audioId: data.audioId.present ? data.audioId.value : this.audioId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordExampleData(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('japanese: $japanese, ')
          ..write('chinese: $chinese, ')
          ..write('audioId: $audioId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, wordId, japanese, chinese, audioId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordExampleData &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.japanese == this.japanese &&
          other.chinese == this.chinese &&
          other.audioId == this.audioId);
}

class WordExamplesCompanion extends UpdateCompanion<WordExampleData> {
  final Value<int> id;
  final Value<String> wordId;
  final Value<String> japanese;
  final Value<String> chinese;
  final Value<String?> audioId;
  const WordExamplesCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.japanese = const Value.absent(),
    this.chinese = const Value.absent(),
    this.audioId = const Value.absent(),
  });
  WordExamplesCompanion.insert({
    this.id = const Value.absent(),
    required String wordId,
    required String japanese,
    required String chinese,
    this.audioId = const Value.absent(),
  }) : wordId = Value(wordId),
       japanese = Value(japanese),
       chinese = Value(chinese);
  static Insertable<WordExampleData> custom({
    Expression<int>? id,
    Expression<String>? wordId,
    Expression<String>? japanese,
    Expression<String>? chinese,
    Expression<String>? audioId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (japanese != null) 'japanese': japanese,
      if (chinese != null) 'chinese': chinese,
      if (audioId != null) 'audio_id': audioId,
    });
  }

  WordExamplesCompanion copyWith({
    Value<int>? id,
    Value<String>? wordId,
    Value<String>? japanese,
    Value<String>? chinese,
    Value<String?>? audioId,
  }) {
    return WordExamplesCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      japanese: japanese ?? this.japanese,
      chinese: chinese ?? this.chinese,
      audioId: audioId ?? this.audioId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (japanese.present) {
      map['japanese'] = Variable<String>(japanese.value);
    }
    if (chinese.present) {
      map['chinese'] = Variable<String>(chinese.value);
    }
    if (audioId.present) {
      map['audio_id'] = Variable<String>(audioId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordExamplesCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('japanese: $japanese, ')
          ..write('chinese: $chinese, ')
          ..write('audioId: $audioId')
          ..write(')'))
        .toString();
  }
}

class $GrammarsTable extends Grammars
    with TableInfo<$GrammarsTable, GrammarEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grammarMeta = const VerificationMeta(
    'grammar',
  );
  @override
  late final GeneratedColumn<String> grammar = GeneratedColumn<String>(
    'grammar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grammarLevelMeta = const VerificationMeta(
    'grammarLevel',
  );
  @override
  late final GeneratedColumn<String> grammarLevel = GeneratedColumn<String>(
    'grammar_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  @override
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDelistedMeta = const VerificationMeta(
    'isDelisted',
  );
  @override
  late final GeneratedColumn<bool> isDelisted = GeneratedColumn<bool>(
    'is_delisted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_delisted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    grammar,
    grammarLevel,
    meaning,
    isDelisted,
    isFavorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammars';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('grammar')) {
      context.handle(
        _grammarMeta,
        grammar.isAcceptableOrUnknown(data['grammar']!, _grammarMeta),
      );
    } else if (isInserting) {
      context.missing(_grammarMeta);
    }
    if (data.containsKey('grammar_level')) {
      context.handle(
        _grammarLevelMeta,
        grammarLevel.isAcceptableOrUnknown(
          data['grammar_level']!,
          _grammarLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_grammarLevelMeta);
    }
    if (data.containsKey('meaning')) {
      context.handle(
        _meaningMeta,
        meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta),
      );
    }
    if (data.containsKey('is_delisted')) {
      context.handle(
        _isDelistedMeta,
        isDelisted.isAcceptableOrUnknown(data['is_delisted']!, _isDelistedMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      grammar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grammar'],
      )!,
      grammarLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grammar_level'],
      )!,
      meaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning'],
      ),
      isDelisted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_delisted'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
    );
  }

  @override
  $GrammarsTable createAlias(String alias) {
    return $GrammarsTable(attachedDatabase, alias);
  }
}

class GrammarEntry extends DataClass implements Insertable<GrammarEntry> {
  final String id;
  final String grammar;
  final String grammarLevel;
  final String? meaning;
  final bool isDelisted;
  final bool isFavorite;
  const GrammarEntry({
    required this.id,
    required this.grammar,
    required this.grammarLevel,
    this.meaning,
    required this.isDelisted,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['grammar'] = Variable<String>(grammar);
    map['grammar_level'] = Variable<String>(grammarLevel);
    if (!nullToAbsent || meaning != null) {
      map['meaning'] = Variable<String>(meaning);
    }
    map['is_delisted'] = Variable<bool>(isDelisted);
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  GrammarsCompanion toCompanion(bool nullToAbsent) {
    return GrammarsCompanion(
      id: Value(id),
      grammar: Value(grammar),
      grammarLevel: Value(grammarLevel),
      meaning: meaning == null && nullToAbsent
          ? const Value.absent()
          : Value(meaning),
      isDelisted: Value(isDelisted),
      isFavorite: Value(isFavorite),
    );
  }

  factory GrammarEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarEntry(
      id: serializer.fromJson<String>(json['id']),
      grammar: serializer.fromJson<String>(json['grammar']),
      grammarLevel: serializer.fromJson<String>(json['grammarLevel']),
      meaning: serializer.fromJson<String?>(json['meaning']),
      isDelisted: serializer.fromJson<bool>(json['isDelisted']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'grammar': serializer.toJson<String>(grammar),
      'grammarLevel': serializer.toJson<String>(grammarLevel),
      'meaning': serializer.toJson<String?>(meaning),
      'isDelisted': serializer.toJson<bool>(isDelisted),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  GrammarEntry copyWith({
    String? id,
    String? grammar,
    String? grammarLevel,
    Value<String?> meaning = const Value.absent(),
    bool? isDelisted,
    bool? isFavorite,
  }) => GrammarEntry(
    id: id ?? this.id,
    grammar: grammar ?? this.grammar,
    grammarLevel: grammarLevel ?? this.grammarLevel,
    meaning: meaning.present ? meaning.value : this.meaning,
    isDelisted: isDelisted ?? this.isDelisted,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  GrammarEntry copyWithCompanion(GrammarsCompanion data) {
    return GrammarEntry(
      id: data.id.present ? data.id.value : this.id,
      grammar: data.grammar.present ? data.grammar.value : this.grammar,
      grammarLevel: data.grammarLevel.present
          ? data.grammarLevel.value
          : this.grammarLevel,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
      isDelisted: data.isDelisted.present
          ? data.isDelisted.value
          : this.isDelisted,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarEntry(')
          ..write('id: $id, ')
          ..write('grammar: $grammar, ')
          ..write('grammarLevel: $grammarLevel, ')
          ..write('meaning: $meaning, ')
          ..write('isDelisted: $isDelisted, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, grammar, grammarLevel, meaning, isDelisted, isFavorite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarEntry &&
          other.id == this.id &&
          other.grammar == this.grammar &&
          other.grammarLevel == this.grammarLevel &&
          other.meaning == this.meaning &&
          other.isDelisted == this.isDelisted &&
          other.isFavorite == this.isFavorite);
}

class GrammarsCompanion extends UpdateCompanion<GrammarEntry> {
  final Value<String> id;
  final Value<String> grammar;
  final Value<String> grammarLevel;
  final Value<String?> meaning;
  final Value<bool> isDelisted;
  final Value<bool> isFavorite;
  final Value<int> rowid;
  const GrammarsCompanion({
    this.id = const Value.absent(),
    this.grammar = const Value.absent(),
    this.grammarLevel = const Value.absent(),
    this.meaning = const Value.absent(),
    this.isDelisted = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GrammarsCompanion.insert({
    required String id,
    required String grammar,
    required String grammarLevel,
    this.meaning = const Value.absent(),
    this.isDelisted = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       grammar = Value(grammar),
       grammarLevel = Value(grammarLevel);
  static Insertable<GrammarEntry> custom({
    Expression<String>? id,
    Expression<String>? grammar,
    Expression<String>? grammarLevel,
    Expression<String>? meaning,
    Expression<bool>? isDelisted,
    Expression<bool>? isFavorite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (grammar != null) 'grammar': grammar,
      if (grammarLevel != null) 'grammar_level': grammarLevel,
      if (meaning != null) 'meaning': meaning,
      if (isDelisted != null) 'is_delisted': isDelisted,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GrammarsCompanion copyWith({
    Value<String>? id,
    Value<String>? grammar,
    Value<String>? grammarLevel,
    Value<String?>? meaning,
    Value<bool>? isDelisted,
    Value<bool>? isFavorite,
    Value<int>? rowid,
  }) {
    return GrammarsCompanion(
      id: id ?? this.id,
      grammar: grammar ?? this.grammar,
      grammarLevel: grammarLevel ?? this.grammarLevel,
      meaning: meaning ?? this.meaning,
      isDelisted: isDelisted ?? this.isDelisted,
      isFavorite: isFavorite ?? this.isFavorite,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (grammar.present) {
      map['grammar'] = Variable<String>(grammar.value);
    }
    if (grammarLevel.present) {
      map['grammar_level'] = Variable<String>(grammarLevel.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    if (isDelisted.present) {
      map['is_delisted'] = Variable<bool>(isDelisted.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarsCompanion(')
          ..write('id: $id, ')
          ..write('grammar: $grammar, ')
          ..write('grammarLevel: $grammarLevel, ')
          ..write('meaning: $meaning, ')
          ..write('isDelisted: $isDelisted, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GrammarUsagesTable extends GrammarUsages
    with TableInfo<$GrammarUsagesTable, GrammarUsageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarUsagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _grammarIdMeta = const VerificationMeta(
    'grammarId',
  );
  @override
  late final GeneratedColumn<String> grammarId = GeneratedColumn<String>(
    'grammar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES grammars (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _subtypeMeta = const VerificationMeta(
    'subtype',
  );
  @override
  late final GeneratedColumn<String> subtype = GeneratedColumn<String>(
    'subtype',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _connectionMeta = const VerificationMeta(
    'connection',
  );
  @override
  late final GeneratedColumn<String> connection = GeneratedColumn<String>(
    'connection',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    grammarId,
    subtype,
    connection,
    explanation,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_usages';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarUsageData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('grammar_id')) {
      context.handle(
        _grammarIdMeta,
        grammarId.isAcceptableOrUnknown(data['grammar_id']!, _grammarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_grammarIdMeta);
    }
    if (data.containsKey('subtype')) {
      context.handle(
        _subtypeMeta,
        subtype.isAcceptableOrUnknown(data['subtype']!, _subtypeMeta),
      );
    }
    if (data.containsKey('connection')) {
      context.handle(
        _connectionMeta,
        connection.isAcceptableOrUnknown(data['connection']!, _connectionMeta),
      );
    } else if (isInserting) {
      context.missing(_connectionMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarUsageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarUsageData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      grammarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grammar_id'],
      )!,
      subtype: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtype'],
      ),
      connection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}connection'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $GrammarUsagesTable createAlias(String alias) {
    return $GrammarUsagesTable(attachedDatabase, alias);
  }
}

class GrammarUsageData extends DataClass
    implements Insertable<GrammarUsageData> {
  final int id;
  final String grammarId;
  final String? subtype;
  final String connection;
  final String explanation;
  final String? notes;
  const GrammarUsageData({
    required this.id,
    required this.grammarId,
    this.subtype,
    required this.connection,
    required this.explanation,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['grammar_id'] = Variable<String>(grammarId);
    if (!nullToAbsent || subtype != null) {
      map['subtype'] = Variable<String>(subtype);
    }
    map['connection'] = Variable<String>(connection);
    map['explanation'] = Variable<String>(explanation);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  GrammarUsagesCompanion toCompanion(bool nullToAbsent) {
    return GrammarUsagesCompanion(
      id: Value(id),
      grammarId: Value(grammarId),
      subtype: subtype == null && nullToAbsent
          ? const Value.absent()
          : Value(subtype),
      connection: Value(connection),
      explanation: Value(explanation),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory GrammarUsageData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarUsageData(
      id: serializer.fromJson<int>(json['id']),
      grammarId: serializer.fromJson<String>(json['grammarId']),
      subtype: serializer.fromJson<String?>(json['subtype']),
      connection: serializer.fromJson<String>(json['connection']),
      explanation: serializer.fromJson<String>(json['explanation']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'grammarId': serializer.toJson<String>(grammarId),
      'subtype': serializer.toJson<String?>(subtype),
      'connection': serializer.toJson<String>(connection),
      'explanation': serializer.toJson<String>(explanation),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  GrammarUsageData copyWith({
    int? id,
    String? grammarId,
    Value<String?> subtype = const Value.absent(),
    String? connection,
    String? explanation,
    Value<String?> notes = const Value.absent(),
  }) => GrammarUsageData(
    id: id ?? this.id,
    grammarId: grammarId ?? this.grammarId,
    subtype: subtype.present ? subtype.value : this.subtype,
    connection: connection ?? this.connection,
    explanation: explanation ?? this.explanation,
    notes: notes.present ? notes.value : this.notes,
  );
  GrammarUsageData copyWithCompanion(GrammarUsagesCompanion data) {
    return GrammarUsageData(
      id: data.id.present ? data.id.value : this.id,
      grammarId: data.grammarId.present ? data.grammarId.value : this.grammarId,
      subtype: data.subtype.present ? data.subtype.value : this.subtype,
      connection: data.connection.present
          ? data.connection.value
          : this.connection,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarUsageData(')
          ..write('id: $id, ')
          ..write('grammarId: $grammarId, ')
          ..write('subtype: $subtype, ')
          ..write('connection: $connection, ')
          ..write('explanation: $explanation, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, grammarId, subtype, connection, explanation, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarUsageData &&
          other.id == this.id &&
          other.grammarId == this.grammarId &&
          other.subtype == this.subtype &&
          other.connection == this.connection &&
          other.explanation == this.explanation &&
          other.notes == this.notes);
}

class GrammarUsagesCompanion extends UpdateCompanion<GrammarUsageData> {
  final Value<int> id;
  final Value<String> grammarId;
  final Value<String?> subtype;
  final Value<String> connection;
  final Value<String> explanation;
  final Value<String?> notes;
  const GrammarUsagesCompanion({
    this.id = const Value.absent(),
    this.grammarId = const Value.absent(),
    this.subtype = const Value.absent(),
    this.connection = const Value.absent(),
    this.explanation = const Value.absent(),
    this.notes = const Value.absent(),
  });
  GrammarUsagesCompanion.insert({
    this.id = const Value.absent(),
    required String grammarId,
    this.subtype = const Value.absent(),
    required String connection,
    required String explanation,
    this.notes = const Value.absent(),
  }) : grammarId = Value(grammarId),
       connection = Value(connection),
       explanation = Value(explanation);
  static Insertable<GrammarUsageData> custom({
    Expression<int>? id,
    Expression<String>? grammarId,
    Expression<String>? subtype,
    Expression<String>? connection,
    Expression<String>? explanation,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (grammarId != null) 'grammar_id': grammarId,
      if (subtype != null) 'subtype': subtype,
      if (connection != null) 'connection': connection,
      if (explanation != null) 'explanation': explanation,
      if (notes != null) 'notes': notes,
    });
  }

  GrammarUsagesCompanion copyWith({
    Value<int>? id,
    Value<String>? grammarId,
    Value<String?>? subtype,
    Value<String>? connection,
    Value<String>? explanation,
    Value<String?>? notes,
  }) {
    return GrammarUsagesCompanion(
      id: id ?? this.id,
      grammarId: grammarId ?? this.grammarId,
      subtype: subtype ?? this.subtype,
      connection: connection ?? this.connection,
      explanation: explanation ?? this.explanation,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (grammarId.present) {
      map['grammar_id'] = Variable<String>(grammarId.value);
    }
    if (subtype.present) {
      map['subtype'] = Variable<String>(subtype.value);
    }
    if (connection.present) {
      map['connection'] = Variable<String>(connection.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarUsagesCompanion(')
          ..write('id: $id, ')
          ..write('grammarId: $grammarId, ')
          ..write('subtype: $subtype, ')
          ..write('connection: $connection, ')
          ..write('explanation: $explanation, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $GrammarExamplesTable extends GrammarExamples
    with TableInfo<$GrammarExamplesTable, GrammarExampleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarExamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usageIdMeta = const VerificationMeta(
    'usageId',
  );
  @override
  late final GeneratedColumn<int> usageId = GeneratedColumn<int>(
    'usage_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES grammar_usages (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sentenceMeta = const VerificationMeta(
    'sentence',
  );
  @override
  late final GeneratedColumn<String> sentence = GeneratedColumn<String>(
    'sentence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDialogMeta = const VerificationMeta(
    'isDialog',
  );
  @override
  late final GeneratedColumn<bool> isDialog = GeneratedColumn<bool>(
    'is_dialog',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dialog" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    usageId,
    sentence,
    translation,
    source,
    isDialog,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_examples';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarExampleData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('usage_id')) {
      context.handle(
        _usageIdMeta,
        usageId.isAcceptableOrUnknown(data['usage_id']!, _usageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usageIdMeta);
    }
    if (data.containsKey('sentence')) {
      context.handle(
        _sentenceMeta,
        sentence.isAcceptableOrUnknown(data['sentence']!, _sentenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sentenceMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('is_dialog')) {
      context.handle(
        _isDialogMeta,
        isDialog.isAcceptableOrUnknown(data['is_dialog']!, _isDialogMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarExampleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarExampleData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      usageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usage_id'],
      )!,
      sentence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sentence'],
      )!,
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      isDialog: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dialog'],
      )!,
    );
  }

  @override
  $GrammarExamplesTable createAlias(String alias) {
    return $GrammarExamplesTable(attachedDatabase, alias);
  }
}

class GrammarExampleData extends DataClass
    implements Insertable<GrammarExampleData> {
  final int id;
  final int usageId;
  final String sentence;
  final String translation;
  final String? source;
  final bool isDialog;
  const GrammarExampleData({
    required this.id,
    required this.usageId,
    required this.sentence,
    required this.translation,
    this.source,
    required this.isDialog,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['usage_id'] = Variable<int>(usageId);
    map['sentence'] = Variable<String>(sentence);
    map['translation'] = Variable<String>(translation);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['is_dialog'] = Variable<bool>(isDialog);
    return map;
  }

  GrammarExamplesCompanion toCompanion(bool nullToAbsent) {
    return GrammarExamplesCompanion(
      id: Value(id),
      usageId: Value(usageId),
      sentence: Value(sentence),
      translation: Value(translation),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      isDialog: Value(isDialog),
    );
  }

  factory GrammarExampleData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarExampleData(
      id: serializer.fromJson<int>(json['id']),
      usageId: serializer.fromJson<int>(json['usageId']),
      sentence: serializer.fromJson<String>(json['sentence']),
      translation: serializer.fromJson<String>(json['translation']),
      source: serializer.fromJson<String?>(json['source']),
      isDialog: serializer.fromJson<bool>(json['isDialog']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'usageId': serializer.toJson<int>(usageId),
      'sentence': serializer.toJson<String>(sentence),
      'translation': serializer.toJson<String>(translation),
      'source': serializer.toJson<String?>(source),
      'isDialog': serializer.toJson<bool>(isDialog),
    };
  }

  GrammarExampleData copyWith({
    int? id,
    int? usageId,
    String? sentence,
    String? translation,
    Value<String?> source = const Value.absent(),
    bool? isDialog,
  }) => GrammarExampleData(
    id: id ?? this.id,
    usageId: usageId ?? this.usageId,
    sentence: sentence ?? this.sentence,
    translation: translation ?? this.translation,
    source: source.present ? source.value : this.source,
    isDialog: isDialog ?? this.isDialog,
  );
  GrammarExampleData copyWithCompanion(GrammarExamplesCompanion data) {
    return GrammarExampleData(
      id: data.id.present ? data.id.value : this.id,
      usageId: data.usageId.present ? data.usageId.value : this.usageId,
      sentence: data.sentence.present ? data.sentence.value : this.sentence,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
      source: data.source.present ? data.source.value : this.source,
      isDialog: data.isDialog.present ? data.isDialog.value : this.isDialog,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarExampleData(')
          ..write('id: $id, ')
          ..write('usageId: $usageId, ')
          ..write('sentence: $sentence, ')
          ..write('translation: $translation, ')
          ..write('source: $source, ')
          ..write('isDialog: $isDialog')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, usageId, sentence, translation, source, isDialog);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarExampleData &&
          other.id == this.id &&
          other.usageId == this.usageId &&
          other.sentence == this.sentence &&
          other.translation == this.translation &&
          other.source == this.source &&
          other.isDialog == this.isDialog);
}

class GrammarExamplesCompanion extends UpdateCompanion<GrammarExampleData> {
  final Value<int> id;
  final Value<int> usageId;
  final Value<String> sentence;
  final Value<String> translation;
  final Value<String?> source;
  final Value<bool> isDialog;
  const GrammarExamplesCompanion({
    this.id = const Value.absent(),
    this.usageId = const Value.absent(),
    this.sentence = const Value.absent(),
    this.translation = const Value.absent(),
    this.source = const Value.absent(),
    this.isDialog = const Value.absent(),
  });
  GrammarExamplesCompanion.insert({
    this.id = const Value.absent(),
    required int usageId,
    required String sentence,
    required String translation,
    this.source = const Value.absent(),
    this.isDialog = const Value.absent(),
  }) : usageId = Value(usageId),
       sentence = Value(sentence),
       translation = Value(translation);
  static Insertable<GrammarExampleData> custom({
    Expression<int>? id,
    Expression<int>? usageId,
    Expression<String>? sentence,
    Expression<String>? translation,
    Expression<String>? source,
    Expression<bool>? isDialog,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usageId != null) 'usage_id': usageId,
      if (sentence != null) 'sentence': sentence,
      if (translation != null) 'translation': translation,
      if (source != null) 'source': source,
      if (isDialog != null) 'is_dialog': isDialog,
    });
  }

  GrammarExamplesCompanion copyWith({
    Value<int>? id,
    Value<int>? usageId,
    Value<String>? sentence,
    Value<String>? translation,
    Value<String?>? source,
    Value<bool>? isDialog,
  }) {
    return GrammarExamplesCompanion(
      id: id ?? this.id,
      usageId: usageId ?? this.usageId,
      sentence: sentence ?? this.sentence,
      translation: translation ?? this.translation,
      source: source ?? this.source,
      isDialog: isDialog ?? this.isDialog,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (usageId.present) {
      map['usage_id'] = Variable<int>(usageId.value);
    }
    if (sentence.present) {
      map['sentence'] = Variable<String>(sentence.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (isDialog.present) {
      map['is_dialog'] = Variable<bool>(isDialog.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarExamplesCompanion(')
          ..write('id: $id, ')
          ..write('usageId: $usageId, ')
          ..write('sentence: $sentence, ')
          ..write('translation: $translation, ')
          ..write('source: $source, ')
          ..write('isDialog: $isDialog')
          ..write(')'))
        .toString();
  }
}

class $LearningProgressTable extends LearningProgress
    with TableInfo<$LearningProgressTable, LearningProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearningProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueTimeMeta = const VerificationMeta(
    'dueTime',
  );
  @override
  late final GeneratedColumn<BigInt> dueTime = GeneratedColumn<BigInt>(
    'due_time',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: false,
    defaultValue: Constant(BigInt.zero),
  );
  static const VerificationMeta _intervalMeta = const VerificationMeta(
    'interval',
  );
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
    'interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _stabilityMeta = const VerificationMeta(
    'stability',
  );
  @override
  late final GeneratedColumn<double> stability = GeneratedColumn<double>(
    'stability',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _repetitionCountMeta = const VerificationMeta(
    'repetitionCount',
  );
  @override
  late final GeneratedColumn<int> repetitionCount = GeneratedColumn<int>(
    'repetition_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastReviewedMeta = const VerificationMeta(
    'lastReviewed',
  );
  @override
  late final GeneratedColumn<BigInt> lastReviewed = GeneratedColumn<BigInt>(
    'last_reviewed',
    aliasedName,
    true,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstLearnedMeta = const VerificationMeta(
    'firstLearned',
  );
  @override
  late final GeneratedColumn<BigInt> firstLearned = GeneratedColumn<BigInt>(
    'first_learned',
    aliasedName,
    true,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stepMeta = const VerificationMeta('step');
  @override
  late final GeneratedColumn<int> step = GeneratedColumn<int>(
    'step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isSuspendedMeta = const VerificationMeta(
    'isSuspended',
  );
  @override
  late final GeneratedColumn<bool> isSuspended = GeneratedColumn<bool>(
    'is_suspended',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_suspended" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isSkippedMeta = const VerificationMeta(
    'isSkipped',
  );
  @override
  late final GeneratedColumn<bool> isSkipped = GeneratedColumn<bool>(
    'is_skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_skipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemType,
    dueTime,
    interval,
    difficulty,
    stability,
    repetitionCount,
    lastReviewed,
    firstLearned,
    step,
    lapses,
    isSuspended,
    isSkipped,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learning_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<LearningProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('due_time')) {
      context.handle(
        _dueTimeMeta,
        dueTime.isAcceptableOrUnknown(data['due_time']!, _dueTimeMeta),
      );
    }
    if (data.containsKey('interval')) {
      context.handle(
        _intervalMeta,
        interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('stability')) {
      context.handle(
        _stabilityMeta,
        stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta),
      );
    }
    if (data.containsKey('repetition_count')) {
      context.handle(
        _repetitionCountMeta,
        repetitionCount.isAcceptableOrUnknown(
          data['repetition_count']!,
          _repetitionCountMeta,
        ),
      );
    }
    if (data.containsKey('last_reviewed')) {
      context.handle(
        _lastReviewedMeta,
        lastReviewed.isAcceptableOrUnknown(
          data['last_reviewed']!,
          _lastReviewedMeta,
        ),
      );
    }
    if (data.containsKey('first_learned')) {
      context.handle(
        _firstLearnedMeta,
        firstLearned.isAcceptableOrUnknown(
          data['first_learned']!,
          _firstLearnedMeta,
        ),
      );
    }
    if (data.containsKey('step')) {
      context.handle(
        _stepMeta,
        step.isAcceptableOrUnknown(data['step']!, _stepMeta),
      );
    }
    if (data.containsKey('lapses')) {
      context.handle(
        _lapsesMeta,
        lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta),
      );
    }
    if (data.containsKey('is_suspended')) {
      context.handle(
        _isSuspendedMeta,
        isSuspended.isAcceptableOrUnknown(
          data['is_suspended']!,
          _isSuspendedMeta,
        ),
      );
    }
    if (data.containsKey('is_skipped')) {
      context.handle(
        _isSkippedMeta,
        isSkipped.isAcceptableOrUnknown(data['is_skipped']!, _isSkippedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LearningProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearningProgressData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      itemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_type'],
      )!,
      dueTime: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}due_time'],
      )!,
      interval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}difficulty'],
      )!,
      stability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stability'],
      )!,
      repetitionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetition_count'],
      )!,
      lastReviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}last_reviewed'],
      ),
      firstLearned: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}first_learned'],
      ),
      step: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step'],
      )!,
      lapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapses'],
      )!,
      isSuspended: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_suspended'],
      )!,
      isSkipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_skipped'],
      )!,
    );
  }

  @override
  $LearningProgressTable createAlias(String alias) {
    return $LearningProgressTable(attachedDatabase, alias);
  }
}

class LearningProgressData extends DataClass
    implements Insertable<LearningProgressData> {
  final String id;
  final String itemType;
  final BigInt dueTime;
  final int interval;
  final double difficulty;
  final double stability;
  final int repetitionCount;
  final BigInt? lastReviewed;
  final BigInt? firstLearned;
  final int step;
  final int lapses;
  final bool isSuspended;
  final bool isSkipped;
  const LearningProgressData({
    required this.id,
    required this.itemType,
    required this.dueTime,
    required this.interval,
    required this.difficulty,
    required this.stability,
    required this.repetitionCount,
    this.lastReviewed,
    this.firstLearned,
    required this.step,
    required this.lapses,
    required this.isSuspended,
    required this.isSkipped,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_type'] = Variable<String>(itemType);
    map['due_time'] = Variable<BigInt>(dueTime);
    map['interval'] = Variable<int>(interval);
    map['difficulty'] = Variable<double>(difficulty);
    map['stability'] = Variable<double>(stability);
    map['repetition_count'] = Variable<int>(repetitionCount);
    if (!nullToAbsent || lastReviewed != null) {
      map['last_reviewed'] = Variable<BigInt>(lastReviewed);
    }
    if (!nullToAbsent || firstLearned != null) {
      map['first_learned'] = Variable<BigInt>(firstLearned);
    }
    map['step'] = Variable<int>(step);
    map['lapses'] = Variable<int>(lapses);
    map['is_suspended'] = Variable<bool>(isSuspended);
    map['is_skipped'] = Variable<bool>(isSkipped);
    return map;
  }

  LearningProgressCompanion toCompanion(bool nullToAbsent) {
    return LearningProgressCompanion(
      id: Value(id),
      itemType: Value(itemType),
      dueTime: Value(dueTime),
      interval: Value(interval),
      difficulty: Value(difficulty),
      stability: Value(stability),
      repetitionCount: Value(repetitionCount),
      lastReviewed: lastReviewed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewed),
      firstLearned: firstLearned == null && nullToAbsent
          ? const Value.absent()
          : Value(firstLearned),
      step: Value(step),
      lapses: Value(lapses),
      isSuspended: Value(isSuspended),
      isSkipped: Value(isSkipped),
    );
  }

  factory LearningProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearningProgressData(
      id: serializer.fromJson<String>(json['id']),
      itemType: serializer.fromJson<String>(json['itemType']),
      dueTime: serializer.fromJson<BigInt>(json['dueTime']),
      interval: serializer.fromJson<int>(json['interval']),
      difficulty: serializer.fromJson<double>(json['difficulty']),
      stability: serializer.fromJson<double>(json['stability']),
      repetitionCount: serializer.fromJson<int>(json['repetitionCount']),
      lastReviewed: serializer.fromJson<BigInt?>(json['lastReviewed']),
      firstLearned: serializer.fromJson<BigInt?>(json['firstLearned']),
      step: serializer.fromJson<int>(json['step']),
      lapses: serializer.fromJson<int>(json['lapses']),
      isSuspended: serializer.fromJson<bool>(json['isSuspended']),
      isSkipped: serializer.fromJson<bool>(json['isSkipped']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemType': serializer.toJson<String>(itemType),
      'dueTime': serializer.toJson<BigInt>(dueTime),
      'interval': serializer.toJson<int>(interval),
      'difficulty': serializer.toJson<double>(difficulty),
      'stability': serializer.toJson<double>(stability),
      'repetitionCount': serializer.toJson<int>(repetitionCount),
      'lastReviewed': serializer.toJson<BigInt?>(lastReviewed),
      'firstLearned': serializer.toJson<BigInt?>(firstLearned),
      'step': serializer.toJson<int>(step),
      'lapses': serializer.toJson<int>(lapses),
      'isSuspended': serializer.toJson<bool>(isSuspended),
      'isSkipped': serializer.toJson<bool>(isSkipped),
    };
  }

  LearningProgressData copyWith({
    String? id,
    String? itemType,
    BigInt? dueTime,
    int? interval,
    double? difficulty,
    double? stability,
    int? repetitionCount,
    Value<BigInt?> lastReviewed = const Value.absent(),
    Value<BigInt?> firstLearned = const Value.absent(),
    int? step,
    int? lapses,
    bool? isSuspended,
    bool? isSkipped,
  }) => LearningProgressData(
    id: id ?? this.id,
    itemType: itemType ?? this.itemType,
    dueTime: dueTime ?? this.dueTime,
    interval: interval ?? this.interval,
    difficulty: difficulty ?? this.difficulty,
    stability: stability ?? this.stability,
    repetitionCount: repetitionCount ?? this.repetitionCount,
    lastReviewed: lastReviewed.present ? lastReviewed.value : this.lastReviewed,
    firstLearned: firstLearned.present ? firstLearned.value : this.firstLearned,
    step: step ?? this.step,
    lapses: lapses ?? this.lapses,
    isSuspended: isSuspended ?? this.isSuspended,
    isSkipped: isSkipped ?? this.isSkipped,
  );
  LearningProgressData copyWithCompanion(LearningProgressCompanion data) {
    return LearningProgressData(
      id: data.id.present ? data.id.value : this.id,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      dueTime: data.dueTime.present ? data.dueTime.value : this.dueTime,
      interval: data.interval.present ? data.interval.value : this.interval,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      stability: data.stability.present ? data.stability.value : this.stability,
      repetitionCount: data.repetitionCount.present
          ? data.repetitionCount.value
          : this.repetitionCount,
      lastReviewed: data.lastReviewed.present
          ? data.lastReviewed.value
          : this.lastReviewed,
      firstLearned: data.firstLearned.present
          ? data.firstLearned.value
          : this.firstLearned,
      step: data.step.present ? data.step.value : this.step,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      isSuspended: data.isSuspended.present
          ? data.isSuspended.value
          : this.isSuspended,
      isSkipped: data.isSkipped.present ? data.isSkipped.value : this.isSkipped,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearningProgressData(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('dueTime: $dueTime, ')
          ..write('interval: $interval, ')
          ..write('difficulty: $difficulty, ')
          ..write('stability: $stability, ')
          ..write('repetitionCount: $repetitionCount, ')
          ..write('lastReviewed: $lastReviewed, ')
          ..write('firstLearned: $firstLearned, ')
          ..write('step: $step, ')
          ..write('lapses: $lapses, ')
          ..write('isSuspended: $isSuspended, ')
          ..write('isSkipped: $isSkipped')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemType,
    dueTime,
    interval,
    difficulty,
    stability,
    repetitionCount,
    lastReviewed,
    firstLearned,
    step,
    lapses,
    isSuspended,
    isSkipped,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearningProgressData &&
          other.id == this.id &&
          other.itemType == this.itemType &&
          other.dueTime == this.dueTime &&
          other.interval == this.interval &&
          other.difficulty == this.difficulty &&
          other.stability == this.stability &&
          other.repetitionCount == this.repetitionCount &&
          other.lastReviewed == this.lastReviewed &&
          other.firstLearned == this.firstLearned &&
          other.step == this.step &&
          other.lapses == this.lapses &&
          other.isSuspended == this.isSuspended &&
          other.isSkipped == this.isSkipped);
}

class LearningProgressCompanion extends UpdateCompanion<LearningProgressData> {
  final Value<String> id;
  final Value<String> itemType;
  final Value<BigInt> dueTime;
  final Value<int> interval;
  final Value<double> difficulty;
  final Value<double> stability;
  final Value<int> repetitionCount;
  final Value<BigInt?> lastReviewed;
  final Value<BigInt?> firstLearned;
  final Value<int> step;
  final Value<int> lapses;
  final Value<bool> isSuspended;
  final Value<bool> isSkipped;
  final Value<int> rowid;
  const LearningProgressCompanion({
    this.id = const Value.absent(),
    this.itemType = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.interval = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.stability = const Value.absent(),
    this.repetitionCount = const Value.absent(),
    this.lastReviewed = const Value.absent(),
    this.firstLearned = const Value.absent(),
    this.step = const Value.absent(),
    this.lapses = const Value.absent(),
    this.isSuspended = const Value.absent(),
    this.isSkipped = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearningProgressCompanion.insert({
    required String id,
    required String itemType,
    this.dueTime = const Value.absent(),
    this.interval = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.stability = const Value.absent(),
    this.repetitionCount = const Value.absent(),
    this.lastReviewed = const Value.absent(),
    this.firstLearned = const Value.absent(),
    this.step = const Value.absent(),
    this.lapses = const Value.absent(),
    this.isSuspended = const Value.absent(),
    this.isSkipped = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemType = Value(itemType);
  static Insertable<LearningProgressData> custom({
    Expression<String>? id,
    Expression<String>? itemType,
    Expression<BigInt>? dueTime,
    Expression<int>? interval,
    Expression<double>? difficulty,
    Expression<double>? stability,
    Expression<int>? repetitionCount,
    Expression<BigInt>? lastReviewed,
    Expression<BigInt>? firstLearned,
    Expression<int>? step,
    Expression<int>? lapses,
    Expression<bool>? isSuspended,
    Expression<bool>? isSkipped,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemType != null) 'item_type': itemType,
      if (dueTime != null) 'due_time': dueTime,
      if (interval != null) 'interval': interval,
      if (difficulty != null) 'difficulty': difficulty,
      if (stability != null) 'stability': stability,
      if (repetitionCount != null) 'repetition_count': repetitionCount,
      if (lastReviewed != null) 'last_reviewed': lastReviewed,
      if (firstLearned != null) 'first_learned': firstLearned,
      if (step != null) 'step': step,
      if (lapses != null) 'lapses': lapses,
      if (isSuspended != null) 'is_suspended': isSuspended,
      if (isSkipped != null) 'is_skipped': isSkipped,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearningProgressCompanion copyWith({
    Value<String>? id,
    Value<String>? itemType,
    Value<BigInt>? dueTime,
    Value<int>? interval,
    Value<double>? difficulty,
    Value<double>? stability,
    Value<int>? repetitionCount,
    Value<BigInt?>? lastReviewed,
    Value<BigInt?>? firstLearned,
    Value<int>? step,
    Value<int>? lapses,
    Value<bool>? isSuspended,
    Value<bool>? isSkipped,
    Value<int>? rowid,
  }) {
    return LearningProgressCompanion(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      dueTime: dueTime ?? this.dueTime,
      interval: interval ?? this.interval,
      difficulty: difficulty ?? this.difficulty,
      stability: stability ?? this.stability,
      repetitionCount: repetitionCount ?? this.repetitionCount,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      firstLearned: firstLearned ?? this.firstLearned,
      step: step ?? this.step,
      lapses: lapses ?? this.lapses,
      isSuspended: isSuspended ?? this.isSuspended,
      isSkipped: isSkipped ?? this.isSkipped,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (dueTime.present) {
      map['due_time'] = Variable<BigInt>(dueTime.value);
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (stability.present) {
      map['stability'] = Variable<double>(stability.value);
    }
    if (repetitionCount.present) {
      map['repetition_count'] = Variable<int>(repetitionCount.value);
    }
    if (lastReviewed.present) {
      map['last_reviewed'] = Variable<BigInt>(lastReviewed.value);
    }
    if (firstLearned.present) {
      map['first_learned'] = Variable<BigInt>(firstLearned.value);
    }
    if (step.present) {
      map['step'] = Variable<int>(step.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (isSuspended.present) {
      map['is_suspended'] = Variable<bool>(isSuspended.value);
    }
    if (isSkipped.present) {
      map['is_skipped'] = Variable<bool>(isSkipped.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearningProgressCompanion(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('dueTime: $dueTime, ')
          ..write('interval: $interval, ')
          ..write('difficulty: $difficulty, ')
          ..write('stability: $stability, ')
          ..write('repetitionCount: $repetitionCount, ')
          ..write('lastReviewed: $lastReviewed, ')
          ..write('firstLearned: $firstLearned, ')
          ..write('step: $step, ')
          ..write('lapses: $lapses, ')
          ..write('isSuspended: $isSuspended, ')
          ..write('isSkipped: $isSkipped, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$NemoDatabase extends GeneratedDatabase {
  _$NemoDatabase(QueryExecutor e) : super(e);
  $NemoDatabaseManager get managers => $NemoDatabaseManager(this);
  late final $WordsTable words = $WordsTable(this);
  late final $WordExamplesTable wordExamples = $WordExamplesTable(this);
  late final $GrammarsTable grammars = $GrammarsTable(this);
  late final $GrammarUsagesTable grammarUsages = $GrammarUsagesTable(this);
  late final $GrammarExamplesTable grammarExamples = $GrammarExamplesTable(
    this,
  );
  late final $LearningProgressTable learningProgress = $LearningProgressTable(
    this,
  );
  late final WordDao wordDao = WordDao(this as NemoDatabase);
  late final GrammarDao grammarDao = GrammarDao(this as NemoDatabase);
  late final LearningDao learningDao = LearningDao(this as NemoDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    words,
    wordExamples,
    grammars,
    grammarUsages,
    grammarExamples,
    learningProgress,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'words',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('word_examples', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'grammars',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('grammar_usages', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'grammar_usages',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('grammar_examples', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$WordsTableCreateCompanionBuilder =
    WordsCompanion Function({
      required String id,
      required String japanese,
      required String hiragana,
      required String chinese,
      required String level,
      Value<String?> pos,
      Value<String?> furiganaDataJson,
      Value<bool> isFavorite,
      Value<int> rowid,
    });
typedef $$WordsTableUpdateCompanionBuilder =
    WordsCompanion Function({
      Value<String> id,
      Value<String> japanese,
      Value<String> hiragana,
      Value<String> chinese,
      Value<String> level,
      Value<String?> pos,
      Value<String?> furiganaDataJson,
      Value<bool> isFavorite,
      Value<int> rowid,
    });

final class $$WordsTableReferences
    extends BaseReferences<_$NemoDatabase, $WordsTable, WordEntry> {
  $$WordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WordExamplesTable, List<WordExampleData>>
  _wordExamplesRefsTable(_$NemoDatabase db) => MultiTypedResultKey.fromTable(
    db.wordExamples,
    aliasName: $_aliasNameGenerator(db.words.id, db.wordExamples.wordId),
  );

  $$WordExamplesTableProcessedTableManager get wordExamplesRefs {
    final manager = $$WordExamplesTableTableManager(
      $_db,
      $_db.wordExamples,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_wordExamplesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WordsTableFilterComposer extends Composer<_$NemoDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get japanese => $composableBuilder(
    column: $table.japanese,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hiragana => $composableBuilder(
    column: $table.hiragana,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chinese => $composableBuilder(
    column: $table.chinese,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get furiganaDataJson => $composableBuilder(
    column: $table.furiganaDataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> wordExamplesRefs(
    Expression<bool> Function($$WordExamplesTableFilterComposer f) f,
  ) {
    final $$WordExamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wordExamples,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordExamplesTableFilterComposer(
            $db: $db,
            $table: $db.wordExamples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WordsTableOrderingComposer
    extends Composer<_$NemoDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get japanese => $composableBuilder(
    column: $table.japanese,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hiragana => $composableBuilder(
    column: $table.hiragana,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chinese => $composableBuilder(
    column: $table.chinese,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get furiganaDataJson => $composableBuilder(
    column: $table.furiganaDataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WordsTableAnnotationComposer
    extends Composer<_$NemoDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get japanese =>
      $composableBuilder(column: $table.japanese, builder: (column) => column);

  GeneratedColumn<String> get hiragana =>
      $composableBuilder(column: $table.hiragana, builder: (column) => column);

  GeneratedColumn<String> get chinese =>
      $composableBuilder(column: $table.chinese, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get pos =>
      $composableBuilder(column: $table.pos, builder: (column) => column);

  GeneratedColumn<String> get furiganaDataJson => $composableBuilder(
    column: $table.furiganaDataJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  Expression<T> wordExamplesRefs<T extends Object>(
    Expression<T> Function($$WordExamplesTableAnnotationComposer a) f,
  ) {
    final $$WordExamplesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wordExamples,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordExamplesTableAnnotationComposer(
            $db: $db,
            $table: $db.wordExamples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WordsTableTableManager
    extends
        RootTableManager<
          _$NemoDatabase,
          $WordsTable,
          WordEntry,
          $$WordsTableFilterComposer,
          $$WordsTableOrderingComposer,
          $$WordsTableAnnotationComposer,
          $$WordsTableCreateCompanionBuilder,
          $$WordsTableUpdateCompanionBuilder,
          (WordEntry, $$WordsTableReferences),
          WordEntry,
          PrefetchHooks Function({bool wordExamplesRefs})
        > {
  $$WordsTableTableManager(_$NemoDatabase db, $WordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> japanese = const Value.absent(),
                Value<String> hiragana = const Value.absent(),
                Value<String> chinese = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String?> pos = const Value.absent(),
                Value<String?> furiganaDataJson = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordsCompanion(
                id: id,
                japanese: japanese,
                hiragana: hiragana,
                chinese: chinese,
                level: level,
                pos: pos,
                furiganaDataJson: furiganaDataJson,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String japanese,
                required String hiragana,
                required String chinese,
                required String level,
                Value<String?> pos = const Value.absent(),
                Value<String?> furiganaDataJson = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordsCompanion.insert(
                id: id,
                japanese: japanese,
                hiragana: hiragana,
                chinese: chinese,
                level: level,
                pos: pos,
                furiganaDataJson: furiganaDataJson,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$WordsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({wordExamplesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (wordExamplesRefs) db.wordExamples],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (wordExamplesRefs)
                    await $_getPrefetchedData<
                      WordEntry,
                      $WordsTable,
                      WordExampleData
                    >(
                      currentTable: table,
                      referencedTable: $$WordsTableReferences
                          ._wordExamplesRefsTable(db),
                      managerFromTypedResult: (p0) => $$WordsTableReferences(
                        db,
                        table,
                        p0,
                      ).wordExamplesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.wordId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WordsTableProcessedTableManager =
    ProcessedTableManager<
      _$NemoDatabase,
      $WordsTable,
      WordEntry,
      $$WordsTableFilterComposer,
      $$WordsTableOrderingComposer,
      $$WordsTableAnnotationComposer,
      $$WordsTableCreateCompanionBuilder,
      $$WordsTableUpdateCompanionBuilder,
      (WordEntry, $$WordsTableReferences),
      WordEntry,
      PrefetchHooks Function({bool wordExamplesRefs})
    >;
typedef $$WordExamplesTableCreateCompanionBuilder =
    WordExamplesCompanion Function({
      Value<int> id,
      required String wordId,
      required String japanese,
      required String chinese,
      Value<String?> audioId,
    });
typedef $$WordExamplesTableUpdateCompanionBuilder =
    WordExamplesCompanion Function({
      Value<int> id,
      Value<String> wordId,
      Value<String> japanese,
      Value<String> chinese,
      Value<String?> audioId,
    });

final class $$WordExamplesTableReferences
    extends
        BaseReferences<_$NemoDatabase, $WordExamplesTable, WordExampleData> {
  $$WordExamplesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _wordIdTable(_$NemoDatabase db) => db.words.createAlias(
    $_aliasNameGenerator(db.wordExamples.wordId, db.words.id),
  );

  $$WordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<String>('word_id')!;

    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WordExamplesTableFilterComposer
    extends Composer<_$NemoDatabase, $WordExamplesTable> {
  $$WordExamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get japanese => $composableBuilder(
    column: $table.japanese,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chinese => $composableBuilder(
    column: $table.chinese,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioId => $composableBuilder(
    column: $table.audioId,
    builder: (column) => ColumnFilters(column),
  );

  $$WordsTableFilterComposer get wordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordExamplesTableOrderingComposer
    extends Composer<_$NemoDatabase, $WordExamplesTable> {
  $$WordExamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get japanese => $composableBuilder(
    column: $table.japanese,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chinese => $composableBuilder(
    column: $table.chinese,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioId => $composableBuilder(
    column: $table.audioId,
    builder: (column) => ColumnOrderings(column),
  );

  $$WordsTableOrderingComposer get wordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableOrderingComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordExamplesTableAnnotationComposer
    extends Composer<_$NemoDatabase, $WordExamplesTable> {
  $$WordExamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get japanese =>
      $composableBuilder(column: $table.japanese, builder: (column) => column);

  GeneratedColumn<String> get chinese =>
      $composableBuilder(column: $table.chinese, builder: (column) => column);

  GeneratedColumn<String> get audioId =>
      $composableBuilder(column: $table.audioId, builder: (column) => column);

  $$WordsTableAnnotationComposer get wordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordExamplesTableTableManager
    extends
        RootTableManager<
          _$NemoDatabase,
          $WordExamplesTable,
          WordExampleData,
          $$WordExamplesTableFilterComposer,
          $$WordExamplesTableOrderingComposer,
          $$WordExamplesTableAnnotationComposer,
          $$WordExamplesTableCreateCompanionBuilder,
          $$WordExamplesTableUpdateCompanionBuilder,
          (WordExampleData, $$WordExamplesTableReferences),
          WordExampleData,
          PrefetchHooks Function({bool wordId})
        > {
  $$WordExamplesTableTableManager(_$NemoDatabase db, $WordExamplesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordExamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordExamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordExamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<String> japanese = const Value.absent(),
                Value<String> chinese = const Value.absent(),
                Value<String?> audioId = const Value.absent(),
              }) => WordExamplesCompanion(
                id: id,
                wordId: wordId,
                japanese: japanese,
                chinese: chinese,
                audioId: audioId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String wordId,
                required String japanese,
                required String chinese,
                Value<String?> audioId = const Value.absent(),
              }) => WordExamplesCompanion.insert(
                id: id,
                wordId: wordId,
                japanese: japanese,
                chinese: chinese,
                audioId: audioId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WordExamplesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (wordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.wordId,
                                referencedTable: $$WordExamplesTableReferences
                                    ._wordIdTable(db),
                                referencedColumn: $$WordExamplesTableReferences
                                    ._wordIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WordExamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$NemoDatabase,
      $WordExamplesTable,
      WordExampleData,
      $$WordExamplesTableFilterComposer,
      $$WordExamplesTableOrderingComposer,
      $$WordExamplesTableAnnotationComposer,
      $$WordExamplesTableCreateCompanionBuilder,
      $$WordExamplesTableUpdateCompanionBuilder,
      (WordExampleData, $$WordExamplesTableReferences),
      WordExampleData,
      PrefetchHooks Function({bool wordId})
    >;
typedef $$GrammarsTableCreateCompanionBuilder =
    GrammarsCompanion Function({
      required String id,
      required String grammar,
      required String grammarLevel,
      Value<String?> meaning,
      Value<bool> isDelisted,
      Value<bool> isFavorite,
      Value<int> rowid,
    });
typedef $$GrammarsTableUpdateCompanionBuilder =
    GrammarsCompanion Function({
      Value<String> id,
      Value<String> grammar,
      Value<String> grammarLevel,
      Value<String?> meaning,
      Value<bool> isDelisted,
      Value<bool> isFavorite,
      Value<int> rowid,
    });

final class $$GrammarsTableReferences
    extends BaseReferences<_$NemoDatabase, $GrammarsTable, GrammarEntry> {
  $$GrammarsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GrammarUsagesTable, List<GrammarUsageData>>
  _grammarUsagesRefsTable(_$NemoDatabase db) => MultiTypedResultKey.fromTable(
    db.grammarUsages,
    aliasName: $_aliasNameGenerator(db.grammars.id, db.grammarUsages.grammarId),
  );

  $$GrammarUsagesTableProcessedTableManager get grammarUsagesRefs {
    final manager = $$GrammarUsagesTableTableManager(
      $_db,
      $_db.grammarUsages,
    ).filter((f) => f.grammarId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_grammarUsagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GrammarsTableFilterComposer
    extends Composer<_$NemoDatabase, $GrammarsTable> {
  $$GrammarsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grammar => $composableBuilder(
    column: $table.grammar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grammarLevel => $composableBuilder(
    column: $table.grammarLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDelisted => $composableBuilder(
    column: $table.isDelisted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> grammarUsagesRefs(
    Expression<bool> Function($$GrammarUsagesTableFilterComposer f) f,
  ) {
    final $$GrammarUsagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grammarUsages,
      getReferencedColumn: (t) => t.grammarId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarUsagesTableFilterComposer(
            $db: $db,
            $table: $db.grammarUsages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GrammarsTableOrderingComposer
    extends Composer<_$NemoDatabase, $GrammarsTable> {
  $$GrammarsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grammar => $composableBuilder(
    column: $table.grammar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grammarLevel => $composableBuilder(
    column: $table.grammarLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDelisted => $composableBuilder(
    column: $table.isDelisted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GrammarsTableAnnotationComposer
    extends Composer<_$NemoDatabase, $GrammarsTable> {
  $$GrammarsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get grammar =>
      $composableBuilder(column: $table.grammar, builder: (column) => column);

  GeneratedColumn<String> get grammarLevel => $composableBuilder(
    column: $table.grammarLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get meaning =>
      $composableBuilder(column: $table.meaning, builder: (column) => column);

  GeneratedColumn<bool> get isDelisted => $composableBuilder(
    column: $table.isDelisted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  Expression<T> grammarUsagesRefs<T extends Object>(
    Expression<T> Function($$GrammarUsagesTableAnnotationComposer a) f,
  ) {
    final $$GrammarUsagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grammarUsages,
      getReferencedColumn: (t) => t.grammarId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarUsagesTableAnnotationComposer(
            $db: $db,
            $table: $db.grammarUsages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GrammarsTableTableManager
    extends
        RootTableManager<
          _$NemoDatabase,
          $GrammarsTable,
          GrammarEntry,
          $$GrammarsTableFilterComposer,
          $$GrammarsTableOrderingComposer,
          $$GrammarsTableAnnotationComposer,
          $$GrammarsTableCreateCompanionBuilder,
          $$GrammarsTableUpdateCompanionBuilder,
          (GrammarEntry, $$GrammarsTableReferences),
          GrammarEntry,
          PrefetchHooks Function({bool grammarUsagesRefs})
        > {
  $$GrammarsTableTableManager(_$NemoDatabase db, $GrammarsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> grammar = const Value.absent(),
                Value<String> grammarLevel = const Value.absent(),
                Value<String?> meaning = const Value.absent(),
                Value<bool> isDelisted = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GrammarsCompanion(
                id: id,
                grammar: grammar,
                grammarLevel: grammarLevel,
                meaning: meaning,
                isDelisted: isDelisted,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String grammar,
                required String grammarLevel,
                Value<String?> meaning = const Value.absent(),
                Value<bool> isDelisted = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GrammarsCompanion.insert(
                id: id,
                grammar: grammar,
                grammarLevel: grammarLevel,
                meaning: meaning,
                isDelisted: isDelisted,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GrammarsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({grammarUsagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (grammarUsagesRefs) db.grammarUsages,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (grammarUsagesRefs)
                    await $_getPrefetchedData<
                      GrammarEntry,
                      $GrammarsTable,
                      GrammarUsageData
                    >(
                      currentTable: table,
                      referencedTable: $$GrammarsTableReferences
                          ._grammarUsagesRefsTable(db),
                      managerFromTypedResult: (p0) => $$GrammarsTableReferences(
                        db,
                        table,
                        p0,
                      ).grammarUsagesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.grammarId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GrammarsTableProcessedTableManager =
    ProcessedTableManager<
      _$NemoDatabase,
      $GrammarsTable,
      GrammarEntry,
      $$GrammarsTableFilterComposer,
      $$GrammarsTableOrderingComposer,
      $$GrammarsTableAnnotationComposer,
      $$GrammarsTableCreateCompanionBuilder,
      $$GrammarsTableUpdateCompanionBuilder,
      (GrammarEntry, $$GrammarsTableReferences),
      GrammarEntry,
      PrefetchHooks Function({bool grammarUsagesRefs})
    >;
typedef $$GrammarUsagesTableCreateCompanionBuilder =
    GrammarUsagesCompanion Function({
      Value<int> id,
      required String grammarId,
      Value<String?> subtype,
      required String connection,
      required String explanation,
      Value<String?> notes,
    });
typedef $$GrammarUsagesTableUpdateCompanionBuilder =
    GrammarUsagesCompanion Function({
      Value<int> id,
      Value<String> grammarId,
      Value<String?> subtype,
      Value<String> connection,
      Value<String> explanation,
      Value<String?> notes,
    });

final class $$GrammarUsagesTableReferences
    extends
        BaseReferences<_$NemoDatabase, $GrammarUsagesTable, GrammarUsageData> {
  $$GrammarUsagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GrammarsTable _grammarIdTable(_$NemoDatabase db) =>
      db.grammars.createAlias(
        $_aliasNameGenerator(db.grammarUsages.grammarId, db.grammars.id),
      );

  $$GrammarsTableProcessedTableManager get grammarId {
    final $_column = $_itemColumn<String>('grammar_id')!;

    final manager = $$GrammarsTableTableManager(
      $_db,
      $_db.grammars,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_grammarIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$GrammarExamplesTable, List<GrammarExampleData>>
  _grammarExamplesRefsTable(_$NemoDatabase db) => MultiTypedResultKey.fromTable(
    db.grammarExamples,
    aliasName: $_aliasNameGenerator(
      db.grammarUsages.id,
      db.grammarExamples.usageId,
    ),
  );

  $$GrammarExamplesTableProcessedTableManager get grammarExamplesRefs {
    final manager = $$GrammarExamplesTableTableManager(
      $_db,
      $_db.grammarExamples,
    ).filter((f) => f.usageId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _grammarExamplesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GrammarUsagesTableFilterComposer
    extends Composer<_$NemoDatabase, $GrammarUsagesTable> {
  $$GrammarUsagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtype => $composableBuilder(
    column: $table.subtype,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get connection => $composableBuilder(
    column: $table.connection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$GrammarsTableFilterComposer get grammarId {
    final $$GrammarsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.grammarId,
      referencedTable: $db.grammars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarsTableFilterComposer(
            $db: $db,
            $table: $db.grammars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> grammarExamplesRefs(
    Expression<bool> Function($$GrammarExamplesTableFilterComposer f) f,
  ) {
    final $$GrammarExamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grammarExamples,
      getReferencedColumn: (t) => t.usageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarExamplesTableFilterComposer(
            $db: $db,
            $table: $db.grammarExamples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GrammarUsagesTableOrderingComposer
    extends Composer<_$NemoDatabase, $GrammarUsagesTable> {
  $$GrammarUsagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtype => $composableBuilder(
    column: $table.subtype,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get connection => $composableBuilder(
    column: $table.connection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$GrammarsTableOrderingComposer get grammarId {
    final $$GrammarsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.grammarId,
      referencedTable: $db.grammars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarsTableOrderingComposer(
            $db: $db,
            $table: $db.grammars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GrammarUsagesTableAnnotationComposer
    extends Composer<_$NemoDatabase, $GrammarUsagesTable> {
  $$GrammarUsagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subtype =>
      $composableBuilder(column: $table.subtype, builder: (column) => column);

  GeneratedColumn<String> get connection => $composableBuilder(
    column: $table.connection,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$GrammarsTableAnnotationComposer get grammarId {
    final $$GrammarsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.grammarId,
      referencedTable: $db.grammars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarsTableAnnotationComposer(
            $db: $db,
            $table: $db.grammars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> grammarExamplesRefs<T extends Object>(
    Expression<T> Function($$GrammarExamplesTableAnnotationComposer a) f,
  ) {
    final $$GrammarExamplesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grammarExamples,
      getReferencedColumn: (t) => t.usageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarExamplesTableAnnotationComposer(
            $db: $db,
            $table: $db.grammarExamples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GrammarUsagesTableTableManager
    extends
        RootTableManager<
          _$NemoDatabase,
          $GrammarUsagesTable,
          GrammarUsageData,
          $$GrammarUsagesTableFilterComposer,
          $$GrammarUsagesTableOrderingComposer,
          $$GrammarUsagesTableAnnotationComposer,
          $$GrammarUsagesTableCreateCompanionBuilder,
          $$GrammarUsagesTableUpdateCompanionBuilder,
          (GrammarUsageData, $$GrammarUsagesTableReferences),
          GrammarUsageData,
          PrefetchHooks Function({bool grammarId, bool grammarExamplesRefs})
        > {
  $$GrammarUsagesTableTableManager(_$NemoDatabase db, $GrammarUsagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarUsagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarUsagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarUsagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> grammarId = const Value.absent(),
                Value<String?> subtype = const Value.absent(),
                Value<String> connection = const Value.absent(),
                Value<String> explanation = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => GrammarUsagesCompanion(
                id: id,
                grammarId: grammarId,
                subtype: subtype,
                connection: connection,
                explanation: explanation,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String grammarId,
                Value<String?> subtype = const Value.absent(),
                required String connection,
                required String explanation,
                Value<String?> notes = const Value.absent(),
              }) => GrammarUsagesCompanion.insert(
                id: id,
                grammarId: grammarId,
                subtype: subtype,
                connection: connection,
                explanation: explanation,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GrammarUsagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({grammarId = false, grammarExamplesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (grammarExamplesRefs) db.grammarExamples,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (grammarId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.grammarId,
                                    referencedTable:
                                        $$GrammarUsagesTableReferences
                                            ._grammarIdTable(db),
                                    referencedColumn:
                                        $$GrammarUsagesTableReferences
                                            ._grammarIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (grammarExamplesRefs)
                        await $_getPrefetchedData<
                          GrammarUsageData,
                          $GrammarUsagesTable,
                          GrammarExampleData
                        >(
                          currentTable: table,
                          referencedTable: $$GrammarUsagesTableReferences
                              ._grammarExamplesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GrammarUsagesTableReferences(
                                db,
                                table,
                                p0,
                              ).grammarExamplesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usageId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GrammarUsagesTableProcessedTableManager =
    ProcessedTableManager<
      _$NemoDatabase,
      $GrammarUsagesTable,
      GrammarUsageData,
      $$GrammarUsagesTableFilterComposer,
      $$GrammarUsagesTableOrderingComposer,
      $$GrammarUsagesTableAnnotationComposer,
      $$GrammarUsagesTableCreateCompanionBuilder,
      $$GrammarUsagesTableUpdateCompanionBuilder,
      (GrammarUsageData, $$GrammarUsagesTableReferences),
      GrammarUsageData,
      PrefetchHooks Function({bool grammarId, bool grammarExamplesRefs})
    >;
typedef $$GrammarExamplesTableCreateCompanionBuilder =
    GrammarExamplesCompanion Function({
      Value<int> id,
      required int usageId,
      required String sentence,
      required String translation,
      Value<String?> source,
      Value<bool> isDialog,
    });
typedef $$GrammarExamplesTableUpdateCompanionBuilder =
    GrammarExamplesCompanion Function({
      Value<int> id,
      Value<int> usageId,
      Value<String> sentence,
      Value<String> translation,
      Value<String?> source,
      Value<bool> isDialog,
    });

final class $$GrammarExamplesTableReferences
    extends
        BaseReferences<
          _$NemoDatabase,
          $GrammarExamplesTable,
          GrammarExampleData
        > {
  $$GrammarExamplesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GrammarUsagesTable _usageIdTable(_$NemoDatabase db) =>
      db.grammarUsages.createAlias(
        $_aliasNameGenerator(db.grammarExamples.usageId, db.grammarUsages.id),
      );

  $$GrammarUsagesTableProcessedTableManager get usageId {
    final $_column = $_itemColumn<int>('usage_id')!;

    final manager = $$GrammarUsagesTableTableManager(
      $_db,
      $_db.grammarUsages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GrammarExamplesTableFilterComposer
    extends Composer<_$NemoDatabase, $GrammarExamplesTable> {
  $$GrammarExamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDialog => $composableBuilder(
    column: $table.isDialog,
    builder: (column) => ColumnFilters(column),
  );

  $$GrammarUsagesTableFilterComposer get usageId {
    final $$GrammarUsagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usageId,
      referencedTable: $db.grammarUsages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarUsagesTableFilterComposer(
            $db: $db,
            $table: $db.grammarUsages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GrammarExamplesTableOrderingComposer
    extends Composer<_$NemoDatabase, $GrammarExamplesTable> {
  $$GrammarExamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDialog => $composableBuilder(
    column: $table.isDialog,
    builder: (column) => ColumnOrderings(column),
  );

  $$GrammarUsagesTableOrderingComposer get usageId {
    final $$GrammarUsagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usageId,
      referencedTable: $db.grammarUsages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarUsagesTableOrderingComposer(
            $db: $db,
            $table: $db.grammarUsages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GrammarExamplesTableAnnotationComposer
    extends Composer<_$NemoDatabase, $GrammarExamplesTable> {
  $$GrammarExamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sentence =>
      $composableBuilder(column: $table.sentence, builder: (column) => column);

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isDialog =>
      $composableBuilder(column: $table.isDialog, builder: (column) => column);

  $$GrammarUsagesTableAnnotationComposer get usageId {
    final $$GrammarUsagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usageId,
      referencedTable: $db.grammarUsages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarUsagesTableAnnotationComposer(
            $db: $db,
            $table: $db.grammarUsages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GrammarExamplesTableTableManager
    extends
        RootTableManager<
          _$NemoDatabase,
          $GrammarExamplesTable,
          GrammarExampleData,
          $$GrammarExamplesTableFilterComposer,
          $$GrammarExamplesTableOrderingComposer,
          $$GrammarExamplesTableAnnotationComposer,
          $$GrammarExamplesTableCreateCompanionBuilder,
          $$GrammarExamplesTableUpdateCompanionBuilder,
          (GrammarExampleData, $$GrammarExamplesTableReferences),
          GrammarExampleData,
          PrefetchHooks Function({bool usageId})
        > {
  $$GrammarExamplesTableTableManager(
    _$NemoDatabase db,
    $GrammarExamplesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarExamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarExamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarExamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> usageId = const Value.absent(),
                Value<String> sentence = const Value.absent(),
                Value<String> translation = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<bool> isDialog = const Value.absent(),
              }) => GrammarExamplesCompanion(
                id: id,
                usageId: usageId,
                sentence: sentence,
                translation: translation,
                source: source,
                isDialog: isDialog,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int usageId,
                required String sentence,
                required String translation,
                Value<String?> source = const Value.absent(),
                Value<bool> isDialog = const Value.absent(),
              }) => GrammarExamplesCompanion.insert(
                id: id,
                usageId: usageId,
                sentence: sentence,
                translation: translation,
                source: source,
                isDialog: isDialog,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GrammarExamplesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({usageId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (usageId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.usageId,
                                referencedTable:
                                    $$GrammarExamplesTableReferences
                                        ._usageIdTable(db),
                                referencedColumn:
                                    $$GrammarExamplesTableReferences
                                        ._usageIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GrammarExamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$NemoDatabase,
      $GrammarExamplesTable,
      GrammarExampleData,
      $$GrammarExamplesTableFilterComposer,
      $$GrammarExamplesTableOrderingComposer,
      $$GrammarExamplesTableAnnotationComposer,
      $$GrammarExamplesTableCreateCompanionBuilder,
      $$GrammarExamplesTableUpdateCompanionBuilder,
      (GrammarExampleData, $$GrammarExamplesTableReferences),
      GrammarExampleData,
      PrefetchHooks Function({bool usageId})
    >;
typedef $$LearningProgressTableCreateCompanionBuilder =
    LearningProgressCompanion Function({
      required String id,
      required String itemType,
      Value<BigInt> dueTime,
      Value<int> interval,
      Value<double> difficulty,
      Value<double> stability,
      Value<int> repetitionCount,
      Value<BigInt?> lastReviewed,
      Value<BigInt?> firstLearned,
      Value<int> step,
      Value<int> lapses,
      Value<bool> isSuspended,
      Value<bool> isSkipped,
      Value<int> rowid,
    });
typedef $$LearningProgressTableUpdateCompanionBuilder =
    LearningProgressCompanion Function({
      Value<String> id,
      Value<String> itemType,
      Value<BigInt> dueTime,
      Value<int> interval,
      Value<double> difficulty,
      Value<double> stability,
      Value<int> repetitionCount,
      Value<BigInt?> lastReviewed,
      Value<BigInt?> firstLearned,
      Value<int> step,
      Value<int> lapses,
      Value<bool> isSuspended,
      Value<bool> isSkipped,
      Value<int> rowid,
    });

class $$LearningProgressTableFilterComposer
    extends Composer<_$NemoDatabase, $LearningProgressTable> {
  $$LearningProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<BigInt> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitionCount => $composableBuilder(
    column: $table.repetitionCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<BigInt> get lastReviewed => $composableBuilder(
    column: $table.lastReviewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<BigInt> get firstLearned => $composableBuilder(
    column: $table.firstLearned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSuspended => $composableBuilder(
    column: $table.isSuspended,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSkipped => $composableBuilder(
    column: $table.isSkipped,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LearningProgressTableOrderingComposer
    extends Composer<_$NemoDatabase, $LearningProgressTable> {
  $$LearningProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<BigInt> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitionCount => $composableBuilder(
    column: $table.repetitionCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<BigInt> get lastReviewed => $composableBuilder(
    column: $table.lastReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<BigInt> get firstLearned => $composableBuilder(
    column: $table.firstLearned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSuspended => $composableBuilder(
    column: $table.isSuspended,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSkipped => $composableBuilder(
    column: $table.isSkipped,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LearningProgressTableAnnotationComposer
    extends Composer<_$NemoDatabase, $LearningProgressTable> {
  $$LearningProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<BigInt> get dueTime =>
      $composableBuilder(column: $table.dueTime, builder: (column) => column);

  GeneratedColumn<int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<double> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => column);

  GeneratedColumn<int> get repetitionCount => $composableBuilder(
    column: $table.repetitionCount,
    builder: (column) => column,
  );

  GeneratedColumn<BigInt> get lastReviewed => $composableBuilder(
    column: $table.lastReviewed,
    builder: (column) => column,
  );

  GeneratedColumn<BigInt> get firstLearned => $composableBuilder(
    column: $table.firstLearned,
    builder: (column) => column,
  );

  GeneratedColumn<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<bool> get isSuspended => $composableBuilder(
    column: $table.isSuspended,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSkipped =>
      $composableBuilder(column: $table.isSkipped, builder: (column) => column);
}

class $$LearningProgressTableTableManager
    extends
        RootTableManager<
          _$NemoDatabase,
          $LearningProgressTable,
          LearningProgressData,
          $$LearningProgressTableFilterComposer,
          $$LearningProgressTableOrderingComposer,
          $$LearningProgressTableAnnotationComposer,
          $$LearningProgressTableCreateCompanionBuilder,
          $$LearningProgressTableUpdateCompanionBuilder,
          (
            LearningProgressData,
            BaseReferences<
              _$NemoDatabase,
              $LearningProgressTable,
              LearningProgressData
            >,
          ),
          LearningProgressData,
          PrefetchHooks Function()
        > {
  $$LearningProgressTableTableManager(
    _$NemoDatabase db,
    $LearningProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearningProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearningProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearningProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> itemType = const Value.absent(),
                Value<BigInt> dueTime = const Value.absent(),
                Value<int> interval = const Value.absent(),
                Value<double> difficulty = const Value.absent(),
                Value<double> stability = const Value.absent(),
                Value<int> repetitionCount = const Value.absent(),
                Value<BigInt?> lastReviewed = const Value.absent(),
                Value<BigInt?> firstLearned = const Value.absent(),
                Value<int> step = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<bool> isSuspended = const Value.absent(),
                Value<bool> isSkipped = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearningProgressCompanion(
                id: id,
                itemType: itemType,
                dueTime: dueTime,
                interval: interval,
                difficulty: difficulty,
                stability: stability,
                repetitionCount: repetitionCount,
                lastReviewed: lastReviewed,
                firstLearned: firstLearned,
                step: step,
                lapses: lapses,
                isSuspended: isSuspended,
                isSkipped: isSkipped,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String itemType,
                Value<BigInt> dueTime = const Value.absent(),
                Value<int> interval = const Value.absent(),
                Value<double> difficulty = const Value.absent(),
                Value<double> stability = const Value.absent(),
                Value<int> repetitionCount = const Value.absent(),
                Value<BigInt?> lastReviewed = const Value.absent(),
                Value<BigInt?> firstLearned = const Value.absent(),
                Value<int> step = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<bool> isSuspended = const Value.absent(),
                Value<bool> isSkipped = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearningProgressCompanion.insert(
                id: id,
                itemType: itemType,
                dueTime: dueTime,
                interval: interval,
                difficulty: difficulty,
                stability: stability,
                repetitionCount: repetitionCount,
                lastReviewed: lastReviewed,
                firstLearned: firstLearned,
                step: step,
                lapses: lapses,
                isSuspended: isSuspended,
                isSkipped: isSkipped,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LearningProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$NemoDatabase,
      $LearningProgressTable,
      LearningProgressData,
      $$LearningProgressTableFilterComposer,
      $$LearningProgressTableOrderingComposer,
      $$LearningProgressTableAnnotationComposer,
      $$LearningProgressTableCreateCompanionBuilder,
      $$LearningProgressTableUpdateCompanionBuilder,
      (
        LearningProgressData,
        BaseReferences<
          _$NemoDatabase,
          $LearningProgressTable,
          LearningProgressData
        >,
      ),
      LearningProgressData,
      PrefetchHooks Function()
    >;

class $NemoDatabaseManager {
  final _$NemoDatabase _db;
  $NemoDatabaseManager(this._db);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
  $$WordExamplesTableTableManager get wordExamples =>
      $$WordExamplesTableTableManager(_db, _db.wordExamples);
  $$GrammarsTableTableManager get grammars =>
      $$GrammarsTableTableManager(_db, _db.grammars);
  $$GrammarUsagesTableTableManager get grammarUsages =>
      $$GrammarUsagesTableTableManager(_db, _db.grammarUsages);
  $$GrammarExamplesTableTableManager get grammarExamples =>
      $$GrammarExamplesTableTableManager(_db, _db.grammarExamples);
  $$LearningProgressTableTableManager get learningProgress =>
      $$LearningProgressTableTableManager(_db, _db.learningProgress);
}

mixin _$WordDaoMixin on DatabaseAccessor<NemoDatabase> {
  $WordsTable get words => attachedDatabase.words;
  $WordExamplesTable get wordExamples => attachedDatabase.wordExamples;
}
mixin _$GrammarDaoMixin on DatabaseAccessor<NemoDatabase> {
  $GrammarsTable get grammars => attachedDatabase.grammars;
  $GrammarUsagesTable get grammarUsages => attachedDatabase.grammarUsages;
  $GrammarExamplesTable get grammarExamples => attachedDatabase.grammarExamples;
}
mixin _$LearningDaoMixin on DatabaseAccessor<NemoDatabase> {
  $LearningProgressTable get learningProgress =>
      attachedDatabase.learningProgress;
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nemoDatabaseHash() => r'5e977c3008daefd479d9fdae98196ecb61c44987';

/// See also [nemoDatabase].
@ProviderFor(nemoDatabase)
final nemoDatabaseProvider = AutoDisposeProvider<NemoDatabase>.internal(
  nemoDatabase,
  name: r'nemoDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nemoDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NemoDatabaseRef = AutoDisposeProviderRef<NemoDatabase>;
String _$wordDaoHash() => r'b7629a01386c8dce1932531e0eb48b5372dc1cc5';

/// See also [wordDao].
@ProviderFor(wordDao)
final wordDaoProvider = AutoDisposeProvider<WordDao>.internal(
  wordDao,
  name: r'wordDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wordDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WordDaoRef = AutoDisposeProviderRef<WordDao>;
String _$grammarDaoHash() => r'332d19f240dcee5834610f9147c91e49b1638dda';

/// See also [grammarDao].
@ProviderFor(grammarDao)
final grammarDaoProvider = AutoDisposeProvider<GrammarDao>.internal(
  grammarDao,
  name: r'grammarDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$grammarDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GrammarDaoRef = AutoDisposeProviderRef<GrammarDao>;
String _$learningDaoHash() => r'594fff41e63f67e19418f6ba368afa831da52be9';

/// See also [learningDao].
@ProviderFor(learningDao)
final learningDaoProvider = AutoDisposeProvider<LearningDao>.internal(
  learningDao,
  name: r'learningDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$learningDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LearningDaoRef = AutoDisposeProviderRef<LearningDao>;
String _$allWordsHash() => r'6b3e2bf4ff71280e7849ff324fb597996d06f87d';

/// See also [allWords].
@ProviderFor(allWords)
final allWordsProvider = AutoDisposeStreamProvider<List<WordEntry>>.internal(
  allWords,
  name: r'allWordsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allWordsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllWordsRef = AutoDisposeStreamProviderRef<List<WordEntry>>;
String _$allGrammarsHash() => r'35d8493cf29b740447d4d636eb7978ff7e3f09a0';

/// See also [allGrammars].
@ProviderFor(allGrammars)
final allGrammarsProvider =
    AutoDisposeStreamProvider<List<GrammarEntry>>.internal(
      allGrammars,
      name: r'allGrammarsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allGrammarsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllGrammarsRef = AutoDisposeStreamProviderRef<List<GrammarEntry>>;
String _$allGrammarsWithDetailsHash() =>
    r'53777d48dc3d6c23ff6c69c3000aa12b9d7d6b25';

/// See also [allGrammarsWithDetails].
@ProviderFor(allGrammarsWithDetails)
final allGrammarsWithDetailsProvider =
    AutoDisposeStreamProvider<List<Grammar>>.internal(
      allGrammarsWithDetails,
      name: r'allGrammarsWithDetailsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allGrammarsWithDetailsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllGrammarsWithDetailsRef = AutoDisposeStreamProviderRef<List<Grammar>>;
String _$wordsByCategoryHash() => r'2bdef4690b50704a45a1753f63e076c3070922ad';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [wordsByCategory].
@ProviderFor(wordsByCategory)
const wordsByCategoryProvider = WordsByCategoryFamily();

/// See also [wordsByCategory].
class WordsByCategoryFamily extends Family<AsyncValue<List<WordEntry>>> {
  /// See also [wordsByCategory].
  const WordsByCategoryFamily();

  /// See also [wordsByCategory].
  WordsByCategoryProvider call(String category) {
    return WordsByCategoryProvider(category);
  }

  @override
  WordsByCategoryProvider getProviderOverride(
    covariant WordsByCategoryProvider provider,
  ) {
    return call(provider.category);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'wordsByCategoryProvider';
}

/// See also [wordsByCategory].
class WordsByCategoryProvider
    extends AutoDisposeStreamProvider<List<WordEntry>> {
  /// See also [wordsByCategory].
  WordsByCategoryProvider(String category)
    : this._internal(
        (ref) => wordsByCategory(ref as WordsByCategoryRef, category),
        from: wordsByCategoryProvider,
        name: r'wordsByCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$wordsByCategoryHash,
        dependencies: WordsByCategoryFamily._dependencies,
        allTransitiveDependencies:
            WordsByCategoryFamily._allTransitiveDependencies,
        category: category,
      );

  WordsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  Override overrideWith(
    Stream<List<WordEntry>> Function(WordsByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WordsByCategoryProvider._internal(
        (ref) => create(ref as WordsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<WordEntry>> createElement() {
    return _WordsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordsByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WordsByCategoryRef on AutoDisposeStreamProviderRef<List<WordEntry>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _WordsByCategoryProviderElement
    extends AutoDisposeStreamProviderElement<List<WordEntry>>
    with WordsByCategoryRef {
  _WordsByCategoryProviderElement(super.provider);

  @override
  String get category => (origin as WordsByCategoryProvider).category;
}

String _$wordWithExamplesHash() => r'70405083d569a9cb21b1447aedbe1be196f875be';

/// See also [wordWithExamples].
@ProviderFor(wordWithExamples)
const wordWithExamplesProvider = WordWithExamplesFamily();

/// See also [wordWithExamples].
class WordWithExamplesFamily extends Family<AsyncValue<WordWithExamples?>> {
  /// See also [wordWithExamples].
  const WordWithExamplesFamily();

  /// See also [wordWithExamples].
  WordWithExamplesProvider call(String id) {
    return WordWithExamplesProvider(id);
  }

  @override
  WordWithExamplesProvider getProviderOverride(
    covariant WordWithExamplesProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'wordWithExamplesProvider';
}

/// See also [wordWithExamples].
class WordWithExamplesProvider
    extends AutoDisposeFutureProvider<WordWithExamples?> {
  /// See also [wordWithExamples].
  WordWithExamplesProvider(String id)
    : this._internal(
        (ref) => wordWithExamples(ref as WordWithExamplesRef, id),
        from: wordWithExamplesProvider,
        name: r'wordWithExamplesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$wordWithExamplesHash,
        dependencies: WordWithExamplesFamily._dependencies,
        allTransitiveDependencies:
            WordWithExamplesFamily._allTransitiveDependencies,
        id: id,
      );

  WordWithExamplesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<WordWithExamples?> Function(WordWithExamplesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WordWithExamplesProvider._internal(
        (ref) => create(ref as WordWithExamplesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WordWithExamples?> createElement() {
    return _WordWithExamplesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordWithExamplesProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WordWithExamplesRef on AutoDisposeFutureProviderRef<WordWithExamples?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _WordWithExamplesProviderElement
    extends AutoDisposeFutureProviderElement<WordWithExamples?>
    with WordWithExamplesRef {
  _WordWithExamplesProviderElement(super.provider);

  @override
  String get id => (origin as WordWithExamplesProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
