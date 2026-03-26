import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../mock/kana_mock_data.dart';

class KanaChartState {
  const KanaChartState({
    required this.section,
    required this.playingId,
  });

  final KanaSection section;
  final String? playingId;

  KanaChartState copyWith({
    KanaSection? section,
    String? playingId,
    bool clearPlaying = false,
  }) {
    return KanaChartState(
      section: section ?? this.section,
      playingId: clearPlaying ? null : (playingId ?? this.playingId),
    );
  }
}

class KanaChartNotifier extends Notifier<KanaChartState> {
  Timer? _mockAudioTimer;

  @override
  KanaChartState build() {
    ref.onDispose(() {
      _mockAudioTimer?.cancel();
    });

    return const KanaChartState(
      section: KanaSection.seion,
      playingId: null,
    );
  }

  void switchSection(KanaSection section) {
    state = state.copyWith(section: section, clearPlaying: true);
  }

  void playSample(String id) {
    _mockAudioTimer?.cancel();
    state = state.copyWith(playingId: id);

    _mockAudioTimer = Timer(const Duration(milliseconds: 700), () {
      state = state.copyWith(clearPlaying: true);
    });
  }
}

final kanaChartProvider = NotifierProvider<KanaChartNotifier, KanaChartState>(
  KanaChartNotifier.new,
);

final kanaCellsProvider = Provider<List<KanaCellData>>((ref) {
  final state = ref.watch(kanaChartProvider);
  return kanaGridData[state.section] ?? const <KanaCellData>[];
});

final kanaColumnsProvider = Provider<int>((ref) {
  final state = ref.watch(kanaChartProvider);
  return kanaColumns[state.section] ?? 5;
});
