import 'package:core_domain/core_domain.dart';
import 'package:core_storage/core_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'historical_statistics_provider.g.dart';

@riverpod
Stream<List<LearningItem>> learnedWords(LearnedWordsRef ref) {
  final repository = ref.watch(statisticsRepositoryProvider);
  return repository.getAllLearnedWords();
}

@riverpod
Stream<List<LearningItem>> learnedGrammars(LearnedGrammarsRef ref) {
  final repository = ref.watch(statisticsRepositoryProvider);
  return repository.getAllLearnedGrammars();
}
