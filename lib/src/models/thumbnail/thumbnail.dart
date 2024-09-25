import 'package:freezed_annotation/freezed_annotation.dart';

part 'thumbnail.freezed.dart';
part 'thumbnail.g.dart';

enum MediaType {
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
  ;

  bool get isImage => this == MediaType.image;
  bool get isVideo => this == MediaType.video;
}

/// Represents a picture thumbnail.
///
@freezed
class Thumbnail with _$Thumbnail {
  const factory Thumbnail({
    /// The served URL of the picture thumbnail.
    ///
    @JsonKey(name: 'src') required String sourceUrl,

    /// An alternate text for the image, if the image cannot be displayed.
    ///
    @JsonKey(name: 'alt', includeIfNull: false) String? altText,

    /// The height of the image.
    ///
    @JsonKey(name: 'height', includeIfNull: false) int? height,

    /// The width of the image.
    ///
    @JsonKey(name: 'width', includeIfNull: false) int? width,

    /// The URL of the thumbnail.
    ///
    @JsonKey(name: 'thumbnail_link', includeIfNull: false) String? thumbnailUrl,

    /// The height of the thumbnail.
    ///
    @JsonKey(name: 'thumbnail_height', includeIfNull: false) int? thumbnailHeight,

    /// The width of the thumbnail.
    ///
    @JsonKey(name: 'thumbnail_width', includeIfNull: false) int? thumbnailWidth,

    /// The background color of the image in hex format.
    ///
    @JsonKey(name: 'bg_color', includeIfNull: false) String? backgroundColor,

    /// The original URL of the image.
    ///
    @JsonKey(name: 'original', includeIfNull: false) String? originalUrl,

    /// Source name.
    ///
    @JsonKey(name: 'src_name', includeIfNull: false) String? sourceName,

    /// Source domain.
    ///
    @JsonKey(name: 'src_domain', includeIfNull: false) String? sourceDomain,

    /// Link to the source this [Thumbnail] was fetched from.
    ///
    @JsonKey(name: 'link', includeIfNull: false) String? sourceLink,

    /// Whether the image is a logo.
    ///
    @JsonKey(name: 'logo', includeIfNull: false) bool? isLogo,

    /// Whether the image is duplicated.
    ///
    @JsonKey(name: 'duplicated', includeIfNull: false) bool? isDuplicated,

    /// The theme associated with the image.
    ///
    @JsonKey(includeIfNull: false) String? theme,

    /// The type of the media.
    ///
    @JsonKey(name: 'media_type') @Default(MediaType.image) MediaType mediaType,

    /// The (YouTube) channel associated with the thumbnail.
    ///
    /// This is only applicable to video thumbnails.
    ///
    @JsonKey(includeIfNull: false) String? channel,

    /// The duration of the video. This is only applicable to video thumbnails.
    ///
    @JsonKey(includeIfNull: false) String? duration,

    /// The date the video was published. This is only applicable to video
    /// thumbnails.
    ///
    @JsonKey(includeIfNull: false) String? date,
  }) = _Thumbnail;

  const Thumbnail._();

  factory Thumbnail.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailFromJson(json);
}
