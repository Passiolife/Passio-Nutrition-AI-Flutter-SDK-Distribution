import 'package:flutter/foundation.dart';

import '../converter/platform_output_converter.dart';
import '../nutrition_ai_detection.dart';
import 'passio_food_origin.dart';

/// Represents metadata associated with a particular food item.
class PassioFoodMetadata {
  /// The barcode of the food item.
  final Barcode? barcode;

  /// A list of origins of the food item.
  final List<PassioFoodOrigin>? foodOrigins;

  /// A description of the ingredients in the food item.
  final String? ingredientsDescription;

  /// A list of tags associated with the food item.
  final List<String>? tags;

  /// Creates a new `PassioFoodMetadata` instance.
  const PassioFoodMetadata({
    this.barcode,
    this.foodOrigins,
    this.ingredientsDescription,
    this.tags,
  });

  String? openFoodLicense() {
    return foodOrigins
        ?.cast<PassioFoodOrigin?>()
        .firstWhere((element) => element?.source == 'openfood',
            orElse: () => null)
        ?.licenseCopy;
  }

  /// Creates a `PassioFoodMetadata` instance from a JSON map.
  factory PassioFoodMetadata.fromJson(Map<String, dynamic> json) =>
      PassioFoodMetadata(
        barcode: json["barcode"],
        ingredientsDescription: json["ingredientsDescription"],
        foodOrigins: mapListOfObjectsOptional(
            json["foodOrigins"], PassioFoodOrigin.fromJson),
        tags: mapDynamicListToListOfString(json["tags"]),
      );

  /// Converts the `PassioFoodMetadata` instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'barcode': barcode,
        'ingredientsDescription': ingredientsDescription,
        'foodOrigins': foodOrigins?.map((e) => e.toJson()).toList(),
        'tags': tags,
      };

  /// Compares two `PassioFoodMetadata` objects for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PassioFoodMetadata) return false;
    return barcode == other.barcode &&
        listEquals(foodOrigins, other.foodOrigins) &&
        ingredientsDescription == other.ingredientsDescription &&
        listEquals(tags, other.tags);
  }

  /// Calculates the hash code for this `PassioFoodMetadata` object.
  @override
  int get hashCode =>
      barcode.hashCode ^
      Object.hashAllUnordered(foodOrigins ?? const []) ^
      ingredientsDescription.hashCode ^
      Object.hashAllUnordered(tags ?? const []);
}
