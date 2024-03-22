/// Represents a preview of the nutritional information for a food item,
class PassioSearchNutritionPreview {
  /// The number of calories in the specified serving size.
  final int calories;

  /// The unit of measurement for the serving size (e.g., "cup", "gram").
  final String servingUnit;

  /// The quantity of the serving size (e.g., 1.5, 100).
  final double servingQuantity;

  /// The weight of the serving size as a string (e.g., "1.5 cups", "100 grams").
  final String servingWeight;

  /// Creates a new instance of `PassioSearchNutritionPreview`.
  const PassioSearchNutritionPreview({
    required this.calories,
    required this.servingUnit,
    required this.servingQuantity,
    required this.servingWeight,
  });

  /// Creates a new instance of `PassioSearchNutritionPreview` from a JSON map.
  factory PassioSearchNutritionPreview.fromJson(Map<String, dynamic> json) {
    return PassioSearchNutritionPreview(
      calories: json['calories'] as int,
      servingUnit: json['servingUnit'] as String,
      servingQuantity: json['servingQuantity'] as double,
      servingWeight: json['servingWeight'] as String,
    );
  }

  /// Converts the `PassioSearchNutritionPreview` object to a JSON map.
  Map<String, dynamic> toJson() => {
        'calories': calories,
        'servingUnit': servingUnit,
        'servingQuantity': servingQuantity,
        'servingWeight': servingWeight,
      };

  /// Compares two `PassioSearchNutritionPreview` objects for equality.
  @override
  bool operator ==(Object other) {
    if (other is! PassioSearchNutritionPreview) return false;
    if (identical(this, other)) return true;

    return calories == other.calories &&
        servingUnit == other.servingUnit &&
        servingQuantity == other.servingQuantity &&
        servingWeight == other.servingWeight;
  }

  /// Calculates the hash code for this `PassioSearchNutritionPreview` object.
  @override
  int get hashCode {
    return calories.hashCode ^
        servingUnit.hashCode ^
        servingQuantity.hashCode ^
        servingWeight.hashCode;
  }
}
