import 'dart:math';
import 'dart:typed_data';
import 'package:feature_learning/src/domain/fsrs_algorithm.dart';

double f32(double x) => Float32List.fromList([x])[0];
int f32Bits(double x) => Float32List.fromList([x]).buffer.asByteData().getUint32(0, Endian.little);

void debugCase(FsrsAlgorithm alg, String id, double stability, double difficulty, double elapsed) {
  final w = alg.w;
  final decay = w[20];

  final s = f32(stability);
  final d = f32(difficulty);
  final factor = f32(pow(f32(0.9), f32(1.0 / -decay)).toDouble() - 1.0);
  final base = f32(elapsed / s * factor + 1.0);
  final r = f32(pow(base, -decay).toDouble());

  final expW8 = f32(exp(w[8]));
  final powStab = f32(pow(s, -w[9]).toDouble());

  // Print raw bits similar to Kotlin debug
  print('BITS|$id|factorBits=${f32Bits(factor)}|baseBits=${f32Bits(base)}|rBits=${f32Bits(r)}|expW8Bits=${f32Bits(expW8)}|powStabBits=${f32Bits(powStab)}');

  final ratings = [FsrsRating.again, FsrsRating.hard, FsrsRating.good, FsrsRating.easy];
  for (var rating in ratings) {
    final hardPenalty = (rating == FsrsRating.hard) ? w[15] : 1.0;
    final easyBonus = (rating == FsrsRating.easy) ? w[16] : 1.0;
    final step1 = f32(expW8 * (11.0 - d));
    final step2 = f32(step1 * powStab);
    final expTerm = f32(exp((1.0 - r) * w[10]));
    final step3 = f32(step2 * (expTerm - 1.0));
    final step4 = f32(step3 * hardPenalty);
    final step5 = f32(step4 * easyBonus);
    final inside = f32(step5 + 1.0);
    final newS = f32(s * inside);
    final interval = f32(alg.nextInterval(newS));
    final label = rating.toString().split('.').last;
    print('BITS3|$id|$label|step5Bits=${f32Bits(step5)}|insideBits=${f32Bits(inside)}|newSBits=${f32Bits(newS)}');
    print('$id|$label|factor=$factor|base=$base|r=$r|expW8=$expW8|step1=$step1|powStab=$powStab|step2=$step2|expTerm=$expTerm|step3=$step3|hardPenalty=$hardPenalty|easyBonus=$easyBonus|step5=$step5|inside=$inside|newS=$newS|interval=$interval');
  }
}

void main() {
  final alg = FsrsAlgorithm();
  final cases = [
    {'id': 's0.01_d1_e0', 's': 0.01, 'd': 1.0, 'e': 0.0},
    {'id': 's0.212_d1_e365', 's': 0.212, 'd': 1.0, 'e': 365.0},
    {'id': 's0.212_d5_e0', 's': 0.212, 'd': 5.0, 'e': 0.0},
    {'id': 's10_d6_e365', 's': 10.0, 'd': 6.0, 'e': 365.0},
    {'id': 's8.2956_d2_e90', 's': 8.2956, 'd': 2.0, 'e': 90.0},
  ];

  for (var c in cases) {
    debugCase(alg, c['id'] as String, c['s'] as double, c['d'] as double, c['e'] as double);
  }
}
