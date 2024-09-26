part of 'media_page_view.dart';

class _MPVVideoWrapper extends StatelessWidget {
  const _MPVVideoWrapper();

  @override
  Widget build(BuildContext context) {
    final thumbnail = context.getThumbnail();
    final theme = Theme.of(context);
    final orange = PColors.orange.resolveFrom(context);
    final callout = Container(
      decoration: ShapeDecoration(
        shape: PDecors.border12,
        color: orange.withOpacity(0.1),
      ),
      margin: k16H12VPadding,
      padding: k16H12VPadding,
      child: Row(
        children: [
          Icon(
            CupertinoIcons.play_circle_fill,
            size: 20.0,
            color: orange,
          ),
          const Gap(12.0),
          Text.rich(
            TextSpan(
              text: 'Video cannot be played. ',
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: CButton(
                    tooltip: 'Go to original video',
                    onTap: () {
                      launchUrlString(thumbnail.sourceUrl);
                    },
                    child: Text(
                      'Original Source',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: PColors.darkGray.resolveFrom(context),
                        decorationThickness: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).expand(),
        ],
      ),
    );
    final thumbnailUrl = thumbnail.thumbnailUrl;
    if (thumbnailUrl == null) {
      return callout;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: RoundedImage.fromUrl(
            thumbnailUrl,
            borderRadius: 0.0,
            fit: BoxFit.contain,
          ),
        ),
        callout,
      ],
    );
  }
}
