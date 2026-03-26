import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'components/settings_components.dart';

// --- TTS State Providers (Aligned with SettingsScreen Notifier Pattern) ---
class TtsVoiceNameNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? value) => state = value;
}
final ttsVoiceNameProvider = NotifierProvider<TtsVoiceNameNotifier, String?>(TtsVoiceNameNotifier.new);

class TtsSpeedNotifier extends Notifier<double> {
  @override
  double build() => 1.0;
  void set(double value) => state = value;
}
final ttsSpeedProvider = NotifierProvider<TtsSpeedNotifier, double>(TtsSpeedNotifier.new);

class TtsPitchNotifier extends Notifier<double> {
  @override
  double build() => 1.0;
  void set(double value) => state = value;
}
final ttsPitchProvider = NotifierProvider<TtsPitchNotifier, double>(TtsPitchNotifier.new);
// ----------------------------------------------

class TtsSettingsScreen extends HookConsumerWidget {
  const TtsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voiceName = ref.watch(ttsVoiceNameProvider);
    final speed = ref.watch(ttsSpeedProvider);
    final pitch = ref.watch(ttsPitchProvider);

    const accentColor = Color(0xFFAF52DE); // NemoPurple
    const secondaryAccent = Color(0xFF00C7BE); // NemoCyan
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
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
                  voices: const ['系统默认', 'Google 语音 1', 'Google 语音 2 (Network)', 'Siri 日本语'],
                  onVoiceSelected: (val) => ref.read(ttsVoiceNameProvider.notifier).set(val),
                  onPreviewVoice: (val) {
                    // TODO: Mock preview
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
            child: _FlatSliderSettingItem(
              icon: Icons.speed_rounded,
              iconColor: accentColor,
              title: '语速 (Speed)',
              value: speed,
              valueDisplay: '${speed.toStringAsFixed(1)}x',
              onChanged: (val) => ref.read(ttsSpeedProvider.notifier).set(val),
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
            child: _FlatSliderSettingItem(
              icon: Icons.music_note_rounded,
              iconColor: secondaryAccent,
              title: '音调 (Pitch)',
              value: pitch,
              valueDisplay: '${pitch.toStringAsFixed(1)}x',
              onChanged: (val) => ref.read(ttsPitchProvider.notifier).set(val),
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
                    // TODO: Trigger TTS preview
                    HapticFeedback.lightImpact();
                  },
                ),
                const SizedBox(height: 12),
                _FlatTextButton(
                  text: '重置为默认值',
                  color: Colors.grey,
                  onClick: () {
                    ref.read(ttsSpeedProvider.notifier).set(1.0);
                    ref.read(ttsPitchProvider.notifier).set(1.0);
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

class _FlatSliderSettingItem extends StatelessWidget {
  const _FlatSliderSettingItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.valueDisplay,
    required this.onChanged,
    required this.min,
    required this.max,
    required this.divisions,
    required this.accentColor,
    required this.labels,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final double value;
  final String valueDisplay;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int divisions;
  final Color accentColor;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              // Squircle Icon Box
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
              // Value Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  valueDisplay,
                  style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              activeTrackColor: accentColor,
              inactiveTrackColor: Colors.grey.withOpacity(0.2),
              thumbColor: accentColor,
              overlayColor: accentColor.withOpacity(0.12),
              tickMarkShape: SliderTickMarkShape.noTickMark,
            ),
            child: Slider(
              value: value,
              onChanged: (val) {
                if (val != value) {
                  HapticFeedback.selectionClick();
                  onChanged(val);
                }
              },
              min: min,
              max: max,
              divisions: divisions,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels.map((l) => Text(l, style: const TextStyle(fontSize: 11, color: Colors.grey))).toList(),
            ),
          ),
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
