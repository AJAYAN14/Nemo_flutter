import 'package:flutter_test/flutter_test.dart';

import 'package:core_ui/core_ui.dart';

void main() {
  test('exports P0 widgets', () {
    expect(NemoSplashScreen, isNotNull);
    expect(NemoMainShell, isNotNull);
  });
}
