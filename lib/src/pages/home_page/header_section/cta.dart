part of '../home_page.dart';

class _CTA extends StatelessWidget {
  const _CTA();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BouncingObject(
      onTap: () {},
      child: HoverTapBuilder(
        builder: (context, isHovered) => Container(
          decoration: ShapeDecoration(
            shape: PDecors.border12,
            color: isHovered
                ? theme.neutral
                : PColors.lightGray.resolveFrom(context),
            shadows: [
              if (isHovered) ...[
                const BoxShadow(
                  color: Color(0xffD4D4D4),
                  blurRadius: 6.0,
                  spreadRadius: 1.0,
                ),
                const BoxShadow(
                  color: Color(0xffEAEDF0),
                  spreadRadius: 1.0,
                ),
                BoxShadow(
                  color: theme.resolveColor(
                    const Color(0xffF6F6F6),
                    PColors.dark2,
                  ),
                  offset: const Offset(0.0, -2.0),
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ],
          ),
          padding: k12VPadding,
          margin: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(16.0),
              Text(
                'Book a call',
                style: theme.textTheme.titleMedium?.apply(
                  fontSizeDelta: 2,
                ),
              ),
              AnimatedSize(
                duration: PEffects.veryShortDuration,
                curve: PEffects.swiftOut,
                child: SizedBox(width: isHovered ? 12.0 : 8.0),
              ),
              const Icon(CupertinoIcons.chevron_forward, size: 20.0),
              AnimatedSize(
                duration: PEffects.veryShortDuration,
                curve: PEffects.swiftOut,
                child: SizedBox(width: isHovered ? 12.0 : 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
