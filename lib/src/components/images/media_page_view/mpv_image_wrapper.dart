part of 'media_page_view.dart';

class _MPVImageWrapper extends StatefulWidget {
  const _MPVImageWrapper();

  @override
  State<_MPVImageWrapper> createState() => _MPVImageWrapperState();
}

class _MPVImageWrapperState extends State<_MPVImageWrapper> {
  final _controller = TransformationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thumbnail = context.select((_MPVItemData data) => data.thumbnail);
    final thumbnailUrl = thumbnail.thumbnailUrl;
    final height = thumbnail.height;
    final width = thumbnail.width;
    final aspectRatio = width ?? 0.0 / (height ?? 1.0);
    final effectiveAspectRatio = aspectRatio == 0.0 || aspectRatio == width
        ? null
        : aspectRatio.toDouble();

    final placeholderBuilder = thumbnailUrl != null
        ? (_) => SizedBox(
              width: double.infinity,
              child: RoundedImage.fromUrl(
                thumbnailUrl,
                borderRadius: 0.0,
                aspectRatio: effectiveAspectRatio,
                fit: BoxFit.contain,
              ),
            )
        : null;

    return Stack(
      children: [
        // if (placeholderBuilder != null) placeholderBuilder(context),
        SizedBox(
          width: double.infinity,
          child: RoundedImage.fromUrl(
            thumbnail.sourceUrl,
            placeholderBuilder: placeholderBuilder,
            errorBuilder: placeholderBuilder,
            borderRadius: 0.0,
            aspectRatio: effectiveAspectRatio,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
