import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components.dart';

class ExpandableOverlayCard extends StatefulWidget {
  /// A card that expands to fill horizontal space when tapped.
  ///
  const ExpandableOverlayCard({
    required this.openChild,
    required this.closedChild,
    required this.semanticLabel,
    this.openWidth,
    this.maxOpenWidth,
    this.openHeight,
    this.openingDirection = AxisDirection.down,
    this.openBorderRadius = 20.0,
    this.closedBorderRadius = 20.0,
    this.openBoxShadows,
    this.closedBoxShadows,
    this.closedColor,
    this.openColor,
    this.displaceByClosedHeight = true,
    this.openAlignment,
    super.key,
  });

  final double? openWidth, openHeight, maxOpenWidth;
  final String semanticLabel;
  final AxisDirection openingDirection;
  final double openBorderRadius, closedBorderRadius;
  final bool displaceByClosedHeight;
  final List<BoxShadow>? closedBoxShadows, openBoxShadows;
  final Color? closedColor, openColor;
  final Alignment? openAlignment;
  final Widget? openChild;
  final Widget closedChild;

  @override
  State<ExpandableOverlayCard> createState() => _ExpandableOverlayCardState();
}

class _ExpandableOverlayCardState extends State<ExpandableOverlayCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  OverlayEntry? _overlay;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    safeRemoveOverlay();
    super.dispose();
  }

  void safeRemoveOverlay() {
    if (_overlay?.mounted ?? false) {
      _overlay?.remove();
    }
  }

  void closeOverlay() {
    // debugPrint('closing overlay');
    // HapticFeedback.lightImpact();
    _controller.reverse().then((_) {
      safeRemoveOverlay();
    });
  }

  @override
  Widget build(BuildContext context) {
    final closedChild = _Container(
      borderRadius: widget.closedBorderRadius,
      boxShadows: widget.closedBoxShadows,
      color: widget.closedColor,
      child: widget.closedChild,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final screenWidth = constraints.maxWidth;
        return PTooltip(
          message: widget.semanticLabel,
          child: BouncingObject(
            scaleFactor: 0.7,
            onTap: () {
              if (widget.openChild == null) {
                return;
              }
              Future.delayed(
                const Duration(milliseconds: 150),
                () {
                  HapticFeedback.lightImpact();

                  final renderBox = context.findRenderObject() as RenderBox?;
                  final size = renderBox?.size ?? Size.zero;
                  final position = renderBox?.localToGlobal(Offset.zero);

                  // debugPrint('size: $size');
                  // debugPrint('position: $position');

                  _overlay = OverlayEntry(
                    builder: (context) => Stack(
                      children: [
                        GestureDetector(
                          onTap: closeOverlay,
                        ),
                        _OverlayContainer(
                          controller: _controller,
                          initialTop:
                              widget.openingDirection == AxisDirection.down
                                  ? position?.dy
                                  : null,
                          initialBottom:
                              widget.openingDirection == AxisDirection.up &&
                                      (position != null)
                                  ? screenHeight - position.dy - size.height
                                  : null,
                          initialLeft: position?.dx,
                          closedWidth: size.width,
                          closedHeight: size.height,
                          openHeight: widget.openHeight,
                          openWidth: widget.openWidth,
                          color: widget.openColor,
                          maxOpenWidth: widget.maxOpenWidth ?? double.infinity,
                          borderRadius: widget.openBorderRadius,
                          boxShadows: widget.openBoxShadows,
                          displaceDownwards:
                              widget.openingDirection == AxisDirection.down &&
                                  widget.displaceByClosedHeight,
                          displaceUpwards:
                              widget.openingDirection == AxisDirection.up &&
                                  widget.displaceByClosedHeight,
                          closedChild: widget.closedChild,
                          screenWidth: screenWidth,
                          child: widget.openChild!,
                        ),
                        // CupertinoButton(
                        //   onPressed: closeOverlay,
                        //   child: const Text(
                        //     'Done',
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontSize: 20.0,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  );

                  Overlay.of(context).insert(_overlay!);

                  _controller.forward();
                },
              );
            },
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Visibility.maintain(
                  visible: _controller.value == 0.0,
                  child: closedChild,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _Container extends StatelessWidget {
  const _Container({
    required this.child,
    this.borderRadius = 20.0,
    this.boxShadows,
    this.color,
  });

  final Widget child;
  final double borderRadius;
  final List<BoxShadow>? boxShadows;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: ShapeDecoration(
        color: color ?? theme.canvasColor,
        shape: PContinuousRectangleBorder(
          cornerRadius: borderRadius,
        ),
        shadows: boxShadows ??
            const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15.0,
              ),
            ],
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }
}

class _OverlayContainer extends StatelessWidget {
  _OverlayContainer({
    this.initialTop,
    this.initialBottom,
    this.initialLeft,
    this.closedWidth,
    this.closedHeight,
    required this.openWidth,
    this.maxOpenWidth = double.infinity,
    this.openHeight,
    this.borderRadius = 20.0,
    this.boxShadows,
    this.color,
    this.displaceDownwards = false,
    this.displaceUpwards = false,
    required this.screenWidth,
    required this.closedChild,
    required this.child,
    required this.controller,
  });

  final double? initialTop,
      initialLeft,
      initialBottom,
      closedWidth,
      closedHeight,
      openWidth,
      openHeight;
  final double borderRadius, maxOpenWidth, screenWidth;
  final bool displaceDownwards, displaceUpwards;
  final List<BoxShadow>? boxShadows;
  final Color? color;
  final Widget child;
  final Widget closedChild;
  final AnimationController controller;
  late final _finalWidth = openWidth ?? min(screenWidth - 32.0, maxOpenWidth);

  late final _animation = CurvedAnimation(
    parent: controller,
    curve: Curves.decelerate,
    reverseCurve: Curves.easeInCubic,
  );
  late final widthTween = Tween<double>(
    begin: closedWidth ?? 0.0,
    end: _finalWidth,
  );
  late final heightTween = Tween<double>(
    begin: closedHeight ?? 0.0,
    end: openHeight ?? 200.0,
  );
  late final leftTween = Tween<double>(
    begin: initialLeft ?? 0.0,
    end: (screenWidth - _finalWidth) / 2,
  );
  late final topTween = Tween<double>(
    begin: initialTop ?? 0.0,
    end: (initialTop ?? 0.0) +
        (displaceDownwards
            ? ((closedHeight ?? 0.0) + 8.0)
            : (displaceUpwards ? (-(closedHeight ?? 0.0) - 8.0) : 0.0)),
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final width = widthTween.evaluate(_animation);
        final height = heightTween.evaluate(_animation);
        final left = leftTween.evaluate(_animation);
        final top = initialTop == null ? null : topTween.evaluate(_animation);

        return Positioned(
          top: top,
          bottom: initialBottom,
          left: left,
          width: width,
          height: height,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              closedChild,
              Opacity(
                opacity: _animation.value < 0.3
                    ? _animation.value
                    : (_animation.value < 0.8)
                        ? 0.7
                        : _animation.value,
                child: _Container(
                  borderRadius: borderRadius,
                  boxShadows: boxShadows,
                  color: color,
                  child: OverflowBox(
                    alignment: Alignment.topCenter,
                    maxWidth: _finalWidth,
                    maxHeight: openHeight ?? 200.0,
                    minWidth: closedWidth ?? 0.0,
                    minHeight: closedHeight ?? 0.0,
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
