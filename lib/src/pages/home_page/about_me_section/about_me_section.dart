part of '../home_page.dart';

class AboutMeSection extends StatelessWidget {
  const AboutMeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Photos(),
        Gap(32.0),
        _AboutMeText(),
        _AboutMeCopy(),
      ],
    );
  }
}

class _AboutMeText extends StatelessWidget {
  const _AboutMeText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        Text(
          'About me',
          style: theme.textTheme.displayLarge?.apply(letterSpacingDelta: -1.5),
        ).padEnd(72.0),
        Transform.rotate(
          angle: 0.4,
          child: Image.asset(
            UiAsset.memoji.path,
            width: 100.0,
            height: 100.0,
          ).padBottom(32.0),
        ),
      ],
    );
  }
}

class _AboutMeCopy extends StatelessWidget {
  const _AboutMeCopy();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Born and raised in Vietnam, I went to college in the United States and have lived in 5 different countries. I have a passion for design, technology, and building products that make an impact.',
          style: theme.textTheme.titleLarge?.modifyWeight(-1.5),
        ),
      ],
    ).readableWidth().center();
  }
}
