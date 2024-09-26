part of '../home_page.dart';

final _screenshotController = ScreenshotController();

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Expansion State
        ChangeNotifierProvider<ValueNotifier<bool>>(
          create: (_) => ValueNotifier(false),
        ),
      ],
      builder: (context, _) => Column(
        children: [
          MouseRegion(
            onEnter: (_) => context.read<ValueNotifier<bool>>().value = true,
            onExit: (_) => context.read<ValueNotifier<bool>>().value = false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SafeArea(child: Gap(48.0)),
                const _MugWithLinks().center(),
                const Gap(8.0),
              ],
            ).withMaxWidth(500.0).pad16H().center(),
          ),
          CButton(
            tooltip: null,
            onTap: () async {
              await _screenshotController.captureAndSave(
                (await getDownloadDirectory()).path,
                fileName: 'screenshot.png',
                pixelRatio: 4.0,
              );
              debugPrint('Captured');
            },
            padding: k16H12VPadding,
            color: Colors.red,
            child: const Text('Capture'),
          ),
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Intro(),
              Gap(8.0),
              _CTA(),
            ],
          ).readableWidth().pad16H().center(),
        ],
      ),
    );
  }
}

extension _HeaderState on BuildContext {
  bool isExpanded() => watch<ValueNotifier<bool>>().value;
}

class _MugWithLinks extends StatelessWidget {
  const _MugWithLinks();

  @override
  Widget build(BuildContext context) {
    final isExpanded = context.isExpanded();

    final links = _links.map((link) => _Link(link)).toList();

    return AnimatedSize(
      duration: PEffects.shortDuration,
      curve: PEffects.swiftOut,
      child: SizedBox(
        width: 400.0,
        height: isExpanded ? 160.0 : 100.0,
        child: Padding(
          padding: isExpanded
              ? const EdgeInsets.only(bottom: 32.0)
              : EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              const _Mug(),
              AnimatedAlign(
                duration: PEffects.shortDuration,
                curve: PEffects.swiftOut,
                alignment: isExpanded
                    ? const AlignmentDirectional(-0.45, -0.8)
                    : const AlignmentDirectional(-0.25, -0.75),
                child: links[0],
              ),
              AnimatedAlign(
                duration: PEffects.shortDuration,
                curve: PEffects.swiftOut,
                alignment: isExpanded
                    ? const AlignmentDirectional(0.55, -0.8)
                    : const AlignmentDirectional(0.25, -0.75),
                child: links[1],
              ),
              AnimatedAlign(
                duration: PEffects.shortDuration,
                curve: PEffects.swiftOut,
                alignment: isExpanded
                    ? const AlignmentDirectional(-0.4, 0.8)
                    : const AlignmentDirectional(-0.25, 0.75),
                child: links[2],
              ),
              AnimatedAlign(
                duration: PEffects.shortDuration,
                curve: PEffects.swiftOut,
                alignment: isExpanded
                    ? const AlignmentDirectional(0.4, 0.8)
                    : const AlignmentDirectional(0.25, 0.75),
                child: links[3],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Mug extends StatelessWidget {
  const _Mug();

  @override
  Widget build(BuildContext context) {
    final imageProvider = UiAsset.me1.toImageProvider();
    return Screenshot(
      controller: _screenshotController,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: [
            ...PDecors.focusedShadows(
              elevation: 0.5,
              baseColor: PColors.selectiveYellow,
            ),
            ...PDecors.focusedShadows(
              baseColor: PColors.steelBlue,
              elevation: 0.25,
            ),
          ],
        ),
        margin: const EdgeInsets.all(16.0),
        child: CircleAvatar(
          foregroundImage: imageProvider,
          radius: 24.0,
        ),
      ),
    );
  }
}

typedef _LinkData = (
  String,
  IconData,
  CupertinoDynamicColor,
  String,
  bool preferBottom
);

const _links = <_LinkData>[
  (
    'GitHub',
    HugeIcons.strokeRoundedGithub,
    CupertinoDynamicColor.withBrightness(
      color: Color(0xff323232),
      darkColor: Color(0xff424242),
    ),
    'https://github.com/sangddn',
    false,
  ),
  (
    'Twitter/X',
    HugeIcons.strokeRoundedNewTwitter,
    CupertinoDynamicColor.withBrightness(
      color: Color(0xff1DA1F2),
      darkColor: Color(0xff1DA1F2),
    ),
    'https://x.com/sangddn',
    false,
  ),
  (
    'Blog',
    HugeIcons.strokeRoundedInternet,
    CupertinoColors.activeGreen,
    'https://sangdoan.net',
    true,
  ),
  (
    'Email',
    HugeIcons.strokeRoundedMail02,
    CupertinoColors.activeOrange,
    'mailto:hello@sangdoan.com',
    true,
  ),
];

class _Link extends StatelessWidget {
  const _Link(this.data);

  final _LinkData data;

  IconData get icon => data.$2;
  String get text => data.$1;
  String get link => data.$4;
  CupertinoDynamicColor get color => data.$3;
  bool get preferBottom => data.$5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExpanded = context.isExpanded();
    final resolvedColor = color.resolveFrom(context);

    return AnimatedContainer(
      duration: PEffects.shortDuration,
      curve: Curves.easeInOut,
      decoration: ShapeDecoration(
        shape: const SquircleStadiumBorder(),
        shadows: isExpanded
            ? PDecors.mediumShadows(
                elevation: 0.5,
                baseColor: color,
              )
            : [],
      ),
      clipBehavior: Clip.antiAlias,
      child: HoverTapBuilder(
        cornerRadius: 0.0,
        mouseCursor: SystemMouseCursors.click,
        builder: (context, isHovered) => CButton(
          cornerRadius: 0.0,
          color: isExpanded ? theme.neutral : Colors.transparent,
          tooltip: link,
          tooltipPreferBottom: preferBottom,
          tooltipWaitDuration: const Duration(milliseconds: 1000),
          onTap: () {
            launchUrlString(link);
          },
          child: AnimatedContainer(
            duration: PEffects.shortDuration,
            curve: PEffects.swiftOut,
            padding: k12HPadding + k8VPadding,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomCenter,
                radius: 1.5,
                colors: [
                  if (isHovered) resolvedColor.tint40 else Colors.transparent,
                  if (isHovered) resolvedColor else Colors.transparent,
                ],
              ),
            ),
            child: AnimatedDefaultTextStyle(
              duration: PEffects.veryShortDuration,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: isHovered ? Colors.white : theme.colorScheme.onSurface,
              ),
              child: Builder(
                builder: (context) {
                  return AnimatedSize(
                    duration: PEffects.veryShortDuration,
                    curve: PEffects.swiftOut,
                    alignment: AlignmentDirectional.centerStart,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: 16.0,
                          color: DefaultTextStyle.of(context).style.color,
                        ),
                        if (isExpanded) ...[
                          const Gap(8.0),
                          Text(text),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
