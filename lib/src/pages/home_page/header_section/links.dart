part of '../home_page.dart';

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
