import 'package:core_domain/core_domain.dart';
import 'package:test/test.dart';

void main() {
  group('core_domain exports', () {
    test('mock constants are available', () {
      expect(kAppName, 'Nemo');
      expect(kMockUserName, isNotEmpty);
    });
  });
}
