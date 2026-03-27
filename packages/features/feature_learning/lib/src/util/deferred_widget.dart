import 'package:flutter/material.dart';

typedef LibraryLoader = Future<void> Function();
typedef DeferredWidgetBuilder = Widget Function();

class DeferredWidget extends StatefulWidget {
  const DeferredWidget({
    super.key,
    required this.loader,
    required this.builder,
    this.placeholder = const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  });

  final LibraryLoader loader;
  final DeferredWidgetBuilder builder;
  final Widget placeholder;

  @override
  State<DeferredWidget> createState() => _DeferredWidgetState();
}

class _DeferredWidgetState extends State<DeferredWidget> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await widget.loader();
    if (mounted) {
      setState(() {
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loaded) {
      return widget.builder();
    }
    return widget.placeholder;
  }
}
