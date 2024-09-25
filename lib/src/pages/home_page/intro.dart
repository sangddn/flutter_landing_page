part of 'home_page.dart';

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleLarge!.modifyWeight(-1);

    return HoverTapBuilder(
      mouseCursor: SystemMouseCursors.text,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      cornerRadius: 0.0,
      builder: (context, isHovered) => Provider<bool>.value(
        value: isHovered,
        child: DefaultTextStyle(
          style: style,
          child: Text.rich(
            TextSpan(
              text:
                  'Hey, I’m Sang, a design engineer and full-stack developer, ',
              onEnter: (_) => context.read<ValueNotifier<bool>>().value = true,
              onExit: (_) => context.read<ValueNotifier<bool>>().value = false,
              children: const [
                TextSpan(
                  text: 'helping founders and startups build ',
                ),
                WidgetSpan(
                  baseline: TextBaseline.alphabetic,
                  alignment: PlaceholderAlignment.middle,
                  child: _IconicText(),
                ),
                TextSpan(text: ' '),
                WidgetSpan(
                  baseline: TextBaseline.alphabetic,
                  alignment: PlaceholderAlignment.middle,
                  child: _FastText(),
                ),
                TextSpan(text: '.'),
              ],
            ),
            style: style,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _IconicText extends StatelessWidget {
  const _IconicText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHovered = context.watch<bool>();
    var style = DefaultTextStyle.of(context)
        .style
        .modifyWeight(2)
        .copyWith(color: isHovered ? theme.inverseNeutral : null);
    if (isHovered) {
      style = style.monoFont;
    }
    final text = Text('iconic products', style: style);
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        text,
        if (isHovered) ...[
          const Gap(8.0),
          Icon(
            HugeIcons.strokeRoundedSourceCode,
            color: PColors.blue.resolveFrom(context),
            size: 24.0,
          ),
        ],
      ],
    );

    return AnimatedContainer(
      duration: 200.ms,
      curve: Easing.emphasizedDecelerate,
      decoration: !isHovered
          ? null
          : ShapeDecoration(
              shape: const PContinuousRectangleBorder(
                cornerRadius: 12.0,
                side: BorderSide(
                  color: Color(0xff69778E),
                ),
              ),
              gradient: const RadialGradient(
                center: Alignment.topCenter,
                radius: 2.0,
                colors: [
                  Color(0xff72829A),
                  Color(0xff444E62),
                ],
              ),
              shadows: [
                BoxShadow(
                  color: const Color(0xff000000).withOpacity(0.25),
                  blurRadius: 8.0,
                  spreadRadius: -2.0,
                  offset: const Offset(0.0, 5.0),
                ),
                const BoxShadow(
                  color: Color(0xff121720),
                  spreadRadius: 1.0,
                ),
                const BoxShadow(
                  color: Color(0xff2D3444),
                  spreadRadius: 1.0,
                  offset: Offset(0.0, 3.0),
                  blurStyle: BlurStyle.inner,
                ),
                const BoxShadow(
                  color: Color(0xff546374),
                  spreadRadius: 1.0,
                  offset: Offset(0.0, 4.0),
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ),
      padding: isHovered ? k12HPadding + k8VPadding : EdgeInsets.zero,
      margin: isHovered ? const EdgeInsets.all(6.0) : EdgeInsets.zero,
      child: AnimatedSize(
        duration: 200.ms,
        curve: Easing.emphasizedDecelerate,
        alignment: AlignmentDirectional.centerStart,
        child: isHovered
            ? ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xffFFFFFF),
                    Color(0xffD0D0D0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: content,
              )
            : content,
      ),
    );
  }
}

class _FastText extends StatelessWidget {
  const _FastText();

  @override
  Widget build(BuildContext context) {
    final isHovered = context.watch<bool>();
    var style = DefaultTextStyle.of(context)
        .style
        .copyWith(color: isHovered ? Colors.white : null);
    if (isHovered) {
      style = style.copyWith(
        shadows: [
          const BoxShadow(
            color: Color(0xffCE5700),
            offset: Offset(0.0, 1.0),
          ),
        ],
      );
    }
    final text = Text('fast', style: style);
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        text,
        if (isHovered) ...[
          const Gap(8.0),
          const Icon(
            HugeIcons.strokeRoundedZap,
            color: Colors.white,
            size: 24.0,
            shadows: [
              BoxShadow(
                color: Color(0xffCE5700),
                offset: Offset(0.0, 1.0),
              ),
            ],
          ),
        ],
      ],
    );

    return AnimatedContainer(
      duration: 200.ms,
      curve: Easing.emphasizedDecelerate,
      decoration: !isHovered
          ? null
          : ShapeDecoration(
              shape: const GradientSquircleStadiumBorder(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(222, 255, 255, 255),
                    Color(0xffCE5700),
                  ],
                ),
              ),
              gradient: const RadialGradient(
                center: Alignment.topCenter,
                radius: 2.0,
                colors: [
                  Color(0xffFFAA46),
                  Color(0xffF76800),
                ],
              ),
              shadows: [
                const BoxShadow(
                  color: Color(0xffCE5700),
                  offset: Offset(0.0, 1.0),
                ),
                BoxShadow(
                  color: const Color(0xff000000).withOpacity(0.17),
                  blurRadius: 9.0,
                  spreadRadius: -1.0,
                  offset: const Offset(0.0, 5.0),
                ),
                const BoxShadow(
                  color: Color(0xffAE4900),
                  spreadRadius: 2.0,
                ),
              ],
            ),
      padding: isHovered ? k12HPadding + k8VPadding : EdgeInsets.zero,
      margin: isHovered ? const EdgeInsets.all(6.0) : EdgeInsets.zero,
      child: AnimatedSize(
        duration: 200.ms,
        curve: Easing.emphasizedDecelerate,
        alignment: AlignmentDirectional.centerStart,
        child: content,
      ),
    );
  }
}
