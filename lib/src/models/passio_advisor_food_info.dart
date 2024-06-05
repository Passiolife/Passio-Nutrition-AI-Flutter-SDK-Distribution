import 'passio_food_data_info.dart';

/// Represents information about a food item recognized by the Passio Advisor.
///
/// This class contains details about the food item, including its data info,
/// portion size, recognized name, and weight in grams.
class PassioAdvisorFoodInfo {
  /// Detailed information about the food item.
  final PassioFoodDataInfo? foodDataInfo;

  /// The portion size of the food item.
  final String portionSize;

  /// The recognised name of the food item.
  final String recognisedName;

  /// The weight of the food item in grams.
  final double weightGrams;

  /// Creates a new instance of `PassioAdvisorFoodInfo`.
  const PassioAdvisorFoodInfo({
    this.foodDataInfo,
    required this.portionSize,
    required this.recognisedName,
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
        portionSize: json['portionSize'] as String,
        recognisedName: json['recognisedName'] as String,
        weightGrams: json['weightGrams'] as double,
      );

  /// Converts the `PassioAdvisorFoodInfo` instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'foodDataInfo': foodDataInfo?.toJson(),
        'portionSize': portionSize,
        'recognisedName': recognisedName,
        'weightGrams': weightGrams,
      };

  /// Compares two `PassioAdvisorFoodInfo` objects for equality.
  @override
  bool operator ==(Object other) {
    if (other is! PassioAdvisorFoodInfo) return false;
    if (identical(this, other)) return true;

    return foodDataInfo == other.foodDataInfo &&
        portionSize == other.portionSize &&
        recognisedName == other.recognisedName &&
        weightGrams == other.weightGrams;
  }

  /// Calculates the hash code for this `PassioAdvisorFoodInfo` object.
  @override
  int get hashCode => Object.hash(
        foodDataInfo,
        portionSize,
        recognisedName,
        weightGrams,
      );
}
