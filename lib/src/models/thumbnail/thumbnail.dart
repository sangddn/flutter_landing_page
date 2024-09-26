// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

enum MediaType {
  image,
  video,
  ;

  bool get isImage => this == MediaType.image;
  bool get isVideo => this == MediaType.video;
}

/// Represents a picture thumbnail.
///
@immutable
class Thumbnail {
  final String sourceUrl;
  final String? thumbnailUrl;
  final int? height;
  final int? width;
  final int? thumbnailHeight;
  final int? thumbnailWidth;
  final MediaType mediaType;
  final String? title;
  final String? description;

  const Thumbnail({
    required this.sourceUrl,
    this.thumbnailUrl,
    this.height,
    this.width,
    this.thumbnailHeight,
    this.thumbnailWidth,
    required this.mediaType,
    this.title,
    this.description,
  });

  Thumbnail copyWith({
    String? sourceUrl,
    String? thumbnailUrl,
    int? height,
    int? width,
    int? thumbnailHeight,
    int? thumbnailWidth,
    MediaType? mediaType,
    String? title,
    String? description,
  }) {
    return Thumbnail(
      sourceUrl: sourceUrl ?? this.sourceUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      height: height ?? this.height,
      width: width ?? this.width,
      thumbnailHeight: thumbnailHeight ?? this.thumbnailHeight,
      thumbnailWidth: thumbnailWidth ?? this.thumbnailWidth,
      mediaType: mediaType ?? this.mediaType,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sourceUrl': sourceUrl,
      'thumbnailUrl': thumbnailUrl,
      'height': height,
      'width': width,
      'thumbnailHeight': thumbnailHeight,
      'thumbnailWidth': thumbnailWidth,
      'mediaType': mediaType.name,
      'title': title,
      'description': description,
    };
  }

  factory Thumbnail.fromMap(Map<String, dynamic> map) {
    return Thumbnail(
      sourceUrl: map['sourceUrl'] as String,
      thumbnailUrl:
          map['thumbnailUrl'] != null ? map['thumbnailUrl'] as String : null,
      height: map['height'] != null ? map['height'] as int : null,
      width: map['width'] != null ? map['width'] as int : null,
      thumbnailHeight:
          map['thumbnailHeight'] != null ? map['thumbnailHeight'] as int : null,
      thumbnailWidth:
          map['thumbnailWidth'] != null ? map['thumbnailWidth'] as int : null,
      mediaType: MediaType.values.byName(map['mediaType'] as String),
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Thumbnail.fromJson(String source) =>
      Thumbnail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Thumbnail(sourceUrl: $sourceUrl, thumbnailUrl: $thumbnailUrl, height: $height, width: $width, thumbnailHeight: $thumbnailHeight, thumbnailWidth: $thumbnailWidth, mediaType: $mediaType, title: $title, description: $description)';
  }

  @override
  bool operator ==(covariant Thumbnail other) {
    if (identical(this, other)) return true;

    return other.sourceUrl == sourceUrl &&
        other.thumbnailUrl == thumbnailUrl &&
        other.height == height &&
        other.width == width &&
        other.thumbnailHeight == thumbnailHeight &&
        other.thumbnailWidth == thumbnailWidth &&
        other.mediaType == mediaType &&
        other.title == title &&
        other.description == description;
  }

  @override
  int get hashCode {
    return sourceUrl.hashCode ^
        thumbnailUrl.hashCode ^
        height.hashCode ^
        width.hashCode ^
        thumbnailHeight.hashCode ^
        thumbnailWidth.hashCode ^
        mediaType.hashCode ^
        title.hashCode ^
        description.hashCode;
  }
}
