import 'package:nutrition_ai/src/models/enums.dart';
import 'package:nutrition_ai/src/models/passio_food_item.dart';

import 'passio_food_data_info.dart';

/// Represents information about a food item recognized by the Passio Advisor.
///
/// This class contains details about the food item, including its data info,
/// portion size, recognized name, and weight in grams.
class PassioAdvisorFoodInfo {
  /// Detailed information about the food item.
  final PassioFoodDataInfo? foodDataInfo;

  /// Contains detailed information about the packaged food item, including nutrition facts and barcode data.
  final PassioFoodItem? packagedFoodItem;

  /// The portion size of the food item.
  final String portionSize;

  /// The type of result returned from the food recognition process.
  /// It can indicate if the result is a recognized food item, barcode, or nutrition facts.
  final PassioFoodResultType resultType;

  /// The recognised name of the food item.
  final String recognisedName;

  /// The weight of the food item in grams.
  final double weightGrams;

  /// Creates a new instance of `PassioAdvisorFoodInfo`.
  const PassioAdvisorFoodInfo({
    this.foodDataInfo,
    this.packagedFoodItem,
    required this.portionSize,
    required this.recognisedName,
    required this.resultType,
    required this.weightGrams,
  });

  /// Creates a `PassioAdvisorFoodInfo` instance from a JSON map.
  factory PassioAdvisorFoodInfo.fromJson(Map<String, dynamic> json) =>
      PassioAdvisorFoodInfo(
        foodDataInfo: json['foodDataInfo'] != null
            ? PassioFoodDataInfo.fromJson(
                (json['foodDataInfo'] as Map<Object?, Object?>)
                    .cast<String, dynamic>())
            : null,
        packagedFoodItem: json['packagedFoodItem'] != null
            ? PassioFoodItem.fromJson(
                (json['packagedFoodItem'] as Map<Object?, Object?>)
                    .cast<String, dynamic>())
            : null,
        portionSize: json['portionSize'] as String,
        resultType: PassioFoodResultType.values.byName(json['resultType']),
        recognisedName: json['recognisedName'] as String,
        weightGrams: json['weightGrams'] as double,
      );

  /// Converts the `PassioAdvisorFoodInfo` instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'foodDataInfo': foodDataInfo?.toJson(),
        'packagedFoodItem': packagedFoodItem,
        'portionSize': portionSize,
        'resultType': resultType.name,
        'recognisedName': recognisedName,
        'weightGrams': weightGrams,
      };

  /// Compares two `PassioAdvisorFoodInfo` objects for equality.
  @override
  bool operator ==(Object other) {
    if (other is! PassioAdvisorFoodInfo) return false;
    if (identical(this, other)) return true;

    return foodDataInfo == other.foodDataInfo &&
        packagedFoodItem == other.packagedFoodItem &&
        portionSize == other.portionSize &&
        resultType == other.resultType &&
        recognisedName == other.recognisedName &&
        weightGrams == other.weightGrams;
  }

  /// Calculates the hash code for this `PassioAdvisorFoodInfo` object.
  @override
  int get hashCode => Object.hash(
        foodDataInfo,
        packagedFoodItem,
        portionSize,
        resultType,
        recognisedName,
        weightGrams,
      );
}
