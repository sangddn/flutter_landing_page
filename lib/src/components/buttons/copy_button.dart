import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/core.dart';
import '../components.dart';

class CopyButton extends StatelessWidget {
  const CopyButton({
    this.foregroundColor,
    this.backgroundColor,
    this.cornerRadius,
    required this.data,
    this.label = 'Copy',
    this.lowkey = false,
    super.key,
  });

  final Color? foregroundColor;
  final Color? backgroundColor;
  final double? cornerRadius;
  final bool lowkey;
  final String Function() data;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = this.foregroundColor ?? theme.colorScheme.onSurface;

    return FeedbackButton<bool>(
      feedbackBuilder: (_, hide, isSuccess) {
        if (isSuccess == null) {
          return const Icon(HugeIcons.strokeRoundedCopy01);
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSuccess
                  ? CupertinoIcons.check_mark_circled_solid
                  : CupertinoIcons.xmark_circle_fill,
            ),
            const Gap(8.0),
            if (isSuccess)
              const Text('Copied!')
            else
              const Text('Copy failed.'),
          ],
        );
      },
      builder: (_, show) => _buildButton(
        () {
          try {
            Clipboard.setData(
              ClipboardData(
                text: data(),
              ),
            );
            show(true);
          } catch (_) {
            show(false);
          }
        },
        cornerRadius ?? 8.0,
        backgroundColor ?? theme.gray,
        foregroundColor,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              HugeIcons.strokeRoundedCopy01,
              size: 16.0,
              color: foregroundColor,
            ),
            const Gap(8.0),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    VoidCallback onTap,
    double cornerRadius,
    Color backgroundColor,
    Color foregroundColor,
    Widget child,
  ) =>
      lowkey
          ? CButton(
              tooltip: 'Copy',
              padding: k16H8VPadding,
              cornerRadius: cornerRadius,
              color: backgroundColor,
              onTap: onTap,
              child: child,
            )
          : PButton(
              onTap: (_) => onTap(),
              borderRadius: cornerRadius,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              child: child,
            );
}
