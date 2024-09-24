import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../components.dart';

/// A counter that animates between two numbers, digit-by-digit.
///
/// It is recommended to use a mono-spaced font for the style. If digits
/// have varying widths, a slight [SizeTransition] will be applied as the digits
/// change, which may not desired in some cases such as when the counter is
/// changing frequently.
///
class NumericCounter extends StatefulWidget {
  const NumericCounter({
    this.textScaler,
    this.style,
    this.alignment = PlaceholderAlignment.middle,
    this.leadingSpans = const [],
    this.trailingSpans = const [],
    this.leadingZeros = 0,
    required this.count,
    super.key,
  });

  final TextScaler? textScaler;
  final TextStyle? style;
  final PlaceholderAlignment alignment;
  final int leadingZeros;
  final List<InlineSpan> leadingSpans, trailingSpans;
  final int count;

  @override
  State<NumericCounter> createState() => _NumericCounterState();
}

class _NumericCounterState extends State<NumericCounter> {
  late var _oldDigits = List.filled(_digits.length, ' ', growable: true);
  late var _digits = _getDigits();
  late var _oldCount = widget.count;
  late var _count = widget.count;

  List<String> _getDigits() => [
        ...List.filled(widget.leadingZeros, '0'),
        ...widget.count.toString().split(''),
      ];

  @override
  void didUpdateWidget(covariant NumericCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    _oldCount = oldWidget.count;
    _count = widget.count;
    if (_oldCount != _count) {
      final newDigits = _getDigits();
      if (newDigits.length > _digits.length) {
        final fill = List.filled(newDigits.length - _digits.length, ' ');
        _digits.addAll(fill);
        _oldDigits.addAll(fill);
      } else {
        final removeLength = _digits.length - newDigits.length;
        _digits.removeRange(0, removeLength);
        _oldDigits.removeRange(0, removeLength);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _oldDigits = _digits;
          _digits = newDigits;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textScaler: widget.textScaler,
      TextSpan(
        children: [
          ...widget.leadingSpans,
          WidgetSpan(
            alignment: widget.alignment,
            baseline: TextBaseline.alphabetic,
            child: MediaQuery.withNoTextScaling(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Visibility.maintain(
                    visible: false,
                    child: AnimatedSize(
                      duration: PEffects.shortDuration,
                      curve: Curves.decelerate,
                      child: Text(_digits.join(), style: widget.style),
                    ),
                  ),
                  Align(
                    widthFactor: 0.0,
                    child: Wrap(
                      children: [
                        for (var i = 0; i < _digits.length; i++)
                          TranslationSwitcher.custom(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (var child, final animation) {
                              final oldDigitIsSmaller =
                                  _oldDigits[i] == ' ' || _oldCount < _count;
                              final offset = const Offset(0.0, 0.5) *
                                  (oldDigitIsSmaller ? 1 : -1);
                              final isReversed =
                                  animation.status.isCompletedOrReversed;

                              child = FadeTransition(
                                opacity: animation,
                                child: child,
                              );

                              child = BlurTransition(
                                blur: Tween<double>(
                                  begin: 3.5,
                                  end: 0.0,
                                ).animate(animation),
                                child: child,
                              );

                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: isReversed
                                      ? offset.scale(-1.2, -1.2)
                                      : offset,
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.ease,
                                  ),
                                ),
                                child: child,
                              );
                            },
                            layoutBuilder: alignedLayoutBuilder(
                              i == 0
                                  ? AlignmentDirectional.centerEnd
                                  : i == _digits.length - 1
                                      ? AlignmentDirectional.centerStart
                                      : Alignment.center,
                            ),
                            child: Text(
                              _digits[i],
                              style: widget.style,
                              key: ValueKey(_digits[i]),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...widget.trailingSpans,
        ],
      ),
    );
  }
}

class NumericCounterTest extends StatefulWidget {
  const NumericCounterTest({super.key});

  @override
  State<NumericCounterTest> createState() => NumericCounterTestState();
}

class NumericCounterTestState extends State<NumericCounterTest> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumericCounter(
          count: _counter,
          leadingSpans: const [
            TextSpan(text: 'Count: '),
          ],
          trailingSpans: const [
            TextSpan(text: ' pretty cool huh'),
          ],
        ),
        const Gap(8.0),
        Slider.adaptive(
          value: _counter.toDouble(),
          max: 1000.0,
          onChanged: (newVal) => setState(() {
            _counter = newVal.toInt();
          }),
        ),
      ],
    );
  }
}
