part of '../home_page.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _Skills(),
        const _SkillsText().readableWidth().pad16H().center(),
      ],
    );
  }
}

class _SkillsText extends StatelessWidget {
  const _SkillsText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      'Build faster than you think possible',
      style: theme.textTheme.displayLarge?.apply(letterSpacingDelta: -1.5),
      textAlign: TextAlign.center,
    );
  }
}
