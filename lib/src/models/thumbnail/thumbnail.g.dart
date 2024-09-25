// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thumbnail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThumbnailImpl _$$ThumbnailImplFromJson(Map<String, dynamic> json) =>
    _$ThumbnailImpl(
      sourceUrl: json['src'] as String,
      altText: json['alt'] as String?,
      height: (json['height'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      thumbnailUrl: json['thumbnail_link'] as String?,
      thumbnailHeight: (json['thumbnail_height'] as num?)?.toInt(),
      thumbnailWidth: (json['thumbnail_width'] as num?)?.toInt(),
      backgroundColor: json['bg_color'] as String?,
      originalUrl: json['original'] as String?,
      sourceName: json['src_name'] as String?,
      sourceDomain: json['src_domain'] as String?,
      sourceLink: json['link'] as String?,
      isLogo: json['logo'] as bool?,
      isDuplicated: json['duplicated'] as bool?,
      theme: json['theme'] as String?,
      mediaType: $enumDecodeNullable(_$MediaTypeEnumMap, json['media_type']) ??
          MediaType.image,
      channel: json['channel'] as String?,
      duration: json['duration'] as String?,
      date: json['date'] as String?,
    );

Map<String, dynamic> _$$ThumbnailImplToJson(_$ThumbnailImpl instance) {
  final val = <String, dynamic>{
    'src': instance.sourceUrl,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('alt', instance.altText);
  writeNotNull('height', instance.height);
  writeNotNull('width', instance.width);
  writeNotNull('thumbnail_link', instance.thumbnailUrl);
  writeNotNull('thumbnail_height', instance.thumbnailHeight);
  writeNotNull('thumbnail_width', instance.thumbnailWidth);
  writeNotNull('bg_color', instance.backgroundColor);
  writeNotNull('original', instance.originalUrl);
  writeNotNull('src_name', instance.sourceName);
  writeNotNull('src_domain', instance.sourceDomain);
  writeNotNull('link', instance.sourceLink);
  writeNotNull('logo', instance.isLogo);
  writeNotNull('duplicated', instance.isDuplicated);
  writeNotNull('theme', instance.theme);
  val['media_type'] = _$MediaTypeEnumMap[instance.mediaType]!;
  writeNotNull('channel', instance.channel);
  writeNotNull('duration', instance.duration);
  writeNotNull('date', instance.date);
  return val;
}

const _$MediaTypeEnumMap = {
  MediaType.image: 'image',
  MediaType.video: 'video',
};
