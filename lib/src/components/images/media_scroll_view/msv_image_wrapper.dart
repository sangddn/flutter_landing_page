part of 'media_scroll_view.dart';

class _MSVImageWrapper extends StatelessWidget {
  const _MSVImageWrapper();

  @override
  Widget build(BuildContext context) {
    final elevation = context.watchElevation();
    final imageUrl = context.watchImageUrl();
    return RoundedImage.fromUrl(
      imageUrl,
      // resizer: ImageResizer(constraints.maxWidth, constraints.maxHeight),
      borderRadius: context.watchCornerRadius(),
      fit: BoxFit.cover,
      elevation: elevation,
    );
  }
}
