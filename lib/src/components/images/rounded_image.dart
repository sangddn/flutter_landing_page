import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';

import '../../core/core.dart';
import '../components.dart';

typedef ImageBuilder = Widget Function(BuildContext context, Widget child);

sealed class RoundedImage extends StatelessWidget {
  const RoundedImage({
    this.borderRadius = 30.0,
    this.borderSide = BorderSide.none,
    this.fit,
    this.placeholderBuilder,
    this.errorBuilder,
    this.aspectRatio,
    this.blurhash,
    this.resizer,
    this.elevation = -1.0,
    this.imageBuilder,
    super.key,
  });

  const factory RoundedImage.fromUrl(
    String imageUrl, {
    double borderRadius,
    BoxFit fit,
    WidgetBuilder? placeholderBuilder,
    WidgetBuilder? errorBuilder,
    double? aspectRatio,
    String blurhash,
    BorderSide borderSide,
    ImageResizer? resizer,
    double elevation,
    ImageBuilder? imageBuilder,
    Key? key,
  }) = _RoundedImageFromUrl;

  const factory RoundedImage.fromAsset(
    UiAsset assetPath, {
    double borderRadius,
    BoxFit fit,
    WidgetBuilder? placeholderBuilder,
    WidgetBuilder? errorBuilder,
    double? aspectRatio,
    String blurhash,
    BorderSide borderSide,
    ImageResizer? resizer,
    double elevation,
    ImageBuilder? imageBuilder,
    Key? key,
  }) = _RoundedImageFromAsset;

  const factory RoundedImage.fromBytes(
    Uint8List bytes, {
    double borderRadius,
    BoxFit fit,
    WidgetBuilder? placeholderBuilder,
    WidgetBuilder? errorBuilder,
    double? aspectRatio,
    String blurhash,
    BorderSide borderSide,
    ImageResizer resizer,
    double elevation,
    ImageBuilder imageBuilder,
    Key? key,
  }) = _RoundedImageFromBytes;

  const factory RoundedImage.fromFile(
    File file, {
    double borderRadius,
    BoxFit fit,
    WidgetBuilder? placeholderBuilder,
    WidgetBuilder? errorBuilder,
    double aspectRatio,
    String blurhash,
    BorderSide borderSide,
    ImageResizer resizer,
    double elevation,
    ImageBuilder imageBuilder,
    Key? key,
  }) = _RoundedImageFromFile;

  final double borderRadius;
  final BorderSide borderSide;
  final BoxFit? fit;
  final WidgetBuilder? placeholderBuilder;
  final WidgetBuilder? errorBuilder;
  final double? aspectRatio;
  final String? blurhash;
  final ImageResizer? resizer;
  final double elevation;
  final ImageBuilder? imageBuilder;

  ImageProvider getImageProvider(BuildContext context);
  String get cacheKey;

  @override
  Widget build(BuildContext context) {
    final defaultBlurhash = PColors.defaultBlurhash(context);
    final imageProvider = getImageProvider(context);
    final resizedProvider = resizer != null
        ? resizer!.resizeIfNeeded(context, imageProvider)
        : imageProvider;

    final image = OctoImage(
      image: resizedProvider,
      fit: fit ?? BoxFit.cover,
      fadeInDuration: PEffects.longDuration,
      fadeOutDuration: PEffects.mediumDuration,
      placeholderFadeInDuration: PEffects.veryShortDuration,
      fadeInCurve: Curves.ease,
      fadeOutCurve: PEffects.engagingCurve,
      // gaplessPlayback: true,
      placeholderBuilder: blurhash != null
          ? (_) => BlurhashPlaceholder(
                (blurhash?.isNotEmpty ?? false) ? blurhash! : defaultBlurhash,
              )
          : (placeholderBuilder ??
              (context) => Container(
                    decoration: ShapeDecoration(
                      shape: PContinuousRectangleBorder(
                        cornerRadius: borderRadius,
                      ),
                      color: PColors.gray.resolveFrom(context),
                    ),
                  )),
      errorBuilder: (context, error, stackTrace) => blurhash != null
          ? Image(
              image: BlurHashImage(blurhash ?? defaultBlurhash),
              fit: BoxFit.cover,
            )
          : errorBuilder?.call(context) ??
              placeholderBuilder?.call(context) ??
              Container(
                decoration: ShapeDecoration(
                  shape: PContinuousRectangleBorder(cornerRadius: borderRadius),
                  color: PColors.gray.resolveFrom(context),
                ),
              ),
      imageBuilder: imageBuilder,
    );

    final withAspectRatio = aspectRatio != null
        ? AspectRatio(
            aspectRatio: aspectRatio!,
            child: image,
          )
        : image;

    final clipped = ClipPath(
      clipper: ShapeBorderClipper(
        shape: PContinuousRectangleBorder(
          cornerRadius: borderRadius,
        ),
      ),
      child: withAspectRatio,
    );

    final correctedBorderRadius = borderRadius + borderSide.width - 0.75;

    if (elevation <= 0.0) {
      return AnimatedContainer(
        duration: PEffects.shortDuration,
        curve: Curves.ease,
        decoration: ShapeDecoration(
          shape: PContinuousRectangleBorder(
            cornerRadius: correctedBorderRadius,
            side: borderSide,
          ),
        ),
        child: clipped,
      );
    }

    return ColorElevatedWidget(
      cacheKey: cacheKey,
      shape: PContinuousRectangleBorder(
        cornerRadius: borderRadius,
        side: borderSide,
      ),
      imageProvider: resizedProvider,
      elevation: elevation,
      child: clipped,
    );
  }
}

class _RoundedImageFromUrl extends RoundedImage {
  const _RoundedImageFromUrl(
    this.imageUrl, {
    super.borderRadius = 30.0,
    super.fit,
    super.placeholderBuilder,
    super.errorBuilder,
    super.aspectRatio,
    super.blurhash,
    super.borderSide = BorderSide.none,
    super.resizer,
    super.elevation = -1.0,
    super.imageBuilder,
    super.key,
  });

  final String imageUrl;

  @override
  String get cacheKey => imageUrl;

  @override
  ImageProvider<Object> getImageProvider(BuildContext context) {
    return CachedNetworkImageProvider(
      imageUrl,
      cacheKey: imageUrl,
      errorListener: (_) {},
    );
  }
}

class _RoundedImageFromBytes extends RoundedImage {
  const _RoundedImageFromBytes(
    this.bytes, {
    super.borderRadius = 30.0,
    super.fit,
    super.placeholderBuilder,
    super.errorBuilder,
    super.aspectRatio,
    super.blurhash,
    super.borderSide = BorderSide.none,
    super.resizer,
    super.elevation = -1.0,
    super.imageBuilder,
    super.key,
  });

  final Uint8List bytes;

  @override
  String get cacheKey => bytes.hashCode.toString();

  @override
  ImageProvider<Object> getImageProvider(BuildContext context) {
    return MemoryImage(bytes) as ImageProvider;
  }
}

class _RoundedImageFromFile extends RoundedImage {
  const _RoundedImageFromFile(
    this.file, {
    super.borderRadius = 30.0,
    super.fit,
    super.placeholderBuilder,
    super.errorBuilder,
    super.aspectRatio,
    super.blurhash,
    super.borderSide = BorderSide.none,
    super.resizer,
    super.elevation = -1.0,
    super.imageBuilder,
    super.key,
  });

  final File file;

  @override
  String get cacheKey => file.path;

  @override
  ImageProvider<Object> getImageProvider(BuildContext context) {
    return FileImage(file) as ImageProvider;
  }
}

class _RoundedImageFromAsset extends RoundedImage {
  const _RoundedImageFromAsset(
    this.asset, {
    super.borderRadius,
    super.fit,
    super.placeholderBuilder,
    super.errorBuilder,
    super.aspectRatio,
    super.blurhash,
    super.borderSide = BorderSide.none,
    super.resizer,
    super.elevation = -1.0,
    super.imageBuilder,
    super.key,
  });

  final UiAsset asset;

  @override
  String get cacheKey => asset.path;

  @override
  ImageProvider<Object> getImageProvider(BuildContext context) {
    return asset.toImageProvider();
  }
}

class ImageResizer {
  const ImageResizer([this.cachedWidth, this.cachedHeight]);

  final double? cachedWidth;
  final double? cachedHeight;

  ImageProvider resizeIfNeeded(
    BuildContext context,
    ImageProvider imageProvider,
  ) {
    final pixelDensity = MediaQuery.maybeDevicePixelRatioOf(context) ?? 1.0;
    final width = cachedWidth != null ? cachedWidth! * pixelDensity : null;
    final height = cachedHeight != null ? cachedHeight! * pixelDensity : null;
    final widthInt = width == double.infinity ? null : width?.toInt();
    final heightInt = height == double.infinity ? null : height?.toInt();
    try {
      return ResizeImage(
        imageProvider,
        width: widthInt,
        height: heightInt,
        policy: ResizeImagePolicy.fit,
      );
    } on TimeoutException {
      return imageProvider;
    }
  }
}

extension ShortSize on ({double w, double h}) {
  double get aspectRatio => w / h;
  Size get size => Size(w, h);
}

extension ImageResizing on ImageProvider {
  ImageProvider resizeIfNeeded(
    BuildContext context,
    double? cachedWidth,
    double? cachedHeight,
  ) {
    final resizer = ImageResizer(cachedWidth, cachedHeight);
    return resizer.resizeIfNeeded(context, this);
  }
}

class BlurhashPlaceholder extends StatelessWidget {
  const BlurhashPlaceholder(
    this.blurhash, {
    this.fit,
    super.key,
  });

  final String blurhash;
  final BoxFit? fit;

  static Widget icon({
    required String hash,
    required IconData icon,
    BoxFit? fit,
    double? iconSize,
    Color? iconColor,
    Widget? message,
  }) {
    final icon_ = Icon(
      icon,
      size: iconSize,
      color: iconColor,
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        BlurhashPlaceholder(
          hash,
          fit: fit,
        ),
        Opacity(
          opacity: 0.75,
          child: icon_,
        ),
        if (message != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: message,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image(
        image: BlurHashImage(blurhash),
        fit: fit ?? BoxFit.cover,
      ),
    );
  }
}

/// A widget that elevates its child with a color that is derived from the
/// given [ImageProvider].
///
/// The color is derived using the [ColorUtils.getVibrantColors] method.
///
class ColorElevatedWidget extends StatefulWidget {
  const ColorElevatedWidget({
    this.computationDelay = PEffects.shortDuration,
    this.offsetFactor = 1.0,
    this.offsetDelta = Offset.zero,
    this.onElevationColorObtained,
    required this.cacheKey,
    required this.shape,
    required this.imageProvider,
    required this.elevation,
    required this.child,
    super.key,
  });

  final Duration computationDelay;
  final double offsetFactor;
  final Offset offsetDelta;
  final ValueChanged<ProminentColors>? onElevationColorObtained;
  final String cacheKey;
  final ShapeBorder shape;
  final ImageProvider imageProvider;
  final double elevation;
  final Widget child;

  @override
  State<ColorElevatedWidget> createState() => _ColorElevatedWidgetState();
}

class _ColorElevatedWidgetState extends State<ColorElevatedWidget> {
  late var _prominentColorFuture = widget.elevation <= 0.0
      ? Future<ProminentColors?>.value()
      : _getProminentColor();

  Future<ProminentColors> _getProminentColor() async => Future.delayed(
        widget.computationDelay,
        () => ColorUtils.getVibrantColors(
          widget.imageProvider,
          widget.cacheKey,
        ),
      ).then((value) {
        widget.onElevationColorObtained?.call(value);
        return value;
      });

  @override
  void didUpdateWidget(ColorElevatedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageProvider != widget.imageProvider ||
        (widget.elevation > 0.0 && oldWidget.elevation <= 0.0)) {
      setState(() {
        _prominentColorFuture = _getProminentColor();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _prominentColorFuture,
      builder: (context, snapshot) {
        final theme = Theme.of(context);
        final colors = snapshot.data;
        final shadow = theme.resolveColor(
          colors?.dark.adaptForLightMode() ?? Colors.black,
          colors?.dark.adaptForDarkMode() ?? Colors.black,
        );
        return AnimatedContainer(
          duration: PEffects.shortDuration,
          curve: Curves.ease,
          decoration: ShapeDecoration(
            shape: widget.shape,
            shadows: PDecors.focusedShadows(
              baseColor: shadow,
              offsetFactor: widget.offsetFactor,
              offsetDelta: widget.offsetDelta,
              elevation: widget.elevation,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: widget.child,
        );
      },
    );
  }
}
