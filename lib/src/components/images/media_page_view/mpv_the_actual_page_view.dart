part of 'media_page_view.dart';

class _MPVTheActualPageView extends StatelessWidget {
  const _MPVTheActualPageView();

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: context.pageController(),
      onPageChanged: context.notifyPageChange,
      padEnds: false,
      physics: const _CustomPageViewScrollPhysics(),
      itemCount: context.length(),
      itemBuilder: (context, index) => Builder(
        builder: (context) {
          final thumbnail = context.thumbnail(index);
          return Provider.value(
            value: _MPVItemData(
              index: index,
              heroTag: context.getHeroTagFor(thumbnail),
              shouldBlockVerticalDrag: context.watch(),
              thumbnail: thumbnail,
            ),
            child: const _MPVMediaWrapper(),
          );
        },
      ),
    );
  }
}

extension _MPVContext on BuildContext {
  PageController pageController() => watch<PageController>();
  ValueNotifier<double> opacity() => watch<ValueNotifier<double>>();
  int length() => select((IList<Thumbnail> thumbnails) => thumbnails.length);
  Thumbnail thumbnail(int index) =>
      select((IList<Thumbnail> thumbnails) => thumbnails[index]);
  IList<Thumbnail> allThumbnails() => watch<IList<Thumbnail>>();

  void notifyPageChange(int newPage) => read<IndexedThumbnailCallback?>()?.call(
        newPage,
        read<IList<Thumbnail>>()[newPage],
      );
}

extension _MPVItemContext on BuildContext {
  _MPVItemData get itemData => read<_MPVItemData>();
  _MPVItemData watchData() => watch<_MPVItemData>();
  T getData<T>(T Function(_MPVItemData data) fn) => select(fn);
  Thumbnail getThumbnail() => getData((data) => data.thumbnail);
  Object? getHeroTag() => getData((data) => data.heroTag);
  int getIndex() => getData((data) => data.index);
  bool get shouldBlockVerticalDrag => itemData.shouldBlockVerticalDrag;
  bool getIsImage() => getData((data) => data.thumbnail.mediaType.isImage);
}

@immutable
class _MPVItemData {
  const _MPVItemData({
    required this.index,
    required this.heroTag,
    required this.shouldBlockVerticalDrag,
    required this.thumbnail,
  });

  final int index;
  final Object? heroTag;
  final bool shouldBlockVerticalDrag;
  final Thumbnail thumbnail;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is _MPVItemData &&
        other.index == index &&
        other.heroTag == heroTag &&
        other.shouldBlockVerticalDrag == shouldBlockVerticalDrag &&
        other.thumbnail == thumbnail;
  }

  @override
  int get hashCode =>
      index.hashCode ^
      heroTag.hashCode ^
      shouldBlockVerticalDrag.hashCode ^
      thumbnail.hashCode;
}
