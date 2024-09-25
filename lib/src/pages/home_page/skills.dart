part of 'home_page.dart';

const _skills = [
  ('mobile app', HugeIcons.strokeRoundedMobileProgramming01),
  ('web app', HugeIcons.strokeRoundedWebProgramming),
  ('user interface', HugeIcons.strokeRoundedWebDesign02),
  ('visual language', HugeIcons.strokeRoundedEye),
  ('animation', HugeIcons.strokeRoundedMouseRightClick01),
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

class _Skills extends StatelessWidget {
  const _Skills();

  @override
  Widget build(BuildContext context) {
    final skills = _skills
        .indexedMap(
          (index, skill) => _Skill(
            skill: skill.$1,
            icon: skill.$2,
            color: _pastelColors[index],
            foregroundColor: _boldColors[index],
          )
              // .square(100.0)
              .animate()
              .scaleXY(
                delay: 75.ms * index,
                duration: 400.ms,
                curve: Sprung(25),
                begin: 0.1,
                end: 1.0,
              )
              .rotate(
                delay: 100.ms * index,
                duration: 550.ms,
                curve: Curves.easeOutBack,
                begin: -0.01 * index,
                end: 0.01 * (index / 2.5 + 1.0) * (index.isOdd ? -1 : 1),
              ),
          // .custom(
          //   delay: 115.ms * index,
          //   duration: 450.ms,
          //   curve: Curves.ease,
          //   builder: (context, value, child) => Align(
          //     widthFactor: alignTween.transform(value),
          //     child: child,
          //   ),
          // ),
        )
        .toList();

    return Wrap(
      children: skills,
    );
  }
}

class _Skill extends StatelessWidget {
  const _Skill({
    required this.skill,
    required this.icon,
    required this.color,
    required this.foregroundColor,
  });

  final String skill;
  final IconData icon;
  final Color color;
  final Color foregroundColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HoverTapBuilder(
      builder: (context, isHovered) => EnlargeOnHover(
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
                ...PDecors.focusedShadows(elevation: .5),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  spreadRadius: 2.0,
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ),
            width: 200.0,
            height: 80.0,
            padding: k16APadding,
            child: Stack(
              children: [
                Icon(
                  icon,
                  size: 28.0,
                  color: foregroundColor,
                ).alignTopEnd(),
                Text(
                  skill,
                  style: theme.textTheme.bodyLarge?.modifyWeight(2).apply(
                        color: foregroundColor,
                        fontSizeFactor: 1.75,
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
