import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core_designsystem/core_designsystem.dart';

void main() {
  test('exports Nemo theme', () {
    expect(NemoTheme.light.useMaterial3, isTrue);
    expect(NemoTheme.dark.brightness, Brightness.dark);
  });
}
