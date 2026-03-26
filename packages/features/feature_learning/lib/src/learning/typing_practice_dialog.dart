import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'typing_practice_providers.dart';

Future<void> showTypingPracticeDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final notifier = ref.read(typingPracticeProvider.notifier);
  notifier.clear();

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const TypingPracticeDialog(),
  );
}

class TypingPracticeDialog extends ConsumerWidget {
  const TypingPracticeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(typingPracticeProvider);
    final prompt = ref.watch(typingPracticePromptProvider);

    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final availableHeight = MediaQuery.sizeOf(context).height * 0.86;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: keyboardInset),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: availableHeight),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          '跟打练习',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: NemoColors.textMain,
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: NemoColors.surfaceSoft,
                            foregroundColor: NemoColors.textSub,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: NemoColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            prompt.japanese,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: NemoColors.textMain,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            prompt.hiragana,
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: NemoColors.textMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FeedbackBanner(feedback: state.feedback),
                    const SizedBox(height: 10),
                    TextField(
                      onChanged: ref
                          .read(typingPracticeProvider.notifier)
                          .updateKanaInput,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: '假名',
                        hintText: '请输入假名',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide:
                              const BorderSide(color: NemoColors.brandBlue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: ref
                          .read(typingPracticeProvider.notifier)
                          .updateKanjiInput,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        ref.read(typingPracticeProvider.notifier).validate(
                              prompt: prompt,
                              onClose: () {
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                            );
                      },
                      decoration: InputDecoration(
                        labelText: '汉字',
                        hintText: '请输入汉字',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide:
                              const BorderSide(color: NemoColors.brandBlue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: ref
                                .read(typingPracticeProvider.notifier)
                                .clear,
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            label: const Text('清空'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: state.canSubmit
                                ? () {
                                    FocusScope.of(context).unfocus();
                                    ref
                                        .read(typingPracticeProvider.notifier)
                                        .validate(
                                          prompt: prompt,
                                          onClose: () {
                                            if (context.mounted) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        );
                                  }
                                : null,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              backgroundColor: NemoColors.brandBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              '确定',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.feedback});

  final TypingFeedback feedback;

  @override
  Widget build(BuildContext context) {
    if (feedback == TypingFeedback.hidden) {
      return const SizedBox(height: 20);
    }

    final ok = feedback == TypingFeedback.correct;
    final bg = ok ? const Color(0xFFE8F8F2) : const Color(0xFFFFEBEE);
    final fg = ok ? const Color(0xFF0F766E) : const Color(0xFFC62828);
    final text = ok ? '回答正确！' : '回答错误，请检查您的输入';

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            ok ? Icons.check_circle_rounded : Icons.error_rounded,
            color: fg,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
