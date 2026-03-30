import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:feature_learning/src/srs_review/srs_review_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('SrsReview golden', () {
    testGoldens('srs_review basic', (tester) async {
      final builder = DeviceBuilder()
        ..addScenario(
          name: 'default',
          widget: ProviderScope(
            child: SrsReviewScreen(
              mode: 'word',
            ),
          ),
        );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'srs_review_default');
    }, skip: true); // skipped until Kotlin baseline images are provided
  });
}
