import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../components.dart';

class MaybeBackButton extends StatefulWidget {
  const MaybeBackButton({
    this.closeInterceptor,
    this.forceUseCloseButton = false,
    this.size,
    super.key,
  }) : _elevated = false;

  const MaybeBackButton.elevated({
    this.closeInterceptor,
    this.forceUseCloseButton = false,
    this.size,
    super.key,
  }) : _elevated = true;

  /// If this returns true, the modal will close.
  /// If this returns false, the modal will not close.
  ///
  final FutureOr<bool> Function(BuildContext context)? closeInterceptor;
  final bool forceUseCloseButton;
  final double? size;
  final bool _elevated;

  static bool willShow(BuildContext context) {
    final parentRoute = ModalRoute.of(context);
    return parentRoute?.impliesAppBarDismissal ?? false;
  }

  static bool useCloseButton(BuildContext context) {
    final parentRoute = ModalRoute.of(context);
    return parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
  }

  @override
  State<MaybeBackButton> createState() => _MaybeBackButtonState();
}

class _MaybeBackButtonState extends State<MaybeBackButton> {
  Future<void> _close(BuildContext context) async {
    final shouldClose = widget.closeInterceptor == null ||
        await widget.closeInterceptor!(context);
    if (!context.mounted) {
      return;
    }
    if (shouldClose) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = MaterialLocalizations.of(context);
    final useCloseButton =
        widget.forceUseCloseButton || MaybeBackButton.useCloseButton(context);
    if (MaybeBackButton.willShow(context)) {
      final child = Center(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: CButton(
              tooltip: useCloseButton
                  ? localizations.closeButtonTooltip
                  : localizations.backButtonTooltip,
              cornerRadius: widget._elevated ? 100.0 : 8.0,
              onTap: () => _close(context),
              child: Icon(
                useCloseButton ? CupertinoIcons.clear : CupertinoIcons.back,
                size: widget.size,
                color: widget._elevated
                    ? theme.resolveColor(Colors.black87, Colors.white)
                    : null,
              ),
            ),
          ),
        ),
      );

      if (widget._elevated) {
        return Center(
          child: BouncingObject(
            onTap: () => _close(context),
            child: Container(
              decoration: ShapeDecoration(
                shape: const PContinuousRectangleBorder(cornerRadius: 8.0),
                color:
                    Theme.of(context).resolveColor(Colors.white, PColors.dark3),
                shadows: PDecors.focusedShadows(),
              ),
              height: 36.0,
              width: 36.0,
              child: Center(
                child: Padding(
                  padding: useCloseButton
                      ? EdgeInsets.zero
                      : const EdgeInsets.only(right: 2.0),
                  child: IgnorePointer(
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      }

      return child;
    }
    return const SizedBox.shrink();
  }
}
