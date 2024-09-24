import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../components.dart';

class PAccordion extends StatelessWidget {
  const PAccordion({
    required this.title,
    this.leading,
    this.trailing,
    this.subtitle,
    this.onExpansionChanged,
    required this.children,
    super.key,
  });

  final Widget title;

  final Widget? leading;
  final Widget? subtitle;
  final Widget? trailing;

  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedTheme(
      data: theme.copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: CButton(
        tooltip: 'Toggle',
        onTap: () {},
        child: Material(
          color: theme.colorScheme.surface,
          shape: PDecors.border16,
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            collapsedShape: PDecors.border16,
            shape: PDecors.border16,
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            childrenPadding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            onExpansionChanged: onExpansionChanged,
            title: title,
            leading: leading,
            subtitle: subtitle,
            trailing: trailing,
            children: children,
          ),
        ),
      ),
    );
  }
}
