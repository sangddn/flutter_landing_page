part of 'media_scroll_view.dart';

typedef ItemPropertyGetter<T> = T Function(
    int absoluteIndex,
    int crossAxisIndex,
    int numChildrenInCrossAxis,
    Thumbnail thumbnail,
  );

abstract interface class MediaListPattern {
  Axis get axis;
  List<List<T>> organize<T>(List<T> items);
  double getAspectRatio(
    int absoluteIndex,
    int crossAxisIndex,
    int numChildrenInCrossAxis,
  );
}

abstract class _BasePhotoScrollPatternImpl implements MediaListPattern {
  const _BasePhotoScrollPatternImpl({
    this.axis = Axis.horizontal,
  });

  @override
  final Axis axis;
}

class OneTwoOnePattern extends _BasePhotoScrollPatternImpl {
  const OneTwoOnePattern({
    super.axis = Axis.horizontal,
  });

  @override
  double getAspectRatio(
    int absoluteIndex,
    int crossAxisIndex,
    int numChildrenInCrossAxis,
  ) {
    if (numChildrenInCrossAxis == 2) {
      return 1.0;
    } else {
      return 0.75;
    }
  }

  @override
  List<List<T>> organize<T>(List<T> items) {
    int i = 0;
    final List<List<T>> rows = [];
    while (i < items.length) {
      // If even, add a new row
      if (i % 3 == 0 || i % 3 == 1) {
        rows.add([items[i]]);
      } else {
        rows.last.add(items[i]);
      }
      i++;
    }
    return rows;
  }
}

class StraightPattern extends _BasePhotoScrollPatternImpl {
  const StraightPattern({
    this.aspectRatio = 1.0,
    super.axis = Axis.horizontal,
  });

  final double aspectRatio;

  @override
  List<List<T>> organize<T>(List<T> items) {
    int i = 0;
    final List<List<T>> rows = [];
    while (i < items.length) {
      rows.add([items[i]]);
      i++;
    }
    return rows;
  }

  @override
  double getAspectRatio(
    int absoluteIndex,
    int crossAxisIndex,
    int numChildrenInCrossAxis,
  ) =>
      aspectRatio;
}
