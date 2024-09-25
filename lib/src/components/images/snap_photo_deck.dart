import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../core/core.dart';

class SnapPhotoDeck extends StatefulWidget {
  const SnapPhotoDeck({
    this.controller,
    this.initialIndex = 0,
    this.onPageChanged,
    this.style = const SnapPhotoDeckStyle(),
    required this.children,
    super.key,
  });

  final PageController? controller;
  final int initialIndex;
  final ValueChanged<int>? onPageChanged;
  final SnapPhotoDeckStyle style;
  final IList<Widget> children;

  @override
  State<SnapPhotoDeck> createState() => _SnapPhotoDeckState();
}

class _SnapPhotoDeckState extends State<SnapPhotoDeck> {
  late var _controller =
      widget.controller ?? PageController(initialPage: widget.initialIndex);
  late var _activeIndex = widget.initialIndex;

  @override
  void didUpdateWidget(SnapPhotoDeck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller ??
          PageController(
            initialPage: widget.initialIndex,
            // viewportFraction: 0.5,
          );
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final switcher = _Switcher(widget.children);

    return MultiProvider(
      providers: [
        ListenableProvider<PageController>.value(value: _controller),
        ProxyProvider<PageController, ActiveIndex>(
          update: (_, controller, __) {
            try {
              final page = controller.page ?? controller.initialPage.toDouble();
              final index = page == page.round() ? page.round() : null;
              if (index != null) {
                _activeIndex = index;
              }
              return ActiveIndex(_activeIndex, page);
            } catch (error) {
              // ignore
              return ActiveIndex(
                widget.initialIndex,
                widget.initialIndex.toDouble(),
              );
            }
          },
        ),
        Provider<ValueChanged<int>?>.value(value: widget.onPageChanged),
        Provider<SnapPhotoDeckStyle>.value(value: widget.style),
        Provider<int>.value(value: widget.children.length),
      ],
      child: SizedBox.fromSize(
        size: widget.style.size,
        child: switcher,
      ),
    );
  }
}

class _Switcher extends StatelessWidget {
  const _Switcher(this.children);

  final IList<Widget> children;

  @override
  Widget build(BuildContext context) {
    final items = children
        .indexedMap(
          (index, item) =>
              _Item(key: ValueKey(item), index: index, child: item),
        )
        .toList();
    final activeIndex = context.activeIndex();
    final page = context.page();
    final before = items.take(activeIndex);
    final after = items.skip(activeIndex + 1).toList().reversed;
    return Stack(
      alignment: Alignment.center,
      children: [
        // Start side
        if (page >= activeIndex) ...before else ...after,
        // End side
        if (page >= activeIndex) ...after else ...before,
        // Active item
        items[activeIndex],
        const Positioned.fill(child: _PageView()),
      ],
    );
  }
}

class _PageView extends StatelessWidget {
  const _PageView();

  @override
  Widget build(BuildContext context) {
    final count = context.itemCount();
    return PageView.builder(
      controller: context.select((PageController controller) => controller),
      onPageChanged: (index) =>
          context.read<ValueChanged<int>?>()?.call(index % count),
      allowImplicitScrolling: true,
      itemCount: count,
      itemBuilder: (context, index) =>
          SizedBox.expand(child: Text('${index % count}')),
    );
  }
}

class _Item extends StatefulWidget {
  const _Item({required this.index, required this.child, super.key});

  final int index;
  final Widget child;

  @override
  State<_Item> createState() => _ItemState();
}

class _ItemState extends State<_Item> {
  int get index => widget.index;
  int get activeIndex => context.activeIndex();
  int get itemCount => context.itemCount();
  double get currentPage => context.page();
  double get relativePos => currentPage - index;
  double get absRelativePos => relativePos.abs();
  double get activeRelativePos => currentPage - activeIndex;
  double get absActiveRelativePos => activeRelativePos.abs();
  Size get size => context.itemSize();
  // double get width => size.width;
  double get height => size.height;

  @override
  Widget build(BuildContext context) {
    final translateX = _calculateTranslateX();
    final translateZ = _calculateTranslateZ(relativePos);
    final rotateY = _calculateRotateY();
    final rotateZ = _calculateRotateZ();
    final scale = _calculateScale();

    return SizedBox.fromSize(
      size: size,
      child: Stack(
        children: [
          Positioned.fill(
            child: Transform(
              // duration: PEffects.veryShortDuration,
              // curve: Curves.easeInOut,
              transform: Matrix4.translationValues(translateX, 0.0, translateZ),
              child: Transform(
                transform: Matrix4.rotationY(rotateY),
                child: Transform(
                  transform: Matrix4.rotationZ(rotateZ),
                  child: Transform.scale(
                    scale: scale,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
          Center(child: Text(index.toString())),
        ],
      ),
    );
  }

  double _calculateTranslateX() {
    final relativePos = this.relativePos;
    final absRelativePos = this.absRelativePos;
    var translateX = 0.0;
    if (activeIndex == index) {
      if (absRelativePos < 0.5) {
        // Translate the card by 136% of its width when it is active but the
        // scroll distance is less than half if its width
        translateX = 128 * relativePos;
      } else {
        // Translate the card by 128% of its width when it is active and the
        // scroll distance is more than half if its width.
        // Also add a slight offset to the translation so that when the card
        // reaches the final position, it is not completely centered, rather
        // takes its final position as the card next or previous to the new
        // active card.
        translateX = -128 * relativePos.sign;
        translateX += 128 * relativePos;
        translateX += -((1 - absRelativePos / 4) * 10) *
            (absRelativePos - 0.5) *
            2 *
            relativePos.sign;
      }
    } else {
      translateX = relativePos * 10;
    }

    return translateX;
  }

  // translateZ adds a slight perspective effect to the cards when they are
  // being rotated. The parent has it's own perspective value, so we need to
  // adjust the translateZ value based on the scroll progress to make the cards
  // look like they are being rotated in a 3D space.
  double _calculateTranslateZ(double relativePos) {
    return 200 - absRelativePos * 40;
  }

  double _calculateRotateY() {
    var rotateY = 0.0;

    // We rotate the card based on the relative and normalized scroll distance
    // from the active card. The maximum rotation is 75 degrees.
    if (absActiveRelativePos < 0.5) {
      rotateY = absActiveRelativePos * -75;
    } else {
      rotateY = (1 - absActiveRelativePos) * -75;
    }

    if (index == activeIndex) {
      // The active card rotates more than the other cards when it moves away
      // from the center.
      if (absRelativePos < 0.5) {
        rotateY = absRelativePos * -90;
      } else {
        rotateY = (1 - absRelativePos) * -90;
      }
    }

    return rotateY * degrees2Radians;
  }

  double _calculateScale() {
    // Cards scale down as they move away from the active card.
    var scale = 1 - absRelativePos * 0.05;

    // The active card scales down more than the other cards when it is away
    // from the center.
    if (index == activeIndex) {
      if (absRelativePos < 0.5) {
        scale -= absRelativePos * 0.25;
      } else {
        scale -= (1 - absRelativePos) * 0.25;
      }
    }

    if (scale < 0) {
      scale = 0;
    }

    return scale;
  }

  double _calculateRotateZ() {
    return relativePos * 2 * -1 * degrees2Radians;
  }
}

extension _SnapPhotoDeckItemContext on BuildContext {
  T selectStyle<T>(T Function(SnapPhotoDeckStyle) fn) => select(fn);
  Size itemSize() => selectStyle((style) => style.size);
  int activeIndex() => select((ActiveIndex v) => v.index);
  double page() => select((ActiveIndex v) => v.page);
  int itemCount() => watch<int>();
}

@immutable
class ActiveIndex {
  const ActiveIndex(this.index, this.page);

  final int index;
  final double page;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ActiveIndex && other.index == index && other.page == page;
  }

  @override
  int get hashCode => index.hashCode ^ page.hashCode;
}

@immutable
class SnapPhotoDeckStyle {
  const SnapPhotoDeckStyle({
    this.size = const Size(75.0, 100.0),
  });

  final Size size;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is SnapPhotoDeckStyle && other.size == size;
  }

  @override
  int get hashCode {
    return size.hashCode ^ size.hashCode;
  }
}
