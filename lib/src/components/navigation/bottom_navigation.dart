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
        curve: Curves.fastLinearToSlowEaseIn,
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
    final theme = Theme.of(context);
    final color = theme.neutral;
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipPath(
        clipper: const ShapeBorderClipper(shape: PDecors.border24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            decoration: ShapeDecoration(
              shape: PDecors.border24,
              color: color.withOpacity(.5),
              shadows: PDecors.broadShadows(
                context,
                elevation: 4.0,
                style: BlurStyle.outer,
              ),
            ),
            constraints: constraints,
            clipBehavior: Clip.hardEdge,
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

  Widget buildButtonContent(BuildContext context, bool isCurrent, String name) {
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
          color: isCurrent ? foregroundColor : textGray,
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
                .copyWith(color: isCurrent ? foregroundColor : darkGray)
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
    final name = path.getLocalizedName(context);
    return CButton(
      tooltip: name,
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
      child: buildButtonContent(context, isCurrent, name),
    );
  }
}

extension _MainPathInfo on MainPath {
  String getLocalizedName(BuildContext context) => switch (this) {
        MainPath.home => 'Home',
        MainPath.projects => 'Projects',
        MainPath.contact => 'Contact',
      };

  IconData get icon => switch (this) {
        MainPath.home => HugeIcons.strokeRoundedHome01,
        MainPath.projects => HugeIcons.strokeRoundedBriefcase01,
        MainPath.contact => HugeIcons.strokeRoundedMail01,
      };
}

class _Ink extends StatelessWidget {
  const _Ink();

  @override
  Widget build(BuildContext context) {
    return LocalHero(
      tag: 'bottom_navigation_circle',
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
