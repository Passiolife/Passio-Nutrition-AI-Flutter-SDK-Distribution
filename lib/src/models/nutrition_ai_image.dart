import 'package:flutter/foundation.dart';
import 'nutrition_ai_attributes.dart';

/// Native representation of an image.
class PlatformImage {
  final int width;
  final int height;
  final Uint8List pixels;

  PlatformImage(this.width, this.height, this.pixels);
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
