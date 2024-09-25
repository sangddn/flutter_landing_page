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
        const _Intro(),
        const Gap(32.0),
        const _Links().center(),
        const Gap(32.0),
        const _Skills(),
      ],
    ).withMaxWidth(500.0).pad16H().center();
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
