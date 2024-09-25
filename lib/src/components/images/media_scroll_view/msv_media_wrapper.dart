part of 'media_scroll_view.dart';

class _MSVMediaWrapper extends StatelessWidget {
  const _MSVMediaWrapper();

  void _onTap(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    // We need to hold on to this callback before the context is unmounted.
    final clearThumbnailCallback =
        context.read<_ClearActiveThumbnailCallback>();

    // This does 2 things:
    // 1. Hide the thumbnail 1 frame after the transition starts.
    // 2. Set this thumbnail to be the active thumbnail, which causes the
    //    scroll view to jump to this thumbnail (with a delay). -- User doesn't
    //    see this jump, but it is necessary for Hero transition to work when
    //    the user exits the full screen view.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<_OnCarouselIndexChanged>()(
        context.itemData.absoluteIndex,
        context.itemData.thumbnail,
      );
    });

    // Transition duration depends on how far the thumbnail is currently from
    // the center of the screen.
    final currentPosition = context.findRenderObject() as RenderBox?;
    final currentOffset =
        currentPosition?.localToGlobal(Offset.zero) ?? Offset.zero;
    final center = Offset(
      MediaQuery.sizeOf(context).width / 2,
      MediaQuery.sizeOf(context).height / 2,
    );
    final distance = (currentOffset - center).distance;
    final milliseconds = distance / 1.2;
    final duration = Duration(milliseconds: milliseconds.toInt().clamp(250, 600));

    final route = FadePageRoute<void>(
      opaque: false,
      barrierColor: Colors.transparent,
      settings: const RouteSettings(
        name: 'FullScreenImage._FullScreenWidget',
        arguments: {},
      ),
      transitionDuration: duration,
      curve: Curves.easeOutCirc,
      builder: (innerContext) => MediaPageView(
        onIndexChanged: context.read<_OnCarouselIndexChanged>(),
        getHeroTag: context.read<HeroTagGetter?>(),
        thumbnails: context.read<IList<Thumbnail>>(),
        initialIndex: context.itemData.absoluteIndex,
      ),
    );

    Navigator.of(context).push(route).then((_) {
      // Wait out the Hero animation before clearing the active thumbnail
      // and show it again.
      // The duration is the exact same time as the [FadePageRoute.transitionDuration].
      Future.delayed(duration, clearThumbnailCallback);
    });
  }

  @override
  Widget build(BuildContext context) {
    final thumbnail = context.watchThumbnail();
    final elevation = context.watchElevation();
    final imageUrl = context.watchImageUrl();

    final child = switch (thumbnail.mediaType) {
      MediaType.image => const _MSVImageWrapper(),
      MediaType.video => const _MSVVideoWrapper(),
    };

    final heroTag = context.getHeroTag(thumbnail.sourceUrl);

    final heroed = heroTag != null
        ? Hero(
            tag: heroTag,
            flightShuttleBuilder: (
              flightContext,
              animation,
              flightDirection,
              fromHeroContext,
              toHeroContext,
            ) {
              return AnimatedBuilder(
                animation: animation,
                builder: (animationContext, _) {
                  final borderRadius =
                      (1.0 - animation.value) * context.itemData.cornerRadius;
                  return RoundedImage.fromUrl(
                    imageUrl,
                    borderRadius: borderRadius,
                    fit: BoxFit.cover,
                    elevation:
                        lerpDouble(elevation, 0.0, animation.value) ?? 0.0,
                  );
                },
              );
            },
            placeholderBuilder: (_, size, child) => child,
            child: child,
          )
        : child;

    final tappable = BouncingObject(
      onTap: () => _onTap(context),
      child: heroed,
    );

    return Offstage(
      offstage: context.isActive(thumbnail),
      child: tappable,
    );
  }
}
