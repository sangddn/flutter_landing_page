part of 'ui.dart';

class SoundEffects {
  static final _cached = <UiAsset, int>{};

  static Future<void> play(UiAsset sound, {double rate = 1.0}) async {
    return;
  }

  static Future<void> playSpeechToTextListening() =>
      play(UiAsset.speechToTextListening);

  static Future<void> playSpeechToTextStop() => play(UiAsset.speechToTextStop);

  static Future<void> playSpeechToTextCancel() =>
      play(UiAsset.speechToTextCancel, rate: 1.5);
}
