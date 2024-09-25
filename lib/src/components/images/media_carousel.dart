// import 'dart:io';

// import 'package:carousel_slider_plus/carousel_slider_plus.dart';
// import 'package:fast_immutable_collections/fast_immutable_collections.dart';
// import 'package:flutter/material.dart' hide CarouselController;

// import '../../core/core.dart';
// import '../../models/models.dart';
// import '../components.dart';

// typedef CarouselImageBuilder = Widget Function(BuildContext, int, File);

// class MediaCarousel extends StatefulWidget {
//   const MediaCarousel({
//     this.controller,
//     required this.carouselOptions,
//     this.imageBuilder = _defaultImageBuilder,
//     required this.fetchers,
//     super.key,
//   });

//   factory MediaCarousel.fromUrls({
//     CarouselControllerPlus? controller,
//     required CarouselOptions carouselOptions,
//     CarouselImageBuilder imageBuilder = _defaultImageBuilder,
//     required IList<(MediaType, String)> urls,
//   }) =>
//       MediaCarousel(
//         controller: controller,
//         carouselOptions: carouselOptions,
//         imageBuilder: imageBuilder,
//         fetchers:
//             urls.map((url) => (url.$1, CachedUrlFileFetcher(url.$2))).toIList(),
//       );

//   factory MediaCarousel.photosOnly({
//     CarouselControllerPlus? controller,
//     required CarouselOptions carouselOptions,
//     CarouselImageBuilder imageBuilder = _defaultImageBuilder,
//     required IList<FileFetcher> photoFetchers,
//   }) =>
//       MediaCarousel(
//         controller: controller,
//         carouselOptions: carouselOptions,
//         imageBuilder: imageBuilder,
//         fetchers: photoFetchers
//             .map((fetcher) => (MediaType.image, fetcher))
//             .toIList(),
//       );

//   factory MediaCarousel.photoUrls({
//     CarouselControllerPlus? controller,
//     required CarouselOptions carouselOptions,
//     CarouselImageBuilder imageBuilder = _defaultImageBuilder,
//     required IList<String> photoUrls,
//   }) =>
//       MediaCarousel(
//         controller: controller,
//         carouselOptions: carouselOptions,
//         imageBuilder: imageBuilder,
//         fetchers: photoUrls
//             .map((url) => (MediaType.image, CachedUrlFileFetcher(url)))
//             .toIList(),
//       );

//   factory MediaCarousel.videosOnly({
//     CarouselControllerPlus? controller,
//     required CarouselOptions carouselOptions,
//     CarouselImageBuilder imageBuilder = _defaultImageBuilder,
//     required IList<FileFetcher> videoFetchers,
//   }) =>
//       MediaCarousel(
//         controller: controller,
//         carouselOptions: carouselOptions,
//         imageBuilder: imageBuilder,
//         fetchers: videoFetchers
//             .map((fetcher) => (MediaType.video, fetcher))
//             .toIList(),
//       );

//   factory MediaCarousel.videoUrls({
//     CarouselControllerPlus? controller,
//     required CarouselOptions carouselOptions,
//     CarouselImageBuilder imageBuilder = _defaultImageBuilder,
//     required IList<String> videoUrls,
//   }) =>
//       MediaCarousel(
//         controller: controller,
//         carouselOptions: carouselOptions,
//         imageBuilder: imageBuilder,
//         fetchers: videoUrls
//             .map((url) => (MediaType.video, CachedUrlFileFetcher(url)))
//             .toIList(),
//       );

//   final CarouselControllerPlus? controller;
//   final CarouselOptions carouselOptions;
//   final CarouselImageBuilder imageBuilder;
//   final IList<(MediaType, FileFetcher)> fetchers;

//   @override
//   State<MediaCarousel> createState() => _MediaCarouselState();
// }

// class _MediaCarouselState extends State<MediaCarousel> {
//   late final _futures = _getFutures();
//   late var _combinedFuture = _combineFutures();

//   List<(MediaType, Future<File?>)> _getFutures() =>
//       widget.fetchers.map((fetcher) => (fetcher.$1, fetcher.$2.get())).toList();

//   Future<List<(MediaType, File?)>> _combineFutures() => Future.wait(
//         _futures.map(
//           (fetcherFuture) =>
//               fetcherFuture.$2.then((file) => (fetcherFuture.$1, file)),
//         ),
//       );

//   @override
//   void didUpdateWidget(MediaCarousel oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.fetchers != widget.fetchers) {
//       for (final fetcher in widget.fetchers.asMap().entries) {
//         final value = fetcher.value;
//         if (value != oldWidget.fetchers.elementAtOrNull(fetcher.key)) {
//           final newFuture = (value.$1, value.$2.get());
//           if (_futures.length > fetcher.key) {
//             _futures[fetcher.key] = newFuture;
//           } else {
//             _futures.add(newFuture);
//           }
//         }
//       }
//       setState(() {
//         _combinedFuture = _combineFutures();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _combinedFuture,
//       builder: (context, snapshot) {
//         final list = snapshot.data ?? const [];

//         return CarouselSlider.builder(
//           controller: widget.controller,
//           options: widget.carouselOptions,
//           itemCount: list.length,
//           itemBuilder: (context, index, pageIndex) {
//             final file = list.elementAtOrNull(index);
//             return file != null && file.$2 != null
//                 ? widget.imageBuilder(context, index, file.$2!)
//                 : const Center(child: CircularProgressIndicator.adaptive());
//           },
//         );
//       },
//     );
//   }
// }

// Widget _defaultImageBuilder(BuildContext context, int index, File file) =>
//     RoundedImage.fromFile(file, fit: BoxFit.cover);
