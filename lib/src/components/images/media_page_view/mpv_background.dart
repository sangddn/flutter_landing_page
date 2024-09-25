part of 'media_page_view.dart';

class _MPVBackground extends StatelessWidget {
  const _MPVBackground();

  @override
  Widget build(BuildContext context) {
    final opacity = context.watch<ValueNotifier<double>>().value;
    if (opacity == 0.0) {
      return const SizedBox();
    }
    return Opacity(
      opacity: opacity / 2,
      child: const _MPVLinearlyInterpolatedBackground(),
    );
  }
}

class _MPVLinearlyInterpolatedBackground extends StatelessWidget {
  const _MPVLinearlyInterpolatedBackground();

  @override
  Widget build(BuildContext context) {
    final initialIndex = context.watch<int>().toDouble();
    final currentIndex = context.select<PageController, double>(
      (controller) => controller.hasClients && controller.page != null
          ? controller.page!
          : initialIndex,
    );
    final prev = currentIndex.floor();
    final next = currentIndex.ceil();
    final child = Stack(
      children: [
        if (prev >= 0)
          Opacity(
            opacity: 1.0 - (currentIndex - prev),
            child: _ImageAtIndex(prev),
          ).positionedFill(),
        if (prev != next)
          Opacity(
            opacity: currentIndex - prev,
            child: _ImageAtIndex(next),
          ).positionedFill(),
      ],
    );
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 128.0,
        sigmaY: 128.0,
      ),
      child: child,
    );
  }
}

class _MPVMesh extends StatelessWidget {
  const _MPVMesh(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    if (!context.isImage(index)) {
      return const SizedBox();
    }
    final url = context.getImageUrlAt(index);
    if (url == null) {
      return const SizedBox();
    }
    return _MeshGradientBackground(url);
  }
}

class _MeshGradientBackground extends StatefulWidget {
  const _MeshGradientBackground(this.imageUrl);

  final String imageUrl;

  @override
  State<_MeshGradientBackground> createState() =>
      __MeshGradientBackgroundState();
}

class __MeshGradientBackgroundState extends State<_MeshGradientBackground> {
  late var _colorsFuture =
      ColorUtils.detectImageColors(CachedNetworkImageProvider(widget.imageUrl));

  @override
  void didUpdateWidget(covariant _MeshGradientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        _colorsFuture = ColorUtils.detectImageColors(
          CachedNetworkImageProvider(widget.imageUrl),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeSwitcher(
      child: FadeFutureBuilder(
        key: ValueKey(widget.imageUrl),
        future: _colorsFuture,
        builder: (context, snapshot) {
          final colors = snapshot.data ?? [];
          debugPrint('Colors: $colors');
          if (colors.length < 4) {
            return const SizedBox();
          }
          return SizedBox.expand(
            child: AnimatedMeshGradient(
              colors: colors.take(4).toList(),
              options: AnimatedMeshGradientOptions(
                grain: 0.4,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ImageAtIndex extends StatelessWidget {
  const _ImageAtIndex(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    final url = context.getImageUrlAt(index);
    if (url == null) {
      return const SizedBox();
    }
    return RoundedImage.fromUrl(
      url,
      fit: BoxFit.cover,
      borderRadius: 0.0,
    );
  }
}

extension _MPVBackgroundContext on BuildContext {
  String? getImageUrlAt(int index) => select<IList<Thumbnail>, String?>(
        (thumbnails) {
          final thumbnail = thumbnails.elementAtOrNull(index);
          return thumbnail?.thumbnailUrl ?? thumbnail?.sourceUrl;
        },
      );
  bool isImage(int index) => select<IList<Thumbnail>, bool>(
        (thumbnails) {
          final thumbnail = thumbnails.elementAtOrNull(index);
          return thumbnail?.mediaType.isImage ?? false;
        },
      );
}
