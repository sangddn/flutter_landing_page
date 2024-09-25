import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:local_hero/local_hero.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../router/router.dart';
import '../components.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding =
        math.max(MediaQuery.viewPaddingOf(context).bottom, 16.0);

    final heroScroped = MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: LocalHeroScope(
        curve: const Cubic(0.175, 0.885, 0.32, 1.1),
        duration: PEffects.shortDuration,
        child: _Container(
          constraints: BoxConstraints(
            minHeight: kBottomNavigationBarHeight + bottomPadding,
            maxHeight: kBottomNavigationBarHeight + bottomPadding,
            maxWidth: 300.0,
          ),
          child: const _Buttons().padOnly(8.0, 10.0, 8.0, 10.0),
        )
            .padBottom(bottomPadding)
            .safeBottom(const EdgeInsets.only(bottom: 12.0)),
      ),
    );

    return Semantics(
      explicitChildNodes: true,
      child: heroScroped,
    );
  }
}

class _Container extends StatelessWidget {
  const _Container({
    required this.constraints,
    required this.child,
  });

  final BoxConstraints constraints;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: ShapeDecoration(
          shape: PDecors.border24,
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        constraints: constraints,
        clipBehavior: Clip.hardEdge,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: ColoredBox(
            color: PColors.lightGray.resolveFrom(context),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons();

  @override
  Widget build(BuildContext context) {
    final mainPath = context.watch<MainPath?>();
    const sideGap = 16.0;
    const minMiddleGap = 8.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: MainPath.values.indexedExpand((index, path) {
        final isFirst = index == 0;
        final isLast = index == MainPath.values.length - 1;
        final isCurrent = mainPath == path;

        final padding = EdgeInsetsDirectional.only(
          start: isFirst ? sideGap : minMiddleGap,
          end: isLast ? sideGap : minMiddleGap,
        );

        return [
          Stack(
            alignment: Alignment.center,
            children: [
              if (isCurrent)
                Align(widthFactor: 0.0, child: const _Ink().pad(padding)),
              _NavBarButton(mainPath: path, padding: padding),
            ],
          ),
          if (!isLast) const Spacer(),
        ];
      }).toList(),
    );
  }
}

class _NavBarButton extends StatefulWidget {
  const _NavBarButton({
    required this.mainPath,
    required this.padding,
  });

  final MainPath mainPath;
  final EdgeInsetsDirectional padding;

  @override
  State<_NavBarButton> createState() => NavBarButtonState();
}

class NavBarButtonState extends State<_NavBarButton> {
  AnimationController? _bounceController;
  final List<VoidCallback> _tapTwiceListeners = [];

  MainPath get path => widget.mainPath;

  void addTapTwiceListener(VoidCallback listener) {
    _tapTwiceListeners.add(listener);
  }

  void removeTapTwiceListener(VoidCallback listener) {
    _tapTwiceListeners.remove(listener);
  }

  Widget buildButtonContent(
    BuildContext context,
    bool isHovered,
    bool isCurrent,
    String name,
  ) {
    final theme = Theme.of(context);
    final foregroundColor = theme.colorScheme.primary;
    final darkGray = PColors.darkGray.resolveFrom(context);
    final textGray = PColors.textGray.resolveFrom(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          path.icon,
          size: 20.0,
          color: isCurrent || isHovered ? foregroundColor : textGray,
        )
            .animate(
              onInit: (controller) => _bounceController = controller,
              autoPlay: false,
            )
            .scaleOutAndBack(curve: Curves.easeOutBack),
        const Gap(4.0),
        MediaQuery.withNoTextScaling(
          child: Text(
            name,
            style: theme.textTheme.labelMedium
                ?.modifyWeight(isCurrent ? 0.75 : 0)
                .copyWith(
                  color: isCurrent || isHovered ? foregroundColor : darkGray,
                )
                .apply(letterSpacingDelta: -.1),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final thisPath = widget.mainPath;
    final currentPath = context.watch<MainPath?>();
    final isCurrent = currentPath == widget.mainPath;
    final name = path.name;
    final description = path.description;
    return HoverTapBuilder(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      mouseCursor: SystemMouseCursors.click,
      builder: (context, isHovered) => CButton(
        tooltip: description,
        onTap: () {
          if (isCurrent) {
            _bounceController?.forward(from: 0.0);
            for (final listener in _tapTwiceListeners) {
              listener();
            }
          }
          switch (thisPath) {
            case MainPath.home:
              const HomePageRoute().go(context);
            case MainPath.projects:
              const ProjectsPageRoute().go(context);
            case MainPath.contact:
              const ContactPageRoute().go(context);
          }
        },
        padding: const EdgeInsetsDirectional.all(4.0) + widget.padding,
        child: buildButtonContent(context, isHovered, isCurrent, name),
      ),
    );
  }
}

extension _MainPathInfo on MainPath {
  String get name => switch (this) {
        MainPath.home => 'Home',
        MainPath.projects => 'Work',
        MainPath.contact => 'Meet',
      };

  String get description => switch (this) {
        MainPath.home => 'Home',
        MainPath.projects => 'Our projects',
        MainPath.contact => 'Book a call and get a quote',
      };

  IconData get icon => switch (this) {
        MainPath.home => HugeIcons.strokeRoundedHome07,
        MainPath.projects => HugeIcons.strokeRoundedBriefcase01,
        MainPath.contact => HugeIcons.strokeRoundedCalendarAdd02,
      };
}

class _Ink extends StatelessWidget {
  const _Ink();

  @override
  Widget build(BuildContext context) {
    return LocalHero(
      tag: 'bottom_navigation_circle',
      flightShuttleBuilder: (_, __, ___) => Container(
        height: 80.0,
        width: 80.0,
        decoration: ShapeDecoration(
          shape: PDecors.border16,
          color: PColors.opaqueLightGray.resolveFrom(context),
        ),
      ),
      child: SizedBox(
        height: 80.0,
        width: 80.0,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: PDecors.border16,
            color: PColors.opaqueLightGray.resolveFrom(context),
            shadows: PDecors.focusedShadows(elevation: .25),
          ),
        ),
      ),
    );
  }
}
