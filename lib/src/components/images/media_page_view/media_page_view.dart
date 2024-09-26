import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/core.dart';
import '../../../models/models.dart';
import '../../components.dart';

part 'mpv_physics.dart';
part 'mpv_the_actual_page_view.dart';
part 'mpv_background.dart';
part 'mpv_switcher.dart';

part 'mpv_wrapper.dart';
part 'mpv_media_wrapper.dart';
part 'mpv_image_wrapper.dart';
part 'mpv_video_wrapper.dart';
part 'mpv_source_attribution.dart';

typedef IndexedThumbnailCallback = void Function(
  int index,
  Thumbnail thumbnail,
);

class MediaPageView extends StatefulWidget {
  const MediaPageView({
    this.onIndexChanged,
    this.initialIndex = 0,
    required this.getHeroTag,
    required this.thumbnails,
    super.key,
  });

  final IndexedThumbnailCallback? onIndexChanged;
  final HeroTagGetter? getHeroTag;
  final IList<Thumbnail> thumbnails;
  final int initialIndex;

  @override
  State<MediaPageView> createState() => _MediaPageViewState();
}

class _MediaPageViewState extends State<MediaPageView> {
  // Initialize [PageController] with the initial index here, since [ListenableProvider.create]
  // is called with a 1-frame delay, which would cause the Hero animation to stutter.
  late final _controller = PageController(initialPage: widget.initialIndex);
  bool _blockVerticalDrag = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final isSwitchingPages =
          ((_controller.page ?? 0) - (_controller.page?.toInt() ?? 0)) > 0.1 &&
              ((_controller.page ?? 0) - (_controller.page?.toInt() ?? 0)) <
                  0.9;
      if (isSwitchingPages != _blockVerticalDrag) {
        setState(() {
          _blockVerticalDrag = isSwitchingPages;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<int>.value(value: widget.initialIndex),
        ListenableProvider<PageController>.value(value: _controller),
        ChangeNotifierProvider<ValueNotifier<double>>(
          create: (_) => ValueNotifier(1.0),
        ),
        Provider<IList<Thumbnail>>.value(value: widget.thumbnails),
        Provider<HeroTagGetter?>.value(value: widget.getHeroTag),
        Provider<IndexedThumbnailCallback?>.value(value: widget.onIndexChanged),
        Provider<bool>.value(value: _blockVerticalDrag),
      ],
      child: _MPVWrapper(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Builder(
              builder: (context) {
                final opacity = context.watch<ValueNotifier<double>>().value;
                return Positioned.fill(
                  child: ColoredBox(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(opacity),
                  ),
                );
              },
            ),
            // const _MPVBackground(),
            const _MPVTheActualPageView(),
          ],
        ),
      ),
    );
  }
}

extension _MPVData on BuildContext {
  Object? getHeroTagFor(Thumbnail thumbnail) => select((HeroTagGetter? getter) {
        return getter?.call(thumbnail.sourceUrl);
      });
}
