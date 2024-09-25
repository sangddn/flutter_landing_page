part of 'home_page.dart';

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
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
    );
  }
}
