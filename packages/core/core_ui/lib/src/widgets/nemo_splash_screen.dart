import 'dart:async';

import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';

class NemoSplashScreen extends StatefulWidget {
  const NemoSplashScreen({
    super.key,
    required this.onTimeout,
    this.delay = NemoMetrics.splashDelay,
  });

  final VoidCallback onTimeout;
  final Duration delay;

  @override
  State<NemoSplashScreen> createState() => _NemoSplashScreenState();
}

class _NemoSplashScreenState extends State<NemoSplashScreen> {
  Timer? _timer;
  bool _startAnimation = false;

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
      widget.onTimeout();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: NemoColors.brandBlue,
        child: Center(
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
                      color: Colors.white.withOpacity(0.12),
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
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
