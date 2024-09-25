// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import 'package:provider/provider.dart';

// import '../../core/core.dart';
// import '../components.dart';

// class FlyPhotoDeck extends StatefulWidget {
//   const FlyPhotoDeck({
//     this.leadingWidget,
//     this.height = 100.0,
//     this.width = 100.0,
//     this.cardOffset = const Offset(15, 0),
//     this.cardScale = 0.9,
//     this.dismissThreshold = 30,
//     this.padding = const EdgeInsets.all(8.0),
//     this.onSwipe,
//     this.boxShadows,
//     this.borderRadius = 16.0,
//     required this.photoFetchers,
//     super.key,
//   });

//   factory FlyPhotoDeck.fromUrls({
//     required List<String> photoUrls,
//     Widget? leadingWidget,
//     double height = 100.0,
//     double width = 100.0,
//     Offset cardOffset = const Offset(15, 0),
//     double cardScale = 0.9,
//     int dismissThreshold = 30,
//     EdgeInsetsGeometry? padding,
//     void Function(int newTopmostIndex)? onSwipe,
//     List<BoxShadow>? boxShadows,
//     double borderRadius = 16.0,
//   }) =>
//       FlyPhotoDeck(
//         photoFetchers:
//             photoUrls.map((url) => CachedUrlFileFetcher(url)).toList(),
//         leadingWidget: leadingWidget,
//         height: height,
//         width: width,
//         cardOffset: cardOffset,
//         cardScale: cardScale,
//         dismissThreshold: dismissThreshold,
//         padding: padding,
//         onSwipe: onSwipe,
//         boxShadows: boxShadows,
//         borderRadius: borderRadius,
//       );

//   final List<FileFetcher> photoFetchers;
//   final Widget? leadingWidget;
//   final double height;
//   final double width;
//   final Offset cardOffset;
//   final double cardScale;
//   final int dismissThreshold;
//   final EdgeInsetsGeometry? padding;
//   final void Function(int newTopmostIndex)? onSwipe;
//   final List<BoxShadow>? boxShadows;
//   final double borderRadius;

//   @override
//   State<FlyPhotoDeck> createState() => _FlyPhotoDeckState();
// }

// class _FlyPhotoDeckState extends State<FlyPhotoDeck> {
//   late final _keys = List.generate(_cardsCount, (_) => GlobalKey());
//   late var _photoFutures =
//       widget.photoFetchers.map((fetcher) => fetcher.get()).toList();
//   int _currentTopmostIndex = 0;
//   late var _cardsCount = _setCardCount();

//   int _setCardCount() =>
//       widget.photoFetchers.length + (widget.leadingWidget != null ? 1 : 0);
//   List<Future<File?>> _getFutures() =>
//       widget.photoFetchers.map((fetcher) => fetcher.get()).toList();

//   @override
//   void initState() {
//     super.initState();
//     _photoFutures = _getFutures();
//   }

//   @override
//   void didUpdateWidget(FlyPhotoDeck oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (!listEquals(oldWidget.photoFetchers, widget.photoFetchers)) {
//       _photoFutures = _getFutures();
//     }
//     if (oldWidget.leadingWidget != widget.leadingWidget) {
//       _cardsCount = _setCardCount();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<(int, int)>.value(value: (_cardsCount, _currentTopmostIndex)),
//         Provider<double>.value(value: widget.borderRadius),
//         Provider<Widget?>.value(value: widget.leadingWidget),
//         Provider<List<BoxShadow>?>.value(value: widget.boxShadows),
//         Provider<List<Future<File?>>>.value(value: _photoFutures),
//       ],
//       child: SizedBox(
//         height: widget.height,
//         width: widget.width,
//         child: CardSwiper(
//           numberOfCardsDisplayed: min(3, _cardsCount),
//           cardsCount: _cardsCount,
//           scale: widget.cardScale,
//           backCardOffset: widget.cardOffset,
//           padding: widget.padding ?? EdgeInsets.zero,
//           threshold: widget.dismissThreshold,
//           onSwipe: (index, _, __) {
//             setState(() {
//               _currentTopmostIndex = (index + 1) % _cardsCount;
//             });
//             widget.onSwipe?.call(_currentTopmostIndex);
//             return true;
//           },
//           cardBuilder: (_, index, __, ___) => Provider<int>.value(
//             key: _keys[index],
//             value: index,
//             child: const _FutureCard()
//                 .animate()
//                 .fadeIn()
//                 .scaleXY(begin: 0.0, end: 1.0, curve: Curves.easeOutBack),
//           ),
//         ),
//       ),
//     );
//   }
// }

// extension _CardContext on BuildContext {
//   int topMostIndex() => select(((int, int) v) => v.$2);
//   int cardsCount() => select(((int, int) v) => v.$1);
//   int index() => watch<int>();
//   double borderRadius() => watch<double>();
//   Widget? leadingWidget() => watch<Widget?>();
//   List<BoxShadow>? boxShadows() => watch<List<BoxShadow>?>();
//   Future<File?> fileFuture() {
//     final index = this.index();
//     final leading = leadingWidget();
//     return select(
//       (List<Future<File?>> v) =>
//           leading != null ? v.elementAt(index - 1) : v.elementAt(index),
//     );
//   }
// }

// class _FutureCard extends StatelessWidget {
//   const _FutureCard();

//   @override
//   Widget build(BuildContext context) {
//     final future = context.fileFuture();
//     return FutureProvider<File?>.value(
//       initialData: null,
//       value: future,
//       child: const _Card(),
//     );
//   }
// }

// class _Card extends StatelessWidget {
//   const _Card();

//   double _tilt(BuildContext context, int absoluteIndex) =>
//       (absoluteIndex >= context.topMostIndex()
//           ? absoluteIndex - context.topMostIndex()
//           : ((absoluteIndex + context.cardsCount() + 1) -
//               context.topMostIndex())) /
//       45;

//   @override
//   Widget build(BuildContext context) {
//     final index = context.index();
//     final data = context.watch<File?>();
//     final child = data == null
//         ? ContainerFadeShimmer(radius: context.borderRadius())
//         : RoundedImage.fromFile(
//             data,
//             placeholderBuilder: (context) => ContainerFadeShimmer(
//               radius: context.borderRadius(),
//             ),
//             borderRadius: context.borderRadius(),
//           );
//     return AnimatedRotation(
//       turns: _tilt(context, index),
//       duration: PEffects.veryShortDuration,
//       curve: Curves.easeInOut,
//       child: (index == 0 && context.leadingWidget() != null)
//           ? context.leadingWidget()!
//           : DecoratedBox(
//               decoration: ShapeDecoration(
//                 shape: PContinuousRectangleBorder(
//                   cornerRadius: context.borderRadius(),
//                 ),
//                 shadows: context.boxShadows() ??
//                     const <BoxShadow>[
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 10.0,
//                         offset: Offset(4.0, 8.0),
//                       ),
//                       // BoxShadow(
//                       //   color: Colors.white10,
//                       //   blurRadius: 10.0,
//                       // ),
//                     ],
//               ),
//               child: child,
//             ),
//     );
//   }
// }
