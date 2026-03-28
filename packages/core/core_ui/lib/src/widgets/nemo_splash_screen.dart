import 'dart:async';

import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_storage/core_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NemoSplashScreen extends ConsumerStatefulWidget {
  const NemoSplashScreen({
    super.key,
    required this.onTimeout,
    this.delay = NemoMetrics.splashDelay,
  });

  final VoidCallback onTimeout;
  final Duration delay;

  @override
  ConsumerState<NemoSplashScreen> createState() => _NemoSplashScreenState();
}

class _NemoSplashScreenState extends ConsumerState<NemoSplashScreen> {
  Timer? _timer;
  bool _startAnimation = false;
  bool _timerFinished = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _startAnimation = true;
      });
    });

    _timer = Timer(widget.delay, () {
      if (!mounted) {
        return;
      }
      _timerFinished = true;
      _checkCompletion();
    });
  }

  void _checkCompletion() {
    if (!mounted) return;

    // We only proceed if the timer has finished AND the importer is ready
    final importerAsync = ref.read(assetDataImporterProvider);
    if (_timerFinished && !importerAsync.isLoading) {
      widget.onTimeout();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to importer state to trigger redirection when it finishes
    ref.listen(assetDataImporterProvider, (previous, next) {
      if (!next.isLoading && _timerFinished) {
        widget.onTimeout();
      }
    });

    final importerState = ref.watch(assetDataImporterProvider);

    return Scaffold(
      body: Container(
        color: NemoColors.brandBlue,
        child: Stack(
          children: [
            Center(
              child: AnimatedOpacity(
                duration: NemoMetrics.fadeDuration,
                opacity: _startAnimation ? 1 : 0,
                child: AnimatedScale(
                  duration: NemoMetrics.scaleDuration,
                  curve: Curves.easeOutQuint,
                  scale: _startAnimation ? 1 : 0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sailing_rounded,
                          color: Colors.white,
                          size: 88,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Nemo',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '解锁日语新视界',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Initialization Progress Indicator
            if (importerState.isLoading)
              Positioned(
                bottom: 64,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '正在准备学习资料...',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
            // Error State
            if (importerState.hasError)
              Positioned(
                bottom: 48,
                left: 32,
                right: 32,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '初始化似乎遇到了问题，请稍后重试。',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                      TextButton(
                        onPressed: () => ref.invalidate(assetDataImporterProvider),
                        child: const Text('重试', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
