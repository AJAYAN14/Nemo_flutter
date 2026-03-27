import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_prefs/core_prefs.dart';

part 'tts_service.g.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  final PreferenceService _prefs;

  TtsService({required PreferenceService prefs}) : _prefs = prefs {
    _init();
  }

  Future<void> _init() async {
    await _flutterTts.setLanguage("ja-JP");
    await updateSettings();
    
    _flutterTts.setErrorHandler((msg) {
      print("TTS Error: $msg");
    });
  }

  Future<void> updateSettings() async {
    final speed = _prefs.getTtsSpeed();
    final pitch = _prefs.getTtsPitch();
    final voiceName = _prefs.getTtsVoiceName();

    await _flutterTts.setSpeechRate(speed);
    await _flutterTts.setPitch(pitch);
    if (voiceName != null) {
      await _flutterTts.setVoice({"name": voiceName, "locale": "ja-JP"});
    }
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  Future<List<dynamic>> getVoices() async {
    final voices = await _flutterTts.getVoices;
    return voices.where((v) => v["locale"] == "ja-JP").toList();
  }
}

@riverpod
TtsService ttsService(TtsServiceRef ref) {
  final prefs = ref.watch(preferenceServiceProvider);
  return TtsService(prefs: prefs);
}
