// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thumbnail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Thumbnail _$ThumbnailFromJson(Map<String, dynamic> json) {
  return _Thumbnail.fromJson(json);
}

/// @nodoc
mixin _$Thumbnail {
  /// The served URL of the picture thumbnail.
  ///
  @JsonKey(name: 'src')
  String get sourceUrl => throw _privateConstructorUsedError;

  /// An alternate text for the image, if the image cannot be displayed.
  ///
  @JsonKey(name: 'alt', includeIfNull: false)
  String? get altText => throw _privateConstructorUsedError;

  /// The height of the image.
  ///
  @JsonKey(name: 'height', includeIfNull: false)
  int? get height => throw _privateConstructorUsedError;

  /// The width of the image.
  ///
  @JsonKey(name: 'width', includeIfNull: false)
  int? get width => throw _privateConstructorUsedError;

  /// The URL of the thumbnail.
  ///
  @JsonKey(name: 'thumbnail_link', includeIfNull: false)
  String? get thumbnailUrl => throw _privateConstructorUsedError;

  /// The height of the thumbnail.
  ///
  @JsonKey(name: 'thumbnail_height', includeIfNull: false)
  int? get thumbnailHeight => throw _privateConstructorUsedError;

  /// The width of the thumbnail.
  ///
  @JsonKey(name: 'thumbnail_width', includeIfNull: false)
  int? get thumbnailWidth => throw _privateConstructorUsedError;

  /// The background color of the image in hex format.
  ///
  @JsonKey(name: 'bg_color', includeIfNull: false)
  String? get backgroundColor => throw _privateConstructorUsedError;

  /// The original URL of the image.
  ///
  @JsonKey(name: 'original', includeIfNull: false)
  String? get originalUrl => throw _privateConstructorUsedError;

  /// Source name.
  ///
  @JsonKey(name: 'src_name', includeIfNull: false)
  String? get sourceName => throw _privateConstructorUsedError;

  /// Source domain.
  ///
  @JsonKey(name: 'src_domain', includeIfNull: false)
  String? get sourceDomain => throw _privateConstructorUsedError;

  /// Link to the source this [Thumbnail] was fetched from.
  ///
  @JsonKey(name: 'link', includeIfNull: false)
  String? get sourceLink => throw _privateConstructorUsedError;

  /// Whether the image is a logo.
  ///
  @JsonKey(name: 'logo', includeIfNull: false)
  bool? get isLogo => throw _privateConstructorUsedError;

  /// Whether the image is duplicated.
  ///
  @JsonKey(name: 'duplicated', includeIfNull: false)
  bool? get isDuplicated => throw _privateConstructorUsedError;

  /// The theme associated with the image.
  ///
  @JsonKey(includeIfNull: false)
  String? get theme => throw _privateConstructorUsedError;

  /// The type of the media.
  ///
  @JsonKey(name: 'media_type')
  MediaType get mediaType => throw _privateConstructorUsedError;

  /// The (YouTube) channel associated with the thumbnail.
  ///
  /// This is only applicable to video thumbnails.
  ///
  @JsonKey(includeIfNull: false)
  String? get channel => throw _privateConstructorUsedError;

  /// The duration of the video. This is only applicable to video thumbnails.
  ///
  @JsonKey(includeIfNull: false)
  String? get duration => throw _privateConstructorUsedError;

  /// The date the video was published. This is only applicable to video
  /// thumbnails.
  ///
  @JsonKey(includeIfNull: false)
  String? get date => throw _privateConstructorUsedError;

  /// Serializes this Thumbnail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Thumbnail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ThumbnailCopyWith<Thumbnail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThumbnailCopyWith<$Res> {
  factory $ThumbnailCopyWith(Thumbnail value, $Res Function(Thumbnail) then) =
      _$ThumbnailCopyWithImpl<$Res, Thumbnail>;
  @useResult
  $Res call(
      {@JsonKey(name: 'src') String sourceUrl,
      @JsonKey(name: 'alt', includeIfNull: false) String? altText,
      @JsonKey(name: 'height', includeIfNull: false) int? height,
      @JsonKey(name: 'width', includeIfNull: false) int? width,
      @JsonKey(name: 'thumbnail_link', includeIfNull: false)
      String? thumbnailUrl,
      @JsonKey(name: 'thumbnail_height', includeIfNull: false)
      int? thumbnailHeight,
      @JsonKey(name: 'thumbnail_width', includeIfNull: false)
      int? thumbnailWidth,
      @JsonKey(name: 'bg_color', includeIfNull: false) String? backgroundColor,
      @JsonKey(name: 'original', includeIfNull: false) String? originalUrl,
      @JsonKey(name: 'src_name', includeIfNull: false) String? sourceName,
      @JsonKey(name: 'src_domain', includeIfNull: false) String? sourceDomain,
      @JsonKey(name: 'link', includeIfNull: false) String? sourceLink,
      @JsonKey(name: 'logo', includeIfNull: false) bool? isLogo,
      @JsonKey(name: 'duplicated', includeIfNull: false) bool? isDuplicated,
      @JsonKey(includeIfNull: false) String? theme,
      @JsonKey(name: 'media_type') MediaType mediaType,
      @JsonKey(includeIfNull: false) String? channel,
      @JsonKey(includeIfNull: false) String? duration,
      @JsonKey(includeIfNull: false) String? date});
}

/// @nodoc
class _$ThumbnailCopyWithImpl<$Res, $Val extends Thumbnail>
    implements $ThumbnailCopyWith<$Res> {
  _$ThumbnailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Thumbnail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sourceUrl = null,
    Object? altText = freezed,
    Object? height = freezed,
    Object? width = freezed,
    Object? thumbnailUrl = freezed,
    Object? thumbnailHeight = freezed,
    Object? thumbnailWidth = freezed,
    Object? backgroundColor = freezed,
    Object? originalUrl = freezed,
    Object? sourceName = freezed,
    Object? sourceDomain = freezed,
    Object? sourceLink = freezed,
    Object? isLogo = freezed,
    Object? isDuplicated = freezed,
    Object? theme = freezed,
    Object? mediaType = null,
    Object? channel = freezed,
    Object? duration = freezed,
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      sourceUrl: null == sourceUrl
          ? _value.sourceUrl
          : sourceUrl // ignore: cast_nullable_to_non_nullable
              as String,
      altText: freezed == altText
          ? _value.altText
          : altText // ignore: cast_nullable_to_non_nullable
              as String?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailHeight: freezed == thumbnailHeight
          ? _value.thumbnailHeight
          : thumbnailHeight // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbnailWidth: freezed == thumbnailWidth
          ? _value.thumbnailWidth
          : thumbnailWidth // ignore: cast_nullable_to_non_nullable
              as int?,
      backgroundColor: freezed == backgroundColor
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as String?,
      originalUrl: freezed == originalUrl
          ? _value.originalUrl
          : originalUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceName: freezed == sourceName
          ? _value.sourceName
          : sourceName // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceDomain: freezed == sourceDomain
          ? _value.sourceDomain
          : sourceDomain // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceLink: freezed == sourceLink
          ? _value.sourceLink
          : sourceLink // ignore: cast_nullable_to_non_nullable
              as String?,
      isLogo: freezed == isLogo
          ? _value.isLogo
          : isLogo // ignore: cast_nullable_to_non_nullable
              as bool?,
      isDuplicated: freezed == isDuplicated
          ? _value.isDuplicated
          : isDuplicated // ignore: cast_nullable_to_non_nullable
              as bool?,
      theme: freezed == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as MediaType,
      channel: freezed == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThumbnailImplCopyWith<$Res>
    implements $ThumbnailCopyWith<$Res> {
  factory _$$ThumbnailImplCopyWith(
          _$ThumbnailImpl value, $Res Function(_$ThumbnailImpl) then) =
      __$$ThumbnailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'src') String sourceUrl,
      @JsonKey(name: 'alt', includeIfNull: false) String? altText,
      @JsonKey(name: 'height', includeIfNull: false) int? height,
      @JsonKey(name: 'width', includeIfNull: false) int? width,
      @JsonKey(name: 'thumbnail_link', includeIfNull: false)
      String? thumbnailUrl,
      @JsonKey(name: 'thumbnail_height', includeIfNull: false)
      int? thumbnailHeight,
      @JsonKey(name: 'thumbnail_width', includeIfNull: false)
      int? thumbnailWidth,
      @JsonKey(name: 'bg_color', includeIfNull: false) String? backgroundColor,
      @JsonKey(name: 'original', includeIfNull: false) String? originalUrl,
      @JsonKey(name: 'src_name', includeIfNull: false) String? sourceName,
      @JsonKey(name: 'src_domain', includeIfNull: false) String? sourceDomain,
      @JsonKey(name: 'link', includeIfNull: false) String? sourceLink,
      @JsonKey(name: 'logo', includeIfNull: false) bool? isLogo,
      @JsonKey(name: 'duplicated', includeIfNull: false) bool? isDuplicated,
      @JsonKey(includeIfNull: false) String? theme,
      @JsonKey(name: 'media_type') MediaType mediaType,
      @JsonKey(includeIfNull: false) String? channel,
      @JsonKey(includeIfNull: false) String? duration,
      @JsonKey(includeIfNull: false) String? date});
}

/// @nodoc
class __$$ThumbnailImplCopyWithImpl<$Res>
    extends _$ThumbnailCopyWithImpl<$Res, _$ThumbnailImpl>
    implements _$$ThumbnailImplCopyWith<$Res> {
  __$$ThumbnailImplCopyWithImpl(
      _$ThumbnailImpl _value, $Res Function(_$ThumbnailImpl) _then)
      : super(_value, _then);

  /// Create a copy of Thumbnail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sourceUrl = null,
    Object? altText = freezed,
    Object? height = freezed,
    Object? width = freezed,
    Object? thumbnailUrl = freezed,
    Object? thumbnailHeight = freezed,
    Object? thumbnailWidth = freezed,
    Object? backgroundColor = freezed,
    Object? originalUrl = freezed,
    Object? sourceName = freezed,
    Object? sourceDomain = freezed,
    Object? sourceLink = freezed,
    Object? isLogo = freezed,
    Object? isDuplicated = freezed,
    Object? theme = freezed,
    Object? mediaType = null,
    Object? channel = freezed,
    Object? duration = freezed,
    Object? date = freezed,
  }) {
    return _then(_$ThumbnailImpl(
      sourceUrl: null == sourceUrl
          ? _value.sourceUrl
          : sourceUrl // ignore: cast_nullable_to_non_nullable
              as String,
      altText: freezed == altText
          ? _value.altText
          : altText // ignore: cast_nullable_to_non_nullable
              as String?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailHeight: freezed == thumbnailHeight
          ? _value.thumbnailHeight
          : thumbnailHeight // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbnailWidth: freezed == thumbnailWidth
          ? _value.thumbnailWidth
          : thumbnailWidth // ignore: cast_nullable_to_non_nullable
              as int?,
      backgroundColor: freezed == backgroundColor
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as String?,
      originalUrl: freezed == originalUrl
          ? _value.originalUrl
          : originalUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceName: freezed == sourceName
          ? _value.sourceName
          : sourceName // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceDomain: freezed == sourceDomain
          ? _value.sourceDomain
          : sourceDomain // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceLink: freezed == sourceLink
          ? _value.sourceLink
          : sourceLink // ignore: cast_nullable_to_non_nullable
              as String?,
      isLogo: freezed == isLogo
          ? _value.isLogo
          : isLogo // ignore: cast_nullable_to_non_nullable
              as bool?,
      isDuplicated: freezed == isDuplicated
          ? _value.isDuplicated
          : isDuplicated // ignore: cast_nullable_to_non_nullable
              as bool?,
      theme: freezed == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as MediaType,
      channel: freezed == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThumbnailImpl extends _Thumbnail {
  const _$ThumbnailImpl(
      {@JsonKey(name: 'src') required this.sourceUrl,
      @JsonKey(name: 'alt', includeIfNull: false) this.altText,
      @JsonKey(name: 'height', includeIfNull: false) this.height,
      @JsonKey(name: 'width', includeIfNull: false) this.width,
      @JsonKey(name: 'thumbnail_link', includeIfNull: false) this.thumbnailUrl,
      @JsonKey(name: 'thumbnail_height', includeIfNull: false)
      this.thumbnailHeight,
      @JsonKey(name: 'thumbnail_width', includeIfNull: false)
      this.thumbnailWidth,
      @JsonKey(name: 'bg_color', includeIfNull: false) this.backgroundColor,
      @JsonKey(name: 'original', includeIfNull: false) this.originalUrl,
      @JsonKey(name: 'src_name', includeIfNull: false) this.sourceName,
      @JsonKey(name: 'src_domain', includeIfNull: false) this.sourceDomain,
      @JsonKey(name: 'link', includeIfNull: false) this.sourceLink,
      @JsonKey(name: 'logo', includeIfNull: false) this.isLogo,
      @JsonKey(name: 'duplicated', includeIfNull: false) this.isDuplicated,
      @JsonKey(includeIfNull: false) this.theme,
      @JsonKey(name: 'media_type') this.mediaType = MediaType.image,
      @JsonKey(includeIfNull: false) this.channel,
      @JsonKey(includeIfNull: false) this.duration,
      @JsonKey(includeIfNull: false) this.date})
      : super._();

  factory _$ThumbnailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThumbnailImplFromJson(json);

  /// The served URL of the picture thumbnail.
  ///
  @override
  @JsonKey(name: 'src')
  final String sourceUrl;

  /// An alternate text for the image, if the image cannot be displayed.
  ///
  @override
  @JsonKey(name: 'alt', includeIfNull: false)
  final String? altText;

  /// The height of the image.
  ///
  @override
  @JsonKey(name: 'height', includeIfNull: false)
  final int? height;

  /// The width of the image.
  ///
  @override
  @JsonKey(name: 'width', includeIfNull: false)
  final int? width;

  /// The URL of the thumbnail.
  ///
  @override
  @JsonKey(name: 'thumbnail_link', includeIfNull: false)
  final String? thumbnailUrl;

  /// The height of the thumbnail.
  ///
  @override
  @JsonKey(name: 'thumbnail_height', includeIfNull: false)
  final int? thumbnailHeight;

  /// The width of the thumbnail.
  ///
  @override
  @JsonKey(name: 'thumbnail_width', includeIfNull: false)
  final int? thumbnailWidth;

  /// The background color of the image in hex format.
  ///
  @override
  @JsonKey(name: 'bg_color', includeIfNull: false)
  final String? backgroundColor;

  /// The original URL of the image.
  ///
  @override
  @JsonKey(name: 'original', includeIfNull: false)
  final String? originalUrl;

  /// Source name.
  ///
  @override
  @JsonKey(name: 'src_name', includeIfNull: false)
  final String? sourceName;

  /// Source domain.
  ///
  @override
  @JsonKey(name: 'src_domain', includeIfNull: false)
  final String? sourceDomain;

  /// Link to the source this [Thumbnail] was fetched from.
  ///
  @override
  @JsonKey(name: 'link', includeIfNull: false)
  final String? sourceLink;

  /// Whether the image is a logo.
  ///
  @override
  @JsonKey(name: 'logo', includeIfNull: false)
  final bool? isLogo;

  /// Whether the image is duplicated.
  ///
  @override
  @JsonKey(name: 'duplicated', includeIfNull: false)
  final bool? isDuplicated;

  /// The theme associated with the image.
  ///
  @override
  @JsonKey(includeIfNull: false)
  final String? theme;

  /// The type of the media.
  ///
  @override
  @JsonKey(name: 'media_type')
  final MediaType mediaType;

  /// The (YouTube) channel associated with the thumbnail.
  ///
  /// This is only applicable to video thumbnails.
  ///
  @override
  @JsonKey(includeIfNull: false)
  final String? channel;

  /// The duration of the video. This is only applicable to video thumbnails.
  ///
  @override
  @JsonKey(includeIfNull: false)
  final String? duration;

  /// The date the video was published. This is only applicable to video
  /// thumbnails.
  ///
  @override
  @JsonKey(includeIfNull: false)
  final String? date;

  @override
  String toString() {
    return 'Thumbnail(sourceUrl: $sourceUrl, altText: $altText, height: $height, width: $width, thumbnailUrl: $thumbnailUrl, thumbnailHeight: $thumbnailHeight, thumbnailWidth: $thumbnailWidth, backgroundColor: $backgroundColor, originalUrl: $originalUrl, sourceName: $sourceName, sourceDomain: $sourceDomain, sourceLink: $sourceLink, isLogo: $isLogo, isDuplicated: $isDuplicated, theme: $theme, mediaType: $mediaType, channel: $channel, duration: $duration, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThumbnailImpl &&
            (identical(other.sourceUrl, sourceUrl) ||
                other.sourceUrl == sourceUrl) &&
            (identical(other.altText, altText) || other.altText == altText) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.thumbnailHeight, thumbnailHeight) ||
                other.thumbnailHeight == thumbnailHeight) &&
            (identical(other.thumbnailWidth, thumbnailWidth) ||
                other.thumbnailWidth == thumbnailWidth) &&
            (identical(other.backgroundColor, backgroundColor) ||
                other.backgroundColor == backgroundColor) &&
            (identical(other.originalUrl, originalUrl) ||
                other.originalUrl == originalUrl) &&
            (identical(other.sourceName, sourceName) ||
                other.sourceName == sourceName) &&
            (identical(other.sourceDomain, sourceDomain) ||
                other.sourceDomain == sourceDomain) &&
            (identical(other.sourceLink, sourceLink) ||
                other.sourceLink == sourceLink) &&
            (identical(other.isLogo, isLogo) || other.isLogo == isLogo) &&
            (identical(other.isDuplicated, isDuplicated) ||
                other.isDuplicated == isDuplicated) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        sourceUrl,
        altText,
        height,
        width,
        thumbnailUrl,
        thumbnailHeight,
        thumbnailWidth,
        backgroundColor,
        originalUrl,
        sourceName,
        sourceDomain,
        sourceLink,
        isLogo,
        isDuplicated,
        theme,
        mediaType,
        channel,
        duration,
        date
      ]);

  /// Create a copy of Thumbnail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ThumbnailImplCopyWith<_$ThumbnailImpl> get copyWith =>
      __$$ThumbnailImplCopyWithImpl<_$ThumbnailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThumbnailImplToJson(
      this,
    );
  }
}

abstract class _Thumbnail extends Thumbnail {
  const factory _Thumbnail(
      {@JsonKey(name: 'src') required final String sourceUrl,
      @JsonKey(name: 'alt', includeIfNull: false) final String? altText,
      @JsonKey(name: 'height', includeIfNull: false) final int? height,
      @JsonKey(name: 'width', includeIfNull: false) final int? width,
      @JsonKey(name: 'thumbnail_link', includeIfNull: false)
      final String? thumbnailUrl,
      @JsonKey(name: 'thumbnail_height', includeIfNull: false)
      final int? thumbnailHeight,
      @JsonKey(name: 'thumbnail_width', includeIfNull: false)
      final int? thumbnailWidth,
      @JsonKey(name: 'bg_color', includeIfNull: false)
      final String? backgroundColor,
      @JsonKey(name: 'original', includeIfNull: false)
      final String? originalUrl,
      @JsonKey(name: 'src_name', includeIfNull: false) final String? sourceName,
      @JsonKey(name: 'src_domain', includeIfNull: false)
      final String? sourceDomain,
      @JsonKey(name: 'link', includeIfNull: false) final String? sourceLink,
      @JsonKey(name: 'logo', includeIfNull: false) final bool? isLogo,
      @JsonKey(name: 'duplicated', includeIfNull: false)
      final bool? isDuplicated,
      @JsonKey(includeIfNull: false) final String? theme,
      @JsonKey(name: 'media_type') final MediaType mediaType,
      @JsonKey(includeIfNull: false) final String? channel,
      @JsonKey(includeIfNull: false) final String? duration,
      @JsonKey(includeIfNull: false) final String? date}) = _$ThumbnailImpl;
  const _Thumbnail._() : super._();

  factory _Thumbnail.fromJson(Map<String, dynamic> json) =
      _$ThumbnailImpl.fromJson;

  /// The served URL of the picture thumbnail.
  ///
  @override
  @JsonKey(name: 'src')
  String get sourceUrl;

  /// An alternate text for the image, if the image cannot be displayed.
  ///
  @override
  @JsonKey(name: 'alt', includeIfNull: false)
  String? get altText;

  /// The height of the image.
  ///
  @override
  @JsonKey(name: 'height', includeIfNull: false)
  int? get height;

  /// The width of the image.
  ///
  @override
  @JsonKey(name: 'width', includeIfNull: false)
  int? get width;

  /// The URL of the thumbnail.
  ///
  @override
  @JsonKey(name: 'thumbnail_link', includeIfNull: false)
  String? get thumbnailUrl;

  /// The height of the thumbnail.
  ///
  @override
  @JsonKey(name: 'thumbnail_height', includeIfNull: false)
  int? get thumbnailHeight;

  /// The width of the thumbnail.
  ///
  @override
  @JsonKey(name: 'thumbnail_width', includeIfNull: false)
  int? get thumbnailWidth;

  /// The background color of the image in hex format.
  ///
  @override
  @JsonKey(name: 'bg_color', includeIfNull: false)
  String? get backgroundColor;

  /// The original URL of the image.
  ///
  @override
  @JsonKey(name: 'original', includeIfNull: false)
  String? get originalUrl;

  /// Source name.
  ///
  @override
  @JsonKey(name: 'src_name', includeIfNull: false)
  String? get sourceName;

  /// Source domain.
  ///
  @override
  @JsonKey(name: 'src_domain', includeIfNull: false)
  String? get sourceDomain;

  /// Link to the source this [Thumbnail] was fetched from.
  ///
  @override
  @JsonKey(name: 'link', includeIfNull: false)
  String? get sourceLink;

  /// Whether the image is a logo.
  ///
  @override
  @JsonKey(name: 'logo', includeIfNull: false)
  bool? get isLogo;

  /// Whether the image is duplicated.
  ///
  @override
  @JsonKey(name: 'duplicated', includeIfNull: false)
  bool? get isDuplicated;

  /// The theme associated with the image.
  ///
  @override
  @JsonKey(includeIfNull: false)
  String? get theme;

  /// The type of the media.
  ///
  @override
  @JsonKey(name: 'media_type')
  MediaType get mediaType;

  /// The (YouTube) channel associated with the thumbnail.
  ///
  /// This is only applicable to video thumbnails.
  ///
  @override
  @JsonKey(includeIfNull: false)
  String? get channel;

  /// The duration of the video. This is only applicable to video thumbnails.
  ///
  @override
  @JsonKey(includeIfNull: false)
  String? get duration;

  /// The date the video was published. This is only applicable to video
  /// thumbnails.
  ///
  @override
  @JsonKey(includeIfNull: false)
  String? get date;

  /// Create a copy of Thumbnail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ThumbnailImplCopyWith<_$ThumbnailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
