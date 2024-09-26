part of '../home_page.dart';

const _skills = [
  ('mobile app', HugeIcons.strokeRoundedMobileProgramming01),
  ('web app', HugeIcons.strokeRoundedWebProgramming),
  ('user interface', HugeIcons.strokeRoundedWebDesign02),
  ('visual language', HugeIcons.strokeRoundedEye),
  ('interactions', HugeIcons.strokeRoundedMouseRightClick01),
  ('backend', HugeIcons.strokeRoundedDatabase01),
];

const _pastelColors = [
  Color(0xffD7EEFF),
  Color(0xffF2FD9B),
  Color(0xffC5FBC9),
  Color(0xffEDDBFF),
  Color(0xffFEE59A),
  PColors.selectiveYellow800,
];

final _boldColors = [
  const Color(0xff599FEE),
  const Color(0xff86B51C),
  const Color(0xff27B083),
  const Color(0xffB663E6),
  const Color(0xffF48C2B),
  PColors.atomicTangerine.shade10,
];

final alignTween = Tween<double>(begin: 0.0, end: 0.8);

class _Skills extends StatelessWidget {
  const _Skills();

  double _getEndAngle(int index, double endAdjustmentValue) {
    return 0.02 * (index / 2.5 + 1.0) * (index.isOdd ? -1 : 1) +
        (index == 0
            ? endAdjustmentValue / 2
            : index == _skills.length - 1
                ? -endAdjustmentValue / 2.5
                : 0.0);
  }

  double _getAlignment(int index, double endAdjustmentValue, double animValue) {
    return alignTween.transform(animValue) *
        (index == 0
            ? 1.0 - endAdjustmentValue
            : index == _skills.length - 1
                ? 1.0 - endAdjustmentValue
                : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    // If screen width is too small, we add rotation to the firrst
    // and the last widgets
    final endAdjustmentValue =
        ((800.0 - screenWidth) / 300.0).clamp(0.0, 1.0) * 0.25;
    final skills = Target.isWebIos || Target.isWebAndroid
        ? _skills.indexedMap((index, skill) {
            final angle = _getEndAngle(index, endAdjustmentValue) * 2 * math.pi;
            return Align(
              widthFactor: _getAlignment(index, endAdjustmentValue, 1.0),
              child: Transform.rotate(
                angle: angle,
                child: _Skill(
                  angle: angle,
                  distance: 2.0,
                  skill: skill.$1,
                  icon: skill.$2,
                  color: _pastelColors[index],
                  foregroundColor: _boldColors[index],
                ),
              ),
            );
          })
        : _skills.indexedMap(
            (index, skill) => const SizedBox()
                .animate()
                .custom(
                  delay: 100.ms * index,
                  duration: 550.ms,
                  curve: PEffects.swiftOut,
                  begin: -0.01 * index,
                  end: _getEndAngle(index, endAdjustmentValue),
                  builder: (context, value, _) {
                    final angle = value * 2 * math.pi;
                    return Transform.rotate(
                      angle: angle,
                      child: _Skill(
                        angle: angle,
                        distance: 2.0,
                        skill: skill.$1,
                        icon: skill.$2,
                        color: _pastelColors[index],
                        foregroundColor: _boldColors[index],
                      ),
                    );
                  },
                )
                .scaleXY(
                  delay: 75.ms * index,
                  duration: 400.ms,
                  curve: Sprung(25),
                  begin: 0.1,
                  end: 1.0,
                )
                .custom(
                  delay: 115.ms * index,
                  duration: 450.ms,
                  curve: PEffects.swiftOut,
                  builder: (context, value, child) => Align(
                    widthFactor:
                        _getAlignment(index, endAdjustmentValue, value),
                    child: child,
                  ),
                ),
          );

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: skills.toList(),
          ),
        ),
      ),
    );

    // return Center(
    //   child: OverflowBox(
    //     maxWidth: 1000.0,
    //     maxHeight: 200.0,
    //     fit: OverflowBoxFit.deferToChild,
    //     child: Row(
    //       mainAxisSize: MainAxisSize.min,
    //       children: skills.toList(),
    //     ),
    //   ),
    // );
  }
}

class _Skill extends StatelessWidget {
  const _Skill({
    required this.angle,
    required this.distance,
    required this.skill,
    required this.icon,
    required this.color,
    required this.foregroundColor,
  });

  final double angle, distance;
  final String skill;
  final IconData icon;
  final Color color;
  final Color foregroundColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    return DefaultSelectionStyle(
      mouseCursor: SystemMouseCursors.basic,
      child: EnlargeOnHover(
        child: Transform.scale(
          scale: 1 / 1.1,
          child: Container(
            decoration: ShapeDecoration(
              shape: PDecors.border16,
              gradient: LinearGradient(
                colors: [
                  color.tint30,
                  color.tint20,
                  color.tint10,
                  color,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              shadows: [
                ...PDecors.focusedShadows(
                  elevation: .75,
                  offsetDelta: Offset.fromDirection(angle, distance),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  spreadRadius: 2.0,
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ),
            width: 200.0 * (screenWidth / 800.0).clamp(0.7, 1.0),
            height: 80.0,
            padding: k16APadding,
            child: Stack(
              children: [
                Icon(
                  icon,
                  size: 28.0,
                  color: foregroundColor,
                  shadows: const [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 1.0,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ).alignTopEnd(),
                Text(
                  skill,
                  style: theme.textTheme.bodyLarge?.modifyWeight(2).apply(
                        color: foregroundColor,
                        fontSizeFactor:
                            1.75 * (screenWidth / 900.0).clamp(0.6, 1.0),
                        heightFactor: 0.6,
                      ),
                  overflow: TextOverflow.visible,
                ).alignBottomStart(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
