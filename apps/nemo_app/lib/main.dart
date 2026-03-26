import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nemo_app/app/nemo_app.dart';

void main() {
  runApp(const ProviderScope(child: NemoApp()));
}
