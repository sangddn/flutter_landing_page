// ignore_for_file: use_if_null_to_convert_nulls_to_bools, always_put_control_body_on_new_line
//
// Library copied from: https://github.com/letsar/value_layout_builder/blob/master/lib/src/sliver_value_layout_builder.dart
// with some modifications.
//

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// The signature of the [ValueLayoutBuilder] builder function.
typedef ValueLayoutWidgetBuilder<T> = Widget Function(
  BuildContext context,
  BoxValueConstraints<T> constraints,
);

class BoxValueConstraints<T> extends BoxConstraints {
  BoxValueConstraints({
    required this.value,
    required BoxConstraints constraints,
  }) : super(
          minWidth: constraints.minWidth,
          maxWidth: constraints.maxWidth,
          minHeight: constraints.minHeight,
          maxHeight: constraints.maxHeight,
        );

  final T value;

  @override
  bool operator ==(Object other) {
    assert(debugAssertIsValid());
    if (identical(this, other)) return true;
    if (other is! BoxValueConstraints<T>) return false;
    final BoxValueConstraints<T> typedOther = other;
    assert(typedOther.debugAssertIsValid());
    return value == typedOther.value &&
        minWidth == typedOther.minWidth &&
        maxWidth == typedOther.maxWidth &&
        minHeight == typedOther.minHeight &&
        maxHeight == typedOther.maxHeight;
  }

  @override
  int get hashCode {
    assert(debugAssertIsValid());
    return Object.hash(minWidth, maxWidth, minHeight, maxHeight, value);
  }
}

/// Builds a widget tree that can depend on the parent widget's size and a extra
/// value.
///
/// Similar to the [LayoutBuilder] widget except that the constraints contains
/// an extra value.
///
/// See also:
///
///  * [LayoutBuilder].
///  * [SliverValueLayoutBuilder], the sliver version of this widget.
class ValueLayoutBuilder<T>
    extends ConstrainedLayoutBuilder<BoxValueConstraints<T>> {
  /// Creates a widget that defers its building until layout.
  const ValueLayoutBuilder({
    super.key,
    required super.builder,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderValueLayoutBuilder<T>();
}

class _RenderValueLayoutBuilder<T> extends RenderBox
    with
        RenderObjectWithChildMixin<RenderBox>,
        RenderConstrainedLayoutBuilder<BoxValueConstraints<T>, RenderBox> {
  @override
  double computeMinIntrinsicWidth(double height) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    rebuildIfNecessary();
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
    } else {
      size = constraints.biggest;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return child?.hitTest(result, position: position) ?? false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) context.paintChild(child!, offset);
  }

  bool _debugThrowIfNotCheckingIntrinsics() {
    assert(() {
      if (!RenderObject.debugCheckingIntrinsics) {
        throw FlutterError(
            'ValueLayoutBuilder does not support returning intrinsic dimensions.\n'
            'Calculating the intrinsic dimensions would require running the layout '
            'callback speculatively, which might mutate the live render object tree.');
      }
      return true;
    }());

    return true;
  }
}

/// The signature of the [SliverValueLayoutBuilder] builder function.
///
typedef SliverValueLayoutWidgetBuilder<T> = Widget Function(
  BuildContext context,
  SliverValueConstraints<T> constraints,
);

class SliverValueConstraints<T> extends SliverConstraints {
  SliverValueConstraints({
    required this.value,
    required SliverConstraints constraints,
  }) : super(
          axisDirection: constraints.axisDirection,
          growthDirection: constraints.growthDirection,
          userScrollDirection: constraints.userScrollDirection,
          scrollOffset: constraints.scrollOffset,
          precedingScrollExtent: constraints.precedingScrollExtent,
          overlap: constraints.overlap,
          remainingPaintExtent: constraints.remainingPaintExtent,
          crossAxisExtent: constraints.crossAxisExtent,
          crossAxisDirection: constraints.crossAxisDirection,
          viewportMainAxisExtent: constraints.viewportMainAxisExtent,
          remainingCacheExtent: constraints.remainingCacheExtent,
          cacheOrigin: constraints.cacheOrigin,
        );

  final T value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! SliverValueConstraints<T>) {
      return false;
    }
    assert(other.debugAssertIsValid());
    return other.value == value &&
        other.axisDirection == axisDirection &&
        other.growthDirection == growthDirection &&
        other.scrollOffset == scrollOffset &&
        other.overlap == overlap &&
        other.remainingPaintExtent == remainingPaintExtent &&
        other.crossAxisExtent == crossAxisExtent &&
        other.crossAxisDirection == crossAxisDirection &&
        other.viewportMainAxisExtent == viewportMainAxisExtent &&
        other.remainingCacheExtent == remainingCacheExtent &&
        other.cacheOrigin == cacheOrigin;
  }

  @override
  int get hashCode {
    return Object.hash(
      axisDirection,
      growthDirection,
      scrollOffset,
      overlap,
      remainingPaintExtent,
      crossAxisExtent,
      crossAxisDirection,
      viewportMainAxisExtent,
      remainingCacheExtent,
      cacheOrigin,
      value,
    );
  }
}

/// Builds a sliver widget tree that can depend on its own
/// [SliverValueConstraints].
///
/// Similar to the [ValueLayoutBuilder] widget except its builder should return
/// a sliver widget, and [SliverValueLayoutBuilder] is itself a sliver.
/// The framework calls the [builder] function at layout time and provides the
/// current [SliverValueConstraints].
/// The [SliverValueLayoutBuilder]'s final [SliverGeometry] will match the
/// [SliverGeometry] of its child.
///
/// See also:
///
///  * [ValueLayoutBuilder], the non-sliver version of this widget.
class SliverValueLayoutBuilder<T>
    extends ConstrainedLayoutBuilder<SliverValueConstraints<T>> {
  /// Creates a sliver widget that defers its building until layout.
  const SliverValueLayoutBuilder({
    super.key,
    required super.builder,
  });

  /// Called at layout time to construct the widget tree.
  ///
  /// The builder must return a non-null sliver widget.
  @override
  SliverValueLayoutWidgetBuilder<T> get builder => super.builder;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSliverValueLayoutBuilder<T>();
}

class _RenderSliverValueLayoutBuilder<T> extends RenderSliver
    with
        RenderObjectWithChildMixin<RenderSliver>,
        RenderConstrainedLayoutBuilder<SliverValueConstraints<T>,
            RenderSliver> {
  @override
  double childMainAxisPosition(RenderObject child) {
    assert(child == this.child);
    return 0;
  }

  @override
  void performLayout() {
    rebuildIfNecessary();
    child?.layout(constraints, parentUsesSize: true);
    geometry = child?.geometry ?? SliverGeometry.zero;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child == this.child);
    // child's offset is always (0, 0), transform.translate(0, 0) does not mutate the transform.
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // This renderObject does not introduce additional offset to child's position.
    if (child?.geometry?.visible == true) {
      context.paintChild(child!, offset);
    }
  }

  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    return child != null &&
        child!.geometry!.hitTestExtent > 0 &&
        child!.hitTest(
          result,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition,
        );
  }
}
