part of '../home_page.dart';

class AboutMeSection extends StatelessWidget {
  const AboutMeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Ticket(),
        Gap(32.0),
        _AboutMeText(),
      ],
    );
  }
}

class _AboutMeText extends StatelessWidget {
  const _AboutMeText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      'About me',
      style: theme.textTheme.displayLarge?.apply(letterSpacingDelta: -1.5),
    );
  }
}
