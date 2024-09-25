import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _kDefaultSpread = 0.0872665;

class SwipeDeck extends StatefulWidget {
  const SwipeDeck({
    super.key,
    required this.widgets,
    this.initialIndex = 0,
    this.emptyIndicator = const SizedBox.shrink(),
    this.onChange,
    this.aspectRatio = 1.0,
    this.cardSpreadInDegrees = 5.0,
    this.onSwipeRight,
    this.onSwipeLeft,
  });

  final List<Widget> widgets;
  final int initialIndex;
  final Widget emptyIndicator;
  final double aspectRatio, cardSpreadInDegrees;
  final ValueChanged<int>? onChange;
  final VoidCallback? onSwipeRight, onSwipeLeft;

  @override
  State<SwipeDeck> createState() => _SwipeDeckState();
}

class _SwipeDeckState extends State<SwipeDeck> {
  final borderRadius = BorderRadius.circular(20.0);
  List<Widget> leftStackRaw = [], rightStackRaw = [];
  List<MapEntry<int, Widget>> leftStack = [], rightStack = [];
  Widget? currentWidget, contestantImage, removedImage;
  bool draggingLeft = false, onHold = false, beginDrag = false;
  double transformLevel = 0,
      removeTransformLevel = 0,
      spreadInRadians = _kDefaultSpread;
  Timer? stackTimer, repositionTimer;

  @override
  void dispose() {
    super.dispose();
    stackTimer?.cancel();
    repositionTimer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    if (widget.widgets.isEmpty) {
      return;
    }

    spreadInRadians =
        widget.cardSpreadInDegrees.clamp(2.0, 10.0) * (math.pi / 180);

    leftStackRaw = widget.widgets.sublist(widget.initialIndex);
    rightStackRaw = widget.widgets.sublist(0, widget.initialIndex);

    currentWidget = leftStackRaw.first;
    leftStackRaw.removeAt(0);
    contestantImage = leftStackRaw.first;

    leftStack = leftStackRaw.asMap().entries.toList();
    rightStack = rightStackRaw.asMap().entries.toList();
  }

  @override
  void didUpdateWidget (SwipeDeck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.widgets, widget.widgets)) {
      leftStackRaw = widget.widgets.sublist(widget.initialIndex);
      rightStackRaw = widget.widgets.sublist(0, widget.initialIndex);

      currentWidget = leftStackRaw.first;
      leftStackRaw.removeAt(0);
      contestantImage = leftStackRaw.first;

      leftStack = leftStackRaw.asMap().entries.toList();
      rightStack = rightStackRaw.asMap().entries.toList();
      setState(() {});
    }
  }

  void refreshLHStacks() {
    if (stackTimer != null && stackTimer!.isActive) {
      return;
    }
    leftStack = leftStackRaw.asMap().entries.toList();
    rightStack = rightStackRaw.asMap().entries.toList();
    onHold = true;
    removeTransformLevel = transformLevel;
    transformLevel = 0;
    final double part = removeTransformLevel / 50;
    stackTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (removeTransformLevel >= part) {
        removeTransformLevel -= part;
        setState(() {});
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      stackTimer!.cancel();
      removedImage = const Center();
      removeTransformLevel = math.max(removeTransformLevel, 0);
      setState(() {
        onHold = false;
      });
    });
  }

  void returnToPosition() {
    if (repositionTimer != null && repositionTimer!.isActive) {
      return;
    }
    onHold = true;
    final double part = transformLevel / 10;
    repositionTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (transformLevel >= part) {
        transformLevel -= part;
      }
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      repositionTimer?.cancel();
      transformLevel = math.max(transformLevel, 0);
      setState(() {
        onHold = false;
      });
    });
  }

  Widget wrapWithContainer(Widget widget, double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: widget,
    );
  }

  void postOnChange(int index) {
    widget.onChange?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final bool dragLimit = transformLevel > 0.8;
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          TransformData(spreadRadians: spreadInRadians),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageWidth = constraints.maxWidth / 2;
          final imageHeight = widget.aspectRatio * imageWidth;
          final double centerWidth = constraints.maxWidth / 2;
          if (widget.widgets.isEmpty) {
            return widget.emptyIndicator;
          }
          return GestureDetector(
            onPanDown: (downDetails) {
              if ((centerWidth - downDetails.localPosition.dx).abs() < 50) {
                beginDrag = true;
                setState(() {});
              }
            },
            onPanEnd: (panEnd) {
              beginDrag = false;
              returnToPosition();
            },
            onPanUpdate: (panDetails) {
              if (onHold || currentWidget == null || !beginDrag) {
                return;
              }
              draggingLeft = centerWidth > panDetails.localPosition.dx;

              if ((draggingLeft && rightStackRaw.isEmpty) ||
                  (!draggingLeft && leftStackRaw.isEmpty)) {
                return;
              }

              transformLevel =
                  (centerWidth - panDetails.localPosition.dx).abs() /
                      centerWidth;
              context.read<TransformData>().setTransformDelta(transformLevel);
              context.read<TransformData>().isLeftDrag = draggingLeft;
              if (draggingLeft) {
                if (rightStack.isEmpty) {
                  return;
                }
                contestantImage = rightStack.last.value;
              } else {
                if (leftStack.isEmpty) {
                  return;
                }
                contestantImage = leftStack.first.value;
              }
              bool changed = false;
              if (transformLevel > 0.8) {
                removedImage = currentWidget;
                if (draggingLeft) {
                  if (rightStackRaw.isEmpty) {
                    return;
                  }
                  leftStackRaw.insert(0, currentWidget!);
                  currentWidget = rightStackRaw.last;
                  rightStackRaw.removeLast();

                  changed = true;
                  if (rightStackRaw.isNotEmpty) {
                    contestantImage = rightStackRaw.last;
                  }
                } else {
                  if (leftStackRaw.isEmpty) {
                    return;
                  }
                  rightStackRaw.add(currentWidget!);
                  currentWidget = leftStackRaw.first;
                  leftStackRaw.removeAt(0);

                  changed = true;
                  if (leftStackRaw.isNotEmpty) {
                    contestantImage = leftStackRaw.first;
                  }
                }
                if (changed) {
                  draggingLeft
                      ? widget.onSwipeLeft?.call()
                      : widget.onSwipeRight?.call();
                  postOnChange(rightStackRaw.length);
                }
                refreshLHStacks();
              }
              setState(() {});
            },
            child: Center(
              child: Stack(
                children: [
                  ...rightStack.map(
                    (e) => _WidgetHolder(
                      width: imageWidth,
                      height: imageHeight,
                      image: e.value,
                      index: e.key,
                      isLeft: false,
                      lastIndex: rightStack.length - 1,
                    ),
                  ),
                  ...leftStack.map(
                    (e) => _WidgetHolder(
                      width: imageWidth,
                      height: imageHeight,
                      image: e.value,
                      index: e.key,
                      lastIndex: leftStack.length,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                      removeTransformLevel * (draggingLeft ? -90 : 90),
                      0,
                    ),
                    child: Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.rotationZ(
                        removeTransformLevel * (draggingLeft ? -0.5 : 0.5),
                      ),
                      child: SizedBox(
                        width: imageWidth,
                        height: imageHeight,
                        child: removedImage ?? const Center(),
                      ),
                    ),
                  ),
                  if (!dragLimit) ...[
                    Transform.scale(
                      scale: 1.0 + math.min(transformLevel, 0.02),
                      child: SizedBox(
                        width: imageWidth,
                        height: imageHeight,
                        child: contestantImage ?? const Center(),
                      ),
                    ),
                  ],
                  if (currentWidget != null) ...[
                    Transform.translate(
                      offset:
                          Offset(transformLevel * (draggingLeft ? -90 : 90), 0),
                      child: Transform.scale(
                        scale: math.max(0.8, 1 - transformLevel + 0.2),
                        child: Transform(
                          alignment: Alignment.bottomCenter,
                          transform: Matrix4.rotationZ(
                            transformLevel * (draggingLeft ? -0.5 : 0.5),
                          ),
                          child: Container(
                            width: imageWidth,
                            height: imageHeight,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ],
                              borderRadius: borderRadius,
                            ),
                            child: currentWidget,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (dragLimit) ...[
                    Transform.scale(
                      scale: 1.0 + math.min(transformLevel, 0.02),
                      child: SizedBox(
                        width: imageWidth,
                        height: imageHeight,
                        child: contestantImage ?? const Center(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WidgetHolder extends StatefulWidget {
  const _WidgetHolder({
    required this.width,
    required this.height,
    required this.image,
    required this.index,
    this.isLeft = true,
    this.lastIndex = 0,
  });

  final double width, height;
  final Widget image;
  final int index;
  final bool isLeft;
  final int lastIndex;

  @override
  _WidgetHolderState createState() => _WidgetHolderState();
}

class _WidgetHolderState extends State<_WidgetHolder> {
  late Widget childImage;

  @override
  void initState() {
    super.initState();
    childImage = SizedBox(
      width: widget.width,
      height: widget.height,
      child: widget.image,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TransformData transformData = context.watch<TransformData>();
    final double spread = transformData.spreadRadians;
    final double finalRotation = (widget.index <= widget.lastIndex - 3)
        ? (3 * spread)
        : ((widget.lastIndex - widget.index) * spread);
    final bool isLeft = transformData.isLeftDrag;
    final double scaleDifferential = 0.05 * transformData.transformDelta;
    return Transform.scale(
      scale: isLeft
          ? (widget.isLeft ? (1 - scaleDifferential) : 1 + scaleDifferential)
          : (widget.isLeft ? 1 + scaleDifferential : (1 - scaleDifferential)),
      child: Transform(
        alignment: Alignment.bottomCenter,
        transform:
            Matrix4.rotationZ(widget.isLeft ? -finalRotation : finalRotation),
        child: childImage,
      ),
    );
  }
}

class TransformData extends ChangeNotifier {
  TransformData({
    required this.spreadRadians,
  });

  double _tDelta = 0;
  double spreadRadians = _kDefaultSpread;

  bool isLeftDrag = false;

  double get transformDelta => _tDelta;
  void setTransformDelta(double newDelta) {
    _tDelta = newDelta;
    notifyListeners();
  }
}
