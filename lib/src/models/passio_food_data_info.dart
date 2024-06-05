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

  /// A unique ID for the search result.
  final String resultId;

  /// The score associated with the search result, potentially indicating its relevance.
  final double score;

  /// The scored name of the food item
  final String scoredName;

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
    required this.resultId,
    required this.scoredName,
    required this.score,
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
        resultId: json['resultId'] as String,
        score: json['score'] as double,
        scoredName: json['scoredName'] as String,
        type: json['type'] as String,
        isShortName: json['isShortName'] as bool,
      );

  /// Converts the `PassioFoodDataInfo` instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'brandName': brandName,
        'foodName': foodName,
        'iconId': iconID,
        'labelId': labelId,
        'nutritionPreview': nutritionPreview.toJson(),
        'resultId': resultId,
        'score': score,
        'scoredName': scoredName,
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
        resultId == other.resultId &&
        score == other.score &&
        scoredName == other.scoredName &&
        type == other.type &&
        isShortName == other.isShortName;
  }

  /// Calculates the hash code for this `PassioFoodDataInfo` object.
  @override
  int get hashCode =>
      brandName.hashCode ^
      foodName.hashCode ^
      iconID.hashCode ^
      labelId.hashCode ^
      nutritionPreview.hashCode ^
      resultId.hashCode ^
      score.hashCode ^
      scoredName.hashCode ^
      type.hashCode ^
      isShortName.hashCode;
}
