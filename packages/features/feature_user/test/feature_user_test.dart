import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:feature_user/feature_user.dart';

void main() {
  test('profile provider returns mock name', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final value = container.read(mockProfileNameProvider);
    expect(value, isNotEmpty);
  });
}
