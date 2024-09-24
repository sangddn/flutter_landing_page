import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../components.dart';

/// A collection of extensions for composing widgets in a more concise manner.
///
/// Usually, widgets are composed using the following syntax:
/// ```dart
/// Widget build(BuildContext context) {
///  return Padding(
///     padding: EdgeInsets.all(16.0),
///     child: child,
///   );
/// }
/// ```
///
/// This provides readability but can be verbose when child is null.
/// ```
/// Widget build(BuildContext context) {
///  return child == null
///   ? Container()
///   : Padding(
///       padding: EdgeInsets.all(16.0),
///       child: child,
///     );
/// }
/// ```
///
/// The extensions in this file allow for a more concise syntax:
/// ```dart
/// Widget build(BuildContext context) {
///   return child?.pad16A() ?? Container();
/// }
/// ```
/// or, in cases of more complex compositions:
/// ```dart
/// Widget build(BuildContext context) {
///  return child?.asChild(
///     (child) => ColoredBox(color: Colors.gray, child: child),
///   );
/// }
/// ```
///
extension Compose on Widget {
  Widget asChild(Widget Function(Widget child) builder) => builder(this);
  Widget asChildIf(bool condition, Widget Function(Widget child) builder) =>
      condition ? asChild(builder) : this;
}

extension ComposeList on Iterable<Widget> {
  Iterable<Widget> wrapEach(Widget Function(Widget child) builder) =>
      map((child) => builder(child));
  Iterable<Widget> wrapEachIf(
    bool Function(Widget child) condition,
    Widget Function(Widget child) builder,
  ) =>
      map((child) => condition(child) ? builder(child) : child);
}

extension MaterialX on Widget {
  Widget material() => Material(child: this);
  Widget materialIf(bool condition) => condition ? material() : this;
}

extension PaddingX on Widget {
  Widget pad(EdgeInsetsGeometry padding, {Key? key}) => this is Gap
      ? this
      : Padding(
          key: key,
          padding: padding,
          child: this,
        );

  Widget padAll(double padding, {Key? key}) =>
      pad(EdgeInsets.all(padding), key: key);
  Widget padRight(double right, {Key? key}) =>
      pad(EdgeInsets.only(right: right), key: key);
  Widget padStart(double start, {Key? key}) =>
      pad(EdgeInsetsDirectional.only(start: start), key: key);
  Widget padLeft(double left, {Key? key}) =>
      pad(EdgeInsetsDirectional.only(start: left), key: key);
  Widget padEnd(double end, {Key? key}) =>
      pad(EdgeInsetsDirectional.only(end: end), key: key);
  Widget padTop(double top, {Key? key}) =>
      pad(EdgeInsets.only(top: top), key: key);
  Widget padBottom(double bottom, {Key? key}) =>
      pad(EdgeInsets.only(bottom: bottom), key: key);
  Widget padVertical(double vertical, {Key? key}) =>
      pad(EdgeInsets.symmetric(vertical: vertical), key: key);
  Widget padHorizontal(double horizontal, {Key? key}) =>
      pad(EdgeInsets.symmetric(horizontal: horizontal), key: key);
  Widget padBottomEnd(double value, {Key? key}) => pad(
        EdgeInsetsDirectional.only(bottom: value, end: value),
        key: key,
      );
  Widget padBottomStart(double value, {Key? key}) => pad(
        EdgeInsetsDirectional.only(bottom: value, start: value),
        key: key,
      );
  Widget padTopEnd(double value, {Key? key}) => pad(
        EdgeInsetsDirectional.only(top: value, end: value),
        key: key,
      );
  Widget padTopStart(double value, {Key? key}) => pad(
        EdgeInsetsDirectional.only(top: value, start: value),
        key: key,
      );
  Widget padOnly([
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
    double left = 0.0,
    Key? key,
  ]) =>
      pad(
        EdgeInsets.only(top: top, right: right, bottom: bottom, left: left),
        key: key,
      );
  Widget padOnlyDirectional([
    double top = 0.0,
    double start = 0.0,
    double bottom = 0.0,
    double end = 0.0,
    Key? key,
  ]) =>
      pad(
        EdgeInsetsDirectional.only(
          top: top,
          start: start,
          bottom: bottom,
          end: end,
        ),
        key: key,
      );

  Widget pad16H({Key? key}) => pad(k16HPadding, key: key);
  Widget pad16A({Key? key}) => pad(k16APadding, key: key);
  Widget pad16H8V({Key? key}) => pad(k16H8VPadding, key: key);
  Widget pad8V({Key? key}) => pad(k8VPadding, key: key);
  Widget pad8H({Key? key}) => pad(k8HPadding, key: key);
  Widget pad12V({Key? key}) => pad(k12VPadding, key: key);
  Widget pad16H12V({Key? key}) => pad(k16H12VPadding, key: key);
  Widget pad16H4V({Key? key}) => pad(k16H4VPadding, key: key);
  Widget pad24H({Key? key}) => pad(k24HPadding, key: key);
  Widget pad12H({Key? key}) => pad(k12HPadding, key: key);
  Widget pad4H({Key? key}) => pad(k4HPadding, key: key);
  Widget pad4V({Key? key}) => pad(k4VPadding, key: key);

  // Slivers
  Widget padSliver(
    EdgeInsetsGeometry padding, {
    bool sliverAdapt = false,
    Key? key,
  }) =>
      this is SliverGap
          ? this
          : SliverPadding(
              key: key,
              padding: padding,
              sliver: sliverAdapt ? SliverToBoxAdapter(child: this) : this,
            );

  Widget padSliverAll(double padding, {bool sliverAdapt = false, Key? key}) =>
      padSliver(EdgeInsets.all(padding), sliverAdapt: sliverAdapt, key: key);
  Widget padSliverHorizontal(double horizontal, {bool sliverAdapt = false}) =>
      padSliver(
        EdgeInsets.symmetric(horizontal: horizontal),
        sliverAdapt: sliverAdapt,
        key: key,
      );
  Widget padSliverVertical(
    double vertical, {
    bool sliverAdapt = false,
    Key? key,
  }) =>
      padSliver(
        EdgeInsets.symmetric(vertical: vertical),
        sliverAdapt: sliverAdapt,
        key: key,
      );
  Widget padSliverStart(double start, {bool sliverAdapt = false, Key? key}) =>
      padSliver(
        EdgeInsetsDirectional.only(start: start),
        sliverAdapt: sliverAdapt,
        key: key,
      );
  Widget padSliverEnd(double end, {bool sliverAdapt = false, Key? key}) =>
      padSliver(
        EdgeInsetsDirectional.only(end: end),
        sliverAdapt: sliverAdapt,
        key: key,
      );
  Widget padSliverTop(double top, {bool sliverAdapt = false, Key? key}) =>
      padSliver(
        EdgeInsetsDirectional.only(top: top),
        sliverAdapt: sliverAdapt,
        key: key,
      );
  Widget padSliverBottom(double bottom, {bool sliverAdapt = false, Key? key}) =>
      padSliver(
        EdgeInsetsDirectional.only(bottom: bottom),
        sliverAdapt: sliverAdapt,
        key: key,
      );

  Widget padSliver16H({bool sliverAdapt = false, Key? key}) =>
      padSliver(k16HPadding, sliverAdapt: sliverAdapt, key: key);
  Widget padSliver16A({bool sliverAdapt = false, Key? key}) =>
      padSliver(k16APadding, sliverAdapt: sliverAdapt, key: key);
  Widget padSliver16H8V({bool sliverAdapt = false, Key? key}) =>
      padSliver(k16H8VPadding, sliverAdapt: sliverAdapt, key: key);
  Widget padSliver8V({bool sliverAdapt = false, Key? key}) =>
      padSliver(k8VPadding, sliverAdapt: sliverAdapt, key: key);
  Widget padSliver8H({bool sliverAdapt = false, Key? key}) =>
      padSliver(k8HPadding, sliverAdapt: sliverAdapt, key: key);
  Widget padSliver12V({bool sliverAdapt = false, Key? key}) =>
      padSliver(k12VPadding, sliverAdapt: sliverAdapt, key: key);
  Widget padSliver16H12V({bool sliverAdapt = false, Key? key}) =>
      padSliver(k16H12VPadding, sliverAdapt: sliverAdapt, key: key);
  Widget padSliver16H4V({bool sliverAdapt = false, Key? key}) =>
      padSliver(k16H4VPadding, sliverAdapt: sliverAdapt, key: key);
  Widget padSliver24H({bool sliverAdapt = false, Key? key}) =>
      padSliver(k24HPadding, sliverAdapt: sliverAdapt, key: key);

  // Conditional padding
  Widget padIf(bool condition, EdgeInsetsGeometry padding) =>
      condition ? pad(padding) : this;
  Widget pad16HIf(bool condition) => padIf(condition, k16HPadding);
  Widget pad16AIf(bool condition) => padIf(condition, k16APadding);
  Widget pad16H8VIf(bool condition) => padIf(condition, k16H8VPadding);
  Widget pad8VIf(bool condition) => padIf(condition, k8VPadding);
  Widget pad8HIf(bool condition) => padIf(condition, k8HPadding);
  Widget pad12VIf(bool condition) => padIf(condition, k12VPadding);
  Widget pad16H12VIf(bool condition) => padIf(condition, k16H12VPadding);
  Widget pad16H4VIf(bool condition) => padIf(condition, k16H4VPadding);
  Widget pad24HIf(bool condition) => padIf(condition, k24HPadding);

  // Safe Area
  Widget safeArea([EdgeInsets min = EdgeInsets.zero]) =>
      SafeArea(minimum: min, child: this);
  Widget safeAreaIf(bool condition, [EdgeInsets min = EdgeInsets.zero]) =>
      condition ? safeArea(min) : this;
  Widget safeTop([EdgeInsets min = EdgeInsets.zero]) => SafeArea(
        minimum: min,
        bottom: false,
        left: false,
        right: false,
        child: this,
      );
  Widget safeBottom([EdgeInsets min = EdgeInsets.zero]) => SafeArea(
        minimum: min,
        top: false,
        left: false,
        right: false,
        child: this,
      );
  Widget safeLeft([EdgeInsets min = EdgeInsets.zero]) => SafeArea(
        minimum: min,
        top: false,
        bottom: false,
        right: false,
        child: this,
      );
  Widget safeRight([EdgeInsets min = EdgeInsets.zero]) => SafeArea(
        minimum: min,
        top: false,
        bottom: false,
        left: false,
        child: this,
      );
  Widget safeAreaOnly({
    EdgeInsets minPadding = EdgeInsets.zero,
    bool top = false,
    bool bottom = false,
    bool left = false,
    bool right = false,
  }) =>
      SafeArea(
        minimum: minPadding,
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: this,
      );
  Widget safeHorizontal([EdgeInsets min = EdgeInsets.zero]) =>
      SafeArea(minimum: min, top: false, bottom: false, child: this);
  Widget safeVertical([EdgeInsets min = EdgeInsets.zero]) =>
      SafeArea(minimum: min, left: false, right: false, child: this);
  Widget sliverSafeArea([EdgeInsets min = EdgeInsets.zero]) =>
      SliverSafeArea(minimum: min, sliver: this);
  Widget sliverSafeTop([EdgeInsets min = EdgeInsets.zero]) => SliverSafeArea(
        minimum: min,
        sliver: this,
        bottom: false,
        left: false,
        right: false,
      );
  Widget sliverSafeBottom([EdgeInsets min = EdgeInsets.zero]) => SliverSafeArea(
        minimum: min,
        sliver: this,
        top: false,
        left: false,
        right: false,
      );
  Widget sliverSafeLeft([EdgeInsets min = EdgeInsets.zero]) => SliverSafeArea(
        minimum: min,
        sliver: this,
        top: false,
        bottom: false,
        right: false,
      );
  Widget sliverSafeRight([EdgeInsets min = EdgeInsets.zero]) => SliverSafeArea(
        minimum: min,
        sliver: this,
        top: false,
        bottom: false,
        left: false,
      );
  Widget sliverSafeHorizontal([EdgeInsets min = EdgeInsets.zero]) =>
      SliverSafeArea(minimum: min, sliver: this, top: false, bottom: false);
}

extension ListPaddingX on Iterable<Widget> {
  List<Widget> padEach(EdgeInsetsGeometry padding) =>
      mapToList((_, widget) => widget is Gap ? widget : widget.pad(padding));
  List<Widget> padBottomEach(double bottom) =>
      mapToList((_, widget) => widget.padBottom(bottom));
  List<Widget> padTopEach(double top) =>
      mapToList((_, widget) => widget.padTop(top));
  List<Widget> padEndEach(double right) =>
      mapToList((_, widget) => widget.padEnd(right));
  List<Widget> padStartEach(double left) =>
      mapToList((_, widget) => widget.padStart(left));
  List<Widget> padHorizontalEach(double horizontal) =>
      mapToList((_, widget) => widget.padHorizontal(horizontal));
  List<Widget> padVerticalEach(double vertical) =>
      mapToList((_, widget) => widget.padVertical(vertical));
  List<Widget> padAllEach(double padding) =>
      mapToList((_, widget) => widget.padAll(padding));
  List<Widget> padEach16H() => padEach(k16HPadding);
  List<Widget> padEach16A() => padEach(k16APadding);
  List<Widget> padEach16H8V() => padEach(k16H8VPadding);
  List<Widget> padEach8V() => padEach(k8VPadding);
  List<Widget> padEach8H() => padEach(k8HPadding);
  List<Widget> padEach12V() => padEach(k12VPadding);
  List<Widget> padEach16H12V() => padEach(k16H12VPadding);
  List<Widget> padEach16H4V() => padEach(k16H4VPadding);
  List<Widget> padEach24H() => padEach(k24HPadding);

  // Slivers
  List<Widget> padEachSliver(EdgeInsetsGeometry padding) =>
      mapToList((_, widget) => widget.padSliver(padding));
  List<Widget> padBottomEachSliver(double bottom) =>
      mapToList((_, widget) => widget.padSliverBottom(bottom));
  List<Widget> padTopEachSliver(double top) =>
      mapToList((_, widget) => widget.padSliverTop(top));
  List<Widget> padEndEachSliver(double right) =>
      mapToList((_, widget) => widget.padSliverEnd(right));
  List<Widget> padStartEachSliver(double left) =>
      mapToList((_, widget) => widget.padSliverStart(left));
  List<Widget> padHorizontalEachSliver(double horizontal) =>
      mapToList((_, widget) => widget.padSliverHorizontal(horizontal));
  List<Widget> padVerticalEachSliver(double vertical) =>
      mapToList((_, widget) => widget.padSliverVertical(vertical));
  List<Widget> padAllEachSliver(double padding) =>
      mapToList((_, widget) => widget.padSliverAll(padding));

  List<Widget> padEachSliver16H() => padEachSliver(k16HPadding);
  List<Widget> padEachSliver16A() => padEachSliver(k16APadding);
  List<Widget> padEachSliver16H8V() => padEachSliver(k16H8VPadding);
  List<Widget> padEachSliver8V() => padEachSliver(k8VPadding);
  List<Widget> padEachSliver8H() => padEachSliver(k8HPadding);
  List<Widget> padEachSliver12V() => padEachSliver(k12VPadding);
  List<Widget> padEachSliver16H12V() => padEachSliver(k16H12VPadding);
  List<Widget> padEachSliver16H4V() => padEachSliver(k16H4VPadding);
  List<Widget> padEachSliver24H() => padEachSliver(k24HPadding);
}

extension ConstraintX on Widget {
  Widget constrain(BoxConstraints constraints) => this is Gap
      ? this
      : ConstrainedBox(
          constraints: constraints,
          child: this,
        );
  Widget constrainIf(bool condition, BoxConstraints constraints) =>
      condition ? constrain(constraints) : this;

  Widget withMaxWidth(double width) =>
      constrain(BoxConstraints(maxWidth: width));
  Widget withMaxHeight(double height) =>
      constrain(BoxConstraints(maxHeight: height));
  Widget withMinWidth(double width) =>
      constrain(BoxConstraints(minWidth: width));
  Widget withMinHeight(double height) =>
      constrain(BoxConstraints(minHeight: height));
  Widget tight({double? width, double? height}) =>
      constrain(BoxConstraints.tightFor(width: width, height: height));
  Widget tightIfFinite({
    double width = double.infinity,
    double height = double.infinity,
  }) =>
      constrain(BoxConstraints.tightForFinite(width: width, height: height));

  Widget withMaxWidthIf(bool condition, double width) =>
      constrainIf(condition, BoxConstraints(maxWidth: width));
  Widget withMaxHeightIf(bool condition, double height) =>
      constrainIf(condition, BoxConstraints(maxHeight: height));
  Widget withMinWidthIf(bool condition, double width) =>
      constrainIf(condition, BoxConstraints(minWidth: width));
  Widget withMinHeightIf(bool condition, double height) =>
      constrainIf(condition, BoxConstraints(minHeight: height));

  Widget concentrated() => withMaxWidth(400.0);
  Widget readableWidth() => withMaxWidth(500.0);
  Widget narrowWidth() => withMaxWidth(600.0);
  Widget intrinsicWidth() => IntrinsicWidth(child: this);
  Widget intrinsicHeight() => IntrinsicHeight(child: this);
}

extension ListConstrainX on Iterable<Widget> {
  List<Widget> constrainEach(BoxConstraints constraints) => mapToList(
        (_, widget) => widget is Gap ? widget : widget.constrain(constraints),
      );
  List<Widget> constrainEachWithMaxWidth(double width) =>
      constrainEach(BoxConstraints(maxWidth: width));
  List<Widget> constrainEachWithMaxHeight(double height) =>
      constrainEach(BoxConstraints(maxHeight: height));
  List<Widget> constrainEachWithMinWidth(double width) =>
      constrainEach(BoxConstraints(minWidth: width));
  List<Widget> constrainEachWithMinHeight(double height) =>
      constrainEach(BoxConstraints(minHeight: height));
  List<Widget> constrainEachTight({double? width, double? height}) =>
      constrainEach(BoxConstraints.tightFor(width: width, height: height));
  List<Widget> constrainEachTightIfFinite({
    double width = double.infinity,
    double height = double.infinity,
  }) =>
      constrainEach(
        BoxConstraints.tightForFinite(width: width, height: height),
      );

  List<Widget> centerEach() =>
      mapToList((_, widget) => widget is Gap ? widget : Center(child: widget));

  List<Widget> readableWidthEach() => constrainEachWithMaxWidth(500.0);
}

extension PreferredSizeX on Widget {
  PreferredSizeWidget preferredSize(double width, double height) =>
      PreferredSize(
        preferredSize: Size(width, height),
        child: this,
      );
}

extension PositionedX on Widget {
  Widget positioned({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) =>
      Positioned(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        width: width,
        height: height,
        child: this,
      );

  Widget positionedFill({
    double? left = 0.0,
    double? top = 0.0,
    double? right = 0.0,
    double? bottom = 0.0,
  }) =>
      Positioned.fill(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        child: this,
      );
}

extension FlexX on Widget {
  Widget expand([int flex = 1]) => Expanded(flex: flex, child: this);
  Widget flexible([int flex = 1]) => Flexible(flex: flex, child: this);
  Widget expandIf(bool condition, [int flex = 1]) =>
      condition ? expand(flex) : this;
  Widget flexibleIf(bool condition, [int flex = 1]) =>
      condition ? flexible(flex) : this;
}

extension AlignX on Widget {
  Widget align(AlignmentGeometry alignment) =>
      Align(alignment: alignment, child: this);
  Widget alignIf(bool condition, AlignmentGeometry alignment) =>
      condition ? align(alignment) : this;
  Widget center() => align(Alignment.center);
  Widget centerIf(bool condition) => alignIf(condition, Alignment.center);
  Widget alignTopCenter() => align(Alignment.topCenter);
  Widget alignTopCenterIf(bool condition) =>
      alignIf(condition, Alignment.topCenter);
  Widget alignBottomCenter() => align(Alignment.bottomCenter);
  Widget alignBottomCenterIf(bool condition) =>
      alignIf(condition, Alignment.bottomCenter);
  Widget alignTopLeft() => align(Alignment.topLeft);
  Widget alignTopLeftIf(bool condition) =>
      alignIf(condition, Alignment.topLeft);
  Widget alignTopRight() => align(Alignment.topRight);
  Widget alignTopRightIf(bool condition) =>
      alignIf(condition, Alignment.topRight);
  Widget alignBottomLeft() => align(Alignment.bottomLeft);
  Widget alignBottomLeftIf(bool condition) =>
      alignIf(condition, Alignment.bottomLeft);
  Widget alignBottomRight() => align(Alignment.bottomRight);
  Widget alignBottomRightIf(bool condition) =>
      alignIf(condition, Alignment.bottomRight);
  Widget alignTopStart() => align(AlignmentDirectional.topStart);
  Widget alignTopStartIf(bool condition) =>
      alignIf(condition, AlignmentDirectional.topStart);
  Widget alignTopEnd() => align(AlignmentDirectional.topEnd);
  Widget alignTopEndIf(bool condition) =>
      alignIf(condition, AlignmentDirectional.topEnd);
  Widget alignBottomStart() => align(AlignmentDirectional.bottomStart);
  Widget alignBottomStartIf(bool condition) =>
      alignIf(condition, AlignmentDirectional.bottomStart);
  Widget alignBottomEnd() => align(AlignmentDirectional.bottomEnd);
  Widget alignBottomEndIf(bool condition) =>
      alignIf(condition, AlignmentDirectional.bottomEnd);
  Widget alignCenterStart() => align(AlignmentDirectional.centerStart);
  Widget alignCenterStartIf(bool condition) =>
      alignIf(condition, AlignmentDirectional.centerStart);
  Widget alignCenterEnd() => align(AlignmentDirectional.centerEnd);
  Widget alignCenterEndIf(bool condition) =>
      alignIf(condition, AlignmentDirectional.centerEnd);
}

extension SizingX on Widget {
  Widget withWidth(double width) => SizedBox(width: width, child: this);
  Widget maybeWithWidth(double? width) =>
      width == null ? this : withWidth(width);
  Widget withHeight(double height) => SizedBox(height: height, child: this);
  Widget maybeWithHeight(double? height) =>
      height == null ? this : withHeight(height);
  Widget withSize(double width, double height) =>
      SizedBox(width: width, height: height, child: this);
  Widget square(double size) => withSize(size, size);
  Widget shrink() => SizedBox.shrink(child: this);
  Widget withSizeIf(bool condition, double width, double height) =>
      condition ? withSize(width, height) : this;
  Widget withWidthIf(bool condition, double width) =>
      condition ? withWidth(width) : this;
  Widget withHeightIf(bool condition, double height) =>
      condition ? withHeight(height) : this;
  Widget aspectRatio(double aspectRatio) => AspectRatio(
        aspectRatio: aspectRatio,
        child: this,
      );
  Widget aspectRatioIf(bool condition, double aspectRatio) =>
      condition ? this.aspectRatio(aspectRatio) : this;
}

extension SizingListX on Iterable<Widget> {
  List<Widget> withWidthEach(double width) =>
      mapToList((_, widget) => widget.withWidth(width));
  List<Widget> withHeightEach(double height) =>
      mapToList((_, widget) => widget.withHeight(height));
  List<Widget> withSizeEach(double width, double height) =>
      mapToList((_, widget) => widget.withSize(width, height));
  List<Widget> withSizeEachIf(
    bool Function(Widget child) condition,
    double width,
    double height,
  ) =>
      mapToList(
        (_, widget) => widget.withSizeIf(condition(widget), width, height),
      );
  List<Widget> withWidthEachIf(
    bool Function(Widget child) condition,
    double width,
  ) =>
      mapToList((_, widget) => widget.withWidthIf(condition(widget), width));
  List<Widget> withHeightEachIf(
    bool Function(Widget child) condition,
    double height,
  ) =>
      mapToList((_, widget) => widget.withHeightIf(condition(widget), height));
}

extension SliverX on Widget {
  Widget asSliver() => SliverToBoxAdapter(child: this);
  Widget asSliverIf(bool condition) => condition ? asSliver() : this;
}

extension SelectionX on Widget {
  Widget selectableIfWebOrDesktop() =>
      Target.isWeb || Target.isDesktop ? SelectionArea(child: this) : this;
  Widget selectableIfWeb() => Target.isWeb ? SelectionArea(child: this) : this;
  Widget selectable() => SelectionArea(child: this);
  Widget preventSelect() => SelectionContainer.disabled(child: this);
}

extension ScalingX on num {
  double scaleWithText(BuildContext context) =>
      MediaQuery.textScalerOf(context).scale(toDouble());
}

extension DirectionalityX on BuildContext {
  bool get ltr => Directionality.of(this) == TextDirection.ltr;
  bool get rtl => Directionality.of(this) == TextDirection.rtl;
}

class DirectionalPositioned extends StatelessWidget {
  const DirectionalPositioned({
    this.top,
    this.start,
    this.bottom,
    this.end,
    this.width,
    this.height,
    required this.child,
    super.key,
  });

  final double? top, start, bottom, end, width, height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.directional(
      textDirection: Directionality.of(context),
      top: top,
      start: start,
      bottom: bottom,
      end: end,
      width: width,
      height: height,
      child: child,
    );
  }
}
