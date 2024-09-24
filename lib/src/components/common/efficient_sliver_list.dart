import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EfficientSliverList extends SliverMultiBoxAdaptorWidget {
  const EfficientSliverList({
    super.key,
    required super.delegate,
  });

  factory EfficientSliverList.builder({
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    Key? key,
  }) {
    return EfficientSliverList(
      key: key,
      delegate: SliverChildBuilderDelegate(
        itemBuilder,
        childCount: itemCount,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
      ),
    );
  }

  factory EfficientSliverList.list({
    required List<Widget> children,
    Key? key,
  }) {
    return EfficientSliverList(
      key: key,
      delegate: SliverChildListDelegate(children),
    );
  }

  @override
  SliverMultiBoxAdaptorElement createElement() =>
      SliverMultiBoxAdaptorElement(this, replaceMovedChildren: true);

  @override
  RenderSliverMultiBoxAdaptor createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return _RenderEfficientSliverList(childManager: element);
  }
}

class _RenderEfficientSliverList extends RenderSliverMultiBoxAdaptor {
  _RenderEfficientSliverList({required super.childManager});

  /// When true the layout offsets of children are the actual offsets. This
  /// will be true while scrolling from beginning to end without jumping out
  /// of cached area.
  bool _layoutOffsetIsEstimated = false;

  /// When sliver is scrolled away completely we rely on cached extent
  /// to provide consistent scrollExtent to viewport.
  double? _cachedExtent;

  double? _estimateExtent() {
    for (var child = lastChild; child != null; child = childBefore(child)) {
      // It is possible that child has no layout and will be removed by
      // collectGarbage.
      if (!child.hasSize) {
        continue;
      }
      final offset = childScrollOffset(child);
      if (offset != null) {
        final extent = (offset + paintExtentOf(child)) / (indexOf(child) + 1);
        _cachedExtent = extent > 0 ? extent : null;
        return extent;
      }
    }
    return _cachedExtent;
  }

  int? _estimatedOffsetChildIndex;
  double? _estimatedOffset;

  @override
  double? childScrollOffset(covariant RenderObject child) {
    for (var c = firstChild; c != null; c = childAfter(c)) {
      if (child == c) {
        return super.childScrollOffset(child);
      }
    }
    // Trying to query child offset of child that's not currently visible;
    // Assume this is from viewPort.getOffsetToReveal, in which case we'll
    // estimate the offset, but also remember the index and offset so that
    // we can possibly correct scrollOffset in next performLayout call.
    final offset = indexOf(child as RenderBox) * (_estimateExtent() ?? 0.0);
    _estimatedOffsetChildIndex = indexOf(child);
    _estimatedOffset = offset;
    return offset;
  }

  @override
  void performLayout() {
    /// Moves the layout offset of this and subsequent children by the given delta.
    void shiftLayoutOffsets(RenderBox? child, double delta) {
      while (child != null) {
        final data = child.parentData! as SliverMultiBoxAdaptorParentData;
        data.layoutOffset = data.layoutOffset! + delta;
        child = childAfter(child);
      }
    }

    final SliverConstraints constraints = this.constraints;
    final BoxConstraints childConstraints = constraints.asBoxConstraints();

    /// Layouts single child. Will return scrollOffset of the child, or `null`
    /// if scroll offset couldn't have been determined.
    ///
    /// Resets the layoutOffset of the child after.
    double? layoutChild(
      RenderBox child, {
      RenderBox? lastChildWithScrollOffset,
    }) {
      // If child offset can't be determined, there's no point laying out the child.
      if (childScrollOffset(child) == null &&
          lastChildWithScrollOffset == null) {
        return null;
      }
      if (childScrollOffset(child) == null) {
        final data = child.parentData! as SliverMultiBoxAdaptorParentData;
        data.layoutOffset = childScrollOffset(lastChildWithScrollOffset!)! +
            paintExtentOf(lastChildWithScrollOffset);
      }
      child.layout(childConstraints, parentUsesSize: true);
      final nextChild = childAfter(child);
      if (nextChild != null) {
        final nextChildData =
            nextChild.parentData! as SliverMultiBoxAdaptorParentData;
        nextChildData.layoutOffset = null;
      }
      return childScrollOffset(child);
    }

    childManager.didStartLayout();
    childManager.setDidUnderflow(false);

    final totalChildCount = childManager.childCount;

    // Scroll offset including cache area.
    final double scrollOffset =
        constraints.scrollOffset + constraints.cacheOrigin;

    // Inflate remaining extent when scrolling from beginning. This is
    // to reduce extent estimation error, which can be large when estimating
    // from first child only.
    final double remainingExtent = math.max(
      constraints.remainingCacheExtent,
      constraints.viewportMainAxisExtent +
          2 * constraints.cacheOrigin -
          constraints.scrollOffset,
    );

    bool addTrailingChild() {
      if (indexOf(lastChild!) < totalChildCount - 1 &&
          (childScrollOffset(lastChild!)! + paintExtentOf(lastChild!) <
              scrollOffset + remainingExtent)) {
        final newLayoutOffset =
            childScrollOffset(lastChild!)! + paintExtentOf(lastChild!);

        final box = insertAndLayoutChild(
          childConstraints,
          after: lastChild,
          parentUsesSize: true,
        );
        if (box == null) {
          return false;
        }
        final data = box.parentData! as SliverMultiBoxAdaptorParentData;
        data.layoutOffset = newLayoutOffset;
        return true;
      } else {
        return false;
      }
    }

    void zeroGeometry() {
      geometry = SliverGeometry.zero;
      childManager.didFinishLayout();
    }

    // There are no children, nothing to estimate extent for. This will create
    // up to 10 initial children. If scrollOffset is 0, these children will be
    // reused later. If scroll extent large, these will likely be scraped in
    // next step, but we should at least be able to estimate jump position.
    if (firstChild == null && _cachedExtent == null) {
      if (!addInitialChild()) {
        return zeroGeometry();
      }
      layoutChild(firstChild!);
      for (var i = 1; i < 10; ++i) {
        if (!addTrailingChild()) {
          break;
        }
      }
    }

    // First go through all children, remove those that are no longer
    // in cache area and layout those that are in the cache area.
    int leadingGarbage = 0;
    int trailingGarbage = 0;
    RenderBox? lastChildWithScrollOffset;

    RenderBox? previousChild;
    int index = firstChild != null ? indexOf(firstChild!) : 0;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      // all items after first trailing garbage are automatically garbage
      if (trailingGarbage > 0) {
        ++trailingGarbage;
      } else {
        if (indexOf(child) != index) {
          final newChild =
              insertAndLayoutChild(childConstraints, after: previousChild);
          // This should not normally happen. If there is GAP between children we should be
          // able to fill it, otherwise it would be an inconsistency in childManager.
          assert(newChild != null, 'Unexpected trailing child.');
          if (newChild == null) {
            ++trailingGarbage;
            continue;
          } else {
            child = newChild;
          }
        }
        final offset = layoutChild(
          child,
          lastChildWithScrollOffset: lastChildWithScrollOffset,
        );
        if (offset == null) {
          // could not determine scroll offset, treat as leading garbage
          ++leadingGarbage;
        } else {
          lastChildWithScrollOffset = child;
          final endOffset = offset + paintExtentOf(child);
          if (offset > scrollOffset + remainingExtent) {
            ++trailingGarbage;
          } else if (endOffset < scrollOffset) {
            ++leadingGarbage;
          }
        }
      }
      previousChild = child;
      ++index;
    }

    // Estimate extent from currently available children. This must be done
    // after children have been laid-out in previous step, but before
    // collecting garbage. It is possible that we'll end-up with no children
    // after collecting garbage but still need to estimate index after jump.
    final extent = _estimateExtent() ?? 0.0;
    if (extent < precisionErrorTolerance) {
      return zeroGeometry();
    }

    collectGarbage(leadingGarbage, trailingGarbage);

    // This sliver is not visible yet. Provide cached extent to be consistent.
    if (constraints.scrollOffset == 0 &&
        constraints.remainingCacheExtent < precisionErrorTolerance) {
      // Remove items added initially to determine average extent. If this
      // Sliver is far away this can get rid of quite a lot of state that would
      // be kept unnecessarily.
      collectGarbage(childCount, 0);
      geometry = SliverGeometry(
        scrollExtent: childManager.childCount * extent,
      );
      return;
    }

    // We're jumping completely over the cache area. All children have been
    // removed.
    if (firstChild == null) {
      if (scrollOffset == 0) {
        if (!addInitialChild()) {
          return zeroGeometry();
        }
        // Layout offset of first child is always 0. No estimation necessary.
        _layoutOffsetIsEstimated = false;
      } else {
        final firstChildInCacheAreaIndex = scrollOffset ~/ extent;

        if (firstChildInCacheAreaIndex >= totalChildCount) {
          // We didn't reach scroll offset. It means user scrolled past this
          // sliver.
          geometry = SliverGeometry(
            maxPaintExtent: totalChildCount * extent,
            scrollExtent: totalChildCount * extent,
          );
          childManager.didFinishLayout();
          return;
        }

        // Put first child at the scroll offset, not the beginning of cache area
        final firstChildScrollOffset = constraints.scrollOffset;
        final firstChildIndex =
            math.min(firstChildScrollOffset ~/ extent, totalChildCount - 1);

        if (!addInitialChild(
          index: firstChildIndex,
          layoutOffset: firstChildIndex * extent,
        )) {
          return zeroGeometry();
        }
        // First child was put to estimated extent
        _layoutOffsetIsEstimated = true;
      }
      firstChild!.layout(childConstraints, parentUsesSize: true);

      // First child added is the last child. In this case align the new child
      // to estimated extent. There may be sliver after this one, in which case
      // we hold on to the estimated extent until user scrolls far enough to
      // remove last child.
      if (indexOf(firstChild!) == totalChildCount - 1) {
        final data = firstChild!.parentData! as SliverMultiBoxAdaptorParentData;
        data.layoutOffset =
            totalChildCount * extent - paintExtentOf(firstChild!);
      }
    }

    // At this point there is at least one child.
    // First we need to create children before current child all the way to the
    // beginning of cached area
    double scrollCorrection = 0;

    while (indexOf(firstChild!) > 0 &&
        childScrollOffset(firstChild!)! > scrollOffset + scrollCorrection) {
      final prevOffset = childScrollOffset(firstChild!)!;
      final box =
          insertAndLayoutLeadingChild(childConstraints, parentUsesSize: true);
      if (box == null) {
        break;
      }
      final data = box.parentData! as SliverMultiBoxAdaptorParentData;
      // Avoid scroll offset correction if layout offset is not estimated
      // or if we're adding from last child, which means the sliver after
      // may be visible.
      if (!_layoutOffsetIsEstimated ||
          indexOf(lastChild!) == totalChildCount - 1) {
        data.layoutOffset = prevOffset - paintExtentOf(box);
      } else {
        data.layoutOffset = prevOffset - extent;
        final double correction = paintExtentOf(box) - extent;
        shiftLayoutOffsets(childAfter(box), correction);
        scrollCorrection += correction;
      }
    }

    // Additional corrections

    // Child is not first but it goes before the very beginning
    if (indexOf(firstChild!) > 0 &&
        childScrollOffset(firstChild!)! < precisionErrorTolerance) {
      _layoutOffsetIsEstimated = true;
      final double correctedOffset = indexOf(firstChild!) * extent;
      final double correction =
          correctedOffset - childScrollOffset(firstChild!)!;
      shiftLayoutOffsets(firstChild, correction);
      scrollCorrection += correction;
    }

    // First child is not at the very beginning
    if (indexOf(firstChild!) == 0 && childScrollOffset(firstChild!)! != 0) {
      final double correction = -childScrollOffset(firstChild!)!;
      shiftLayoutOffsets(firstChild, correction);
      scrollCorrection += correction;
    }

    if (scrollCorrection.abs() > precisionErrorTolerance) {
      if (_estimatedOffset != null) {
        _estimatedOffset = _estimatedOffset! + scrollCorrection;
      }
      geometry = SliverGeometry(scrollOffsetCorrection: scrollCorrection);
      childManager.didFinishLayout();
      return;
    }

    if (indexOf(firstChild!) == 0) {
      assert(childScrollOffset(firstChild!)! == 0);
      _layoutOffsetIsEstimated = false;
    }

    // Add remaining children to fill the cache area
    while (addTrailingChild()) {}

    // Assume this is viewport trying to reveal particular child that was out of
    // cache area originally. We provided estimated offset for the child, but
    // the actual one might be different. If that's the case, correct the
    // position now.
    if (_estimatedOffsetChildIndex != null) {
      for (var c = firstChild; c != null; c = childAfter(c)) {
        if (_estimatedOffsetChildIndex == indexOf(c)) {
          final o = childScrollOffset(c)!;
          if ((o - _estimatedOffset!).abs() > precisionErrorTolerance) {
            geometry =
                SliverGeometry(scrollOffsetCorrection: o - _estimatedOffset!);
            childManager.didFinishLayout();
            _estimatedOffsetChildIndex = null;
            _estimatedOffset = null;
            return;
          }
        }
      }
    }

    // Compute scroll extent.

    var endScrollOffset =
        childScrollOffset(lastChild!)! + paintExtentOf(lastChild!);

    final remainingChildrenCount = totalChildCount - indexOf(lastChild!) - 1;
    endScrollOffset += extent * remainingChildrenCount;

    _estimatedOffsetChildIndex = null;
    _estimatedOffset = null;

    final cacheStart = constraints.scrollOffset + constraints.cacheOrigin;
    final lastChildEnd =
        childScrollOffset(lastChild!)! + paintExtentOf(lastChild!);
    final cacheConsumed = (lastChildEnd - cacheStart)
        .clamp(0.0, constraints.remainingCacheExtent);

    var paintExtent = calculatePaintOffset(
      constraints,
      from: childScrollOffset(firstChild!)!,
      to: endScrollOffset,
    );

    // If remaining paint extent is consumed, make sure to use the *exact* value.
    // Otherwise, even if the delta is extremely small, Flutter will consider
    // next sliver visible, which means that our layoutOffset will be used
    // determine paint position of render boxes inside next sliver (even if
    // invisible these affects directional focus for example). That leads
    // to incorrect results if we're in the middle of sliver.
    if ((constraints.remainingPaintExtent - paintExtent).abs() <
        precisionErrorTolerance) {
      paintExtent = constraints.remainingPaintExtent;
    }

    geometry = SliverGeometry(
      scrollExtent: endScrollOffset,
      paintExtent: paintExtent,
      maxPaintExtent: endScrollOffset,
      cacheExtent: cacheConsumed,
      hasVisualOverflow: endScrollOffset > constraints.remainingPaintExtent,
    );

    if (paintExtent < constraints.remainingPaintExtent) {
      childManager.setDidUnderflow(true);
    }

    childManager.didFinishLayout();
  }
}
