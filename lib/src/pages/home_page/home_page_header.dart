part of 'home_page.dart';

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Mug(),
        const Gap(16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hey, I’m Sang, a design enginner,',
              style: theme.textTheme.headlineSmall,
            ),
            const Gap(6.0),
            Text(
              'helping founders and startups build iconic product experiences.',
              style: theme.textTheme.headlineLarge,
            ),
          ],
        ),
        const Gap(32.0),
        const _Links().center(),
        const Gap(32.0),
        const _Skills(),
      ],
    ).withMaxWidth(500.0).pad16H().center();
  }
}

const _skills = [
  ('mobile app', HugeIcons.strokeRoundedMobileProgramming01),
  ('web app', HugeIcons.strokeRoundedWebProgramming),
  ('user interface', HugeIcons.strokeRoundedWebDesign02),
  ('visual language', HugeIcons.strokeRoundedEye),
  ('animation', HugeIcons.strokeRoundedMouseRightClick01),
  ('backend', HugeIcons.strokeRoundedDatabase01),
];

const _pastelColors = [
  Color(0xffD7EEFF),
  Color(0xffF2FD9B),
  Color(0xffC5FBC9),
  Color(0xffEDDBFF),
  Color(0xffFEE59A),
  PColors.selectiveYellow800,
];

final _boldColors = [
  const Color(0xff599FEE),
  const Color(0xff86B51C),
  const Color(0xff27B083),
  const Color(0xffB663E6),
  const Color(0xffF48C2B),
  PColors.atomicTangerine.shade10,
];

class _Skills extends StatelessWidget {
  const _Skills();

  @override
  Widget build(BuildContext context) {
    final skills = _skills
        .indexedMap(
          (index, skill) => _Skill(
            skill: skill.$1,
            icon: skill.$2,
            color: _pastelColors[index],
            foregroundColor: _boldColors[index],
          )
              // .square(100.0)
              .animate()
              .scaleXY(
                delay: 75.ms * index,
                duration: 400.ms,
                curve: Sprung(25),
                begin: 0.1,
                end: 1.0,
              )
              .rotate(
                delay: 100.ms * index,
                duration: 550.ms,
                curve: Curves.easeOutBack,
                begin: -0.01 * index,
                end: 0.01 * (index / 2.5 + 1.0) * (index.isOdd ? -1 : 1),
              ),
          // .custom(
          //   delay: 115.ms * index,
          //   duration: 450.ms,
          //   curve: Curves.ease,
          //   builder: (context, value, child) => Align(
          //     widthFactor: alignTween.transform(value),
          //     child: child,
          //   ),
          // ),
        )
        .toList();

    return Wrap(
      children: skills,
    );
  }
}

class _Skill extends StatelessWidget {
  const _Skill({
    required this.skill,
    required this.icon,
    required this.color,
    required this.foregroundColor,
  });

  final String skill;
  final IconData icon;
  final Color color;
  final Color foregroundColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HoverTapBuilder(
      builder: (context, isHovered) => EnlargeOnHover(
        child: Transform.scale(
          scale: 1 / 1.1,
          child: Container(
            decoration: ShapeDecoration(
              shape: PDecors.border16,
              gradient: LinearGradient(
                colors: [
                  color.tint30,
                  color.tint20,
                  color.tint10,
                  color,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              shadows: [
                ...PDecors.focusedShadows(elevation: .5),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  spreadRadius: 2.0,
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ),
            width: 200.0,
            height: 80.0,
            padding: k16APadding,
            child: Stack(
              children: [
                Icon(
                  icon,
                  size: 28.0,
                  color: foregroundColor,
                ).alignTopEnd(),
                Text(
                  skill,
                  style: theme.textTheme.bodyLarge?.modifyWeight(2).apply(
                        color: foregroundColor,
                        fontSizeFactor: 1.75,
                        heightFactor: 0.6,
                      ),
                  overflow: TextOverflow.visible,
                ).alignBottomStart(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _links = [
  ('GitHub', HugeIcons.strokeRoundedGithub, 'https://github.com/sangddn'),
  ('Twitter', HugeIcons.strokeRoundedNewTwitter, 'https://x.com/sangddn'),
  (
    'LinkedIn',
    HugeIcons.strokeRoundedLinkedin01,
    'https://www.linkedin.com/in/sangtrdoan/'
  ),
  ('Email', HugeIcons.strokeRoundedMail02, 'mailto:hello@sangdoan.com'),
];

class _Links extends StatelessWidget {
  const _Links();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 6.0,
      spacing: 8.0,
      children: _links
          .map((link) => _Link(icon: link.$2, text: link.$1, link: link.$3))
          .toList(),
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({
    required this.icon,
    required this.text,
    required this.link,
  });

  final IconData icon;
  final String text;
  final String link;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HoverTapBuilder(
      cornerRadius: 12.0,
      mouseCursor: SystemMouseCursors.click,
      builder: (context, isHovered) => CButton(
        tooltip: link,
        onTap: () {
          launchUrlString(link);
        },
        padding: k16H12VPadding,
        cornerRadius: 12.0,
        color: PColors.gray.resolveFrom(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.0, color: theme.colorScheme.onSurface),
            const Gap(8.0),
            Text(text, style: theme.textTheme.labelMedium),
          ],
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
        border: Border.all(color: Colors.white, width: 3.0),
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
        radius: 20.0,
      ),
    );
  }
}
