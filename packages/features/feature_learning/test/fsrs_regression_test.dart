import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:feature_learning/src/domain/fsrs_algorithm.dart';

bool f32Equal(double? a, double? b) {
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;
  return Float32List.fromList([a])[0] == Float32List.fromList([b])[0];
}

void main() {
  test('FsrsAlgorithm regression parity with Kotlin baseline', () {
    final baselinePath = '../../../fsrs_kotlin_outputs.json';
    final file = File(baselinePath);
    expect(file.existsSync(), isTrue, reason: 'Kotlin baseline file not found at $baselinePath');

    final data = jsonDecode(file.readAsStringSync()) as List<dynamic>;
    final alg = FsrsAlgorithm();

    for (final entry in data) {
      final id = entry['id'] as String;
      final currentStability = (entry['currentStability'] as num?)?.toDouble();
      final currentDifficulty = (entry['currentDifficulty'] as num?)?.toDouble();
      final elapsedDays = (entry['elapsedDays'] as num).toDouble();

      MemoryState? current;
      if (currentStability != null || currentDifficulty != null) {
        current = MemoryState(
          stability: currentStability ?? 0.0,
          difficulty: currentDifficulty ?? 0.0,
        );
      }

      final next = alg.nextStates(current, elapsedDays);

      Map<String, dynamic> expected(Map m) => m.cast<String, dynamic>();

      final expectedNext = expected(entry['nextStates'] as Map);

      final again = expectedNext['again'] as Map<String, dynamic>;
      final hard = expectedNext['hard'] as Map<String, dynamic>;
      final good = expectedNext['good'] as Map<String, dynamic>;
      final easy = expectedNext['easy'] as Map<String, dynamic>;

      // Compare float32-equality for each numeric field
      expect(f32Equal(next.again.memory.stability, (again['stability'] as num).toDouble()), isTrue,
          reason: '$id again.stability mismatch');
      expect(f32Equal(next.again.memory.difficulty, (again['difficulty'] as num).toDouble()), isTrue,
          reason: '$id again.difficulty mismatch');
      expect(f32Equal(next.again.interval, (again['interval'] as num).toDouble()), isTrue,
          reason: '$id again.interval mismatch');

      expect(f32Equal(next.hard.memory.stability, (hard['stability'] as num).toDouble()), isTrue,
          reason: '$id hard.stability mismatch');
      expect(f32Equal(next.hard.memory.difficulty, (hard['difficulty'] as num).toDouble()), isTrue,
          reason: '$id hard.difficulty mismatch');
      expect(f32Equal(next.hard.interval, (hard['interval'] as num).toDouble()), isTrue,
          reason: '$id hard.interval mismatch');

      expect(f32Equal(next.good.memory.stability, (good['stability'] as num).toDouble()), isTrue,
          reason: '$id good.stability mismatch');
      expect(f32Equal(next.good.memory.difficulty, (good['difficulty'] as num).toDouble()), isTrue,
          reason: '$id good.difficulty mismatch');
      expect(f32Equal(next.good.interval, (good['interval'] as num).toDouble()), isTrue,
          reason: '$id good.interval mismatch');

      expect(f32Equal(next.easy.memory.stability, (easy['stability'] as num).toDouble()), isTrue,
          reason: '$id easy.stability mismatch');
      expect(f32Equal(next.easy.memory.difficulty, (easy['difficulty'] as num).toDouble()), isTrue,
          reason: '$id easy.difficulty mismatch');
      expect(f32Equal(next.easy.interval, (easy['interval'] as num).toDouble()), isTrue,
          reason: '$id easy.interval mismatch');
    }
  }, timeout: Timeout.none);
}
