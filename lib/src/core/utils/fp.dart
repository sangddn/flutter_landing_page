import 'dart:async';
import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

extension FuncMap<T> on T {
  R let<R>(R Function(T t) fn) => fn(this);
  R? maybeLet<R>(R Function(T t)? fn) => fn?.call(this);
  T swapIf(bool Function(T) test, T val) => test(this) ? val : this;
}

extension FunctionalString on String {
  String swapIfEmpty(String val) => isEmpty ? val : this;
}

extension ListPrototypedGeneration<T> on T {
  Iterable<R> prototypedGenerate<R>(
    int length,
    R Function(T prototype, int index) fn,
  ) sync* {
    for (var i = 0; i < length; i++) {
      yield fn(this, i);
    }
  }

  Iterable<T> waterfallGenerate(
    int length,
    T Function(T prototype, int index) fn,
  ) sync* {
    var prototype = this;
    for (var i = 0; i < length; i++) {
      yield prototype = fn(prototype, i);
    }
  }
}

extension MinMax<T extends Comparable<T>> on Iterable<T> {
  T? minOrNull() {
    if (isEmpty) {
      return null;
    }
    return reduce(
      (value, element) => value.compareTo(element) < 0 ? value : element,
    );
  }

  T? maxOrNull() {
    if (isEmpty) {
      return null;
    }
    return reduce(
      (value, element) => value.compareTo(element) > 0 ? value : element,
    );
  }
}

extension MinMax2<T> on Iterable<T> {
  T? minOrNull(double Function(T, T) compare) {
    if (isEmpty) {
      return null;
    }
    return reduce(
      (value, element) => compare(value, element) < 0 ? value : element,
    );
  }

  T? maxOrNull(double Function(T, T) compare) {
    if (isEmpty) {
      return null;
    }
    return reduce(
      (value, element) => compare(value, element) > 0 ? value : element,
    );
  }
}

extension MinMaxFunc<T> on Iterable<T> {
  T minMap<R>(R Function(T) func, bool Function(R, R) compare) {
    return reduce(
      (value, element) => compare(func(value), func(element)) ? value : element,
    );
  }

  T maxMap<R>(R Function(T) func, bool Function(R, R) compare) {
    return reduce(
      (value, element) => compare(func(value), func(element)) ? element : value,
    );
  }

  T? minMapOrNull<R>(R Function(T) func, bool Function(R, R) compare) {
    if (isEmpty) {
      return null;
    }
    return minMap(func, compare);
  }

  T? maxMapOrNull<R>(R Function(T) func, bool Function(R, R) compare) {
    if (isEmpty) {
      return null;
    }
    return maxMap(func, compare);
  }
}

extension Enumerate<T> on Iterable<T> {
  Iterable<T> startWith(T element) sync* {
    yield element;
    yield* this;
  }

  Iterable<T> maybeStartWith(T? element) sync* {
    if (element != null) {
      yield element;
    }
    yield* this;
  }
  
  List<R> mapToList<R>(R Function(int index, T item) fn) {
    return indexedMap(fn).toList();
  }

  Iterable<(int, T)> enumerate() sync* {
    var i = 0;
    for (final item in this) {
      yield (i, item);
      i++;
    }
  }

  Iterable<R> indexedMap<R>(R Function(int index, T item) func) sync* {
    var i = 0;
    for (final item in this) {
      yield func(i, item);
      i++;
    }
  }

  Iterable<R> indexedExpand<R>(
    Iterable<R> Function(int index, T item) func,
  ) sync* {
    var i = 0;
    for (final item in this) {
      yield* func(i, item);
      i++;
    }
  }

  /// Returns a new iterable of iterables that are the size of [n], except
  /// for the last iterable which may be smaller.
  ///
  Iterable<Iterable<T>> mapEveryN(int n) sync* {
    var i = 0;
    var current = <T>[];
    for (final item in this) {
      current.add(item);
      i++;
      if (i == n) {
        yield current;
        current = <T>[];
        i = 0;
      }
    }
    if (current.isNotEmpty) {
      yield current;
    }
  }

  /// Interleaving the elements of two iterables.
  ///
  /// Example:
  /// ```dart
  /// final a = [1, 2, 3];
  /// final b = ['a', 'b', 'c'];
  /// final result = a.interleave(b);
  /// print(result); // [1, 'a', 2, 'b', 3, 'c']
  /// ```
  ///
  Iterable<T> interleave(Iterable<T> other) sync* {
    final a = iterator;
    final b = other.iterator;
    while (a.moveNext() && b.moveNext()) {
      yield a.current;
      yield b.current;
    }
  }

  /// An indexed version of [Iterable.where].
  /// The [test] function is applied to each element along with its index.
  /// The resulting iterable consists of all elements for which the [test]
  /// function returned true.
  ///
  /// Example:
  /// ```dart
  /// final list = [1, 2, 3, 4, 5];
  /// final result = list.whereIndexed((index, value) => index.isEven);
  /// print(result); // [1, 3, 5]
  ///
  Iterable<T> indexedWhere(bool Function(int index, T value) test) sync* {
    var i = 0;
    for (final item in this) {
      if (test(i, item)) {
        yield item;
      }
      i++;
    }
  }

  /// A version of [indexedWhere] that returns an iterable along with the index.
  ///
  /// Example:
  /// ```dart
  /// final list = [1, 2, 3, 4, 5];
  /// final result = list.indexedWhereWithIndex((index, value) => index.isEven);
  /// print(result); // [(0, 1), (2, 3), (4, 5)]
  ///
  Iterable<(int, T)> indexedWhereWithIndex(
    bool Function(int index, T value) test,
  ) sync* {
    var i = 0;
    for (final item in this) {
      if (test(i, item)) {
        yield (i, item);
      }
      i++;
    }
  }

  /// A version of [Iterable.where] that returns an iterable along with the index.
  ///
  /// Example:
  /// ```dart
  /// final list = [1, 2, 3, 4, 5];
  /// final result = list.whereWithIndex((value) => value.isEven);
  /// print(result); // [(0, 2), (1, 4)]
  /// ```
  ///
  Iterable<(int, T)> whereWithIndex(bool Function(T value) test) sync* {
    var i = 0;
    for (final item in this) {
      if (test(item)) {
        yield (i, item);
      }
      i++;
    }
  }

  /// Reverse the order of the elements in the iterable on a condition.
  ///
  Iterable<T> reverseIf(bool condition) {
    return condition ? toList().reversed : this;
  }

  ///
  ///
  Iterable<R> mapSeparated<R>(
    R Function(int index, T value) fn,
    R Function(int indexBefore, T value) separator,
  ) sync* {
    var i = 0;
    for (final item in this) {
      if (i != 0) {
        yield separator(i - 1, item);
      }
      yield fn(i, item);
      i++;
    }
  }

  ///
  ///
  Iterable<R> whereSameType<R extends T>(bool Function(T value) test) sync* {
    for (final item in this) {
      if (test(item)) {
        yield item as R;
      }
    }
  }

  /// Returns the first index of an element that satisfies the [test] function.
  ///
  /// Returns -1 if no element satisfies the [test] function.
  ///
  int whereFirstIndex(bool Function(T value) test) {
    var i = 0;
    for (final item in this) {
      if (test(item)) {
        return i;
      }
      i++;
    }
    return -1;
  }

  T? maybeReduce(T Function(T, T) combine) {
    if (isEmpty) {
      return null;
    }
    return reduce(combine);
  }

  void forEachIndexed(void Function(int index, T value) fn) {
    var i = 0;
    for (final item in this) {
      fn(i, item);
      i++;
    }
  }
}

Iterable<(T, R)> zip<T, R>(Iterable<T> a, Iterable<R> b) sync* {
  final aIterator = a.iterator;
  final bIterator = b.iterator;
  while (aIterator.moveNext() && bIterator.moveNext()) {
    yield (aIterator.current, bIterator.current);
  }
}

Iterable<(T, R, S)> zip3<T, R, S>(
  Iterable<T> a,
  Iterable<R> b,
  Iterable<S> c,
) sync* {
  final aIterator = a.iterator;
  final bIterator = b.iterator;
  final cIterator = c.iterator;
  while (aIterator.moveNext() && bIterator.moveNext() && cIterator.moveNext()) {
    yield (aIterator.current, bIterator.current, cIterator.current);
  }
}

/// Returns an iterable that combines the elements of multiple iterables.
/// 
/// Process:
/// A = [1, 2, 3, ...]
/// B = [a, b, c, ...]
/// -> [1, a, 2, b, 3, c, ...]
/// 
/// If any of the iterables are exhausted, the resulting iterable will continue
/// with the remaining elements of the other iterables until all are exhausted.
/// 
Iterable<T> combine<T>(List<Iterable<T>> iterables) sync* {
  final iterators = iterables.map((iterable) => iterable.iterator).toList();
  while (true) {
    var hasMore = false;
    for (var i = 0; i < iterables.length; i++) {
      if (iterators[i].moveNext()) {
        yield iterators[i].current;
        hasMore = true;
      }
    }
    if (!hasMore) {
      break;
    }
  }
}

extension MapTests<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } on StateError {
      return null;
    }
  }

  /// Returns the [where]-th element that satisfies the [test] function.
  /// 
  /// [where] is zero-indexed and must be non-negative.
  /// 
  /// If there are fewer than `where + 1` elements that satisfy the [test] 
  /// function, returns null.
  /// 
  T? whereOrNull(int where, bool Function(T) test) {
    assert (where >= 0);
    var i = 0;
    for (final item in this) {
      if (test(item)) {
        if (i == where) {
          return item;
        }
        i++;
      }
    }
    return null;
  }

  T? lastWhereOrNull(bool Function(T) test) {
    try {
      return lastWhere(test);
    } on StateError {
      return null;
    }
  }

  T? singleWhereOrNull(bool Function(T) test) {
    try {
      return singleWhere(test);
    } on StateError {
      return null;
    }
  }
}

extension FunctionalTests<K, V> on Map<K, V> {
  void retainWhere(bool Function(K, V) test) {
    final toRemove = <K>{};
    for (final entry in entries) {
      if (!test(entry.key, entry.value)) {
        toRemove.add(entry.key);
      }
    }
    removeWhere((key, value) => toRemove.contains(key));
  }

  void keep(Iterable<K> keys) {
    retainWhere((key, _) => keys.contains(key));
  }
}

extension IMapX<K,V> on IMap<K, V> {
  IMap<K, V> retainWhere(bool Function(K, V) test) {
    final toRemove = <K>{};
    for (final entry in entries) {
      if (!test(entry.key, entry.value)) {
        toRemove.add(entry.key);
      }
    }
    return removeWhere((key, value) => toRemove.contains(key));
  }

  IMap<K, V> keep(Iterable<K> keys) {
    return retainWhere((key, _) => keys.contains(key));
  }
}

extension MapKeyComparison<K extends Comparable<K>, V> on Map<K, V> {
  Map<K, V> sortedByKey() {
    final sortedKeys = keys.toList()..sort();
    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, this[key] as V)),
    );
  }

  Map<K, V> sortedByKeyDescending() {
    final sortedKeys = keys.toList()..sort((a, b) => b.compareTo(a));
    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, this[key] as V)),
    );
  }

  Map<K, V> sortedByKeyWith(Comparator<K> compare) {
    final sortedKeys = keys.toList()..sort(compare);
    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, this[key] as V)),
    );
  }

  Map<K, V> sortedByKeyWithDescending(Comparator<K> compare) {
    final sortedKeys = keys.toList()..sort((a, b) => compare(b, a));
    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, this[key] as V)),
    );
  }

  MapEntry<K, V> maxKey() {
    final max = keys.reduce(
      (value, element) => value.compareTo(element) > 0 ? value : element,
    );
    return MapEntry(max, this[max] as V);
  }

  MapEntry<K, V> minKey() {
    final min = keys.reduce(
      (value, element) => value.compareTo(element) < 0 ? value : element,
    );
    return MapEntry(min, this[min] as V);
  }
}

extension MapValueComparison<K, V extends Comparable<V>> on Map<K, V> {
  Map<K, V> sortedByValue() {
    final sortedEntries = entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return Map.fromEntries(sortedEntries);
  }

  Map<K, V> sortedByValueDescending() {
    final sortedEntries = entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sortedEntries);
  }

  Map<K, V> sortedByValueWith(Comparator<V> compare) {
    final sortedEntries = entries.toList()
      ..sort((a, b) => compare(a.value, b.value));
    return Map.fromEntries(sortedEntries);
  }

  Map<K, V> sortedByValueWithDescending(Comparator<V> compare) {
    final sortedEntries = entries.toList()
      ..sort((a, b) => compare(b.value, a.value));
    return Map.fromEntries(sortedEntries);
  }

  MapEntry<K, V> maxValue() {
    if (isEmpty) {
      throw StateError('Map is empty');
    }
    final max = values.reduce(
      (value, element) => value.compareTo(element) > 0 ? value : element,
    );
    return entries.firstWhere((entry) => entry.value == max);
  }

  MapEntry<K, V> minValue() {
    final min = values.reduce(
      (value, element) => value.compareTo(element) < 0 ? value : element,
    );
    return entries.firstWhere((entry) => entry.value == min);
  }

  MapEntry<K, V>? maybeMaxValue() {
    if (isEmpty) {
      return null;
    }
    return maxValue();
  }

  MapEntry<K, V>? maybeMinValue() {
    if (isEmpty) {
      return null;
    }
    return minValue();
  }
}

extension MapToList<K, V> on Map<K, V> {
  Iterable<(K, V)> where(bool Function(K, V) test) sync* {
    for (final entry in entries) {
      if (test(entry.key, entry.value)) {
        yield (entry.key, entry.value);
      }
    }
  }

  (K, V) firstWhere(bool Function(K, V) test) {
    for (final entry in entries) {
      if (test(entry.key, entry.value)) {
        return (entry.key, entry.value);
      }
    }
    throw StateError('No element');
  }

  (K, V) lastWhere(bool Function(K, V) test) {
    for (final entry in entries.toList().reversed) {
      if (test(entry.key, entry.value)) {
        return (entry.key, entry.value);
      }
    }
    throw StateError('No element');
  }

  (K, V) singleWhere(bool Function(K, V) test) {
    var found = false;
    (K, V)? result;
    for (final entry in entries) {
      if (test(entry.key, entry.value)) {
        if (found) {
          throw StateError('More than one element');
        }
        found = true;
        result = (entry.key, entry.value);
      }
    }
    if (!found) {
      throw StateError('No element');
    }
    return result!;
  }

  (K, V)? firstWhereOrNull(bool Function(K, V) test) {
    for (final entry in entries) {
      if (test(entry.key, entry.value)) {
        return (entry.key, entry.value);
      }
    }
    return null;
  }

  (K, V)? lastWhereOrNull(bool Function(K, V) test) {
    for (final entry in entries.toList().reversed) {
      if (test(entry.key, entry.value)) {
        return (entry.key, entry.value);
      }
    }
    return null;
  }

  Iterable<R> mapIter<R>(R Function(K, V) fn) {
    return entries.map((entry) => fn(entry.key, entry.value));
  }

  Iterable<(K, V)> asIterable() sync* {
    for (final entry in entries) {
      yield (entry.key, entry.value);
    }
  }
}

extension ListsX<T> on List<T> {
  bool containsAny(Iterable<T> elements) {
    for (final element in elements) {
      if (contains(element)) {
        return true;
      }
    }
    return false;
  }

  bool containsAll(Iterable<T> elements) {
    for (final element in elements) {
      if (!contains(element)) {
        return false;
      }
    }
    return true;
  }

  /// Returns the index of the first appearance of [element] in the list,
  /// assuming the list is one-indexed.
  ///
  /// Returns -1 if the element is not found.
  ///
  int oneIndexOf(T element) {
    final zeroIndex = indexOf(element);
    if (zeroIndex == -1) {
      return -1;
    }
    return zeroIndex + 1;
  }
}

extension IterableX<T> on Iterable<T> {
  Iterable<T> takeIf(int count, bool condition) =>
      condition ? take(count) : this;

  Iterable<T> takeUntil(bool Function(T) condition) sync* {
    for (final element in this) {
      if (condition(element)) {
        break;
      }
      yield element;
    }
  }

  Iterable<T> takeWhere(int count, bool Function(T) condition) sync* {
    var i = 0;
    for (final element in this) {
      if (condition(element)) {
        yield element;
        i++;
        if (i == count) {
          break;
        }
      }
    }
  }

  Iterable<T> takeUnique(int count) {
    final seen = <T>{};
    return where((element) {
      if (seen.contains(element)) {
        return false;
      }
      seen.add(element);
      return true;
    }).take(count);
  }

  Map<R, List<T>> groupBy<R>(R Function(T) keyFn) {
    final map = <R, List<T>>{};
    for (final element in this) {
      final key = keyFn(element);
      if (!map.containsKey(key)) {
        map[key] = <T>[];
      }
      map[key]!.add(element);
    }
    return map;
  }

  Iterable<T> addAllBetween(Iterable<T> betweens) sync* {
    if (isEmpty) {
      return;
    }
    if (length == 1) {
      yield first;
      return;
    }
    for (final element in this) {
      yield element;
      if (betweens.isNotEmpty) {
        yield betweens.first;
        betweens = betweens.skip(1);
      }
    }
  }

  Iterable<T> addBetween(T between) sync* {
    for (final element in this) {
      yield element;
      yield between;
    }
  }

  Iterable<T> addBetweenIf(
    T between,
    bool Function(T previous, T after) condition,
  ) sync* {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return;
    }
    var previous = iterator.current;
    while (iterator.moveNext()) {
      final current = iterator.current;
      yield previous;
      if (condition(previous, current)) {
        yield between;
      }
      previous = current;
    }
    yield previous;
  }

  Iterable<T> separate(T Function(T) fn) sync* {
    for (final element in this) {
      yield element;
      yield fn(element);
    }
  }

  Iterable<T> separateMultiple(Iterable<T> Function(T) fn) sync* {
    for (final element in this) {
      yield element;
      yield* fn(element);
    }
  }
}

extension ListX<T> on List<T> {
  Iterable<T> loopStartAt(int index) sync* {
    for (var i = index; i < length; i++) {
      yield this[i];
    }
    for (var i = 0; i < index; i++) {
      yield this[i];
    }
  }
}

extension TupleX2<T, R> on (T?, R?) {
  S? mapNonNull<S>(S Function(T, R) fn) =>
      $1 is Object && $2 is Object ? fn($1 as T, $2 as R) : null;
}

extension FlatMap<T> on Iterable<Iterable<T>> {
  Iterable<R> mapFlat<R>(R Function(T) fn) {
    return expand((element) => element.map(fn));
  }
}

extension ToMap<V> on Iterable<V> {
  Map<K, V> mapVal<K>(K Function(V) keyFn) {
    return Map.fromEntries(map((e) => MapEntry(keyFn(e), e)));
  }
}

extension ToMap2<K> on Iterable<K> {
  Map<K, V> mapKey<V>(V Function(K) valueFn) {
    return Map.fromEntries(map((e) => MapEntry(e, valueFn(e))));
  }
}

class CombineAnyLatestStream<T, R> extends StreamView<R> {
  CombineAnyLatestStream(
    Iterable<Stream<T>> streams,
    R Function(List<T?>) combiner,
  ) : super(_buildController(streams, combiner).stream);

  /// Constructs a [CombineAnyLatestStream] from a pair of [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineAnyLatestStream<dynamic, R> combine2<A, B, R>(
    Stream<A> streamOne,
    Stream<B> streamTwo,
    R Function(A a, B b) combiner,
  ) =>
      CombineAnyLatestStream<dynamic, R>(
        [streamOne, streamTwo],
        (List<dynamic> values) => combiner(values[0] as A, values[1] as B),
      );

  /// Constructs a [CombineAnyLatestStream] from 3 [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineAnyLatestStream<dynamic, R> combine3<A, B, C, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    R Function(A a, B b, C c) combiner,
  ) =>
      CombineAnyLatestStream<dynamic, R>(
        [streamA, streamB, streamC],
        (List<dynamic> values) {
          return combiner(
            values[0] as A,
            values[1] as B,
            values[2] as C,
          );
        },
      );

  /// Constructs a [CombineAnyLatestStream] from 4 [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineAnyLatestStream<dynamic, R> combine4<A, B, C, D, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    Stream<D> streamD,
    R Function(A a, B b, C c, D d) combiner,
  ) =>
      CombineAnyLatestStream<dynamic, R>(
        [streamA, streamB, streamC, streamD],
        (List<dynamic> values) {
          return combiner(
            values[0] as A,
            values[1] as B,
            values[2] as C,
            values[3] as D,
          );
        },
      );

  /// Constructs a [CombineAnyLatestStream] from 5 [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineAnyLatestStream<dynamic, R> combine5<A, B, C, D, E, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    Stream<D> streamD,
    Stream<E> streamE,
    R Function(A a, B b, C c, D d, E e) combiner,
  ) =>
      CombineAnyLatestStream<dynamic, R>(
        [streamA, streamB, streamC, streamD, streamE],
        (List<dynamic> values) {
          return combiner(
            values[0] as A,
            values[1] as B,
            values[2] as C,
            values[3] as D,
            values[4] as E,
          );
        },
      );

  /// Constructs a [CombineAnyLatestStream] from 6 [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineAnyLatestStream<dynamic, R> combine6<A, B, C, D, E, F, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    Stream<D> streamD,
    Stream<E> streamE,
    Stream<F> streamF,
    R Function(A a, B b, C c, D d, E e, F f) combiner,
  ) =>
      CombineAnyLatestStream<dynamic, R>(
        [streamA, streamB, streamC, streamD, streamE, streamF],
        (List<dynamic> values) {
          return combiner(
            values[0] as A,
            values[1] as B,
            values[2] as C,
            values[3] as D,
            values[4] as E,
            values[5] as F,
          );
        },
      );

  /// Constructs a [CombineAnyLatestStream] from 7 [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineAnyLatestStream<dynamic, R> combine7<A, B, C, D, E, F, G, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    Stream<D> streamD,
    Stream<E> streamE,
    Stream<F> streamF,
    Stream<G> streamG,
    R Function(A a, B b, C c, D d, E e, F f, G g) combiner,
  ) =>
      CombineAnyLatestStream<dynamic, R>(
        [streamA, streamB, streamC, streamD, streamE, streamF, streamG],
        (List<dynamic> values) {
          return combiner(
            values[0] as A,
            values[1] as B,
            values[2] as C,
            values[3] as D,
            values[4] as E,
            values[5] as F,
            values[6] as G,
          );
        },
      );

  /// Constructs a [CombineAnyLatestStream] from 8 [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineAnyLatestStream<dynamic, R> combine8<A, B, C, D, E, F, G, H, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    Stream<D> streamD,
    Stream<E> streamE,
    Stream<F> streamF,
    Stream<G> streamG,
    Stream<H> streamH,
    R Function(A a, B b, C c, D d, E e, F f, G g, H h) combiner,
  ) =>
      CombineAnyLatestStream<dynamic, R>(
        [
          streamA,
          streamB,
          streamC,
          streamD,
          streamE,
          streamF,
          streamG,
          streamH,
        ],
        (List<dynamic> values) {
          return combiner(
            values[0] as A,
            values[1] as B,
            values[2] as C,
            values[3] as D,
            values[4] as E,
            values[5] as F,
            values[6] as G,
            values[7] as H,
          );
        },
      );

  /// Constructs a [CombineAnyLatestStream] from 9 [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineAnyLatestStream<dynamic, R>
      combine9<A, B, C, D, E, F, G, H, I, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    Stream<D> streamD,
    Stream<E> streamE,
    Stream<F> streamF,
    Stream<G> streamG,
    Stream<H> streamH,
    Stream<I> streamI,
    R Function(A a, B b, C c, D d, E e, F f, G g, H h, I i) combiner,
  ) =>
          CombineAnyLatestStream<dynamic, R>(
            [
              streamA,
              streamB,
              streamC,
              streamD,
              streamE,
              streamF,
              streamG,
              streamH,
              streamI,
            ],
            (List<dynamic> values) {
              return combiner(
                values[0] as A,
                values[1] as B,
                values[2] as C,
                values[3] as D,
                values[4] as E,
                values[5] as F,
                values[6] as G,
                values[7] as H,
                values[8] as I,
              );
            },
          );

  static StreamController<R> _buildController<T, R>(
    Iterable<Stream<T>> streams,
    R Function(List<T?> values) combiner,
  ) {
    int completed = 0;

    late List<StreamSubscription<T>> subscriptions;
    List<T?>? values;

    final controller = StreamController<R>(sync: true);

    controller.onListen = () {
      void onDone() {
        if (++completed == streams.length) {
          controller.close();
        }
      }

      subscriptions = streams.indexedMap((index, stream) {
        return stream.listen(
          (T event) {
            final R combined;

            if (values == null) {
              return;
            }

            values![index] = event;

            try {
              combined = combiner(List<T?>.unmodifiable(values!));
            } catch (e, s) {
              controller.addError(e, s);
              return;
            }

            controller.add(combined);
          },
          onError: controller.addError,
          onDone: onDone,
        );
      }).toList(growable: false);

      if (subscriptions.isEmpty) {
        controller.close();
      } else {
        values = List<T?>.filled(subscriptions.length, null);
      }
    };

    controller.onPause = () => subscriptions.map((e) => e.pause());
    controller.onResume = () => subscriptions.map((e) => e.resume());
    // ignore: void_checks
    controller.onCancel = () {
      values = null;
      return subscriptions.map((e) => e.cancel());
    };

    return controller;
  }
}

extension RandomElement<T> on Iterable<T> {
  T randomElement([int? seed, Set<T>? except]) {
    final random = seed != null ? Random(seed) : Random();
    final list = except != null
        ? (toList()..removeWhere((ele) => except.contains(ele)))
        : toList();
    return list[random.nextInt(list.length)];
  }

  Iterable<T> randomSubset(int size, [int? seed]) {
    return (toList()..shuffle(seed != null ? Random(seed) : null)).take(size);
  }
}

extension PrependStream<T> on Stream<T> {
  Stream<T> prepend(T value) async* {
    yield value;
    yield* this;
  }
}
