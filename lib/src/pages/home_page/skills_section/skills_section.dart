part of '../home_page.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _Skills(),
        const Column(
          children: [
            _SkillsText(),
            Gap(32.0),
            _SkillsCopy(),
          ],
        ).readableWidth().pad16H().center(),
      ],
    );
  }
}

class _SkillsText extends StatelessWidget {
  const _SkillsText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          theme.resolveColor(PColors.offWhite, PColors.dark.shade20),
          theme.resolveColor(PColors.dark, PColors.offWhite),
        ],
        stops: const [0.0, 0.3],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ).createShader(bounds),
      child: Text(
        'Build faster than you think possible',
        style: theme.textTheme.displayLarge?.apply(letterSpacingDelta: -1.5),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _SkillsCopy extends StatelessWidget {
  const _SkillsCopy({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Build an MVP',
          style: theme.textTheme.titleLarge,
        ),
        const Gap(16.0),
        Text(
          'I have years of experience turning ideas into fully functional web and mobile apps in as little as one week. I can help you prototype, validate and pressure-test at the speed of your ideas. I understand the unique challenges startups face, and I can provide empathetic, agile, and affordable development solutions tailored to your needs.',
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
