import 'package:audioplayers/audioplayers.dart';

/// 1:1 Parity with Kotlin SoundEffectPlayer.
///
/// Plays short sound effects from bundled assets. Uses AudioPlayer per-sound
/// to allow overlapping playback (matching SoundPool maxStreams=4 behaviour).
class SoundEffectService {
  static final SoundEffectService _instance = SoundEffectService._();
  factory SoundEffectService() => _instance;
  SoundEffectService._();

  final AudioPlayer _goodPlayer = AudioPlayer();
  final AudioPlayer _otherPlayer = AudioPlayer();

  bool _initialized = false;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    _initialized = true;
    // Pre-set sources for fast playback; AudioCache is used under the hood.
    await _goodPlayer.setSource(AssetSource('audio/sound_good.mp3'));
    await _otherPlayer.setSource(AssetSource('audio/sound_other.mp3'));
    await _goodPlayer.setReleaseMode(ReleaseMode.stop);
    await _otherPlayer.setReleaseMode(ReleaseMode.stop);
  }

  /// Play "good" sound (for Good / Easy ratings).
  /// Matches Kotlin's `SoundEffectPlayer.playGoodSound(context)`.
  Future<void> playGoodSound() async {
    try {
      await _ensureInit();
      await _goodPlayer.stop();
      await _goodPlayer.resume();
    } catch (_) {
      // Silently fail — identical to Kotlin's catch-all in fallbackPlay.
    }
  }

  /// Play "other" sound (for Again / Hard ratings).
  /// Matches Kotlin's `SoundEffectPlayer.playOtherSound(context)`.
  Future<void> playOtherSound() async {
    try {
      await _ensureInit();
      await _otherPlayer.stop();
      await _otherPlayer.resume();
    } catch (_) {
      // Silently fail.
    }
  }

  void dispose() {
    _goodPlayer.dispose();
    _otherPlayer.dispose();
    _initialized = false;
  }
}
