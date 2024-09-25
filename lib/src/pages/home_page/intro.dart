part of 'home_page.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logo =
        theme.resolveBrightness(UiAsset.logoLightSvg, UiAsset.logoDarkSvg);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(-20.0, 0.0),
          child: ScalableImageWidget.fromSISource(
            si: ScalableImageSource.fromSI(
              rootBundle,
              logo.precompiledSvgPath,
            ),
          ).withSize(240.0, 80.0),
        ),
        Text(
          'I build your startup’s MVP faster than you think possible. In most cases, we’ll help you go from idea to a fully functional, ready-to-test product in just a week.',
          style: theme.textTheme.bodyMedium?.apply(fontSizeDelta: 3),
        ),
      ],
    ).withWidth(500.0).center();
  }
}
