import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:feature_learning/feature_learning.dart';
import 'package:core_domain/core_domain.dart';

part 'leech_management_providers.g.dart';

class LeechManagementState {
  final List<LearningItem> skippedWords;
  final List<LearningItem> skippedGrammars;
  final String? error;
  final String? successMessage;

  LeechManagementState({
    this.skippedWords = const [],
    this.skippedGrammars = const [],
    this.error,
    this.successMessage,
  });

  LeechManagementState copyWith({
    List<LearningItem>? skippedWords,
    List<LearningItem>? skippedGrammars,
    String? error,
    String? successMessage,
  }) {
    return LeechManagementState(
      skippedWords: skippedWords ?? this.skippedWords,
      skippedGrammars: skippedGrammars ?? this.skippedGrammars,
      error: error ?? this.error,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

@riverpod
class LeechManagementNotifier extends _$LeechManagementNotifier {
  @override
  FutureOr<LeechManagementState> build() async {
    final repository = ref.watch(learningRepositoryProvider);
    final words = await repository.getSkippedItems('word');
    final grammars = await repository.getSkippedItems('grammar');
    
    return LeechManagementState(
      skippedWords: words,
      skippedGrammars: grammars,
    );
  }

  Future<void> recover(String id, String type) async {
    final current = state.valueOrNull;
    if (current == null) return;

    try {
      final repository = ref.read(learningRepositoryProvider);
      await repository.recoverLeech(id, type);
      
      // Refresh local data to avoid full reload if possible, 
      // but Repository provides the source of truth.
      final words = await repository.getSkippedItems('word');
      final grammars = await repository.getSkippedItems('grammar');
      
      state = AsyncData(current.copyWith(
        skippedWords: words,
        skippedGrammars: grammars,
        successMessage: type == 'word' ? '单词已恢复至学习队列' : '语法已恢复至学习队列',
        error: null,
      ));
    } catch (e) {
      state = AsyncData(current.copyWith(error: '恢复失败: $e', successMessage: null));
    }
  }

  void clearMessages() {
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(error: null, successMessage: null));
    }
  }
}
