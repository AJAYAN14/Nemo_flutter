import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:feature_learning/src/domain/fsrs_algorithm.dart';

void main() async {
  final alg = FsrsAlgorithm();

  final testCases = [
    {'state': null, 'elapsed': 0.0, 'id': 'new_0'},
    {'state': null, 'elapsed': 1.0, 'id': 'new_1'},
    {'state': {'stability': 0.212, 'difficulty': 5.0}, 'elapsed': 0.0, 'id': 's0.212_d5_e0'},
    {'state': {'stability': 0.212, 'difficulty': 5.0}, 'elapsed': 1.0, 'id': 's0.212_d5_e1'},
    {'state': {'stability': 1.2931, 'difficulty': 3.0}, 'elapsed': 7.0, 'id': 's1.2931_d3_e7'},
    {'state': {'stability': 2.3065, 'difficulty': 4.0}, 'elapsed': 30.0, 'id': 's2.3065_d4_e30'},
    {'state': {'stability': 8.2956, 'difficulty': 2.0}, 'elapsed': 90.0, 'id': 's8.2956_d2_e90'},
    {'state': {'stability': 10.0, 'difficulty': 6.0}, 'elapsed': 365.0, 'id': 's10_d6_e365'},
    {'state': {'stability': 100.0, 'difficulty': 5.0}, 'elapsed': 365.0, 'id': 's100_d5_e365'},
    {'state': {'stability': 0.5, 'difficulty': 9.0}, 'elapsed': 3.0, 'id': 's0.5_d9_e3'},
    {'state': {'stability': 0.01, 'difficulty': 1.0}, 'elapsed': 0.0, 'id': 's0.01_d1_e0'},
    {'state': {'stability': 50.0, 'difficulty': 4.0}, 'elapsed': 14.0, 'id': 's50_d4_e14'},
    {'state': {'stability': 7.0, 'difficulty': 8.0}, 'elapsed': 21.0, 'id': 's7_d8_e21'},
    {'state': {'stability': 30.0, 'difficulty': 6.0}, 'elapsed': 45.0, 'id': 's30_d6_e45'},
    {'state': {'stability': 0.8, 'difficulty': 2.0}, 'elapsed': 2.0, 'id': 's0.8_d2_e2'},
    {'state': {'stability': 3.0, 'difficulty': 5.0}, 'elapsed': 10.0, 'id': 's3_d5_e10'},
    {'state': {'stability': 20.0, 'difficulty': 7.0}, 'elapsed': 60.0, 'id': 's20_d7_e60'},
    {'state': {'stability': 5.0, 'difficulty': 1.0}, 'elapsed': 1.0, 'id': 's5_d1_e1'},
    {'state': {'stability': 0.212, 'difficulty': 1.0}, 'elapsed': 365.0, 'id': 's0.212_d1_e365'},
    {'state': {'stability': 36500.0, 'difficulty': 10.0}, 'elapsed': 365.0, 'id': 's36500_d10_e365'},
  ];

  final outputs = testCases.map((tc) {
    final state = tc['state'];
    final elapsed = (tc['elapsed'] as double);
    final id = tc['id'] as String;

    MemoryState? current;
    if (state != null) {
      final Map<String, dynamic> st = state as Map<String, dynamic>;
      current = MemoryState(
        stability: (st['stability'] as double),
        difficulty: (st['difficulty'] as double),
      );
    }

    final next = alg.nextStates(current, elapsed);

    Map<String, dynamic> toMap(ItemState item) => {
          'stability': item.memory.stability,
          'difficulty': item.memory.difficulty,
          'interval': item.interval,
        };

    return {
      'id': id,
      'currentStability': current?.stability,
      'currentDifficulty': current?.difficulty,
      'elapsedDays': elapsed,
      'nextStates': {
        'again': toMap(next.again),
        'hard': toMap(next.hard),
        'good': toMap(next.good),
        'easy': toMap(next.easy),
      }
    };
  }).toList();

  // Helper: format a numeric value to the shortest decimal string that
  // round-trips to the same 32-bit float. This mirrors Kotlin's Float
  // stringification used when producing the baseline JSON.
  String fmtF32(double v) {
    final f32 = Float32List.fromList([v])[0];
    // Try increasing precision until parsed->f32 equals original f32
    for (var p = 1; p <= 15; p++) {
      final s = f32.toStringAsPrecision(p);
      try {
        final parsed = double.parse(s);
        final parsedF32 = Float32List.fromList([parsed])[0];
        if (parsedF32 == f32) return s;
      } catch (_) {}
    }
    // Fallback to the full f32 toString
    return f32.toString();
  }

  String writeNumberToken(double? v) => v == null ? 'null' : fmtF32(v);

  String toMapJsonFromMap(Map<String, dynamic> m) {
    return '{"stability": ${writeNumberToken(m['stability'] as double)}, "difficulty": ${writeNumberToken(m['difficulty'] as double)}, "interval": ${writeNumberToken(m['interval'] as double)}}';
  }

  final sb = StringBuffer();
  sb.writeln('[');
  for (var i = 0; i < outputs.length; i++) {
    final o = outputs[i];
    sb.writeln('  {');
    sb.writeln('    "id": ${jsonEncode(o['id'])},');
    sb.writeln('    "currentStability": ${writeNumberToken(o['currentStability'] as double?)},');
    sb.writeln('    "currentDifficulty": ${writeNumberToken(o['currentDifficulty'] as double?)},');
    sb.writeln('    "elapsedDays": ${writeNumberToken(o['elapsedDays'] as double)},');
    final ns = o['nextStates'] as Map<String, dynamic>;
    sb.writeln('    "nextStates": {');
    sb.writeln('      "again": ${toMapJsonFromMap(ns['again'] as Map<String, dynamic>)},');
    sb.writeln('      "hard": ${toMapJsonFromMap(ns['hard'] as Map<String, dynamic>)},');
    sb.writeln('      "good": ${toMapJsonFromMap(ns['good'] as Map<String, dynamic>)},');
    sb.writeln('      "easy": ${toMapJsonFromMap(ns['easy'] as Map<String, dynamic>)}');
    sb.writeln('    }');
    sb.write('  }');
    if (i < outputs.length - 1) sb.write(',');
    sb.writeln();
  }
  sb.writeln(']');

  final file = File(r'../../../fsrs_dart_outputs.json');
  await file.writeAsString(sb.toString());
  print('Wrote Dart FSRS outputs to ${file.path}');
}
