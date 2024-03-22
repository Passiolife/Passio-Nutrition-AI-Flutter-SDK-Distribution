import '../nutrition_ai_detection.dart';
import 'passio_search_nutrition_preview.dart';

class PassioSearchResult {
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

  /// Creates a new instance of `PassioSearchResponse`.
  const PassioSearchResult({
    required this.brandName,
    required this.foodName,
    required this.iconID,
    required this.labelId,
    required this.nutritionPreview,
    required this.resultId,
    required this.scoredName,
    required this.score,
    required this.type,
  });

  /// Creates a `PassioSearchResult` instance from a JSON map.
  factory PassioSearchResult.fromJson(Map<String, dynamic> json) =>
      PassioSearchResult(
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
      );

  /// Converts the `PassioSearchResult` instance to a JSON map.
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
      };

  /// Compares two `PassioSearchResult` objects for equality.
  @override
  bool operator ==(Object other) {
    if (other is! PassioSearchResult) return false;
    if (identical(this, other)) return true;

    return brandName == other.brandName &&
        foodName == other.foodName &&
        iconID == other.iconID &&
        labelId == other.labelId &&
        nutritionPreview == other.nutritionPreview &&
        resultId == other.resultId &&
        score == other.score &&
        scoredName == other.scoredName &&
        type == other.type;
  }

  /// Calculates the hash code for this `PassioSearchResult` object.
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
      type.hashCode;
}
