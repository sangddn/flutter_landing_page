import 'package:flutter/material.dart';

import '../../router/router.dart';
import '../components.dart';

typedef ScrollPageBuilder = Widget Function(
  BuildContext context,
  ScrollController scrollController,
);

class ResponsiveLayoutWithNav extends StatelessWidget {
  const ResponsiveLayoutWithNav({
    required this.builder,
    super.key,
  });

  final ScrollPageBuilder builder;

  @override
  Widget build(BuildContext context) {
    return _MobileScaffold(builder: builder);
  }
}

class _MobileScaffold extends StatefulWidget {
  const _MobileScaffold({
    required this.builder,
  });

  final ScrollPageBuilder builder;

  @override
  State<_MobileScaffold> createState() => __MobileScaffoldState();
}

class __MobileScaffoldState extends State<_MobileScaffold> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = PrimaryScrollController(
      controller: _scrollController,
      child: Scaffold(
        primary: false,
        body: widget.builder(context, _scrollController),
        bottomNavigationBar: const BottomNavigation(),
        extendBody: true,
        resizeToAvoidBottomInset: false,
      ),
    );

    return PStackedTransition(child: child);
  }
}

/// A version of [IndexedStack] that laziy builds its children.
///
/// This is useful for when you have a lot of children, and you don't want to
/// build them all at once, but want to retain all the built children in memory.
///
class LazyIndexedStack extends StatefulWidget {
  const LazyIndexedStack({
    this.textDirection,
    this.alignment = AlignmentDirectional.topStart,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
    this.maxChildrenKeptAlive = 3,
    required this.index,
    required this.children,
    super.key,
  });

  final TextDirection? textDirection;
  final AlignmentGeometry alignment;
  final StackFit fit;
  final Clip clipBehavior;
  final int? index;
  final int maxChildrenKeptAlive;
  final List<Widget> children;

  @override
  State<LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  late final _activatedList = List<bool>.generate(
    widget.children.length,
    (int i) => i == widget.index,
  );

  @override
  void didUpdateWidget(LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _activateIndex(widget.index);
    }
  }

  void _activateIndex(int? index) {
    if (index == null) {
      return;
    }
    if (!_activatedList[index]) {
      setState(() {
        _activatedList[index] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lazyChildren = List<Widget>.generate(
      widget.children.length,
      (int i) {
        if (_activatedList[i]) {
          return widget.children[i];
        }
        return const SizedBox.shrink();
      },
    );

    return IndexedStack(
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      sizing: widget.fit,
      index: widget.index,
      children: lazyChildren,
    );
  }
}
