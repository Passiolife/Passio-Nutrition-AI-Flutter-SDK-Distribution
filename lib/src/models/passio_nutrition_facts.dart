/// A class representing the nutritional facts of a food item.
class PassioNutritionFacts {
  /// The amount of added sugar.
  final double? addedSugar;

  /// The amount of calcium.
  final double? calcium;

  /// The number of calories.
  final double? calories;

  /// The amount of carbohydrates.
  final double? carbs;

  /// The amount of cholesterol.
  final double? cholesterol;

  /// The amount of dietary fiber.
  final double? dietaryFiber;

  /// The amount of fat.
  final double? fat;

  /// The ingredients list as a string.
  final String? ingredients;

  /// The amount of iron.
  final double? iron;

  /// The amount of potassium.
  final double? potassium;

  /// The amount of protein.
  final double? protein;

  /// The amount of saturated fat.
  final double? saturatedFat;

  /// The quantity of the serving size.
  final double? servingQuantity;

  /// The unit name of the serving size.
  final String? servingUnit;

  /// The quantity of the weight.
  final double? weightQuantity;

  /// The unit of the weight.
  final String? weightUnit;

  /// The amount of sodium.
  final double? sodium;

  /// The amount of sugar alcohol.
  final double? sugarAlcohol;

  /// The total amount of sugars.
  final double? sugars;

  /// The amount of total sugars.
  final double? totalSugars;

  /// The amount of transFat.
  final double? transFat;

  /// The amount of vitamin D.
  final double? vitaminD;

  /// Creates a new instance of `PassioNutritionFacts`.
  const PassioNutritionFacts({
    this.addedSugar,
    this.calcium,
    this.calories,
    this.carbs,
    this.cholesterol,
    this.dietaryFiber,
    this.fat,
    this.ingredients,
    this.iron,
    this.potassium,
    this.protein,
    this.saturatedFat,
    this.servingQuantity,
    this.servingUnit,
    this.weightQuantity,
    this.weightUnit,
    this.sodium,
    this.sugarAlcohol,
    this.sugars,
    this.totalSugars,
    this.transFat,
    this.vitaminD,
  });

  /// Creates a `PassioNutritionFacts` instance from a JSON map.
  factory PassioNutritionFacts.fromJson(Map<String, dynamic> json) =>
      PassioNutritionFacts(
        addedSugar: json['addedSugar'] as double?,
        calcium: json['calcium'] as double?,
        calories: json['calories'] as double?,
        carbs: json['carbs'] as double?,
        cholesterol: json['cholesterol'] as double?,
        dietaryFiber: json['dietaryFiber'] as double?,
        fat: json['fat'] as double?,
        ingredients: json['ingredients'] as String?,
        iron: json['iron'] as double?,
        potassium: json['potassium'] as double?,
        protein: json['protein'] as double?,
        saturatedFat: json['saturatedFat'] as double?,
        servingQuantity: json['servingQuantity'] as double?,
        servingUnit: json['servingUnit'] as String?,
        weightQuantity: json['weightQuantity'] as double?,
        weightUnit: json['weightUnit'] as String?,
        sodium: json['sodium'] as double?,
        sugarAlcohol: json['sugarAlcohol'] as double?,
        sugars: json['sugars'] as double?,
        totalSugars: json['totalSugars'] as double?,
        transFat: json['transFat'] as double?,
        vitaminD: json['vitaminD'] as double?,
      );

  /// Converts the `PassioNutritionFacts` instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'addedSugar': addedSugar,
        'calcium': calcium,
        'calories': calories,
        'carbs': carbs,
        'cholesterol': cholesterol,
        'dietaryFiber': dietaryFiber,
        'fat': fat,
        'ingredients': ingredients,
        'iron': iron,
        'potassium': potassium,
        'protein': protein,
        'saturatedFat': saturatedFat,
        'servingQuantity': servingQuantity,
        'servingUnit': servingUnit,
        'weightQuantity': weightQuantity,
        'weightUnit': weightUnit,
        'sodium': sodium,
        'sugarAlcohol': sugarAlcohol,
        'sugars': sugars,
        'totalSugars': totalSugars,
        'transFat': transFat,
        'vitaminD': vitaminD,
      };

  /// Compares two `PassioNutritionFacts` objects for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PassioNutritionFacts) return false;

    return addedSugar == other.addedSugar &&
        calcium == other.calcium &&
        calories == other.calories &&
        carbs == other.carbs &&
        cholesterol == other.cholesterol &&
        dietaryFiber == other.dietaryFiber &&
        fat == other.fat &&
        ingredients == other.ingredients &&
        iron == other.iron &&
        potassium == other.potassium &&
        protein == other.protein &&
        saturatedFat == other.saturatedFat &&
        servingQuantity == other.servingQuantity &&
        servingUnit == other.servingUnit &&
        weightQuantity == other.weightQuantity &&
        weightUnit == other.weightUnit &&
        sodium == other.sodium &&
        sugarAlcohol == other.sugarAlcohol &&
        sugars == other.sugars &&
        totalSugars == other.totalSugars &&
        transFat == other.transFat &&
        vitaminD == other.vitaminD;
  }

  /// Calculates the hash code for this `PassioNutritionFacts` object.
  @override
  int get hashCode {
    return Object.hashAll(
      [
        addedSugar,
        calcium,
        calories,
        carbs,
        cholesterol,
        dietaryFiber,
        fat,
        ingredients,
        iron,
        potassium,
        protein,
        saturatedFat,
        servingQuantity,
        servingUnit,
        weightQuantity,
        weightUnit,
        sodium,
        sugarAlcohol,
        sugars,
        totalSugars,
        transFat,
        vitaminD,
      ],
    );
  }
}
