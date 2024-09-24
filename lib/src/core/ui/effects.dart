part of 'ui.dart';

class PEffects {
  static const almostInstant = Duration(milliseconds: 50);
  static const veryShortDuration = Duration(milliseconds: 150);
  static const shortDuration = Duration(milliseconds: 250);
  static const mediumDuration = Duration(milliseconds: 500);
  static const longDuration = Duration(milliseconds: 800);
  static const veryLongDuration = Duration(milliseconds: 1200);

  static const engagingCurve = Cubic(0.4, 0.0, 0.2, 1.0);
  static const playfulCurve = Cubic(0.22, 0.74, 0.38, 1.09);

  static const blur = BlurEffect(
    duration: Duration(milliseconds: 300),
    curve: Easing.emphasizedDecelerate,
    begin: Offset(8.0, 8.0),
    end: Offset.zero,
  );

  static const scaleIn = ScaleEffect(
    duration: Duration(milliseconds: 300),
    curve: Easing.emphasizedDecelerate,
    begin: Offset(1.1, 1.1),
    end: Offset(1.0, 1.0),
  );
}
