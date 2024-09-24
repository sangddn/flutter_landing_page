import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../components.dart';

class ExpansionChevron extends StatelessWidget {
  const ExpansionChevron({
    this.showLabel = 'Show',
    this.hideLabel,
    required this.isExpanded,
    super.key,
  });

  final String? showLabel;
  final String? hideLabel;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TranslationSwitcher.top(
          layoutBuilder: alignedLayoutBuilder(AlignmentDirectional.centerEnd),
          child: !isExpanded
              ? showLabel != null
                  ? Text(
                      key: const ValueKey('show'),
                      showLabel!,
                      style: TextStyle(
                        color: PColors.textGray.resolveFrom(context),
                        decoration: TextDecoration.underline,
                        decorationColor: PColors.darkGray.resolveFrom(context),
                      ),
                    ).padEnd(4.0)
                  : const SizedBox(key: ValueKey('show'))
              : hideLabel != null
                  ? Text(
                      key: const ValueKey('hide'),
                      hideLabel!,
                      style: TextStyle(
                        color: PColors.textGray.resolveFrom(context),
                        decoration: TextDecoration.underline,
                        decorationColor: PColors.darkGray.resolveFrom(context),
                      ),
                    ).padEnd(4.0)
                  : const SizedBox(key: ValueKey('hide')),
        ).withHeight(24.0),
        AnimatedRotation(
          duration: PEffects.shortDuration,
          curve: Curves.ease,
          turns: !isExpanded ? (context.ltr ? -0.25 : 0.25) : 0.0,
          child: Icon(
            CupertinoIcons.chevron_down,
            size: 16.0,
            color: PColors.textGray.resolveFrom(context),
          ),
        ),
      ],
    );
  }
}
