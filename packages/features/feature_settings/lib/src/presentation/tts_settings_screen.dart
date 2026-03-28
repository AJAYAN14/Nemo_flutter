import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:core_prefs/core_prefs.dart';
import 'package:core_audio/core_audio.dart';
import 'components/settings_components.dart';

// Real providers from core_prefs will be used.

class TtsSettingsScreen extends HookConsumerWidget {
  const TtsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferenceServiceProvider);
    final voiceName = prefs.getTtsVoiceName();
    final speed = prefs.getTtsSpeed();
    final pitch = prefs.getTtsPitch();

    const accentColor = Color(0xFFAF52DE); // NemoPurple
    const secondaryAccent = Color(0xFF00C7BE); // NemoCyan
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('语音设置', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // =====================
          // 语音来源
          // =====================
          const SettingsSectionTitle('语音来源'),
          PremiumCard(
            padding: EdgeInsets.zero,
            child: PremiumSettingsItem(
              title: '选择语音',
              subtitle: voiceName ?? '系统默认',
              icon: Icons.record_voice_over_rounded,
              iconColor: const Color(0xFFFF2D55), // NemoRed
              onClick: () => context.showNemoBottomSheet(
                child: VoiceSelectionBottomSheet(
                  currentVoiceName: voiceName,
                  voices: const ['系统默认'], // TODO: Fetch real voices from TtsService
                  onVoiceSelected: (val) async {
                    await prefs.setTtsVoiceName(val == '系统默认' ? null : val);
                    ref.read(ttsServiceProvider).updateSettings();
                    ref.invalidate(preferenceServiceProvider);
                  },
                  onPreviewVoice: (val) {
                    ref.read(ttsServiceProvider).speak('こんにちは、これはプレビューです');
                  },
                ),
              ),
              showDivider: false,
            ),
          ),

          const SizedBox(height: 24),

          // =====================
          // 语速调节
          // =====================
          const SettingsSectionTitle('语速调节'),
          PremiumCard(
            padding: EdgeInsets.zero,
            child: PremiumSliderSettingItem(
              icon: Icons.speed_rounded,
              iconColor: accentColor,
              title: '语速 (Speed)',
              value: speed,
              valueDisplay: '${speed.toStringAsFixed(1)}x',
              onChanged: (val) async {
                await prefs.setTtsSpeed(val);
                ref.read(ttsServiceProvider).updateSettings();
                ref.invalidate(preferenceServiceProvider);
              },
              min: 0.5,
              max: 2.0,
              divisions: 15,
              accentColor: accentColor,
              labels: const ['0.5x', '1.0x', '2.0x'],
            ),
          ),

          const SizedBox(height: 24),

          // =====================
          // 音调调节
          // =====================
          const SettingsSectionTitle('音调调节'),
          PremiumCard(
            padding: EdgeInsets.zero,
            child: PremiumSliderSettingItem(
              icon: Icons.music_note_rounded,
              iconColor: secondaryAccent,
              title: '音调 (Pitch)',
              value: pitch,
              valueDisplay: '${pitch.toStringAsFixed(1)}x',
              onChanged: (val) async {
                await prefs.setTtsPitch(val);
                ref.read(ttsServiceProvider).updateSettings();
                ref.invalidate(preferenceServiceProvider);
              },
              min: 0.5,
              max: 2.0,
              divisions: 15,
              accentColor: secondaryAccent,
              labels: const ['0.5x', '1.0x', '2.0x'],
            ),
          ),

          const SizedBox(height: 24),

          // =====================
          // 试听 & 重置
          // =====================
          const SettingsSectionTitle('试听 & 重置'),
          PremiumCard(
            child: Column(
              children: [
                _FlatPrimaryButton(
                  text: '试听 (日语)',
                  icon: Icons.play_arrow_rounded,
                  color: accentColor,
                  onClick: () {
                    ref.read(ttsServiceProvider).speak('こんにちは、日本語の学習を始めましょう。');
                    HapticFeedback.lightImpact();
                  },
                ),
                const SizedBox(height: 12),
                _FlatTextButton(
                  text: '重置为默认值',
                  color: Colors.grey,
                  onClick: () async {
                    HapticFeedback.mediumImpact();
                    await prefs.setTtsSpeed(1.0);
                    await prefs.setTtsPitch(1.0);
                    ref.read(ttsServiceProvider).updateSettings();
                    ref.invalidate(preferenceServiceProvider);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _FlatPrimaryButton extends StatelessWidget {
  const _FlatPrimaryButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onClick,
  });

  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onClick,
        icon: Icon(icon, size: 20),
        label: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }
}

class _FlatTextButton extends StatelessWidget {
  const _FlatTextButton({
    required this.text,
    required this.color,
    required this.onClick,
  });

  final String text;
  final Color color;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClick,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
    );
  }
}
