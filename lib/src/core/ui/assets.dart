part of 'ui.dart';

enum UiAsset {
  // Logos
  icon('$_logo/icon', 'png'),
  iconRounded('$_logo/icon_rounded', 'png'),
  favicon('$_logo/favicon', 'png'),
  faviconNoir('$_logo/favicon_noir', 'png'),
  faviconMono('$_logo/favicon_mono', 'png'),
  logoDark('$_logo/logo_dark', 'png'),
  logoLight('$_logo/logo_light', 'png'),
  logoDarkSvg('$_logo/logo_dark', 'svg'),
  logoLightSvg('$_logo/logo_light', 'svg'),

  // Graphics
  dcGraphic('$_graphics/dc', 'jpeg'),
  sfGraphic('$_graphics/sf', 'jpeg'),
  georgetownGraphic('$_graphics/georgetown', 'jpeg'),
  georgetown2Graphic('$_graphics/georgetown_2', 'jpeg'),
  hotAirBalloon('$_graphics/hot_air_balloon', 'webp'),

  // Me
  me1('$_avatars/me_1', 'webp'),
  me2('$_avatars/me_2', 'webp'),
  friendGroup('$_avatars/group', 'webp'),
  memoji('$_avatars/memoji', 'webp'),

  // Icons
  lineSpacing('$_imgMisc/line_spacing', 'svg'),
  letterSpacing('$_imgMisc/letter_spacing', 'svg'),
  wordSpacing('$_imgMisc/word_spacing', 'svg'),
  margin('$_imgMisc/margin', 'svg'),
  verifiedIcon('$_imgMisc/verified_icon', 'png'),
  verifiedIconAlt('$_imgMisc/verified_icon_alt', 'png'),
  walkOutlined('$_icon/walk_outlined', 'svg'),
  walkFilled('$_icon/walk_filled', 'svg'),
  carOutlined('$_icon/car_outlined', 'svg'),
  carFilled('$_icon/car_filled', 'svg'),
  carAltOutlined('$_icon/car_alt_outlined', 'svg'),
  carAltFilled('$_icon/car_alt_filled', 'svg'),
  pinOutlined('$_icon/pin_outlined', 'svg'),
  pinFilled('$_icon/pin_filled', 'svg'),
  walletOutlined('$_icon/wallet_outlined', 'svg'),
  walletFilled('$_icon/wallet_filled', 'svg'),

  // Misc logos
  appleHealth('$_imgMisc/apple_health', 'png'),
  healthConnect('$_imgMisc/health_connect', 'png'),
  notion('$_imgMisc/notion', 'png'),
  googleCalendar('$_imgMisc/google_calendar', 'png'),
  appleCalendar('$_imgMisc/apple_calendar', 'png'),
  googlePhotos('$_imgMisc/google_photos', 'png'),
  applePhotos('$_imgMisc/apple_photos', 'png'),
  google('$_imgMisc/google_logo', 'svg'),
  googleColor('$_imgMisc/google_logo_color', 'svg'),
  twitterX('$_imgMisc/twitter_x', 'svg'),
  instagram('$_imgMisc/instagram', 'png'),
  qatarAirwaysLogo('$_imgMisc/qatar', 'png'),

  // Graphics
  featureRequest('$_imgMisc/questions', 'png'),
  inviteFriends('$_imgMisc/invite_friends', 'png'),

  // Sound Effects
  sentMessage('$_soundEffect/message_sent_sound', 'wav'),
  speechToTextListening('$_soundEffect/speech_to_text_listening', 'm4r'),
  speechToTextStop('$_soundEffect/speech_to_text_stop', 'm4r'),
  speechToTextCancel('$_soundEffect/speech_to_text_cancel', 'm4r'),
  ;

  const UiAsset(this.pathWoExt, this.ext);

  final String pathWoExt;
  final String ext;
}

const _assets = 'assets';
const _image = '$_assets/images';
const _sound = '$_assets/sounds';
const _precompiledSvg = '$_assets/precompiled_svgs';

const _avatars = '$_image/avatars';
const _graphics = '$_image/graphics';
const _logo = '$_image/logos';
const _imgMisc = '$_image/misc';
const _icon = '$_image/icons';

const _soundEffect = '$_sound/sound_effects';

extension UiAssetX on UiAsset {
  String get path => '$pathWoExt.$ext';
  String get name => pathWoExt.split('/').last;
  bool get isSvg => ext == 'svg';
  bool get isPng => ext == 'png';
  bool get isJpeg => ext == 'jpeg' || ext == 'jpg';
  bool get isGif => ext == 'gif';
  bool get isJson => ext == 'json';
  bool get isAhap => ext == 'ahap';

  String get precompiledSvgPath {
    if (ext != 'svg') {
      throw UnsupportedError('Only SVGs can be precompiled');
    }
    return '$_precompiledSvg/$name.si';
  }

  /// Returns an [ImageProvider] for the asset.
  ///
  /// This does not support SVGs. If the asset is an SVG, it must be precompiled
  /// and used with [ScalableImageWidget].
  ///
  ImageProvider toImageProvider() {
    if (isSvg) {
      throw UnsupportedError('SVGs must be precompiled');
    }
    return AssetImage(path) as ImageProvider;
  }
}
