import 'package:flutter/foundation.dart';
import 'package:nutrition_ai/src/converter/platform_output_converter.dart';

import '../nutrition_ai_detection.dart';
import 'passio_search_nutrition_preview.dart';

/// A class representing detailed information about a food item.
class PassioFoodDataInfo {
  /// The brand name of the food item.
  final String brandName;

  /// The name of the food item.
  final String foodName;

  /// The ID of the icon associated with the food item.
  final PassioID iconID;

  /// The ID of the food label.
  final String labelId;

  /// A preview of the nutritional information for the food item.
  final PassioSearchNutritionPreview nutritionPreview;

  /// A reference code serving as a unique identifier for the food item.
  final String refCode;

  /// A unique ID for the search result.
  final String resultId;

  /// The score associated with the search result, potentially indicating its relevance.
  final double score;

  /// The scored name of the food item
  final String scoredName;

  /// A list of tags associated with the food item
  final List<String>? tags;

  /// The type of food item.
  final String type;

  /// Whether to use a short name for the food item.
  final bool isShortName;

  /// Creates a new instance of `PassioFoodDataInfo`.
  const PassioFoodDataInfo({
    required this.brandName,
    required this.foodName,
    required this.iconID,
    required this.labelId,
    required this.nutritionPreview,
    required this.refCode,
    required this.resultId,
    required this.scoredName,
    required this.score,
    required this.tags,
    required this.type,
    required this.isShortName,
  });

  /// Creates a `PassioFoodDataInfo` instance from a JSON map.
  factory PassioFoodDataInfo.fromJson(Map<String, dynamic> json) =>
      PassioFoodDataInfo(
        brandName: json['brandName'] as String,
        foodName: json['foodName'] as String,
        iconID: json['iconID'],
        labelId: json['labelId'] as String,
        nutritionPreview: PassioSearchNutritionPreview.fromJson(
            (json['nutritionPreview'] as Map<Object?, Object?>)
                .cast<String, dynamic>()),
        refCode: json['refCode'] as String,
        resultId: json['resultId'] as String,
        score: json['score'] as double,
        scoredName: json['scoredName'] as String,
        tags: mapDynamicListToListOfString(json["tags"]),
        type: json['type'] as String,
        isShortName: json['isShortName'] as bool,
      );

  /// Converts the `PassioFoodDataInfo` instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'brandName': brandName,
        'foodName': foodName,
        'iconID': iconID,
        'labelId': labelId,
        'nutritionPreview': nutritionPreview.toJson(),
        'refCode': refCode,
        'resultId': resultId,
        'score': score,
        'scoredName': scoredName,
        'tags': tags,
        'type': type,
        'isShortName': isShortName,
      };

  /// Compares two `PassioFoodDataInfo` objects for equality.
  @override
  bool operator ==(Object other) {
    if (other is! PassioFoodDataInfo) return false;
    if (identical(this, other)) return true;

    return brandName == other.brandName &&
        foodName == other.foodName &&
        iconID == other.iconID &&
        labelId == other.labelId &&
        nutritionPreview == other.nutritionPreview &&
        refCode == other.refCode &&
        resultId == other.resultId &&
        score == other.score &&
        scoredName == other.scoredName &&
        type == other.type &&
        isShortName == other.isShortName &&
        listEquals(tags, other.tags);
  }

  /// Calculates the hash code for this `PassioFoodDataInfo` object.
  @override
  int get hashCode =>
      brandName.hashCode ^
      foodName.hashCode ^
      iconID.hashCode ^
      labelId.hashCode ^
      nutritionPreview.hashCode ^
      refCode.hashCode ^
      resultId.hashCode ^
      score.hashCode ^
      scoredName.hashCode ^
      type.hashCode ^
      isShortName.hashCode ^
      Object.hashAllUnordered(tags ?? const []);
}
