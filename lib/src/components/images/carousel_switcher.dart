import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';

enum CarouselAnimationStyle {
  none,
  scale,
  fade,
  scaleFade,
}

class CarouselSwitcher extends StatefulWidget {
  const CarouselSwitcher({
    this.onPageChanged,
    this.initialIndex = 0,
    this.indexListenable,
    this.style = const CarouselSwitcherStyle(),
    required this.children,
    super.key,
  });

  final ValueChanged<int>? onPageChanged;
  final int initialIndex;
  final ValueNotifier<int>? indexListenable;
  final CarouselSwitcherStyle style;
  final List<Widget> children;

  @override
  State<CarouselSwitcher> createState() => _CarouselSwitcherState();
}

class _CarouselSwitcherState extends State<CarouselSwitcher> {
  late final _controller = PageController(
    initialPage: widget.initialIndex,
    keepPage: false,
    viewportFraction: 0.3,
  );

  void _onIndexNotified() {
    final index = widget.indexListenable?.value ?? widget.initialIndex;
    if (index == _controller.page?.round()) {
      return;
    }
    _controller.animateToPage(
      index,
      duration: PEffects.shortDuration,
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();
    widget.indexListenable?.addListener(_onIndexNotified);
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.indexListenable?.removeListener(_onIndexNotified);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final switcher = _Switcher(widget.children);

    final withLayoutBuilder = LayoutBuilder(
      builder: (context, constraints) {
        final style = widget.style;
        final width = constraints.maxWidth;

        return MultiProvider(
          providers: [
            Provider<Size>.value(value: Size(width, style.height)),
            Provider<BoxConstraints>.value(
              value: BoxConstraints(
                maxWidth: min(width / 2, style.maxItemWidth),
                minWidth: style.minItemWidth,
              ),
            ),
          ],
          child: switcher,
        );
      },
    );

    return MultiProvider(
      providers: [
        Provider<CarouselSwitcherStyle>.value(value: widget.style),
        ListenableProvider<PageController>.value(value: _controller),
        ProxyProvider<PageController, double>(
          update: (_, controller, __) {
            try {
              return controller.page ?? controller.initialPage.toDouble();
            } catch (error) {
              // ignore
              return widget.initialIndex.toDouble();
            }
          },
        ),
        Provider<ValueChanged<int>?>.value(value: widget.onPageChanged),
        Provider<int>.value(value: widget.children.length),
      ],
      child: SizedBox(
        height: widget.style.height,
        width: widget.style.width,
        child: withLayoutBuilder,
      ),
    );
  }
}

class _Switcher extends StatelessWidget {
  const _Switcher(this.children);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: Builder(
            builder: (context) {
              final currentPage = context.watch<double>();
              return Stack(
                children: children.indexedMap((index, item) {
                  final currentIndex = currentPage - index;
                  return Provider<double>.value(
                    value: currentIndex,
                    child: _CarouselSwitcherItem(child: item),
                  );
                }).toList(),
              );
            },
          ),
        ),
        const Positioned.fill(child: _PageView()),
      ],
    );
  }
}

class _PageView extends StatefulWidget {
  const _PageView();

  @override
  State<_PageView> createState() => _PageViewState();
}

class _PageViewState extends State<_PageView> {
  @override
  Widget build(BuildContext context) {
    final currentPage = context.watch<double>();
    final controller =
        context.select((PageController controller) => controller);
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        final page = controller.page?.round();
        if (page != null) {
          scheduleMicrotask(() {
            controller.animateToPage(
              page,
              duration: PEffects.veryShortDuration,
              curve: Curves.ease,
            );
          });
        }
        return false;
      },
      child: PageView.builder(
        controller: controller,
        allowImplicitScrolling: true,
        pageSnapping: false,
        onPageChanged: context.watch<ValueChanged<int>?>(),
        itemCount: context.watch<int>(),
        itemBuilder: (context, index) => Provider.value(
          value: currentPage - index,
          child: const _GhostBox(),
        ),
      ),
    );
  }
}

class _GhostBox extends StatelessWidget {
  const _GhostBox();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.calculateItemWidth(),
      height: context.height(),
    );
  }
}

class _CarouselSwitcherItem extends StatelessWidget {
  const _CarouselSwitcherItem({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animationStyle = context.style();

    Widget child = SizedBox(
      width: context.calculateItemWidth(),
      height: context.height(),
      child: this.child,
    );

    child = AnimatedScale(
      scale: animationStyle == CarouselAnimationStyle.scale ||
              animationStyle == CarouselAnimationStyle.scaleFade
          ? context.scaleValue()
          : 1,
      duration: const Duration(milliseconds: 150),
      curve: Curves.ease,
      child: child,
    );

    child = AnimatedOpacity(
      opacity: animationStyle == CarouselAnimationStyle.fade ||
              animationStyle == CarouselAnimationStyle.scaleFade
          ? context.opacityValue()
          : 1,
      duration: const Duration(milliseconds: 150),
      curve: Curves.ease,
      child: child,
    );

    child = Padding(
      padding: EdgeInsetsDirectional.only(start: context.spacing() / 2),
      child: child,
    );

    return Transform.translate(
      offset: Offset(context.itemPosition(), 0),
      child: child,
    );
  }
}

extension _CarouselSwitcherItemContext on BuildContext {
  double index() => watch<double>();
  double absIndex() => index().abs();
  double width() => watch<Size>().width;
  double height() => watch<Size>().height;
  double maxWidth() => watch<BoxConstraints>().maxWidth;
  double minWidth() => watch<BoxConstraints>().minWidth;
  double spacing() => select((CarouselSwitcherStyle style) => style.spacing);
  CarouselAnimationStyle style() =>
      select((CarouselSwitcherStyle style) => style.animationStyle);

  double itemPosition() {
    final centerPosition = width() / 2;
    final mainPosition = centerPosition - (maxWidth() / 2);
    if (index() == 0) {
      return mainPosition;
    }
    return calculateNewMainPosition(mainPosition);
  }

  double calculateItemWidth() {
    final absIndex = this.absIndex();
    final maxWidth = this.maxWidth();
    final minWidth = this.minWidth();
    final diffWidth = maxWidth - minWidth;
    final newMaxItemWidth = maxWidth - (diffWidth * absIndex);
    return (absIndex < 1 ? newMaxItemWidth : minWidth) - spacing();
  }

  double scaleValue() => 1 - (0.15 * absIndex());

  double opacityValue() {
    return (1 - (0.2 * absIndex())).clamp(0, 1);
  }

  double calculateLeftPosition(double mainPosition) {
    return absIndex() <= 1 ? mainPosition : (mainPosition - minWidth());
  }

  double calculateRightPosition(double mainPosition) {
    final totalWidth = maxWidth() + minWidth();
    return absIndex() <= 1 ? mainPosition : mainPosition + totalWidth;
  }

  double calculateRightAndLeftDiffPosition() {
    final index = this.index();
    final absIndex = index.abs();
    final minWidth = this.minWidth();
    return absIndex <= 1.0
        ? ((index > 0 ? minWidth : maxWidth()) * absIndex)
        : ((index > 0 ? (absIndex - 1) : (absIndex - 2)) * minWidth);
  }

  double calculateNewMainPosition(double mainPosition) {
    final diffPosition = calculateRightAndLeftDiffPosition();
    final leftPosition = calculateLeftPosition(mainPosition);
    final rightPosition = calculateRightPosition(mainPosition);
    return index() > 0
        ? leftPosition - diffPosition
        : rightPosition + diffPosition;
  }
}

@immutable
class CarouselSwitcherStyle {
  const CarouselSwitcherStyle({
    this.height = 120.0,
    this.width = double.maxFinite,
    this.spacing = 8.0,
    this.minItemWidth = 40.0,
    this.maxItemWidth = 80.0,
    this.animationStyle = CarouselAnimationStyle.none,
  });

  final double height;
  final double width;
  final double spacing;
  final double minItemWidth;
  final double maxItemWidth;
  final CarouselAnimationStyle animationStyle;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is CarouselSwitcherStyle &&
        other.height == height &&
        other.width == width &&
        other.spacing == spacing &&
        other.minItemWidth == minItemWidth &&
        other.maxItemWidth == maxItemWidth &&
        other.animationStyle == animationStyle;
  }

  @override
  int get hashCode {
    return height.hashCode ^
        width.hashCode ^
        spacing.hashCode ^
        minItemWidth.hashCode ^
        maxItemWidth.hashCode ^
        animationStyle.hashCode;
  }

  @override
  String toString() {
    return 'CarouselSwitcherStyle(height: $height, width: $width, spacing: $spacing, minItemWidth: $minItemWidth, maxItemWidth: $maxItemWidth, style: $animationStyle)';
  }
}
