import 'package:freezed_annotation/freezed_annotation.dart';

part 'word.freezed.dart';
part 'word.g.dart';

@freezed
class Word with _$Word {
  const factory Word({
    required String id,
    required String japanese,
    required String hiragana,
    required String chinese,
    required String level,
    String? pos,
    @Default([]) List<WordExample> examples,
    @Default([]) List<FuriganaBlock> furiganaData,
    @Default(false) bool isFavorite,
  }) = _Word;

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);
}

@freezed
class WordExample with _$WordExample {
  const factory WordExample({
    required String japanese,
    required String chinese,
    String? audioId,
  }) = _WordExample;

  factory WordExample.fromJson(Map<String, dynamic> json) => _$WordExampleFromJson(json);
}

@freezed
class FuriganaBlock with _$FuriganaBlock {
  const factory FuriganaBlock({
    required String text,
    String? furigana,
  }) = _FuriganaBlock;

  factory FuriganaBlock.fromJson(Map<String, dynamic> json) => _$FuriganaBlockFromJson(json);
}
