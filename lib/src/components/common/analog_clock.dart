// ignore_for_file: prefer_single_quotes
// Adapted from: https://github.com/furkantektas/analog_clock/blob/master/lib/analog_clock_painter.dart
// with some modifications

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../core/core.dart';

class AnalogClock extends StatefulWidget {
  const AnalogClock({
    this.datetime,
    this.showDigitalClock = true,
    this.showTicks = true,
    this.showNumbers = true,
    this.showSecondHand = true,
    this.showAllNumbers = false,
    this.useMilitaryTime = true,
    this.hourHandColor = Colors.black,
    this.minuteHandColor = Colors.black,
    this.secondHandColor = Colors.redAccent,
    this.tickColor = Colors.grey,
    this.digitalClockColor = Colors.black,
    this.numberColor = Colors.black,
    this.textScaleFactor = 1.0,
    this.isLive,
    this.strokeWidth = 3.0,
    this.handPinHoleSize = 8.0,
    super.key,
  });

  const AnalogClock.dark({
    this.datetime,
    this.showDigitalClock = true,
    this.showTicks = true,
    this.showNumbers = true,
    this.showAllNumbers = false,
    this.showSecondHand = true,
    this.useMilitaryTime = true,
    this.isLive,
    this.textScaleFactor = 1.0,
    this.strokeWidth = 3.0,
    this.handPinHoleSize = 8.0,
    super.key,
  })  : hourHandColor = Colors.white,
        minuteHandColor = Colors.white,
        secondHandColor = Colors.redAccent,
        tickColor = Colors.grey,
        digitalClockColor = Colors.white,
        numberColor = Colors.white;

  final DateTime? datetime;
  final bool showDigitalClock;
  final bool showTicks;
  final bool showNumbers;
  final bool showAllNumbers;
  final bool showSecondHand;
  final bool useMilitaryTime;
  final Color hourHandColor;
  final Color minuteHandColor;
  final Color secondHandColor;
  final Color tickColor;
  final Color digitalClockColor;
  final Color numberColor;
  final bool? isLive;
  final double textScaleFactor;
  final double strokeWidth;
  final double handPinHoleSize;

  @override
  State<AnalogClock> createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  late final _initialDatetime = _datetime;
  late var _datetime = widget.datetime ?? DateTime.now();
  Duration updateDuration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    // repaint the clock every second if second-hand or digital-clock are shown
    updateDuration = widget.showSecondHand || widget.showDigitalClock
        ? const Duration(seconds: 1)
        : const Duration(minutes: 1);

    if (widget.isLive ?? (widget.datetime == null)) {
      // update clock every second or minute based on second hand's visibility.
      Timer.periodic(updateDuration, update);
    }
  }

  void update(Timer timer) {
    // update is only called on live clocks. So, it's safe to update dateTime.
    _datetime = _initialDatetime.add(updateDuration * timer.tick);
    maybeSetState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
          width: double.infinity,
          child: CustomPaint(
            painter: AnalogClockPainter(
              dateTime: _datetime,
              showDigitalClock: widget.showDigitalClock,
              showTicks: widget.showTicks,
              showNumbers: widget.showNumbers,
              showAllNumbers: widget.showAllNumbers,
              showSecondHand: widget.showSecondHand,
              useMilitaryTime: widget.useMilitaryTime,
              hourHandColor: widget.hourHandColor,
              minuteHandColor: widget.minuteHandColor,
              secondHandColor: widget.secondHandColor,
              tickColor: widget.tickColor,
              digitalClockColor: widget.digitalClockColor,
              textScaleFactor: widget.textScaleFactor,
              numberColor: widget.numberColor,
              strokeWidth: widget.strokeWidth,
              handPinHoleSize: widget.handPinHoleSize,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!(widget.isLive ?? widget.datetime == null) &&
        widget.datetime != oldWidget.datetime) {
      _datetime = widget.datetime ?? DateTime.now();
    }
  }
}

class AnalogClockPainter extends CustomPainter {
  AnalogClockPainter({
    required this.dateTime,
    this.showDigitalClock = true,
    this.showTicks = true,
    this.showNumbers = true,
    this.showSecondHand = true,
    this.hourHandColor = Colors.black,
    this.minuteHandColor = Colors.black,
    this.secondHandColor = Colors.redAccent,
    this.tickColor = Colors.grey,
    this.digitalClockColor = Colors.black,
    this.numberColor = Colors.black,
    this.showAllNumbers = false,
    this.textScaleFactor = 1.0,
    this.useMilitaryTime = true,
    this.strokeWidth = 3.0,
    this.handPinHoleSize = 8.0,
  });

  DateTime dateTime;
  final bool showDigitalClock;
  final bool showTicks;
  final bool showNumbers;
  final bool showAllNumbers;
  final bool showSecondHand;
  final bool useMilitaryTime;
  final Color hourHandColor;
  final Color minuteHandColor;
  final Color secondHandColor;
  final Color tickColor;
  final Color digitalClockColor;
  final Color numberColor;
  final double textScaleFactor;
  final double strokeWidth;
  final double handPinHoleSize;

  static const double baseSize = 320.0;
  static const double minutesInHour = 60.0;
  static const double secondsInMinute = 60.0;
  static const double hoursInClock = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleFactor = size.shortestSide / baseSize;

    if (showTicks) {
      _paintTickMarks(canvas, size, scaleFactor);
    }
    if (showNumbers) {
      _drawIndicators(canvas, size, scaleFactor, showAllNumbers);
    }

    if (showDigitalClock) {
      _paintDigitalClock(canvas, size, scaleFactor, useMilitaryTime);
    }

    _paintClockHands(canvas, size, scaleFactor);
    _paintPinHole(canvas, size, scaleFactor);
  }

  @override
  bool shouldRepaint(AnalogClockPainter oldDelegate) {
    return oldDelegate.dateTime.isBefore(dateTime);
  }

  void _paintPinHole(Canvas canvas, Size size, double scaleFactor) {
    final Paint midPointStrokePainter = Paint()
      ..color = showSecondHand ? secondHandColor : minuteHandColor
      ..strokeWidth = strokeWidth * scaleFactor
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      size.center(Offset.zero),
      handPinHoleSize * scaleFactor,
      midPointStrokePainter,
    );
  }

  void _drawIndicators(
    Canvas canvas,
    Size size,
    double scaleFactor,
    bool showAllNumbers,
  ) {
    final TextStyle style = TextStyle(
      color: numberColor,
      fontSize: 18.0 * scaleFactor * textScaleFactor,
    ).modifyWeight(1);
    double p = 12.0;
    if (showTicks) {
      p += 24.0;
    }

    final double r = size.shortestSide / 2;
    final double longHandLength = r - (p * scaleFactor);

    for (var h = 1; h <= 12; h++) {
      if (!showAllNumbers && h % 3 != 0) {
        continue;
      }
      final double angle = (h * pi / 6) - pi / 2; //+ pi / 2;
      final Offset offset =
          Offset(longHandLength * cos(angle), longHandLength * sin(angle));
      final TextSpan span = TextSpan(style: style, text: h.toString());
      final TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, size.center(offset - tp.size.center(Offset.zero)));
    }
  }

  Offset _getHandOffset(double percentage, double length) {
    final radians = 2 * pi * percentage;
    final angle = -pi / 2.0 + radians;

    return Offset(length * cos(angle), length * sin(angle));
  }

  // ref: https://www.codenameone.com/blog/codename-one-graphics-part-2-drawing-an-analog-clock.html
  void _paintTickMarks(Canvas canvas, Size size, double scaleFactor) {
    final double r = size.shortestSide / 2;
    final tick = 5 * scaleFactor,
        mediumTick = 2.0 * tick,
        longTick = 3.0 * tick;
    final double p = longTick + 4 * scaleFactor;
    final Paint tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 2.0 * scaleFactor;

    for (int i = 1; i <= 60; i++) {
      // default tick length is short
      double len = tick;
      if (i % 15 == 0) {
        // Longest tick on quarters (every 15 ticks)
        len = longTick;
      } else if (i % 5 == 0) {
        // Medium ticks on the '5's (every 5 ticks)
        len = mediumTick;
      }
      // Get the angle from 12 O'Clock to this tick (radians)
      final double angleFrom12 = i / 60.0 * 2.0 * pi;

      // Get the angle from 3 O'Clock to this tick
      // Note: 3 O'Clock corresponds with zero angle in unit circle
      // Makes it easier to do the math.
      final double angleFrom3 = pi / 2.0 - angleFrom12;

      canvas.drawLine(
        size.center(
          Offset(
            cos(angleFrom3) * (r + len - p),
            sin(angleFrom3) * (r + len - p),
          ),
        ),
        size.center(
          Offset(cos(angleFrom3) * (r - p), sin(angleFrom3) * (r - p)),
        ),
        tickPaint,
      );
    }
  }

  void _paintClockHands(Canvas canvas, Size size, double scaleFactor) {
    final double r = size.shortestSide / 2;
    double p = 0.0;
    if (showTicks) {
      p += 28.0;
    }
    if (showNumbers) {
      p += 24.0;
    }
    if (showAllNumbers) {
      p += 24.0;
    }
    final double longHandLength = r - (p * scaleFactor);
    final double shortHandLength = r - (p + 36.0) * scaleFactor;

    final Paint handPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.bevel
      ..strokeWidth = strokeWidth * scaleFactor;
    final double seconds = dateTime.second / secondsInMinute;
    final double minutes = (dateTime.minute + seconds) / minutesInHour;
    final double hour = (dateTime.hour + minutes) / hoursInClock;

    canvas.drawLine(
      size.center(_getHandOffset(hour, handPinHoleSize * scaleFactor)),
      size.center(_getHandOffset(hour, shortHandLength)),
      handPaint..color = hourHandColor,
    );

    canvas.drawLine(
      size.center(_getHandOffset(minutes, handPinHoleSize * scaleFactor)),
      size.center(_getHandOffset(minutes, longHandLength)),
      handPaint..color = minuteHandColor,
    );
    if (showSecondHand) {
      canvas.drawLine(
        size.center(_getHandOffset(seconds, handPinHoleSize * scaleFactor)),
        size.center(_getHandOffset(seconds, longHandLength)),
        handPaint..color = secondHandColor,
      );
    }
  }

  void _paintDigitalClock(
    Canvas canvas,
    Size size,
    double scaleFactor,
    bool useMilitaryTime,
  ) {
    int hourInt = dateTime.hour;
    String meridiem = '';
    if (!useMilitaryTime) {
      if (hourInt > 12) {
        hourInt = hourInt - 12;
        meridiem = ' PM';
      } else {
        meridiem = ' AM';
      }
    }
    final String hour = hourInt.toString().padLeft(2, '0');
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    final String second = dateTime.second.toString().padLeft(2, '0');
    final TextSpan digitalClockSpan = TextSpan(
      style: TextStyle(
        color: digitalClockColor,
        fontSize: 18 * scaleFactor * textScaleFactor,
      ),
      text: "$hour:$minute:$second$meridiem",
    );
    final TextPainter digitalClockTP = TextPainter(
      text: digitalClockSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    digitalClockTP.layout();
    digitalClockTP.paint(
      canvas,
      size.center(
        -digitalClockTP.size.center(Offset(0.0, -size.shortestSide / 6)),
      ),
    );
  }
}
