part of 'media_page_view.dart';

enum _GestureType {
  pan,
  scale,
}

class _MPVMediaWrapper extends StatelessWidget {
  const _MPVMediaWrapper();

  @override
  Widget build(BuildContext context) {
    Widget child = context.getIsImage()
        ? const _MPVImageWrapper()
        : const _MPVVideoWrapper();

    if (context.getHeroTag() case final tag?) {
      // final index = context.getIndex();
      // final currentPage = context.select((PageController controller) {
      //   try {
      //     return controller.page;
      //   } catch (e) {
      //     return index;
      //   }
      // });

      child = Hero(
        tag: tag,
        // flightShuttleBuilder:
        //     currentPage == null || (currentPage - index).abs() > 0.4
        //         ? (_, __, ___, ____, _____) => const SizedBox()
        //         : null,
        child: child,
      );
    }

    return _InteractiveWrapper(child: child);
  }
}

class _InteractiveWrapper extends StatefulWidget {
  const _InteractiveWrapper({required this.child});

  final Widget child;

  @override
  State<_InteractiveWrapper> createState() => _InteractiveWrapperState();
}

class _InteractiveWrapperState extends State<_InteractiveWrapper>
    with TickerProviderStateMixin {
  final _dismissThreshold = 90.0;
  Offset _offset = Offset.zero;
  double get _currentVOffset => _offset.dy;
  _GestureType? _gestureType;

  late final _offsetAnimationController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final _offsetCurve =
      CurvedAnimation(parent: _offsetAnimationController, curve: Curves.ease);
  late var _offsetAnimation =
      Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(_offsetCurve);

  final _transformationController = TransformationController();
  late final _scaleAnimationController = AnimationController(
    duration: const Duration(milliseconds: 350),
    vsync: this,
  );
  late final _scaleCurve = CurvedAnimation(
    parent: _scaleAnimationController,
    curve: Curves.ease,
  );
  late var _scaleAnimation = Matrix4Tween(
    begin: Matrix4.identity(),
    end: Matrix4.identity(),
  ).animate(_scaleCurve);
  double get _currentScale =>
      _transformationController.value.getMaxScaleOnAxis().toPrecision(2);

  EdgeInsetsGeometry _getPadding(Offset offset) {
    final vOffset = offset.dy;
    final hOffset = offset.dx;
    return EdgeInsets.only(
      top: vOffset < 0.0 ? 0.0 : vOffset,
      bottom: vOffset > 0.0 ? 0.0 : -vOffset,
      left: hOffset < 0.0 ? 0.0 : hOffset,
      right: hOffset > 0.0 ? 0.0 : -hOffset,
    );
  }

  void _animateOffsetBack() {
    _offsetAnimation = Tween<Offset>(
      begin: _offset,
      end: Offset.zero,
    ).animate(_offsetCurve);
    _offsetAnimationController
        .forward(from: 0)
        .then((_) => _setOffset(Offset.zero));
  }

  void _animateScaleBack() {
    _scaleAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(_scaleCurve);
    _scaleAnimationController.forward(from: 0);
  }

  void _onScaleAnimationChanged() {
    if (_scaleAnimationController.isAnimating) {
      _transformationController.value = _scaleAnimation.value;
    }
  }

  void _onOffsetAnimationChanged() {
    if (_offsetAnimationController.isAnimating) {
      context.read<ValueNotifier<double>>().value =
          (1.0 - (_offsetAnimation.value.dy.abs() / _dismissThreshold) / 2)
              .clamp(0.0, 1.0);
    }
  }

  void _setOffset(Offset newOffset) {
    maybeSetState(() {
      _offset = newOffset;
    });
    _onOffsetChanged();
  }

  void _onOffsetChanged() {
    if (!_offsetAnimationController.isAnimating) {
      context.read<ValueNotifier<double>>().value = Curves.ease.transform(
        (1.0 - (_currentVOffset.abs() / _dismissThreshold) / 2).clamp(0.0, 1.0),
      );
    }
  }

  void _onPanUpdate(ScaleUpdateDetails details) {
    if (context.shouldBlockVerticalDrag) {
      if (_offset != Offset.zero) {
        _animateOffsetBack();
      }
      return;
    }
    final lastVOffset = _currentVOffset.abs();
    final delta = details.focalPointDelta;
    _setOffset(_offset + delta);
    if (lastVOffset < _dismissThreshold &&
        _currentVOffset.abs() >= _dismissThreshold) {
      // Haptics.selection();
    }
    if (lastVOffset >= _dismissThreshold &&
        _currentVOffset.abs() < _dismissThreshold) {
      // Haptics.selection();
    }
  }

  void _onPanEnd(ScaleEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond;
    // If the velocity is high enough, dismiss the image right away
    if (velocity.dy > 1200.0) {
      Navigator.of(context).pop();
      return;
    }
    if (_currentVOffset.abs() > _dismissThreshold) {
      Navigator.of(context).pop();
    } else {
      _animateOffsetBack();
    }
  }

  // Decide which type of gesture this is by comparing the amount of scale
  // and rotation in the gesture, if any. Scale starts at 1 and rotation
  // starts at 0. Pan will have no scale and no rotation because it uses only one
  // finger.
  _GestureType _getGestureType(ScaleUpdateDetails details) {
    final scale = details.scale;
    final rotation = details.rotation;
    if ((scale - 1).abs() > rotation.abs()) {
      return _GestureType.scale;
    } else {
      return _GestureType.pan;
    }
  }

  @override
  void initState() {
    super.initState();
    _offsetAnimationController.addListener(_onOffsetAnimationChanged);
    _scaleAnimationController.addListener(_onScaleAnimationChanged);
  }

  @override
  void dispose() {
    _offsetAnimationController.dispose();
    _scaleAnimationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = widget.child;

    return InteractiveViewer(
      transformationController: _transformationController,
      panEnabled: false,
      clipBehavior: Clip.none,
      maxScale: 7.0,
      onInteractionStart: (details) {
        if (context.shouldBlockVerticalDrag || _offset != Offset.zero) {
          return;
        }
        _gestureType = null;
      },
      onInteractionUpdate: (details) {
        if (_offsetAnimationController.isAnimating) {
          return;
        }
        if (_gestureType == _GestureType.pan) {
          // When a gesture first starts, it sometimes has no change in scale and
          // rotation despite being a two-finger gesture. Here the gesture is
          // allowed to be reinterpreted as its correct type after originally
          // being marked as a pan.
          _gestureType = _getGestureType(details);
        } else {
          _gestureType ??= _getGestureType(details);
        }

        switch (_gestureType!) {
          case _GestureType.pan:
            // We only care about the pan gesture. If the image is zoomed in,
            // a scale gesture or animation is at play, which will be handled
            // by [InteractiveViewer] itself.
            if (_currentScale > 1.0) {
              return;
            } else if (details.pointerCount == 1) {
              _onPanUpdate(details);
            }
          case _GestureType.scale:
            if (_scaleAnimationController.isAnimating) {
              _scaleAnimationController.stop();
              return;
            }
            // [InteractiveViewer] handles the rest
            return;
        }
      },
      onInteractionEnd: (details) {
        if (_currentScale > 1.0) {
          _animateScaleBack();
          return;
        }
        if (_gestureType == _GestureType.pan) {
          _onPanEnd(details);
        }
      },
      child: Center(
        child: AnimatedBuilder(
          animation: _offsetAnimation,
          builder: (context, child) {
            if (_offsetAnimationController.isAnimating) {
              return Padding(
                padding: _getPadding(_offsetAnimation.value),
                child: child,
              );
            }
            return Padding(
              padding: _getPadding(_offset),
              child: child,
            );
          },
          child: child,
        ),
      ),
    );
  }
}
