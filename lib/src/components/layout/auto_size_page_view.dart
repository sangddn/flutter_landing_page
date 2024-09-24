import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const _firstLayoutMaxHeight = 10000.0;

/// A [PageView] that sizes itself to the size of the active child.
/// 
/// Only supports horizontal scrolling for now.
/// 
class AutoSizePageView extends StatefulWidget {
  const AutoSizePageView({
    super.key,
    this.reverse = false,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.scrollBehavior,
    this.padEnds = true,
    required this.controller,
    required this.children,
  }) : assert(children.length > 0, 'Children must not be empty');

  final bool reverse;
  final ScrollPhysics? physics;
  final bool pageSnapping;
  final ValueChanged<int>? onPageChanged;
  final DragStartBehavior dragStartBehavior;
  final bool allowImplicitScrolling;
  final String? restorationId;
  final Clip clipBehavior;
  final ScrollBehavior? scrollBehavior;
  final bool padEnds;
  final PageController controller;
  final List<Widget> children;

  @override
  State<AutoSizePageView> createState() => _AutoSizePageViewState();
}

class _AutoSizePageViewState extends State<AutoSizePageView> {
  final _sizes = <int, Size>{};

  @override
  void didUpdateWidget(AutoSizePageView oldWidget) {
    super.didUpdateWidget(oldWidget);

    _sizes.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) => _SizingContainer(
        sizes: _sizes,
        page: widget.controller.hasClients ? widget.controller.page ?? 0 : 0,
        child: child,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => PageView(
          controller: widget.controller,
          reverse: widget.reverse,
          physics: widget.physics,
          pageSnapping: widget.pageSnapping,
          onPageChanged: widget.onPageChanged,
          dragStartBehavior: widget.dragStartBehavior,
          allowImplicitScrolling: widget.allowImplicitScrolling,
          restorationId: widget.restorationId,
          clipBehavior: widget.clipBehavior,
          scrollBehavior: widget.scrollBehavior,
          padEnds: widget.padEnds,
          children: [
            for (final (i, child) in widget.children.indexed)
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox.fromSize(size: _sizes[i]),
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    child: _SizeAware(
                      child: child,
                      // don't setState, we'll use it in the layout phase
                      onSizeLaidOut: (size) {
                        _sizes[i] = size;
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

typedef _OnSizeLaidOutCallback = void Function(Size);

class _SizingContainer extends SingleChildRenderObjectWidget {
  const _SizingContainer({
    super.child,
    required this.sizes,
    required this.page,
  });

  final Map<int, Size> sizes;
  final double page;

  @override
  _RenderSizingContainer createRenderObject(BuildContext context) {
    return _RenderSizingContainer(
      sizes: sizes,
      page: page,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSizingContainer renderObject,
  ) {
    renderObject
      ..sizes = sizes
      ..page = page;
  }
}

class _RenderSizingContainer extends RenderProxyBox {
  _RenderSizingContainer({
    RenderBox? child,
    required Map<int, Size> sizes,
    required double page,
  })  : _sizes = sizes,
        _page = page,
        super(child);

  Map<int, Size> _sizes;
  Map<int, Size> get sizes => _sizes;
  set sizes(Map<int, Size> value) {
    if (_sizes == value) {
      return;
    }
    _sizes = value;
    markNeedsLayout();
  }

  double _page;
  double get page => _page;
  set page(double value) {
    if (_page == value) {
      return;
    }
    _page = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    if (child case final child?) {
      child.layout(
        constraints.copyWith(
          minWidth: constraints.maxWidth,
          minHeight: 0,
          maxHeight:
              constraints.hasBoundedHeight ? null : _firstLayoutMaxHeight,
        ),
        parentUsesSize: true,
      );

      final a = sizes[page.floor()]!;
      final b = sizes[page.ceil()]!;

      final height = lerpDouble(a.height, b.height, page - page.floor());

      child.layout(
        constraints.copyWith(minHeight: height, maxHeight: height),
        parentUsesSize: true,
      );
      size = child.size;
    } else {
      size = computeSizeForNoChild(constraints);
    }
  }
}

class _SizeAware extends SingleChildRenderObjectWidget {
  const _SizeAware({
    required Widget child,
    required this.onSizeLaidOut,
  }) : super(child: child);

  final _OnSizeLaidOutCallback onSizeLaidOut;

  @override
  _RenderSizeAware createRenderObject(BuildContext context) {
    return _RenderSizeAware(
      onSizeLaidOut: onSizeLaidOut,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSizeAware renderObject) {
    renderObject.onSizeLaidOut = onSizeLaidOut;
  }
}

class _RenderSizeAware extends RenderProxyBox {
  _RenderSizeAware({
    RenderBox? child,
    required _OnSizeLaidOutCallback onSizeLaidOut,
  })  : _onSizeLaidOut = onSizeLaidOut,
        super(child);

  _OnSizeLaidOutCallback? _onSizeLaidOut;
  _OnSizeLaidOutCallback get onSizeLaidOut => _onSizeLaidOut!;
  set onSizeLaidOut(_OnSizeLaidOutCallback value) {
    if (_onSizeLaidOut == value) {
      return;
    }
    _onSizeLaidOut = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    super.performLayout();

    onSizeLaidOut(
      getDryLayout(
        constraints.copyWith(maxHeight: double.infinity),
      ),
    );
  }
}
