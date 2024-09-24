part of 'ui.dart';

/// The base class for all features.
///
sealed class Feature {
  const Feature({
    required this.name,
    required this.description,
    required this.versionIntroduced,
    required this.showcaseDescription,
    this.assets,
  });

  /// The name of this feature.
  ///
  final String name;

  /// The description for this feature.
  ///
  /// Should be short and sweet.
  ///
  final String description;

  /// The long description for this feature, used to showcase the feature.
  ///
  final String showcaseDescription;

  /// The icon for this feature.
  ///
  /// This is used to showcase the feature in various places.
  /// See [TipTour].
  ///
  Widget get icon;

  /// The assets for this feature.
  ///
  /// This is used to showcase the feature in various places.
  /// See [TipTour].
  ///
  final FeatureAssets? assets;

  /// The version of the app in which this feature was introduced.
  ///
  /// This is used to determine whether or not to show the feature to the user
  /// on a "What's New" dialog and to organize the features on "Features" page.
  ///
  final String versionIntroduced;

  bool get isPro => this is ProFeature;
  bool get isFree => this is! ProFeature;
}

/// The base class for all pro features.
///
/// Pro features are features that require the user to upgrade to a pro plan
/// in order to use them.
///
sealed class ProFeature extends Feature {
  const ProFeature({
    required super.name,
    required super.description,
    super.assets,
    required super.versionIntroduced,
    required this.upgradeTitle,
    required super.showcaseDescription,
    required this.upgradeCta,
  });

  /// The title to be used in paywall.
  ///
  final String upgradeTitle;

  /// The call to action to be used in paywall.
  ///
  final String upgradeCta;
}

typedef FeatureImage = ({String light, String dark});
typedef FeatureVideo = ({String light, String dark});
typedef FeatureImages = ({FeatureImage narrow, FeatureImage wide});
typedef FeatureVideos = ({FeatureVideo narrow, FeatureVideo wide});

sealed class FeatureAssets {
  const FeatureAssets({
    required this.ios,
    required this.android,
    required this.web,
    required this.macos,
    this.iosVideo,
    this.androidVideo,
    this.webVideo,
    this.macosVideo,
  });

  final FeatureImages ios;
  final FeatureImages android;
  final FeatureImages web;
  final FeatureImages macos;
  final FeatureVideos? iosVideo;
  final FeatureVideos? androidVideo;
  final FeatureVideos? webVideo;
  final FeatureVideos? macosVideo;
}
