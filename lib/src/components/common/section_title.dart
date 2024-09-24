import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../components.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(
    this.text, {
    this.explanation,
    super.key,
  });

  final String text;
  final String? explanation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gray = theme.textGray;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text.capitalize(),
          style: theme.textTheme.bodyLarge,
        ),
        if (explanation case final explanation?)
          Flexible(
            child: Text(
              explanation,
              style: theme.textTheme.bodySmall?.copyWith(
                color: gray,
              ),
            ),
          ),
        const Gap(4.0),
      ],
    ).pad8H();
  }
}
