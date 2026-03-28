import 'package:test/test.dart';
import 'package:feature_learning/src/domain/fsrs_parameter_optimizer.dart';
import 'package:feature_learning/src/domain/fsrs_algorithm.dart';

void main() {
  test('FsrsParameterOptimizer returns null when logs insufficient', () {
    final result = FsrsParameterOptimizer.optimize(List.generate(399, (i) => (i % 4) + 1));
    expect(result, isNull);
  });

  test('FsrsParameterOptimizer returns tuned parameters when logs sufficient', () {
    final logs = List.generate(400, (i) => (i % 4) + 1); // ratings 1..4
    final result = FsrsParameterOptimizer.optimize(logs);
    expect(result, isNotNull);
    expect(result!.parameters.length, FsrsAlgorithm.defaultParameters.length);
    expect(result.sampleSize, 400);
  });
}
