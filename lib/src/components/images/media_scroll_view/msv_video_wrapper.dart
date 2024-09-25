part of 'media_scroll_view.dart';

class _MSVVideoWrapper extends StatelessWidget {
  const _MSVVideoWrapper();

  @override
  Widget build(BuildContext context) {
    final thumbnail = context.watchThumbnail();
    return __MSVVideoWrapper(thumbnail);
  }
}

class __MSVVideoWrapper extends StatefulWidget {
  const __MSVVideoWrapper(this.thumbnail);

  final Thumbnail thumbnail;

  @override
  State<__MSVVideoWrapper> createState() => __MSVVideoWrapperState();
}

class __MSVVideoWrapperState extends State<__MSVVideoWrapper> {
  String get _link => widget.thumbnail.sourceUrl;

  @override
  Widget build(BuildContext context) {
    assert(widget.thumbnail.mediaType.isVideo);

    final thumbnail = widget.thumbnail.thumbnailUrl;
    final placeholderBuilder = thumbnail != null
        ? (_) => RoundedImage.fromUrl(
              thumbnail,
              borderRadius: context.itemData.cornerRadius,
              // fit: BoxFit.contain,
            )
        : null;

    return Stack(
      children: [
        if (placeholderBuilder != null) placeholderBuilder(context),
        if (thumbnail != null)
          RoundedImage.fromUrl(
            thumbnail,
            placeholderBuilder: placeholderBuilder,
            borderRadius: context.watchCornerRadius(),
            // fit: BoxFit.cover,
          ).positionedFill(),
        const Align(child: _PlayButton()),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final theme = Theme.of(context);
          final showLabel = constraints.maxWidth > 100.0 &&
              context.selectData((data) => data.absoluteIndex == 0);
          final color = theme.resolveColor(PColors.dark2, Colors.white);
          return Container(
            decoration: ShapeDecoration(
              shape: showLabel
                  ? const SquircleStadiumBorder()
                  : const CircleBorder(),
              shadows: PDecors.elevation(
                2.0,
                isOuter: true,
                increaseIntensity: true,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Container(
                color: theme.neutral.withOpacity(0.6),
                padding: k8APadding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.play_arrow_solid,
                      color: color.withOpacity(0.95),
                      size: 20.0,
                      shadows: PDecors.focusedShadows(),
                    ).padStart(2.0),
                    if (showLabel) ...[
                      const Gap(4.0),
                      Text(
                        'Play',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: color)
                            .modifyWeight(1),
                      ),
                      const Gap(6.0),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      );
}
