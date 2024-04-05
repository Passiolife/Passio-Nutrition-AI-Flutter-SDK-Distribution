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

enum IconSize { px90, px180, px360 }

extension IconSizeExtension on IconSize {
  String get sizeForURL {
    return toString().replaceAll('IconSize.', '').replaceAll('px', '');
  }
}

/// The defaultIcon represents one of five predefined icons shipped with the
/// SDK, base on the food item's [PassioIDEntityType].
///
/// The cachedIcon is a previously downloaded icon for a give food item.
class PassioFoodIcons {
  final PlatformImage defaultIcon;
  final PlatformImage? cachedIcon;

  PassioFoodIcons(this.defaultIcon, this.cachedIcon);
}
