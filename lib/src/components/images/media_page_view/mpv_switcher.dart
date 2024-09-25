part of 'media_page_view.dart';

class _MPVSwitcher extends StatefulWidget {
  const _MPVSwitcher();

  @override
  State<_MPVSwitcher> createState() => _MPVSwitcherState();
}

class _MPVSwitcherState extends State<_MPVSwitcher> {
  @override
  Widget build(BuildContext context) {
    final thumbnails = context.allThumbnails();
    return ChangeNotifierProxyProvider<PageController, ValueNotifier<int>>(
      create: (context) => ValueNotifier(context.read<int>()),
      update: (_, value, previous) {
        try {
          previous?.value = value.page?.round() ?? 0;
        } catch (e) {
          //ignore
        }
        return previous!;
      },
      builder: (context, _) => CarouselSwitcher(
        initialIndex: context.watch<int>(),
        indexListenable: context.watch<ValueNotifier<int>>(),
        onPageChanged: (index) {
          if (index != context.read<ValueNotifier<int>>().value) {
            context.read<PageController>().jumpToPage(index);
          }
        },
        style: const CarouselSwitcherStyle(
          height: 40.0,
          minItemWidth: 30.0,
          spacing: 1.0,
        ),
        children: thumbnails.mapToList((index, thumbnail) {
          return Builder(
            builder: (context) {
              final isCurrent = context.select(
                (ValueNotifier<int> notifier) => notifier.value == index,
              );
              // Preload the next image at full size.
              final isUpNext = context.select(
                (ValueNotifier<int> notifier) => notifier.value == index + 1,
              );
              return AnimatedPadding(
                duration: PEffects.shortDuration,
                curve: PEffects.engagingCurve,
                padding: isCurrent ? k8HPadding : EdgeInsets.zero,
                child: RoundedImage.fromUrl(
                  isUpNext && thumbnail.mediaType.isImage
                      ? thumbnail.sourceUrl
                      : (thumbnail.thumbnailUrl ?? thumbnail.sourceUrl),
                  borderRadius: 4.0,
                  borderSide: isCurrent
                      ? const BorderSide(color: Colors.white, width: 1.5)
                      : BorderSide.none,
                  resizer: isUpNext ? null : const ImageResizer(80.0, 40.0),
                ),
              );
            },
          );
        }),
      ).padBottom(8.0),
    );
  }
}
