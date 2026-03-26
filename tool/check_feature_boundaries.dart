import 'dart:io';

final _featureImport = RegExp(r'''import\s+['"]package:(feature_[^/]+)/''');

void main() {
  final root = Directory.current;
  final featuresRoot = Directory('${root.path}${Platform.pathSeparator}packages${Platform.pathSeparator}features');
  if (!featuresRoot.existsSync()) {
    stderr.writeln('features directory not found: ${featuresRoot.path}');
    exit(2);
  }

  final violations = <String>[];
  for (final file in featuresRoot
      .listSync(recursive: true, followLinks: false)
      .whereType<File>()) {
    final normalizedPath = file.path.replaceAll('\\', '/');
    if (!normalizedPath.contains('/lib/') || !normalizedPath.endsWith('.dart')) {
      continue;
    }
    final parts = normalizedPath.split('/');
    final featureIndex = parts.indexOf('features');
    if (featureIndex == -1 || featureIndex + 1 >= parts.length) {
      continue;
    }
    final ownerFeature = parts[featureIndex + 1];
    final content = file.readAsStringSync();
    final lines = content.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final match = _featureImport.firstMatch(line);
      if (match == null) {
        continue;
      }
      final importedFeature = match.group(1)!;
      if (importedFeature != ownerFeature) {
        violations.add('${file.path}:${i + 1}: $line');
      }
    }
  }

  if (violations.isNotEmpty) {
    stderr.writeln('Feature boundary violation detected. Cross-feature imports are not allowed in lib/.');
    for (final violation in violations) {
      stderr.writeln(violation);
    }
    exit(1);
  }

  stdout.writeln('Feature boundary check passed.');
}
