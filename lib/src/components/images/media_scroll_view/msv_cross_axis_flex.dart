part of 'media_scroll_view.dart';

class _MSVCrossAxisFlex extends StatelessWidget {
  const _MSVCrossAxisFlex({
    required this.thumbnails,
    required this.runSpacing,
    required this.cornerRadius,
  });

  final List<Thumbnail> thumbnails;
  final double runSpacing;
  final double cornerRadius;

  @override
  Widget build(BuildContext context) {
    final pattern = context.pattern;
    final extent = context.axisExtent;
    final imageBuilder = context.watch<MSVImageBuilder?>();

    return Flex(
      direction:
          pattern.axis == Axis.horizontal ? Axis.vertical : Axis.horizontal,
      mainAxisSize: MainAxisSize.min,
      children: thumbnails.indexedMap(
        (index, thumbnail) {
          final absoluteIndex = context.getAbsoluteIndex(thumbnail);

          final effectiveHeight = (extent / thumbnails.length) -
              (runSpacing / 2 * (thumbnails.length - 1));

          final effectiveWidth = effectiveHeight *
              pattern.getAspectRatio(
                absoluteIndex,
                index,
                thumbnails.length,
              );

          const media = _MSVMediaWrapper();
          final sizedMedia = SizedBox(
            width: effectiveWidth,
            height: effectiveHeight,
            child: Provider.value(
              value: _MSVItemData(
                absoluteIndex: absoluteIndex,
                index: index,
                numChildren: thumbnails.length,
                thumbnail: thumbnail,
                cornerRadius: cornerRadius,
              ),
              child: media,
            ),
          );

          return Padding(
            padding: EdgeInsets.only(
              top: index == 0 ? 0.0 : runSpacing,
            ),
            child: imageBuilder?.call(
                  absoluteIndex,
                  index,
                  thumbnails.length,
                  thumbnail,
                  sizedMedia,
                ) ??
                sizedMedia,
          );
        },
      ).toList(),
    );
  }
}

extension _MSVItemFromContext on BuildContext {
  _MSVItemData get itemData => read<_MSVItemData>();
  _MSVItemData watchData() => watch<_MSVItemData>();
  T selectData<T>(T Function(_MSVItemData data) fn) => select(fn);
  Thumbnail watchThumbnail() => selectData((data) => data.thumbnail);
  double watchElevation() {
    final data = watchData();
    return getElevation(
      data.absoluteIndex,
      data.index,
      data.numChildren,
      data.thumbnail,
    );
  }

  String watchImageUrl() {
    final data = watchData();
    return getImageUrl(
      data.absoluteIndex,
      data.index,
      data.numChildren,
      data.thumbnail,
    );
  }

  double watchCornerRadius() => selectData((data) => data.cornerRadius);
}

@immutable
class _MSVItemData {
  const _MSVItemData({
    required this.absoluteIndex,
    required this.index,
    required this.numChildren,
    required this.thumbnail,
    required this.cornerRadius,
  });

  final int absoluteIndex;
  final int index;
  final int numChildren;
  final Thumbnail thumbnail;
  final double cornerRadius;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is _MSVItemData &&
        other.absoluteIndex == absoluteIndex &&
        other.index == index &&
        other.numChildren == numChildren &&
        other.thumbnail == thumbnail &&
        other.cornerRadius == cornerRadius;
  }

  @override
  int get hashCode =>
      absoluteIndex.hashCode ^
      index.hashCode ^
      numChildren.hashCode ^
      thumbnail.hashCode ^
      cornerRadius.hashCode;
}
