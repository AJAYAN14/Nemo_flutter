import 'package:flutter/material.dart';

class UnifiedTestScreen extends StatelessWidget {
  final Widget headerContent;
  final Widget progressContent;
  final Widget testContent;
  final Widget footerContent;

  const UnifiedTestScreen({
    super.key,
    required this.headerContent,
    required this.progressContent,
    required this.testContent,
    required this.footerContent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.05),
              theme.colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Scrollable Content
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 120, // Space for fixed footer
                  ),
                  child: Column(
                    children: [
                      headerContent,
                      const SizedBox(height: 16),
                      progressContent,
                      const SizedBox(height: 16),
                      testContent,
                    ],
                  ),
                ),
              ),

              // Fixed Footer (Floating effect)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  color: Colors.transparent, // Floating look
                  padding: const EdgeInsets.all(16),
                  child: footerContent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
