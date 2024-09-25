import 'dart:async';
import 'dart:ui';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../../core/core.dart';
import '../../../models/models.dart';
import '../../../router/router.dart';
import '../../components.dart';

part 'msv_patterns.dart';

part 'msv_cross_axis_flex.dart';
part 'msv_media_wrapper.dart';
part 'msv_image_wrapper.dart';
part 'msv_video_wrapper.dart';

typedef _OnCarouselIndexChanged = void Function(int index, Thumbnail thumbnail);
typedef _AbsoluteIndexGetter = int Function(Thumbnail thumbnail);
typedef HeroTagGetter = Object Function(String sourceUrl);
typedef _ClearActiveThumbnailCallback = void Function();
typedef MSVImageBuilder = Widget Function(
  int absoluteIndex,
  int crossAxisIndex,
  int numChildrenInCrossAxis,
  Thumbnail thumbnail,
  Widget sizedChild,
);

class MediaScrollView extends StatefulWidget {
  const MediaScrollView({
    required this.thumbnails,
    this.maxScrollableChildren,
    this.getImageUrl,
    this.getHeroTag,
    this.axisExtent = 300.0,
    this.pattern = const OneTwoOnePattern(),
    this.padding = EdgeInsets.zero,
    this.cornerRadius = 3.0,
    this.runSpacing = 8.0,
    this.spacing = 8.0,
    this.getElevation,
    this.imageBuilder,
    super.key,
  }) : assert(thumbnails.length > 0);

  final IList<Thumbnail> thumbnails;

  /// The maximum number of children that can be scrolled through in the
  /// scroll view.
  ///
  /// If `null`, all children are scrollable.
  /// If specified, the scroll view will only scroll through the first
  /// [maxScrollableChildren] children. (If the number of children is less than
  /// [maxScrollableChildren], this has no effect.)
  ///
  /// All children are still displayed in [MediaPageView].
  ///
  final int? maxScrollableChildren;

  final double axisExtent;

  /// The corner radius of the photos.
  ///
  /// Defaults to `3.0`.
  ///
  final double cornerRadius;

  /// The spacing between the cross-axis flexes along the main axis.
  ///
  final double spacing;

  /// The spacing between the items along the cross axis.
  ///
  final double runSpacing;

  /// A getter for the image URL for [MediaType.image].
  ///
  /// This does not work for videos.
  ///
  /// Defaults to `Thumbnail.thumbnailUrl` or `Thumbnail.sourceUrl`, in that
  /// order.
  ///
  final ItemPropertyGetter<String>? getImageUrl;

  /// A Hero tag getter. Defaults to `null`, which means no Hero is used.
  ///
  final HeroTagGetter? getHeroTag;

  /// The pattern to use to organize the photos.
  ///
  /// Defaults to [OneTwoOnePattern].
  ///
  /// See [MediaListPattern] for more information.
  ///
  final MediaListPattern pattern;

  /// Padding around the photo scroll.
  ///
  /// Defaults to [EdgeInsets.zero].
  ///
  final EdgeInsets padding;

  /// Elevation getter for the photos.
  ///
  final ItemPropertyGetter<double>? getElevation;

  /// Image builder for the photos. Particularly useful for animations.
  ///
  final MSVImageBuilder? imageBuilder;

  @override
  State<MediaScrollView> createState() => _MediaScrollViewState();
}

class _MediaScrollViewState extends State<MediaScrollView> {
  final _scrollController = ScrollController();
  final _listController = ListController();

  MediaListPattern get _pattern => widget.pattern;

  // Organize photos into 1-2-1-2 pattern
  late var _photoRows = _pattern.organize(widget.thumbnails.unlockView);

  // The thumbnail currently active in the expanded [MediaPageView].
  final _activeThumbnail = ValueNotifier<Thumbnail?>(null);

  int indexOf(Thumbnail thumbnail) => widget.thumbnails.indexOf(thumbnail);

  void _onCarouselIndexChanged(int index, Thumbnail thumbnail) {
    final currentlyNull = _activeThumbnail.value == null;
    _activeThumbnail.value = thumbnail;
    final range = _listController.unobstructedVisibleRange;
    // [unobstructedVisibleRange] is only an estimation of what's visible.
    // We narrow this range down to the middle third to make sure the thumbnail
    // is indeed visible.
    if (range == null ||
        index < range.$1 + (range.$2 / 3).ceil() ||
        index > range.$1 + (range.$2 * 2 / 3).floor()) {
      // If [currentlyNull], ie. user just opened the photo into page view,
      // we add a delay to the scroll to not jump while user is still looking
      // at the scroll view. (We can't add the delay at the pushing of the route
      // since we still want to hide the thumbnail immediately.)
      if (currentlyNull) {
        Future.delayed(PEffects.shortDuration, () {
          if (mounted) {
            _jumpTo(index);
          }
        });
      } else {
        _jumpTo(index);
      }
    }
  }

  void _jumpTo(int index) {
    _listController.jumpToItem(
      index: index,
      scrollController: _scrollController,
      alignment: 0.1,
    );
  }

  void _clearActiveThumbnail() {
    _activeThumbnail.value = null;
  }

  @override
  void didUpdateWidget(covariant MediaScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thumbnails != widget.thumbnails ||
        oldWidget.pattern != widget.pattern ||
        oldWidget.maxScrollableChildren != widget.maxScrollableChildren) {
      _photoRows = _pattern.organize(
        widget.thumbnails
            .take(widget.maxScrollableChildren ?? widget.thumbnails.length)
            .toList(),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _listController.dispose();
    _activeThumbnail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IList<Thumbnail>>.value(value: widget.thumbnails),
        Provider<List<List<Thumbnail>>>.value(value: _photoRows),
        Provider<_OnCarouselIndexChanged>.value(value: _onCarouselIndexChanged),
        Provider<HeroTagGetter?>.value(value: widget.getHeroTag),
        Provider<ItemPropertyGetter<double>?>.value(value: widget.getElevation),
        Provider<MediaListPattern>.value(value: _pattern),
        Provider<_AbsoluteIndexGetter>.value(value: indexOf),
        Provider<double>.value(value: widget.axisExtent),
        ChangeNotifierProvider<ValueNotifier<Thumbnail?>>.value(
          value: _activeThumbnail,
        ),
        Provider<_ClearActiveThumbnailCallback>.value(
          value: _clearActiveThumbnail,
        ),
        Provider<MSVImageBuilder?>.value(value: widget.imageBuilder),
        Provider<ItemPropertyGetter<String>?>.value(value: widget.getImageUrl),
      ],
      child: SizedBox(
        height: widget.axisExtent,
        child: SuperListView.separated(
          controller: _scrollController,
          listController: _listController,
          scrollDirection: _pattern.axis,
          cacheExtent: 100.0,
          itemCount: _photoRows.length,
          separatorBuilder: (context, index) => Gap(widget.spacing),
          clipBehavior: Clip.none,
          padding: widget.padding,
          itemBuilder: (context, index) => _MSVCrossAxisFlex(
            thumbnails: _photoRows[index],
            runSpacing: widget.runSpacing,
            cornerRadius: widget.cornerRadius,
          ),
        ),
      ),
    );
  }
}

extension _BuildContextExtension on BuildContext {
  MediaListPattern get pattern => watch<MediaListPattern>();
  // IList<Thumbnail> get thumbnails => watch<IList<Thumbnail>>();
  // List<List<Thumbnail>> get organizedThumbnails =>
  //     watch<List<List<Thumbnail>>>();
  // T getThumbnails<T>(T Function(IList<Thumbnail>) fn) => select(fn);
  // T getOrganizedThumbnails<T>(T Function(List<List<Thumbnail>>) fn) =>
  //     select(fn);

  double get axisExtent => watch<double>();

  double getElevation(
    int absoluteIndex,
    int crossAxisIndex,
    int numChildrenInCrossAxis,
    Thumbnail thumbnail,
  ) =>
      select((ItemPropertyGetter<double>? getter) {
        if (getter == null) {
          return 0.0;
        }
        return getter(
          absoluteIndex,
          crossAxisIndex,
          numChildrenInCrossAxis,
          thumbnail,
        );
      });

  String getImageUrl(
    int absoluteIndex,
    int crossAxisIndex,
    int numChildrenInCrossAxis,
    Thumbnail thumbnail,
  ) =>
      select(
        (ItemPropertyGetter<String>? getter) =>
            getter?.call(
              absoluteIndex,
              crossAxisIndex,
              numChildrenInCrossAxis,
              thumbnail,
            ) ??
            thumbnail.thumbnailUrl ??
            thumbnail.sourceUrl,
      );

  int getAbsoluteIndex(Thumbnail thumbnail) =>
      select((_AbsoluteIndexGetter getter) => getter(thumbnail));

  bool isActive(Thumbnail thumbnail) =>
      select((ValueNotifier<Thumbnail?> active) => active.value == thumbnail);

  Object? getHeroTag(String sourceUrl) =>
      watch<HeroTagGetter?>()?.call(sourceUrl);
}
