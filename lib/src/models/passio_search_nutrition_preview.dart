/// Represents a preview of the nutritional information for a food item,
class PassioSearchNutritionPreview {
  /// The number of calories in the specified serving size.
  final int calories;

  /// The amount of carbohydrates.
  final double carbs;

  /// The amount of fat.
  final double fat;

  /// The amount of protein.
  final double protein;

  /// The amount of fiber.
  final double fiber;

  /// The quantity of the serving size (e.g., 1.5, 100).
  final double servingQuantity;

  /// The unit of measurement for the serving size (e.g., "cup", "gram").
  final String servingUnit;

  /// The weight of the serving size as a quantity.
  final double weightQuantity;

  /// The unit of measurement for the weight of the serving size (e.g., "gram").
  final String weightUnit;

  /// Creates a new instance of `PassioSearchNutritionPreview`.
  const PassioSearchNutritionPreview({
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
    required this.fiber,
    required this.servingQuantity,
    required this.servingUnit,
    required this.weightQuantity,
    required this.weightUnit,
  });

  /// Creates a new instance of `PassioSearchNutritionPreview` from a JSON map.
  factory PassioSearchNutritionPreview.fromJson(Map<String, dynamic> json) {
    return PassioSearchNutritionPreview(
      calories: json['calories'] as int,
      carbs: json['carbs'] as double,
      fat: json['fat'] as double,
      protein: json['protein'] as double,
      fiber: json['fiber'] as double,
      servingUnit: json['servingUnit'] as String,
      servingQuantity: json['servingQuantity'] as double,
      weightUnit: json['weightUnit'],
      weightQuantity: json['weightQuantity'],
    );
  }

  /// Converts the `PassioSearchNutritionPreview` object to a JSON map.
  Map<String, dynamic> toJson() => {
        'calories': calories,
        'carbs': carbs,
        'fat': fat,
        'protein': protein,
        'fiber': fiber,
        'servingUnit': servingUnit,
        'servingQuantity': servingQuantity,
        'weightUnit': weightUnit,
        'weightQuantity': weightQuantity,
      };

  /// Compares two `PassioSearchNutritionPreview` objects for equality.
  @override
  bool operator ==(Object other) {
    if (other is! PassioSearchNutritionPreview) return false;
    if (identical(this, other)) return true;

    return calories == other.calories &&
        carbs == other.carbs &&
        fat == other.fat &&
        protein == other.protein &&
        fiber == other.fiber &&
        servingUnit == other.servingUnit &&
        servingQuantity == other.servingQuantity &&
        weightUnit == other.weightUnit &&
        weightQuantity == other.weightQuantity;
  }

  /// Calculates the hash code for this `PassioSearchNutritionPreview` object.
  @override
  int get hashCode {
    return calories.hashCode ^
        carbs.hashCode ^
        fat.hashCode ^
        protein.hashCode ^
        fiber.hashCode ^
        servingUnit.hashCode ^
        servingQuantity.hashCode ^
        weightUnit.hashCode ^
        weightQuantity.hashCode;
  }
}
