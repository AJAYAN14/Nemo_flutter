import 'dart:math';

import 'package:feature_learning/src/domain/fsrs_algorithm.dart';

class ReviewLog {
  final int rating;
  ReviewLog({required this.rating});
}

class OptimizationResult {
  final List<double> parameters;
  final int sampleSize;
  final double againRate;
  final double hardRate;

  OptimizationResult({
    required this.parameters,
    required this.sampleSize,
    required this.againRate,
    required this.hardRate,
  });
}

class FsrsParameterOptimizer {
  static const int minLogsForTuning = 400;

  /// Optimize parameters from review logs.
  ///
  /// Accepts `logs` as a list of either ints (rating), Maps with `rating`, or
  /// `ReviewLog` instances.
  static OptimizationResult? optimize(List<dynamic> logs, [List<double>? base]) {
    if (logs.length < minLogsForTuning) return null;

    final tuned = List<double>.from(base ?? FsrsAlgorithm.defaultParameters);
    final total = logs.length.toDouble();

    int toRating(dynamic item) {
      if (item is int) return item;
      if (item is double) return item.toInt();
      if (item is ReviewLog) return item.rating;
      if (item is Map && item['rating'] != null) return (item['rating'] as num).toInt();
      return 0;
    }

    final againCount = logs.where((l) => toRating(l) <= 2).length;
    final hardCount = logs.where((l) => toRating(l) == 3).length;

    final againRate = againCount.toDouble() / total;
    final hardRate = hardCount.toDouble() / total;

    // 1) forget-rate drift adjustments
    final double againDrift = againRate - 0.25;
    tuned[11] = tuned[11] * _clamp(1.0 + againDrift * 0.50, 0.92, 1.08);
    tuned[8] = tuned[8] * _clamp(1.0 - againDrift * 0.35, 0.92, 1.08);
    tuned[16] = tuned[16] * _clamp(1.0 - againDrift * 0.25, 0.94, 1.06);

    // 2) hard-rate drift adjustments
    final double hardDrift = hardRate - 0.20;
    tuned[15] = tuned[15] * _clamp(1.0 - hardDrift * 0.40, 0.90, 1.10);

    // 3) stability protection
    tuned[11] = max(0.5, tuned[11]);
    tuned[16] = max(1.1, tuned[16]);

    return OptimizationResult(
      parameters: tuned,
      sampleSize: logs.length,
      againRate: againRate,
      hardRate: hardRate,
    );
  }

  static double _clamp(double value, double min, double max) => value.clamp(min, max) as double;
}
