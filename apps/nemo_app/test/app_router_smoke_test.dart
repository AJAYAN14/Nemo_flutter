import 'package:flutter_test/flutter_test.dart';
import 'package:nemo_app/app/router/app_router.dart';

void main() {
  test('main router is initialized', () {
    expect(appRouter, isNotNull);
  });
}
