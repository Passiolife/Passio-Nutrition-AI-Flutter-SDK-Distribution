import 'package:flutter/foundation.dart';
import 'package:nutrition_ai/src/models/enums.dart';

/// Native representation of an image.
class PlatformImage {
  /// The width of the image.
  final int width;

  /// The height of the image.
  final int height;

  /// The raw pixel data of the image.
  final Uint8List pixels;

  /// Creates a new `PlatformImage` object.
  const PlatformImage(this.width, this.height, this.pixels);

  /// Creates a `PlatformImage` object from a JSON map.
  factory PlatformImage.fromJson(Map<String, dynamic> json) => PlatformImage(
        json["width"] as int,
        json["height"] as int,
        json["pixels"] as Uint8List,
      );

  /// Compares two `PlatformImage` objects for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PlatformImage) return false;
    return width == other.width &&
        height == other.height &&
        listEquals(pixels, other.pixels);
  }

  /// Calculates the hash code for this `PlatformImage` object.
  @override
  int get hashCode =>
      Object.hash(width, height) ^ Object.hashAllUnordered(pixels);
}

/// Enumeration for icon sizes.
enum IconSize {
  /// Icon size of 90 pixels.
  px90,

  /// Icon size of 180 pixels.
  px180,

  /// Icon size of 360 pixels.
  px360
}

/// Extension on the `IconSize` enum to provide a URL-friendly size string.
extension IconSizeExtension on IconSize {
  /// Returns a URL-friendly string representation of the icon size.
  String get sizeForURL {
    return toString().replaceAll('IconSize.', '').replaceAll('px', '');
  }
}

/// The defaultIcon represents one of five predefined icons shipped with the
/// SDK, base on the food item's [PassioIDEntityType].
///
/// The cachedIcon is a previously downloaded icon for a give food item.
class PassioFoodIcons {
  /// The default icon, which is one of five predefined icons based on the
  /// food item's [PassioIDEntityType].
  final PlatformImage defaultIcon;

  /// A cached icon, which is a previously downloaded icon for a given food item.
  final PlatformImage? cachedIcon;

  /// Creates a new `PassioFoodIcons` object.
  const PassioFoodIcons(
    this.defaultIcon,
    this.cachedIcon,
  );
}
