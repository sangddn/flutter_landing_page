import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../components.dart';

class AnimatedTime extends StatelessWidget {
  const AnimatedTime({
    this.style,
    this.prefix = '',
    this.use24Hour,
    required this.timeOfDay,
    this.second,
    super.key,
  });

  final String prefix;
  final TextStyle? style;
  final bool? use24Hour;
  final TimeOfDay timeOfDay;
  final int? second;

  @override
  Widget build(BuildContext context) {
    final style = this.style ??
        Theme.of(context).textTheme.labelLarge?.enableFeature('calt');
    final secondaryStyle = style?.copyWith(
      color: PColors.textGray.resolveFrom(context),
    );
    final use24Hour =
        this.use24Hour ?? MediaQuery.alwaysUse24HourFormatOf(context);
    final hour = use24Hour ? timeOfDay.hour : timeOfDay.hourOfPeriod;
    final amPm = use24Hour
        ? ''
        : timeOfDay.period == DayPeriod.am
            ? 'AM'
            : 'PM';
    final minute = timeOfDay.minute;
    return Text.rich(
      style: style,
      TextSpan(
        children: [
          if (prefix.isNotEmpty) ...[
            TextSpan(text: prefix, style: secondaryStyle),
            const TextSpan(text: ' '),
          ],
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: NumericCounter(
              textScaler: TextScaler.noScaling,
              count: hour,
              style: style,
            ).padBottom(1.0),
          ),
          const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: _Semicolon(),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: NumericCounter(
              textScaler: TextScaler.noScaling,
              count: minute,
              leadingZeros: minute < 10 ? 1 : 0,
              style: style,
            ).padBottom(1.0),
          ),
          if (second case final second?) ...[
            const WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: _Semicolon(),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: NumericCounter(
                textScaler: TextScaler.noScaling,
                count: second,
                style: style,
              ).padBottom(1.0),
            ),
          ],
          if (!use24Hour) ...[
            const TextSpan(text: ' '),
            TextSpan(
              text: amPm,
              style: secondaryStyle,
            ),
          ],
        ],
      ),
    );
  }
}

class _Semicolon extends StatelessWidget {
  const _Semicolon();
  @override
  Widget build(BuildContext context) {
    return Text(
      ':',
      style:
          Theme.of(context).textTheme.labelLarge?.enableFeature('calt').apply(
                color: PColors.textGray.resolveFrom(context),
                fontSizeFactor: 1.0 / 1.0.scaleWithText(context),
              ),
    );
  }
}
