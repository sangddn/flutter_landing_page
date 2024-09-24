part of 'ui.dart';

class SoundEffects {
  static final _pool = Soundpool.fromOptions(
    options: const SoundpoolOptions(
      iosOptions: SoundpoolOptionsIos(
        audioSessionCategory: AudioSessionCategory.ambient,
      ),
    ),
  );
  static final _cached = <UiAsset, int>{};

  static Future<void> play(UiAsset sound, {double rate = 1.0}) async {
    final soundId = _cached[sound] ??
        (await rootBundle.load(sound.path).then((bytes) async {
          return _cached[sound] = await _pool.load(bytes);
        }));
    debugPrint('SoundEffects.play: $soundId');
    if (soundId == null) {
      return;
    }
    await _pool.play(soundId, rate: rate);
    return;
  }

  static Future<void> playSpeechToTextListening() =>
      play(UiAsset.speechToTextListening);

  static Future<void> playSpeechToTextStop() => play(UiAsset.speechToTextStop);

  static Future<void> playSpeechToTextCancel() =>
      play(UiAsset.speechToTextCancel, rate: 1.5);
}
