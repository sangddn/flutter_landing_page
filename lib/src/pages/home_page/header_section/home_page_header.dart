part of '../home_page.dart';

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
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          ...PDecors.focusedShadows(
            baseColor: PColors.selectiveYellow,
            elevation: 1.25,
          ),
          ...PDecors.focusedShadows(
            baseColor: PColors.steelBlue,
            elevation: 0.75,
          ),
        ],
      ),
      child: CircleAvatar(
        foregroundImage: imageProvider,
        radius: 24.0,
      ),
    );
  }
}
